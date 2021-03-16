if nil == TalentGeneral then
	---@class TalentGeneral
	TalentGeneral = {
		---玩家天赋
		tPlayerTalents = {},
		---玩家天赋点
		tPlayerPoint = {},
	}
end
---@type TalentGeneral
local public = TalentGeneral

function public:init(bReload)
	for i = 0, PlayerData:GetPlayerMaxCount() - 1 do
		NetEventData:BindDo('OnUpdateTalents', 'service', 'player_talent_' .. i, self)
		NetEventData:BindDo('OnUpdatePoint', 'service', 'player_talent_point_' .. i, self)
	end

	EventManager:register(EomDebug.PlayerChat, 'OnPlayerChatDebug', self)

	Request:Event("player.talent_level_up", Dynamic_Wrap(public, "ReqAddTalent"), public)
	Request:Event("player.talent_reset", Dynamic_Wrap(public, "ReqResetTalent"), public)

	if bReload then
		DotaTD:EachPlayer(function(_, iPlayerID)
			self:UpdatePlayerTalentGeneral(iPlayerID)
		end)
	end
end



--事件-------------
	do
	function public:OnUpdateTalents(_, sKey, val)
		local tS = string.split(sKey, '_')
		local iPlayerID = tonumber(tS[#tS])
		self.tPlayerTalents[iPlayerID] = val
		self:UpdatePlayerTalentGeneral(iPlayerID)
	end
	function public:OnUpdatePoint(_, sKey, val)
		local tS = string.split(sKey, '_')
		local iPlayerID = tonumber(tS[#tS])
		self.tPlayerPoint[iPlayerID] = val
	end
	function public:OnPlayerChatDebug(iPlayerID, tokens)
		if tokens[1] == '-logtalent' then
			DeepPrintTable(self.tPlayerTalents[iPlayerID])
		elseif tokens[1] == '-addtalent' then
			Request:ServerEvent('player.talent_level_up', iPlayerID, {
				PlayerID = iPlayerID,
				talent_id = tokens[2],
			})
		end
	end
end
--HTTP-------------
	do
	---请求加天赋
	function public:ReqAddTalent(params)
		local iPlayerID = params.PlayerID
		local sTalentID = tostring(params.talent_id)


		-- 验证正确天赋ID
		local sAblt, tAbltKV = GetTalentGeneralAbltKVByID(sTalentID)
		if not tAbltKV then
			return '#error_talent_id'
		end

		--剩余点
		local iTalentPoint = tonumber(NetEventData:GetTableValue('service', 'player_talent_point_' .. iPlayerID)) or 0
		-- 已经消耗
		local iTalentUsePoint = 0

		-- 玩家天赋点不足
		if 1 > iTalentPoint then
			return '#error_talent_point_not_enough'
		end

		-- 验证天赋可学习
		local tPlayerTalent = NetEventData:GetTableValue('service', 'player_talent_' .. iPlayerID)
		if tPlayerTalent then
			if not tAbltKV.Endless or 0 == tAbltKV.Endless then
				local iLevelCur = tonumber(tPlayerTalent[sTalentID])
				if iLevelCur and iLevelCur >= tAbltKV.MaxLevel then
					-- 已经是最大等级
					return	'#error_already_max_level'
				end
			end
			for _, iCount in pairs(tPlayerTalent) do
				iTalentUsePoint = iTalentUsePoint + (tonumber(iCount) or 0)
			end
		end

		-- 前置技能点消耗门槛
		local NeedUseCount = tonumber(tAbltKV.NeedUseCount) or 0
		if iTalentUsePoint < NeedUseCount then
			return '#error_need_use_point_count'
		end

		-- 请求加经验
		local tData = {
			--account id
			uid = PlayerResource:GetSteamAccountID(iPlayerID),
			--天赋ID
			oid = sTalentID,
		}

		local data = Service:POSTSync('player.talent_level_up', tData)
		return data
	end
	---请求重置天赋
	function public:ReqResetTalent(params)
		local iPlayerID = params.PlayerID
		local sTalentID = tostring(params.talent_id)

		-- 已经消耗
		local iTalentUsePoint = 0
		local tPlayerTalent = NetEventData:GetTableValue('service', 'player_talent_' .. iPlayerID)
		if tPlayerTalent then
			for _, iCount in pairs(tPlayerTalent) do
				iTalentUsePoint = iTalentUsePoint + (tonumber(iCount) or 0)
			end
		end
		if 0 >= iTalentUsePoint then
			return 'error_talent_reset_not_need'
		end

		-- 请求加经验
		local tData = {
			--account id
			uid = GetAccountID(iPlayerID),
		}
		local data = Service:POSTSync('player.talent_reset', tData)
		return data
	end
end
--API-------------
	do
	---更新玩家通用天赋技能
	function public:UpdatePlayerTalentGeneral(iPlayerID)
		local hHero = PlayerData:GetHero(iPlayerID)
		if not IsValid(hHero) then return end
		for iPlayerID2, tTalents in pairs(self.tPlayerTalents) do
			if iPlayerID == iPlayerID2 then
				for sID, iLevel in pairs(tTalents) do
					if 0 < iLevel then
						local sAblt, tAbltKV = GetTalentGeneralAbltKVByID(sID)
						if sAblt then
							local hAblt = hHero:AddAbility(sAblt)
							if hAblt then
								hAblt:SetLevel(iLevel)
								if tonumber(tAbltKV.IsImmediate) == 1 then
									--立即使用型天赋
									hAblt:OnSpellStart()
									hHero:RemoveAbilityByHandle(hAblt)
								end
							end
						end
					end
				end
				break
			end
		end
	end
end



return public