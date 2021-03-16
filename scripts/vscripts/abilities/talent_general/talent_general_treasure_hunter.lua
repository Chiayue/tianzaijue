--Abilities
if talent_general_treasure_hunter == nil then
	talent_general_treasure_hunter = class({})
end
function talent_general_treasure_hunter:OnSpellStart()
	local free_draw_card_bonus_chance = self:GetSpecialValueFor('free_draw_card_bonus_chance')
	local iPlayerID = GetPlayerID(self:GetCaster())
	local iLevel = GetPlayerTalentLevel(iPlayerID, self:GetAbilityName())

	EModifier:RegModifierKeyVal(EMDF_DRAW_CARD_CHANCE_PERCENTAGE,
	self:GetAbilityName() .. iPlayerID,
	function(iPlayerID2, sCardName, sReservoirName)
		if iPlayerID == iPlayerID2 then
			if sReservoirName == 'lucky' then
				local sRarity = DotaTD:GetCardRarity(sCardName)
				if sRarity == 'sr' or sRarity == 'ssr' then
					return free_draw_card_bonus_chance * iLevel
				end
			end
		end
	end)
end