LinkLuaModifier("modifier_talent_general_desire_to_fight", "abilities/talent_general/talent_general_desire_to_fight.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_talent_general_desire_to_fight_buff", "abilities/talent_general/talent_general_desire_to_fight.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if talent_general_desire_to_fight == nil then
	talent_general_desire_to_fight = class({})
end
function talent_general_desire_to_fight:OnSpellStart()
	local iPlayerID = GetPlayerID(self:GetCaster())
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, nil, 'modifier_talent_general_desire_to_fight', nil)
end

---------------------------------------------------------------------
--Modifiers
if modifier_talent_general_desire_to_fight == nil then
	modifier_talent_general_desire_to_fight = class({}, nil, eom_modifier_aura)
end
function modifier_talent_general_desire_to_fight:GetAuraUnitType() return UnitType.Building + UnitType.Commander end
function modifier_talent_general_desire_to_fight:GetModifierAura()
	return 'modifier_talent_general_desire_to_fight_buff'
end

-- 单位身上的BUFF
if modifier_talent_general_desire_to_fight_buff == nil then
	modifier_talent_general_desire_to_fight_buff = class({}, nil, eom_modifier)
end
function modifier_talent_general_desire_to_fight_buff:GetTexture()
	return GetAbilityTexture('talent_general_desire_to_fight')
end
function modifier_talent_general_desire_to_fight_buff:IsHidden()
	return 0 == self:GetStackCount()
end
function modifier_talent_general_desire_to_fight_buff:OnCreated(params)
	local iLevel = GetPlayerTalentLevel(GetPlayerID(self:GetParent()), 'talent_general_desire_to_fight')
	self.attack_bonus_pct = self:GetKVSpecialValueFor('talent_general_desire_to_fight', 'attack_bonus_pct', iLevel)
	self.max_stack = self:GetKVSpecialValueFor('talent_general_desire_to_fight', 'max_stack', iLevel)
end
function modifier_talent_general_desire_to_fight_buff:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_DEATH, 'OnEventBuildingDeath' }
	}
end
function modifier_talent_general_desire_to_fight_buff:OnEventBuildingDeath(tEventData)
	if GetPlayerID(tEventData.hUnit) ~= self:GetPlayerID() then return end
	if self:GetStackCount() < self.max_stack then
		self:IncrementStackCount()
	end
end
function modifier_talent_general_desire_to_fight_buff:GetMagicalAttackBonusPercentage()
	return self.attack_bonus_pct * self:GetStackCount()
end
function modifier_talent_general_desire_to_fight_buff:GetPhysicalAttackBonusPercentage()
	return self.attack_bonus_pct * self:GetStackCount()
end
function modifier_talent_general_desire_to_fight_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_talent_general_desire_to_fight_buff:OnTooltip()
	return self.attack_bonus_pct * self:GetStackCount()
end