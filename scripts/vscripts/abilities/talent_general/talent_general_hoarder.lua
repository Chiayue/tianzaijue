LinkLuaModifier("modifier_talent_general_hoarder", "abilities/talent_general/talent_general_hoarder.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_talent_general_hoarder_buff", "abilities/talent_general/talent_general_hoarder.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if talent_general_hoarder == nil then
	talent_general_hoarder = class({})
end
function talent_general_hoarder:OnSpellStart()
	local iPlayerID = GetPlayerID(self:GetCaster())

	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, nil, 'modifier_talent_general_hoarder', nil)
end

---------------------------------------------------------------------
--Modifiers
if modifier_talent_general_hoarder == nil then
	modifier_talent_general_hoarder = class({}, nil, eom_modifier)
end
function modifier_talent_general_hoarder:OnCreated(params)
	local iLevel = GetPlayerTalentLevel(self:GetPlayerID(), 'talent_general_hoarder')
	self.gold_per = self:GetKVSpecialValueFor('talent_general_hoarder', 'gold_per', iLevel)
	self.max_stack = self:GetKVSpecialValueFor('talent_general_hoarder', 'max_stack', iLevel)
	if IsServer() then
	end
end
function modifier_talent_general_hoarder:EDeclareFunctions()
	return {
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_GOLD_CHANGE, 'OnEventPlayerGoldChange' }
	}
end

---@param tEventData EventData_PLAYER_GOLD_CHANGE
function modifier_talent_general_hoarder:OnEventPlayerGoldChange(tEventData)
	if tEventData.PlayerID ~= self:GetPlayerID() then return end
	local iStatck = math.floor(tEventData.iGold / self.gold_per)
	if iStatck > self.max_stack then
		iStatck = self.max_stack
	end
	EachUnits(tEventData.PlayerID, function(hUnit)
		if 0 >= iStatck then
			hUnit:RemoveModifierByNameAndCaster('modifier_talent_general_hoarder_buff', self:GetParent())
		else
			local hBuff = hUnit:AddNewModifier(self:GetParent(), nil, 'modifier_talent_general_hoarder_buff', {})
			if hBuff then
				hBuff:SetStackCount(iStatck)
			end
		end
	end, UnitType.Building + UnitType.Commander)
end




-- 单位身上的BUFF
if modifier_talent_general_hoarder_buff == nil then
	modifier_talent_general_hoarder_buff = class({}, nil, eom_modifier)
end
function modifier_talent_general_hoarder_buff:GetTexture()
	return GetAbilityTexture('talent_general_hoarder')
end
function modifier_talent_general_hoarder_buff:OnCreated(params)
	local iLevel = GetPlayerTalentLevel(GetPlayerID(self:GetParent()), 'talent_general_hoarder')
	self.attack_bonus_pct = self:GetKVSpecialValueFor('talent_general_hoarder', 'attack_bonus_pct', iLevel)
	if IsServer() then
	end
end
function modifier_talent_general_hoarder_buff:GetMagicalAttackBonusPercentage()
	return self.attack_bonus_pct * self:GetStackCount()
end
function modifier_talent_general_hoarder_buff:GetPhysicalAttackBonusPercentage()
	return self.attack_bonus_pct * self:GetStackCount()
end
function modifier_talent_general_hoarder_buff:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE,
	}
end
function modifier_talent_general_hoarder_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_talent_general_hoarder_buff:OnTooltip()
	return self.attack_bonus_pct * self:GetStackCount()
end