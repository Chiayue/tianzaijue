LinkLuaModifier("modifier_cmd_rattletrap_5", "abilities/commander/cmd_rattletrap/cmd_rattletrap_5.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_rattletrap_5 == nil then
	cmd_rattletrap_5 = class({})
end
function cmd_rattletrap_5:GetIntrinsicModifierName()
	return "modifier_cmd_rattletrap_5"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_rattletrap_5 == nil then
	modifier_cmd_rattletrap_5 = class({}, nil, eom_modifier)
end
function modifier_cmd_rattletrap_5:IsHidden()
	return true
end
function modifier_cmd_rattletrap_5:OnCreated(params)
	self.pct = self:GetAbilitySpecialValueFor('pct')
end
function modifier_cmd_rattletrap_5:OnRefresh(params)
	self.pct = self:GetAbilitySpecialValueFor('pct')
end
function modifier_cmd_rattletrap_5:EDeclareFunctions()
	return {
		EMDF_REMAKE_LEVELUP_CHANCE_PERCENTAGE,
	}
end
function modifier_cmd_rattletrap_5:GetRemakeLevelupChancePercentage(iPlayerID, iRarity)
	return self.pct
end