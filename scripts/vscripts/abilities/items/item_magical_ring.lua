LinkLuaModifier("modifier_item_magical_ring", "abilities/items/item_magical_ring.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_magical_ring == nil then
	item_magical_ring = class({}, nil, base_ability_attribute)
end
function item_magical_ring:GetIntrinsicModifierName()
	return "modifier_item_magical_ring"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_magical_ring == nil then
	modifier_item_magical_ring = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_magical_ring:OnCreated(params)
	self.magical_attack = self:GetAbilitySpecialValueFor("magical_attack")
	self.crit_chance = self:GetAbilitySpecialValueFor("crit_chance")
	self.crit_damage_pct = self:GetAbilitySpecialValueFor("crit_damage_pct")
	if IsServer() then
	end
end
function modifier_item_magical_ring:OnRefresh(params)
	self.magical_attack = self:GetAbilitySpecialValueFor("magical_attack")
	self.crit_chance = self:GetAbilitySpecialValueFor("crit_chance")
	self.crit_damage_pct = self:GetAbilitySpecialValueFor("crit_damage_pct")
	if IsServer() then
	end
end
function modifier_item_magical_ring:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_magical_ring:GetMagicalAttackBonus()
	return self.magical_attack
end
function modifier_item_magical_ring:EDeclareFunctions()
	return {
		[EMDF_MAGICAL_ATTACK_BONUS] = self.magical_attack,
		EMDF_ATTACK_CRIT_BONUS
	}
end
function modifier_item_magical_ring:GetAttackCritBonus()
	return self.crit_damage_pct, self.crit_chance
end
AbilityClassHook('item_magical_ring', getfenv(1), 'abilities/items/item_magical_ring.lua', { KeyValues.ItemsKv })