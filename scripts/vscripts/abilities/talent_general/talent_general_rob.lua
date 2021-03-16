--Abilities
if talent_general_rob == nil then
	talent_general_rob = class({})
end
function talent_general_rob:OnSpellStart()
	local kill_count = self:GetSpecialValueFor('kill_count')
	local crystal = self:GetSpecialValueFor('crystal')
	local iPlayerID = GetPlayerID(self:GetCaster())
	local iCount = 0
	---@param tData EventData_EnemyDeath
	EventManager:register(ET_ENEMY.ON_DEATH, function(tData)
		if not tData.entindex_attacker then return end
		if tData.entindex_attacker == tData.entindex_killed then return end	--自杀
		if iPlayerID ~= GetPlayerID(EntIndexToHScript(tData.entindex_attacker)) then return end
		iCount = iCount + 1
		if iCount >= kill_count then
			iCount = 0
			PlayerData:ModifyCrystal(iPlayerID, crystal)
		end
	end, nil, nil, self:GetAbilityName() .. iPlayerID)
end