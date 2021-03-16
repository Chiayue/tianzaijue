LinkLuaModifier("modifier_courier_sp_duration", "abilities/courier/sr/courier_sp_duration.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if courier_sp_duration == nil then
	courier_sp_duration = class({})
end
function courier_sp_duration:GetIntrinsicModifierName()
	return "modifier_courier_sp_duration"
end
---------------------------------------------------------------------
--Modifiers
if modifier_courier_sp_duration == nil then
	modifier_courier_sp_duration = class({}, nil, eom_modifier)
end
function modifier_courier_sp_duration:OnCreated(params)
	self.pct = self:GetAbilitySpecialValueFor('pct')
	if IsServer() then
	end
end
function modifier_courier_sp_duration:OnRefresh(params)
	self.pct = self:GetAbilitySpecialValueFor('pct')
	if IsServer() then
	end
end
function modifier_courier_sp_duration:OnDestroy()
	if IsServer() then
	end
end
function modifier_courier_sp_duration:EDeclareFunctions()
	return {
		EMDF_GOLD_ROUND_GOLD_BONUS_PERCENTAGE
	}
end
function modifier_courier_sp_duration:GetGoldRoundGoldBonusPercentage()
	return self.pct
end