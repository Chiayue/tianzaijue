LinkLuaModifier("modifier_death_prophetA_2", "abilities/tower/death_prophetA/death_prophetA_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_death_prophetA_2_debuff", "abilities/tower/death_prophetA/death_prophetA_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if death_prophetA_2 == nil then
	death_prophetA_2 = class({})
end
function death_prophetA_2:GetIntrinsicModifierName()
	return "modifier_death_prophetA_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_death_prophetA_2 == nil then
	modifier_death_prophetA_2 = class({}, nil, eom_modifier)
end
function modifier_death_prophetA_2:IsHidden()
	return true
end
function modifier_death_prophetA_2:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end
function modifier_death_prophetA_2:OnTakeDamage(params)
	if params.unit.IsCursed and params.unit:IsCursed() and self:GetParent():IsAlive() then
		params.unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_death_prophetA_2_debuff", { duration = self:GetAbility():GetDuration() })
	end
end
------------------------------------------------------------------------------
if modifier_death_prophetA_2_debuff == nil then
	modifier_death_prophetA_2_debuff = class({}, nil, eom_modifier)
end
function modifier_death_prophetA_2_debuff:IsDebuff()
	return true
end
function modifier_death_prophetA_2_debuff:OnCreated(params)
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
	self.max_stack = self:GetAbilitySpecialValueFor("max_stack")
	if IsServer() then
		if self:GetStackCount() < self.max_stack then
			self:IncrementStackCount()
		end
	end
end
function modifier_death_prophetA_2_debuff:OnRefresh(params)
	self:OnCreated(params)
end
function modifier_death_prophetA_2_debuff:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_death_prophetA_2_debuff:EDeclareFunctions()
	return {
		EMDF_INCOMING_PERCENTAGE,
	}
end
function modifier_death_prophetA_2_debuff:GetIncomingPercentage()
	return self.damage_pct * self:GetStackCount()
end