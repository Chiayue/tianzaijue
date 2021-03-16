--游戏事件
if nil == ET_GAME then
	---@class ET_GAME 游戏事件
	ET_GAME = {
		GAME_READY = enumid(0), --游戏准备阶段（玩家位于出生岛）
		GAME_BEGIN = enumid(), --游戏开始（全部玩家准备，进图各自场地内）
		DIFFICULTY_CHANGE = enumid(), --难度更换
		EPISODE_BEGIN = enumid(), --章节开始
		ROUND_CHANGE = enumid(), --回合转换
		NPC_SPAWNED = enumid(), --单位生成
		NPC_FIRST_SPAWNED = enumid(), --单位首次生成
		NPC_DEATH = enumid(), --单位死亡
		NPC_DESTROYED = enumid(), --单位销毁
		ON_CLONED = enumid(), --克隆单位
		ON_SUMMONED = enumid(), --召唤单位
		ON_ILLUSION = enumid(), --创建幻象单位
		ON_TELEPORTED = enumid(), --传送
		DAMAGE_FILTER = enumid(), --伤害过滤
		MODS_LOADOVER = enumid(), --游戏模块加载完成
		GAME_BALANCE = enumid(), --游戏结算
		GAME_END = enumid(100), --游戏结束
	}
	enum_unique(ET_GAME)
end

--战斗流程事件
if nil == ET_BATTLE then
	---@class ET_BATTLE 战斗流程事件
	ET_BATTLE = {
		ON_PREPARATION = enumid(0), --备战
		ON_PREPARATION_END = enumid(), --备战阶段 结束
		ON_BATTLEING = enumid(), --战斗
		ON_BATTLEING_END = enumid(), --战斗阶段 结束
		ON_BOSS_BOMB = enumid(), --BOSS爆炸
		ON_BATTLEING_ENDWAIT_START = enumid(), --战斗结束等待阶段 开始
		ON_BATTLEING_ENDWAIT_END = enumid(), --战斗结束等待阶段 结束
	}
	enum_unique(ET_BATTLE)
end

--玩家事件
if nil == ET_PLAYER then
	---@class ET_PLAYER 玩家事件
	ET_PLAYER = {
		-- ALL_LOADED_FINISHED = enumid(0), --全玩家加载完成
		ON_LOADED_FINISHED = enumid(1), --玩家加载完成
		ON_DAMAGE = enumid(), --玩家受到伤害
		ON_DEATH = enumid(), --玩家死亡
		ENEMY_COUNT_CHANGE = enumid(), --玩家怪物数量更新
		ROUND_RESULT = enumid(), --玩家当前回合胜负结果通知
		LEVEL_CHANGED = enumid(), --玩家升级人口改变
		CONNECT_STATE_CHANGE = enumid(), -- 连接状态改变
		ON_PLAYER_HERO_SPAWNED = enumid(), --玩家信使英雄生成

		ON_TOWER_SPAWNED = enumid(100), --玩家防御塔单位生成
		ON_TOWER_SELL = enumid(), --玩家防御塔出售
		ON_TOWER_DEATH = enumid(), --玩家防御塔死亡
		ON_TOWER_TO_CARD = enumid(), --玩家防御塔放回手牌
		ON_TOWER_CARD_SELL = enumid(), --玩家防御塔卡牌出售
		ON_TOWER_CARD_EXCHANGE = enumid(), --玩家防御塔卡牌共享
		ON_TOWER_SPAWNED_FROM_CARD = enumid(), --玩家用卡牌建塔
		ON_TOWER_LEVELUP_FROM_CARD = enumid(), --玩家用卡牌升级建筑
		ON_TOWER_NEW_ITEM_ENTITY = enumid(), --玩家防御塔生成物品实体
		ON_TOWER_DESTROY_ITEM_ENTITY = enumid(), --玩家防御塔销毁物品实体
		ON_TOWER_DESTROY = enumid(), --玩家防御塔销毁之前
		ON_TOWER_DESTROYED = enumid(), --玩家防御塔销毁
		ON_TOWER_FINDING_ENEMY = enumid(), --玩家防御塔锁定敌对目标
		ON_TOWER_LEVELUP = enumid(), --玩家防御塔升级
		ON_TOWER_ABILITY_UPDATE = enumid(), --玩家防御塔羁绊技能更新
		ON_HERO_CARD_LEVELUP = enumid(), --英雄卡升级
		ON_HERO_CARD_BUY_IN_DRAW = enumid(), --购买抽卡区域的英雄卡
		ON_DRAW_CARD = enumid(), --玩家抽卡
		ON_CHANGE_HERO_CARD = enumid(), --玩家添加英雄卡

		ON_HERO_CARD_GROWUP_LEVELUP = enumid(), --英雄卡外围成长升级

		ON_ITEM_LVLUPDATE = enumid(200), -- 玩家装备升級
		ON_ITEM_REMAKE = enumid(400), -- 玩家装备重铸
		ON_BUY_SHARINGITEM = enumid(), -- 玩家购买共享物品
		ON_ITEM_SHARE = enumid(), -- 玩家共享物品

		ON_HERO_USE_SPELL = enumid(300), -- 指挥官使用技能卡
		ON_COMMANDER_SPAWNED = enumid(), --指挥官单位生成
		ON_BIRTHPLACE_COMMANDER_SPAWNED = enumid(), --营地指挥官单位生成
		ON_COMMANDER_LEVELUP = enumid(), --指挥官升级

		ON_TAX_BALANCE = enumid(), --玩家结算税金

		ON_GOLD_CHANGE = enumid(), -- 玩家金币数量变更
		ON_ADD_TOTAL_GOLD = enumid(), -- 玩家本局总金币增加

		ON_OPEN_BOX = enumid(), -- 玩家打开宝箱
	}
	enum_unique(ET_PLAYER)
end

--怪物事件
if nil == ET_ENEMY then
	---@class ET_ENEMY 怪物事件
	ET_ENEMY = {
		ON_SPAWNED = enumid(0), --怪物出生
		ON_DEATH = enumid(), --进攻怪物死亡
		ON_ENTER_DOOR = enumid(), --怪物进入传送门
	}
	enum_unique(ET_ENEMY)
end