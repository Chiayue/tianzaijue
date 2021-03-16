LinkLuaModifier("modifier_item_zhi_staff", "abilities/items/item_zhi_staff.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--制式长矛
if item_zhi_staff == nil then
	item_zhi_staff = class({}, nil, base_ability_attribute)
end
function item_zhi_staff:GetIntrinsicModifierName()
	return "modifier_item_zhi_staff"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_zhi_staff == nil then
	modifier_item_zhi_staff = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_zhi_staff:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.magical_extra = self:GetAbilitySpecialValueFor("magical_extra")
	if IsServer() then
	end
end
function modifier_item_zhi_staff:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.magical_extra = self:GetAbilitySpecialValueFor("magical_extra")
	if IsServer() then
	end
end
function modifier_item_zhi_staff:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_zhi_staff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT
	}
end
---@param tAttackInfo AttackInfo
function modifier_item_zhi_staff:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent()
	or not IsValid(hTarget)
	or IsAttackMiss(tAttackInfo)
	or self:GetParent():PassivesDisabled()
	then return end

	-- 有几率造成额外伤害
	for iDamageType, tDamageInfo in pairs(tAttackInfo.tDamageInfo) do
		-- 如果是近战
		if RollPercentage(self.chance) and iDamageType == DAMAGE_TYPE_MAGICAL then
			tDamageInfo.damage = tDamageInfo.damage + self.magical_extra
		end
	end
end
AbilityClassHook('item_zhi_staff', getfenv(1), 'abilities/items/item_zhi_staff.lua', { KeyValues.ItemsKv })