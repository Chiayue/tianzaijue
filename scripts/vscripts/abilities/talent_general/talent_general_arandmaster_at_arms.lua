--Abilities
if talent_general_arandmaster_at_arms == nil then
	talent_general_arandmaster_at_arms = class({})
end
function talent_general_arandmaster_at_arms:OnSpellStart()
	local good_item_bonus_chance = self:GetSpecialValueFor('good_item_bonus_chance')
	local iPlayerID = GetPlayerID(self:GetCaster())
	local iLevel = GetPlayerTalentLevel(iPlayerID, self:GetAbilityName())

	EModifier:RegModifierKeyVal(EMDF_DRAW_ITEM_CHANCE_PERCENTAGE,
	self:GetAbilityName() .. iPlayerID,
	function(iPlayerID2, sItemName)
		if iPlayerID == iPlayerID2 then
			local sRarity = Items:GetItemRarity(sItemName)
			if sRarity == 'sr' or sRarity == 'ssr' then
				return good_item_bonus_chance * iLevel
			end
		end
	end)
end