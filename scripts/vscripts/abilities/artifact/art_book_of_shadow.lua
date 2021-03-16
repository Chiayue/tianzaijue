LinkLuaModifier("modifier_art_book_of_shadow", "abilities/artifact/art_book_of_shadow.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if art_book_of_shadow == nil then
	art_book_of_shadow = class({}, nil, artifact_base)
end
function art_book_of_shadow:GetIntrinsicModifierName()
	return "modifier_art_book_of_shadow"
end

------------------------------------------------------------------------------
if modifier_art_book_of_shadow == nil then
	modifier_art_book_of_shadow = class({}, nil, eom_modifier)
end
function modifier_art_book_of_shadow:OnCreated(params)
	self.fixed_sell_card_gold_pct = self:GetAbilitySpecialValueFor("fixed_sell_card_gold_pct")
end
function modifier_art_book_of_shadow:OnRefresh(params)
	self.fixed_sell_card_gold_pct = self:GetAbilitySpecialValueFor("fixed_sell_card_gold_pct")
end
function modifier_art_book_of_shadow:OnDestroy(params)
end
function modifier_art_book_of_shadow:EDeclareFunctions()
	return {
		EMDF_FIXED_SELL_CARD_GOLD_PERCENT
	}
end
function modifier_art_book_of_shadow:GetModifierFixedSellCardGoldPercent()
	return self.fixed_sell_card_gold_pct
end