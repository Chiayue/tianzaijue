---吸血獠牙
if nil == item_vampire_fang then
	item_vampire_fang = class({}, nil, base_ability_attribute)
end
function item_vampire_fang:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_vampire_fang then
	modifier_item_vampire_fang = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_vampire_fang:OnCreated(params)
	self:UpdateValues()
end

function modifier_item_vampire_fang:IsHidden()
	self:UpdateValues()
	return true
end
function modifier_item_vampire_fang:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_vampire_fang:UpdateValues()
	self.round_bonus = self:GetAbilitySpecialValueFor('round_bonus')
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
end
-- function modifier_item_vampire_fang:EDeclareFunctions()
-- 	return {
-- 		[MODIFIER_EVENT_ON_DEATH] = { self:GetParent(), nil },
-- 	}
-- end
-- function modifier_item_vampire_fang:OnDeath(params)
-- 	if params.attacker ~= self:GetParent() then return end
-- 	local hAttacker = params.attacker
-- 	if not IsValid(hAttacker) then return end
-- 	if hAttacker:GetTeamNumber() == params.unit:GetTeamNumber() then return end
-- 	if self.unlock_level <= self:GetAbility():GetLevel() then
-- 		params.attacker:Heal(self.round_bonus * Spawner:GetRound(), params.attacker)
-- 	end
-- end
AbilityClassHook('item_vampire_fang', getfenv(1), 'abilities/items/item_vampire_fang.lua', { KeyValues.ItemsKv })