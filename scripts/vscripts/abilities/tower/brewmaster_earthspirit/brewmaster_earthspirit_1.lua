LinkLuaModifier("modifier_brewmaster_earthspirit_1", "abilities/tower/brewmaster_earthspirit/brewmaster_earthspirit_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_brewmaster_earthspirit_1_debuff", "abilities/tower/brewmaster_earthspirit/brewmaster_earthspirit_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if brewmaster_earthspirit_1 == nil then
	brewmaster_earthspirit_1 = class({})
end
function brewmaster_earthspirit_1:GetIntrinsicModifierName()
	return "modifier_brewmaster_earthspirit_1"
end

------------------------------------------------------------------------------
if modifier_brewmaster_earthspirit_1 == nil then
	modifier_brewmaster_earthspirit_1 = class({}, nil, eom_modifier)
end
function modifier_brewmaster_earthspirit_1:IsHidden()
	return true
end
function modifier_brewmaster_earthspirit_1:OnCreated(params)
	if IsServer() then

	end
end
function modifier_brewmaster_earthspirit_1:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_brewmaster_earthspirit_1:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_brewmaster_earthspirit_1:EDeclareFunctions()
	return {
		EMDF_ATTACKT_PROJECTILE,
		EMDF_EVENT_ON_ATTACK_HIT
	}
end
function modifier_brewmaster_earthspirit_1:GetAttackProjectile()
	return "particles/units/heroes/hero_brewmaster/brewmaster_hurl_boulder.vpcf"
end
function modifier_brewmaster_earthspirit_1:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	local hCaster = self:GetCaster()
	if hCaster:IsAbilityReady(self:GetAbility()) then
		self:GetAbility():UseResources(true, true, true)
	else
		return
	end

	local center_radius = self:GetAbilitySpecialValueFor("center_radius")
	local center_damage = self:GetAbilitySpecialValueFor("center_damage")
	local hAbility_3 = hCaster:FindAbilityByName("brewmaster_earthspirit_3")
	local bStun = (IsValid(hAbility_3) and hAbility_3:GetLevel() > 0) and true or false

	local tDamageInfo = tAttackInfo.tDamageInfo

	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hTarget:GetAbsOrigin(), nil, self:GetAbilitySpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, self:GetAbility():GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
	for _, hUnit in pairs(tTargets) do
		if tDamageInfo then
			for __, tData in pairs(tDamageInfo) do
				if 0 < tData.damage then
					local tDamageData = {
						victim = hUnit,
						attacker = hCaster,
						damage = (hUnit == hTarget and 0 or tData.damage) + tData.damage * center_damage * 0.01,
						damage_type = tData.damage_type,
						damage_flags = tData.damage_flags,
						ability = self:GetAbility()
					}
					ApplyDamage(tDamageData)
				end
			end
		end

		if hUnit:IsAlive() then
			if (hUnit:GetAbsOrigin() - hTarget:GetAbsOrigin()):Length2D() < center_radius then
				hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_brewmaster_earthspirit_1_debuff", { duration = self:GetAbility():GetDuration() })
			end
			if bStun then
				hUnit:AddBuff(hCaster, BUFF_TYPE.STUN, hAbility_3:GetSpecialValueFor("stun_duration"))
			end
		end
	end

	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_pulverize.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, hTarget:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(iParticleID)
end

---------------------------------------------------------------------
--Modifiers
if modifier_brewmaster_earthspirit_1_debuff == nil then
	modifier_brewmaster_earthspirit_1_debuff = class({}, nil, BaseModifier)
end
function modifier_brewmaster_earthspirit_1_debuff:IsDebuff()
	return true
end
function modifier_brewmaster_earthspirit_1_debuff:OnCreated(params)
	self.movespeed_reduce = self:GetAbilitySpecialValueFor("movespeed_reduce")
	if IsServer() then
	else
		self:SetDuration(0, false)
	end
end
function modifier_brewmaster_earthspirit_1_debuff:OnRefresh(params)
	self.movespeed_reduce = self:GetAbilitySpecialValueFor("movespeed_reduce")
	if IsServer() then
	end
end
function modifier_brewmaster_earthspirit_1_debuff:OnDestroy()
	if IsServer() then
	end
end
function modifier_brewmaster_earthspirit_1_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_brewmaster_earthspirit_1_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -self.movespeed_reduce
end
function modifier_brewmaster_earthspirit_1_debuff:OnTooltip()
	return self:GetModifierMoveSpeedBonus_Percentage()
end