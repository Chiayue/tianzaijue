require("modifiers/BaseClass")
require("modifiers/EomMdf/eom_modifier");

LinkLuaModifier("modifier_attribute_register", "modifiers/attribute/modifier_attribute_register.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_attribute_getter", "modifiers/attribute/modifier_attribute_getter.lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_eom_debug_unit", "mods/EomDebug.lua", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_attack_system", "modifiers/util/modifier_attack_system.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dummy", "modifiers/util/modifier_dummy.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_events", "modifiers/util/modifier_events.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fix_damage", "modifiers/util/modifier_fix_damage.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_activity_modifiers", "modifiers/util/modifier_activity_modifiers.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_no_health_bar", "modifiers/util/modifier_no_health_bar.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_size_change", "modifiers/util/modifier_size_change.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tpscroll", "modifiers/util/modifier_tpscroll.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_motion", "modifiers/util/modifier_motion.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_pudding", "modifiers/util/modifier_pudding.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_death_knockback", "modifiers/util/modifier_death_knockback.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_no_damage", "modifiers/util/modifier_no_damage.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_color_aura", "modifiers/util/modifier_color_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_float", "modifiers/util/modifier_float.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_passive_cast", "modifiers/util/modifier_passive_cast.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_channel", "modifiers/util/modifier_channel.lua", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_wave", "modifiers/unit/modifier_wave.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_attribute", "modifiers/unit/modifier_enemy_attribute.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_indicator", "modifiers/unit/modifier_star_indicator.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_builder", "modifiers/unit/modifier_builder.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_endless_affix", "modifiers/unit/modifier_endless_affix.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ghost_tower", "modifiers/unit/modifier_ghost_tower.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ghost_enemy", "modifiers/unit/modifier_ghost_enemy.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_gold", "modifiers/unit/modifier_enemy_gold.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wave_gold_stiffness", "modifiers/unit/modifier_wave_gold_stiffness.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hero_card_drag", "modifiers/unit/modifier_hero_card_drag.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_hero_card_drag_show", "modifiers/unit/modifier_hero_card_drag_show.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_movespeed_alldeath", "modifiers/unit/modifier_movespeed_alldeath.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_duration", "modifiers/unit/modifier_duration.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_outdoor", "modifiers/unit/modifier_outdoor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_commander", "modifiers/unit/modifier_commander.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_commander_birthplace", "modifiers/unit/modifier_commander_birthplace.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tower", "modifiers/unit/modifier_tower.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_artifact_hitbox", "modifiers/unit/modifier_artifact_hitbox.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_artifact", "modifiers/unit/modifier_artifact.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sp_caster", "modifiers/unit/modifier_sp_caster.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sp_aura", "modifiers/unit/modifier_sp_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_niunian", "modifiers/unit/modifier_niunian.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_contract_monster", "modifiers/unit/modifier_contract_monster.lua", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_enemy_ai", "modifiers/ai/modifier_enemy_ai.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_gold_ai", "modifiers/ai/modifier_enemy_gold_ai.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_boss_ai", "modifiers/ai/modifier_enemy_boss_ai.lua", LUA_MODIFIER_MOTION_NONE)

-- 通用modifier
LinkLuaModifier("modifier_blind", "modifiers/common/modifier_blind.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_disarm", "modifiers/common/modifier_disarm.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_feared", "modifiers/common/modifier_feared.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_froze", "modifiers/common/modifier_froze.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hex", "modifiers/common/modifier_hex.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mute", "modifiers/common/modifier_mute.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_nightmare", "modifiers/common/modifier_nightmare.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_root", "modifiers/common/modifier_root.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_silent", "modifiers/common/modifier_silent.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_stun", "modifiers/common/modifier_stun.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_taunted", "modifiers/common/modifier_taunted.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tenacity", "modifiers/common/modifier_tenacity.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_poison", "modifiers/common/modifier_poison.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bleeding", "modifiers/common/modifier_bleeding.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cold_curse", "modifiers/common/modifier_cold_curse.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invincible", "modifiers/common/modifier_invincible.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ignite", "modifiers/common/modifier_ignite.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_evade", "modifiers/common/modifier_evade.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_injury", "modifiers/common/modifier_injury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lock", "modifiers/common/modifier_lock.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ai_disabled", "modifiers/common/modifier_ai_disabled.lua", LUA_MODIFIER_MOTION_NONE)

-- 初始modifier
LinkLuaModifier("modifier_ogre_med", "modifiers/ambient/modifier_ogre_med.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lina", "modifiers/ambient/modifier_lina.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_axe", "modifiers/ambient/modifier_axe.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_courier_nian", "modifiers/ambient/modifier_courier_nian.lua", LUA_MODIFIER_MOTION_NONE)

-- 无尽词缀
LinkLuaModifier("modifier_affix_profession", "abilities/affix/affix_profession.lua", LUA_MODIFIER_MOTION_NONE)

BUFF_TYPE = {
	BLIND = "modifier_blind", -- 致盲
	DISARM = "modifier_disarm", -- 缴械
	FEAR = "modifier_feared", -- 恐惧
	FROZEN = "modifier_froze", -- 冰冻
	HEX = "modifier_hex", -- 妖术
	MUTE = "modifier_mute", -- 锁闭
	NIGHTMARE = "modifier_nightmare", -- 噩梦
	ROOT = "modifier_root", -- 缠绕
	SILENCE = "modifier_silent", -- 沉默
	STUN = "modifier_stun", -- 晕眩
	KNOCKBACK = "modifier_knockback", -- 击退
	TAUNT = "modifier_taunted", -- 嘲讽
	TENACITY = "modifier_tenacity", -- 坚韧（满抗性）
	SHIELD = "modifier_shield", -- 护盾属性
	CURSE = {
		COLD = "modifier_cold_curse", -- 寒冷诅咒
	},
	COLD_CURSE = "modifier_cold_curse", -- 寒冷诅咒
	INVINCIBLE = "modifier_invincible", -- 无敌
	IGNITE = "modifier_ignite", -- 点燃
	EVADE = "modifier_evade", -- 闪避
	INJURY = "modifier_injury", -- 易伤
	POISON = "modifier_poison", -- 中毒
	LOCK = "modifier_lock", -- 锁定
	AI_DISABLED = "modifier_ai_disabled", -- 禁止AI

}

LinkLuaModifier("modifier_enemy_touch_magma", "modifiers/common/modifier_enemy_touch_magma.lua", LUA_MODIFIER_MOTION_NONE)

-- 地图内建筑
LinkLuaModifier("modifier_card_group", "modifiers/map_building/modifier_card_group.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shop", "modifiers/map_building/modifier_shop.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_treasure_box", "modifiers/map_building/modifier_treasure_box.lua", LUA_MODIFIER_MOTION_NONE)