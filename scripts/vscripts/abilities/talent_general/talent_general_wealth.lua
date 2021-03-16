--Abilities
if talent_general_wealth == nil then
	talent_general_wealth = class({})
end
function talent_general_wealth:OnSpellStart()
	local init_gold_bonus = self:GetSpecialValueFor('init_gold_bonus')
	local iPlayerID = GetPlayerID(self:GetCaster())

	EModifier:RegModifierKeyVal(EMDF_INIT_GOLD_BONUS,
	self:GetAbilityName() .. iPlayerID,
	function(iPlayerID2)
		if iPlayerID == iPlayerID2 then
			return init_gold_bonus
		end
	end)
end