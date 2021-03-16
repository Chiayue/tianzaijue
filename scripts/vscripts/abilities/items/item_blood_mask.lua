LinkLuaModifier( "modifier_item_blood_mask", "abilities/items/item_blood_mask.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if item_blood_mask == nil then
	item_blood_mask = class({},nil,base_ability_attribute)
end
function item_blood_mask:GetIntrinsicModifierName()
	return "modifier_item_blood_mask"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_blood_mask == nil then
	modifier_item_blood_mask = class({},nil,modifier_base_ability_attribute)
end
function modifier_item_blood_mask:UpdateValues()
	self.health_regen_per = self:GetAbilitySpecialValueFor('health_regen_per')
end
function modifier_item_blood_mask:OnCreated(params)
	self:UpdateValues()
	if IsServer() then
	end
end
function modifier_item_blood_mask:OnRefresh(params)
	self:UpdateValues()
	if IsServer() then
	end
end
function modifier_item_blood_mask:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_blood_mask:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK_LANDED] = { self:GetParent() }
	}
end
function modifier_item_blood_mask:OnAttackLanded(params)
	if params.attacker ~= self:GetParent() then return end
	params.attacker:Heal(self.health_regen_per, self)
end

AbilityClassHook('item_blood_mask', getfenv(1), 'abilities/items/item_blood_mask.lua', { KeyValues.ItemsKv })