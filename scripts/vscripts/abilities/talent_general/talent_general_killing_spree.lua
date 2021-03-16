--Abilities
if talent_general_killing_spree == nil then
	talent_general_killing_spree = class({})
end
function talent_general_killing_spree:OnSpellStart()
	local max_stack = self:GetSpecialValueFor('max_stack')
	local reward_per = self:GetSpecialValueFor('reward_per')
	local iPlayerID = GetPlayerID(self:GetCaster())

	local iStack = 0

	-- 杀敌加层
	---@param tData EventData_EnemyDeath
	EventManager:register(ET_ENEMY.ON_DEATH, function(tData)
		if not tData.entindex_attacker then return end
		if tData.entindex_attacker == tData.entindex_killed then return end	--自杀
		if iPlayerID ~= GetPlayerID(EntIndexToHScript(tData.entindex_attacker)) then return end
		if iStack < max_stack then
			iStack = iStack + 1
		end
	end, nil, nil, self:GetAbilityName() .. iPlayerID)

	-- 建筑英雄死亡清零
	---@param tData EventData_PlayerTowerDeath
	EventManager:register(ET_PLAYER.ON_TOWER_DEATH, function(tData)
		if iPlayerID ~= GetPlayerID(tData.hUnit) then return end
		iStack = 0
	end, nil, nil, self:GetAbilityName() .. iPlayerID)

	-- 杀怪金币百分比加成
	EModifier:RegModifierKeyVal(EMDF_KILL_GOLD_PERCENTAGE,
	self:GetAbilityName() .. iPlayerID,
	function(iPlayerID2, params)
		if iPlayerID ~= iPlayerID2 then return end
		if not params or params.unit:IsBoss() then return end	--Boss不加
		return iStack * reward_per
	end)
end