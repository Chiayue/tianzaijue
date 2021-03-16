LinkLuaModifier("modifier_riki_3", "abilities/tower/riki/riki_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_riki_3_debuff", "abilities/tower/riki/riki_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if riki_3 == nil then
	riki_3 = class({})
end
function riki_3:GetIntrinsicModifierName()
	return "modifier_riki_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_riki_3 == nil then
	modifier_riki_3 = class({}, nil, eom_modifier)
end
function modifier_riki_3:IsHidden()
	return true
end
function modifier_riki_3:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK_LANDED] = { self:GetParent() },
	}
end
function modifier_riki_3:OnAttackLanded(params)
	if math.abs(AngleDiff(VectorToAngles(params.attacker:GetForwardVector())[2], VectorToAngles(params.target:GetForwardVector())[2])) <= 90 or
	params.attacker:HasModifier("modifier_riki_2_buff")
	then
		params.target:AddNewModifier(params.attacker, self:GetAbility(), "modifier_riki_3_debuff", { duration = self:GetAbility():GetDuration() })
	end
end
---------------------------------------------------------------------
if modifier_riki_3_debuff == nil then
	modifier_riki_3_debuff = class({}, nil, eom_modifier)
end
function modifier_riki_3_debuff:IsDebuff()
	return true
end
function modifier_riki_3_debuff:OnCreated(params)
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
	self.max_stack = self:GetAbilitySpecialValueFor("max_stack")
	self.max_bleed_damage = self:GetAbilitySpecialValueFor("max_bleed_damage")
	if IsServer() then
		self:StartIntervalThink(1)
		self:SetStackCount(1)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_riki_3_debuff:OnRefresh(params)
	self.max_bleed_damage = self:GetAbilitySpecialValueFor("max_bleed_damage")
	if IsServer() then
		if self:GetStackCount() < self.max_stack then
			self:IncrementStackCount()
		end
	end
end
function modifier_riki_3_debuff:OnIntervalThink()
	local hParent = self:GetParent()
	local flDamage = math.min(hParent:GetHealth() * self.damage_pct * 0.01 * self:GetStackCount(), self.max_bleed_damage * 0.01 * hParent:GetVal(ATTRIBUTE_KIND.PhysicalAttack))
	if IsValid(self:GetCaster()) and IsValid(hParent) then
		self:GetCaster():DealDamage(hParent, self:GetAbility(), flDamage)
	end
end
function modifier_riki_3_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_riki_3_debuff:OnTooltip()
	return self:GetStackCount()
end