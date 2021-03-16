LinkLuaModifier("modifier_cmd_rattletrap_1", "abilities/commander/cmd_rattletrap/cmd_rattletrap_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_rattletrap_1 == nil then
	cmd_rattletrap_1 = class({})
end
function cmd_rattletrap_1:GetIntrinsicModifierName()
	return "modifier_cmd_rattletrap_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_rattletrap_1 == nil then
	modifier_cmd_rattletrap_1 = class({}, nil, eom_modifier)
end
function modifier_cmd_rattletrap_1:IsHidden()
	return true
end
function modifier_cmd_rattletrap_1:OnCreated(params)
	self.pct = self:GetAbilitySpecialValueFor('pct')
	if IsServer() then
	end
end
function modifier_cmd_rattletrap_1:OnRefresh(params)
	self.pct = self:GetAbilitySpecialValueFor('pct')
	if IsServer() then
	end
end
function modifier_cmd_rattletrap_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_cmd_rattletrap_1:EDeclareFunctions()
	return {
		EMDF_REMAKE_CRYSTAl_PERCENTAGE
	}
end
function modifier_cmd_rattletrap_1:GetModifyRemakeCrystalPercentage()
	return -self.pct
end