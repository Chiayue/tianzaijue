LinkLuaModifier("modifier_sp_hpregen_single", "abilities/spell/sp_hpregen_single.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_hpregen_single == nil then
	sp_hpregen_single = class({})
end
function sp_hpregen_single:GetIntrinsicModifierName()
	return "modifier_sp_hpregen_single"
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_hpregen_single == nil then
	modifier_sp_hpregen_single = class({})
end
function modifier_sp_hpregen_single:OnCreated(params)
	if IsServer() then
	end
end
function modifier_sp_hpregen_single:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_sp_hpregen_single:OnDestroy()
	if IsServer() then
	end
end
function modifier_sp_hpregen_single:DeclareFunctions()
	return {
	}
end