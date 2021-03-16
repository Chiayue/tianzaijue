if Items == nil then
	---@class Items
	Items = {
		---@type ItemData[][] 玩家全部物品数据
		tPlayerItems = {
		-- [iPlayerID] = {
		-- 	[iItemID] = {
		-- 		sItemName 物品名
		-- 		iLevel 物品等级(跟随随机掉落物品等级，杀boss后升级)
		-- 		iStar 物品星级(利用魂晶升星)
		-- 		iStarBonus 物品星级奖励 (通过神器等获得的奖励。物品实际星级 = iStar + iStarBonus)
		-- 		iItemID 物品id(在tPlayerItems表中的index)
		-- 		iOwnerEntIndex 物品拥有者 ent index (default: -1)
		-- 		iOwnerCardID 物品所在卡牌ID (default: -1)
		-- 		sOwnerName 物品拥有者名字 (default: "")
		-- 		iItemEntIndex 物品 ent index (default: -1)
		-- 		iItemSlot 物品所在槽位 (default: -1)
		-- 		iUISlot 物品所在UI的槽位
		-- 		tCDInfo
		-- 	}
		-- }
		},
		--- 修改器数据
		tModifyData = {
		-- tStarBonus
		}
	}
	Items = class({})
end
---@class Items
local public = Items

-- 检测物品
CHECK_ITEM_RESULT_SUCCESS = 0				-- 成功
CHECK_ITEM_RESULT_FAIL_FALSE_OWNER = 1		-- 失败，非所属
CHECK_ITEM_RESULT_FAIL_UNQUALIFIED = 2		-- 失败，无资格

function public:init(bReload)
	if not bReload then
		self.tPlayerItems = {}
		self.tModifyData = {}
	end

	self.tPublicArea = {}
	local public_warehouses = Entities:FindAllByName("public_warehouse")
	for k, public_warehouse in pairs(public_warehouses) do
		local origin = public_warehouse:GetAbsOrigin()
		local angles = public_warehouse:GetAngles()
		local bounds = public_warehouse:GetBounds()
		local vMin = RotatePosition(Vector(0, 0, 0), angles, bounds.Mins) + origin
		local vMax = RotatePosition(Vector(0, 0, 0), angles, bounds.Maxs) + origin

		table.insert(self.tPublicArea, {
			Vector(vMin.x, vMin.y, 0),
			Vector(vMax.x, vMin.y, 0),
			Vector(vMax.x, vMax.y, 0),
			Vector(vMin.x, vMax.y, 0),
		})
	end

	CustomUIEvent("Items_Give", Dynamic_Wrap(self, "OnItems_Give"), self)
	CustomUIEvent("Items_Take", Dynamic_Wrap(self, "OnItems_Take"), self)
	CustomUIEvent("Items_LevelUp", Dynamic_Wrap(self, "OnItems_LevelUp"), self)
	CustomUIEvent("Items_Remake", Dynamic_Wrap(self, "OnItems_Remake"), self)
	-- 调试模式删除装备
	-- CustomUIEvent("Items_Remove", Dynamic_Wrap(self, "OnItems_Remove"), self)
end

