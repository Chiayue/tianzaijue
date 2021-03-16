LinkLuaModifier("modifier_item_goldess_hand", "abilities/items/item_goldess_hand.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--
if item_goldess_hand == nil then
	item_goldess_hand = class({}, nil, base_ability_attribute)
end
function item_goldess_hand:GetIntrinsicModifierName()
	return "modifier_item_goldess_hand"
end

---------------------------------------------------------------------
--Modifiers
if modifier_item_goldess_hand == nil then
	modifier_item_goldess_hand = class({}, nil, modifier_base_ability_attribute)
end
-- function modifier_item_goldess_hand:GetTexture()
-- 	return "item_hand_of_midas"
-- 	return "hand_of_midas_ogre_arcana"
-- end
function modifier_item_goldess_hand:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.gold_bonus = self:GetAbilitySpecialValueFor("gold_bonus")
	if IsServer() then
		self:SetStackCount(self:GetAbility():Load("iStackCount"))
	end
end
function modifier_item_goldess_hand:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.gold_bonus = self:GetAbilitySpecialValueFor("gold_bonus")
	if IsServer() then
	end
end
function modifier_item_goldess_hand:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_goldess_hand:IsHidden()
	return false
end
function modifier_item_goldess_hand:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
	}
end
function modifier_item_goldess_hand:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_item_goldess_hand:OnTooltip()
	return self:GetStackCount()
end
function modifier_item_goldess_hand:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end
	if RollPercentage(self.chance) and not self:GetParent():IsIllusion() and self:GetAbility():IsCooldownReady() then
		self:GetAbility():UseResources(false, false, true)
		local iPlayerID = GetPlayerID(self:GetParent())
		--攻击一次就增加一定数目金币
		PlayerData:ModifyGold(iPlayerID, self.gold_bonus, true)

		self:IncrementStackCount(self.gold_bonus)
		self:GetAbility():Save("iStackCount", self:GetStackCount())

	end
end


AbilityClassHook('item_goldess_hand', getfenv(1), 'abilities/items/item_goldess_hand.lua', { KeyValues.ItemsKv })