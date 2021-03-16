require("core/Attribute/AttributeSystem")

--- 额外初始金币
EMDF_INIT_GOLD_BONUS = 'GetInitGoldBonus'	--(iPlayerID)
--- 修改最大建筑数量
EMDF_MAX_BUILDING_BONUS = 'GetModifierMaxBuildingBonus'
--- 固定售卡金币百分比
EMDF_FIXED_SELL_CARD_GOLD_PERCENT = 'GetModifierFixedSellCardGoldPercent'
--- 修改最大手牌数
EMDF_MAX_HAND_CARD_COUNT_BONUS = 'GetModifierMaxHandCardCountBonus'
--- 修改物品星级奖励
EMDF_ITEM_STAR_BONUS = 'GetModifierItemStarBonus'
--- 修改指挥官魔法回复
EMDF_HERO_CONSTANT_MANA_REGEN = 'GetModifierHeroConstantManaRegen'
--- 修改指挥官魔法回复百分比
EMDF_HERO_PERCENTAGE_MANA_REGEN = 'GetModifierHeroPercentageManaRegen'
--- 指挥官升级消耗打折(return 优惠百分比 return 10=9折)
EMDF_CMD_UPGRADE_DISCOUNT_PERCENTAGE = 'GetModifierCmdUpgradeDiscont'
--- 抽卡消耗金币打折(return 优惠百分比 return 10=9折)
EMDF_BUY_CARD_DISCOUNT_PERCENTAGE = 'GetModifierCardBuyDiscont'	--(sCardName)
--- 修改卡片刷新价格
EMDF_CARD_REFRESH_COST_CONSTANT = 'GetModifierCardRefreshCostConstant'
--- 修改卡片刷新价格百分比
EMDF_CARD_REFRESH_COST_PERCENTAGE = 'GetModifierCardRefreshCostPercent'
--- 回合金币额外百分比
EMDF_ROUND_GOLD_PERCENTAGE = 'GetRoundGoldPercentage'	--(iPlayerID)
--- 杀怪金币额外百分比
EMDF_KILL_GOLD_PERCENTAGE = 'GetKillGoldPercentage'	--(iPlayerID, params?)
--- 宝箱回合额外时间
EMDF_GOLD_ROUND_DURATION_BONUS = 'GetGoldRoundDurationBonus'	--(iPlayerID)
--- 宝箱回合额外金钱掉落
EMDF_GOLD_ROUND_GOLD_BONUS_PERCENTAGE = 'GetGoldRoundGoldBonusPercentage'	--(iPlayerID)
--- 抽卡时的额外概率权重百分比
EMDF_DRAW_CARD_CHANCE_PERCENTAGE = 'GetDrawCardChancePercentage'	--(iPlayerID, sCardName, sReservoirName)
--- 抽装备物品时的额外概率权重百分比
EMDF_DRAW_ITEM_CHANCE_PERCENTAGE = 'GetDrawItemChancePercentage'	--(iPlayerID, sItemName, sReservoirName)
--- 重铸装备时的额外升级品质概率百分比
EMDF_REMAKE_LEVELUP_CHANCE_PERCENTAGE = 'GetRemakeLevelupChancePercentage'	--(iPlayerID, iRarity)
--- 重铸时魂晶消耗百分比
EMDF_REMAKE_CRYSTAl_PERCENTAGE = 'GetModifyRemakeCrystalPercentage'
--- 修改羁绊需求数量
EMDF_FETTERS_ACTIVE_COUNT = 'GetModifyFettersActiveCount'	--(iPlayerID, sTagName, iCount)

--- 修改羁绊解锁状态
EMDF_TAG_ABLT_LOCK_STATE = 'GetTagAbltLockState'
--[[--
	(iPlayerID, sTagName)=>
		iState:number 		解锁状态	0:按羁绊数量正常解锁	1:强制解锁	2:强制不解锁
		iLevel?:number		优先级		0:默认
]]
---局外数值
--- 额外玩家档案经验百分比
EMDF_PLAYER_LEVELXP_PERCENT = 'GetPlayerLevelXPPercent'	--(iPlayerID)

---法术卡
--- 修改覆盖修改玩家最大技能卡数
EMDF_OVERRIDE_PLAYER_MAX_SPELL_CARD = 'GetModifierOverridePlayerMaxSpellCard'
--- 修改技能卡额外魔法消耗
EMDF_SPELL_CARD_MANA_COST_BONUS = 'GetSpellCardManaCostBonus'
--- 修改技能卡魔法消耗百分比
EMDF_SPELL_CARD_MANA_COST_PERCENTAGE = 'GetSpellCardManaCostPercentage'
--- 修改技能卡额外数量
EMDF_BONUS_SPELL_CARD = 'GetBonusSpellCard'

