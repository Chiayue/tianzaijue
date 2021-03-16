-- Global name: Filters
if Filters == nil then
	Filters = {}
end
local public = Filters

function public:AbilityTuningValueFilter(params)
	return true
end

function public:BountyRunePickupFilter(params)
	return true
end

function public:DamageFilter(params)
	local hVictim = EntIndexToHScript(params.entindex_victim_const or -1)
	local hAttacker = EntIndexToHScript(params.entindex_attacker_const or -1)
	local iDamageType = params.damagetype_const
	if iDamageType == DAMAGE_TYPE_NONE then
		iDamageType = DAMAGE_TYPE_PURE
	end

	if 0 < params.damage then
		---@class EventData_DAMAGE_FILTER
		local tEvent = {
			typeDamage = iDamageType,
			hAttacker = hAttacker,
			hVictim = hVictim,
			fDamage = params.damage,
			bResult = true,
		}
		EventManager:fireEvent(ET_GAME.DAMAGE_FILTER, tEvent)
		return tEvent.bResult
	end

	return true
end

local ORDER = {
	DOTA_UNIT_ORDER_NONE = 0,
	DOTA_UNIT_ORDER_MOVE_TO_POSITION = 1,
	DOTA_UNIT_ORDER_MOVE_TO_TARGET = 2,
	DOTA_UNIT_ORDER_ATTACK_MOVE = 3,
	DOTA_UNIT_ORDER_ATTACK_TARGET = 4,
	DOTA_UNIT_ORDER_CAST_POSITION = 5,
	DOTA_UNIT_ORDER_CAST_TARGET = 6,
	DOTA_UNIT_ORDER_CAST_TARGET_TREE = 7,
	DOTA_UNIT_ORDER_CAST_NO_TARGET = 8,
	DOTA_UNIT_ORDER_CAST_TOGGLE = 9,
	DOTA_UNIT_ORDER_HOLD_POSITION = 10,
	DOTA_UNIT_ORDER_TRAIN_ABILITY = 11,
	DOTA_UNIT_ORDER_DROP_ITEM = 12,
	DOTA_UNIT_ORDER_GIVE_ITEM = 13,
	DOTA_UNIT_ORDER_PICKUP_ITEM = 14,
	DOTA_UNIT_ORDER_PICKUP_RUNE = 15,
	DOTA_UNIT_ORDER_PURCHASE_ITEM = 16,
	DOTA_UNIT_ORDER_SELL_ITEM = 17,
	DOTA_UNIT_ORDER_DISASSEMBLE_ITEM = 18,
	DOTA_UNIT_ORDER_MOVE_ITEM = 19,
	DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO = 20,
	DOTA_UNIT_ORDER_STOP = 21,
	DOTA_UNIT_ORDER_TAUNT = 22,
	DOTA_UNIT_ORDER_BUYBACK = 23,
	DOTA_UNIT_ORDER_GLYPH = 24,
	DOTA_UNIT_ORDER_EJECT_ITEM_FROM_STASH = 25,
	DOTA_UNIT_ORDER_CAST_RUNE = 26,
	DOTA_UNIT_ORDER_PING_ABILITY = 27,
	DOTA_UNIT_ORDER_MOVE_TO_DIRECTION = 28,
	DOTA_UNIT_ORDER_PATROL = 29,
	DOTA_UNIT_ORDER_VECTOR_TARGET_POSITION = 30,
	DOTA_UNIT_ORDER_RADAR = 31,
	DOTA_UNIT_ORDER_SET_ITEM_COMBINE_LOCK = 32,
	DOTA_UNIT_ORDER_CONTINUE = 33,
	DOTA_UNIT_ORDER_VECTOR_TARGET_CANCELED = 34,
	DOTA_UNIT_ORDER_CAST_RIVER_PAINT = 35,
	DOTA_UNIT_ORDER_PREGAME_ADJUST_ITEM_ASSIGNMENT = 36,
	DOTA_UNIT_ORDER_DROP_ITEM_AT_FOUNTAIN = 37,
}
function public:ExecuteOrderFilter(params)
	return true
end

function public:HealingFilter(params)
	return true
end

function public:ItemAddedToInventoryFilter(params)
	return true
end

function public:ModifierGainedFilter(params)
	local hCaster = EntIndexToHScript(params.entindex_caster_const or -1)
	local hAbility = EntIndexToHScript(params.entindex_ability_const or -1)
	local hParent = EntIndexToHScript(params.entindex_parent_const or -1)
	local sModifierName = params.name_const
	local fDuration = params.duration
	return true
end

function public:ModifyExperienceFilter(params)
	return true
end

function public:ModifyGoldFilter(params)
	local iPlayerID = params.player_id_const
	local iReason = params.reason_const
	local bIsReliable = params.reliable == 1
	local iGold = params.gold

	-- 总经济统计
	if PlayerResource:IsValidPlayerID(iPlayerID) then
		PlayerData:ModifyGold(iPlayerID, iGold)
	end

	return true
end

function public:RuneSpawnFilter(params)
	return true
end

function public:TrackingProjectileFilter(params)
	return true
end

function public:init(bReload)
	local GameMode = GameRules:GetGameModeEntity()

	-- GameMode:SetAbilityTuningValueFilter(Dynamic_Wrap(public, "AbilityTuningValueFilter"), public)
	-- GameMode:SetBountyRunePickupFilter(Dynamic_Wrap(public, "BountyRunePickupFilter"), public)
	GameMode:SetDamageFilter(Dynamic_Wrap(public, "DamageFilter"), public)
	-- GameMode:SetExecuteOrderFilter(Dynamic_Wrap(public, "ExecuteOrderFilter"), public)
	-- GameMode:SetHealingFilter(Dynamic_Wrap(public, "HealingFilter"), public)
	-- GameMode:SetItemAddedToInventoryFilter(Dynamic_Wrap(public, "ItemAddedToInventoryFilter"), public)
	-- GameMode:SetModifierGainedFilter(Dynamic_Wrap(public, "ModifierGainedFilter"), public)
	-- GameMode:SetModifyExperienceFilter(Dynamic_Wrap(public, "ModifyExperienceFilter"), public)
	GameMode:SetModifyGoldFilter(Dynamic_Wrap(public, "ModifyGoldFilter"), public)
	-- GameMode:SetRuneSpawnFilter(Dynamic_Wrap(public, "RuneSpawnFilter"), public)
	-- GameMode:SetTrackingProjectileFilter(Dynamic_Wrap(public, "TrackingProjectileFilter"), public)
end

return public