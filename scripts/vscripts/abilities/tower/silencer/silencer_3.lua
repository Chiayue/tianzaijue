LinkLuaModifier("modifier_silencer_3", "abilities/tower/silencer/silencer_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_silencer_3_effect", "abilities/tower/silencer/silencer_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if silencer_3 == nil then
	silencer_3 = class({})
end
function silencer_3:Trigger()
	if self:GetLevel() <= 0 then
		return
	end

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_silencer_3", {})
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_silencer_3_effect", { duration = LOCAL_PARTICLE_MODIFIER_DURATION })
end
---------------------------------------------------------------------
--Modifiers
if modifier_silencer_3 == nil then
	modifier_silencer_3 = class({}, nil, eom_modifier)
end
function modifier_silencer_3:OnCreated(params)
	self.maximum_health_bonus = self:GetAbilitySpecialValueFor("maximum_health_bonus")
	self.max_stack_count = self:GetAbilitySpecialValueFor("max_stack_count")
	if IsServer() then
		if self:GetStackCount() < self.max_stack_count then
			self:IncrementStackCount()
		end
	end
end
function modifier_silencer_3:OnRefresh(params)
	self.maximum_health_bonus = self:GetAbilitySpecialValueFor("maximum_health_bonus")
	self.max_stack_count = self:GetAbilitySpecialValueFor("max_stack_count")
	if IsServer() then
		if self:GetStackCount() < self.max_stack_count then
			self:IncrementStackCount()
		end
	end
end
function modifier_silencer_3:OnDestroy()
	if IsServer() then
	end
end
function modifier_silencer_3:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_PREPARATION
	}
end
function modifier_silencer_3:OnPreparation()
	self:Destroy()
end
function modifier_silencer_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS
	}
end
function modifier_silencer_3:GetModifierExtraHealthBonus()
	return self.maximum_health_bonus * self:GetStackCount()
end

------------------------------------------------------------------------------
if modifier_silencer_3_effect == nil then
	modifier_silencer_3_effect = class({}, nil, BaseModifier)
end
function modifier_silencer_3_effect:IsHidden()
	return true
end
function modifier_silencer_3_effect:OnCreated(params)
	if IsClient() then
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_silencer/silencer_last_word_status.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticle, false, false, 0, false, false)
	end
end
function modifier_silencer_3_effect:OnRefresh(params)
	if IsClient() then
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_silencer/silencer_last_word_status.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticle, false, false, 0, false, false)
	end
end