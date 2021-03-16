LinkLuaModifier("modifier_sp_levelup", "abilities/spell/sp_levelup.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_levelup == nil then
	sp_levelup = class({})
end
function sp_levelup:GetIntrinsicModifierName()
	return "modifier_sp_levelup"
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_levelup == nil then
	modifier_sp_levelup = class({})
end
function modifier_sp_levelup:OnCreated(params)
	if IsServer() then
	end
end
function modifier_sp_levelup:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_sp_levelup:OnDestroy()
	if IsServer() then
	end
end
function modifier_sp_levelup:DeclareFunctions()
	return {
	}
end