LinkLuaModifier("modifier_sp_cannon", "abilities/spell/sp_cannon.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_cannon == nil then
	sp_cannon = class({}, nil, sp_base)
end
function sp_cannon:CastFilterResult()
	if GSManager:getStateType() == GS_Battle then
		return UF_SUCCESS
	end
	return UF_FAIL_CUSTOM, "dota_hud_error_only_can_not_cast"
end
function sp_cannon:OnSpellStart()
	local hCaster = self:GetCaster()
	local hCommander = Commander:GetCommander(hCaster:GetPlayerOwnerID())
	local count_min = self:GetSpecialValueFor("count_min")
	local count_max = self:GetSpecialValueFor("count_max")
	local iCount = RandomInt(count_min, count_max)

	if GSManager:getStateType() == GS_Battle then
		if Spawner:IsBossRound() then
			CreateModifierThinker(hCommander, self, "modifier_sp_cannon", {count=iCount}, hCommander:GetAbsOrigin(), hCommander:GetTeamNumber(), false)
		else
			DotaTD:EachPlayer(function(_, iPlayerID)
				if PlayerData:IsPlayerDeath(iPlayerID) then return end
				local hPlayerCommander = Commander:GetCommander(iPlayerID)

				CreateModifierThinker(hPlayerCommander, self, "modifier_sp_cannon", {count=iCount}, hPlayerCommander:GetAbsOrigin(), hPlayerCommander:GetTeamNumber(), false)
			end)
		end
	end
end
function sp_cannon:OnProjectileHit(hTarget, vLocation)
	local hCaster = self:GetCaster()
	
	local radius = self:GetSpecialValueFor("radius")
	local damage_pct = self:GetSpecialValueFor("damage_pct")
	local damage_pct_ancient = self:GetSpecialValueFor("damage_pct_ancient")

	local iTeamNumber = hCaster:GetTeamNumber()

	DotaTD:EachPlayer(function(_, iPlayerID)
		if PlayerData:IsPointInPlayerRange(iPlayerID, vLocation) then
			iTeamNumber = PlayerData:GetHero(iPlayerID):GetTeamNumber()
		end
	end)

	local tTargets = FindUnitsInRadius(iTeamNumber, vLocation, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
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

	EmitSoundOnLocationWithCaster(vLocation, "Hero_Rattletrap.Rocket_Flare.Explode", hCaster)

	return true
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_cannon == nil then
	modifier_sp_cannon = class({})
end
function modifier_sp_cannon:IsHidden()
	return false
end
function modifier_sp_cannon:IsDebuff()
	return false
end
function modifier_sp_cannon:IsPurgable()
	return true
end
function modifier_sp_cannon:IsPurgeException()
	return true
end
function modifier_sp_cannon:IsStunDebuff()
	return false
end
function modifier_sp_cannon:OnCreated(params)
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.land_time = self:GetAbilitySpecialValueFor("land_time")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self.iCount = params.count
		if type(self.iCount) ~= "number" then
			self:Destroy()
			return
		end
		
		self:StartIntervalThink(self.interval)
		self:OnIntervalThink()
	end
end
function modifier_sp_cannon:OnDestroy()
	local hParent = self:GetParent()
	if IsServer() then
		hParent:RemoveAllModifiers(0, false, true, true)
		hParent:RemoveSelf()
	end
end
function modifier_sp_cannon:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local hCaster = self:GetCaster()
		local hAbility = self:GetAbility()

		if not IsValid(hCaster) or not IsValid(hAbility) then
			self:Destroy()
			return
		end

		local iPlayerID = hCaster:GetPlayerOwnerID()
		if PlayerData:GetPlayerRoundResult(iPlayerID) ~= nil then
			self:Destroy()
			return
		end
		local tTargets = {}
		EachUnits(iPlayerID, function(hUnit)
			table.insert(tTargets, hUnit)
		end, UnitType.AllEnemies)
		if #tTargets > 0 then
			self.iCount = self.iCount - 1

			local hTarget = GetRandomElement(tTargets)

			local vStart = hParent:GetAbsOrigin()
			local vEnd = hTarget:GetAbsOrigin()
			local vDirection = vEnd - vStart
			vDirection.z = 0

			local iParticleID = ParticleManager:CreateParticle("particles/spell/sp_cannon/sp_cannon.vpcf", PATTACH_WORLDORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, vStart)
			ParticleManager:SetParticleControl(iParticleID, 1, vEnd)
			ParticleManager:SetParticleControl(iParticleID, 5, Vector(self.radius, self.land_time, 0))
			ParticleManager:ReleaseParticleIndex(iParticleID)

			local iParticleID = ParticleManager:CreateParticle("particles/spell/sp_cannon/sp_cannon_marker.vpcf", PATTACH_WORLDORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, vEnd)
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, self.radius, -self.radius/self.land_time))
			ParticleManager:SetParticleControl(iParticleID, 2, Vector(self.land_time, 0, 0))
			ParticleManager:ReleaseParticleIndex(iParticleID)

			local tInfo = {
				Ability = hAbility,
				vSpawnOrigin = vStart,
				vVelocity = vDirection/self.land_time,
				fDistance = vDirection:Length2D(),
			}
			ProjectileManager:CreateLinearProjectile(tInfo)

			EmitSoundOnLocationWithCaster(vStart, "Hero_Rattletrap.Rocket_Flare.Fire", hCaster)

			if self.iCount <= 0 then
				self:Destroy()
			end
		end
	end
end
function modifier_sp_cannon:CheckState()
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
function modifier_sp_cannon:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_sp_cannon:OnBattleEnd()
	self:Destroy()
end