--Abilities
if talent_general_blacksmiths == nil then
	talent_general_blacksmiths = class({})
end
function talent_general_blacksmiths:OnSpellStart()
	local remake_levelup_chance = self:GetSpecialValueFor('remake_levelup_chance')
	local iPlayerID = GetPlayerID(self:GetCaster())

	EModifier:RegModifierKeyVal(EMDF_REMAKE_LEVELUP_CHANCE_PERCENTAGE,
	self:GetAbilityName() .. iPlayerID,
	function(iPlayerID2, iRarity)
		if iPlayerID == iPlayerID2 then
			return remake_levelup_chance
		end
	end)
end