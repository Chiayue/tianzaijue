LinkLuaModifier("modifier_item_sharp_dish_debuff", "abilities/items/item_sharp_dish.lua", LUA_MODIFIER_MOTION_NONE)

---争强法盘
if nil == item_sharp_dish then
	item_sharp_dish = class({}, nil, base_ability_attribute)
end
function item_sharp_dish:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_sharp_dish then
	modifier_item_sharp_dish = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_sharp_dish:IsHidden()
	return false
end
function modifier_item_sharp_dish:OnCreated(params)
	self:UpdateValues()
end
function modifier_item_sharp_dish:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_sharp_dish:UpdateValues()
	self.attack_bonus = self:GetAbilitySpecialValueFor('attack_bonus')
	self.attack_reduce = self:GetAbilitySpecialValueFor('attack_reduce')
	self.stack_count = self:GetAbilitySpecialValueFor('stack_count')
	self.bonus_attack = self:GetAbilitySpecialValueFor('bonus_attack')
	self.bonus_attack_reduce = self:GetAbilitySpecialValueFor('bonus_attack_reduce')
	
end

function modifier_item_sharp_dish:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK] = { self:GetParent() },
		EMDF_MAGICAL_ATTACK_BONUS,
		EMDF_EVENT_ON_BATTLEING_END
	}
end

function modifier_item_sharp_dish:OnAttack(params)
	if params.target == nil or params.target:GetClassname() == "dota_item_drop" then return end
	-- if params.target ~= self.
	
	if self:GetStackCount() > 0 then 
		local flDamage = self.attack_bonus + self.bonus_attack - (self.attack_reduce - self.bonus_attack_reduce) * (self.stack_count - self:GetStackCount())
		self:GetParent():SetVal(ATTRIBUTE_KIND.PhysicalAttack, flDamage , self)
		self:DecrementStackCount()
	end
	
	if self:GetStackCount() == 0 then 
		self:SetStackCount(self.stack_count)
	end

end


function modifier_item_sharp_dish:GetMagicalAttackBonus()
	return self.attack_bonus + self.bonus_attack - (self.attack_reduce - self.bonus_attack_reduce) * (self.stack_count - self:GetStackCount())
	
end

function modifier_item_sharp_dish:OnBattleEnd()
	self:SetStackCount(self.stack_count)
end

function modifier_item_sharp_dish:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_TOOLTIP2
	}
end

function modifier_item_sharp_dish:OnTooltip2()
	return self.attack_bonus + self.bonus_attack - (self.attack_reduce - self.bonus_attack_reduce) * (self.stack_count - self:GetStackCount())

end






AbilityClassHook('item_sharp_dish', getfenv(1), 'abilities/items/item_sharp_dish.lua', { KeyValues.ItemsKv })