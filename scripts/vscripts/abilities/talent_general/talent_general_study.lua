if talent_general_study == nil then
	talent_general_study = class({})
end
function talent_general_study:OnSpellStart()
	local player_levelxp_bonus_pct = self:GetSpecialValueFor('player_levelxp_bonus_pct')
	local iPlayerID = GetPlayerID(self:GetCaster())

	EModifier:RegModifierKeyVal(EMDF_PLAYER_LEVELXP_PERCENT,
	self:GetAbilityName() .. iPlayerID,
	function(iPlayerID2)
		if iPlayerID == iPlayerID2 then
			return player_levelxp_bonus_pct
		end
	end)
end