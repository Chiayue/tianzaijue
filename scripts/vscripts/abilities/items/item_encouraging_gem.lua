---振奋宝石
LinkLuaModifier("modifier_attack_speed_bonus_buff1", "abilities/items/item_encouraging_gem.lua", LUA_MODIFIER_MOTION_NONE)


if nil == item_encouraging_gem then
	item_encouraging_gem = class({}, nil, base_ability_attribute)
end
function item_encouraging_gem:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_encouraging_gem then
	modifier_item_encouraging_gem = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_encouraging_gem:OnCreated(params)
	self:UpdateValues()
end

function modifier_item_encouraging_gem:IsHidden()
	return true
end
function modifier_item_encouraging_gem:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_encouraging_gem:UpdateValues()

	self.stack_account = self:GetAbilitySpecialValueFor('stack_account')
	self.attack_speed_bonus = self:GetAbilitySpecialValueFor('attack_speed_bonus')
	self.time_duration = self:GetAbilitySpecialValueFor('time_duration')
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
end
function modifier_item_encouraging_gem:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK] = { self:GetParent() },
	}
end

function modifier_item_encouraging_gem:OnAttack(params)
	if params.attacker ~= self:GetParent() then return end

	if self.unlock_level <= self:GetAbility():GetLevel() then
		self.hModifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_attack_speed_bonus_buff1", { duration = self.time_duration })
	end
end



if modifier_attack_speed_bonus_buff1 == nil then
	modifier_attack_speed_bonus_buff1 = class({}, nil, eom_modifier)
end
function modifier_attack_speed_bonus_buff1:OnCreated(params)
	self.stack_account = self:GetAbilitySpecialValueFor('stack_account')
	self.attack_speed_bonus = self:GetAbilitySpecialValueFor('attack_speed_bonus')
	self.time_duration = self:GetAbilitySpecialValueFor('time_duration')
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_attack_speed_bonus_buff1:IsDebuff()
	return false
end
function modifier_attack_speed_bonus_buff1:IsHidden()
	return false
end
function modifier_attack_speed_bonus_buff1:OnRefresh(params)
	self.stack_account = self:GetAbilitySpecialValueFor('stack_account')
	self.attack_speed_bonus = self:GetAbilitySpecialValueFor('attack_speed_bonus')
	self.time_duration = self:GetAbilitySpecialValueFor('time_duration')
	if IsServer() then
		if self:GetStackCount() < self.stack_account then
			self:IncrementStackCount()
		end
	end
end
function modifier_attack_speed_bonus_buff1:OnDestroy(params)
	if IsServer() then

	end
end
function modifier_attack_speed_bonus_buff1:EDeclareFunctions()
	return {
		EMDF_ATTACKT_SPEED_BONUS,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_attack_speed_bonus_buff1:GetAttackSpeedBonus()
	return self.attack_speed_bonus * self:GetStackCount()
end
function modifier_attack_speed_bonus_buff1:OnBattleEnd()
	self:SetStackCount(0)
end

function modifier_attack_speed_bonus_buff1:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2
	}
end
-- function modifier_attack_speed_bonus_buff1:OnTooltip()
-- 	return self.health_per
-- end
function modifier_attack_speed_bonus_buff1:OnTooltip2()
	return self.attack_speed_bonus * self:GetStackCount()
end







AbilityClassHook('item_encouraging_gem', getfenv(1), 'abilities/items/item_encouraging_gem.lua', { KeyValues.ItemsKv })