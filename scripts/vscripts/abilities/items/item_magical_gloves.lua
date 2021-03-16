LinkLuaModifier("modifier_item_magical_gloves", "abilities/items/item_magical_gloves.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_magical_gloves == nil then
	item_magical_gloves = class({}, nil, base_ability_attribute)
end
function item_magical_gloves:GetIntrinsicModifierName()
	return "modifier_item_magical_gloves"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_magical_gloves == nil then
	modifier_item_magical_gloves = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_magical_gloves:OnCreated(params)
	self.magical_attack_pct = self:GetAbilitySpecialValueFor("magical_attack_pct")
	if IsServer() then
	end
end
function modifier_item_magical_gloves:OnRefresh(params)
	self.magical_attack_pct = self:GetAbilitySpecialValueFor("magical_attack_pct")
	if IsServer() then
	end
end
function modifier_item_magical_gloves:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_magical_gloves:EDeclareFunctions()
	return {
		[EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE] = self.magical_attack_pct,
	}
end

AbilityClassHook('item_magical_gloves', getfenv(1), 'abilities/items/item_magical_gloves.lua', { KeyValues.ItemsKv })