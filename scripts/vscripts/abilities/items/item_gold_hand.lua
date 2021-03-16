LinkLuaModifier("modifier_item_gold_hand", "abilities/items/item_gold_hand.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--枫糖浆
if item_gold_hand == nil then
	item_gold_hand = class({})
end
function item_gold_hand:GetIntrinsicModifierName()
	return "modifier_item_gold_hand"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_gold_hand == nil then
	modifier_item_gold_hand = class({}, nil, eom_modifier)
end
function modifier_item_gold_hand:IsHidden()
	return self:GetStackCount() == 0
end
function modifier_item_gold_hand:OnCreated(params)
	self.gold_earn = self:GetAbilitySpecialValueFor("gold_earn")
	if IsServer() then
		self:SetStackCount(self:GetAbility():Load("iStackCount"))
	end
end
function modifier_item_gold_hand:OnRefresh(params)
	self.gold_earn = self:GetAbilitySpecialValueFor("gold_earn")
	if IsServer() then
	end
end
function modifier_item_gold_hand:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_gold_hand:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
		EMDF_ATTACKT_SPEED_BONUS
	}
end
function modifier_item_gold_hand:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_item_gold_hand:OnTooltip()
	return	self:GetStackCount()
end
function modifier_item_gold_hand:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end
	if not self:GetParent():IsIllusion() then
		local iPlayerID = self:GetParent():GetPlayerOwnerID()
		--攻击一次就增加一定数目金币
		PlayerData:ModifyGold(iPlayerID, self.gold_earn, true)
		self:IncrementStackCount(self.gold_earn)
		self:GetAbility():Save("iStackCount", self:GetStackCount())
	end
end