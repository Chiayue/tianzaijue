if Settings == nil then
	Settings = {}
end
local public = Settings
DEBUG_MODE = false																		--- 调试模式
VERSION = '1.1f'																		--- 版本号
if IsInToolsMode() or (GameRules and GameRules:IsCheatMode()) then	VERSION = VERSION .. 'dev' end

MAX_HEALTH = 2147483000

-- 激活码
NEED_ACTIVE_CKD = true
ACTIVE_CKD = 'azsx'


--游戏规则相关--------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
GAME_MODE_SELECTION_TIME = 0															-- 模式选择阶段时间
GAME_MODE_SELECTION_LOCK_TIME = 0														-- 模式选择阶段锁定时间
if IsInToolsMode() then
	GAME_MODE_SELECTION_TIME = 0														-- （工具模式）模式选择阶段时间
	GAME_MODE_SELECTION_LOCK_TIME = 0													-- （工具模式）模式选择阶段锁定时间
end
USE_HERO_CARD_TO_BUILDING_IN_BATTLEING = true											---战斗时操作英雄卡牌（放置）
USE_HERO_CARD_TO_EXCANGE_IN_BATTLEING = false											---战斗时操作英雄卡牌（交换）
USE_HERO_CARD_TO_LEVELUP_IN_BATTLEING = true											---战斗时操作英雄卡牌（升级）
BORNPLACE_PREPARE_TIME = 60															---出生岛的准备时间
GET_MAX_MATCH_REFRESH_TIMES = 2															---玩家整局最大神器、道具刷新次数
INIT_PLAYER_SPEELCARD_COUNT = 0															---初始玩家法术卡数量
SELL_SPELL_CRYSTAL_PERCENT = 50															-- 法术卡出售价值百分比
PLAYER_SPEELCARD_HAND_MAX = 4															---玩家法术卡手牌上限
CONSUMABLE_HERO_HELP_UNIT_NAME = 'storm_spirit'											---消耗品：英雄助阵的单位
SELECT_ITEM_TIMEOUT = 60																---选择装备神器的超时时间 /s
SELECT_ITEM_GIVEUP_GOLD = 300															---弃选择装备神器的金币奖励
SELECT_ITEM_GIVEUP_CRYSTAL = 30															---弃选择装备神器的魂晶奖励
SELECT_ITEM_BY_BOSS_WIN = {																---BOSS回合胜利额外选装备配置
	[10] = {
		select_items = 'ItemLevel_2 | ItemLevel_3',
		select_items_count = 0,
	},
	[20] = {
		select_items = 'ItemLevel_3 | ItemLevel_4',
		select_items_count = 0,
	},
	[30] = {
		select_items = 'ItemLevel_4 | ItemLevel_5',
		select_items_count = 0,
	},
}

MISS_ENEMY_BOSS_INTENSIFY_ATTRIBUTE = function(hUnit)									---漏怪增加BOSS的属性
	return {
		[EMDF_STATUS_HEALTH_BONUS_PERCENTAGE] = 3,
		[EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE] = 3,
		[EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE] = 3,
	}
end

--卡组、组卡--------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
GROUP_CARD_CARD_COUNT = 54																--- 卡组最大英雄卡数量
GROUP_CARD_CARD_COUNT_MIN = 16															--- 卡组最少英雄卡数量
GROUP_CARD_CAN_SAME_CARD = false														--- 卡组可以有相同英雄卡

--宝箱怪--------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
ENEMY_GOOD_DURATION = 45																---宝箱持续时间
ENEMY_GOOD_DEATH_DURATION = 3															---宝箱死亡时石化持续时间
ENEMY_GOOD_TP_DURATION = 5																---宝箱传送持续时间
ENEMY_GOLD_DEATH_ADD_HP_RATE = 0.3														---宝箱怪死亡血量增加倍率
function GET_GOLD_ENEMY_GOLD(iDeath)													-- 获取宝箱金币掉落数
	--奖励总和
	local iReward = RandomInt(80, 120)
	--掉落实体数
	local iEntityCount = Clamp(math.ceil(iReward / 40), 1, 10)
	return iReward, iEntityCount
