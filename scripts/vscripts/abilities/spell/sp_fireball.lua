LinkLuaModifier("modifier_sp_fireball_thinker", "abilities/spell/sp_fireball.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_fireball == nil then
	sp_fireball = class({}, nil, sp_base)
end
function sp_fireball:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_fireball:OnSpellStart()
	local hCaster = self:GetCaster()
	local land_time = self:GetSpecialValueFor("land_time")
	local vPosition = self:GetCursorPosition()
	local iTeamNumber = hCaster:GetTeamNumber()

	DotaTD:EachPlayer(function(_, iPlayerID)
		if PlayerData:IsPointInPlayerRange(iPlayerID, vPosition) then
			iTeamNumber = PlayerData:GetHero(iPlayerID):GetTeamNumber()
		end
	end)

	CreateModifierThinker(hCaster, self, "modifier_sp_fireball_thinker", { duration = land_time }, vPosition, iTeamNumber, false)
	EmitSoundOnLocationWithCaster(vPosition, "Hero_Invoker.ChaosMeteor.Cast", hCaster)
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_fireball_thinker == nil then
	modifier_sp_fireball_thinker = class({})
end
function modifier_sp_fireball_thinker:IsDebuff()
	return true
end
function modifier_sp_fireball_thinker:IsHidden()
	return false
end
function modifier_sp_fireball_thinker:IsPurgable()
	return false
end
function modifier_sp_fireball_thinker:IsPurgeException()
	return false
end
function modifier_sp_fireball_thinker:AllowIllusionDuplicate()
	return false
end
function modifier_sp_fireball_thinker:OnCreated()
	local hParent = self:GetParent()

	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.knockback_health = self:GetAbilitySpecialValueFor("knockback_health")
	self.knockback_time = self:GetAbilitySpecialValueFor("knockback_time")
	self.knockback_distance = self:GetAbilitySpecialValueFor("knockback_distance")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
	self.damage_pct_ancient = self:GetAbilitySpecialValueFor("damage_pct_ancient")
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")

	if IsServer() then
		hParent:EmitSound("Hero_Invoker.ChaosMeteor.Loop")

		self.vPosition = hParent:GetAbsOrigin()
		self.iTeamNumber = hParent:GetTeamNumber()
		local vStart = self.vPosition + Vector(0, 0, 1600)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, vStart)
		ParticleManager:SetParticleControl(iParticleID, 1, vStart + (self.vPosition - vStart):Length() * (1.3 / self:GetDuration()) * (self.vPosition - vStart):Normalized())
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(self:GetDuration(), 0, 0))
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
function modifier_sp_fireball_thinker:OnDestroy()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	if IsServer() then
		hParent:StopSound("Hero_Invoker.ChaosMeteor.Loop")
		hParent:EmitSound("Hero_Invoker.ChaosMeteor.Impact")
		ScreenShake(hParent:GetAbsOrigin(), 20, 12, 0.5, 6000, 0, true)

		hParent:RemoveAllModifiers(0, false, true, true)
		hParent:RemoveSelf()

		if not IsValid(hCaster) or not IsValid(hAbility) then
			return
		end

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self.vPosition)
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, self.radius, self.radius))
		ParticleManager:ReleaseParticleIndex(iParticleID)

		local tTargets = FindUnitsInRadius(self.iTeamNumber, self.vPosition, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, hTarget in pairs(tTargets) do
			hTarget:AddNewModifier(hCaster, hAbility, "modifier_stunned", {duration=GetStatusDebuffDuration(self.stun_duration, hTarget, hCaster)})

			local fDamage = self.damage_pct * hTarget:GetMaxHealth() * 0.01
			if hTarget:IsBoss() or hTarget:IsGoldWave() then
				fDamage = self.damage_pct_ancient * hTarget:GetMaxHealth() * 0.01
			end
			fDamage = fDamage + self.damage
			ApplyDamage({
				attacker = hCaster,
				victim = hTarget,
				damage = fDamage,
				damage_type = hAbility:GetAbilityDamageType(),
				ability = hAbility,
				damage_flags = DOTA_DAMAGE_FLAG_SPELL,
			})
		end
	end
end
function modifier_sp_fireball_thinker:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] = true,
		[MODIFIER_STATE_NO_TEAM_SELECT] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}
end
