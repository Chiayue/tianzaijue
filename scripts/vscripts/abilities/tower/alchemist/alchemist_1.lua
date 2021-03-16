LinkLuaModifier("modifier_alchemist_1_buff", "abilities/tower/alchemist/alchemist_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if alchemist_1 == nil then
	alchemist_1 = class({ iBehavior = DOTA_ABILITY_BEHAVIOR_NO_TARGET }, nil, ability_base_ai)
end
function alchemist_1:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_alchemist_1_buff", { duration = self:GetDuration() })
	hCaster:EmitSound("Hero_Alchemist.ChemicalRage.Cast")
	-- 二技能
	local hModifier = hCaster:FindModifierByName("modifier_alchemist_2")
	if IsValid(hModifier) then
		hModifier:SetStackCount(hModifier:GetStackCount() + 1)
		hModifier:ForceRefresh()
	end
end
function alchemist_1:GetIntrinsicModifierName()
	-- return "modifier_alchemist_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_alchemist_1_buff == nil then
	modifier_alchemist_1_buff = class({}, nil, eom_modifier)
end
function modifier_alchemist_1_buff:OnCreated(params)
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	self.heal_regen_pct = self:GetAbilitySpecialValueFor("heal_regen_pct")
	self.attack_bonus_pct = self:GetAbilitySpecialValueFor("attack_bonus_pct")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_chemical_rage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_chemichalrage_effect.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_ogerhead", self:GetParent():GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_chemical_rage_hero_effect.vpcf", PATTACH_INVALID, self:GetParent())
		self:AddParticle(iParticleID, false, false, 100, true, false)
		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/status_effect_chemical_rage.vpcf", PATTACH_INVALID, self:GetParent())
		self:AddParticle(iParticleID, false, true, 100, false, false)
	end
end
function modifier_alchemist_1_buff:OnIntervalThink()
	if self:GetAbility():IsAbilityReady() then
		ExecuteOrder(self:GetParent(), DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, self:GetAbility())
	end
end
function modifier_alchemist_1_buff:OnDestroy()
	if IsServer() then
		self:GetParent():StartGesture(ACT_DOTA_ALCHEMIST_CHEMICAL_RAGE_END)
	end
end
function modifier_alchemist_1_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_alchemist_1_buff:EDeclareFunctions()
	return {
		[EMDF_ATTACKT_SPEED_BONUS] = self.attackspeed,
		[EMDF_MOVEMENT_SPEED_BONUS] = self.movespeed,
		EMDF_HEALTH_REGEN_BONUS,
		[EMDF_BONUS_MAXIMUM_ATTACK_SPEED] = math.max(self.attackspeed, 500),
		EMDF_PHYSICAL_ATTACK_BONUS,
	}
end
function modifier_alchemist_1_buff:GetHealthRegenBonus()
	return self.heal_regen_pct * self:GetParent():GetVal(ATTRIBUTE_KIND.StatusHealth) * 0.01
end
function modifier_alchemist_1_buff:GetActivityTranslationModifiers()
	return "chemical_rage"
end
function modifier_alchemist_1_buff:GetPhysicalAttackBonus()
	return self.attack_bonus_pct * self:GetCaster():GetValByKey(ATTRIBUTE_KIND.PhysicalAttack, ATTRIBUTE_KEY.BASE) * 0.01
end
function modifier_alchemist_1_buff:OnTooltip()
	self.iTooltip = ((self.iTooltip or -1) + 1) % 4
	if 0 == self.iTooltip then
		return self.attackspeed
	end
	if 1 == self.iTooltip then
		return self.movespeed
	end
	if 2 == self.iTooltip then
		return self.heal_regen_pct
	end
	return self.attack_bonus_pct
end