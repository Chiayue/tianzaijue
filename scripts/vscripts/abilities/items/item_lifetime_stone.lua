LinkLuaModifier("modifier_item_lifetime_stone", "abilities/items/item_lifetime_stone.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--恐鳌之戒
if item_lifetime_stone == nil then
	item_lifetime_stone = class({}, nil, base_ability_attribute)
end
function item_lifetime_stone:GetIntrinsicModifierName()
	return "modifier_item_lifetime_stone"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_lifetime_stone == nil then
	modifier_item_lifetime_stone = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_lifetime_stone:OnCreated(params)
	self.healthpct_bonus = self:GetAbilitySpecialValueFor("healthpct_bonus")
	if IsServer() then
	end
end
function modifier_item_lifetime_stone:OnRefresh(params)
	self.healthpct_bonus = self:GetAbilitySpecialValueFor("healthpct_bonus")
	if IsServer() then
	end
end
function modifier_item_lifetime_stone:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_lifetime_stone:EDeclareFunctions()
	return {
		[EMDF_STATUS_HEALTH_BONUS_PERCENTAGE] = self.healthpct_bonus
	}
end


AbilityClassHook('item_lifetime_stone', getfenv(1), 'abilities/items/item_lifetime_stone.lua', { KeyValues.ItemsKv })