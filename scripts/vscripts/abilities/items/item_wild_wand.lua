LinkLuaModifier("modifier_item_wild_wand", "abilities/items/item_wild_wand.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_wild_wand == nil then
	item_wild_wand = class({}, nil, base_ability_attribute)
end
function item_wild_wand:GetIntrinsicModifierName()
	return "modifier_item_wild_wand"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_wild_wand == nil then
	modifier_item_wild_wand = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_wild_wand:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_item_wild_wand:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.magical_atbonus = self:GetAbilitySpecialValueFor("magical_atbonus")
	if IsServer() then
		self:SetStackCount(self:GetAbility():Load("iStackCount"))
	end
end
function modifier_item_wild_wand:IsHidden()
	return self:GetStackCount() == 0
end
function modifier_item_wild_wand:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.magical_atbonus = self:GetAbilitySpecialValueFor("magical_atbonus")
	if IsServer() then
	end
end
function modifier_item_wild_wand:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_wild_wand:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK] = { self:GetParent() },
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_MAGICAL_ATTACK_BONUS
	}
end
function modifier_item_wild_wand:GetMagicalAttackBonus()
	return self:GetStackCount() * self.magical_atbonus
end
function modifier_item_wild_wand:OnAttack(params)
	if IsServer() then
		if RollPercentage(self.chance) then
			self:IncrementStackCount()
			self:GetAbility():Save("iStackCount", self:GetStackCount())
		end
	end
end
function modifier_item_wild_wand:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_item_wild_wand:OnTooltip()
	return self:GetStackCount() * self.magical_atbonus
end
AbilityClassHook('item_wild_bow', getfenv(1), 'abilities/items/item_wild_bow.lua', { KeyValues.ItemsKv })