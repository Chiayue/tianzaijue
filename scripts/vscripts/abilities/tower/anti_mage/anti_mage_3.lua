LinkLuaModifier("modifier_anti_mage_3", "abilities/tower/anti_mage/anti_mage_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_anti_mage_3_particle", "abilities/tower/anti_mage/anti_mage_3.lua", LUA_MODIFIER_MOTION_NONE)

if anti_mage_3 == nil then
	local tInitData = {
		iBehavior = DOTA_ABILITY_BEHAVIOR_UNIT_TARGET,
		funcSortFunction = function(a, b)
			return a:GetMana() < b:GetMana()
		end
	}
	anti_mage_3 = class(tInitData, nil, ability_base_ai)
end
function anti_mage_3:GetManaCost(iLevel)
	return self:GetCaster():GetMaxMana()
end
function anti_mage_3:GetIntrinsicModifierName()
	return "modifier_anti_mage_3"
end
function anti_mage_3:OnAbilityPhaseStart()
	EmitSoundOn("Hero_Antimage.ManaVoidCast", self:GetCaster())
	self.iManaCostCur = self:GetManaCost(self:GetLevel())
	return true
end
function anti_mage_3:OnAbilityPhaseInterrupted()
	StopSoundOn("Hero_Antimage.ManaVoidCast", self:GetCaster())
	return true
end
function anti_mage_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local physical_rate = self:GetSpecialValueFor("physical_rate")
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	local mana_damage_pct = self:GetSpecialValueFor("mana_damage_pct")
	local radius = self:GetSpecialValueFor("radius")

	--特效
	hCaster:AddNewModifier(hTarget, self, 'modifier_anti_mage_3_particle', { duration = LOCAL_PARTICLE_MODIFIER_DURATION })
	EmitSoundOn("Hero_Antimage.ManaVoid", hTarget)

	-- --一技能回蓝量
	-- local iManaRegainCur = 1
	-- local hAblt1 = hCaster:FindAbilityByName('anti_mage_1')
	-- if IsValid(hAblt1) and hAblt1.iManaRegainCur and 0 < hAblt1.iManaRegainCur then
	-- 	iManaRegainCur = hAblt1.iManaRegainCur
	-- 	hAblt1.iManaRegainCur = 0
	-- end
	--伤害和眩晕
	local fDamage = mana_damage_pct * 0.01 * self.iManaCostCur * physical_rate * 0.01 * hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack)
	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hTarget:GetAbsOrigin(), nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_CLOSEST, false)
	for n, hUnit in pairs(tTargets) do
		hUnit:AddBuff(hCaster, BUFF_TYPE.STUN, stun_duration)
		ApplyDamage({
			ability = self,
			attacker = hCaster,
			victim = hUnit,
			damage = fDamage,
			damage_type = self:GetAbilityDamageType()
		})
	end

	--成功释放
	-- local hBuff = hCaster:FindModifierByName(self:GetIntrinsicModifierName())
	-- if hBuff then
	-- 	hBuff:StartIntervalThink(-1)
	-- 	hBuff:SetStackCount(0)
	-- end
end

---------------------------------------------------------------------
--Modifiers
if modifier_anti_mage_3 == nil then
	modifier_anti_mage_3 = class({}, nil, eom_modifier)
end
function modifier_anti_mage_3:IsHidden()
	return true
end
function modifier_anti_mage_3:OnCreated(params)
	self.attack_count = self:GetAbilitySpecialValueFor("attack_count")
	self.mana_damage_pct = self:GetAbilitySpecialValueFor("mana_damage_pct")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_anti_mage_3:OnRefresh(params)
	self.attack_count = self:GetAbilitySpecialValueFor("attack_count")
	self.mana_damage_pct = self:GetAbilitySpecialValueFor("mana_damage_pct")
end
function modifier_anti_mage_3:OnIntervalThink()
	local hParent = self:GetParent()
	local hAblt = self:GetAbility()
	if not hAblt:IsAbilityReady() then return end

	if not IsValid(self.hTarget) or not self.hTarget:IsAlive() then
		--原单位死亡，重新寻找魔法最少的单位
		local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, 500, hAblt:GetAbilityTargetTeam(), hAblt:GetAbilityTargetType(), hAblt:GetAbilityTargetFlags(), FIND_CLOSEST, false)
		local iMana
		for _, hTarget in pairs(tTargets) do
			if not iMana or hTarget:GetMana() < iMana then
				iMana = hTarget:GetMana()
				self.hTarget = hTarget
			end
		end
	end
	if not IsValid(self.hTarget) then return end

	--达到次数，释放法力虚空
	ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_TARGET, self.hTarget, self:GetAbility())
	-- hParent:SetCursorCastTarget(hTarget)
	-- self:GetAbility():OnSpellStart()
	self.hTarget = nil
end
function modifier_anti_mage_3:EDeclareFunctions()
	return {
	-- EMDF_EVENT_ON_ATTACK_HIT,
	}
end
function modifier_anti_mage_3:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if nil == hTarget
	or tAttackInfo.attacker ~= self:GetParent()
	or IsAttackMiss(tAttackInfo)
	or self:GetParent():PassivesDisabled()
	then return end

	local hParent = self:GetParent()

	self:SetStackCount(math.min(self:GetStackCount() + 1, self.attack_count))
	if self:GetStackCount() >= self.attack_count then
		self.hTarget = hTarget
		self:StartIntervalThink(0)
	end
end

--法力虚空特效
if modifier_anti_mage_3_particle == nil then
	modifier_anti_mage_3_particle = class({}, nil, ParticleModifier)
end
function modifier_anti_mage_3_particle:OnCreated(params)
	if IsServer() then
	else
		local radius = self:GetAbilitySpecialValueFor("radius")
		LocalPlayerAbilityParticle(self:GetAbility(), function()
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_manavoid.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, 0, 0))
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end, PARTICLE_DETAIL_LEVEL_ULTRA)
	end
end