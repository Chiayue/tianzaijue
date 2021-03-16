LinkLuaModifier("modifier_art_holy_revenge", "abilities/artifact/art_holy_revenge.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_holy_revenge == nil then
	art_holy_revenge = class({}, nil, artifact_base)
end
function art_holy_revenge:GetIntrinsicModifierName()
	return "modifier_art_holy_revenge"
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_holy_revenge == nil then
	modifier_art_holy_revenge = class({}, nil, eom_modifier)
end
function modifier_art_holy_revenge:OnCreated(params)
	if IsServer() then
	end
end
function modifier_art_holy_revenge:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_art_holy_revenge:OnDestroy()
	if IsServer() then
	end
end
function modifier_art_holy_revenge:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_ENEMY_SPAWNED
	}
end
function modifier_art_holy_revenge:OnInBattle()
	local iPlayerID = self:GetPlayerID()
	local friend_reduce_health_pct = self:GetAbilitySpecialValueFor("friend_reduce_health_pct")
	if Spawner:IsBossRound() then
		EachUnits(iPlayerID, function(hUnit)
			hUnit:SetHealth(hUnit:GetMaxHealth() * (100 - 10) * 0.01)
		end, UnitType.Building)
	else
		EachUnits(iPlayerID, function(hUnit)
			hUnit:SetHealth(hUnit:GetMaxHealth() * (100 - friend_reduce_health_pct) * 0.01)
		end, UnitType.Building)
	end
end
function modifier_art_holy_revenge:OnEnemySpawned(params)
	local enemy_reduce_health_pct = self:GetAbilitySpecialValueFor("enemy_reduce_health_pct")

	if self:GetPlayerID() == params.iPlayerID then
		local hUnit = params.hUnit
		hUnit:SetHealth(hUnit:GetMaxHealth() * (100 - enemy_reduce_health_pct) * 0.01)
	end
	if Spawner:IsBossRound() then
		local hUnit = params.hUnit
		hUnit:SetHealth(hUnit:GetMaxHealth() * (100 - 10) * 0.01)
	end
end