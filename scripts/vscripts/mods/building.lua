if Building == nil then
	---@class Building
	Building = class({})
end

LinkLuaModifier("modifier_building", "modifiers/unit/modifier_building.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_building_move", "modifiers/unit/modifier_building_move.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_building_ai", "modifiers/ai/modifier_building_ai.lua", LUA_MODIFIER_MOTION_NONE)

local AttackCapabilityS2I = {
	["DOTA_UNIT_CAP_NO_ATTACK"] = DOTA_UNIT_CAP_NO_ATTACK,
	["DOTA_UNIT_CAP_MELEE_ATTACK"] = DOTA_UNIT_CAP_MELEE_ATTACK,
	["DOTA_UNIT_CAP_RANGED_ATTACK"] = DOTA_UNIT_CAP_RANGED_ATTACK
}

-- 通用处理
function Building:init(bReload)
	if not bReload then
		Building.tBuildings = {}
	end

	CustomUIEvent("BuildingLearningAbility", Building.onBuildingLearningAbility)

	EventManager:register(ET_GAME.NPC_SPAWNED, 'OnNpcSpawned', self, EVENT_LEVEL_ULTRA)
end

function Building:OnNpcSpawned(tData)
	local hUnit = EntIndexToHScript(tData.entindex)
	if not IsValid(hUnit) then return end

	if LOCK_CREATE_UNIT_BUIDLING then
		Building.InitUnit(LOCK_CREATE_UNIT_BUIDLING, hUnit)
	end
end

function Building.onBuildingLearningAbility(iEventSourceIndex, tEvents)
	if GameRules:IsGamePaused() then return end

	local hUnit = EntIndexToHScript(tEvents.iUnitIndex or -1)
	local hAbility = EntIndexToHScript(tEvents.iAbilityIndex or -1)

	if IsValid(hUnit) and IsValid(hAbility) and hUnit.GetBuilding ~= nil and hAbility:GetCaster() == hUnit then
		local hBuilding = hUnit:GetBuilding()
		if hBuilding ~= nil and hBuilding:GetAbilityPoints() > 0 and hBuilding:GetLevel() >= hAbility:GetHeroLevelRequiredToUpgrade() then
			if hAbility:GetLevel() < hAbility:GetMaxLevel() then
				hAbility:UpgradeAbility(true)
				hBuilding:SetAbilityPoints(hBuilding:GetAbilityPoints() - 1)
			end
		end
	end
end

function Building.onBuildingSelectingQualificationAbility(iEventSourceIndex, tEvents)
	if GameRules:IsGamePaused() then return end

	local hUnit = EntIndexToHScript(tEvents.iUnitIndex or -1)
	local sAbilityName = tEvents.sAbilityName or ""

	if IsValid(hUnit) and hUnit.GetBuilding ~= nil then
		local hBuilding = hUnit:GetBuilding()
		if hBuilding ~= nil then
			hBuilding:ConfirmQualificationAbility(sAbilityName)
		end
	end
end

function Building.updateNetTables()
	for iIndex, hBuilding in pairs(Building.tBuildings) do
		hBuilding:updateNetTable()
	end
end

function Building.indexToHandle(iIndex)
	return Building.tBuildings[iIndex]
end

function Building.insert(hBuilding)
	local iIndex = 1
	while Building.tBuildings[iIndex] ~= nil do
		iIndex = iIndex + 1
	end
	Building.tBuildings[iIndex] = hBuilding
	return iIndex
end
function Building.remove(hBuilding)
	if type(hBuilding) == "number" then -- 按索引删除
		local iIndex = hBuilding
		if Building.tBuildings[iIndex] ~= nil then
			Building.tBuildings[iIndex] = nil
			return true
		end
	else -- 按实例删除
		for iIndex, _hBuilding in pairs(Building.tBuildings) do
			if _hBuilding == hBuilding then
				Building.tBuildings[iIndex] = nil
				return true
			end
		end
	end
	return false
end

-- 类相关
---@return Building Building
function NewBuilding(...)
	return Building(...)
end

