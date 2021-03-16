LinkLuaModifier("modifier_doomA_3_debuff", "abilities/tower/doomA/doomA_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_doomA_3_buff", "abilities/tower/doomA/doomA_3.lua", LUA_MODIFIER_MOTION_NONE)
if doomA_3 == nil then
	funcSortFunction = function(a, b)
		return a:GetHealth() < b:GetHealth()
	end
	doomA_3 = class({ iBehavior = DOTA_ABILITY_BEHAVIOR_UNIT_TARGET, funcSortFunction = funcSortFunction }, nil, ability_base_ai)
end
function doomA_3:Spawn()
	local hCaster = self:GetCaster()
	self.tGolem = {}
end
function doomA_3:GetGolem()
	return self.tGolem
end
function doomA_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	hTarget:AddNewModifier(hCaster, self, "modifier_doomA_3_debuff", { duration = self:GetDuration() })
end
---------------------------------------------------------------------
--Modifiers
if modifier_doomA_3_debuff == nil then
	modifier_doomA_3_debuff = class({}, nil, eom_modifier)
end
function modifier_doomA_3_debuff:IsDebuff()
	return true
end
function modifier_doomA_3_debuff:OnCreated(params)
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.tick_radius = self:GetAbilitySpecialValueFor("tick_radius")
	self.summon_radius = self:GetAbilitySpecialValueFor("summon_radius")
	self.tick_damage_factor = self:GetAbilitySpecialValueFor("tick_damage_factor")
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	self.summon_damage_factor = self:GetAbilitySpecialValueFor("summon_damage_factor")
	self.golem_count = self:GetAbilitySpecialValueFor("golem_count")
	if IsServer() then
		self.flDamage = self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self.tick_damage_factor * self.interval * 0.01
		self.flSummonDamage = self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self.summon_damage_factor * self.interval * 0.01
		self:StartIntervalThink(self.interval)

		self:GetParent():EmitSound("Hero_DoomBringer.Doom")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_doomA_3_debuff:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Hero_DoomBringer.Doom")
	end
end
function modifier_doomA_3_debuff:CheckState()
	if IsServer() then
		return {
			[MODIFIER_STATE_SILENCED] = self:GetParent():IsFriendly(self:GetCaster()) or not self:GetParent():IsBoss(),
		}
	end
end
function modifier_doomA_3_debuff:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	if IsValid(hCaster) then
		local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.tick_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		hCaster:DealDamage(tTargets, self:GetAbility(), self.flDamage)
	end
end
function modifier_doomA_3_debuff:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_DEATH] = {nil, self:GetParent() },
	}
end
function modifier_doomA_3_debuff:OnDeath()
	local hCaster = self:GetCaster()
	if not IsValid(hCaster) or not IsValid(self:GetAbility()) then
		return
	end
	local hParent = self:GetParent()
	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.summon_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, hUnit in pairs(tTargets) do
		hCaster:DealDamage(hUnit, self:GetAbility(), self.flSummonDamage)
		hUnit:AddBuff(hCaster, BUFF_TYPE.STUN, self.stun_duration)
	end
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Hero_Warlock.RainOfChaos")
	local tGolem = self:GetAbility():GetGolem()
	local hUnit = CreateUnitByName("npc_dota_doom_golem", self:GetParent():GetAbsOrigin(), false, hCaster, hCaster, hCaster:GetTeamNumber())
	hUnit:FireSummonned(hCaster)
	Attributes:Register(hUnit)
	hUnit:AddNewModifier(hCaster, nil, "modifier_building_ai", nil)
	hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_doomA_3_buff", nil)
	hUnit:AddAbility("doomA_1"):SetLevel(self:GetAbility():GetLevel())
	table.insert(tGolem, hUnit)
	-- 清除多余的
	if #tGolem > self.golem_count then
		tGolem[1]:RemoveModifierByName("modifier_doomA_3_buff")
	end
end
---------------------------------------------------------------------
if modifier_doomA_3_buff == nil then
	modifier_doomA_3_buff = class({}, nil, eom_modifier)
end
function modifier_doomA_3_buff:OnCreated(params)
	self.attribute_pct = self:GetAbilitySpecialValueFor("attribute_pct")
	self.health = self.attribute_pct * self:GetCaster():GetVal(ATTRIBUTE_KIND.StatusHealth) * 0.01
	self.attack = self.attribute_pct * self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalAttack) * 0.01
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_doomA_3_buff:OnRefresh(params)
	self:OnCreated(params)
end
function modifier_doomA_3_buff:OnDestroy()
	if IsServer() then
		if IsValid(self:GetCaster()) and IsValid(self:GetAbility()) then
			local tGolem = self:GetAbility():GetGolem()
			ArrayRemove(tGolem, self:GetParent())
			self:GetParent():ForceKill(false)
		end
	end
end
function modifier_doomA_3_buff:OnIntervalThink()
	if not IsValid(self:GetCaster()) or GSManager:getStateType() ~= GS_Battle then
		self:Destroy()
	end
end
function modifier_doomA_3_buff:EDeclareFunctions()
	return {
		[EMDF_STATUS_HEALTH_BONUS] = self.health,
		[EMDF_MAGICAL_ATTACK_BONUS] = self.attack,
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_doomA_3_buff:GetStatusHealthBonus()
	return self.health
end
function modifier_doomA_3_buff:GetMagicalAttackBonus()
	return self.attack
end
function modifier_doomA_3_buff:OnInBattle()
	if IsValid(self:GetParent()) then
		self:GetParent():AddNewModifier(self:GetCaster(), nil, "modifier_building_ai", nil)
	end
end
function modifier_doomA_3_buff:OnBattleEnd()
	local hParent = self:GetParent()
	hParent:RemoveModifierByName("modifier_building_ai")
	self:Destroy()
end