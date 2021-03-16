LinkLuaModifier( "modifier_cmd_huskar_7", "abilities/commander/cmd_huskar/cmd_huskar_7.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if cmd_huskar_7 == nil then
	cmd_huskar_7 = class({})
end
function cmd_huskar_7:GetIntrinsicModifierName()
	return "modifier_cmd_huskar_7"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_huskar_7 == nil then
	modifier_cmd_huskar_7 = class({})
end
function modifier_cmd_huskar_7:OnCreated(params)
	if IsServer() then
	end
end
function modifier_cmd_huskar_7:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_cmd_huskar_7:OnDestroy()
	if IsServer() then
	end
end
function modifier_cmd_huskar_7:DeclareFunctions()
	return {
	}
end