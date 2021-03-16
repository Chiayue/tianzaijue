LinkLuaModifier("modifier_item_ignorance_hat", "abilities/items/item_ignorance_hat.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_ignorance_hat == nil then
	item_ignorance_hat = class({}, nil, base_ability_attribute)
end
function item_ignorance_hat:GetIntrinsicModifierName()
	return "modifier_item_ignorance_hat"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_ignorance_hat == nil then
	modifier_item_ignorance_hat = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_ignorance_hat:OnCreated(params)
	self.health_regen_everytimes = self:GetAbilitySpecialValueFor("health_regen_everytimes")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then
	end
end
function modifier_item_ignorance_hat:OnRefresh(params)
	self.health_regen_everytimes = self:GetAbilitySpecialValueFor("health_regen_everytimes")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then
	end
end
function modifier_item_ignorance_hat:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_ignorance_hat:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
		EMDF_HEALTH_REGEN_BONUS,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_item_ignorance_hat:GetHealthRegenBonus()
	return self:GetStackCount() * self.health_regen_everytimes
end
function modifier_item_ignorance_hat:OnBattleEnd()
	self:SetStackCount(0)
end

function modifier_item_ignorance_hat:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if hTarget ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end
	if self.unlock_level > self:GetAbility():GetLevel() then return end
	-- 被打增加次数
	if not self:GetParent():IsIllusion() and IsServer() then
		self:IncrementStackCount()
	end
end

AbilityClassHook('item_ignorance_hat', getfenv(1), 'abilities/items/item_ignorance_hat.lua', { KeyValues.ItemsKv })