LinkLuaModifier("modifier_art_lucky_cat", "abilities/artifact/art_lucky_cat.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--招财猫
if art_lucky_cat == nil then
	art_lucky_cat = class({}, nil, artifact_base)
end
function art_lucky_cat:GetIntrinsicModifierName()
	return "modifier_art_lucky_cat"
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_lucky_cat == nil then
	modifier_art_lucky_cat = class({}, nil, eom_modifier)
end
function modifier_art_lucky_cat:OnCreated(params)
	self.goldbuy_discount = self:GetAbilitySpecialValueFor('goldbuy_discount')
	if IsServer() then
	end
end
function modifier_art_lucky_cat:OnRefresh(params)
	self.goldbuy_discount = self:GetAbilitySpecialValueFor('goldbuy_discount')
	if IsServer() then
	end
end
function modifier_art_lucky_cat:OnDestroy()
	if IsServer() then
	end
end

function modifier_art_lucky_cat:EDeclareFunctions()
	return {
		EMDF_BUY_CARD_DISCOUNT_PERCENTAGE
	}
end
function modifier_art_lucky_cat:GetModifierCardBuyDiscont(sCardName)
	return self.goldbuy_discount
end