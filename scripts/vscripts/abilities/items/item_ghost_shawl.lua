LinkLuaModifier("modifier_item_ghost_shawl", "abilities/items/item_ghost_shawl.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_ghost_shawl_buff", "abilities/items/item_ghost_shawl.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_ghost_shawl == nil then
	item_ghost_shawl = class({})
end
function item_ghost_shawl:GetIntrinsicModifierName()
	return "modifier_item_ghost_shawl"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_ghost_shawl == nil then
	modifier_item_ghost_shawl = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_ghost_shawl:IsHidden()
	return true
end
function modifier_item_ghost_shawl:OnCreated(params)
	self.duration = self:GetAbilitySpecialValueFor("duration")
end
function modifier_item_ghost_shawl:OnRefresh(params)
	self.duration = self:GetAbilitySpecialValueFor("duration")
end
function modifier_item_ghost_shawl:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() }
	}
end
function modifier_item_ghost_shawl:OnTakeDamage(params)
	if params.unit == self:GetParent() and self:GetAbility():IsCooldownReady() then
		self:GetAbility():UseResources(false, false, true)
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_ghost_shawl_buff", { duration = self.duration })
		self:GetParent():EmitSound("Hero_Pugna.Decrepify")
	end
end
---------------------------------------------------------------------
if modifier_item_ghost_shawl_buff == nil then
	modifier_item_ghost_shawl_buff = class({}, nil, eom_modifier)
end
function modifier_item_ghost_shawl_buff:IsHidden()
	return true
end
function modifier_item_ghost_shawl_buff:OnCreated(params)
	self.mana_regen = self:GetAbilitySpecialValueFor("mana_regen")
	self.cooldown_reduction = self:GetAbilitySpecialValueFor("cooldown_reduction")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/status_effect_ghost.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		self:AddParticle(iParticleID, false, true, 10, false, false)
	end
end
function modifier_item_ghost_shawl_buff:OnRefresh(params)
	self.mana_regen = self:GetAbilitySpecialValueFor("mana_regen")
	self.cooldown_reduction = self:GetAbilitySpecialValueFor("cooldown_reduction")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
end
function modifier_item_ghost_shawl_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
	}
end
function modifier_item_ghost_shawl_buff:GetModifierPercentageCooldown()
	if self:GetAbility():GetLevel() >= self.unlock_level then
		return self.cooldown_reduction
	end
end
function modifier_item_ghost_shawl_buff:EDeclareFunctions()
	return {
		[EMDF_MANA_REGEN_BONUS] = self.mana_regen,
	}
end
function modifier_item_ghost_shawl_buff:CheckState()
	return {
		-- [MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true
	}
end
-- function modifier_item_ghost_shawl_buff:GetManaRegenBonus()
-- 	return self.mana_regen
-- end