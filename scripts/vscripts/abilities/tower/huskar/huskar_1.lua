LinkLuaModifier("modifier_huskar_1", "abilities/tower/huskar/huskar_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_huskar_1_debuff", "abilities/tower/huskar/huskar_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if huskar_1 == nil then
	huskar_1 = class({})
end
function huskar_1:GetIntrinsicModifierName()
	return "modifier_huskar_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_huskar_1 == nil then
	modifier_huskar_1 = class({}, nil, eom_modifier)
end
function modifier_huskar_1:IsHidden()
	return true
end
function modifier_huskar_1:IsDebuff()
	return false
end
function modifier_huskar_1:IsPurgable()
	return false
end
function modifier_huskar_1:IsPurgeException()
	return false
end
function modifier_huskar_1:IsStunDebuff()
	return false
end
function modifier_huskar_1:OnCreated(params)
	self.health_cost = self:GetAbilitySpecialValueFor("health_cost")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.maximum_health_regen = self:GetAbilitySpecialValueFor("maximum_health_regen")
	self.hp_threshold_max = self:GetAbilitySpecialValueFor("hp_threshold_max")
	if IsClient() then
		self.iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_berserkers_blood.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(self.iParticleID, false, false, -1, false, false)
		self:StartIntervalThink(0)
	end
end
function modifier_huskar_1:OnRefresh(params)
	self.health_cost = self:GetAbilitySpecialValueFor("health_cost")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.maximum_health_regen = self:GetAbilitySpecialValueFor("maximum_health_regen")
	self.hp_threshold_max = self:GetAbilitySpecialValueFor("hp_threshold_max")
end
function modifier_huskar_1:OnDestroy()
end
function modifier_huskar_1:OnIntervalThink()
	if IsClient() then
		local fPercent = RemapValClamped(self:GetParent():GetHealthPercent(), 100, self.hp_threshold_max, 30, 50)
		ParticleManager:SetParticleControl(self.iParticleID, 1, Vector(fPercent, fPercent, fPercent))
		self:StartIntervalThink(0)
	end
end
function modifier_huskar_1:EDeclareFunctions()
	return {
		EMDF_HEALTH_REGEN_BONUS,
		EMDF_ATTACKT_PROJECTILE,
		EMDF_EVENT_ON_ATTACK_HIT,
		[MODIFIER_EVENT_ON_ATTACK] = { self:GetParent() },
	}
end
function modifier_huskar_1:GetHealthRegenBonus(params)
	return RemapValClamped(self:GetParent():GetHealthPercent(), 100, self.hp_threshold_max, 0, self.maximum_health_regen)
end
function modifier_huskar_1:GetAttackProjectile(params)
	return "particles/units/heroes/hero_huskar/huskar_burning_spear.vpcf"
end
function modifier_huskar_1:OnAttack(params)
	if params.target == nil or params.target:GetClassname() == "dota_item_drop" then return end
	local hParent = self:GetParent()
	if params.attacker == hParent then
		local fHealthCost = hParent:GetHealth() * self.health_cost*0.01
		hParent:ModifyHealth(hParent:GetHealth() - fHealthCost, self:GetAbility(), false, 0)

		hParent:EmitSound("Hero_Huskar.Burning_Spear.Cast")
	end
end
function modifier_huskar_1:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	local hAbility = self:GetAbility()
	local hParent = self:GetParent()
	if IsValid(hAbility) then
		EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_Huskar.Burning_Spear", hParent)

		local tTargets = FindUnitsInRadiusWithAbility(hParent, hTarget:GetAbsOrigin(), self.radius, hAbility, FIND_CLOSEST)
		for _, hUnit in pairs(tTargets) do
			hUnit:AddNewModifier(hParent, hAbility, "modifier_huskar_1_debuff", { duration = hAbility:GetDuration() })
		end
	end
end
function modifier_huskar_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_huskar_1:OnTooltip()
	return self:GetHealthRegenBonus()
end
---------------------------------------------------------------------
if modifier_huskar_1_debuff == nil then
	modifier_huskar_1_debuff = class({}, nil, eom_modifier)
end
function modifier_huskar_1_debuff:IsHidden()
	return false
end
function modifier_huskar_1_debuff:IsDebuff()
	return true
end
function modifier_huskar_1_debuff:IsPurgable()
	return false
end
function modifier_huskar_1_debuff:IsPurgeException()
	return false
end
function modifier_huskar_1_debuff:IsStunDebuff()
	return false
end
function modifier_huskar_1_debuff:OnCreated(params)
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
	if IsServer() then
		self.tData = {{
			fDieTime = self:GetDieTime(),
		}}
		self:IncrementStackCount()

		self.fDamageTime = GameRules:GetGameTime() + 1

		self:StartIntervalThink(0)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/status_effect_life_stealer_open_wounds.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, true, 10, false, false)
	end
end
function modifier_huskar_1_debuff:OnRefresh(params)
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
	if IsServer() then
		table.insert(self.tData, {
			fDieTime = self:GetDieTime(),
		})
		self:IncrementStackCount()
	end
end
function modifier_huskar_1_debuff:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local hCaster = self:GetCaster()
		local hAbility = self:GetAbility()
		if not IsValid(hCaster) or not IsValid(hAbility) then
			self:Destroy()
			return
		end
		local fTime = GameRules:GetGameTime()
		for i = #self.tData, 1, -1 do
			if fTime >= self.tData[i].fDieTime then
				self:DecrementStackCount()
				table.remove(self.tData, i)
			end
		end
		if fTime >= self.fDamageTime then
			self.fDamageTime = self.fDamageTime + 1
			hCaster:DealDamage(hParent, hAbility, self:GetStackCount() * hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self.damage_pct*0.01)
		end
	end
end