LinkLuaModifier("modifier_talent_general_building", "abilities/talent_general/talent_general.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_talent_general", "abilities/talent_general/talent_general.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if talent_general == nil then
	talent_general = class({})
end
function talent_general:GetIntrinsicModifierName()
	return "modifier_talent_general"
end


--玩家天赋通用BUFF
if modifier_talent_general == nil then
	modifier_talent_general = class({}, nil, eom_modifier)
end
function modifier_talent_general:OnCreated(params)
	if IsServer() then
	end
end
function modifier_talent_general:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_talent_general:OnDestroy()
	if IsServer() then
	end
end
function modifier_talent_general:DeclareFunctions()
	return {
	}
end