--UI事件************************************************************************************************************************
	do
	--给单位物品
	function public:OnItems_Give(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		local hTarget = EntIndexToHScript(events.target_entid)
		local iItemID = events.item_id
		local iTargetSolt = tonumber(events.item_slot) or self:GetUnitEmptySolt(hTarget) or DOTA_ITEM_SLOT_1

		if not IsValid(hTarget) then
			return
		end

		local iPlayerID_Target = GetPlayerID(hTarget)
		if iPlayerID_Target ~= iPlayerID then
			ErrorMessage(iPlayerID, '#dota_hud_error_item_cant_give_other')
			return
		end

		--给物品
		if hTarget:HasModifier('modifier_eom_debug_unit') then
			self:ItemGiveDebugUnit(iPlayerID, iItemID, hTarget, iTargetSolt)
		else
			self:ItemGive(iPlayerID, iItemID, hTarget, iTargetSolt)
		end
		EmitSoundForPlayer("T3.ItemEquip", iPlayerID)
	end
	--脱下单位物品
	function public:OnItems_Take(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		self:ItemTake(iPlayerID, events.item_id)
		EmitSoundForPlayer("T3.ItemUnEquip", iPlayerID)
	end
	---物品升星
	function public:OnItems_LevelUp(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		self:ItemLevelUp(iPlayerID, events.item_id)
	end
	---物品重铸
	function public:OnItems_Remake(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		self:ItemRemake(iPlayerID, events.item_id)
	end
	-- 删除物品(调试模式)
	function public:OnItems_Remove(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		-- 移除玩家装备
		local iItemID = events.item_id
		self:RemoveItem(iPlayerID, iItemID)
	end
end

--玩家加载完成
function public:InitPlayerItemData(tEvent)
	local iPlayerID = tEvent.PlayerID
	self.tPlayerItems[iPlayerID] = {}
	self.tModifyData[iPlayerID] = {}
	self:UpdateNetTables()
end

--更新网表
function public:UpdateNetTables()
	CustomNetTables:SetTableValue("items", "player_items", self.tPlayerItems)
	for iPlayerID, t in pairs(self.tModifyData) do
		CustomNetTables:SetTableValue("items", "player_items_modify_" .. iPlayerID, {
			remake_cost_pct = self:GetRemakeCrystalPercentage(iPlayerID),
			remake_chance_pct = {
				GetRemakeLevelupChancePercentage(iPlayerID, 1),
				GetRemakeLevelupChancePercentage(iPlayerID, 2),
				GetRemakeLevelupChancePercentage(iPlayerID, 3),
				GetRemakeLevelupChancePercentage(iPlayerID, 4),
			}
		})
	end
end
----------------------------------------------------------------------------------------------------
-- 修改器
--- 修改物品星级奖励
function public:GetModifierItemStarBonus(hSource, func)
	local iPlayerID = hSource:GetPlayerID()
	local tPlayerModifyData = self.tModifyData[iPlayerID]
	if tPlayerModifyData then
		tPlayerModifyData.tStarBonus = tPlayerModifyData.tStarBonus or {}
		local tModify = tPlayerModifyData.tStarBonus
		if tModify[hSource] ~= func then
			tModify[hSource] = func
		end
		self:RefreshPlayerItemStar(iPlayerID)
	end
end

--- 刷新玩家物品星级奖励数据
---@param iPlayerID number 参数为nil时刷新所有玩家数据
function public:RefreshPlayerItemStarBonus(iPlayerID)
	if iPlayerID == nil then
		for iPlayerID, tPlayerModifyData in pairs(self.tModifyData) do
			local tPlayerItem = self.tPlayerItems[iPlayerID]
			local iBonus = self:GetPlayerItemStarBonus(iPlayerID)
			for itemid, item in pairs(tPlayerItem) do
				item.iStarBonus = iBonus

			end
		end
	else
		local tPlayerItem = self.tPlayerItems[iPlayerID]
		local iBonus = self:GetPlayerItemStarBonus(iPlayerID)
		for itemid, item in pairs(tPlayerItem) do
			item.iStarBonus = iBonus

		end
	end
	self:UpdateNetTables()
end

--- 获取玩家物品星级奖励
function public:GetPlayerItemStarBonus(iPlayerID)
	local tPlayerModifyData = self.tModifyData[iPlayerID]
	if tPlayerModifyData == nil then
		return 0
	end

	local iBonus = 0
	local tModify = tPlayerModifyData.tStarBonus

	if tModify ~= nil then
		for hSource, func in pairs(tModify) do
			if hSource and func then
				local bonus = tonumber(func(hSource))
				if bonus then
					iBonus = iBonus + bonus
				end
			end
		end
	end
	return iBonus
end

--- 刷新玩家物品星级（刷新单位身上的装备, 同时刷新玩家物品星级奖励）
function public:RefreshPlayerItemStar(iPlayerID)
	local tPlayerItem = self.tPlayerItems[iPlayerID]
	if tPlayerItem == nil then
		return
	end
	self:RefreshPlayerItemStarBonus(iPlayerID)
	for iItemID, tItem in pairs(tPlayerItem) do
		if tItem.iItemEntIndex > -1 then
			local hItem = EntIndexToHScript(tItem.iItemEntIndex)
			local iLevel = tItem.iStarBonus + tItem.iStar
			if IsValid(hItem) then
				hItem:SetLevel(iLevel)

				local hUnit = EntIndexToHScript(tItem.iOwnerEntIndex)
				if IsValid(hUnit) then
					local hBuilding = hUnit:GetBuilding()
					if IsValid(hBuilding:GetUnitEntity()) then

						hBuilding:CloneSyncItems(hBuilding:GetUnitEntity())
					end
				end
			end
		end
	end
end

---获取玩家重铸时升级品质的额外概率百分比
function GetRemakeLevelupChancePercentage(iPlayerID, iRarity)
	local fPct = 0
	for key, tVals in pairs(EModifier:GetModifierVals(EMDF_REMAKE_LEVELUP_CHANCE_PERCENTAGE, iPlayerID, iRarity)) do
		local iVal = tonumber(tVals[1]) or 0
		fPct = fPct + iVal
	end
	return fPct
end
if not EModifier:HasModifier(EMDF_REMAKE_LEVELUP_CHANCE_PERCENTAGE) then
	EModifier:CreateModifier(EMDF_REMAKE_LEVELUP_CHANCE_PERCENTAGE, function()
		public:UpdateNetTables()
	end)
end

---修改玩家重铸时魂晶消耗百分比
function public:GetModifyRemakeCrystalPercentage(hSource, func)
	local iPlayerID = hSource:GetPlayerID()
	local tPlayerModifyData = self.tModifyData[iPlayerID]
	if tPlayerModifyData then
		tPlayerModifyData.tRemakeCostPct = tPlayerModifyData.tRemakeCostPct or {}
		local tModify = tPlayerModifyData.tRemakeCostPct
		if tModify[hSource] ~= func then
			tModify[hSource] = func
			self:UpdateNetTables()
		end
	end
end
---获取玩家重铸时魂晶消耗百分比
function public:GetRemakeCrystalPercentage(iPlayerID)
	local tPlayerModifyData = self.tModifyData[iPlayerID]
	if tPlayerModifyData == nil then
		return 100
	end

	local iBonus = 100
	local tModify = tPlayerModifyData.tRemakeCostPct

	if tModify ~= nil then
		for hSource, func in pairs(tModify) do
			if hSource and func then
				local bonus = tonumber(func(hSource))
				if bonus then
					iBonus = iBonus + bonus
				end
			end
		end
	end
	return iBonus
end

----------------------------------------------------------------------------------------------------
-- core
--- 通过iItemEntIndex 获取物品数据
function public:GetItemDataByItemEntIndex(iItemEntIndex, iPlayerID)
	for id, tItemDatas in pairs(self.tPlayerItems) do
		if iPlayerID == nil or iPlayerID == id then
			for iItemID, tItemData in pairs(tItemDatas) do
				if tItemData.iItemEntIndex == iItemEntIndex then
					return tItemData
				end
			end
		end
	end
end
--- 获取单位的空槽位
function public:GetUnitEmptySolt(hUnit)
	if IsValid(hUnit) then
		for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_3 do
			if hUnit.GetItemInSlot then
				local hItem = hUnit:GetItemInSlot(i)
				if not IsValid(hItem) then
					return i
				end
			end
		end
	end
end
--
function public:IsPositionInPublicArea(vPosition)
	for k, polygon in pairs(self.tPublicArea) do
		if IsPointInPolygon(vPosition, polygon) then
			return true
		end
	end
	return false
end

--是否装备已满
function public:IsItemMax(hTarget)
	for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_9 do
		if self:IsValidItemSlot(i) then
			if hTarget:GetItemInSlot(i) then
			else
				return false
			end
		end
	end
	return true
end
function public:IsValidItemSlot(iSlot)
	return nil ~= ITEM_UNLOCK_LEVEL[iSlot]
end
--- 获取物品升星需要魂晶数
function public:GetItemLevelUpConsumeCrystal(iPlayerID, iItemID)
	local tData = self.tPlayerItems[iPlayerID][iItemID]
	if not tData then return 0 end

	local iCrystal = ITEM_LEVELUP_STAR_COST_GOLD[tData.iRarity][tData.iStar]

	return iCrystal or 0
end
--- 获取物品重铸需要魂晶数
function public:GetItemRemakeConsumeCrystal(iPlayerID, iItemID)
	local tData = self.tPlayerItems[iPlayerID][iItemID]
	if not tData then return 0 end

	local iCrystal = math.ceil(ITEM_REMAKE_STAR_COST_GOLD[tData.iRarity] * self:GetRemakeCrystalPercentage(iPlayerID) * 0.01)

	return iCrystal or 0
end
--- 获取物品重铸概率
function public:GetItemRemakeProbability(iRarity, iPlayerID)
	return (ITEM_REMAKE_CHANCE[iRarity] or 0) * (100 + GetRemakeLevelupChancePercentage(iPlayerID, iRarity)) * 0.01
end
--- 获取物品星级
function public:GetItemLevel(iPlayerID, iItemID)
	local tData = self.tPlayerItems[iPlayerID][iItemID]
	if not tData then return 0 end

	self:RefreshPlayerItemStarBonus(iPlayerID)
	return tData.iStar + tData.iStarBonus
end
----------------------------------------------------------------------------------------------------
-- operator
--- 给玩家添加装备
function public:AddItem(iPlayerID, sItemName)
	local tKV = KeyValues.ItemsKv[sItemName]
	if not tKV then
		ErrorMessage(iPlayerID, 'error_item : ' .. sItemName)
		return false
	end

	---@class ItemData
	local tData = {}
	tData.sItemName = sItemName
	tData.iLevel = tonumber(tKV.ItemLevel or 1) --等级
	tData.iStar = 1		--星级
	tData.iStarBonus = 0  --星级奖励
	tData.iOwnerEntIndex = -1
	tData.iOwnerCardID = -1
	tData.sOwnerName = ""
	tData.iItemEntIndex = -1
	tData.iItemSlot = -1
	tData.iItemID = DoUniqueString('iItemID')
	tData.iRarity = tonumber(tKV.Rarity or 1)

	local iSlotMax = 0
	for k, v in pairs(self.tPlayerItems[iPlayerID]) do
		if iSlotMax < v.iUISlot then
			iSlotMax = v.iUISlot
		end
	end
	tData.iUISlot =	iSlotMax + 1

	self.tPlayerItems[iPlayerID][tData.iItemID] = tData

	if string.find(sItemName, 'item_unknowned_item') == nil then
		Contract:OnPlayerAddItemOrArtifact(iPlayerID, sItemName)
	end

	GameTimer(1, function()
		if string.find(sItemName, 'item_unknowned_item') then
			Items:RemoveItem(iPlayerID, tData.iItemID, tData.iRarity)
			local sItemPools = table.concat({ "ItemLevel_", tData.iRarity })
			local tItem = SelectItem:GetRandomItems(1, iPlayerID, sItemPools, {})
			if tItem[1] then
				local tItemNew = Items:AddItem(iPlayerID, tItem[1].sItemName)
			end
		end
	end)

	self:UpdateNetTables()

	return tData
end
-- 移除玩家装备
function public:RemoveItem(iPlayerID, iItemID)
	for iItemID2, tData in pairs(self.tPlayerItems[iPlayerID]) do
		if iItemID2 == iItemID then
			self:ItemTake(iPlayerID, iItemID)
			self.tPlayerItems[iPlayerID][iItemID] = nil
			self:UpdateNetTables()
			return
		end
	end
end
-- 移除玩家所有装备
function public:RemoveAllItem(iPlayerID)
	for iItemID, tData in pairs(self.tPlayerItems[iPlayerID]) do
		self:ItemTake(iPlayerID, iItemID)
		self.tPlayerItems[iPlayerID][iItemID] = nil
	end
	self:UpdateNetTables()
end

--- 给英雄添加装备
function public:ItemGive(iPlayerID, iItemID, hTarget, iTargetSolt)
	local tData = self.tPlayerItems[iPlayerID][iItemID]
	if not tData then return end

	-- 判断有效单位
	if not IsValid(hTarget) then return end
	if not BuildSystem:IsBuilding(hTarget) then return end

	if iTargetSolt == nil then
		iTargetSolt = tData.iItemSlot
	end
	-- 判断有效槽位
	if not self:IsValidItemSlot(iTargetSolt) then
		ErrorMessage(iPlayerID, '#dota_hud_error_item_slot_error')
		return
	end
	local hBuilding = hTarget:GetBuilding()
	hTarget = hBuilding:GetUnitEntity()

	local hItem = EntIndexToHScript(tData.iItemEntIndex)

	local hItemBefore = hTarget:GetItemInSlot(iTargetSolt)
	if IsValid(hItemBefore) and nil ~= string.find(hItemBefore:GetName(), 'item_lock') then
		--物品格未解锁
		ErrorMessage(iPlayerID, '#dota_hud_error_item_slot_not_unlock')
		return
	end

	-- 物品已经装备在某单位身上
	if IsValid(hItem) then
		-- 装备到源位置 return
		if hItem == hItemBefore then return end

		-- 在目标单位 交换物品位置
		if hItem:GetParent() == hTarget then
			hTarget:SwapItems(iTargetSolt, hItem:GetItemSlot())
			if IsValid(hBuilding:GetUnitEntity()) then
				hBuilding:CloneSyncItems(hBuilding:GetUnitEntity())
			end

			-- 同步并更新数据
			if IsValid(hItemBefore) then
				local tItemData = self:GetItemDataByItemEntIndex(hItemBefore:entindex())
				tItemData.iItemSlot = hItem:GetItemSlot()
			end
			tData.iItemSlot = iTargetSolt
			self:UpdateNetTables()
			return
		end

		-- 在其他单位 卸下装备
		self:ItemTake(iPlayerID, iItemID)
	end

	if tData.iOwnerCardID ~= -1 then
		-- 装备在卡牌上 卸下卡牌上的物品
		HeroCardData:RemoveCardItem(iPlayerID, tData.iOwnerCardID, iItemID)
	end

	-- 指定槽位有物品
	if IsValid(hItemBefore) then
		local tItemData = self:GetItemDataByItemEntIndex(hItemBefore:entindex())
		self:ItemTake(iPlayerID, tItemData.iItemID)
	end

	--限制数量
	if self:IsItemMax(hTarget) then
		ErrorMessage(iPlayerID, '#dota_hud_error_item_max')
		return
	end

	--添加物品
	local hItem = CreateItem(tData.sItemName, nil, hTarget)
	if hItem then
		tData.iItemEntIndex = hItem:entindex()

		hItem = hTarget:AddItem(hItem)

		if hItem:GetParent() ~= hTarget and hItem:GetContainer() == nil then
			tData.iItemEntIndex = nil
			UTIL_RemoveImmediate(hItem)
			ErrorMessage(iPlayerID, 'error')
			return
		end

		-- 星级=技能等级
		hItem:SetLevel(self:GetItemLevel(iPlayerID, iItemID))

		--同步CD
		if tData.tCDInfo then
			local fCDLast = tData.tCDInfo.fCDLast - (GameRules:GetGameTime() - tData.tCDInfo.time)
			if 0 < fCDLast then
				hItem:StartCooldown(fCDLast)
			end
			tData.tCDInfo = nil
		end
		--同步槽位
		hTarget:SwapItems(iTargetSolt, hItem:GetItemSlot())

		--更新数据
		tData.iOwnerEntIndex = hTarget:GetEntityIndex()
		tData.iOwnerCardID = -1
		tData.sOwnerName = hTarget:GetUnitName()
		tData.iItemSlot = iTargetSolt
		hItem.tItemData = tData
		self:UpdateNetTables()

		if BuildSystem:IsBuilding(hTarget) then
			EventManager:fireEvent(ET_PLAYER.ON_TOWER_NEW_ITEM_ENTITY, {
				PlayerID = iPlayerID,
				hItem = hItem,
				hBuilding = hTarget:GetBuilding(),
			})
		end

		return hItem
	end
end

--- 给英雄添加装备
function public:ItemGiveDebugUnit(iPlayerID, iItemID, hTarget, iTargetSolt)
	local tData = self.tPlayerItems[iPlayerID][iItemID]
	if not tData then return end

	-- 判断有效单位
	if not IsValid(hTarget) then return end
	if iTargetSolt == nil then
		iTargetSolt = tData.iItemSlot
	end
	-- 判断有效槽位
	if not self:IsValidItemSlot(iTargetSolt) then
		ErrorMessage(iPlayerID, '#dota_hud_error_item_slot_error')
		return
	end
	local hItem = EntIndexToHScript(tData.iItemEntIndex)
	local hItemBefore = hTarget:GetItemInSlot(iTargetSolt)

	-- 物品已经装备在某单位身上
	if IsValid(hItem) then
		-- 装备到源位置 return
		if hItem == hItemBefore then return end

		-- 在目标单位 交换物品位置
		if hItem:GetParent() == hTarget then
			hTarget:SwapItems(iTargetSolt, hItem:GetItemSlot())

			-- 同步并更新数据
			if IsValid(hItemBefore) then
				local tItemData = self:GetItemDataByItemEntIndex(hItemBefore:entindex())
				tItemData.iItemSlot = hItem:GetItemSlot()
			end
			tData.iItemSlot = iTargetSolt
			self:UpdateNetTables()
			return
		end

		-- 在其他单位 卸下装备
		self:ItemTake(iPlayerID, iItemID)
	end

	if tData.iOwnerCardID ~= -1 then
		-- 装备在卡牌上 卸下卡牌上的物品
		HeroCardData:RemoveCardItem(iPlayerID, tData.iOwnerCardID, iItemID)
	end

	-- 指定槽位有物品
	if IsValid(hItemBefore) then
		local tItemData = self:GetItemDataByItemEntIndex(hItemBefore:entindex())
		self:ItemTake(iPlayerID, tItemData.iItemID)
	end

	--限制数量
	if self:IsItemMax(hTarget) then
		ErrorMessage(iPlayerID, '#dota_hud_error_item_max')
		return
	end

	--添加物品
	local hItem = CreateItem(tData.sItemName, nil, hTarget)
	if hItem then
		hItem = hTarget:AddItem(hItem)
		if hItem:GetParent() ~= hTarget and hItem:GetContainer() == nil then
			UTIL_RemoveImmediate(hItem)
			ErrorMessage(iPlayerID, 'error')
			return
		end

		-- 星级=技能等级
		hItem:SetLevel(self:GetItemLevel(iPlayerID, iItemID))

		--同步CD
		if tData.tCDInfo then
			local fCDLast = tData.tCDInfo.fCDLast - (GameRules:GetGameTime() - tData.tCDInfo.time)
			if 0 < fCDLast then
				hItem:StartCooldown(fCDLast)
			end
			tData.tCDInfo = nil
		end
		--同步槽位
		hTarget:SwapItems(iTargetSolt, hItem:GetItemSlot())

		--更新数据
		tData.iOwnerEntIndex = hTarget:GetEntityIndex()
		tData.iOwnerCardID = -1
		tData.sOwnerName = hTarget:GetUnitName()
		tData.iItemEntIndex = hItem:entindex()
		tData.iItemSlot = iTargetSolt

		hItem.tItemData = tData
		self:UpdateNetTables()
		return hItem
	end
end

---装备升星
function public:ItemLevelUp(iPlayerID, iItemID)

	local tData = self.tPlayerItems[iPlayerID][iItemID]
	if not tData then return end

	local iCrystal = self:GetItemLevelUpConsumeCrystal(iPlayerID, iItemID)
	if PlayerData:GetCrystal(iPlayerID) < iCrystal then
		return
	end

	--判断星级上限
	local tItemDataKv = KeyValues.ItemsKv[tData.sItemName]
	local iMaxStar = tItemDataKv.MaxUpgradeLevel or tItemDataKv.MaxLevel
	local iCurStar = self:GetItemLevel(iPlayerID, iItemID)
	if iCurStar >= iMaxStar then
		ErrorMessage(iPlayerID, '#dota_hud_error_item_star_limit')
		return
	end

	-- 修改水晶数量
	PlayerData:ModifyCrystal(iPlayerID, -iCrystal)

	local tEvent = {
		PlayerID = iPlayerID,
		iItemID = iItemID,
		level = 1
	}

	EventManager:fireEvent(ET_PLAYER.ON_ITEM_LVLUPDATE, tEvent)

	self:SetItemLevel(iPlayerID, iItemID, tData.iStar + tEvent.level)

	-- 物品升星
	self:UpdateNetTables()
end

---装备重铸
function public:ItemRemake(iPlayerID, iItemID)
	local tData = self.tPlayerItems[iPlayerID][iItemID]
	if not tData then return end

	local iCrystal = self:GetItemRemakeConsumeCrystal(iPlayerID, iItemID)
	if PlayerData:GetCrystal(iPlayerID) < iCrystal then
		ErrorMessage(iPlayerID, "dota_hud_error_not_enough_crystal")
		return
	end

	local tItemDataKv = KeyValues.ItemsKv[tData.sItemName]
	local iItemRarity = tItemDataKv.Rarity

	local iChanceUpgrade = self:GetItemRemakeProbability(iItemRarity, iPlayerID)
	local iChanceKeep = 100 - iChanceUpgrade
	local iItemRarityWill = iItemRarity + 1

	self:RemoveItem(iPlayerID, iItemID)

	---@type ItemData
	local tItemNew
	local tItem
	-- 随机一个装备名字
	if iItemRarity ~= 4 then
		if iChanceKeep <= 0 then
			local sItemPools = table.concat({ "ItemLevel_", iItemRarityWill })
			tItem = SelectItem:GetRandomItems(1, iPlayerID, sItemPools, { tData.sItemName })
			if tItem[1] then
				tItemNew = self:AddItem(iPlayerID, tItem[1].sItemName)
			end
		else
			local sItemPools = table.concat({ "ItemLevel_", iItemRarity, "#", iChanceKeep, " | ", "ItemLevel_", iItemRarityWill, "#", iChanceUpgrade })
			tItem = SelectItem:GetRandomItems(1, iPlayerID, sItemPools, { tData.sItemName })
			if tItem[1] then
				tItemNew = self:AddItem(iPlayerID, tItem[1].sItemName)
			end
		end
	else
		local sItemPools = "ItemLevel_4"
		tItem = SelectItem:GetRandomItems(1, iPlayerID, sItemPools, { tData.sItemName })
		if tItem[1] then
			tItemNew = self:AddItem(iPlayerID, tItem[1].sItemName)
		end
	end

	if tItem[1] then
		local rItem = KeyValues.ItemsKv[tItem[1].sItemName]
		local rItemRarity = rItem.Rarity
		if tonumber(rItemRarity) > tonumber(iItemRarity) then
			EmitSoundForPlayer('T3.knockout', iPlayerID)
		end
	end
	-- 修改水晶数量
	PlayerData:ModifyCrystal(iPlayerID, -iCrystal)

	if tItemNew then
		tItemNew.iUISlot = tData.iUISlot
	end

	---@class EventData_PlayerItemRemake
	local tEventData = {
		PlayerID = iPlayerID,
		tItemData = tItemNew,
		tItemDataOld = tData,
	}
	EventManager:fireEvent(ET_PLAYER.ON_ITEM_REMAKE, tEventData)
	self:UpdateNetTables()

end


function public:SetItemLevel(iPlayerID, iItemID, iLevel)
	local tData = self.tPlayerItems[iPlayerID][iItemID]
	if not tData then return end

	local iCurStar = self:GetItemLevel(iPlayerID, iItemID)

	--如果物品星级降至0
	if iLevel <= 0 then
		iLevel = 1
	end
	tData.iStar = iLevel

	--设置物品实体等级
	if tData.iItemEntIndex > -1 then
		local hItem = EntIndexToHScript(tData.iItemEntIndex)
		hItem:SetLevel(iLevel)
	end
end

--- 装备给卡牌
function public:ItemGiveCard(iPlayerID, iItemID, iCardID, iTargetSolt)
	local tData = self.tPlayerItems[iPlayerID][iItemID]
	if not tData then return end

	self:RemoveItemEntity(iPlayerID, iItemID)

	--卡牌上添加物品
	HeroCardData:AddCardItem(iPlayerID, iCardID, {
		iItemID = iItemID,
		sItemName = tData.sItemName,
		tCDInfo = tData.tCDInfo,
		iItemSlot = iTargetSolt,
	})

	--装备上记录卡牌
	tData.iOwnerCardID = iCardID
	tData.iItemSlot = iTargetSolt
	tData.iOwnerEntIndex = -1
	tData.iItemEntIndex = -1
	tData.sOwnerName = HeroCardData:GetPlayerCardName(iPlayerID, iCardID)
	self:UpdateNetTables()
end

--- 移除装备实体
function public:RemoveItemEntity(iPlayerID, iItemID)
	local tData = self.tPlayerItems[iPlayerID][iItemID]
	if not tData then return end

	-- local hItem = self.tPlayerItemEnts[iPlayerID][iItemID]
	local hItem = EntIndexToHScript(tData.iItemEntIndex)
	if IsValid(hItem) then
		--记录物品信息
		--CD
		if hItem.IsCooldownReady and not hItem:IsCooldownReady() then
			tData.tCDInfo = {
				fCD = hItem:GetCooldownTime(),
				fCDLast = hItem:GetCooldownTimeRemaining(),
				time = GameRules:GetGameTime(),
			}
		end

		local hParent = hItem:GetParent()
		hParent:TakeItem(hItem)

		if BuildSystem:IsBuilding(hParent) then
			EventManager:fireEvent(ET_PLAYER.ON_TOWER_DESTROY_ITEM_ENTITY, {
				PlayerID = iPlayerID,
				hItem = hItem,
				hBuilding = hParent:GetBuilding(),
			})
		end

		UTIL_RemoveImmediate(hItem)

		tData.sOwnerName = ""
		tData.iOwnerEntIndex = -1
		tData.iItemEntIndex = -1
		tData.iItemSlot = -1
		self:UpdateNetTables()
	end
end

--- 用itemid卸下装备
function public:ItemTake(iPlayerID, iItemID)
	local tData = self.tPlayerItems[iPlayerID][iItemID]
	if not tData then return end

	self:RemoveItemEntity(iPlayerID, iItemID)

	-- 卸下卡牌上的物品
	if tData.iOwnerCardID ~= -1 then
		HeroCardData:RemoveCardItem(iPlayerID, tData.iOwnerCardID, iItemID)
		tData.iOwnerCardID = -1
		tData.sOwnerName = ""
	end

	tData.iItemSlot = -1

	self:UpdateNetTables()
end
--- 用entid卸下装备-
---@param iEntID number 实体ID
---@param iSlot number 物品格ID，不填默认全部
function public:ItemTakeByEntID(iPlayerID, iEntID, iSlot)
	local hUnit = EntIndexToHScript(iEntID)
	if not IsValid(hUnit) then
		return
	end

	if nil == iSlot then
		for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_9 do
			local hItem = hUnit:GetItemInSlot(i)
			if hItem and hItem.tItemData then
				Items:ItemTake(iPlayerID, hItem.tItemData.iItemID)
			end
		end
	else
		local hItem = hUnit:GetItemInSlot(iSlot)
		if hItem and hItem.tItemData then
			Items:ItemTake(iPlayerID, hItem.tItemData.iItemID)
		end
	end
end


---遍历物品
function public:EachItems(iPlayerID, func)
	local tPlayerItems = self.tPlayerItems[iPlayerID]
	if tPlayerItems then
		for iItemID, tItemData in pairs(tPlayerItems) do
			if func(tItemData) then
				return
			end
		end
	end
end

---获取玩家拥有的物品数量
function public:GetItemCount(iPlayerID)
	local tPlayerItems = self.tPlayerItems[iPlayerID]
	if tPlayerItems then
		return TableCount(tPlayerItems)
	end
	return 0
end
---获取玩家某物品数量
function public:GetItemCountByName(iPlayerID, sItemName)
	local iCount = 0
	---@param tItemData ItemData
	self:EachItems(iPlayerID, function(tItemData)
		if tItemData.sItemName then
			iCount = iCount + 1
		end
	end)
	return iCount
end
---玩家是否某物品数量达到上限
function public:IsItemCountToMax(iPlayerID, sItemName)
	local tKV = KeyValues.ItemsKv[sItemName]
	if not tKV or not tKV.CountMax then
		return false
	end
	if 0 > tKV.CountMax then
		return false
	end
	local iCount = self:GetItemCountByName(iPlayerID, sItemName)
	return iCount >= tKV.CountMax
end

---是否是游戏内物品
function public:IsGameHasItem(sItemName)
	local tKV = KeyValues.ItemsKv[sItemName]
	return tKV and nil ~= tKV.Rarity
end
---@return string n r sr ssr
function public:GetItemRarity(sItemName)
	local iRarity = 1
	local tKV = KeyValues.ItemsKv[sItemName]
	if tKV then
		iRarity = tKV.Rarity
	end
	return ({ 'n', 'r', 'sr', 'ssr' })[iRarity] or 'n'
end
---获取物品名字用商品ID
function public:GetItemNameByGoodsID(sItemGoodsID)
	for k, v in pairs(KeyValues.ItemsKv) do
		if 'table' == type(v) and v.ID and tostring(v.ID) == tostring(sItemGoodsID) then
			return k
		end
	end
end

return public