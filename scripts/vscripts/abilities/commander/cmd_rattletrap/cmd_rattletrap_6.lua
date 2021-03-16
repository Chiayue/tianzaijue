LinkLuaModifier("modifier_cmd_rattletrap_6", "abilities/commander/cmd_rattletrap/cmd_rattletrap_6.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_rattletrap_6 == nil then
	cmd_rattletrap_6 = class({})
end
function cmd_rattletrap_6:GetIntrinsicModifierName()
	return "modifier_cmd_rattletrap_6"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_rattletrap_6 == nil then
	modifier_cmd_rattletrap_6 = class({}, nil, eom_modifier)
end
function modifier_cmd_rattletrap_6:IsHidden()
	return true
end
function modifier_cmd_rattletrap_6:OnCreated(params)
	if IsServer() then
	end
end
function modifier_cmd_rattletrap_6:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_cmd_rattletrap_6:OnDestroy()
	if IsServer() then
	end
end
function modifier_cmd_rattletrap_6:EDeclareFunctions()
	return {
		EMDF_FETTERS_ACTIVE_COUNT
	}
end
function modifier_cmd_rattletrap_6:GetModifyFettersActiveCount(iPlayerID, sTagName)
	if sTagName == "techie" then
		return -1
	end
end