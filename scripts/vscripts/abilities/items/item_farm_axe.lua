LinkLuaModifier("modifier_item_farm_axe", "abilities/items/item_farm_axe.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_farm_axe == nil then
	item_farm_axe = class({}, nil, base_ability_attribute)
end
function item_farm_axe:GetIntrinsicModifierName()
	return "modifier_item_farm_axe"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_farm_axe == nil then
	modifier_item_farm_axe = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_farm_axe:OnCreated(params)
	self.extra_damage = self:GetAbilitySpecialValueFor("extra_damage")
	if IsServer() then
	end
end
function modifier_item_farm_axe:IsHidden()
	return true
end
function modifier_item_farm_axe:OnRefresh(params)
	self.extra_damage = self:GetAbilitySpecialValueFor("extra_damage")
	if IsServer() then
	end
end
function modifier_item_farm_axe:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_farm_axe:EDeclareFunctions()
	return {
		EMDF_OUTGOING_PERCENTAGE
	}
end
function modifier_item_farm_axe:GetOutgoingPercentage(params)
	if params.attacker ~= self:GetParent() then return end
	if params.target:IsCreep() then
		return self.extra_damage
	end
end