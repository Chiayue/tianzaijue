LinkLuaModifier("modifier_item_evasion_talisman", "abilities/items/item_evasion_talisman.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_evasion_talisman == nil then
	item_evasion_talisman = class({})
end
function item_evasion_talisman:GetIntrinsicModifierName()
	return "modifier_item_evasion_talisman"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_evasion_talisman == nil then
	modifier_item_evasion_talisman = class({}, nil, eom_modifier)
end
function modifier_item_evasion_talisman:OnCreated(params)
	self.evasion_pct = self:GetAbilitySpecialValueFor("evasion_pct")
	if IsServer() then
	end
end
function modifier_item_evasion_talisman:OnRefresh(params)
	self.evasion_pct = self:GetAbilitySpecialValueFor("evasion_pct")
	if IsServer() then
	end
end
function modifier_item_evasion_talisman:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_evasion_talisman:IsHidden()
	return true
end
function modifier_item_evasion_talisman:EDeclareFunctions()
	return {
		EMDF_ATTACK_MISS_BONUS
	}
end
function modifier_item_evasion_talisman:GetAttackMissBonus()
	return 100, self.evasion_pct
end