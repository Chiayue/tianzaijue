LinkLuaModifier("modifier_skeleton_warrior_3", "abilities/tower/skeleton_warrior/skeleton_warrior_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_warrior_3_buff", "abilities/tower/skeleton_warrior/skeleton_warrior_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if skeleton_warrior_3 == nil then
	skeleton_warrior_3 = class({})
end
function skeleton_warrior_3:GetIntrinsicModifierName()
	return "modifier_skeleton_warrior_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_skeleton_warrior_3 == nil then
	modifier_skeleton_warrior_3 = class({}, nil, eom_modifier)
end
function modifier_skeleton_warrior_3:IsHidden()
	return true
end
function modifier_skeleton_warrior_3:IsDebuff()
	return false
end
function modifier_skeleton_warrior_3:IsPurgable()
	return false
end
function modifier_skeleton_warrior_3:IsPurgeException()
	return false
end
function modifier_skeleton_warrior_3:IsStunDebuff()
	return false
end
function modifier_skeleton_warrior_3:AllowIllusionDuplicate()
	return false
end
function modifier_skeleton_warrior_3:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.inherited_attack_damage = self:GetAbilitySpecialValueFor("inherited_attack_damage")
	if IsServer() then
		self:StartIntervalThink(0)
		self:OnIntervalThink()
	end
end
function modifier_skeleton_warrior_3:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.inherited_attack_damage = self:GetAbilitySpecialValueFor("inherited_attack_damage")
	if IsServer() then
	end
end
function modifier_skeleton_warrior_3:OnDestroy()
	if IsServer() then
	end
end
function modifier_skeleton_warrior_3:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		if hParent:IsIllusion() then
			self:StartIntervalThink(-1)
			return
		end
		if hParent:IsAlive() then
			self.fPhysicalAttack = hParent:GetVal(ATTRIBUTE_KIND.PhysicalAttack)
		end
	end
end
function modifier_skeleton_warrior_3:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_DEATH] = {nil, self:GetParent()},
	}
end
function modifier_skeleton_warrior_3:OnDeath(params)
	if params.unit:IsIllusion() then return end
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if params.unit == hParent then
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), self.radius, hAbility, FIND_ANY_ORDER)
		local fBonusAttackDamage = self.fPhysicalAttack * self.inherited_attack_damage * 0.01
		for _, hTarget in pairs(tTargets) do
			hTarget:AddNewModifier(hCaster, hAbility, "modifier_skeleton_warrior_3_buff", { bonus_attack_damage = fBonusAttackDamage })
		end
	end
end
---------------------------------------------------------------------
if modifier_skeleton_warrior_3_buff == nil then
	modifier_skeleton_warrior_3_buff = class({}, nil, eom_modifier)
end
function modifier_skeleton_warrior_3_buff:IsHidden()
	return false
end
function modifier_skeleton_warrior_3_buff:IsDebuff()
	return false
end
function modifier_skeleton_warrior_3_buff:IsPurgable()
	return false
end
function modifier_skeleton_warrior_3_buff:IsPurgeException()
	return false
end
function modifier_skeleton_warrior_3_buff:IsStunDebuff()
	return false
end
function modifier_skeleton_warrior_3_buff:AllowIllusionDuplicate()
	return false
end
function modifier_skeleton_warrior_3_buff:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_enrage_buff.vpcf"
end
function modifier_skeleton_warrior_3_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_skeleton_warrior_3_buff:OnCreated(params)
	if IsServer() then
		self:IncrementStackCount(tonumber(params.bonus_attack_damage) or 0)
	end
end
function modifier_skeleton_warrior_3_buff:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount(tonumber(params.bonus_attack_damage) or 0)
	end
end
function modifier_skeleton_warrior_3_buff:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS,
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_skeleton_warrior_3_buff:GetPhysicalAttackBonus()
	return self:GetStackCount()
end
function modifier_skeleton_warrior_3_buff:OnBattleEnd()
	return self:Destroy()
end
function modifier_skeleton_warrior_3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_skeleton_warrior_3_buff:OnTooltip()
	return self:GetPhysicalAttackBonus()
end