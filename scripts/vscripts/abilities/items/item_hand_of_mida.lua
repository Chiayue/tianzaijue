---点金手
---
if nil == item_hand_of_mida then
	item_hand_of_mida = class({}, nil, base_ability_attribute)
end
function item_hand_of_mida:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_hand_of_mida then
	modifier_item_hand_of_mida = class({}, nil, modifier_base_ability_attribute)
end

function modifier_item_hand_of_mida:IsHidden()
	return true
end
function modifier_item_hand_of_mida:OnCreated(params)
	self:UpdateValues()
end

function modifier_item_hand_of_mida:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_hand_of_mida:UpdateValues(params)
	self.crystal_bonus = self:GetAbilitySpecialValueFor("crystal_bonus")
	self.chance = self:GetAbilitySpecialValueFor('chance')
	self.gold_bonus = self:GetAbilitySpecialValueFor("gold_bonus")
	self.creep_damage_bonus = self:GetAbilitySpecialValueFor("creep_damage_bonus")
end


function modifier_item_hand_of_mida:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_DEATH] = { self:GetParent() },
		-- EMDF_EVENT_ON_PREPARATION,
		EMDF_OUTGOING_PERCENTAGE
	}
end
function modifier_item_hand_of_mida:GetOutgoingPercentage(params)
	if params.attacker ~= self:GetParent() then return end
	if params.target:IsCreep() then
		return self.creep_damage_bonus
	end
	return
end


function modifier_item_hand_of_mida:OnDeath(params)
	if params.attacker == self:GetParent() then
		if RollPercentage(self.chance) then
			PlayerData:ModifyCrystal(GetPlayerID(self:GetParent()), self.crystal_bonus)
			PlayerData:ModifyGold(GetPlayerID(self:GetParent()), self.gold_bonus)
		end
	end
end
-- function modifier_item_hand_of_mida:OnPreparation(params)
-- 	if self:GetParent().GetBuilding then
-- 		local hBuilding = self:GetParent():GetBuilding()
-- 		if hBuilding:GetUnitEntity() == self:GetParent() then
-- 			PlayerData:ModifyGold(self:GetPlayerID(), self.gold_bonus)
-- 		end
-- 	end
-- end
AbilityClassHook('item_hand_of_mida', getfenv(1), 'abilities/items/item_hand_of_mida.lua', { KeyValues.ItemsKv })