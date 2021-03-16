LinkLuaModifier("modifier_mirana_2_buff", "abilities/tower/mirana/mirana_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if mirana_2 == nil then
	mirana_2 = class({})
end
function mirana_2:GetIntrinsicModifierName()
	return "modifier_mirana_2"
end
function mirana_2:MoonHit(hTarget)
	local hCaster = self:GetCaster()
	local damage_pct = self:GetSpecialValueFor("damage_pct")
	local attack_bonus_pct = self:GetSpecialValueFor("attack_bonus_pct")
	if not self:GetCaster():IsAlive() then return end
	if hCaster:IsIllusion() then return end
	if IsValid(hCaster) and self:GetLevel() > 0 then
		self:GetCaster():EmitSound("Ability.Starfall")
		local target_point = hTarget:GetAbsOrigin()
		local particleID = ParticleManager:CreateParticle("particles/units/heroes/mirana/mirana_2_starfall_attack.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(particleID, 0, hTarget, PATTACH_CUSTOMORIGIN_FOLLOW, nil, hTarget:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particleID)
	end

	self:GetCaster():GameTimer(0.57, function()
		if IsValid(hTarget) then
			EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Ability.StarfallImpact", self:GetCaster())
			local damage_table =					{
				ability = self,
				attacker = self:GetCaster(),
				victim = hTarget,
				damage = damage_pct * 0.01 * self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalAttack),
				damage_type = DAMAGE_TYPE_MAGICAL
			}
			ApplyDamage(damage_table)

			self:GetCaster():AddNewModifier(self:GetCaster(), self, 'modifier_mirana_2_buff', { duration = 200 })
		end
	end)
end
---------------------------------------------------------------------
--Modifiers
if modifier_mirana_2_buff == nil then
	modifier_mirana_2_buff = class({}, nil, eom_modifier)
end
function modifier_mirana_2_buff:OnCreated(params)
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
	self.attack_bonus_pct = self:GetAbilitySpecialValueFor("attack_bonus_pct")
	self.max_count = self:GetAbilitySpecialValueFor("max_count")
	self:SetStackCount(1)
	if IsServer() then
		local particleID = ParticleManager:CreateParticle("particles/units/heroes/mirana/mirana_2_leap_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlForward(particleID, 1, self:GetParent():GetForwardVector())
		ParticleManager:ReleaseParticleIndex(particleID)
	end
end
function modifier_mirana_2_buff:OnRefresh(params)
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
	self.attack_bonus_pct = self:GetAbilitySpecialValueFor("attack_bonus_pct")
	self.max_count = self:GetAbilitySpecialValueFor("max_count")
	if IsServer() then
		if self.max_count > self:GetStackCount() then
			self:IncrementStackCount()
			local particleID = ParticleManager:CreateParticle("particles/units/heroes/mirana/mirana_2_leap_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControlForward(particleID, 1, self:GetParent():GetForwardVector())
			ParticleManager:ReleaseParticleIndex(particleID)
		end
	end
end
function modifier_mirana_2_buff:EDeclareFunctions()
	return {
		EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_mirana_2_buff:GetMagicalAttackBonusPercentage()
	return self:GetStackCount() * self.attack_bonus_pct
end
function modifier_mirana_2_buff:OnBattleEnd()
	self:SetStackCount(0)
	self:Destroy()
end
function modifier_mirana_2_buff:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_mirana_2_buff:OnTooltip()
	return self:GetStackCount()*self.attack_bonus_pct
end