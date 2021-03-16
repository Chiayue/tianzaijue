---玲珑心
if nil == item_mask_of_fear then
	item_mask_of_fear = class({}, nil, base_ability_attribute)
end
function item_mask_of_fear:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_mask_of_fear then
	modifier_item_mask_of_fear = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_mask_of_fear:OnCreated(params)
	self:UpdateValues()
end
function modifier_item_mask_of_fear:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_mask_of_fear:UpdateValues()
	self.chance = self:GetAbilitySpecialValueFor('chance')
	self.time_of_fear = self:GetAbilitySpecialValueFor('time_of_fear')
	self.health_sign_pct = self:GetAbilitySpecialValueFor('health_sign_pct')
	self.attack_speed_pct_bonus = self:GetAbilitySpecialValueFor('attack_speed_pct_bonus')
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
end
function modifier_item_mask_of_fear:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() },
		[EMDF_ATTACKT_SPEED_BONUS] = self.attack_speed_pct_bonus,
	}
end

function modifier_item_mask_of_fear:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end
	if self:GetAbility():GetLevel() < self.unlock_level then return end
	local arc_damage_percent_add = 0

	local chance = self.chance
	local hCaster = self:GetParent()
	if not Spawner:IsBossRound() and not Spawner:IsGoldRound() then
		if RollPercentage(chance) then
			hTarget:AddBuff(hCaster, BUFF_TYPE.FEAR, self.time_of_fear)
		end
	end
end

-- function modifier_item_mask_of_fear:OnTakeDamage(params)
-- 	local iStack = 0
-- 	if self.unlock_level <= self:GetAbility():GetLevel() then
-- 		if self:GetParent():GetHealthPercent() < self.health_sign_pct then
-- 			iStack = 1
-- 		end
-- 	end
-- 	if self:GetStackCount() ~= iStack then
-- 		self:SetStackCount(iStack)
-- 	end
-- end
AbilityClassHook('item_mask_of_fear', getfenv(1), 'abilities/items/item_mask_of_fear.lua', { KeyValues.ItemsKv })