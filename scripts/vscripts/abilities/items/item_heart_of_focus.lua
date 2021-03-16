---专注之心
if nil == item_heart_of_focus then
	item_heart_of_focus = class({}, nil, base_ability_attribute)
end
function item_heart_of_focus:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_heart_of_focus then
	modifier_item_heart_of_focus = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_heart_of_focus:OnCreated(params)
	self:UpdateValues()
end

function modifier_item_heart_of_focus:IsHidden()
	return false
end
function modifier_item_heart_of_focus:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_heart_of_focus:UpdateValues()
	self.attack_speed_bonus = self:GetAbilitySpecialValueFor('attack_speed_bonus')
	self.stack_account = self:GetAbilitySpecialValueFor('stack_account')
	self.stun_stack_account = self:GetAbilitySpecialValueFor('stun_stack_account')
	self.chance = self:GetAbilitySpecialValueFor('chance')
	self.stun_time = self:GetAbilitySpecialValueFor('stun_time')
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")

end
function modifier_item_heart_of_focus:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK] = { self:GetParent() },
		EMDF_ATTACKT_SPEED_BONUS
	}
end
function modifier_item_heart_of_focus:OnAttack(params)
	if params.target == nil or params.target:GetClassname() == "dota_item_drop" then return end
	-- if params.target ~= self.hTarget then
	if self.hTarget == nil then
		self.hTarget = params.target
	end
	if self.hTarget ~= params.target then
		self:SetStackCount(0)
		self.hTarget = params.target
	end
	if self.unlock_level <= self:GetAbility():GetLevel() then
		if self:GetStackCount() >= self.stun_stack_account and RollPercentage(self.chance) then
			params.target:AddBuff(self:GetParent(), BUFF_TYPE.STUN, self.stun_time)
		end
	end

	if self:GetStackCount() < self.stack_account then
		self:IncrementStackCount()
	end

end


function modifier_item_heart_of_focus:GetAttackSpeedBonus()
	return self.attack_speed_bonus * self:GetStackCount()
end

function modifier_item_heart_of_focus:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_TOOLTIP2
	}
end

function modifier_item_heart_of_focus:OnTooltip2()
	return self.attack_speed_bonus * self:GetStackCount()
end


AbilityClassHook('item_heart_of_focus', getfenv(1), 'abilities/items/item_heart_of_focus.lua', { KeyValues.ItemsKv })