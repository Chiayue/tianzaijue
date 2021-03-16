LinkLuaModifier("modifier_courier_tax", "abilities/courier/r/courier_tax.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if courier_tax == nil then
	courier_tax = class({})
end
function courier_tax:GetIntrinsicModifierName()
	return "modifier_courier_tax"
end
---------------------------------------------------------------------
--Modifiers
if modifier_courier_tax == nil then
	modifier_courier_tax = class({}, nil, eom_modifier)
end
function modifier_courier_tax:OnCreated(params)
	self.tax_bonus_pct = self:GetAbilitySpecialValueFor("tax_bonus_pct")
end
function modifier_courier_tax:OnRefresh(params)
	self.tax_bonus_pct = self:GetAbilitySpecialValueFor("tax_bonus_pct")
end
function modifier_courier_tax:GetTaxPercentage()
	return self.tax_bonus_pct
end
function modifier_courier_tax:EDeclareFunctions()
	return {
		EMDF_TAX_PERCENTAGE
	}
end