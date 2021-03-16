LinkLuaModifier("modifier_cmd_tinker_2", "abilities/commander/cmd_tinker/cmd_tinker_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--百夫长
if cmd_tinker_2 == nil then
	cmd_tinker_2 = class({})
end
function cmd_tinker_2:GetIntrinsicModifierName()
	return "modifier_cmd_tinker_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_tinker_2 == nil then
	modifier_cmd_tinker_2 = class({}, nil, eom_modifier)
end
function modifier_cmd_tinker_2:IsHidden()
	return true
end
function modifier_cmd_tinker_2:OnCreated(params)
	self.upgrade_decpct = self:GetAbilitySpecialValueFor("upgrade_decpct")
	if IsServer() then
	end
end
function modifier_cmd_tinker_2:OnRefresh(params)
	self.upgrade_decpct = self:GetAbilitySpecialValueFor("upgrade_decpct")
	if IsServer() then
	end
end
function modifier_cmd_tinker_2:OnDestroy()
	if IsServer() then
	end
end
function modifier_cmd_tinker_2:EDeclareFunctions()
	return {
		EMDF_CMD_UPGRADE_DISCOUNT_PERCENTAGE
	}
end
function modifier_cmd_tinker_2:GetModifierCmdUpgradeDiscont()
	return self.upgrade_decpct
end