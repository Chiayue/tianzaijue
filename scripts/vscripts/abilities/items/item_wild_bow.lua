LinkLuaModifier("modifier_item_wild_bow", "abilities/items/item_wild_bow.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_wild_bow == nil then
	item_wild_bow = class({}, nil, base_ability_attribute)
end
function item_wild_bow:GetIntrinsicModifierName()
	return "modifier_item_wild_bow"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_wild_bow == nil then
	modifier_item_wild_bow = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_wild_bow:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_item_wild_bow:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.attack_bonus = self:GetAbilitySpecialValueFor("attack_bonus")
	if IsServer() then
		self:SetStackCount(self:GetAbility():Load("iStackCount"))
	end
end
function modifier_item_wild_bow:IsHidden()
	return self:GetStackCount() == 0
end
function modifier_item_wild_bow:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.attack_bonus = self:GetAbilitySpecialValueFor("attack_bonus")
	if IsServer() then
	end
end
function modifier_item_wild_bow:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_wild_bow:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK] = { self:GetParent() },
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_PHYSICAL_ATTACK_BONUS
	}
end
function modifier_item_wild_bow:GetPhysicalAttackBonus()
	return self:GetStackCount() * self.attack_bonus
end
function modifier_item_wild_bow:OnAttack(params)
	if IsServer() then
		if RollPercentage(self.chance) then
			self:IncrementStackCount()
			self:GetAbility():Save("iStackCount", self:GetStackCount())
		end
	end
end
function modifier_item_wild_bow:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_item_wild_bow:OnTooltip()
	return self:GetStackCount() * self.attack_bonus
end
AbilityClassHook('item_wild_bow', getfenv(1), 'abilities/items/item_wild_bow.lua', { KeyValues.ItemsKv })