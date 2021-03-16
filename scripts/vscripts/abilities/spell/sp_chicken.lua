LinkLuaModifier("modifier_sp_chicken", "abilities/spell/sp_chicken.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_chicken == nil then
	sp_chicken = class({}, nil, sp_base)
end
function sp_chicken:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_chicken:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	local iTeamNumber = hCaster:GetTeamNumber()

	DotaTD:EachPlayer(function(_, iPlayerID)
		if PlayerData:IsPointInPlayerRange(iPlayerID, vPosition) then
			iTeamNumber = PlayerData:GetHero(iPlayerID):GetTeamNumber()
		end
	end)

	local hTower = CreateUnitByName("chicken_house", vPosition, false, hCaster, hCaster, iTeamNumber)
	Attributes:Register(hTower)
	hTower:AddNewModifier(hCaster, self, "modifier_sp_chicken", { duration = duration })
	hTower:SetModelScale(2.55)

	local iParticleID = ParticleManager:CreateParticle("particles/radiant_fx/tower_good3_destroy_lvl3_fallback_med.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTower)
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(vPosition, "Ability.Starfall", hCaster)
	self:GameTimer(0.3, function()
		ScreenShake(vPosition, 20, 12, 0.5, 6000, 0, true)
	end)
end
function sp_chicken:OnProjectileHit(_, vLocation)
	local hCaster = self:GetCaster()
	local explosion_radius = self:GetSpecialValueFor("explosion_radius")
	local damage_pct = self:GetSpecialValueFor("damage_pct")
	local damage_pct_ancient = self:GetSpecialValueFor("damage_pct_ancient")
	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), vLocation, nil, explosion_radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_CLOSEST, false)
	for _, hTarget in pairs(tTargets) do
		local fDamage = hTarget:GetMaxHealth() * damage_pct*0.01
		if hTarget:IsBoss() or hTarget:IsGoldWave() then
			fDamage = hTarget:GetMaxHealth() * damage_pct_ancient*0.01
		end
		ApplyDamage({
			attacker = hCaster,
			victim = hTarget,
			damage = fDamage,
			damage_type = self:GetAbilityDamageType(),
			ability = self,
			damage_flags = DOTA_DAMAGE_FLAG_SPELL,
		})
	end
	return true
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_chicken == nil then
	modifier_sp_chicken = class({}, nil, eom_modifier)
end
function modifier_sp_chicken:IsHidden()
	return true
end
function modifier_sp_chicken:IsDebuff()
	return false
end
function modifier_sp_chicken:IsPurgable()
	return false
end
function modifier_sp_chicken:IsPurgeException()
	return false
end
function modifier_sp_chicken:IsStunDebuff()
	return false
end
function modifier_sp_chicken:OnCreated(params)
	self.summon_interval = self:GetAbilitySpecialValueFor("summon_interval")
	self.speed = self:GetAbilitySpecialValueFor("speed")
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.width = self:GetAbilitySpecialValueFor("width")
	if IsServer() then
		self:SetDuration(self:GetDuration()-2/30, true)
		self:StartIntervalThink(self.summon_interval)
		self:OnIntervalThink()
		self:GetParent():StartGesture(ACT_DOTA_IDLE)
	end
end
function modifier_sp_chicken:OnDestroy()
	if IsServer() then
		self:GetParent():ForceKill(false)
		self:GetParent():AddNoDraw()
	end
end
function modifier_sp_chicken:OnIntervalThink()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	if IsServer() then
		if not IsValid(hAbility) or not IsValid(hCaster) then
			self:Destroy()
			return
		end

		local vDirection = RandomVector(1)
		local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.distance+self.width, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
		if IsValid(tTargets[1]) then
			vDirection = tTargets[1]:GetAbsOrigin() - hParent:GetAbsOrigin()
			vDirection.z = 0
			vDirection = vDirection:Normalized()
		end
		local tInfo = {
			Ability = hAbility,
			Source = hParent,
			EffectName = "particles/spell/sp_chicken/sp_chicken.vpcf",
			vSpawnOrigin = hParent:GetAbsOrigin(),
			vVelocity = vDirection * self.speed,
			fDistance = self.distance,
			fStartRadius = self.width,
			fEndRadius = self.width,
			iUnitTargetTeam = hAbility:GetAbilityTargetTeam(),
			iUnitTargetType = hAbility:GetAbilityTargetType(),
			iUnitTargetFlags = hAbility:GetAbilityTargetFlags(),
		}
		ProjectileManager:CreateLinearProjectile(tInfo)
	end
end
function modifier_sp_chicken:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_ROOTED] = true,
	}
end
function modifier_sp_chicken:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_LIFETIME_FRACTION,
	}
end
function modifier_sp_chicken:GetUnitLifetimeFraction()
	return self:GetRemainingTime() / self:GetDuration()
end
function modifier_sp_chicken:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_sp_chicken:OnBattleEnd()
	self:Destroy()
end