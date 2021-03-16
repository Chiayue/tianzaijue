LinkLuaModifier("modifier_storm_spirit_3", "abilities/tower/storm_spirit/storm_spirit_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_storm_spirit_3_thinker", "abilities/tower/storm_spirit/storm_spirit_3.lua", LUA_MODIFIER_MOTION_NONE)

if storm_spirit_3 == nil then
	storm_spirit_3 = class({})
end

function storm_spirit_3:Remnant(vPosition)
	local hCaster = self:GetCaster()
	local chance = self:GetSpecialValueFor("chance")
	local delay = self:GetSpecialValueFor("delay")
	if RollPercentage(chance) and self:GetLevel() > 0 then
		local hThinker = CreateUnitByName(hCaster:GetUnitName(), vPosition, false, hCaster, hCaster, hCaster:GetTeamNumber())
		hThinker:SetForwardVector(hCaster:GetForwardVector())
		hThinker:StartGesture(ACT_DOTA_CAST_ABILITY_1)

		for i = hThinker:GetAbilityCount() - 1, 0, -1 do
			local hAbility = hThinker:GetAbilityByIndex(i)
			if IsValid(hAbility) then
				hThinker:RemoveAbilityByHandle(hAbility)
			end
		end

		hThinker:AddNewModifier(hCaster, self, "modifier_storm_spirit_3_thinker", { duration = delay })

		hCaster:EmitSound("Hero_StormSpirit.StaticRemnantPlant")
	end
end
function storm_spirit_3:GetIntrinsicModifierName()
	return "modifier_storm_spirit_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_storm_spirit_3 == nil then
	modifier_storm_spirit_3 = class({}, nil, eom_modifier)
end
function modifier_storm_spirit_3:IsHidden()
	return true
end
function modifier_storm_spirit_3:IsDebuff()
	return false
end
function modifier_storm_spirit_3:IsPurgable()
	return false
end
function modifier_storm_spirit_3:IsPurgeException()
	return false
end
function modifier_storm_spirit_3:IsStunDebuff()
	return false
end
function modifier_storm_spirit_3:AllowIllusionDuplicate()
	return false
end
function modifier_storm_spirit_3:OnCreated(params)
	self.attack_speed_percentage = self:GetAbilitySpecialValueFor("attack_speed_percentage")
	self.max_attack_speed = self:GetAbilitySpecialValueFor("max_attack_speed")
end
function modifier_storm_spirit_3:OnRefresh(params)
	self.attack_speed_percentage = self:GetAbilitySpecialValueFor("attack_speed_percentage")
	self.max_attack_speed = self:GetAbilitySpecialValueFor("max_attack_speed")
end
function modifier_storm_spirit_3:EDeclareFunctions()
	return {
		[EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE] = self.attack_speed_percentage,
		EMDF_EVENT_ON_ATTACK_HIT,
		[EMDF_BONUS_MAXIMUM_ATTACK_SPEED] = self.max_attack_speed,
	}
end
function modifier_storm_spirit_3:GetAttackSpeedPercentage()
	return self.attack_speed_percentage
end
function modifier_storm_spirit_3:GetAttackSpeedBonusMaximum()
	return self.max_attack_speed
end
function modifier_storm_spirit_3:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()

	if IsValid(hAbility) and type(hAbility.Remnant) == "function" then
		hAbility:Remnant(vLocation or hTarget:GetAbsOrigin())
	end
end
---------------------------------------------------------------------
if modifier_storm_spirit_3_thinker == nil then
	modifier_storm_spirit_3_thinker = class({})
end
function modifier_storm_spirit_3_thinker:IsHidden()
	return true
end
function modifier_storm_spirit_3_thinker:IsDebuff()
	return false
end
function modifier_storm_spirit_3_thinker:IsPurgable()
	return false
end
function modifier_storm_spirit_3_thinker:IsPurgeException()
	return false
end
function modifier_storm_spirit_3_thinker:IsStunDebuff()
	return false
end
function modifier_storm_spirit_3_thinker:AllowIllusionDuplicate()
	return false
end
function modifier_storm_spirit_3_thinker:OnCreated(params)
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self.vPosition = hParent:GetAbsOrigin()
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/storm_spirit_static_remnant.vpcf", PATTACH_INVALID, hParent)
		self:AddParticle(iParticleID, false, true, 10, false, false)
	end
end
function modifier_storm_spirit_3_thinker:OnDestroy()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hAbility = self:GetAbility()
		local hParent = self:GetParent()
		hParent:RemoveSelf()

		if not IsValid(hCaster) or not IsValid(hAbility) then
			return
		end

		local tTargets = FindUnitsInRadiusWithAbility(hCaster, self.vPosition, self.radius, hAbility)
		hCaster:DealDamage(tTargets, hAbility, hAbility:GetAbilityDamage())
		EmitSoundOnLocationWithCaster(self.vPosition, "Hero_StormSpirit.StaticRemnantExplode", hCaster)
	end
end
function modifier_storm_spirit_3_thinker:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true
	}
end