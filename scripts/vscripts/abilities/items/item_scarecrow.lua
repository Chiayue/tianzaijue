---稻草人
if nil == item_scarecrow then
	item_scarecrow = class({}, nil, base_ability_attribute)
end
function item_scarecrow:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_scarecrow then
	modifier_item_scarecrow = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_scarecrow:OnCreated(params)
	self:UpdateValues()
end

function modifier_item_scarecrow:IsHidden()
	return false
end
function modifier_item_scarecrow:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_scarecrow:UpdateValues()
	self.damage_pct = self:GetAbilitySpecialValueFor('damage_pct')
	-- self.damage_pct = 100
	self.punish_pct = self:GetAbilitySpecialValueFor('punish_pct')


end
function modifier_item_scarecrow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}
end
function modifier_item_scarecrow:GetModifierTotalDamageOutgoing_Percentage(params)

	local tAtkInfo = GetAttackInfoByDamageRecord(params.record, params.attacker)
	if nil == tAtkInfo then
		--技能
		return self.damage_pct
	else
		--攻击
		return -self.punish_pct
	end
end


-- function modifier_item_scarecrow:GetPhysicalAttackBonusPercentage()
-- 	return self.punish_pct
-- end
AbilityClassHook('item_scarecrow', getfenv(1), 'abilities/items/item_scarecrow.lua', { KeyValues.ItemsKv })