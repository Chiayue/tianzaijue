LinkLuaModifier("modifier_sp_manaregen_single", "abilities/spell/sp_manaregen_single.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_manaregen_single == nil then
	sp_manaregen_single = class({})
end
function sp_manaregen_single:GetIntrinsicModifierName()
	return "modifier_sp_manaregen_single"
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_manaregen_single == nil then
	modifier_sp_manaregen_single = class({})
end
function modifier_sp_manaregen_single:OnCreated(params)
	if IsServer() then
	end
end
function modifier_sp_manaregen_single:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_sp_manaregen_single:OnDestroy()
	if IsServer() then
	end
end
function modifier_sp_manaregen_single:DeclareFunctions()
	return {
	}
end