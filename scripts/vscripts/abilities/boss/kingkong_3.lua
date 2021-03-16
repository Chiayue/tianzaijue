LinkLuaModifier("modifier_kingkong_3", "abilities/boss/kingkong_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingkong_3_1", "abilities/boss/kingkong_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingkong_3_2", "abilities/boss/kingkong_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if kingkong_3 == nil then
	kingkong_3 = class({})
end
function kingkong_3:OnAbilityPhaseStart()
	self.hModifier = self:GetCaster():AddBuff(self:GetCaster(), BUFF_TYPE.TENACITY)
	return true
end
function kingkong_3:OnAbilityPhaseInterrupted()
	self.hModifier:Destroy()
end
function kingkong_3:OnSpellStart()
	if IsValid(self.hModifier) then
		self.hModifier:Destroy()
	end
	-- 测试
	self:Summon()
end
function kingkong_3:Summon()
	local hCaster = self:GetCaster()
	-- hCaster:ForcePlayActivityOnce(ACT_DOTA_CAST_ABILITY_4)
	local angle = self:GetSpecialValueFor("angle")
	local distance = self:GetSpecialValueFor("distance")
	local boss_health_pct = self:GetSpecialValueFor("boss_health_pct")
	local vDirection = -hCaster:GetForwardVector()
	local tPosition = {
		hCaster:GetAbsOrigin() + Rotation2D(vDirection, math.rad(angle)) * distance,
		hCaster:GetAbsOrigin() + Rotation2D(vDirection, math.rad(-angle)) * distance,
	}
	local tUnitName = {"kingkong_beasts_boar", "kingkong_telepathy_beast"}
	local tModifier = {"modifier_kingkong_3_1", "modifier_kingkong_3_2"}
	
	local iPlayerCount = PlayerData:GetPlayerCount(true)
	if iPlayerCount > 2 then
		tPosition = {
			hCaster:GetAbsOrigin() + Rotation2D(vDirection, math.rad(angle)) * distance,
			hCaster:GetAbsOrigin() + Rotation2D(vDirection, math.rad(angle + 180)) * distance,
			hCaster:GetAbsOrigin() + Rotation2D(vDirection, math.rad(-angle)) * distance,
			hCaster:GetAbsOrigin() + Rotation2D(vDirection, math.rad(-angle + 180)) * distance,
		}
		tUnitName = {"kingkong_beasts_boar", "kingkong_telepathy_beast", "kingkong_beasts_boar", "kingkong_telepathy_beast"}
		tModifier = {"modifier_kingkong_3_1", "modifier_kingkong_3_2", "modifier_kingkong_3_1", "modifier_kingkong_3_2"}
	end
	-- 
	local tUnit = {}
	for i, sUnitName in ipairs(tUnitName) do
		local hUnit = CreateUnitByName(sUnitName, tPosition[i], false, hCaster, hCaster, hCaster:GetTeamNumber())
		hUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
		Attributes:Register(hUnit)
		hUnit:AddNewModifier(hCaster, self, tModifier[i], nil)
		FindClearSpaceForUnit(hUnit, hUnit:GetAbsOrigin(), true)
		hUnit:SetBaseMaxHealth(hCaster:GetMaxHealth() * boss_health_pct * 0.01)
		hUnit:SetMaxHealth(hUnit:GetBaseMaxHealth())
		hUnit:SetHealth(hUnit:GetBaseMaxHealth())
		-- 添加到玩家怪物列表
		Spawner:AddMissing(nil, hUnit)
		table.insert(tUnit, hUnit)
	end
	return tUnit
end
function kingkong_3:GetIntrinsicModifierName()
	return "modifier_kingkong_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_kingkong_3 == nil then
	modifier_kingkong_3 = class({}, nil, BaseModifier)
end
function modifier_kingkong_3:IsHidden()
	return true
end
function modifier_kingkong_3:OnCreated(params)
	self.trigger_pct = self:GetAbilitySpecialValueFor("trigger_pct")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_kingkong_3:OnIntervalThink()
	if self:GetParent():GetHealthPercent() <= self.trigger_pct and self:GetStackCount() == 0 then
		self:GetParent():Purge(false, true, false, true, true)
		ExecuteOrderFromTable({
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self:GetAbility():entindex(),
		})
		self:SetStackCount(1)
	end
end
---------------------------------------------------------------------
if modifier_kingkong_3_1 == nil then
	modifier_kingkong_3_1 = class({}, nil, eom_modifier)
end
function modifier_kingkong_3_1:OnCreated(params)
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_call_boar.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_kingkong_3_1:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK,
	}
end
function modifier_kingkong_3_1:OnAttack(params)
	if params.target == nil or params.target:GetClassname() == "dota_item_drop" then
		return
	end

	if params.attacker == self:GetParent() and not params.attacker:PassivesDisabled() and not params.attacker:AttackFilter(params.record, ATTACK_STATE_NO_EXTENDATTACK) then
		local tTargets = FindUnitsInRadius(params.attacker:GetTeamNumber(), params.attacker:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local attack_split = self:GetAbilitySpecialValueFor('attack_split') - 1
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
if modifier_kingkong_3_2 == nil then
	modifier_kingkong_3_2 = class({}, nil, BaseModifier)
end
function modifier_kingkong_3_2:OnCreated(params)
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.heal_amount_pct = self:GetAbilitySpecialValueFor("heal_amount_pct")
	if IsServer() then
		self:StartIntervalThink(self.interval)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_call_bird.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_kingkong_3_2:OnIntervalThink()
	local hParent = self:GetParent()
	local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, -1, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	table.sort(tTargets, function(a, b) return a:GetHealth() < b:GetHealth() end)
	if IsValid(tTargets[1]) then
		tTargets[1]:Heal(self.heal_amount_pct * tTargets[1]:GetMaxHealth() * 0.01, self:GetAbility())
		-- SendOverheadEventMessage(hParent:GetPlayerOwner(), OVERHEAD_ALERT_HEAL, tTargets[1], self.heal_amount, hParent:GetPlayerOwner())
	end
end