--- 修改税金额外百分比
EMDF_TAX_PERCENTAGE = 'GetTaxPercentage'
--
--- 自定义事务
EMDF_EVENT_CUSTOM = 'OnCustomEvent'	--{ 事件类型, 回调函数, 优先级（选参） }
-- {
-- 	[EMDF_EVENT_CUSTOM] = { ET_GAME.GAME_BEGIN, self.func, ?EVENT_LEVEL_NONE }
-- 	[EMDF_EVENT_CUSTOM] = { ET_GAME.GAME_BEGIN, 'func_name', ?EVENT_LEVEL_NONE }
-- 	多个事件：[EMDF_EVENT_CUSTOM] = {
-- 		{ 事件类型1, 回调函数1, 优先级（选参） },
-- 		{ 事件类型2, 回调函数2, 优先级（选参） },
-- }
--
----------------------------------------------------------------------------------------------------
-- ET_GAME
--- 回合数改变
EMDF_EVENT_ON_ROUND_CHANGE = 'OnRoundChange'

----------------------------------------------------------------------------------------------------
-- ET_PLAYER
--- 开始备战
EMDF_EVENT_ON_PREPARATION = 'OnPreparation'
--- 备战结束
EMDF_EVENT_ON_PREPARATION_END = 'OnPreparationEnd'
--- 进入战斗
EMDF_EVENT_ON_IN_BATTLE = 'OnInBattle'
--- 战斗结束
EMDF_EVENT_ON_BATTLEING_END = 'OnBattleEnd'

--- 玩家回合胜负结果
EMDF_EVENT_ON_PLAYER_ROUND_RESULT = 'OnPlayerRoundResult'
--- 玩家裝備升級
EMDF_EVENT_ON_PLAYER_ITEMLEV_UPDATE = 'OnPlayerItemLevelUpdate'
--- 指挥官使用技能卡 -- params: {iPlayerID: number, sCardName:string}
EMDF_EVENT_ON_PLAYER_USE_SPELL = 'OnHeroUseSpell'
----------------------------------------------------------------------------------------------------
-- ET_ENEMY
--- 敌人出生 (params: {iPlayerID:number, hUnit:handle})
EMDF_EVENT_ON_ENEMY_SPAWNED = "OnEnemySpawned"

----------------------------------------------------------------------------------------------------
-- 自定义攻击
--- 自定义攻击命中（由 base_attack 所触发的弹道）
EMDF_EVENT_ON_ATTACK_HIT = 'OnAttackHit'
--[[ (hTarget, tAttackInfo, ExtraData, vLocation) => void
		tAttackInfo -> {tDamageInfo, tDamageRecords, record, ...}
		ExtraData -> {record, ...}]]
--- 自定义攻击的record生成 （在自定义攻击时，暴击等计算前触发）
EMDF_EVENT_ON_ATTACK_RECORD_CREATE = 'OnCustomAttackRecordCreate'	--(tAttackInfo) => void
--- 自定义攻击的record删除
EMDF_EVENT_ON_ATTACK_RECORD_DESTROY = 'OnCustomAttackRecordDestroy'	--(tAttackInfo) => void
--- 攻击类型
EMDF_ATTACK_TYPE = 'GetAttackType'
--- 攻击闪避
EMDF_ATTACK_MISS_BONUS = 'GetAttackMissBonus' --return 闪避伤害百分比, 概率(0-100)
--- 攻击速度
EMDF_ATTACKT_SPEED_BONUS = 'GetAttackSpeedBonus'
--- 攻击速度（覆盖）
EMDF_ATTACKT_SPEED_OVERRIDE = 'GetAttackSpeedOverride'
--- 攻击速度百分比
EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE = 'GetAttackSpeedPercentage'
--- 额外最大攻速
EMDF_BONUS_MAXIMUM_ATTACK_SPEED = 'GetAttackSpeedBonusMaximum'
--- 攻击范围
EMDF_ATTACK_RANGE_BONUS = 'GetAttackRangeBonus'
--- 攻击范围（覆盖）
EMDF_ATTACK_RANGE_OVERRIDE = 'GetAttackRangeOverride'
--- 攻击弹道修改
EMDF_ATTACKT_PROJECTILE = 'GetAttackProjectile'	--{iLevel=0}
--- 攻击命中声音修改
EMDF_ATTACKT_HIT_SOUND = 'GetAttackHitSound'	--{iLevel=0}
--- 攻击动作修改
EMDF_ATTACKT_ANIMATION = 'GetAttackAnimation'	--{iLevel=0}
--- 攻击动作速率修改
EMDF_ATTACKT_ANIMATION_RATE = 'GetAttackAnimationRate'	--{iLevel=0}
--- 额外攻击flags标识
EMDF_ATTACKT_FLAGS = 'GetAttackFlags'	--{iLevel=0} --(params, typeFalgs) => typeFalgs : number
--- 攻击行为修改
EMDF_DO_ATTACK_BEHAVIOR = 'DoAttackBehavior'	--{iLevel=0}
--[[ (tAttackInfo, hAttackAbility)
		=> void
		|| (hTarget, vLocation, ExtraData, hAttackAbility) => bool 如果弹道绑定在hAttackAbility上，可以返回一个function作为hit命中后的
		|| bool 返回false标识忽略这次的DoAttackBehavior

]]
--- 弹道命中
EMDF_EVENT_ON_PROJECTILE_HIT = 'OnProjectileHit'	--(hTarget, tProjectileInfo, vLocation, ExtraData) => void
--- 弹道命中目标替换
EMDF_CHANGE_PROJECTILE_HIT_TARGET = 'ChangeProjectileHitTarget'	--(hTarget, tProjectileInfo, vLocation, ExtraData) => hTarget
----------------------------------------------------------------------------------------------------
-- 属性修改
--- 额外移动速度
EMDF_MOVEMENT_SPEED_BONUS = 'GetMoveSpeedBonus'
--- 移动速度百分比修改
EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE = 'GetMoveSpeedBonusPercentage'

--- 魔法攻击力修改
EMDF_MAGICAL_ATTACK_BONUS = 'GetMagicalAttackBonus'
--- 魔法攻击力修改（独立的不能被百分比修改）
EMDF_MAGICAL_ATTACK_BONUS_UNIQUE = 'GetMagicalAttackBonusUnique'
--- 魔法攻击力百分比修改
EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE = 'GetMagicalAttackBonusPercentage'
--- 物理攻击力修改
EMDF_PHYSICAL_ATTACK_BONUS = 'GetPhysicalAttackBonus'
--- 物理攻击力修改（独立的不能被百分比修改）
EMDF_PHYSICAL_ATTACK_BONUS_UNIQUE = 'GetPhysicalAttackBonusUnique'
--- 物理攻击力百分比修改
EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE = 'GetPhysicalAttackBonusPercentage'
--- 生命修改
EMDF_STATUS_HEALTH_BONUS = 'GetStatusHealthBonus'
EMDF_STATUS_HEALTH_BONUS_PERCENTAGE = 'GetStatusHealthBonusPercentage'
--- 魔法修改
EMDF_STATUS_MANA_BONUS = 'GetStatusManaBonus'
EMDF_STATUS_MANA_BONUS_PERCENTAGE = 'GetStatusManaBonusPercentage'
--- 护甲修改
EMDF_MAGICAL_ARMOR_BONUS = 'GetMagicalArmorBonus'
EMDF_MAGICAL_ARMOR_BONUS_PERCENTAGE = 'GetMagicalArmorBonusPercentage'
EMDF_PHYSICAL_ARMOR_BONUS = 'GetPhysicalArmorBonus'
EMDF_PHYSICAL_ARMOR_BONUS_PERCENTAGE = 'GetPhysicalArmorBonusPercentage'
-- 无视护甲
EMDF_ARMOR_IGNORE_PERCENTAGE = 'GetArmorIgnorePercentage'

--- 普攻暴击
EMDF_ATTACK_CRIT_BONUS = 'GetAttackCritBonus'	--return 暴击伤害百分比, 概率(0-100)
--- 全伤害暴击
EMDF_DAMAGE_CRIT_BONUS = 'GetDamageCritBonus'	--return 暴击伤害百分比, 概率(0-100)
--- 魔法暴击
EMDF_MAGICAL_CRIT_BONUS = 'GetMagicalCritBonus'	--return 暴击伤害百分比, 概率(0-100)
--- 物理暴击
EMDF_PHYSICAL_CRIT_BONUS = 'GetPhysicalCritBonus'	--return 暴击伤害百分比, 概率(0-100)
--- 纯粹暴击
EMDF_PURE_CRIT_BONUS = 'GetPureCritBonus'	--return 暴击伤害百分比, 概率(0-100)

--- 普攻吸血百分比
EMDF_ATTACK_HELF_BONUS_PERCENTAGE = 'GetAttackHealBonusPercentage'
--- 全伤害吸血百分比
EMDF_DAMAGE_HELF_BONUS_PERCENTAGE = 'GetDamageHealBonusPercentage'
--- 魔法吸血百分比
EMDF_MAGICAL_HELF_BONUS_PERCENTAGE = 'GetMagicalHealBonusPercentage'
--- 物理吸血百分比
EMDF_PHYSICAL_HELF_BONUS_PERCENTAGE = 'GetPhysicalHealBonusPercentage'
--- 纯粹吸血百分比
EMDF_PURE_HELF_BONUS_PERCENTAGE = 'GetPureHealBonusPercentage'

--- 全伤害打出百分比
EMDF_OUTGOING_PERCENTAGE = 'GetOutgoingPercentage'
--- 魔法打出百分比
EMDF_MAGICAL_OUTGOING_PERCENTAGE = 'GetMagicalOutgoingPercentage'
--- 物理打出百分比
EMDF_PHYSICAL_OUTGOING_PERCENTAGE = 'GetPhysicalOutgoingPercentage'
--- 纯粹打出百分比
EMDF_PURE_OUTGOING_PERCENTAGE = 'GetPureOutgoingPercentage'

--- 全伤害承受百分比
EMDF_INCOMING_PERCENTAGE = 'GetIncomingPercentage'
--- 魔法承受百分比
EMDF_MAGICAL_INCOMING_PERCENTAGE = 'GetMagicalIncomingPercentage'
--- 物理承受百分比
EMDF_PHYSICAL_INCOMING_PERCENTAGE = 'GetPhysicalIncomingPercentage'
--- 纯粹承受百分比
EMDF_PURE_INCOMING_PERCENTAGE = 'GetPureIncomingPercentage'

--- 打伤害比例吸蓝
EMDF_OUTGOING_MANA_REGEN_PERCENTAGE = 'GetOutgoingManaRegenPercentage'
--- 打魔法比例吸蓝
EMDF_MAGICAL_OUTGOING_MANA_REGEN_PERCENTAGE = 'GetMagicalOutgoingManaRegenPercentage'
--- 打物理比例吸蓝
EMDF_PHYSICAL_OUTGOING_MANA_REGEN_PERCENTAGE = 'GetPhysicalOutgoingManaRegenPercentage'
--- 打纯粹比例吸蓝
EMDF_PURE_OUTGOING_MANA_REGEN_PERCENTAGE = 'GetPureOutgoingManaRegenPercentage'

--- 受伤害比例吸蓝
EMDF_INCOMING_MANA_REGEN_PERCENTAGE = 'GetIncomingManaRegenPercentage'
--- 受魔法比例吸蓝
EMDF_MAGICAL_INCOMING_MANA_REGEN_PERCENTAGE = 'GetMagicalIncomingManaRegenPercentage'
--- 受物理比例吸蓝
EMDF_PHYSICAL_INCOMING_MANA_REGEN_PERCENTAGE = 'GetPhysicalIncomingManaRegenPercentage'
--- 受纯粹比例吸蓝
EMDF_PURE_INCOMING_MANA_REGEN_PERCENTAGE = 'GetPureIncomingManaRegenPercentage'

--- 魔法每秒恢复
EMDF_MANA_REGEN_BONUS = 'GetManaRegenBonus'
EMDF_MANA_REGEN_PERCENTAGE = 'GetManaRegenPercentage'

--- 生命每秒恢复
EMDF_HEALTH_REGEN_BONUS = 'GetHealthRegenBonus'
EMDF_HEALTH_REGEN_PERCENTAGE = 'GetHealthRegenPercentage'

--- 自身状态抗性百分比
EMDF_STATUS_RESISTANCE_PERCENTAGE = 'GetStatusResistancePercentage'
--- 施加负面状态加深百分比
EMDF_STATUS_RESISTANCE_PERCENTAGE_CASTER = 'GetStatusResistancePercentageCaster'

-- 仇恨等级
EMDF_THREAT_LEVEL = 'GetThreatLevel'

--- 模型大小百分比
EMDF_MODEL_SCALE = "GetModifierModelScale"

-- 重生时间
EMDF_REINCARNATION = "GetModifierReincarnation"

--[[	自定义状态
	function public:ECheckState()
		return {
			[MODIFIER_STATE_CURSED] = true,
		}
	end

	CDOTA_BaseNPC:IsCursed()
]]
MODIFIER_STATE_CURSED = 1		-- 诅咒
MODIFIER_STATE_IGNITED = 2		-- 燃烧
MODIFIER_STATE_INJURED = 3		-- 易伤
MODIFIER_STATE_POISONED = 4		-- 中毒
MODIFIER_STATE_TENACITED = 5	-- 霸体
MODIFIER_STATE_LOCKED = 6		-- 锁定
MODIFIER_STATE_AI_DISABLED = 7	-- 禁止ai执行命令

--[[E_DECLARE_FUNCTION 定义：
	{
		source: 调用到的class
		evt?:
			true: 注册事件调用
			attribute_const： 注册属性常量修改 SetVal
			attribute_pct: 注册属性百分比修改 SetValPercent
		attribute_kind?: ATTRIBUTE_KIND
			需要修改的属性
	}
]]
E_DECLARE_FUNCTION = {
	---@type Draw
	[EMDF_CARD_REFRESH_COST_PERCENTAGE] = { source = 'Draw',},
	[EMDF_CARD_REFRESH_COST_CONSTANT] = { source = 'Draw',},
	---@type PlayerBuildings
	[EMDF_MAX_BUILDING_BONUS] = { source = 'PlayerBuildings',},
	---@type HeroCardData
	[EMDF_FIXED_SELL_CARD_GOLD_PERCENT] = { source = 'HeroCardData',},
	---@type HeroCardData
	[EMDF_MAX_HAND_CARD_COUNT_BONUS] = { source = 'HeroCardData',},
	---@type Items
	[EMDF_ITEM_STAR_BONUS] = { source = 'Items',},
	---@type Items
	[EMDF_REMAKE_CRYSTAl_PERCENTAGE] = { source = 'Items',},
	---@type Draw
	[EMDF_BUY_CARD_DISCOUNT_PERCENTAGE] = { source = 'Draw',},
	---@type HandSpellCards
	[EMDF_OVERRIDE_PLAYER_MAX_SPELL_CARD] = { source = 'HandSpellCards',},
	[EMDF_SPELL_CARD_MANA_COST_BONUS] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.SpellCardManaCostBonus },
	[EMDF_SPELL_CARD_MANA_COST_PERCENTAGE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.SpellCardManaCostPercentage },
	---@type HeroCardData
	[EMDF_TAX_PERCENTAGE] = { source = 'HeroCardData',},

	[EMDF_EVENT_CUSTOM] = { evt = 'custom_event',},
	[EMDF_EVENT_ON_ROUND_CHANGE] = { evt = true,},
	[EMDF_EVENT_ON_PREPARATION] = { evt = true,},
	[EMDF_EVENT_ON_PREPARATION_END] = { evt = true,},
	[EMDF_EVENT_ON_IN_BATTLE] = { evt = true,},
	[EMDF_EVENT_ON_BATTLEING_END] = { evt = true,},
	[EMDF_EVENT_ON_ENEMY_SPAWNED] = { evt = true,},
	[EMDF_EVENT_ON_PLAYER_ROUND_RESULT] = { evt = true,},

	[EMDF_EVENT_ON_PLAYER_ITEMLEV_UPDATE] = { evt = true,},
	[EMDF_EVENT_ON_PLAYER_USE_SPELL] = { evt = true,},

	[EMDF_EVENT_ON_PROJECTILE_HIT] = { evt = true, funcNotifyEvt = function(tModify, ...) local bResult = false for hSource, func in pairs(tModify) do if hSource and func and func(hSource, ...) then bResult = true end end return bResult end },
	[EMDF_CHANGE_PROJECTILE_HIT_TARGET] = { evt = true, funcNotifyEvt = function(tModify, tTargetChange, ...)
		for hSource, func in pairs(tModify) do
			if hSource and func then
				local hTarget = tTargetChange[#tTargetChange].hTarget
				local hTargetCur = func(hSource, hTarget, ...)
				if hTarget ~= hTargetCur then
					table.insert(tTargetChange, { hTarget = hTargetCur })
				end
			end
		end
	end },

	[EMDF_EVENT_ON_ATTACK_HIT] = { evt = true, funcNotifyEvt = function(tModify, ...) local bResult = false for hSource, func in pairs(tModify) do if hSource and func and func(hSource, ...) then bResult = true end end return bResult end },
	[EMDF_EVENT_ON_ATTACK_RECORD_CREATE] = { evt = true,},
	[EMDF_EVENT_ON_ATTACK_RECORD_DESTROY] = { evt = true,},


	[EMDF_MAGICAL_ATTACK_BONUS] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.MagicalAttack,},
	[EMDF_MAGICAL_ATTACK_BONUS_UNIQUE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.MagicalAttack, attribute_flags = ATTRIBUTE_FLAG.UNIQUE },
	[EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE] = { evt = "attribute_pct", attribute_kind = ATTRIBUTE_KIND.MagicalAttack },
	[EMDF_PHYSICAL_ATTACK_BONUS] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.PhysicalAttack },
	[EMDF_PHYSICAL_ATTACK_BONUS_UNIQUE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.PhysicalAttack, attribute_flags = ATTRIBUTE_FLAG.UNIQUE },
	[EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE] = { evt = "attribute_pct", attribute_kind = ATTRIBUTE_KIND.PhysicalAttack },
	[EMDF_STATUS_HEALTH_BONUS] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.StatusHealth },
	[EMDF_STATUS_HEALTH_BONUS_PERCENTAGE] = { evt = "attribute_pct", attribute_kind = ATTRIBUTE_KIND.StatusHealth },
	[EMDF_STATUS_MANA_BONUS] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.StatusMana },
	[EMDF_STATUS_MANA_BONUS_PERCENTAGE] = { evt = "attribute_pct", attribute_kind = ATTRIBUTE_KIND.StatusMana },
	[EMDF_MAGICAL_ARMOR_BONUS] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.MagicalArmor },
	[EMDF_MAGICAL_ARMOR_BONUS_PERCENTAGE] = { evt = "attribute_pct", attribute_kind = ATTRIBUTE_KIND.MagicalArmor },
	[EMDF_PHYSICAL_ARMOR_BONUS] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.PhysicalArmor },
	[EMDF_PHYSICAL_ARMOR_BONUS_PERCENTAGE] = { evt = "attribute_pct", attribute_kind = ATTRIBUTE_KIND.PhysicalArmor },
	[EMDF_ATTACK_CRIT_BONUS] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.AttackCrit },
	[EMDF_DAMAGE_CRIT_BONUS] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.DamageCrit },
	[EMDF_MAGICAL_CRIT_BONUS] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.MagicalCrit },
	[EMDF_PHYSICAL_CRIT_BONUS] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.PhysicalCrit },
	[EMDF_PURE_CRIT_BONUS] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.PureCrit },
	[EMDF_ATTACK_HELF_BONUS_PERCENTAGE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.AttackHeal },
	[EMDF_DAMAGE_HELF_BONUS_PERCENTAGE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.DamageHeal },
	[EMDF_MAGICAL_HELF_BONUS_PERCENTAGE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.MagicalHeal },
	[EMDF_PHYSICAL_HELF_BONUS_PERCENTAGE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.PhysicalHeal },
	[EMDF_PURE_HELF_BONUS_PERCENTAGE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.PureHeal },
	[EMDF_OUTGOING_PERCENTAGE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.OutgoingPercentage },
	[EMDF_MAGICAL_OUTGOING_PERCENTAGE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.MagicalOutgoingPercentage },
	[EMDF_PHYSICAL_OUTGOING_PERCENTAGE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.PhysicalOutgoingPercentage },
	[EMDF_PURE_OUTGOING_PERCENTAGE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.PureOutgoingPercentage },
	[EMDF_INCOMING_PERCENTAGE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.IncomingPercentage },
	[EMDF_MAGICAL_INCOMING_PERCENTAGE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.MagicalIncomingPercentage },
	[EMDF_PHYSICAL_INCOMING_PERCENTAGE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.PhysicalIncomingPercentage },
	[EMDF_PURE_INCOMING_PERCENTAGE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.PureIncomingPercentage },
	[EMDF_OUTGOING_MANA_REGEN_PERCENTAGE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.OutgoingManaRegen },
	[EMDF_MAGICAL_OUTGOING_MANA_REGEN_PERCENTAGE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.MagicalOutgoingManaRegen },
	[EMDF_PHYSICAL_OUTGOING_MANA_REGEN_PERCENTAGE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.PhysicalOutgoingManaRegen },
	[EMDF_PURE_OUTGOING_MANA_REGEN_PERCENTAGE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.PureOutgoingManaRegen },
	[EMDF_INCOMING_MANA_REGEN_PERCENTAGE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.IncomingManaRegen },
	[EMDF_MAGICAL_INCOMING_MANA_REGEN_PERCENTAGE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.MagicalIncomingManaRegen },
	[EMDF_PHYSICAL_INCOMING_MANA_REGEN_PERCENTAGE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.PhysicalIncomingManaRegen },
	[EMDF_PURE_INCOMING_MANA_REGEN_PERCENTAGE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.PureIncomingManaRegen },
	[EMDF_STATUS_RESISTANCE_PERCENTAGE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.StatusResistancePercentage },
	[EMDF_STATUS_RESISTANCE_PERCENTAGE_CASTER] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.StatusResistancePercentageCaster },
	[EMDF_ARMOR_IGNORE_PERCENTAGE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.IgnoreArmor },

	[EMDF_ATTACK_TYPE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.AttackType },
	[EMDF_ATTACK_MISS_BONUS] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.AttackMiss },
	[EMDF_ATTACKT_SPEED_BONUS] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.AttackSpeed },
	[EMDF_ATTACKT_SPEED_OVERRIDE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.AttackSpeed, attribute_flags = ATTRIBUTE_FLAG.OVERRIDE },
	[EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE] = { evt = "attribute_pct", attribute_kind = ATTRIBUTE_KIND.AttackSpeed },
	[EMDF_ATTACK_RANGE_BONUS] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.AttackRange },
	[EMDF_ATTACK_RANGE_OVERRIDE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.AttackRange, attribute_flags = ATTRIBUTE_FLAG.OVERRIDE },
	[EMDF_BONUS_MAXIMUM_ATTACK_SPEED] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.AttackSpeedBonusMaximum },
	[EMDF_ATTACKT_PROJECTILE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.AttackProjectile, unpack = EModifier:unpacker('iLevel'), RegAttribute = EModifier.RegAttribute_LevelVal, RegAttributePct = EModifier.RegAttributePct_LevelVal },
	[EMDF_ATTACKT_HIT_SOUND] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.AttackHitSound, unpack = EModifier:unpacker('iLevel'), RegAttribute = EModifier.RegAttribute_LevelVal, RegAttributePct = EModifier.RegAttributePct_LevelVal },
	[EMDF_ATTACKT_ANIMATION] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.AttackAnimation, unpack = EModifier:unpacker('iLevel'), RegAttribute = EModifier.RegAttribute_LevelVal, RegAttributePct = EModifier.RegAttributePct_LevelVal },
	[EMDF_ATTACKT_ANIMATION_RATE] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.AttackAnimationRate, unpack = EModifier:unpacker('iLevel'), RegAttribute = EModifier.RegAttribute_LevelVal, RegAttributePct = EModifier.RegAttributePct_LevelVal },
	[EMDF_ATTACKT_FLAGS] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.AttackFlags, unpack = EModifier:unpacker('iLevel'), RegAttribute = EModifier.RegAttribute_LevelVal, RegAttributePct = EModifier.RegAttributePct_LevelVal },
	[EMDF_DO_ATTACK_BEHAVIOR] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.AttackBehavior, unpack = EModifier:unpacker('iLevel'), RegAttribute = EModifier.RegAttribute_LevelVal, RegAttributePct = EModifier.RegAttributePct_LevelVal },

	[EMDF_MOVEMENT_SPEED_BONUS] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.MoveSpeed },
	[EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE] = { evt = "attribute_pct", attribute_kind = ATTRIBUTE_KIND.MoveSpeed },

	[EMDF_MANA_REGEN_BONUS] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.ManaRegen },
	[EMDF_MANA_REGEN_PERCENTAGE] = { evt = "attribute_pct", attribute_kind = ATTRIBUTE_KIND.ManaRegen },

	[EMDF_HEALTH_REGEN_BONUS] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.HealthRegen },
	[EMDF_HEALTH_REGEN_PERCENTAGE] = { evt = "attribute_pct", attribute_kind = ATTRIBUTE_KIND.HealthRegen },
	[EMDF_MODEL_SCALE] = { evt = "attribute_pct", attribute_kind = ATTRIBUTE_KIND.ModelScale },
	[EMDF_THREAT_LEVEL] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.ThreatLevel },

	[EMDF_REINCARNATION] = { evt = "attribute_const", attribute_kind = ATTRIBUTE_KIND.Reincarnation, unpack = EModifier:unpacker('iLevel'), RegAttribute = EModifier.RegAttribute_LevelVal, RegAttributePct = EModifier.RegAttributePct_LevelVal },

	---官方事件
	--[[ 示例：
	{
				MODIFIER_EVENT_ON_ATTACK,
				[MODIFIER_EVENT_ON_ATTACK] = { hSource, hTarget }
			}
	]]
	[MODIFIER_EVENT_ON_SPELL_TARGET_READY] = 1,
	[MODIFIER_EVENT_ON_ATTACK_RECORD] = 1,
	[MODIFIER_EVENT_ON_ATTACK_START] = 1,
	[MODIFIER_EVENT_ON_ATTACK] = 1,
	[MODIFIER_EVENT_ON_ATTACK_LANDED] = 1,
	[MODIFIER_EVENT_ON_ATTACK_FAIL] = 1,
	[MODIFIER_EVENT_ON_ATTACK_ALLIED] = 1,
	[MODIFIER_EVENT_ON_ORDER] = 1,
	[MODIFIER_EVENT_ON_UNIT_MOVED] = 1,
	[MODIFIER_EVENT_ON_ABILITY_START] = 1,
	[MODIFIER_EVENT_ON_ABILITY_EXECUTED] = 1,
	[MODIFIER_EVENT_ON_ABILITY_FULLY_CAST] = 1,
	[MODIFIER_EVENT_ON_ABILITY_END_CHANNEL] = 1,
	[MODIFIER_EVENT_ON_TAKEDAMAGE] = 1,
	[MODIFIER_EVENT_ON_STATE_CHANGED] = 1,
	[MODIFIER_EVENT_ON_DAMAGE_CALCULATED] = 1,
	[MODIFIER_EVENT_ON_ATTACKED] = 1,
	[MODIFIER_EVENT_ON_DEATH] = 1,
	[MODIFIER_EVENT_ON_RESPAWN] = 1,
	[MODIFIER_EVENT_ON_SPENT_MANA] = 1,
	[MODIFIER_EVENT_ON_TELEPORTING] = 1,
	[MODIFIER_EVENT_ON_TELEPORTED] = 1,
	[MODIFIER_EVENT_ON_HEALTH_GAINED] = 1,
	[MODIFIER_EVENT_ON_MANA_GAINED] = 1,
	[MODIFIER_EVENT_ON_HERO_KILLED] = 1,
	[MODIFIER_EVENT_ON_HEAL_RECEIVED] = 1,
	[MODIFIER_EVENT_ON_MODIFIER_ADDED] = 1,
	[MODIFIER_EVENT_ON_ATTACK_FINISHED] = 1,
	[MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY] = 1,
	[MODIFIER_EVENT_ON_ATTACK_CANCELLED] = 1,
}




