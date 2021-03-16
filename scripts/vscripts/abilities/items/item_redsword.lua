LinkLuaModifier("modifier_item_redsword", "abilities/items/item_redsword.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_redsword == nil then
	item_redsword = class({}, nil, base_ability_attribute)
end
function item_redsword:GetIntrinsicModifierName()
	return "modifier_item_redsword"
end
function item_redsword:Precache(context)
	-- PrecacheResource("particle", "particles/items/item_magic_cube/magic_cube.vpcf", context)
	-- PrecacheResource("particle", "particles/units/heroes/hero_rubick/rubick_faceless_void_chronosphere.vpcf", context)
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_redsword == nil then
	modifier_item_redsword = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_redsword:IsHidden()
	return true
end
function modifier_item_redsword:OnCreated(params)

	if IsServer() then
	end
end
function modifier_item_redsword:OnRefresh(params)

	if IsServer() then
	end
end
function modifier_item_redsword:OnDestroy()
	if IsServer() then
	end
end
-- function modifier_item_redsword:EDeclareFunctions()
-- 	return {
-- 		[MODIFIER_EVENT_ON_DEATH] = { self:GetParent() },
-- 		EMDF_PHYSICAL_ATTACK_BONUS
-- 	}
-- end
AbilityClassHook('item_redsword', getfenv(1), 'abilities/items/item_redsword.lua', { KeyValues.ItemsKv })