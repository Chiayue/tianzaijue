---冰刀
LinkLuaModifier("modifier_item_ice_sword_debuff", "abilities/items/item_ice_sword.lua", LUA_MODIFIER_MOTION_NONE)

if nil == item_ice_sword then
	item_ice_sword = class({}, nil, base_ability_attribute)
end
function item_ice_sword:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_ice_sword then
	modifier_item_ice_sword = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_ice_sword:IsHidden()
	return true
end
function modifier_item_ice_sword:IsDebuff()
	return false
end
function modifier_item_ice_sword:IsPurgable()
	return false
end
function modifier_item_ice_sword:IsPurgeException()
	return false
end
function modifier_item_ice_sword:AllowIllusionDuplicate()
	return false
end
function modifier_item_ice_sword:OnCreated(params)
	self:UpdateValues()
end
function modifier_item_ice_sword:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_ice_sword:UpdateValues(params)
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
end
function modifier_item_ice_sword:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
		EMDF_ATTACKT_PROJECTILE,
	}
end
function modifier_item_ice_sword:GetAttackProjectile()
	return "particles/items2_fx/skadi_projectile.vpcf"
end
function modifier_item_ice_sword:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if not tAttackInfo
	or self:GetParent() ~= tAttackInfo.attacker
	or IsAttackMiss(tAttackInfo)
	or not IsValid(hTarget)
	then return end

	local hAbility = self:GetAbility()
	local hParent = self:GetParent()
	if self.unlock_level <= hAbility:GetLevel() then
		hTarget:AddNewModifier(hParent, hAbility, "modifier_item_ice_sword_debuff", { duration = self.duration })
	end
end
------------------------------------------------------------
---隐身
if modifier_item_ice_sword_debuff == nil then
	modifier_item_ice_sword_debuff = class({}, nil, eom_modifier)
end
function modifier_item_ice_sword_debuff:IsHidden()
	return false
end
function modifier_item_ice_sword_debuff:IsDebuff()
	return true
end
function modifier_item_ice_sword_debuff:IsPurgable()
	return true
end
function modifier_item_ice_sword_debuff:IsPurgeException()
	return true
end
function modifier_item_ice_sword_debuff:AllowIllusionDuplicate()
	return false
end
function modifier_item_ice_sword_debuff:GetEffectName()
	return "particles/generic_gameplay/generic_slowed_cold.vpcf"
end
function modifier_item_ice_sword_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_item_ice_sword_debuff:OnCreated(params)
	self.move_speed_punish_pct = self:GetAbilitySpecialValueFor('move_speed_punish_pct')
	self.attack_speed_punish_pct = self:GetAbilitySpecialValueFor('attack_speed_punish_pct')
end
function modifier_item_ice_sword_debuff:EDeclareFunctions()
	return {
		[EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE] = -self.move_speed_punish_pct,
		[EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE] = -self.attack_speed_punish_pct,
	}
end
AbilityClassHook('item_ice_sword', getfenv(1), 'abilities/items/item_ice_sword.lua', { KeyValues.ItemsKv })