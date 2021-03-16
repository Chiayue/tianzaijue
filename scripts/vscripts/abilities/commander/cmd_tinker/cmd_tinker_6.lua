LinkLuaModifier("modifier_cmd_tinker_6", "abilities/commander/cmd_tinker/cmd_tinker_6.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_tinker_6 == nil then
	cmd_tinker_6 = class({})
end
function cmd_tinker_6:GetIntrinsicModifierName()
	return "modifier_cmd_tinker_6"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_tinker_6 == nil then
	modifier_cmd_tinker_6 = class({}, nil, eom_modifier)
end
function modifier_cmd_tinker_6:IsHidden()
	return true
end
function modifier_cmd_tinker_6:OnCreated(params)
	self.golds_reduce = self:GetAbilitySpecialValueFor("golds_reduce")
	if IsServer() then
	end
end
function modifier_cmd_tinker_6:OnRefresh(params)
	self.golds_reduce = self:GetAbilitySpecialValueFor("golds_reduce")
	if IsServer() then
	end
end
function modifier_cmd_tinker_6:OnDestroy()
	if IsServer() then
	end
end
function modifier_cmd_tinker_6:EDeclareFunctions()
	return {
		EMDF_CARD_REFRESH_COST_CONSTANT
	}
end
function modifier_cmd_tinker_6:GetModifierCardRefreshCostConstant()
	return self.golds_reduce * math.min(Draw.tPlayerDrawCount[GetPlayerID(self:GetParent())], 1)
end