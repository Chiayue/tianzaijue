LinkLuaModifier("modifier_item_rapier_debuff", "abilities/items/item_rapier.lua", LUA_MODIFIER_MOTION_NONE)

---圣灯
if nil == item_rapier then
	item_rapier = class({}, nil, base_ability_attribute)
end
function item_rapier:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_rapier then
	modifier_item_rapier = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_rapier:IsHidden()
	return 0 == self.range
end
function modifier_item_rapier:IsAura()
	return self.unlock_level <= self:GetAbility():GetLevel()
end
function modifier_item_rapier:GetAuraRadius()
	return self.range
end
function modifier_item_rapier:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_item_rapier:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end
function modifier_item_rapier:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_item_rapier:GetModifierAura()
	return "modifier_item_rapier_debuff"
end
function modifier_item_rapier:OnCreated(params)
	self:OnRefresh(params)
end
function modifier_item_rapier:OnRefresh(params)
	self.range = self:GetAbilitySpecialValueFor('range')
	self.damage_per = self:GetAbilitySpecialValueFor('damage_per')
	self.unlock_level = self:GetAbilitySpecialValueFor('unlock_level')
end
function modifier_item_rapier:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2,
	}
end
function modifier_item_rapier:OnTooltip()
	return self.damage_per
end
function modifier_item_rapier:OnTooltip2()
	return self.range
end

--DEBUFF
if nil == modifier_item_rapier_debuff then
	modifier_item_rapier_debuff = class({}, nil, eom_modifier)
end
function modifier_item_rapier_debuff:IsHidden()
	return false
end
function modifier_item_rapier_debuff:IsDebuff()
	return true
end
function modifier_item_rapier_debuff:OnCreated(params)
	self:UpdateValues()
end
function modifier_item_rapier_debuff:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_rapier_debuff:UpdateValues()
	self.range = self:GetAbilitySpecialValueFor('range')
	self.damage_per = self:GetAbilitySpecialValueFor('damage_per')

end
function modifier_item_rapier_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2,
	}
end
function modifier_item_rapier_debuff:EDeclareFunctions()
	return {
		[EMDF_INCOMING_PERCENTAGE] = self.damage_per
	}
end
function modifier_item_rapier_debuff:OnTooltip()
	return self.damage_per
end





AbilityClassHook('item_rapier', getfenv(1), 'abilities/items/item_rapier.lua', { KeyValues.ItemsKv })