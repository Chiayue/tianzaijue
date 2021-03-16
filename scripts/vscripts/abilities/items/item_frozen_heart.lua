---冰霜之心
LinkLuaModifier("modifier_angel_relics_physical_immune", "abilities/items/item_frozen_heart.lua", LUA_MODIFIER_MOTION_NONE)


if nil == item_frozen_heart then
	item_frozen_heart = class({}, nil, base_ability_attribute)
end
function item_frozen_heart:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_frozen_heart then
	modifier_item_frozen_heart = class({}, nil, modifier_base_ability_attribute)
end

function modifier_item_frozen_heart:IsHidden()
	return false
end
function modifier_item_frozen_heart:OnCreated(params)
	self:UpdateValues()
end

function modifier_item_frozen_heart:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_frozen_heart:UpdateValues(params)
	self.magical_armor = self:GetAbilitySpecialValueFor("magical_armor")
	self.physical_armor = self:GetAbilitySpecialValueFor('physical_armor')
	self.chance = self:GetAbilitySpecialValueFor('chance')
	self.duration_time = self:GetAbilitySpecialValueFor('duration_time')
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")

end
function modifier_item_frozen_heart:EDeclareFunctions()
	return {
		[EMDF_PHYSICAL_ARMOR_BONUS] = self.physical_armor,
		[EMDF_MAGICAL_ARMOR_BONUS] = self.magical_armor,
		---别人打我
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() },
	}
end

function modifier_item_frozen_heart:GetPhysicalArmorBonus(params)
	return self.physical_armor
end
function modifier_item_frozen_heart:GetMagicalArmorBonus(params)
	return self.magical_armor
end

function modifier_item_frozen_heart:OnTakeDamage(params)
	if params.attacker == self:GetParent() then return end
	if not IsValid(self:GetParent()) then return end
	if params.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() then return end
	local hParent = self:GetParent()

	if self.unlock_level > self:GetAbility():GetLevel() then
		return
	end

	if RollPercentage(self.chance) then
		params.attacker:AddBuff(hParent, BUFF_TYPE.FROZEN, self.duration_time)
	end
end


AbilityClassHook('item_frozen_heart', getfenv(1), 'abilities/items/item_frozen_heart.lua', { KeyValues.ItemsKv })