end
function GET_GOLD_ENEMY_CRYSTAL(iDeath)													-- 获取宝箱魂晶掉落数
	--奖励总和
	local iReward = 1 + iDeath
	--掉落实体数
	local iEntityCount = Clamp(math.ceil(iDeath / 10), 1, 10)
	return iReward, iEntityCount
end
function CRYSTAL_AUTO_PICKUP_TIME()														-- 魂晶自动拾取时间
	return RandomFloat(1, 4)
end

--英雄塔--------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
HERO_MAX_LEVEL = 5																		-- 英雄最大等级
HERO_XP_PER_LEVEL_TABLE = {																-- 英雄塔经验表
	0,
	1,
	3,
	7,
	11
}
BASE_XP_LEVEL_TABLE = {																	-- 原生经验表
	0,
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8,
	9
}
ITEM_UNLOCK_LEVEL = {																	---英雄的物品格数量和解锁等级
	[DOTA_ITEM_SLOT_1 or 0] = 1,
	[DOTA_ITEM_SLOT_2 or 1] = 1,
	[DOTA_ITEM_SLOT_3 or 2] = 3,
}
GET_BUILDING_MANA_REGEN_EXTRA = function(fLostHpPer)									--英雄损失生命值额外回魔
	return fLostHpPer * 0.001
end
PUDDING_VALUES = {																		---移动英雄位置后的布丁系数
	duration = 0.3,
	change = 0.15, --振幅
	rate = 10, --振频 次数/s
}
GAME_CARD_RATE = HERO_XP_PER_LEVEL_TABLE[HERO_MAX_LEVEL] * 3							-- 卡组单卡对应游戏内卡牌数量
--指挥官等级与税金--------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
SELL_CARD_GOLD_PERCENT = {																--各星级卡牌出售金币折扣
	50, --1星	5折
	50, --2星	5折
	50, --3星	5折
	50, --4星	5折
	50, --5星	5折
}
TAX = {																					--手牌税收：1，2，3，4，5星
	n =	{ 30, 75, 150, 200, 225 },
	r =	{ 30, 75, 150, 200, 225 },
	sr = { 30, 75, 150, 200, 225 },
	ssr = { 30, 75, 150, 200, 225 },
}
TAX_CARD_COEFFICIENT = { 0 }															--漏怪扣除税金系数
function TAX_CARD_PLAYER_LEVEL_COEFFICIENT(iLevel, iGold)								--指挥官等级提升税金系数
	return iGold + (iGold * (iLevel - 1) * 0.05)
