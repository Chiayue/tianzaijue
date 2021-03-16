if nil == Consumable then
	---@class Consumable 消耗品管理
	Consumable = {
		tPlayerItems = {}
	}
	Consumable = class({}, Consumable)
end

---@type Consumable
local public = Consumable

function public:init(bReload)
	if not bReload then
	end

	CustomUIEvent('Consumable_UsedItem', Dynamic_Wrap(self, 'OnConsumable_UsedItem'), self)

	Request:Event("game.quick_buy_ingameitem", Dynamic_Wrap(public, "SetQuickBuyIngameitem"), public)
	self:UpdateNetTables()
end

--事件监听************************************************************************************************************************
	do
	---玩家使用消耗品
	function public:OnConsumable_UsedItem(eventSourceIndex, data)
		local iPlayerID = data.PlayerID
		local entIndex = data.entIndex
		local name = data.name
		local sid = data.sid
		local pid = data.pid
		local buyuse = data.buyuse

		local hAblt = EntIndexToHScript(entIndex)
		if not hAblt
		or GetPlayerID(hAblt:GetCaster()) ~= iPlayerID
		or PlayerData:IsPlayerDeath(iPlayerID)
		or not hAblt:IsCooldownReady()
		then
			return
		end

		local tData = {
			uid = GetAccountID(iPlayerID),
			sid = sid,
		}
		if hAblt:CastFilterResult() ~= UF_FAIL_CUSTOM then
			-- ExecuteOrder(hAblt:GetCaster(), DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, hAblt)
			hAblt:UseResources(false, false, true)
			hAblt:OnSpellStart()

			if buyuse == 1 then
				tData.pid = pid
				-- 购买并使用
				Service:POST('item.buyuse', tData, function(data)
					-- DeepPrintTable(data)
					-- if data and data.status == 0 then
					-- 	ExecuteOrder(hAblt:GetCaster(), DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, hAblt)
					-- else
					-- 	ErrorMessage(iPlayerID, 'dota_hud_error_not_enough_cunsumable')
					-- end
				end)
			else
				Service:POST('item.use', tData, function(data)
					-- if data and data.status == 0 then
					-- 	ExecuteOrder(hAblt:GetCaster(), DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, hAblt)
					-- else
					-- 	ErrorMessage(iPlayerID, 'dota_hud_error_not_enough_cunsumable')
					-- end
				end)
			end
		end
	end
end
--事件监听************************************************************************************************************************
	do
	---玩家英雄生产
	---@param tEvent EventData_ON_PLAYER_HERO_SPAWNED
	function public:OnPlayerHeroSpawned(tEvent)
		local iPlayerID = tEvent.PlayerID
		local hUnit = tEvent.hUnit

		self.tPlayerItems[iPlayerID] = self.tPlayerItems[iPlayerID] or {}
		---添加消耗品技能
		for sName, _ in pairs(KeyValues.ConsumableKv) do
			local sid = tonumber(KeyValues.ConsumableKv[sName].UniqueID)
			local pid = tonumber(self:GetItemProductID(sid))
			if not hUnit:HasAbility(sName) then
				local hAblt = hUnit:AddAbility(sName)
				hAblt:SetLevel(1)
				self.tPlayerItems[iPlayerID][sName] = {
					entIndex = hAblt:GetEntityIndex(),
					sid = sid,
					pid = pid,
				}
			end
		end

		self:UpdateNetTables()
	end
end

function public:UpdateNetTables()
	for iPlayerID, v in pairs(self.tPlayerItems) do
		NetEventData:SetTableValue("common", "consumable_player_" .. iPlayerID, v)
	end
end

--- 获取消耗品商店id
function public:GetItemProductID(orderid)
	local table = {
		[1129001] = 8884001, -- 命运骰子
		[1120001] = 8884003, -- 星光闪耀
		[1120002] = 8884004, -- 轮回之力
		[1120003] = 8884005, -- 心跳停止
	}

	return table[orderid]
end

function public:SetQuickBuyIngameitem(params)
	local iPlayerID = params.PlayerID


	local data = Service:POSTSync('game.quick_buy_ingameitem', {
		uid = GetAccountID(iPlayerID),
	})

	return data
end

return public