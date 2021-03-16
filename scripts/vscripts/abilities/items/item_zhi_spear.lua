LinkLuaModifier("modifier_item_zhi_spear", "abilities/items/item_zhi_spear.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--制式长矛
if item_zhi_spear == nil then
	item_zhi_spear = class({}, nil, base_ability_attribute)
end
function item_zhi_spear:GetIntrinsicModifierName()
	return "modifier_item_zhi_spear"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_zhi_spear == nil then
	modifier_item_zhi_spear = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_zhi_spear:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.physical_extra = self:GetAbilitySpecialValueFor("physical_extra")
	if IsServer() then
	end
end
function modifier_item_zhi_spear:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.physical_extra = self:GetAbilitySpecialValueFor("physical_extra")
	if IsServer() then
	end
end
function modifier_item_zhi_spear:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_zhi_spear:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT
	}
end
---@param tAttackInfo AttackInfo
function modifier_item_zhi_spear:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent()
	or not IsValid(hTarget)
	or IsAttackMiss(tAttackInfo)
	or self:GetParent():PassivesDisabled()
	then return end


	-- 有几率造成额外伤害
	for iDamageType, tDamageInfo in pairs(tAttackInfo.tDamageInfo) do
		-- 如果是近战
		if iDamageType == DAMAGE_TYPE_PHYSICAL and not tAttackInfo.attacker:IsRangedAttacker() then
			if RollPercentage(self.chance) then
				tDamageInfo.damage = tDamageInfo.damage + self.physical_extra
			end
		end
	end
end
AbilityClassHook('item_zhi_spear', getfenv(1), 'abilities/items/item_zhi_spear.lua', { KeyValues.ItemsKv })