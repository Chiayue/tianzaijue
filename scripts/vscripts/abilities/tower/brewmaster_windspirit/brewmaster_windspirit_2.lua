LinkLuaModifier("modifier_brewmaster_windspirit_2", "abilities/tower/brewmaster_windspirit/brewmaster_windspirit_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_brewmaster_windspirit_2_debuff", "abilities/tower/brewmaster_windspirit/brewmaster_windspirit_2.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if brewmaster_windspirit_2 == nil then
	brewmaster_windspirit_2 = class({})
end

function brewmaster_windspirit_2:GetIntrinsicModifierName()
	return 'modifier_brewmaster_windspirit_2'
end
---------------------------------------------------------------------
-- Modifiers
if modifier_brewmaster_windspirit_2 == nil then
	modifier_brewmaster_windspirit_2 = class({}, nil, eom_modifier)
end
function modifier_brewmaster_windspirit_2:IsHidden()
	return true
end
function modifier_brewmaster_windspirit_2:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK] = { self:GetParent() },
		EMDF_EVENT_ON_ATTACK_HIT
	}
end
function modifier_brewmaster_windspirit_2:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	hTarget:AddNewModifier(tAttackInfo.attacker, self:GetAbility(), "modifier_brewmaster_windspirit_2_debuff", { duration = self:GetAbility():GetDuration() })
end
function modifier_brewmaster_windspirit_2:OnAttack(params)
	if params.target == nil or params.target:GetClassname() == "dota_item_drop" then
		return
	end

	if params.attacker == self:GetParent() and not params.attacker:PassivesDisabled() and not params.attacker:AttackFilter(params.record, ATTACK_STATE_NO_EXTENDATTACK) then
		local tTargets = FindUnitsInRadius(params.attacker:GetTeamNumber(), params.attacker:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local attack_split = self:GetAbility():GetSpecialValueFor('attack_split')
		for _, hUnit in pairs(tTargets) do
			local iAttackState = ATTACK_STATE_NOT_USECASTATTACKORB + ATTACK_STATE_NOT_PROCESSPROCS + ATTACK_STATE_SKIPCOOLDOWN + ATTACK_STATE_IGNOREINVIS + ATTACK_STATE_NO_CLEAVE + ATTACK_STATE_NO_EXTENDATTACK + ATTACK_STATE_SKIPCOUNTING
			params.attacker:Attack(hUnit, iAttackState)
			attack_split = attack_split - 1
			if attack_split <= 0 then
				break
			end
		end
	end
end
---------------------------------------------------------------------
if modifier_brewmaster_windspirit_2_debuff == nil then
	modifier_brewmaster_windspirit_2_debuff = class({}, nil, eom_modifier)
end
function modifier_brewmaster_windspirit_2_debuff:IsDebuff()
	return true
end
function modifier_brewmaster_windspirit_2_debuff:OnCreated(params)
	self.movespeed_reduce = self:GetAbilitySpecialValueFor("movespeed_reduce")
	if IsServer() then
		local hParent = self:GetParent()
	end
end
function modifier_brewmaster_windspirit_2_debuff:EDeclareFunctions()
	return {
		[EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE] = -self.movespeed_reduce
	}
end
function modifier_brewmaster_windspirit_2_debuff:GetMoveSpeedBonusPercentage()
	return -self.movespeed_reduce
end
function modifier_brewmaster_windspirit_2_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_brewmaster_windspirit_2_debuff:OnTooltip()
	return self.movespeed_reduce
end