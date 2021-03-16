LinkLuaModifier("modifier_enigma_2", "abilities/tower/enigma/enigma_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enigma_2_enemy_buff", "abilities/tower/enigma/enigma_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enigma_2_max_health", "abilities/tower/enigma/enigma_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if enigma_2 == nil then
	enigma_2 = class({})
end
function enigma_2:GetIntrinsicModifierName()
	return "modifier_enigma_2"
end
function enigma_2:OnEnigmaHit(hTarget, hSource)
	if not hTarget:IsAlive() then return end
	if not hSource:IsAlive() then return end
	if IsValid(hSource) then
		local hModifier = hTarget:FindModifierByNameAndCaster("modifier_enigma_2_enemy_buff", hSource)
		if IsValid(hModifier) then
			hModifier:SetDuration(self:GetSpecialValueFor("duration"), false)
			hModifier:ForceRefresh()
		else
			hTarget:AddNewModifier(hSource, self, "modifier_enigma_2_enemy_buff", { duration = self:GetSpecialValueFor("duration") })
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_enigma_2 == nil then
	modifier_enigma_2 = class({}, nil, eom_modifier)
end
function modifier_enigma_2:IsHidden()
	return true
end
function modifier_enigma_2:OnCreated(params)
	if IsServer() then
	end
end
function modifier_enigma_2:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_enigma_2:OnDestroy()
	if IsServer() then
	end
end
function modifier_enigma_2:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
	}
end
function modifier_enigma_2:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	self:GetAbility():OnEnigmaHit(hTarget, self:GetParent())
end
---------------------------------------------------------------------
if modifier_enigma_2_enemy_buff == nil then
	modifier_enigma_2_enemy_buff = class({}, nil, eom_modifier)
end
function modifier_enigma_2_enemy_buff:IsDebuff()
	return true
end
function modifier_enigma_2_enemy_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_enigma_2_enemy_buff:OnCreated(params)
	self.magical_attack_dps = self:GetAbilitySpecialValueFor("magical_attack_dps")
	self.drain_health_per_mana = self:GetAbilitySpecialValueFor("drain_health_per_mana")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.max_health_duration = self:GetAbilitySpecialValueFor("max_health_duration")
	if IsServer() then
		self:StartIntervalThink(self.interval)
	else
		LocalPlayerAbilityParticle(self:GetAbility(), function()
			-- 敌人特效
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/enigma/enigma_2_dark_watch.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
			ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
			ParticleManager:SetParticleControlEnt(iParticleID, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), false)
			self:AddParticle(iParticleID, false, false, -1, false, false)
			-- 自身特效
			local iParticleID1 = ParticleManager:CreateParticle("particles/units/heroes/enigma/enigma_2_death_soul.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
			ParticleManager:SetParticleControl(iParticleID1, 0, self:GetCaster():GetAbsOrigin())
			self:AddParticle(iParticleID1, false, false, -1, false, false)
		end, PARTICLE_DETAIL_LEVEL_MEDIUM)
	end
end
function modifier_enigma_2_enemy_buff:OnRefresh(params)
	self.magical_attack_dps = self:GetAbilitySpecialValueFor("magical_attack_dps")
	self.drain_health_per_mana = self:GetAbilitySpecialValueFor("drain_health_per_mana")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.max_health_duration = self:GetAbilitySpecialValueFor("max_health_duration")
	if IsServer() then

	end
end
function modifier_enigma_2_enemy_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_enigma_2_enemy_buff:OnIntervalThink()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hAbility = self:GetAbility()
		if not IsValid(hCaster) or not IsValid(hAbility) then
			self:Destroy()
			return
		end
		if not hCaster:IsAlive() then
			self:Destroy()
			return
		end

		local hParent = self:GetParent()

		local hSource = hAbility:GetCaster()

		local fDamage = hSource:GetVal(ATTRIBUTE_KIND.MagicalAttack) * self.magical_attack_dps*0.01 * self.interval
		ApplyDamage({
			ability = hAbility,
			attacker = hCaster,
			victim = hParent,
			damage = fDamage,
			damage_type = hAbility:GetAbilityDamageType()
		})

		local fHeal = hSource:GetMaxMana() * self.drain_health_per_mana * self.interval
		local fHealth = hCaster:GetHealth()
		hCaster:Heal(fHeal, hAbility)
		local fActualHeal = hCaster:GetHealth() - fHealth
		local fOverflowHeal = fHeal - fActualHeal

		if fOverflowHeal > 0 then
			hCaster:AddNewModifier(hCaster, hAbility, "modifier_enigma_2_max_health", {duration = self.max_health_duration, max_health = fOverflowHeal})
		end
	end
end
function modifier_enigma_2_enemy_buff:CheckState()
	return {
	}
end
---------------------------------------------------------------------
if modifier_enigma_2_max_health == nil then
	modifier_enigma_2_max_health = class({}, nil, eom_modifier)
end
function modifier_enigma_2_max_health:OnCreated(params)
	if IsServer() then
		self.fMaxHealth = 0
		self.tData = {}

		local fBonusMaxHealth = params.max_health or 0
		table.insert(self.tData, {
			fDieTime = self:GetDieTime(),
			fMaxHealth = fBonusMaxHealth,
		})
		self.fMaxHealth = self.fMaxHealth + fBonusMaxHealth
		self:SetStackCount(self.fMaxHealth)

		self:StartIntervalThink(0)
	end
end
function modifier_enigma_2_max_health:OnRefresh(params)
	if IsServer() then
		local fBonusMaxHealth = params.max_health or 0
		table.insert(self.tData, {
			fDieTime = self:GetDieTime(),
			fMaxHealth = fBonusMaxHealth,
		})
		self.fMaxHealth = self.fMaxHealth + fBonusMaxHealth
		self:SetStackCount(self.fMaxHealth)
	end
end
function modifier_enigma_2_max_health:OnDestroy()
	if IsServer() then
	end
end
function modifier_enigma_2_max_health:OnIntervalThink()
	if IsServer() then
		local fGameTime = GameRules:GetGameTime()
		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].fDieTime then
				self.fMaxHealth = self.fMaxHealth - self.tData[i].fMaxHealth
				self:SetStackCount(self.fMaxHealth)

				table.remove(self.tData, i)
			end
		end
	end
end
function modifier_enigma_2_max_health:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_enigma_2_max_health:EDeclareFunctions()
	return {
		EMDF_STATUS_HEALTH_BONUS,
	}
end
function modifier_enigma_2_max_health:GetStatusHealthBonus()
	return self:GetStackCount()
end
function modifier_enigma_2_max_health:OnTooltip()
	return self:GetStatusHealthBonus()
end