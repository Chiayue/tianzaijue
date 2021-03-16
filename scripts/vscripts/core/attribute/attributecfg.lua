---自定义属性
ATTRIBUTE_KIND = {
	StatusHealth = 'status_health', --生命值
	StatusMana = 'status_mana', --魔法值

	MagicalAttack = 'magical_attack', --魔法攻击力
	PhysicalAttack = 'physical_attack', --物理攻击力

	MagicalArmor = 'magical_armor', --魔法护甲
	PhysicalArmor = 'physical_armor', --物理护甲

	AttackCrit = 'attack_crit', --普攻伤害暴击
	DamageCrit = 'damage_crit', --全伤害暴击
	MagicalCrit = 'magical_crit', --魔法暴击
	PhysicalCrit = 'physical_crit', --物理暴击
	PureCrit = 'pure_crit', --纯粹暴击

	AttackHeal = 'attack_helf', --普攻伤害吸血
	DamageHeal = 'damage_helf', --全伤害吸血
	MagicalHeal = 'magical_helf', --魔法吸血
	PhysicalHeal = 'physical_helf', --物理吸血
	PureHeal = 'pure_helf', --纯粹吸血

	IgnoreArmor = 'ignore_armor_pct', --无视护甲百分比

	OutgoingPercentage = 'outgoing_percentage', --全伤害打出百分比
	MagicalOutgoingPercentage = 'magical_outgoing_percentage', --魔法打出百分比
	PhysicalOutgoingPercentage = 'physical_outgoing_percentage', --物理打出百分比
	PureOutgoingPercentage = 'pure_outgoing_percentage', --纯粹打出百分比

	IncomingPercentage = 'incoming_percentage', --全伤害承受百分比
	MagicalIncomingPercentage = 'magical_incoming_percentage', --魔法承受百分比
	PhysicalIncomingPercentage = 'physical_incoming_percentage', --物理承受百分比
	PureIncomingPercentage = 'pure_incoming_percentage', --纯粹承受百分比

	ManaRegen = 'mana_regen', --魔法每秒恢复
	HealthRegen = 'health_regen', --魔法每秒恢复

	OutgoingManaRegen = 'outgoing_mana_regen', --打全伤害比例吸蓝
	MagicalOutgoingManaRegen = 'magical_outgoing_mana_regen', --打魔法比例吸蓝
	PhysicalOutgoingManaRegen = 'physical_outgoing_mana_regen', --打物理比例吸蓝
	PureOutgoingManaRegen = 'pure_outgoing_mana_regen', --打纯粹比例吸蓝

	IncomingManaRegen = 'incoming_mana_regen', --受全伤害比例吸蓝
	MagicalIncomingManaRegen = 'magical_incoming_mana_regen', --受魔法比例吸蓝
	PhysicalIncomingManaRegen = 'physical_incoming_mana_regen', --受物理比例吸蓝
	PureIncomingManaRegen = 'pure_incoming_mana_regen', --受纯粹比例吸蓝

	AttackMiss = 'attack_miss', --攻击闪避
	AttackSpeed = 'attackt_speed', --攻击速度
	AttackSpeedBonusMaximum = 'bonus_maximum_attack_speed', --额外最大攻速
	AttackRange = 'attack_range', --攻击范围
	AttackProjectile = 'attackt_projectile', --攻击弹道修改
	AttackHitSound = 'attack_hit_sound', --攻击命中声音修改
	AttackBehavior = 'attackt_behavior', --攻击行为修改
	AttackAnimation = 'attackt_animation', --攻击动作修改
	AttackAnimationRate = 'attackt_animation_rate', --攻击动作速率修改
	AttackFlags = 'attackt_flags', --攻击标识修改

	MoveSpeed = 'movement_speed', --移动速度

	StatusResistancePercentage = 'status_resistance_percentage', --自身状态抗性百分比
	StatusResistancePercentageCaster = 'status_resistance_percentage_caster', --施加负面状态加深百分比

	--法术卡
	SpellCardManaCostBonus = 'spell_card_mana_cost_bonus', -- 法术卡额外魔法消耗增减
	SpellCardManaCostPercentage = 'spell_card_mana_cost_percentage', -- 法术卡魔法消耗增减百分比

	ModelScale = 'model_scale', -- 模型大小
	ThreatLevel = 'threat_level', -- 仇恨等级
	BuildingLevelBonus = 'building_level_bonus', -- 英雄建筑额外星级

	Reincarnation = 'reincarnation', -- 重生时间
}

ATTRIBUTE_KEY['STAR_LEVEL'] = 'star_level'	--星级属性

---需要同步属性
ATTRIBUTE_SYNC = {
	[ATTRIBUTE_KIND.PhysicalAttack] = true,
	[ATTRIBUTE_KIND.MagicalAttack] = true,
	[ATTRIBUTE_KIND.PhysicalArmor] = true,
	[ATTRIBUTE_KIND.MagicalArmor] = true,
	[ATTRIBUTE_KIND.StatusMana] = true,
	[ATTRIBUTE_KIND.ManaRegen] = true,
	[ATTRIBUTE_KIND.HealthRegen] = true,
	[ATTRIBUTE_KIND.AttackSpeed] = true,
	[ATTRIBUTE_KIND.AttackRange] = true,
	[ATTRIBUTE_KIND.MoveSpeed] = true,

	[ATTRIBUTE_KIND.OutgoingPercentage] = true,
	[ATTRIBUTE_KIND.MagicalOutgoingPercentage] = true,
	[ATTRIBUTE_KIND.PhysicalOutgoingPercentage] = true,
	[ATTRIBUTE_KIND.PureOutgoingPercentage] = true,

	[ATTRIBUTE_KIND.IncomingPercentage] = true,
	[ATTRIBUTE_KIND.MagicalIncomingPercentage] = true,
	[ATTRIBUTE_KIND.PhysicalIncomingPercentage] = true,
	[ATTRIBUTE_KIND.PureIncomingPercentage] = true,
}