LinkLuaModifier("modifier_item_summon_wand", "abilities/items/item_summon_wand.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_summon_wand_buff", "abilities/items/item_summon_wand.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_summon_wand == nil then
	item_summon_wand = class({}, nil, base_ability_attribute)
end
function item_summon_wand:GetIntrinsicModifierName()
	return "modifier_item_summon_wand"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_summon_wand == nil then
	modifier_item_summon_wand = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_summon_wand:OnCreated(params)
	self.summon_atkspedbonus = self:GetAbilitySpecialValueFor("summon_atkspedbonus")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_item_summon_wand:OnRefresh(params)
	self.summon_atkspedbonus = self:GetAbilitySpecialValueFor("summon_atkspedbonus")
	if IsServer() then
	end
end
function modifier_item_summon_wand:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_summon_wand:OnIntervalThink()
	if IsServer() then
		local iPlayerID = GetPlayerID(self:GetParent())
		EachUnits(iPlayerID, function(hUnit)
			if CheckUnitType(iPlayerID, hUnit, UnitType.Summoner) and not hUnit:HasModifier("modifier_item_summon_wand_buff") then
				hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_summon_wand_buff", {})
			end
		end)
	end

end
function modifier_item_summon_wand:EDeclareFunctions()
	return {
	}
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_summon_wand_buff == nil then
	modifier_item_summon_wand_buff = class({}, nil, eom_modifier)
end
function modifier_item_summon_wand_buff:OnCreated(params)
	self.summon_atkspedbonus = self:GetAbilitySpecialValueFor("summon_atkspedbonus")
	if IsServer() then

	end
end
function modifier_item_summon_wand_buff:OnRefresh(params)
	self.summon_atkspedbonus = self:GetAbilitySpecialValueFor("summon_atkspedbonus")
	if IsServer() then
	end
end
function modifier_item_summon_wand_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_summon_wand_buff:EDeclareFunctions()
	return {
		EMDF_ATTACKT_SPEED_BONUS
	}
end
function modifier_item_summon_wand_buff:GetAttackSpeedBonus()
	return	self.summon_atkspedbonus
end
function modifier_item_summon_wand_buff:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_item_summon_wand_buff:OnTooltip()
	return self.summon_atkspedbonus
end
AbilityClassHook('item_summon_wand', getfenv(1), 'abilities/items/item_summon_wand.lua', { KeyValues.ItemsKv })