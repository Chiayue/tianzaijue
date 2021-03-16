---警卫鞋
if nil == item_guard_shoe then
	item_guard_shoe = class({}, nil, base_ability_attribute)
end
function item_guard_shoe:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_guard_shoe then
	modifier_item_guard_shoe = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_guard_shoe:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor('chance')
	self.incoming_reduce = self:GetAbilitySpecialValueFor('incoming_reduce')
	self.movement_speed = self:GetAbilitySpecialValueFor('movement_speed')
end
function modifier_item_guard_shoe:IsHidden()
	return false
end
function modifier_item_guard_shoe:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor('chance')
	self.incoming_reduce = self:GetAbilitySpecialValueFor('incoming_reduce')
	self.movement_speed = self:GetAbilitySpecialValueFor('movement_speed')
end
function modifier_item_guard_shoe:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2
	}
end
function modifier_item_guard_shoe:OnTooltip()
	return self.movement_speed
end
function modifier_item_guard_shoe:OnTooltip2()
	return self.chance
end
-- 	[EMDF_EVENT_CUSTOM] = { ET_GAME.GAME_BEGIN, self.func, ?EVENT_LEVEL_NONE }
function modifier_item_guard_shoe:EDeclareFunctions()
	return {
		EMDF_ATTACK_MISS_BONUS
	}
end
function modifier_item_guard_shoe:GetAttackMissBonus()
	return self.incoming_reduce, self.chance
end

AbilityClassHook('item_guard_shoe', getfenv(1), 'abilities/items/item_guard_shoe.lua', { KeyValues.ItemsKv })