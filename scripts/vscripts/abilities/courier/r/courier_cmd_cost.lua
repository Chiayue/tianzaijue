LinkLuaModifier("modifier_courier_cmd_cost", "abilities/courier/r/courier_cmd_cost.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if courier_cmd_cost == nil then
	courier_cmd_cost = class({})
end
function courier_cmd_cost:GetIntrinsicModifierName()
	return "modifier_courier_cmd_cost"
end
---------------------------------------------------------------------
--Modifiers
if modifier_courier_cmd_cost == nil then
	modifier_courier_cmd_cost = class({}, nil, eom_modifier)
end
function modifier_courier_cmd_cost:OnCreated(params)
	self.cost_reduce_pct = self:GetAbilitySpecialValueFor('cost_reduce_pct')
	if IsServer() then
	end
end
function modifier_courier_cmd_cost:OnRefresh(params)
	self.cost_reduce_pct = self:GetAbilitySpecialValueFor('cost_reduce_pct')
	if IsServer() then
	end
end
function modifier_courier_cmd_cost:EDeclareFunctions()
	return {
		EMDF_CMD_UPGRADE_DISCOUNT_PERCENTAGE
	}
end
function modifier_courier_cmd_cost:GetModifierCmdUpgradeDiscont()
	return self.cost_reduce_pct
end