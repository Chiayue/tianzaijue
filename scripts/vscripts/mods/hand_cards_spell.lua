if nil == HandSpellCards then
	---@class HandSpellCards
	HandSpellCards = {
		---@type SpellCard[][] { iPlayerID:SpellCard }
		tPlayerCards = nil, --玩家手牌

		tModifyData = nil,
		-- 接入修改器类型
		tMDFType = {
			OverridePlayerMaxSpellCard = 1, -- 最大技能卡数
		}
	}
	HandSpellCards = class({}, HandSpellCards)

	---@class SpellCard
	SpellCard = {
		---卡牌名
		sCardName = nil,
		---卡牌唯一ID
		iCardID = nil,
		---卡牌技能ID
		iEntIndex = nil,
		---卡牌数量
		iCount = nil,
	}
end
---@type HandSpellCards
local public = HandSpellCards

function public:init(bReload)
	if not bReload then
		self.tPlayerCards = {}
		self.tModifyData = {}
	end

	self:UpdateNetTables()

	CustomUIEvent("SpellCard_Sell", Dynamic_Wrap(self, "OnSpellCard_Sell"), self)
	Request:Event("SpellCard_UseCard", Dynamic_Wrap(self, "OnSpellCard_UseCard"), self)

	if IsInToolsMode() then
		CustomUIEvent("Debug_TakeSpellCard", Dynamic_Wrap(self, "OnDebug_TakeSpellCard"), self)
	end
end

--UI事件************************************************************************************************************************
	do
	--使用法术牌
	function public:OnSpellCard_UseCard(events)
		DeepPrintTable(events)
		local iPlayerID = events.PlayerID

		if events.target_pos then
			events.target_pos_x = events.target_pos[1]
			events.target_pos_y = events.target_pos[2]
			events.target_pos_z = events.target_pos[3]
		end

		local bSuccess = self:UsedCard(iPlayerID, events.card_id, events)
		return { success = bSuccess }
	end
	--出售法术卡
	function public:OnSpellCard_Sell(eventSourceIndex, events)
		local iPlayerID = events.PlayerID
		self:SellSpellCard(iPlayerID, events.scardname)
	end

	---图鉴选卡
	function public:OnDebug_TakeSpellCard(_, tEvent)
		self:AddCard(tEvent.PlayerID, tEvent.sCardName)
	end
end
--UI事件************************************************************************************************************************
--
function public:UpdateNetTables()
	CustomNetTables:SetTableValue("hand_cards", "hand_cards_spell", self.tPlayerCards)
end

---获取法术卡名字用商品ID
function public:GetCardNameByGoodsID(sSpellGoodsID)
	for k, v in pairs(KeyValues.SpellKv) do
		if 'table' == type(v) and v.Unique and tostring(v.Unique) == tostring(sSpellGoodsID) then
			return k
		end
	end
end

--出售法术卡
function public:SellSpellCard(iPlayerID, sCardName)
	local iCardID = HandSpellCards:GetPlayerCardIDByName(iPlayerID, sCardName)
	local tCard = self.tPlayerCards[iPlayerID][iCardID]
	if tCard == nil then return end

	local iCrystal = math.floor(DotaTD:GetSpellCardCrystal(sCardName) * SELL_SPELL_CRYSTAL_PERCENT * 0.01 * tCard.iCount)
	PlayerData:ModifyCrystal(iPlayerID, iCrystal)
	PlayerData:AddMana(iPlayerID, 20)

	HandSpellCards:RemoveCardByID(iPlayerID, iCardID)
end
function public:InitPlayerSpellCardData(tEvent)
	local iPlayerID = tEvent.PlayerID
	self.tPlayerCards[iPlayerID] = {}
	self.tModifyData[iPlayerID] = {}
	self:UpdateNetTables()
end

