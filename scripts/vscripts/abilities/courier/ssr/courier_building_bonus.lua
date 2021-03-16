LinkLuaModifier( "modifier_courier_building_bonus", "abilities/courier/ssr/courier_building_bonus.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if courier_building_bonus == nil then
	courier_building_bonus = class({})
end
function courier_building_bonus:GetIntrinsicModifierName()
	return "modifier_courier_building_bonus"
end
---------------------------------------------------------------------
--Modifiers
if modifier_courier_building_bonus == nil then
	modifier_courier_building_bonus = class({}, nil, eom_modifier)
end
function modifier_courier_building_bonus:IsHidden()
	return true
end
function modifier_courier_building_bonus:EDeclareFunctions()
	return {
		EMDF_MAX_BUILDING_BONUS
	}
end
function modifier_courier_building_bonus:GetModifierMaxBuildingBonus()
	return 1
end