-- 光环eom_modifier
if eom_modifier_aura == nil then
	---@class eom_modifier_aura
	eom_modifier_aura = class({}, nil, eom_modifier)
end
function eom_modifier_aura:constructor()
	if self.OnCreated ~= eom_modifier_aura.OnCreated then
		local _OnCreated = self.OnCreated
		self.OnCreated = function(...)
			_OnCreated(...)
			eom_modifier_aura.OnCreated(...)
		end
	end
	if self.OnRefresh ~= eom_modifier_aura.OnRefresh then
		local _OnRefresh = self.OnRefresh
		self.OnRefresh = function(...)
			_OnRefresh(...)
			eom_modifier_aura.OnRefresh(...)
		end
	end
	if self.OnDestroy ~= eom_modifier_aura.OnDestroy then
		local _OnDestroy = self.OnDestroy
		self.OnDestroy = function(...)
			_OnDestroy(...)
			eom_modifier_aura.OnDestroy(...)
		end
	end
	self.IsAura = eom_modifier_aura.IsAura

	if self.EDeclareFunctions ~= eom_modifier_aura.EDeclareFunctions then
		local _EDeclareFunctions = self.EDeclareFunctions
		self.EDeclareFunctions = function(...)
			local t1 = eom_modifier_aura.EDeclareFunctions(...)
			local t2 = _EDeclareFunctions(...)

			-- 处理EMDF_EVENT_CUSTOM合并
			if t2[EMDF_EVENT_CUSTOM] then
				if t2[EMDF_EVENT_CUSTOM][1] then
					-- 子类有定义
					if 'table' == type(t2[EMDF_EVENT_CUSTOM][1]) then
						-- 多个事件
						for _, v in pairs(t1[EMDF_EVENT_CUSTOM]) do
							table.insert(t2[EMDF_EVENT_CUSTOM], v)
						end
					else
						table.insert(t1[EMDF_EVENT_CUSTOM], t2[EMDF_EVENT_CUSTOM])
						t2[EMDF_EVENT_CUSTOM] = t1[EMDF_EVENT_CUSTOM]
					end
				else
					-- 子类无定义直接覆盖
					t2[EMDF_EVENT_CUSTOM] = t1[EMDF_EVENT_CUSTOM]
				end
			else
				-- 子类无定义直接覆盖
				t2[EMDF_EVENT_CUSTOM] = t1[EMDF_EVENT_CUSTOM]
			end

			-- 处理 MODIFIER_EVENT_ON_DEATH 合并
			local bHas = nil == t2[MODIFIER_EVENT_ON_DEATH]
			if not bHas then
				for i, v in ipairs(t2) do
					if i == MODIFIER_EVENT_ON_DEATH then
						bHas = true
						table.remove(t2, i)
						break
					end
				end
			end
			table.insert(t2, MODIFIER_EVENT_ON_DEATH)
			if bHas then
				local tParams = t2[MODIFIER_EVENT_ON_DEATH] or {nil, nil }
				if self.OnDeath ~= eom_modifier_aura.OnDeath then
					local _OnDeath = self.OnDeath
					self.OnDeath = function(hSelf, params, ...)
						eom_modifier_aura.OnDeath(hSelf, params, ...)
						if (not tParams[1] or params.attacker == tParams[1])
						and (not tParams[2] or params.unit == tParams[2])
						then
							_OnDeath(hSelf, params, ...)
						end
					end
				end
			end

			return t2
		end
	end

	eom_modifier.constructor(self)
