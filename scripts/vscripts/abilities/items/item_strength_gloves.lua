LinkLuaModifier("modifier_item_strength_gloves", "abilities/items/item_strength_gloves.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_strength_gloves == nil then
	item_strength_gloves = class({})
end
function item_strength_gloves:GetIntrinsicModifierName()
	return "modifier_item_strength_gloves"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_strength_gloves == nil then
	modifier_item_strength_gloves = class({}, nil, eom_modifier)
end
function modifier_item_strength_gloves:OnCreated(params)
	self.physical_attack_pct = self:GetAbilitySpecialValueFor("physical_attack_pct")
	if IsServer() then
	end
end
function modifier_item_strength_gloves:IsHidden()
	return true
end
function modifier_item_strength_gloves:OnRefresh(params)
	self.physical_attack_pct = self:GetAbilitySpecialValueFor("physical_attack_pct")
	if IsServer() then
	end
end
function modifier_item_strength_gloves:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_strength_gloves:EDeclareFunctions()
	return {
		[EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE] = self.physical_attack_pct
	}
end