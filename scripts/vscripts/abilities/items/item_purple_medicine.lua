LinkLuaModifier("modifier_item_purple_medicine", "abilities/items/item_purple_medicine.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_purple_medicine == nil then
	item_purple_medicine = class({})
end
function item_purple_medicine:GetIntrinsicModifierName()
	return "modifier_item_purple_medicine"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_purple_medicine == nil then
	modifier_item_purple_medicine = class({}, nil, eom_modifier)
end
function modifier_item_purple_medicine:OnCreated(params)
	self.attack_speed_bonus = self:GetAbilitySpecialValueFor("attack_speed_bonus")
	if IsServer() then
	end
end
function modifier_item_purple_medicine:OnRefresh(params)
	self.attack_speed_bonus = self:GetAbilitySpecialValueFor("attack_speed_bonus")
	if IsServer() then
	end
end
function modifier_item_purple_medicine:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_purple_medicine:IsHidden()
	return self:GetStackCount() == 0
end
function modifier_item_purple_medicine:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
		EMDF_ATTACKT_SPEED_BONUS,
		EMDF_EVENT_ON_BATTLEING_END
	}
end

function modifier_item_purple_medicine:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end
	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_item_purple_medicine:GetAttackSpeedBonus()
	return self.attack_speed_bonus * self:GetStackCount()
end

function modifier_item_purple_medicine:OnBattleEnd()
	self:SetStackCount(0)
end
function modifier_item_purple_medicine:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_item_purple_medicine:OnTooltip()
	return self.attack_speed_bonus * self:GetStackCount()
end