--初始化玩家开局法术卡
function public:InitPlayerSpellCard(iPlayerID)
	local tCards = {}
	SelectSpellCard:EachCardinPool(iPlayerID, 'SpellCard_ALL', function(sCard)
		if not self:HasCard(iPlayerID, sCard) then
			table.insert(tCards, sCard)
		end
	end)

	for i = 1, INIT_PLAYER_SPEELCARD_COUNT do
		local iRand = RandomInt(1, #tCards)
		self:AddCard(iPlayerID, tCards[iRand])
		table.remove(tCards, iRand)
	end

	self:UpdateNetTables()
end

--法术卡牌ID获取卡牌名
function public:GetPlayerCardName(iPlayerID, iCardID)
	local tData = self.tPlayerCards[iPlayerID]
	if not tData then return end
	tData = tData[iCardID]
	if not tData then return end
	return tData.sCardName
end
--法术卡牌名获取卡牌ID
function public:GetPlayerCardIDByName(iPlayerID, sCardName)
	local tData = self.tPlayerCards[iPlayerID]
	if not tData then return end
	for k, v in pairs(tData) do
		if v.sCardName == sCardName then
			return k
		end
	end
end

--- 获取技能卡通过ability 的entindex
function public:GetPlayerCardByEntindex(iPlayerID, iEntIndex)
	local tData = self.tPlayerCards[iPlayerID]
	if not tData then return end
	return (FIND(tData, function(k, v)
		return v.iEntIndex == iEntIndex
	end)).value
end

--获取法术手牌数量
function public:GetPlayerCardCount(iPlayerID)
	local tData = self.tPlayerCards[iPlayerID]
	if not tData then return 0 end
	return TableCount(tData)
end

--- 获取玩家最大法术卡种类数量
function public:GetPlayerMaxCardCategory(iPlayerID)
	return PLAYER_SPEELCARD_HAND_MAX + self:GetModifyPlayerSpellCardCount(iPlayerID)
end

--- 获取玩家额外法术卡种类数量
function public:GetModifyPlayerSpellCardCount(iPlayerID)
	local iCount = 0
	for key, tVals in pairs(EModifier:GetModifierVals(EMDF_BONUS_SPELL_CARD, iPlayerID)) do
		local iVal = tonumber(tVals[1]) or 0
		if type(key) == 'table' then
			---@type eom_modifier
			local hBuff = key
			if hBuff:GetPlayerID() ~= iPlayerID then
				iVal = 0
			end
		end
		iCount = iVal + iCount
	end
	return iCount
end
if not EModifier:HasModifier(EMDF_BONUS_SPELL_CARD) then EModifier:CreateModifier(EMDF_BONUS_SPELL_CARD) end

--- 获取玩家最大技能卡数量
function public:GetPlayerMaxCardCount(iPlayerID)
	local iMax = self:GetOverridePlayerMaxSpellCard(iPlayerID)
	if iMax then
		return iMax
	end
	-- 默认没有数量上限
	return -1
end

--获取手牌中法术种类数量
function public:GetPlayerHandCardKind(iPlayerID)
	local tPlayerData =	self.tPlayerCards[iPlayerID]
	return TableCount(tPlayerData)
end

--给玩家添加卡牌
function public:AddCard(iPlayerID, sCardName)
	local hHero = PlayerData:GetHero(iPlayerID)
	if not IsValid(hHero) or not hHero:IsAlive() then return false end

	---@type SpellCard
	local tData

	local iCardID = self:GetPlayerCardIDByName(iPlayerID, sCardName)
	if iCardID then
		---重复卡牌
		tData =	self.tPlayerCards[iPlayerID][iCardID]
		tData.iCount = tData.iCount + 1
	else
		--给英雄添加技能
		local hAblt = hHero:FindAbilityByName(sCardName)
		if not hAblt then
			hAblt = hHero:AddAbility(sCardName)
		else
			hAblt:StopTimer('RmoveCard')
		end
		if hAblt then
			hAblt:SetHidden(true)
			hAblt:SetActivated(true)
			hAblt:SetLevel(hAblt:GetMaxLevel())


			---@class SpellCard
			tData = {}
			tData.sCardName = sCardName
			tData.iCardID = DoUniqueString('SpellCard')
			tData.iCount = 1
			tData.iEntIndex = hAblt:entindex()
			self.tPlayerCards[iPlayerID][tData.iCardID] = tData
		else
			if IsInToolsMode() then
				error('add spell card error : ' .. 'card_name=' .. sCardName .. ', card_count=' .. self:GetPlayerCardCount(iPlayerID))
			else
				DebugError('add spell card error : ', 'card_name=' .. sCardName .. ', card_count=' .. self:GetPlayerCardCount(iPlayerID))
			end
		end
	end

	self:UpdateNetTables()

	return tData
end

--给玩家移除卡牌
function public:RemoveCard(iPlayerID, hAbility)
	local hHero = PlayerData:GetHero(iPlayerID)
	if not IsValid(hHero) or not hHero:IsAlive() or self.tPlayerCards[iPlayerID] == nil then return false end
	local sCardName = hAbility:GetAbilityName()
	for iCardID, tCard in pairs(self.tPlayerCards[iPlayerID]) do
		if tCard.sCardName == sCardName then
			return self:RemoveCardByID(iPlayerID, iCardID)
		end
	end
	self:UpdateNetTables()
end

--- 移除玩家法术牌
function public:RemoveCardByID(iPlayerID, iCardID)
	local hHero = PlayerData:GetHero(iPlayerID)
	if not IsValid(hHero) or not hHero:IsAlive() or self.tPlayerCards[iPlayerID] == nil then return false end
	local tCard = self.tPlayerCards[iPlayerID][iCardID]

	if tCard ~= nil then
		local hAbility = EntIndexToHScript(tCard.iEntIndex)
		if IsValid(hAbility) then
			-- hAbility:SetActivated(true)
			hAbility:GameTimer('RmoveCard', math.max(hAbility:GetDuration(), hAbility:GetSpecialValueFor('duration'), 10) + 1, function()
				if IsValid(hHero) then
					hHero:RemoveAbilityByHandle(hAbility)
				end
			end)
		end
		self.tPlayerCards[iPlayerID][iCardID] = nil
	end

	self:UpdateNetTables()
end

---销毁玩家全部卡牌
function public:RemoveAll(iPlayerID)
	local t = {}
	for iCardID, _ in pairs(self.tPlayerCards[iPlayerID]) do
		table.insert(t, iCardID)
	end
	for _, iCardID in ipairs(t) do
		self:RemoveCardByID(iPlayerID, iCardID)
	end
	self.tPlayerCards[iPlayerID] = {}
	self:UpdateNetTables()
end

--- 遍历法术卡
function public:EachCard(iPlayerID, func)
	if self.tPlayerCards[iPlayerID] == nil then return false end

	if type(func) ~= "function" then
		return false
	end

	local tCards = self.tPlayerCards[iPlayerID]
	for k, tCard in pairs(tCards) do
		func(tCard)
	end
end

--- 获取玩家法术卡
function public:GetPlayerSpellCards(iPlayerID)
	return self.tPlayerCards[iPlayerID]
end

---不同施法类型处理
function public:ProcessBehavior(typeBehavior, hAbility, tParams)
	if typeBehavior ~= bit.band(typeBehavior, GetAbilityBehavior(hAbility)) then
		return false
	end

	local hCaster = hAbility:GetCaster()
	local iPlayerID = hCaster:GetPlayerOwnerID()
	local hTarget
	local vTarget = Vector(0, 0, 0)
	local typeFilterResult
	local sError = 'dota_hud_error_only_can_not_cast'

	if typeBehavior == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
		if 'number' == type(tParams.target_entid) then
			hTarget = EntIndexToHScript(tParams.target_entid)
			if IsValid(hTarget) then
				typeFilterResult, sError = hAbility:CastFilterResultTarget(hTarget)
			end
		end
	elseif typeBehavior == DOTA_ABILITY_BEHAVIOR_POINT then
		if nil ~= tParams.target_pos_x and nil ~= tParams.target_pos_y and nil ~= tParams.target_pos_z then
			vTarget = Vector(tParams.target_pos_x, tParams.target_pos_y, tParams.target_pos_z)
			typeFilterResult, sError = hAbility:CastFilterResultLocation(vTarget)
		end
	elseif typeBehavior == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
		typeFilterResult, sError = hAbility:CastFilterResult()
	end

	if UF_SUCCESS ~= typeFilterResult then
		if sError then
			ErrorMessage(iPlayerID, sError)
		end
		return false
	end

	hAbility.GetCursorTarget = function()
		return hTarget
	end
	hAbility.GetCursorPosition = function()
		return IsValid(hTarget) and hTarget:GetAbsOrigin() or vTarget
	end

	return true
end

---玩家使用卡牌
function public:UsedCard(iPlayerID, iCardID, tParams)
	local sCardName = self:GetPlayerCardName(iPlayerID, iCardID)
	if not sCardName then return false end

	local hHero = PlayerData:GetHero(iPlayerID)
	if not IsValid(hHero) or not hHero:IsAlive() then return false end

	local hAblt = hHero:FindAbilityByName(sCardName)
	if not hAblt then return false end
	if not hAblt:IsFullyCastable() then
		if hAblt:GetManaCost(hAblt:GetLevel()) > hHero:GetMana() then
			ErrorMessage(iPlayerID, 'dota_hud_error_not_enough_mana')
		end
		return false
	end
	if not hAblt:IsActivated() then return false end

	--单位目标
	if not self:ProcessBehavior(DOTA_ABILITY_BEHAVIOR_UNIT_TARGET, hAblt, tParams) then
		--点目标
		if not self:ProcessBehavior(DOTA_ABILITY_BEHAVIOR_POINT, hAblt, tParams) then
			--无目标
			if not self:ProcessBehavior(DOTA_ABILITY_BEHAVIOR_NO_TARGET, hAblt, tParams) then
				return false
			end
		end
	end

	if hAblt:OnSpellStart() ~= false then
		PlayerData:AddMana(iPlayerID, -hAblt:GetManaCost(1))
		hAblt:UseResources(false, true, true)

		---@class EventData_PLAYER_USE_SPELL
		local tEventData = {
			iPlayerID = iPlayerID,
			sCardName = sCardName,
			hAblt = hAblt,
		}
		EventManager:fireEvent(ET_PLAYER.ON_HERO_USE_SPELL, tEventData)

		-- 消耗卡牌
		local tKV = hAblt:GetAbilityKeyValues()
		local iUsedCount = tonumber(tKV.IsConsumables)
		if 0 < iUsedCount then
			local hCard = self.tPlayerCards[iPlayerID][iCardID]
			hCard.iCount = hCard.iCount - iUsedCount
			if 0 >= hCard.iCount then
				self:RemoveCardByID(iPlayerID, iCardID)
			end
			self:UpdateNetTables()
		end

		Recorder:RecordPlayerUseSpellCard(iPlayerID, sCardName)
	end
	return true
end

---玩家是否拥有某卡牌
function public:HasCard(iPlayerID, sCard)
	local tCards = self.tPlayerCards[iPlayerID]
	if tCards then
		for sCardID, hCard in pairs(tCards) do
			if sCard == hCard.sCardName then
				return 0 < hCard.iCount
			end
		end
	end
	return false
end

----------------------------------------------------------------------------------------------------
-- Midify
--- 覆盖修改玩家最大技能卡数
function public:GetModifierOverridePlayerMaxSpellCard(hSource, func)
	local iPlayerID = hSource:GetPlayerID()
	local tPlayerModifyData = self.tModifyData[iPlayerID]
	if tPlayerModifyData then
		tPlayerModifyData[self.tMDFType.OverridePlayerMaxSpellCard] = tPlayerModifyData[self.tMDFType.OverridePlayerMaxSpellCard] or {}
		local tModify = tPlayerModifyData[self.tMDFType.OverridePlayerMaxSpellCard]
		if tModify[hSource] ~= func then
			tModify[hSource] = func
		end
	end
end
--- 获取已覆盖修改的玩家最技能卡数
function public:GetOverridePlayerMaxSpellCard(iPlayerID)
	local tPlayerModifyData = self.tModifyData[iPlayerID]
	if tPlayerModifyData == nil then
		return nil
	end

	local iBonus = 999
	local tModify = tPlayerModifyData[self.tMDFType.OverridePlayerMaxSpellCard]
	if tModify ~= nil then
		for hSource, func in pairs(tModify) do
			if hSource and func then
				local bonus = tonumber(func(hSource))
				if bonus then
					iBonus = math.min(bonus, iBonus)
				end
			end
		end
	end
	--- 默认无上限 -1
	return iBonus == 999 and -1 or iBonus
end

return public