end
-- 关闭官方光环
function eom_modifier_aura:IsAura() return false end
-- 光环筛选玩家
function eom_modifier_aura:GetAuraEffectPlayerID() return self:GetPlayerID() end
-- 光环筛选单位类型
function eom_modifier_aura:GetAuraUnitType() return UnitType.All end
-- 光环筛选单位排除
function eom_modifier_aura:GetAuraEntityReject(hEntity) return false end
-- 光环施加的modifier名字
function eom_modifier_aura:GetModifierAura() end
-- 光环筛选范围
function eom_modifier_aura:GetAuraRadius() return -1 end
-- 光环的设置，返回modifier
function eom_modifier_aura:SetAuraModifier(hUnit)
	if self:GetModifierAura() then
		return hUnit:AddNewModifier(self:GetParent(), self:GetAbility(), self:GetModifierAura(), nil)
	end
end
-- 光环是否仅战斗时有效
function eom_modifier_aura:IsBattleAura() return true end
function eom_modifier_aura:OnCreated(params)
	if IsServer() then
		self._tAuraMdfs_ = {}
		if not self:IsBattleAura() or PlayerData:IsBattling(self:GetPlayerID()) then
			self:_UpdateAuras_()
		end
	end
end
function eom_modifier_aura:OnRefresh(params)
	if IsServer() then
		if not self:IsBattleAura() or PlayerData:IsBattling(self:GetPlayerID()) then
			self:_UpdateAuras_()
		end
	end
