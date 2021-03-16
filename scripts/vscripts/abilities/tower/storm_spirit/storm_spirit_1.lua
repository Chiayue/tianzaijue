LinkLuaModifier("modifier_storm_spirit_1", "abilities/tower/storm_spirit/storm_spirit_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_storm_spirit_1_buff", "abilities/tower/storm_spirit/storm_spirit_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_storm_spirit_1_debuff", "abilities/tower/storm_spirit/storm_spirit_1.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if storm_spirit_1 == nil then
	storm_spirit_1 = class({})
end
function storm_spirit_1:AddElectric(iCount)
	local hCaster = self:GetCaster()
	local mana_regen = self:GetSpecialValueFor("mana_regen")
	local stack_count = self:GetSpecialValueFor("stack_count")
	local hModifier = self:GetIntrinsicModifier()
	if IsValid(hModifier) then
		hModifier:SetStackCount(hModifier:GetStackCount() + stack_count)
		hCaster:GiveMana(mana_regen)
	end
end
function storm_spirit_1:GetIntrinsicModifierName()
	return "modifier_storm_spirit_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_storm_spirit_1 == nil then
	modifier_storm_spirit_1 = class({}, nil, eom_modifier)
end
function modifier_storm_spirit_1:IsHidden()
	return false
end
function modifier_storm_spirit_1:IsDebuff()
	return false
end
function modifier_storm_spirit_1:IsPurgable()
	return false
end
function modifier_storm_spirit_1:IsPurgeException()
	return false
end
function modifier_storm_spirit_1:IsStunDebuff()
	return false
end
function modifier_storm_spirit_1:AllowIllusionDuplicate()
	return false
end
function modifier_storm_spirit_1:OnCreated(params)
	self.max_stack = self:GetAbilitySpecialValueFor("max_stack")
end
function modifier_storm_spirit_1:OnRefresh(params)
	self.max_stack = self:GetAbilitySpecialValueFor("max_stack")
end
function modifier_storm_spirit_1:OnStackCountChanged(iStackCount)
	if IsServer() then
		if self:GetStackCount() >= self.max_stack then
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_storm_spirit_1_buff", nil)
			self:SetStackCount(self:GetStackCount() - self.max_stack)
		end
	end
end
function modifier_storm_spirit_1:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
	}
end
function modifier_storm_spirit_1:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	local hParent = self:GetParent()
	local hAbility = self:GetAbility()

	hTarget:AddNewModifier(hParent, hAbility, "modifier_storm_spirit_1_debuff", { duration = hAbility:GetDuration() })
end
function modifier_storm_spirit_1:OnBattleEnd()
	self:SetStackCount(0)
end
---------------------------------------------------------------------
if modifier_storm_spirit_1_buff == nil then
	modifier_storm_spirit_1_buff = class({}, nil, eom_modifier)
end
function modifier_storm_spirit_1_buff:GetTexture()
	return "storm_spirit_overload"
end
function modifier_storm_spirit_1_buff:IsHidden()
	return false
end
function modifier_storm_spirit_1_buff:IsDebuff()
	return false
end
function modifier_storm_spirit_1_buff:IsPurgable()
	return false
end
function modifier_storm_spirit_1_buff:IsPurgeException()
	return false
end
function modifier_storm_spirit_1_buff:IsStunDebuff()
	return false
end
function modifier_storm_spirit_1_buff:AllowIllusionDuplicate()
	return false
end
function modifier_storm_spirit_1_buff:OnCreated(params)
	local hParent = self:GetParent()
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self:IncrementStackCount()
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_overload_ambient.vpcf", PATTACH_CUSTOMORIGIN, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_attack1", hParent:GetAbsOrigin(), true)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_storm_spirit_1_buff:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_storm_spirit_1_buff:OnStackCountChanged(iStackCount)
	if IsServer() then
		if self:GetStackCount() <= 0 then
			self:Destroy()
		end
	end
end
function modifier_storm_spirit_1_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
end
function modifier_storm_spirit_1_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_storm_spirit_1_buff:GetActivityTranslationModifiers()
	return "overload"
end
function modifier_storm_spirit_1_buff:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	local vPosition = vLocation or hTarget:GetAbsOrigin()
	
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local tTargets = FindUnitsInRadiusWithAbility(hParent, vPosition, self.radius, hAbility)
	hParent:DealDamage(tTargets, hAbility, hAbility:GetAbilityDamage())
	self:DecrementStackCount()

	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/storm_spirit/strom_spirit_ti8/storm_sprit_ti8_overload_discharge.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, self.radius, self.radius))
	ParticleManager:ReleaseParticleIndex(iParticleID)
end
function modifier_storm_spirit_1_buff:OnBattleEnd()
	self:Destroy()
end
---------------------------------------------------------------------
if modifier_storm_spirit_1_debuff == nil then
	modifier_storm_spirit_1_debuff = class({}, nil, eom_modifier)
end
function modifier_storm_spirit_1_debuff:IsHidden()
	return false
end
function modifier_storm_spirit_1_debuff:IsDebuff()
	return true
end
function modifier_storm_spirit_1_debuff:IsPurgable()
	return true
end
function modifier_storm_spirit_1_debuff:IsPurgeException()
	return true
end
function modifier_storm_spirit_1_debuff:IsStunDebuff()
	return false
end
function modifier_storm_spirit_1_debuff:AllowIllusionDuplicate()
	return false
end
function modifier_storm_spirit_1_debuff:OnCreated(params)
	self.slow_attack_speed_pct = self:GetAbilitySpecialValueFor("slow_attack_speed_pct")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	if IsServer() then
		self:StartIntervalThink(self.interval)
		self:OnIntervalThink()
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/storm_spirit_1.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_storm_spirit_1_debuff:OnRefresh(params)
	self.slow_attack_speed_pct = self:GetAbilitySpecialValueFor("slow_attack_speed_pct")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	if IsServer() then
		self:OnIntervalThink()
	end
end
function modifier_storm_spirit_1_debuff:OnIntervalThink()
	if IsServer() then
		local hAbility = self:GetAbility()
		if not IsValid(hAbility) then
			self:Destroy()
			return
		end
		if type(hAbility.AddElectric) == "function" then
			hAbility:AddElectric()
		end
	end
end
function modifier_storm_spirit_1_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_storm_spirit_1_debuff:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE
	}
end
function modifier_storm_spirit_1_debuff:OnAbilityExecuted(params)
	if params.unit == self:GetParent() then
		if params.ability ~= nil and not params.ability:IsItem() and not params.ability:IsToggle() and params.ability:ProcsMagicStick() then
			local hAbility = self:GetAbility()
			if not IsValid(hAbility) then
				self:Destroy()
				return
			end
			if type(hAbility.AddElectric) == "function" then
				hAbility:AddElectric()
			end
		end
	end
end
function modifier_storm_spirit_1_debuff:OnTooltip()
	return self.slow_attack_speed_pct * self:GetParent():GetStatusResistanceFactor(self:GetCaster())
end
function modifier_storm_spirit_1_debuff:GetAttackSpeedPercentage()
	return -self.slow_attack_speed_pct * self:GetParent():GetStatusResistanceFactor(self:GetCaster())
end