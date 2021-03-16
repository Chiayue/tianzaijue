LinkLuaModifier("modifier_item_daedalus", "abilities/items/item_daedalus.lua", LUA_MODIFIER_MOTION_NONE)
if nil == item_daedalus then
	item_daedalus = class({}, nil, base_ability_attribute)
end
function item_daedalus:GetIntrinsicModifierName()
	return "modifier_item_daedalus"
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_daedalus then
	modifier_item_daedalus = class({}, nil, modifier_base_ability_attribute)
end

function modifier_item_daedalus:IsHidden()
	return false
end
function modifier_item_daedalus:OnCreated(params)
	self:UpdateValues()
end

function modifier_item_daedalus:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_daedalus:UpdateValues(params)
	self.crit_chance = self:GetAbilitySpecialValueFor("crit_chance")
	self.crit_damage_pct = self:GetAbilitySpecialValueFor('crit_damage_pct')
end

function modifier_item_daedalus:EDeclareFunctions()
	return {
		EMDF_ATTACK_CRIT_BONUS,
		EMDF_EVENT_ON_ATTACK_HIT,
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = { self:GetParent() }
	}
end
function modifier_item_daedalus:GetAttackCritBonus()
	return self.crit_damage_pct, self.crit_chance
end
function modifier_item_daedalus:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_item_daedalus:OnTooltip()
	local hParent = self:GetParent()
	self._iTooltip = ((self._iTooltip or -1) + 1) % 2
	if 0 == self._iTooltip then
		return self.crit_chance
	elseif 1 == self._iTooltip then
		return self.crit_damage_pct
	end
end