end
function eom_modifier_aura:OnDestroy()
	if IsServer() then
		self:_DelAuras_()
	end
end
function eom_modifier_aura:EDeclareFunctions()
	local t = {
		[EMDF_EVENT_CUSTOM] = {
			{ ET_GAME.NPC_SPAWNED, '_OnNpcSpawn_' },
		},
		MODIFIER_EVENT_ON_DEATH,
	}
	if self:IsBattleAura() then
		table.insert(t[EMDF_EVENT_CUSTOM], { ET_BATTLE.ON_BATTLEING, '_OnBattleing_', EVENT_LEVEL_ULTRA })
		table.insert(t[EMDF_EVENT_CUSTOM], { ET_BATTLE.ON_BATTLEING_END, '_OnBattleingEnd_', EVENT_LEVEL_ULTRA })
		table.insert(t[EMDF_EVENT_CUSTOM], { ET_PLAYER.ROUND_RESULT, '_OnRoundResult_', EVENT_LEVEL_ULTRA })
	end
	return t
end
function eom_modifier_aura:OnDeath(params)
	if params.unit == self:GetParent() then
		-- 自己死亡关闭光环
		self:_DelAuras_()
	end
end
function eom_modifier_aura:_OnBattleing_(tData)
	self:_UpdateAuras_()
