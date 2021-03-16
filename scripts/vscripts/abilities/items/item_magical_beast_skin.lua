LinkLuaModifier("modifier_item_magical_beast_skin", "abilities/items/item_magical_beast_skin.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_magical_beast_skin == nil then
	item_magical_beast_skin = class({}, nil, base_ability_attribute)
end
function item_magical_beast_skin:GetIntrinsicModifierName()
	return "modifier_item_magical_beast_skin"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_magical_beast_skin == nil then
	modifier_item_magical_beast_skin = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_magical_beast_skin:OnCreated(params)
	if IsServer() then
	end
end
function modifier_item_magical_beast_skin:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_item_magical_beast_skin:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_magical_beast_skin:DeclareFunctions()
	return {
	}
end
AbilityClassHook('item_magical_beast_skin', getfenv(1), 'abilities/items/item_magical_beast_skin.lua', { KeyValues.ItemsKv })