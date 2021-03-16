LinkLuaModifier( "modifier_sk_7", "abilities/boss/sk_7.lua", LUA_MODIFIER_MOTION_NONE )

--Abilities
if sk_7 == nil then
	sk_7 = class({})
end
function sk_7:GetIntrinsicModifierName()
	return "modifier_sk_7"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_sk_7 == nil then
	modifier_sk_7 = class({}, nil, BaseModifier)
end
function modifier_sk_7:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end
function modifier_sk_7:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if self:GetParent():IsAbilityReady(self:GetAbility()) then
		local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, hParent:GetAcquisitionRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		if IsValid(tTargets[1]) then
			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
				-- AbilityIndex = self:GetAbility():entindex(),
				TargetIndex = tTargets[1]:entindex(),
			})
			self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel() - 1))
		end
	end
end
function modifier_sk_7:IsHidden()
	return true
end