end
function eom_modifier_aura:_OnBattleingEnd_(tData)
	self:_DelAuras_()
end
---@param tData EventData_PlayerRoundResult
function eom_modifier_aura:_OnRoundResult_(tData)
	if tData.PlayerID == self:GetPlayerID() and 1 == tData.is_win then
		self:_DelAuras_()
	end
end
function eom_modifier_aura:_OnNpcSpawn_(tData)
	if self:IsBattleAura() and not PlayerData:IsBattling(self:GetPlayerID()) then return end	-- 战斗时才添加
	if IsValid(self:GetAbility()) and self:GetAbility():GetLevel() <= 0 then return end	-- 有技能时需要学习技能

	local hUnit = EntIndexToHScript(tData.entindex)
	if IsValid(hUnit) then
		if hUnit == self:GetParent() then
			-- 自己复活开启光环
			self:_UpdateAuras_()
		else
			-- 验证是否受光环影响
			local fRadius = self:GetAuraRadius() or -1
			if fRadius == -1 or fRadius >= (self:GetParent():GetAbsOrigin() - hUnit:GetAbsOrigin()):Length2D() then
				if CheckUnitType(self:GetAuraEffectPlayerID(), hUnit, self:GetAuraUnitType()) then
					if not self:GetAuraEntityReject(hUnit) then
						local hMdf = self:SetAuraModifier(hUnit)
						if IsValid(hMdf) and not exist(self._tAuraMdfs, hMdf) then
							table.insert(self._tAuraMdfs_, hMdf)
						end
					end
				end
			end
		end
	end
