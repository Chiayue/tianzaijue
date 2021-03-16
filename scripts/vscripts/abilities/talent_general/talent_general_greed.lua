--Abilities
if talent_general_greed == nil then
	talent_general_greed = class({})
end
function talent_general_greed:OnSpellStart()
	local duration_bonus = self:GetSpecialValueFor('duration_bonus')
	local iPlayerID = GetPlayerID(self:GetCaster())

	EModifier:RegModifierKeyVal(EMDF_GOLD_ROUND_DURATION_BONUS,
	self:GetAbilityName() .. iPlayerID,
	function(iPlayerID2)
		if iPlayerID == iPlayerID2 then
			return duration_bonus
		end
	end)
end