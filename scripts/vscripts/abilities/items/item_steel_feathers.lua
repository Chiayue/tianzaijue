LinkLuaModifier("modifier_item_steel_feathers_buff", "abilities/items/item_steel_feathers.lua", LUA_MODIFIER_MOTION_NONE)

---钢铁之羽
if nil == item_steel_feathers then
	item_steel_feathers = class({}, nil, base_ability_attribute)
end
function item_steel_feathers:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_steel_feathers then
	modifier_item_steel_feathers = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_steel_feathers:IsHidden()
	return self:GetStackCount() > self.stack_count or self:GetStackCount() == 0
end
function modifier_item_steel_feathers:OnCreated(params)
	self:UpdateValues()
end
function modifier_item_steel_feathers:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_steel_feathers:UpdateValues()
	self.stack_count = self:GetAbilitySpecialValueFor('stack_count')
	self.damage_bonus_pct = self:GetAbilitySpecialValueFor('damage_bonus_pct')
	self.fear_time = self:GetAbilitySpecialValueFor('fear_time')
	self.speed_bonus_pct = self:GetAbilitySpecialValueFor('speed_bonus_pct')
	self.duration = self:GetAbilitySpecialValueFor('duration')
	self.unlock_level = self:GetAbilitySpecialValueFor('unlock_level')
end

function modifier_item_steel_feathers:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK] = {nil, self:GetParent() },
		EMDF_PHYSICAL_OUTGOING_PERCENTAGE,
		EMDF_EVENT_ON_BATTLEING_END

	}
end

function modifier_item_steel_feathers:OnAttack(params)
	self:IncrementStackCount()
	if self:GetStackCount() > self.stack_count then
		if self.unlock_level <= self:GetAbility():GetLevel() then
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), 'modifier_item_steel_feathers_buff', { duration = self.duration })
			self:SetStackCount(0)
		end
	end
end
function modifier_item_steel_feathers:OnBattleEnd(params)
	self:SetStackCount(0)
end



if modifier_item_steel_feathers_buff == nil then
	modifier_item_steel_feathers_buff = class({}, nil, eom_modifier)
end

function modifier_item_steel_feathers_buff:IsHidden()
	return false
end

function modifier_item_steel_feathers_buff:OnRefresh(params)
	self:UpdateValues()
end

function modifier_item_steel_feathers_buff:OnCreated(params)
	self:UpdateValues()
	if IsClient() then
		LocalPlayerAbilityParticle(self:GetAbility(), function()
			local iPtclID = ParticleManager:CreateParticle('particles/items/item_steel_feathers/item_steel_feathers.vpcf', PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
			self:AddParticle(iPtclID, false, false, -1, false, false)
			ParticleManager:SetParticleControl(iPtclID, 1, self:GetParent():GetAbsOrigin())
			return iPtclID
		end, PARTICLE_DETAIL_LEVEL_MEDIUM)

	end
end

function modifier_item_steel_feathers_buff:UpdateValues()
	self.stack_count = self:GetAbilitySpecialValueFor('stack_count')
	self.damage_bonus_pct = self:GetAbilitySpecialValueFor('damage_bonus_pct')
	self.fear_time = self:GetAbilitySpecialValueFor('fear_time')
	self.speed_bonus_pct = self:GetAbilitySpecialValueFor('speed_bonus_pct')
	self.duration = self:GetAbilitySpecialValueFor('duration')

end


function modifier_item_steel_feathers_buff:EDeclareFunctions()
	return {
		[EMDF_PHYSICAL_OUTGOING_PERCENTAGE] = self.damage_bonus_pct,
		[MODIFIER_EVENT_ON_ATTACK] = { self:GetParent() },
		[EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE] = self.speed_bonus_pct
	}
end
function modifier_item_steel_feathers_buff:OnAttack(params)
	params.target:AddBuff(self:GetParent(), BUFF_TYPE.FEAR, self.fear_time)
end





AbilityClassHook('item_steel_feathers', getfenv(1), 'abilities/items/item_steel_feathers.lua', { KeyValues.ItemsKv })