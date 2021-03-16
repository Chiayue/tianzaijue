LinkLuaModifier("modifier_item_evasion_box", "abilities/items/item_evasion_box.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_evasion_box == nil then
	item_evasion_box = class({})
end
function item_evasion_box:GetIntrinsicModifierName()
	return "modifier_item_evasion_box"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_evasion_box == nil then
	modifier_item_evasion_box = class({}, nil, eom_modifier)
end
function modifier_item_evasion_box:OnCreated(params)
	self.evasion_pct = self:GetAbilitySpecialValueFor("evasion_pct")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	if IsServer() then
	end
end
function modifier_item_evasion_box:OnRefresh(params)
	self.evasion_pct = self:GetAbilitySpecialValueFor("evasion_pct")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	if IsServer() then
	end
end
function modifier_item_evasion_box:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_evasion_box:IsHidden()
	return true
end
function modifier_item_evasion_box:EDeclareFunctions()
	return {
		EMDF_ATTACK_MISS_BONUS
	}
end
function modifier_item_evasion_box:GetAttackMissBonus()
	return self.chance, self.evasion_pct
end