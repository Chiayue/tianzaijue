LinkLuaModifier("modifier_talent_general_gold_command_buff", "abilities/talent_general/talent_general_gold_command.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if talent_general_gold_command == nil then
	talent_general_gold_command = class({})
end
function talent_general_gold_command:OnSpellStart()
	local iPlayerID = GetPlayerID(self:GetCaster())
	local hCaster = self:GetCaster()

	local hCmd = Commander:GetCommander(iPlayerID)
	if IsValid(hCmd) then
		hCmd:RemoveModifierByName('modifier_talent_general_gold_command_buff')
		hCmd:AddNewModifier(hCaster, self, 'modifier_talent_general_gold_command_buff', nil)
	end

	---@param tData EventData_ON_COMMANDER_SPAWNED
	EventManager:register(ET_PLAYER.ON_COMMANDER_SPAWNED, function(tData)
		if iPlayerID ~= tData.PlayerID then return end
		tData.hCommander:AddNewModifier(hCaster, self, 'modifier_talent_general_gold_command_buff', nil)
	end, nil, nil, self:GetAbilityName() .. iPlayerID)
end

---------------------------------------------------------------------
--Modifiers
if modifier_talent_general_gold_command_buff == nil then
	modifier_talent_general_gold_command_buff = class({}, nil, eom_modifier)
end
function modifier_talent_general_gold_command_buff:GetTexture()
	return "lone_druid_spirit_bear_demolish"
end
function modifier_talent_general_gold_command_buff:RemoveOnDeath()
	return false
end
function modifier_talent_general_gold_command_buff:OnCreated(params)
	local iLevel = GetPlayerTalentLevel(self:GetPlayerID(), 'talent_general_gold_command')
	self.attribute_bonus_pct = self:GetKVSpecialValueFor('talent_general_gold_command', 'attribute_bonus_pct', 1) * iLevel
end
function modifier_talent_general_gold_command_buff:OnRefresh(params)
	local iLevel = GetPlayerTalentLevel(self:GetPlayerID(), 'talent_general_gold_command')
	self.attribute_bonus_pct = self:GetKVSpecialValueFor('talent_general_gold_command', 'attribute_bonus_pct', 1) * iLevel
end
function modifier_talent_general_gold_command_buff:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_PHYSICAL_ARMOR_BONUS_PERCENTAGE,
		EMDF_MAGICAL_ARMOR_BONUS_PERCENTAGE,
		EMDF_STATUS_HEALTH_BONUS_PERCENTAGE,
		EMDF_STATUS_MANA_BONUS_PERCENTAGE,
		EMDF_MANA_REGEN_PERCENTAGE,
	}
end
function modifier_talent_general_gold_command_buff:GetPhysicalAttackBonusPercentage()
	return self.attribute_bonus_pct
end
function modifier_talent_general_gold_command_buff:GetMagicalAttackBonusPercentage()
	return self.attribute_bonus_pct
end
function modifier_talent_general_gold_command_buff:GetPhysicalArmorBonusPercentage()
	return self.attribute_bonus_pct
end
function modifier_talent_general_gold_command_buff:GetMagicalArmorBonusPercentage()
	return self.attribute_bonus_pct
end
function modifier_talent_general_gold_command_buff:GetStatusHealthBonusPercentage()
	return self.attribute_bonus_pct
end
function modifier_talent_general_gold_command_buff:GetStatusManaBonusPercentage()
	return self.attribute_bonus_pct
end
function modifier_talent_general_gold_command_buff:GetManaRegenPercentage()
	return self.attribute_bonus_pct
end
function modifier_talent_general_gold_command_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2,
	}
end
function modifier_talent_general_gold_command_buff:OnTooltip()
	local tMdfs = self:EDeclareFunctions()
	self._OnTooltip = ((self._OnTooltip or -1) + 1) % #tMdfs
	local i = self._OnTooltip + 1
	return self[tMdfs[i]](self)
end
function modifier_talent_general_gold_command_buff:OnTooltip2()
	local tMdfs = self:EDeclareFunctions()
	self._OnTooltip2 = ((self._OnTooltip2 or -1) + 1) % #tMdfs
	local i = self._OnTooltip2 + 1
	return self:GetParent():GetValByKey(E_DECLARE_FUNCTION[tMdfs[i]].attribute_kind, self)
end