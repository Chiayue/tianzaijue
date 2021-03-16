LinkLuaModifier("modifier_riki_1", "abilities/tower/riki/riki_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_riki_1_buff", "abilities/tower/riki/riki_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if riki_1 == nil then
	riki_1 = class({})
end
function riki_1:GetIntrinsicModifierName()
	return "modifier_riki_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_riki_1 == nil then
	modifier_riki_1 = class({}, nil, eom_modifier)
end
function modifier_riki_1:OnCreated(params)
	self.attack_count = self:GetAbilitySpecialValueFor("attack_count")
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
	self.crit_mult = self:GetAbilitySpecialValueFor("crit_mult")
	self.crit_mult_per_stack = self:GetAbilitySpecialValueFor("crit_mult_per_stack")
	self.phy_pct = self:GetAbilitySpecialValueFor("phy_pct")
	if IsServer() then
	end
end
function modifier_riki_1:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_riki_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_riki_1:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK_LANDED] = { self:GetParent() },
		EMDF_ATTACK_CRIT_BONUS
	}
end
function modifier_riki_1:GetAttackCritBonus(params)
	-- if math.abs(AngleDiff(VectorToAngles(params.attacker:GetForwardVector())[2], VectorToAngles(params.target:GetForwardVector())[2])) <= 90 or
	if params.attacker:HasModifier("modifier_riki_2_buff")
	then
		local bonus_mult = params.attacker:HasModifier("modifier_riki_1_buff") and params.attacker:GetModifierStackCount("modifier_riki_1_buff", params.attacker) or 0
		return self.crit_mult + bonus_mult, 100
	end
end
function modifier_riki_1:OnAttackLanded(params)
	if IsServer() then
		self:IncrementStackCount()
		-- if self:GetStackCount() > self.attack_count then
		local flDamage = params.target:GetHealthDeficit() * self.damage_pct * 0.01 + self:GetParent():GetVal(ATTRIBUTE_KIND.PhysicalAttack) * 0.01 * self.phy_pct
		params.attacker:DealDamage(params.target, self:GetAbility(), flDamage)
		self:SetStackCount(0)
		-- end
		-- if math.abs(AngleDiff(VectorToAngles(params.attacker:GetForwardVector())[2], VectorToAngles(params.target:GetForwardVector())[2])) <= 90 or
		if params.attacker:HasModifier("modifier_riki_2_buff")
		then
			params.attacker:AddNewModifier(params.attacker, self:GetAbility(), "modifier_riki_1_buff", nil)
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_backstab.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)
			ParticleManager:SetParticleControlEnt(iParticleID, 0, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(iParticleID)
			params.target:EmitSound("Hero_Riki.Backstab")
		else
			params.attacker:RemoveModifierByName("modifier_riki_1_buff")
		end
	end
end
---------------------------------------------------------------------
if modifier_riki_1_buff == nil then
	modifier_riki_1_buff = class({}, nil, eom_modifier)
end
function modifier_riki_1_buff:OnCreated(params)
	self.crit_mult_per_stack = self:GetAbilitySpecialValueFor("crit_mult_per_stack")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_riki_1_buff:OnRefresh(params)
	self:OnCreated(params)
end
function modifier_riki_1_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_riki_1_buff:OnTooltip()
	return self.crit_mult_per_stack * self:GetStackCount()
end