if talent_general_lucky == nil then
	talent_general_lucky = class({})
end
function talent_general_lucky:OnSpellStart()
	local refresh_round_count = self:GetSpecialValueFor('refresh_round_count')
	local iPlayerID = GetPlayerID(self:GetCaster())

	if not PlayerResource:IsValidPlayerID(iPlayerID) then
		return
	end

	-- local free_draw_card_bonus_chance = self:GetSpecialValueFor('free_draw_card_bonus_chance')
	-- EModifier:RegModifierKeyVal(EMDF_DRAW_CARD_CHANCE_PERCENTAGE,
	-- self:GetAbilityName() .. iPlayerID,
	-- function(iPlayerID2, sCardName, sReservoirName)
	-- 	if iPlayerID == iPlayerID2 then
	-- 		if sReservoirName == 'lucky' then
	-- 			local sRarity = string.lower(DotaTD:GetCardRarity(sCardName))
	-- 			if sRarity == 'sr' or sRarity == 'ssr' then
	-- 				return free_draw_card_bonus_chance
	-- 			end
	-- 		end
	-- 	end
	-- end)
	--
	local tLucky = Draw.tPlayerLucky[iPlayerID]
	if nil == tLucky then
		Draw.tPlayerLucky[iPlayerID] = {
			iLucky = 0,
			timeRefresh = 0,
		}
	end
	tLucky.bNoTimeRefresh = true

	local iRoundLast = refresh_round_count
	EventManager:register(ET_GAME.ROUND_CHANGE, function()
		if tLucky.iLucky < LUCKY_MAX then
			iRoundLast = iRoundLast - 1
			if iRoundLast == 0 then
				tLucky.iLucky = tLucky.iLucky + 1
				if tLucky.iLucky >= LUCKY_MAX then
					-- 关闭刷新
					iRoundLast = -1
				else
					iRoundLast = refresh_round_count
				end
			end
		end
	end, nil, nil, self:GetAbilityName() .. iPlayerID)


	---@param tData EventData_PlayerDrawCard
	EventManager:register(ET_PLAYER.ON_DRAW_CARD, function(tData)
		if tData.PlayerID == iPlayerID then
			if tLucky.iLucky < LUCKY_MAX and iRoundLast == -1 then
				iRoundLast = refresh_round_count
			end
		end
	end, nil, nil, self:GetAbilityName() .. iPlayerID)
end