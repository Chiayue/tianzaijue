LinkLuaModifier( "modifier_item_hero_sword", "abilities/items/item_hero_sword.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if item_hero_sword == nil then
	item_hero_sword = class({},nil,base_ability_attribute)
end
function item_hero_sword:GetIntrinsicModifierName()
	return "modifier_item_hero_sword"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_hero_sword == nil then
	modifier_item_hero_sword = class({},nil,modifier_base_ability_attribute)
end
function modifier_item_hero_sword:UpdateValues(params)
	self.elit_damage_bonus = self:GetAbilitySpecialValueFor("elit_damage_bonus")
end
function modifier_item_hero_sword:OnCreated(params)
	self:UpdateValues()
	if IsServer() then
	end
end
function modifier_item_hero_sword:OnRefresh(params)
	self:UpdateValues()
	if IsServer() then
	end
end
function modifier_item_hero_sword:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_hero_sword:EDeclareFunctions()
	return {
		EMDF_OUTGOING_PERCENTAGE
	}
end
function modifier_item_hero_sword:GetOutgoingPercentage(params)
	if params.attacker ~= self:GetParent() then return end
	if params.target:IsCreep() then	
		return 
	end
	return self.elit_damage_bonus
end
AbilityClassHook('item_hero_sword', getfenv(1), 'abilities/items/item_hero_sword.lua', { KeyValues.ItemsKv })