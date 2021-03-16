LinkLuaModifier("modifier_courier_draw_cost", "abilities/courier/r/courier_draw_cost.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if courier_draw_cost == nil then
	courier_draw_cost = class({})
end
function courier_draw_cost:GetIntrinsicModifierName()
	return "modifier_courier_draw_cost"
end
---------------------------------------------------------------------
--Modifiers
if modifier_courier_draw_cost == nil then
	modifier_courier_draw_cost = class({}, nil, eom_modifier)
end
function modifier_courier_draw_cost:IsHidden()
	return true
end
function modifier_courier_draw_cost:OnCreated(params)
	self.price_reduce = self:GetAbilitySpecialValueFor('price_reduce')
end
function modifier_courier_draw_cost:OnRefresh(params)
	self.price_reduce = self:GetAbilitySpecialValueFor('price_reduce')
end
function modifier_courier_draw_cost:EDeclareFunctions()
	return {
		EMDF_BUY_CARD_DISCOUNT_PERCENTAGE
	}
end
function modifier_courier_draw_cost:GetModifierCardBuyDiscont()
	return self.price_reduce
end