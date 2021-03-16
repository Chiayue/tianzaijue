LinkLuaModifier( "modifier_item_hero_staff", "abilities/items/item_hero_staff.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if item_hero_staff == nil then
	item_hero_staff = class({},nil,base_ability_attribute)
end
function item_hero_staff:GetIntrinsicModifierName()
	return "modifier_item_hero_staff"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_hero_staff == nil then
	modifier_item_hero_staff = class({},nil,modifier_base_ability_attribute)
end
function modifier_item_hero_staff:UpdateValues(params)
	self.elit_damage_bonus = self:GetAbilitySpecialValueFor("elit_damage_bonus")
end
function modifier_item_hero_staff:OnCreated(params)
	self:UpdateValues()
	if IsServer() then
	end
end
function modifier_item_hero_staff:OnRefresh(params)
	self:UpdateValues()
	if IsServer() then
	end
end
function modifier_item_hero_staff:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_hero_staff:EDeclareFunctions()
	return {
		EMDF_OUTGOING_PERCENTAGE
	}
end
function modifier_item_hero_staff:GetOutgoingPercentage(params)
	if params.attacker ~= self:GetParent() then return end
	if params.target:IsCreep() then	
		return 
	end
	return self.elit_damage_bonus
end
AbilityClassHook('item_hero_staff', getfenv(1), 'abilities/items/item_hero_staff.lua', { KeyValues.ItemsKv })