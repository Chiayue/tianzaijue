LinkLuaModifier("modifier_death_prophetA_1_debuff", "abilities/tower/death_prophetA/death_prophetA_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if death_prophetA_1 == nil then
	death_prophetA_1 = class({}, nil, ability_base_ai)
end
function death_prophetA_1:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function death_prophetA_1:OnSpellStart()
	local hCaster = self:GetCaster()

	local target_count = self:GetSpecialValueFor("target_count")
	local radius = self:GetSpecialValueFor("radius")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), radius, self)
	for _, hUnit in ipairs(tTargets) do
		if target_count > 0 then
			target_count = target_count -1
			hUnit:AddNewModifier(hCaster, self, "modifier_death_prophetA_1_debuff", { duration = self:GetDuration() })
		else
			break
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_death_prophetA_1_debuff == nil then
	modifier_death_prophetA_1_debuff = class({}, nil, BaseModifier)
end
function modifier_death_prophetA_1_debuff:OnCreated(params)
	self.curse_damage_pct = self:GetAbilitySpecialValueFor("curse_damage_pct")
	self.magical_factor = self:GetAbilitySpecialValueFor("magical_factor")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	if IsServer() then
		self:StartIntervalThink(self.interval)
	else
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_death_prophet/death_prophet_spiritsiphon.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_head", hCaster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(iParticleID, 5, Vector(self:GetDuration(), 0, 0))
		ParticleManager:SetParticleControl(iParticleID, 11, Vector(0, 0, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_death_prophetA_1_debuff:OnRefresh(params)
	self.curse_damage_pct = self:GetAbilitySpecialValueFor("curse_damage_pct")
	self.magical_factor = self:GetAbilitySpecialValueFor("magical_factor")
	if IsServer() then
	else
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_death_prophet/death_prophet_spiritsiphon.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_head", hCaster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(iParticleID, 5, Vector(self:GetDuration(), 0, 0))
		ParticleManager:SetParticleControl(iParticleID, 11, Vector(0, 0, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_death_prophetA_1_debuff:OnDestroy(params)
	if IsServer() then
		self:StartIntervalThink(-1)
	end
end
function modifier_death_prophetA_1_debuff:OnIntervalThink()
	if IsServer() then
		if not IsValid(self:GetParent())
		or not IsValid(self:GetCaster())
		or not self:GetParent():IsAlive()
		or not self:GetCaster():IsAlive() then
			self:Destroy()
			return
		end

		-- 敌人身上有诅咒效果
		local flDamage = self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalAttack) * self.magical_factor * 0.01
		if self:GetParent().IsCursed and self:GetParent():IsCursed() then
			flDamage = flDamage * self.curse_damage_pct * 0.01
		end
		self:GetCaster():DealDamage(self:GetParent(), self:GetAbility(), flDamage)
	end
end
function modifier_death_prophetA_1_debuff:DeclareFunctions()
	return {
	}
end
function modifier_death_prophetA_1_debuff:CheckState()
	return {
	}
end
function modifier_death_prophetA_1_debuff:IsDebuff()
	return true
end