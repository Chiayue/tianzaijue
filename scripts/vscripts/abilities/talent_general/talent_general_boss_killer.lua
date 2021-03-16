if talent_general_boss_killer == nil then
	talent_general_boss_killer = class({})
end
function talent_general_boss_killer:OnSpellStart()
	local round_gold_bonus_pct = self:GetSpecialValueFor('round_gold_bonus_pct')
	local iPlayerID = GetPlayerID(self:GetCaster())

	EModifier:RegModifierKeyVal(EMDF_ROUND_GOLD_PERCENTAGE,
	self:GetAbilityName() .. iPlayerID,
	function(iPlayerID2)
		if iPlayerID == iPlayerID2 then
			return round_gold_bonus_pct
		end
	end)
end