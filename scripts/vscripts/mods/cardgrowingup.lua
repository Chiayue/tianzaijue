---卡牌成长类型
CardGrowupType = {
	None = enumid(0),
	---解锁金卡
	GoldCard = enumid(),
	---随机属性
	RandomAttribute = enumid(),
	RandomAttribute_MaxVal = enumid(),
	---解锁铭刻
	Memory = enumid(),

	---属性
	AttributeBeging = enumid(1000),
	[ATTRIBUTE_KIND.PhysicalAttack] = enumid(),
	[ATTRIBUTE_KIND.MagicalAttack] = enumid(),
	[ATTRIBUTE_KIND.PhysicalArmor] = enumid(),
	[ATTRIBUTE_KIND.MagicalArmor] = enumid(),
	[ATTRIBUTE_KIND.StatusHealth] = enumid(),
	[ATTRIBUTE_KIND.StatusMana] = enumid(),
	[ATTRIBUTE_KIND.ManaRegen] = enumid(),
	[ATTRIBUTE_KIND.AttackSpeed] = enumid(),
	[ATTRIBUTE_KIND.MoveSpeed] = enumid(),
	AttributeAll = enumid(),
}
enum(CardGrowupType)


if CardGrowingUp == nil then
	---@class CardGrowingUp
	CardGrowingUp = {
	}
end
---@type CardGrowingUp
local public = CardGrowingUp

function public:init(bReload)
	if not bReload then
	end

	-- CustomUIEvent("PlayerOperate_CardGrowingUpCard", Dynamic_Wrap(public, "OnPlayerOperate_CardGrowingUpCard"), public)
	EventManager:register(ET_PLAYER.ON_TOWER_SPAWNED, 'OnTowerSpawned', public)

	self:UpdateNetTables()
end
--UI事件************************************************************************************************************************
	do
end
--事件监听************************************************************************************************************************
	do
	---英雄棋子生成
	---@param tEvent EventData_ON_TOWER_SPAWNED
	function public:OnTowerSpawned(tEvent)
		local iPlayerID = tEvent.PlayerID
		local hUnit = tEvent.hBuilding:GetUnitEntity()

		self:SetUnitGrowingUp(hUnit)
	end
end
--事件监听************************************************************************************************************************
--
function public:UpdateNetTables()
	-- CustomNetTables:SetTableValue("common", "player_reCardGrowingUp_chance", self.tReCardGrowingUpChance)
	CustomNetTables:SetTableValue("common", "card_growup_type", CardGrowupType)
end

---获取玩家某卡牌单位某星级成长属性加成
function public:GetPlayerGrowingUpAttribute(iPlayerID, sUnitName, iStarLevel)
	local tAttribute = {}

	local tGrowingUp = HeroCard:GetPlayerOneCardGrowupInfo(iPlayerID, sUnitName)
	for type, val in pairs(tGrowingUp) do
		if type > CardGrowupType.AttributeBeging then
			local typeAttribute = CardGrowupType[type]
			if type == CardGrowupType.AttributeAll then
				-- 特殊全属性
				tAttribute[ATTRIBUTE_KIND.PhysicalAttack] = val + (tAttribute[ATTRIBUTE_KIND.PhysicalAttack] or 0)
				tAttribute[ATTRIBUTE_KIND.PhysicalArmor] = val + (tAttribute[ATTRIBUTE_KIND.PhysicalArmor] or 0)
				tAttribute[ATTRIBUTE_KIND.MagicalAttack] = val + (tAttribute[ATTRIBUTE_KIND.MagicalAttack] or 0)
				tAttribute[ATTRIBUTE_KIND.MagicalArmor] = val + (tAttribute[ATTRIBUTE_KIND.MagicalArmor] or 0)
				tAttribute[ATTRIBUTE_KIND.StatusHealth] = val + (tAttribute[ATTRIBUTE_KIND.StatusHealth] or 0)
			else
				-- 单属性
				tAttribute[typeAttribute] = val + (tAttribute[typeAttribute] or 0)
			end
		end
	end

	for typeAttribute, iVal in pairs(tAttribute) do
		local fRate = HeroCard:GetCardDefaultAttributeCoefficient(sUnitName, CardGrowupType[typeAttribute])
		tAttribute[typeAttribute] = iVal * (fRate ^ (iStarLevel - 1))
	end

	return tAttribute
end

---设置卡牌英雄成长属性
function public:SetUnitGrowingUp(hUnit)
	if not IsValid(hUnit) then return end

	local iPlayerID = GetPlayerID(hUnit)
	local sUnitName = hUnit:GetUnitName()

	--添加成长技能
	local hAblt = hUnit:AddAbility('external_attribute')
	if hAblt then
		hAblt:SetLevel(1)
	end
end


return public