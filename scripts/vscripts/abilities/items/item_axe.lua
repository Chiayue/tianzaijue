LinkLuaModifier("modifier_item_axe", 'abilities/items/item_axe.lua', LUA_MODIFIER_MOTION_NONE)

--砍柴斧
if nil == item_axe then
	item_axe = class({}, nil, base_ability_attribute)
end

function item_axe:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_axe then
	modifier_item_axe = class({}, nil, modifier_base_ability_attribute)
end

function modifier_item_axe:IsHidden()
	return false
end
function modifier_item_axe:OnCreated(params)
	self:UpdateValues()
end

function modifier_item_axe:OnRefresh(params)
	self:UpdateValues()
end

function modifier_item_axe:UpdateValues(params)
	self.crit_chance = self:GetAbilitySpecialValueFor("crit_chance")
	self.crit_damage_pct = self:GetAbilitySpecialValueFor('crit_damage_pct')
end

function modifier_item_axe:EDeclareFunctions()
	return {
		EMDF_ATTACK_CRIT_BONUS,
	}
end

function modifier_item_axe:GetAttackCritBonus()
	return self.crit_damage_pct, self.crit_chance
end
-- AbilityClassHook('item_axe', getfenv(1), 'abilities/items/item_axe.lua', { KeyValues.ItemsKv })