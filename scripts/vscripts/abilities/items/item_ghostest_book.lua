LinkLuaModifier("modifier_item_ghostest_book", "abilities/items/item_ghostest_book.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_ghostest_book == nil then
	item_ghostest_book = class({}, nil, base_ability_attribute)
end
function item_ghostest_book:GetIntrinsicModifierName()
	return "modifier_item_ghostest_book"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_ghostest_book == nil then
	modifier_item_ghostest_book = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_ghostest_book:OnCreated(params)
	self.magical_crit_chance = self:GetAbilitySpecialValueFor("magical_crit_chance")
	self.magical_crit_damage = self:GetAbilitySpecialValueFor("magical_crit_damage")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then
	end
end
function modifier_item_ghostest_book:OnRefresh(params)
	self.magical_crit_chance = self:GetAbilitySpecialValueFor("magical_crit_chance")
	self.magical_crit_damage = self:GetAbilitySpecialValueFor("magical_crit_damage")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then
	end
end
function modifier_item_ghostest_book:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_ghostest_book:EDeclareFunctions()
	return {
		EMDF_MAGICAL_CRIT_BONUS,
		[MODIFIER_EVENT_ON_ABILITY_FULLY_CAST] = { self:GetParent() }
	}
end
function modifier_item_ghostest_book:OnAbilityFullyCast(params)
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if params.unit == self:GetParent() then
		if IsValid(params.ability) and hAbility:IsCooldownReady() then
			hAbility:UseResources(false, false, true)
			hParent:GiveMana(hParent:GetMaxMana())
		end
	end
end
function modifier_item_ghostest_book:GetMagicalCritBonus()
	return	self.magical_crit_damage, self.magical_crit_chance
end
AbilityClassHook('item_ghostest_book', getfenv(1), 'abilities/items/item_ghostest_book.lua', { KeyValues.ItemsKv })