end
function eom_modifier_aura:_UpdateAuras_()
	for i = #self._tAuraMdfs_, 1, -1 do
		local hMdfs = self._tAuraMdfs_[i]
		if not IsValid(hMdfs) then
			table.remove(self._tAuraMdfs_, i)
		end
	end

	-- 有技能时需要学习技能
	if IsValid(self:GetAbility()) and self:GetAbility():GetLevel() <= 0 then return end

	local hParent = self:GetParent()
	local fRadius = self:GetAuraRadius() or -1
	EachUnits(self:GetAuraEffectPlayerID(), function(hUnit)
		if fRadius == -1 or fRadius >= (hParent:GetAbsOrigin() - hUnit:GetAbsOrigin()):Length2D() then
			if not self:GetAuraEntityReject(hUnit) then
				local hMdf = self:SetAuraModifier(hUnit)
				if IsValid(hMdf) and not exist(self._tAuraMdfs, hMdf) then
					table.insert(self._tAuraMdfs_, hMdf)
				end
			end
		end
	end, self:GetAuraUnitType())
end
function eom_modifier_aura:_DelAuras_()
	for _, hMdfs in pairs(self._tAuraMdfs_) do
		if IsValid(hMdfs) then
			hMdfs:Destroy()
		end
	end
	self._tAuraMdfs_ = {}
end