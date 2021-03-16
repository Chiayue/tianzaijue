--Abilities
if talent_general_accrual == nil then
	talent_general_accrual = class({})
end
function talent_general_accrual:OnSpellStart()
	local gold_pct = self:GetSpecialValueFor('gold_pct')
	local max_gold = self:GetSpecialValueFor('max_gold')
	local iPlayerID = GetPlayerID(self:GetCaster())

	EventManager:register(ET_BATTLE.ON_BATTLEING_END, function()
		local iGold = math.min(max_gold, PlayerData:GetGold(iPlayerID) * gold_pct * 0.01)
		if 0 < iGold then
			PlayerData:ModifyGold(iPlayerID, iGold)
		end
	end, nil, nil, self:GetAbilityName() .. iPlayerID)
end