function Building:updateNetTable()
	local fSellGoldPer = SELL_CARD_GOLD_PERCENT[Clamp(self:GetLevel(), 1, #SELL_CARD_GOLD_PERCENT)]
	if HeroCardData:GetPlayerFixedSellCardGoldPercent(self.hOwner:GetPlayerOwnerID()) then
		fSellGoldPer = HeroCardData:GetPlayerFixedSellCardGoldPercent(self.hOwner:GetPlayerOwnerID())
	end

	local tData = {
		sName = self:GetUnitEntityName(),
		iBuildingIndex = self:getIndex(),
		iCurrentXP = self:GetCurrentXP(),
		iNeededXPToLevel = self:GetNeededXPToLevel(),
		iLevel = self:GetLevel(),
		iMaxLevel = self:GetMaxLevel(),
		iAbilityPoints = self:GetAbilityPoints(),
		tUpgrades = self:GetUpgradeInfos(),
		iGoldCost = self:GetGoldCost(),
		iGoldBack = self:GetGoldCost() * fSellGoldPer * 0.01,
		bInBattling = self:IsBattling()
	}

	CustomNetTables:SetTableValue("buildings", tostring(self:GetUnitEntityIndex()), tData)
end

function Building:constructor(sName, vLocation, fAngle, hOwner)
	self.iIndex = Building.insert(self)

	self.vLocation = vLocation
	self.fAngle = fAngle
	self.hOwner = hOwner

	self.iLevel = 1
	self.iXP = 0

	self.iAbilityPoints = 0

	self.iBaseGoldCost = DotaTD:GetCardGold(sName) or 0
	self.iGoldCost = self.iBaseGoldCost

	self.iBuildRound = math.max(Spawner:GetRound() - 1, 1)
	self.fDamage = 0
	self.tRoundDamages = {}


	self.typeBuildingMap = BuildSystem.typeBuildingMap

	local hUnit = self:Replace(sName)

	self.hBlocker = BuildSystem:CreateBlocker(BuildSystem:GridNavSquare(BUILDING_SIZE, vLocation))
	self.hBlocker.hBuilding = self

	hUnit:GameTimer(0, function()
		--这帧需要设置大小，下一帧再弹性动画
		hUnit:AddNewModifier(hUnit, nil, "modifier_pudding", PUDDING_VALUES)
	end)
end

function Building:updateInventorySlots()
	local hUnit = self.hUnit

	for iSlot, iLevel in pairs(ITEM_UNLOCK_LEVEL) do
		local hItem = hUnit:GetItemInSlot(iSlot)
		if self:GetStar() >= iLevel then
			--解锁
			if hItem and nil ~= string.find(hItem:GetName(), 'item_lock') then
				hUnit:TakeItem(hItem)
				UTIL_RemoveImmediate(hItem)
			end
		else
			--锁定
			if hItem then
				if nil ~= string.find(hItem:GetName(), 'item_lock') then
					goto continue
				end
				--脱下其他物品
				local tItemData = Items:GetItemDataByItemEntIndex(hItem:entindex(), hUnit:GetPlayerOwnerID())
				Items:RemoveItemEntity(hUnit:GetPlayerOwnerID(), tItemData.iItemID)
			end
			local hItem = CreateItem('item_lock_' .. iLevel, nil, hUnit)
			if hItem then
				hItem = hUnit:AddItem(hItem)
				if iSlot ~= hItem:GetItemSlot() then
					hUnit:SwapItems(iSlot, hItem:GetItemSlot())
				end
			end

			:: continue ::
		end
	end
end

function Building:Move(vLocation, typeBuildingMap)
	if typeBuildingMap then self.typeBuildingMap = typeBuildingMap end

	SnapToGrid(BUILDING_SIZE, vLocation)
	vLocation = GetGroundPosition(vLocation, self.hUnit)

	self.vLocation = vLocation

	if IsValid(self.hUnit) then
		self.hUnit:SetAbsOrigin(vLocation)
		FindClearSpaceForUnit(self.hUnit, vLocation, false)
		self.hUnit:GameTimer(0, function()
			self.hUnit:AddNewModifier(self.hUnit, nil, "modifier_pudding", PUDDING_VALUES)
		end)
	end

	BuildSystem:SetBlockerPolygon(self.hBlocker, BuildSystem:GridNavSquare(BUILDING_SIZE, vLocation))

	return self.vLocation
end

function Building:Replace(sName, bIgnoreParticle)
	local iPlayerID = self.hOwner:GetPlayerOwnerID()
	local tItems = {}
	if self.hUnit ~= nil then
		CustomNetTables:SetTableValue("buildings", tostring(self:GetUnitEntityIndex()), nil)
		self.hUnit:ForceKill(false)
		self.hUnit:RemoveSelf()
		self.iLevel = 1
	end

	if not self.tKV then
		self.tKV = KeyValues.UnitsKv[sName]
	end

	self.sName = sName
	self.hUpgradeInfos = self.hUpgradeInfos
	-- sName = Service:GetPlayerHeroSkin(iPlayerID, sName)
	LOCK_CREATE_UNIT_BUIDLING = self
	local hUnit = CreateUnitByName(sName, self.vLocation, false, self.hOwner, self.hOwner, self.hOwner:GetTeamNumber())
	LOCK_CREATE_UNIT_BUIDLING = nil

	self:AddXP(0, bIgnoreParticle)
	self:updateNetTable()

	---@class EventData_ON_TOWER_SPAWNED
	local tEvent = {
		PlayerID = iPlayerID,
		hBuilding = self,
	}
	EventManager:fireEvent(ET_PLAYER.ON_TOWER_SPAWNED, tEvent)

	return hUnit
end
function Building:InitUnit(hUnit)
	if not IsValid(hUnit) then return end
	self.hUnit = hUnit
	self:ResetAngles()
	-- hUnit:SetControllableByPlayer(iPlayerID, false)
	hUnit:SetUnitCanRespawn(true)

	hUnit:AddNewModifier(hUnit, nil, "modifier_building", nil)
	hUnit:AddNewModifier(hUnit, nil, "modifier_artifact", nil)

	hUnit:SetHasInventory(true)

	-- 注册属性
	Attributes:Register(hUnit)

	hUnit.IsBuilding = function(self)
		return self:IsCreature()
	end
	hUnit.GetBuilding = function(hUnit)
		return self
	end

	--技能处理
	for i = 1, hUnit:GetAbilityCount(), 1 do
		local hAbility = hUnit:GetAbilityByIndex(i - 1)
		if hAbility then
			if DotaTD:GetAbilityTag(hAbility:GetAbilityName()) == "base" then
				hAbility:SetLevel(1)
			else
				hAbility:SetLevel(0)
			end
			-- hAbility:UpgradeAbility(true)
			-- hAbility:SetLevel(0)
			if hAbility:GetAutoCastState() then hAbility:ToggleAutoCast() end
			if hAbility:GetToggleState() then hAbility:ToggleAbility() end
			-- hUnit:RemoveModifierByName(hAbility:GetIntrinsicModifierName() or "")
		end
	end

	--添加物品锁
	self:updateInventorySlots()
end
function Building:ResetAngles(hUnit)
	if not hUnit then hUnit = self.hUnit end

	hUnit:SetAngles(0, self.fAngle, 0)

	--同步棋盘朝向
	local iTeamID = PlayerData:GetPlayerTeamID(self.hOwner:GetPlayerOwnerID())
	if BuildSystem.tMapPoints and BuildSystem.tMapPoints[self.typeBuildingMap] then
		local hMapEnt = BuildSystem.tMapPoints[self.typeBuildingMap][iTeamID]
		if IsValid(hMapEnt) then
			hUnit:SetForwardVector(hMapEnt:GetForwardVector())
		end
	end
end

function Building:Clone()
	if self.hUnit == nil then return end

	local iPlayerID = self.hOwner:GetPlayerOwnerID()
	local hUnit = CreateUnitByName(self.sName, self.vLocation, false, self.hOwner, self.hOwner, self.hOwner:GetTeamNumber())

	-- hUnit:SetControllableByPlayer(iPlayerID, false)
	hUnit:SetAngles(0, self.hUnit:GetAnglesAsVector().y, 0)

	hUnit:SetHasInventory(true)

	-- 注册属性
	Attributes:Register(hUnit)

	hUnit.IsBuilding = function(self)
		return self:IsCreature()
	end
	hUnit.GetBuilding = function(hUnit)
		return self
	end

	--同步
	self:CloneSync(hUnit)

	hUnit:FireClone(self.hUnit)

	return hUnit
end
function Building:CloneSync(hUnit)
	if not IsValid(hUnit) or hUnit == self.hUnit then
		return
	end

	--等级同步
	local iLevel = self.hUnit:GetLevel()
	for i = hUnit:GetLevel(), iLevel - 1 do
		if hUnit.LevelUp ~= nil then
			hUnit:LevelUp()
		end
	end

	--技能同步
	for i = 0, self.hUnit:GetAbilityCount() - 1 do
		local hAbility = self.hUnit:GetAbilityByIndex(i)
		if hAbility ~= nil then
			local hIllusionAbility = hUnit:FindAbilityByName(hAbility:GetAbilityName())
			if hIllusionAbility ~= nil then
				if hIllusionAbility:GetLevel() < hAbility:GetLevel() then
					while hIllusionAbility:GetLevel() < hAbility:GetLevel() do
						hIllusionAbility:UpgradeAbility(true)
					end
				elseif hIllusionAbility:GetLevel() >= hAbility:GetLevel() then
					hIllusionAbility:SetLevel(hAbility:GetLevel())
				end
				if hAbility:GetAutoCastState() ~= hIllusionAbility:GetAutoCastState() then
					hIllusionAbility:ToggleAutoCast()
				end
				if hAbility:GetToggleState() ~= hIllusionAbility:GetToggleState() then
					hIllusionAbility:ToggleAbility()
				end
			end
		end
	end

	--同步主身装备
	self:CloneSyncItems(hUnit)

	--同步buffs
	local tModifiers = self.hUnit:FindAllModifiers()
	for i, hModifier in pairs(tModifiers) do
		if hModifier.AllowIllusionDuplicate and hModifier:AllowIllusionDuplicate() then
			local hIllusionModifier = hUnit:AddNewModifier(hModifier:GetCaster(), hModifier:GetAbility(), hModifier:GetName(), nil)
		end
	end
	hUnit:AddNewModifier(hUnit, nil, "modifier_star_indicator", nil)

	hUnit:SetHealth(self.hUnit:GetHealth())
	hUnit:SetMana(self.hUnit:GetMana())

	return hUnit
end
--同步装备
function Building:CloneSyncItems(hUnit, bReset)
	if nil == bReset then bReset = true end

	--同步主身装备
	for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_9 do
		local hItem = self.hUnit:GetItemInSlot(i)
		if hItem ~= nil then
			local hIllusionItem = hUnit:GetItemInSlot(i)

			if IsValid(hIllusionItem) and hItem:GetAbilityName() ~= hIllusionItem:GetAbilityName() then
				UTIL_RemoveImmediate(hIllusionItem)
			end

			if not IsValid(hIllusionItem) then
				-- hIllusionItem = hItem
				-- hUnit:AddItem(hItem)
				hIllusionItem = CreateItem(hItem:GetName(), hUnit, hUnit)
				hUnit:AddItem(hIllusionItem)
				if i ~= hIllusionItem:GetItemSlot() then
					hUnit:SwapItems(i, hIllusionItem:GetItemSlot())
				end
			end

			--物品等级
			hIllusionItem:SetLevel(hItem:GetLevel())

			if bReset then
				hIllusionItem:StartCooldown(hItem:GetCooldownTimeRemaining())
				hIllusionItem:SetPurchaser(nil)
				hIllusionItem:SetShareability(ITEM_FULLY_SHAREABLE)
				hIllusionItem:SetPurchaseTime(hItem:GetPurchaseTime())
				hIllusionItem:SetCurrentCharges(hItem:GetCurrentCharges())
				hIllusionItem:SetItemState(hItem:GetItemState())
				if hIllusionItem:GetToggleState() ~= hItem:GetToggleState() then
					hIllusionItem:ToggleAbility()
				end
				if hIllusionItem:GetAutoCastState() ~= hItem:GetAutoCastState() then
					hIllusionItem:ToggleAutoCast()
				end
			end
		else
			local hIllusionItem = hUnit:GetItemInSlot(i)
			if hIllusionItem then
				UTIL_RemoveImmediate(hIllusionItem)
			end
		end
	end
end

function Building:AddXP(iXP, bIgnoreParticle)
	if type(iXP) ~= "number" then return end
	iXP = math.floor(iXP)
	self.iGoldCost = self.iGoldCost + self.iBaseGoldCost * iXP
	self.iXP = math.min(self.iXP + iXP, HERO_XP_PER_LEVEL_TABLE[Clamp(self:GetMaxLevel(), 1, #HERO_XP_PER_LEVEL_TABLE)])
	self:ResetLevel(bIgnoreParticle)
end

function Building:LevelUp()
	self:_levelUp(1)
end

function Building:LevelDown()
	self:_levelUp(-1)
end

function Building:_levelUp(iLevel, bIgnoreParticle)
	local hUnit = self.hUnit
	iLevel = iLevel or 1
	local iLevelOld = self.iLevel or 1
	self.iLevel = math.max(1, iLevelOld + iLevel)
	-- 满级播放屏幕特效
	if not bIgnoreParticle and self.iLevel >= #HERO_XP_PER_LEVEL_TABLE and (GSManager:getStateType() == GS_Preparation or GSManager:getStateType() == GS_Battle_EndWait) then
		local iParticleID = ParticleManager:CreateParticle("particles/generic_gameplay/screen_arcane_drop.vpcf", PATTACH_EYES_FOLLOW, hUnit)
		hUnit:Timer(0.5, function()
			ParticleManager:DestroyParticle(iParticleID, false)
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end)
	end

	if self:IsHero() then
		if not bIgnoreParticle then
			local iParticleID = ParticleManager:CreateParticle("particles/hero_promotion.vpcf", PATTACH_ABSORIGIN_FOLLOW, hUnit)
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end
		if hUnit.LevelUp ~= nil then
			hUnit:LevelUp(iLevel > 0, iLevel)
		end
		for i = 0, 0 do
			local hAbility = hUnit:GetAbilityByIndex(i)
			if IsValid(hAbility) then
				hAbility:SetLevel(self:GetStar())
			end
		end
		hUnit:AddNewModifier(hUnit, nil, "modifier_star_indicator", nil)
	end

	--刷新羁绊技能
	BuildSystem:UpdataBuildingAbilityTag(GetPlayerID(self.hUnit))
	--刷新物品格子锁
	self:updateInventorySlots()

	---@class EventData_PlayerTowerLevelup
	local tData = {
		PlayerID = GetPlayerID(hUnit),
		hBuilding = self,
		iLevel = self.iLevel,
		iLevelOld = iLevelOld,
		entIndex = hUnit:GetEntityIndex()
	}
	EventManager:fireEvent(ET_PLAYER.ON_TOWER_LEVELUP, tData)
end

function Building:ModifyLevelBonus(iLevel, key)
	key = key or ATTRIBUTE_KEY.BASE
	AttributeSystem[ATTRIBUTE_KIND.BuildingLevelBonus]:SetVal(self, iLevel, key)
	self:ResetLevel()
end

function Building:ResetLevel(bIgnoreParticle)
	bIgnoreParticle = bIgnoreParticle or false

	local iLevelBonus = AttributeSystem[ATTRIBUTE_KIND.BuildingLevelBonus]:GetVal(self)

	local iXPLevel = 1
	for iLevel, iNeedXP in ipairs(HERO_XP_PER_LEVEL_TABLE) do
		if self.iXP >= iNeedXP then
			iXPLevel = iLevel
		else
			break
		end
	end

	if self.iLevel ~= iLevelBonus + iXPLevel then
		self:_levelUp(iLevelBonus + iXPLevel - self.iLevel, bIgnoreParticle)
	end

	self.hUnit:AddNewModifier(self.hUnit, nil, "modifier_pudding", PUDDING_VALUES)
	local iParticleID = ParticleManager:CreateParticle("particles/econ/events/ti10/hero_levelup_ti10_flash_hit_magic.vpcf", PATTACH_EYES_FOLLOW, self.hUnit)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, self.hUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", self.hUnit:GetAbsOrigin(), false)
	self.hUnit:Timer(0.6, function()
		ParticleManager:DestroyParticle(iParticleID, false)
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end)

	self:updateNetTable()
end

function Building:RemoveSelf()
	BuildSystem:RemoveBlocker(self.hBlocker)

	for i = DOTA_ITEM_SLOT_1, DOTA_STASH_SLOT_6, 1 do
		local item = self.hUnit:GetItemInSlot(i)
		if IsValid(item) and nil ~= string.find(item:GetName(), 'item_lock') then
			UTIL_RemoveImmediate(item)
			-- DropItemAroundUnit(self.hUnit, item)
		end
	end

	CustomNetTables:SetTableValue("buildings", tostring(self:GetUnitEntityIndex()), nil)

	self.hUnit:ForceKill(false)
	self.hUnit:RemoveSelf()
	Building.remove(self.iIndex)

	self.hUnit.IsBuilding = nil
	self.hUnit.GetBuilding = nil
	self.hUnit = nil

	self.sName = nil
	self.hUpgradeInfos = nil
	self.vLocation = nil
	self.fAngle = nil
	self.hOwner = nil
	self.iLevel = nil
	self.iXP = nil
	self.hBlocker = nil
	self.iIndex = nil
end

function Building:getIndex()
	return self.iIndex
end

function Building:CanUpgrade()
	return self:GetUpgradeInfos() ~= nil and self:GetUpgradeInfo() ~= nil
end

function Building:GetUnitEntity()
	return self.hUnit
end

function Building:GetUnitEntityName()
	return self.sName
end

function Building:GetUnitEntityIndex()
	return self.hUnit:entindex()
end

function Building:GetUnitTags()
	return { KeyValues.UnitsKv[self.sName].Tag_1, KeyValues.UnitsKv[self.sName].Tag_2 }
end

function Building:GetUnitAbilityTags()
	local hUnit = self:GetUnitEntity()
	local tAbilityName = {}
	local tTag = {}
	for key, value in pairs(KeyValues.UnitsKv[self.sName]) do
		if string.find(key, "Ability%d") then
			table.insert(tAbilityName, value)
		end
	end
	for _, sAbilityName in ipairs(tAbilityName) do
		local sTag = KeyValues.AbilitiesKv[sAbilityName].Tag
		if sTag then
			table.insert(tTag, KeyValues.AbilitiesKv[sAbilityName].Tag)
		end
	end
	return tTag
end

function Building:HasTag(sTagName)
	for _, sTag in ipairs(self:GetUnitTags()) do
		if sTag == sTagName then
			return true
		end
	end
	return false
end

function Building:GetBlockerEntity()
	return self.hBlocker
end

function Building:IsHero()
	return true
	-- return self.hUnit:GetUnitLabel() == "HERO"
end

function Building:GetGoldCost()
	return self.iGoldCost
end

function Building:GetCurrentXP()
	return self.iXP
end

function Building:GetAbilityPoints()
	return self.iAbilityPoints
end

function Building:SetAbilityPoints(iPoints)
	self.iAbilityPoints = iPoints
	self:updateNetTable()
end

function Building:GetNeededXPToLevel()
	if self:GetLevel() >= self:GetMaxLevel() then
		return 0
	end
	return HERO_XP_PER_LEVEL_TABLE[self:GetLevel() + 1] or 0
end

function Building:GetMaxLevel()
	return HERO_MAX_LEVEL
end

function Building:GetLevel()
	return self.iLevel
end

function Building:GetUpgradeInfos()
	return self.hUpgradeInfos
end

function Building:GetUpgradeInfo()
	if self.hUpgradeInfos == nil then return end
	return self.hUpgradeInfos[tostring(self.iLevel)]
end

function Building:GetOwner()
	return self.hOwner
end

function Building:GetPlayerOwnerID()
	if self.hOwner == nil then return end
	return self.hOwner:GetPlayerOwnerID()
end

function Building:GetStar()
	return self.iLevel
end

function Building:GetBuildRound()
	return self.iBuildRound
end

function Building:GetRoundDamage(typeDamage)
	local fVal = 0
	for typeDamage2, fDamage in pairs(self.tRoundDamages) do
		if nil == typeDamage or typeDamage2 == typeDamage then
			fVal = fVal + fDamage
		end
	end
	return fVal
end
function Building:GetTotalDamage()
	return self.fDamage
end

function Building:ModifyTotalDamage(fDamage, typeDamage)
	if 0 >= fDamage then return end
	self.fDamage = self.fDamage + fDamage
	self.tRoundDamages[typeDamage] = fDamage + (self.tRoundDamages[typeDamage] or 0)
end

--是否死亡（战斗棋子）
function Building:IsDeath()
	return not self:GetUnitEntity():IsAlive()
end

---是否在战斗
function Building:IsBattling()
	if IsValid(self.hUnit) then
		return self.hUnit:HasModifier('modifier_building_ai')
	end
	return false
end
---进入战斗
function Building:JoinBattle()
	if not IsValid(self.hUnit) then return end
	local hUnit = self.hUnit
	self.tRoundDamages = {}
	hUnit:SetMana(0)

	hUnit:Stop()
	hUnit:RemoveModifierByName('modifier_building')
	hUnit:AddNewModifier(hUnit, nil, 'modifier_building_ai', nil)
	hUnit:AddNewModifier(hUnit, nil, 'modifier_artifact', nil)

	self:updateNetTable()
end
---重置棋子
function Building:ResetUnit()
	if not IsValid(self.hUnit) then return end

	if self.hUnit:IsAlive() then
		local iTime = 1.5

		self.hUnit:AddNewModifier(self.hUnit, nil, 'modifier_tpscroll', {
			duration = iTime,
			x = self.vLocation.x,
			y = self.vLocation.y,
			z = self.vLocation.z,
		})

		self.hUnit:GameTimer(iTime, function()
			self.hUnit:Stop()
			self:reset()
		end)
	else
		self:reset()
	end
end
function Building:reset()
	-- BuildSystem:ReplaceBuilding(self.hUnit, self.sName)
	if self.hUnit:IsAlive() then
		-- self.hUnit:RespawnUnit()
		self.hUnit:SetHealth(self.hUnit:GetMaxHealth())
		self.hUnit:AddNewModifier(self.hUnit, nil, 'modifier_building', nil)
		self.hUnit:AddNewModifier(self.hUnit, nil, 'modifier_artifact', nil)
		FindClearSpaceForUnit(self.hUnit, self.vLocation, true)

		self.hUnit:RemoveModifierByName('modifier_building_ai')
		self:ResetAngles()
		for i = 0, self.hUnit:GetAbilityCount() - 1 do
			local hAblt = self.hUnit:GetAbilityByIndex(i)
			if hAblt then
				hAblt:EndCooldown()
			end
		end
		for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_9, 1 do
			local item = self.hUnit:GetItemInSlot(i)
			if item then
				item:EndCooldown()
			end
		end
	else
		-- self.hUnit:RespawnUnit()
		-- FindClearSpaceForUnit(self.hUnit, self.vLocation, true)
		-- self.hUnit:GameTimer(0, function()
		-- 	if self.hUnit:IsAlive() then
		-- 		self.hUnit:AddNewModifier(self.hUnit, nil, 'modifier_building', nil)
		-- 	end
		-- end)
		BuildSystem:ReplaceBuilding(self.hUnit, self.sName)
	end
	self:updateNetTable()
end

--复活战斗棋子
function Building:RespawnBuildingUnit()
	local hUnit = self:GetUnitEntity()
	if self:IsDeath() and IsValid(hUnit) then
		hUnit:RespawnUnit()

		for i = 0, hUnit:GetAbilityCount()-1, 1 do
			local hAbility = hUnit:GetAbilityByIndex(i)
			if IsValid(hAbility) then
				if hAbility:IsToggle() and hAbility:ResetToggleOnRespawn() and hAbility:GetToggleState() then
					hAbility:ToggleAbility()
				end
				hAbility:RefreshIntrinsicModifier()
			end
		end
		for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_6, 1 do
			local hItem = hUnit:GetItemInSlot(i)
			if IsValid(hItem) then
				hItem:RefreshIntrinsicModifier()
			end
		end
	end
end

return Building