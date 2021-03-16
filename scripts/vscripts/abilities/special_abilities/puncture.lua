LinkLuaModifier("modifier_puncture", "abilities/special_abilities/puncture.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_puncture_debuff", "abilities/special_abilities/puncture.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if puncture == nil then
	puncture = class({})
end
function puncture:GetIntrinsicModifierName()
	return "modifier_puncture"
end
---------------------------------------------------------------------
--Modifiers
if modifier_puncture == nil then
	modifier_puncture = class({}, nil, eom_modifier)
end
function modifier_puncture:OnCreated(params)
	if IsServer() then
	end
end
function modifier_puncture:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_puncture:OnDestroy()
	if IsServer() then
	end
end
function modifier_puncture:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK] = { self:GetParent() }
	}
end
function modifier_puncture:OnAttack(params)
	if params.target == nil
	or params.target:GetClassname() == "dota_item_drop" then
		return
	end

	if params.attacker ~= self:GetParent()
	or params.attacker:PassivesDisabled()
	or params.attacker:AttackFilter(params.record, ATTACK_STATE_NO_EXTENDATTACK) then
		return
	end

	local hAbility = self:GetAbility()
	if hAbility:IsCooldownReady() then
		local hTarget = params.target
		if IsValid(hTarget) and hTarget:IsAlive() then
			StartCooldown(hAbility)

			local hCaster = self:GetCaster()
			local duration = hAbility:GetDuration()
			hTarget:AddNewModifier(hCaster, hAbility, "modifier_puncture_debuff", { duration = duration })
		end
	end
end

------------------------------------------------------------------------------
if modifier_puncture_debuff == nil then
	modifier_puncture_debuff = class({}, nil, eom_modifier)
end
function modifier_puncture_debuff:IsDebuff()
	return true
end
function modifier_puncture_debuff:OnCreated(params)
	self.physical_armor_reduce = self:GetAbilitySpecialValueFor("physical_armor_reduce")
	self.max_stack_count = self:GetAbilitySpecialValueFor("max_stack_count")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_puncture_debuff:OnRefresh(params)
	self.physical_armor_reduce = self:GetAbilitySpecialValueFor("physical_armor_reduce")
	self.max_stack_count = self:GetAbilitySpecialValueFor("max_stack_count")
	if IsServer() then
		if self:GetStackCount() < self.max_stack_count then
			self:IncrementStackCount()
		end
	end
end
function modifier_puncture_debuff:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_puncture_debuff:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ARMOR_BONUS
	}
end
function modifier_puncture_debuff:GetPhysicalArmorBonus()
	return -self.physical_armor_reduce * self:GetStackCount()
end