---双刃剑
-- LinkLuaModifier("modifier_angel_relics_physical_immune", "abilities/items/item_doubleside_sword.lua", LUA_MODIFIER_MOTION_NONE)
if nil == item_doubleside_sword then
	item_doubleside_sword = class({}, nil, base_ability_attribute)
end
function item_doubleside_sword:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_doubleside_sword then
	modifier_item_doubleside_sword = class({}, nil, modifier_base_ability_attribute)
end

function modifier_item_doubleside_sword:IsHidden()
	return true
end
function modifier_item_doubleside_sword:OnCreated(params)
	self:UpdateValues()
end

function modifier_item_doubleside_sword:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_doubleside_sword:UpdateValues(params)
	self.crit_chance = self:GetAbilitySpecialValueFor("crit_chance")
	self.crit_damage_pct = self:GetAbilitySpecialValueFor('crit_damage_pct')
	self.attack_punishment_pct = self:GetAbilitySpecialValueFor('attack_punishment_pct')
end

function modifier_item_doubleside_sword:EDeclareFunctions()
	return {
		EMDF_ATTACK_CRIT_BONUS,
		EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE
	}
end

function modifier_item_doubleside_sword:GetAttackCritBonus()
	return self.crit_damage_pct, self.crit_chance
end



AbilityClassHook('item_doubleside_sword', getfenv(1), 'abilities/items/item_doubleside_sword.lua', { KeyValues.ItemsKv })