end
HAND_HERO_CARD_MAX = {																	--不同指挥官等级待定区手牌上限
	[1] = 3,
	[2] = 4,
	[3] = 5,
	[4] = 6,
	[5] = 7,
	[6] = 7,
	[7] = 7,
	[8] = 7,
	[9] = 7,
	[10] = 7,
}
HAND_HERO_CARD_MAX_COUNT = function()													--获取英雄卡手牌最大数量
	return HAND_HERO_CARD_MAX[#HAND_HERO_CARD_MAX]
end
LEVELUP_COST_GOLD = {																	--指挥官升级消耗金币数量
	400, --2
	800, --3
	1200, --4
	2000, --5
	3000, --6
	4000, --7
	5000, --8
	6000, --9
	8000, --10
}
for i = 10, 100 do
	LEVELUP_COST_GOLD[i] = LEVELUP_COST_GOLD[9] + 2000 * (i - 9)
end

--装备升级锻造重铸--------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
ITEM_LEVELUP_STAR_COST_GOLD = {															--物品升星消耗
	[1] =		{ 25, 25, 25 },
	[2] =		{ 50, 50, 50 },
	[3] =		{ 75, 75, 75 },
	[4] =		{ 100, 100, 100 },
	[5] =		{ 200, 200, 200 },
}
ITEM_REMAKE_STAR_COST_GOLD = {															--物品重铸消耗
	[1] =		25,
	[2] =		50,
	[3] =		100,
	[4] =		100,
}
ITEM_REMAKE_CHANCE = {																	--物品重铸升品概率
	[1] =		60,
	[2] =		50,
	[3] =		40,
	[4] =		0,
}

--黑市配置----------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
MARKET_REFRESH_MAXCOUNT = 99															-- 黑市商店最大商品限制
MARKET_REFRESH_ROUND = 3																-- 黑市商店刷新黑市物品回合数
MARKET_REFRESH_ITEMS = 1																-- 黑市商店每次出现物品个数
MARKET_REFRESH_CHANCE = 100																-- 黑市商店刷新几率
MARKET_ITEMBUYS_TIMES = 1																-- 黑市物品购买价值倍数（黑市商人卖的价格倍率）
MARKET_OCCURENCE_ROUND = 3																-- 黑市首次刷新回合
CARD_EXCHANGE_GOLD = 0.8																-- 黑市卖出物品二次折扣(与扔进垃圾桶的钱相关)
BUYCARD_EXCHANGE_GOLD = 1.2																-- 黑市购买物品金币系数(与本身卡片价值相关)
ITEM_EXCHANGE_GOLD = {																	-- 黑市出售物品金币售价
	[1] =		100,
	[2] =		225,
	[3] =		600,
	[4] =		900,
}
ITEM_EXCHANGE_BUYGOLD = {																--黑市购买物品金币价格
	[1] =		200,
	[2] =		450,
	[3] =		1200,
	[4] =		1800,
}
ITEM_EXCHANGE_BUYCRYSTAL = {															--黑市购买物品魂晶价格
	[1] =		20,
	[2] =		45,
	[3] =		120,
	[4] =		180,
}
GAME_SHOP_HERO_UNLOCK_ROUND = 5															-- 黑市解锁英雄购买的回合（废弃）
GAME_SHOP_HERO_MAX = 12																	-- 黑市英雄购买上限（废弃）
GAME_SHOP_HERO_COST = { n = 20, r = 40, sr = 80, ssr = 160,}							-- 黑市各品质英雄卡魂晶价格（废弃）

--刷卡-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
USEITEM_DRAW_FIRST = 2
LUCKY_REFRESH_TIME = 0																	---幸运刷新时间/秒
LUCKY_MAX = 1																			---幸运点数上限
COST_GOLD_ROUND = 0																		--抽卡消耗金币-回合系数
COST_GOLD_LEVEL = 0																		--抽卡消耗金币-等级系数
DRAW_CARD_UPDATE_TIME = 999																--抽卡刷新时间
DRAW_CARD_COST_GOLD = { 100, 100, 100 }													--初始抽卡消耗金币数量{小，中，大}
DRAW_CARD_UPDATE_COUNT_MAX = function(iPlayerID)										--抽卡刷新点数上限
	local iPlayerLevel = PlayerData:GetPlayerLevel(iPlayerID)
	return 0
end
DRAW_CARD_UPDATE_ROUND = function(iPlayerID)											--抽卡刷新回合
	local iPlayerLevel = PlayerData:GetPlayerLevel(iPlayerID)
	return 0
end
function GET_DRAW_CARD_COST_GOLD(iPlayerID, iDrawLevel)									--回合刷新消耗金币数量
	iDrawLevel = iDrawLevel or 1
	local iFrfreshCostPct = Draw:GetPlayerFixedCardRefreshCostPercent(iPlayerID)
	local iFrfreshCost = Draw:GetPlayerFixedCardRefreshCostConstant(iPlayerID)
	local dynamic_price = math.max(0, (DRAW_CARD_COST_GOLD[iDrawLevel] + Spawner:GetRound() * COST_GOLD_ROUND + PlayerData:GetPlayerLevel(iPlayerID) * COST_GOLD_LEVEL) * (iFrfreshCostPct and iFrfreshCostPct or 100) * 0.01 - (iFrfreshCost and (iFrfreshCost) or 0))
	return math.min(dynamic_price, 200)
end
function GET_DRAW_CARD_COST_GOLD_ALL(iPlayerID)											--????
	local t = {}
	for iDrawLevel, _ in pairs(DRAW_CARD_COST_GOLD) do
		t[iDrawLevel] = GET_DRAW_CARD_COST_GOLD(iPlayerID, iDrawLevel)
	end
	return t
end
function GET_LEVELUP_COST_GOLD(iPlayerID)												--升级人口消耗金钱
	local iLevel = PlayerData:GetPlayerLevel(iPlayerID)

	if #LEVELUP_COST_GOLD < iLevel then
		iLevel = #LEVELUP_COST_GOLD
	end
	local iGoldreducepct = 100 - PlayerData:GetcmdUpgradeDiscont(iPlayerID)
	local iGold = LEVELUP_COST_GOLD[iLevel] * iGoldreducepct * 0.01
	-- return LEVELUP_COST_GOLD + Spawner:GetRound() * COST_GOLD_ROUND + PlayerData:GetPlayerLevel(iPlayerID) * COST_GOLD_LEVEL
	return iGold
end
CARD_POOL_LIMIT = {																		--卡池内卡牌稀有度数量限制
	ssr = 2,
	sr = 6,
	r = 8,
	n = 10,
}

--控制刷怪----------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------
TEAM_ENEMY_DOOR_NAME = 'EnemyPortal'													--怪物传送门
TEAM_DOOR_POINT = '_Enemy_Path_A_2'														--各队伍传送门坐标
TEAM_DOOR_OPEN_RANGE = 600																--传送门开启触发范围
TEAM_DOOR_RANGE = 100																	--传送门进入触发范围
BOSS_MAP_POINT_NAME = 'point_Boss_C1'													--Boss地图锚点
BOSS_MAP_FOW_RADIUS = 20000																--Boss区域视野半径
LIMIT_PATHING_SEARCH_DEPTH = 100														--寻路搜索深度
SPAWN_POINT_OFFSET_SIZE = 0																--怪物生成点偏移大小
TEAM_MAP_POINT_ENTITY = {																--各队伍地图锚点
	"TeamMapPoint_1",
	"TeamMapPoint_2",
	"TeamMapPoint_3",
	"TeamMapPoint_4",
}
TEAM_BOSS_MAP_POINT_ENTITY = {															--各队伍Boss地图锚点
	"TeamBossMapPoint_1",
	"TeamBossMapPoint_2",
	"TeamBossMapPoint_3",
	"TeamBossMapPoint_4",
}
ENEMY_MOVE_PATH = {																		--怪物移动路径
	"Enemy_Path_A_0",
	"Enemy_Path_B_0",
}
SPAWN_POINT_OFFSET_ARRAY = {															--怪物生成点偏移值
	[Vector(SPAWN_POINT_OFFSET_SIZE, SPAWN_POINT_OFFSET_SIZE, 0)] = 1,		[Vector(0, SPAWN_POINT_OFFSET_SIZE, 0)] = 1,		[Vector(-SPAWN_POINT_OFFSET_SIZE, SPAWN_POINT_OFFSET_SIZE, 0)] = 1,
	[Vector(SPAWN_POINT_OFFSET_SIZE, 0, 0)] = 1,							[Vector(0, 0, 0)] = 1,								[Vector(-SPAWN_POINT_OFFSET_SIZE, 0, 0)] = 1,
	[Vector(SPAWN_POINT_OFFSET_SIZE, -SPAWN_POINT_OFFSET_SIZE, 0)] = 1,		[Vector(0, -SPAWN_POINT_OFFSET_SIZE, 0)] = 1,		[Vector(-SPAWN_POINT_OFFSET_SIZE, -SPAWN_POINT_OFFSET_SIZE, 0)] = 1,
}


--难度--------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
INIT_GOLD = 800																			---初始金钱
PLAYER_MANA_REGEN = 100																	---玩家每回合魔法恢复
PLAYER_HEALTH_REGEN = 0																	---玩家每回合生命恢复
PLAYER_MANA = 100																		---玩家魔法
PLAYER_HEALTH = 3															---玩家生命
PLAYER_HP_PERCENTAGE = 0																---玩家血量额外百分比
PLAYER_DAMAGE_FROM_COMMANDER_DEATH = 1													---指挥官死亡玩家扣血数量
BUILDING_MIN_COUNT = 3																	-- 开局人口
HERO_BUILDING_MAX_COUNT = 9															-- 人口最大数量
PLAYER_LEVEL_MAX = 100																	-- 玩家等级最大
PLAYER_LEVEL_GIEVE_ARTIFACT = 8															-- 开始升级后给神器的等级
PLAYER_LEVEL_GIEVE_ARTIFACT_POOL = 'PlayerLevelUpArtifact'								-- 升级给神器的抽奖池
PLAYER_LEVEL_GIEVE_ARTIFACT_COUNT = 2													-- 升级给神器的挑选数量
DIFFICULTY = {																			-- 难度分类
	Endless = 0,
	N1 = 1,
	N2 = 2,
	N3 = 3,
	N4 = 4,
	N5 = 5,
	N6 = 6,
	N7 = 7,
	N8 = 8,
	N9 = 9,
	N10 = 10,
	N11 = 11,
	N12 = 12,
	N13 = 13,
}
DIFFICULTY_DEFAULT = DIFFICULTY.N1														-- 默认难度

DIFFICULTY_INFO = {																		-- 难度信息
	[DIFFICULTY.Endless] = {
		all_random = true,
		game_over_round = 40,
		creep_skills = true,
		contract = true,
	},
	[DIFFICULTY.N1] = {
		all_random = true,
		game_over_round = 30,
		creep_skills = false
	},
	[DIFFICULTY.N2] = {
		all_random = true,
		game_over_round = 40,
		creep_skills = true
	},
	[DIFFICULTY.N3] = {
		all_random = true,
		game_over_round = 40,
		creep_skills = true
	},
	[DIFFICULTY.N4] = {
		all_random = true,
		game_over_round = 40,
		creep_skills = true
	},
	[DIFFICULTY.N5] = {
		all_random = true,
		game_over_round = 40,
		creep_skills = true
	},
	[DIFFICULTY.N6] = {
		all_random = true,
		game_over_round = 40,
		creep_skills = true
	},
	[DIFFICULTY.N7] = {
		all_random = true,
		game_over_round = 40,
		creep_skills = true
	},
	[DIFFICULTY.N8] = {
		all_random = true,
		game_over_round = 40,
		creep_skills = true,
		contract = true,
	},
	[DIFFICULTY.N9] = {
		all_random = true,
		game_over_round = 40,
		creep_skills = true,
		contract = true,
	},
	[DIFFICULTY.N10] = {
		all_random = true,
		game_over_round = 40,
		creep_skills = true,
		contract = true,
	},
	[DIFFICULTY.N11] = {
		all_random = true,
		game_over_round = 40,
		creep_skills = true,
		contract = true,
	},
	[DIFFICULTY.N12] = {
		all_random = true,
		game_over_round = 40,
		creep_skills = true,
		contract = true,
	},
	[DIFFICULTY.N13] = {
		all_random = true,
		game_over_round = 40,
		creep_skills = true,
		contract = true,
	},
}
ENEMY_ATTRIBUTE_MODIFIER = function(hUnit)											---回合怪物属性修正
	local iRound = Spawner:GetRound()
	local iPlayerCount = PlayerData:GetAlivePlayerCount()
	local t = {}
	-- 基础数值倍率
	local tBasePercentage = {}
	-- 基础数值百分比提升
	if hUnit:IsBoss() then
		-- BOSS
		tBasePercentage[EMDF_STATUS_HEALTH_BONUS] = ({ 0, 200, 400, 600 })[iPlayerCount]
		tBasePercentage[EMDF_PHYSICAL_ATTACK_BONUS] = ({ 0, 0, 0, 0 })[iPlayerCount]
		tBasePercentage[EMDF_MAGICAL_ATTACK_BONUS] = ({ 0, 0, 0, 0 })[iPlayerCount]
		tBasePercentage[EMDF_PHYSICAL_ARMOR_BONUS] = ({ 0, 0, 0, 0 })[iPlayerCount]
		tBasePercentage[EMDF_MAGICAL_ARMOR_BONUS] = ({ 0, 0, 0, 0 })[iPlayerCount]
	elseif not hUnit:IsGoldWave() then
		-- 非宝箱怪
		tBasePercentage[EMDF_STATUS_HEALTH_BONUS] = 0
		tBasePercentage[EMDF_PHYSICAL_ATTACK_BONUS] = 0
		tBasePercentage[EMDF_MAGICAL_ATTACK_BONUS] = 0
		tBasePercentage[EMDF_PHYSICAL_ARMOR_BONUS] = 0
		tBasePercentage[EMDF_MAGICAL_ARMOR_BONUS] = 0
	end
	for typeEMdf, fValPercentage in pairs(t) do
		local fBase = hUnit:GetValConstByKey(E_DECLARE_FUNCTION[typeEMdf].attribute_kind, ATTRIBUTE_KEY.BASE)
		t[typeEMdf] = fBase * fValPercentage * 0.01
	end
	if hUnit:IsBoss() then
	elseif not hUnit:IsGoldWave() then
		-- 基础数值附加固定值
	end
	return t
end
if IsServer() and not public._GetInitGoldBonus then
	public._GetInitGoldBonus = EModifier:CreateModifier(EMDF_INIT_GOLD_BONUS)
	---获取玩家初始金币
	function public:GetInitGold(iPlayerID)
		local iGold = INIT_GOLD
		for _, tVals in pairs(public._GetInitGoldBonus(iPlayerID)) do
			iGold = (tVals[1] or 0) + iGold
		end
		return iGold
	end
end

--系统参数--------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
CORRECT_GOLD = 50000																--正确金币数额
MAX_GOLD = 9999999																	--最大允许金币数量
AI_TIMER_TICK_TIME = 0.5															-- AI的计时器间隔
FORCE_PICKED_HERO = "npc_dota_hero_phoenix"											-- 强制所有玩家选择英雄
LOCAL_PARTICLE_MODIFIER_DURATION = 3 / 30 											-- 本地特效modifier持续时间
BUILD_SAME_TOWER = true																--允许建造相同防御塔


--契约参数--------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
CONTRACT_LEVEL_FACTOR = 0 -- 契约等级系数，契约等级=回合+完成契约次数*契约等级系数
CONTRACT_REFRESH_AMOUNT = 2 -- 刷新契约数
CONTRACT_AUTO_REFRESH_ROUND = 10 -- 自动刷新契约回合
CONTRACT_SPAWN_POINT = "point_P1" -- 契约怪物诞生点，可像刷怪一样填写各个刷怪点，支持"|"写多个点，会随机选其中一个点诞生
-- 弃用
CONTRACT_ADD_FREE_REFRESH_POINTS_START_ROUND = 1 -- 契约获得免费刷新开始回合
CONTRACT_ADD_FREE_REFRESH_POINTS_ROUND = 1 -- 契约获得免费刷新回合，从开始刷新回合算起每多少回合刷新一次
CONTRACT_ADD_FREE_REFRESH_POINTS = 0 -- 契约获得免费点数
-- 开始契约花费金钱
function CONTRACT_START_REFRESH_GOLD_COST(iStartRefreshCount)
	return iStartRefreshCount * 300
end
-- 开始契约花费魂晶
function CONTRACT_START_REFRESH_CRYSTAL_COST(iStartRefreshCount)
	return 0
end
-- 强化花费金钱
function CONTRACT_REFRESH_GOLD_COST(iContinuousRefreshCount)
	return 0
end
-- 强化花费金钱
function CONTRACT_REFRESH_CRYSTAL_COST(iContinuousRefreshCount)
	return 10
end
function CONTRACT_CONTINUOUS_LEVEL_FACTOR(iContinuousRefreshCount)
	return iContinuousRefreshCount * 4
end
function CONTRACT_BOUNTY_GOLD(iContinuousRefreshCount, iRound)
	return 100 + 100 * iContinuousRefreshCount + CONTRACT_REFRESH_GOLD_COST(0) * iContinuousRefreshCount
	--  + (CONTRACT_REFRESH_GOLD_COST * 4 / iRound)
end
function CONTRACT_BOUNTY_CRYSTAL(iContinuousRefreshCount, iRound)
	return 5 * iContinuousRefreshCount + iRound + CONTRACT_REFRESH_CRYSTAL_COST(0) * iContinuousRefreshCount
end

--[[	伤害Flag

	DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION -- 不受技能增强影响
	DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT -- 不会受到额外伤害加深
	DOTA_DAMAGE_FLAG_NO_SPELL_CRIT -- 不会触发技能暴击
]]
--
if IsServer() then
	DOTA_DAMAGE_FLAG_NO_SPELL_CRIT = DOTA_DAMAGE_FLAG_IGNORES_BASE_PHYSICAL_ARMOR * 2 ^ 1			--不能暴击
	DOTA_DAMAGE_FLAG_CRIT = DOTA_DAMAGE_FLAG_IGNORES_BASE_PHYSICAL_ARMOR * 2 ^ 2 					-- 暴击伤害
	DOTA_DAMAGE_FLAG_MISS = DOTA_DAMAGE_FLAG_IGNORES_BASE_PHYSICAL_ARMOR * 2 ^ 3 					-- 闪避
	DOTA_DAMAGE_FLAG_NO_MISS = DOTA_DAMAGE_FLAG_IGNORES_BASE_PHYSICAL_ARMOR * 2 ^ 4 				-- 不能闪避
	DOTA_DAMAGE_FLAG_NO_HEAL = DOTA_DAMAGE_FLAG_IGNORES_BASE_PHYSICAL_ARMOR * 2 ^ 5 				-- 不能吸血
	DOTA_DAMAGE_FLAG_NO_CUSTOM = DOTA_DAMAGE_FLAG_IGNORES_BASE_PHYSICAL_ARMOR * 2 ^ 6 				-- 自定义化
	DOTA_DAMAGE_FLAG_LIGHT_SPEAKER_AMULET = DOTA_DAMAGE_FLAG_IGNORES_BASE_PHYSICAL_ARMOR * 2 ^ 7	-- 轻语吊坠延迟伤害
	DOTA_DAMAGE_FLAG_FATAL_BOND = DOTA_DAMAGE_FLAG_IGNORES_BASE_PHYSICAL_ARMOR * 2 ^ 8				-- 致命链接伤害
	DOTA_DAMAGE_FLAG_SPELL = DOTA_DAMAGE_FLAG_IGNORES_BASE_PHYSICAL_ARMOR * 2 ^ 9					-- 法术卡伤害
	DOTA_DAMAGE_FLAG_DARK_WILLOW = DOTA_DAMAGE_FLAG_IGNORES_BASE_PHYSICAL_ARMOR * 2 ^ 10			-- 法术卡伤害
end

--[[	自定义modifier事件
]]
--
MODIFIER_EVENT_ON_SPELL_CRIT = MODIFIER_FUNCTION_LAST + 1 							-- OnSpellCrit
MODIFIER_EVENT_ON_DAMAGE_CRIT = MODIFIER_EVENT_ON_SPELL_CRIT + 1 					-- OnDamageCrit
MODIFIER_FUNCTION_NAME = {
	[MODIFIER_EVENT_ON_SPELL_CRIT] = "OnSpellCrit",
	[MODIFIER_EVENT_ON_DAMAGE_CRIT] = "OnDamageCrit",
}
RARITY_COLOR = {																	-- 稀有度颜色
	["n"] = Vector(210, 207, 208),
	["r"] = Vector(136, 179, 241),
	["sr"] = Vector(191, 172, 235),
	["ssr"] = Vector(255, 212, 165),
}
function public:init(bReload)
	local GameMode = GameRules:GetGameModeEntity()
	LimitPathingSearchDepth(LIMIT_PATHING_SEARCH_DEPTH)
	GameRules:SetHeroRespawnEnabled(false)
	GameRules:SetSameHeroSelectionEnabled(true)
	GameRules:SetHeroSelectionTime(99999)
	GameRules:SetHeroSelectPenaltyTime(0)
	GameRules:SetStrategyTime(0.5)
	GameRules:SetShowcaseTime(0)
	GameRules:SetPreGameTime(0)
	GameRules:SetPostGameTime(3000)
	GameRules:SetTreeRegrowTime(10)
	GameRules:SetGoldPerTick(0)
	GameRules:SetGoldTickTime(0)
	GameRules:SetUseBaseGoldBountyOnHeroes(false)
	GameRules:SetFirstBloodActive(false)
	GameRules:SetHideKillMessageHeaders(true)
	GameRules:SetUseUniversalShopMode(false)
	GameRules:SetStartingGold(0)
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 4)
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 0)
	GameRules:SetUseCustomHeroXPValues(true)
	GameMode:SetSelectionGoldPenaltyEnabled(false)
	GameMode:SetUseCustomHeroLevels(true)
	GameMode:SetCustomHeroMaxLevel(#BASE_XP_LEVEL_TABLE)
	GameMode:SetCustomXPRequiredToReachNextLevel(BASE_XP_LEVEL_TABLE)
	GameMode:SetWeatherEffectsDisabled(true)
	GameMode:SetAlwaysShowPlayerNames(false)
	GameMode:SetRecommendedItemsDisabled(true)
	GameMode:SetGoldSoundDisabled(true)
	GameMode:SetFogOfWarDisabled(false)
	GameMode:SetUnseenFogOfWarEnabled(false)
	GameMode:SetLoseGoldOnDeath(false)
	GameMode:SetCustomBuybackCooldownEnabled(true)
	GameMode:SetCustomBuybackCostEnabled(true)
	GameMode:SetMaximumAttackSpeed(700)
	GameMode:SetMinimumAttackSpeed(20)
	GameMode:SetStashPurchasingDisabled(true)
	GameMode:SetStickyItemDisabled(true)
	GameMode:SetDaynightCycleDisabled(false)
	GameMode:SetAnnouncerDisabled(true)
	GameMode:SetKillingSpreeAnnouncerDisabled(true)
	GameMode:SetPauseEnabled(true)
	GameMode:SetCameraZRange(0, 500)
	if IsInToolsMode() then
		GameRules:SetCustomGameSetupAutoLaunchDelay(0)
		GameRules:LockCustomGameSetupTeamAssignment(true)
		GameRules:EnableCustomGameSetupAutoLaunch(true)
		GameRules:SetStartingGold(0)
	else
		GameRules:SetCustomGameSetupAutoLaunchDelay(0)
		GameRules:LockCustomGameSetupTeamAssignment(true)
		GameRules:EnableCustomGameSetupAutoLaunch(true)
		GameMode:SetBuybackEnabled(false)
	end
	SendToServerConsole("dota_max_physical_items_purchase_limit 9999")
	CustomNetTables:SetTableValue("common", "hero_xp_per_level_table", HERO_XP_PER_LEVEL_TABLE)
	CustomNetTables:SetTableValue("common", "settings", {
		VERSION = VERSION,
		item_levelup_star_cost_gold = ITEM_LEVELUP_STAR_COST_GOLD,
		item_remake_star_cost_gold = ITEM_REMAKE_STAR_COST_GOLD,
		item_remake_chance = ITEM_REMAKE_CHANCE,
		item_exchange_gold = ITEM_EXCHANGE_GOLD,
		item_exchange_buygold = ITEM_EXCHANGE_BUYGOLD,
		item_exchange_buycrystal = ITEM_EXCHANGE_BUYCRYSTAL,
		card_exchange_gold = CARD_EXCHANGE_GOLD,
		buycard_exchange_gold = BUYCARD_EXCHANGE_GOLD,
		sell_card_gold_percent = SELL_CARD_GOLD_PERCENT,
		sell_spell_crystal_percent = SELL_SPELL_CRYSTAL_PERCENT,
		hand_hero_card_max_count = HAND_HERO_CARD_MAX_COUNT(),
		difficulty = DIFFICULTY,
		difficulty_info = DIFFICULTY_INFO,
		market_itembuys_times = MARKET_ITEMBUYS_TIMES,
		game_mode_selection_time = GAME_MODE_SELECTION_TIME,
		game_mode_selection_lock_time = GAME_MODE_SELECTION_LOCK_TIME,
		force_picked_hero = FORCE_PICKED_HERO,
		game_shop_hero_unlock_round = GAME_SHOP_HERO_UNLOCK_ROUND,
		game_shop_hero_max = GAME_SHOP_HERO_MAX,
		game_shop_hero_cost = GAME_SHOP_HERO_COST,
		contract_auto_refresh_round = CONTRACT_AUTO_REFRESH_ROUND,
		contract_add_free_refresh_points_start_round = CONTRACT_ADD_FREE_REFRESH_POINTS_START_ROUND,
		contract_add_free_refresh_points_round = CONTRACT_ADD_FREE_REFRESH_POINTS_ROUND,
		is_local_host = not IsDedicatedServer(),
		is_cheat_mode = GameRules:IsCheatMode(),
	})
end

return public