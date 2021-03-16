LinkLuaModifier("modifier_item_panic_button_debuff", "abilities/items/item_panic_button.lua", LUA_MODIFIER_MOTION_NONE)

---圣灯
if nil == item_panic_button then
	item_panic_button = class({}, nil, base_ability_attribute)
end
function item_panic_button:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_panic_button then
	modifier_item_panic_button = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_panic_button:IsHidden()
	return 0 == self.range
end
function modifier_item_panic_button:IsAura()
	return self.unlock_level <= self:GetAbility():GetLevel()
end
function modifier_item_panic_button:GetAuraRadius()
	return self.range
end
function modifier_item_panic_button:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_item_panic_button:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end
function modifier_item_panic_button:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_item_panic_button:GetModifierAura()
	return "modifier_item_panic_button_debuff"
end
function modifier_item_panic_button:OnCreated(params)
	self:UpdateValues()
end
function modifier_item_panic_button:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_panic_button:UpdateValues()
	self.range = self:GetAbilitySpecialValueFor('range')
	self.incoming_per = self:GetAbilitySpecialValueFor('incoming_per')
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
end
function modifier_item_panic_button:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2,
	}
end
function modifier_item_panic_button:OnTooltip()
	return self.incoming_per
end
function modifier_item_panic_button:OnTooltip2()
	return self.range
end

--DEBUFF
if nil == modifier_item_panic_button_debuff then
	modifier_item_panic_button_debuff = class({}, nil, eom_modifier)
end
function modifier_item_panic_button_debuff:IsHidden()
	return false
end
function modifier_item_panic_button_debuff:IsDebuff()
	return false
end
function modifier_item_panic_button_debuff:OnCreated(params)
	self:OnRefresh(params)
end
function modifier_item_panic_button_debuff:OnRefresh(params)
	self.incoming_per = self:GetAbilitySpecialValueFor('incoming_per')
end
function modifier_item_panic_button_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2,
	}
end
function modifier_item_panic_button_debuff:EDeclareFunctions()
	return {
		[EMDF_INCOMING_PERCENTAGE] = -self.incoming_per
	}
end
function modifier_item_panic_button_debuff:OnTooltip()
	return -self.incoming_per
end





AbilityClassHook('item_panic_button', getfenv(1), 'abilities/items/item_panic_button.lua', { KeyValues.ItemsKv })