LinkLuaModifier("modifier_brewmaster_earthspirit_2", "abilities/tower/brewmaster_earthspirit/brewmaster_earthspirit_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_brewmaster_earthspirit_2_buff", "abilities/tower/brewmaster_earthspirit/brewmaster_earthspirit_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if brewmaster_earthspirit_2 == nil then
	brewmaster_earthspirit_2 = class({})
end
function brewmaster_earthspirit_2:GetIntrinsicModifierName()
	return "modifier_brewmaster_earthspirit_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_brewmaster_earthspirit_2 == nil then
	modifier_brewmaster_earthspirit_2 = class({}, nil, eom_modifier)
end
function modifier_brewmaster_earthspirit_2:IsHidden()
	return true
end
function modifier_brewmaster_earthspirit_2:IsAura()
	return false
end
function modifier_brewmaster_earthspirit_2:GetAuraRadius()
	return self.radius
end
function modifier_brewmaster_earthspirit_2:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_brewmaster_earthspirit_2:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_brewmaster_earthspirit_2:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_brewmaster_earthspirit_2:GetModifierAura()
	return "modifier_brewmaster_earthspirit_2_buff"
end
function modifier_brewmaster_earthspirit_2:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		if GSManager:getStateType() == GS_Battle then
			self:OnInBattle()
		end
	end
end
function modifier_brewmaster_earthspirit_2:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = {
			{ ET_GAME.ON_CLONED, self.OnSummoned },
			{ ET_GAME.ON_SUMMONED, self.OnSummoned },
			{ ET_GAME.ON_ILLUSION, self.OnSummoned },
		},
	}
end
function modifier_brewmaster_earthspirit_2:OnInBattle()
	local hParent = self:GetParent()
	EachUnits(GetPlayerID(hParent), function(hUnit)
		hUnit:AddNewModifier(hParent, self:GetAbility(), self:GetModifierAura(), nil)
	end, UnitType.AllFirends)
end
---@param tEvent EventData_ON_SUMMONED
function modifier_brewmaster_earthspirit_2:OnSummoned(tEvent)
	if IsValid(tEvent.unit) and tEvent.unit:FindModifierByNameAndCaster(self:GetModifierAura(), self:GetParent()) then
		if IsValid(tEvent.target) then
			tEvent.target:AddNewModifier(self:GetParent(), self:GetAbility(), self:GetModifierAura(), nil)
		end
	end
end

---------------------------------------------------------------------
--Modifiers
if modifier_brewmaster_earthspirit_2_buff == nil then
	modifier_brewmaster_earthspirit_2_buff = class({}, nil, eom_modifier)
end
function modifier_brewmaster_earthspirit_2_buff:OnCreated(params)
	self.armor_pct = self:GetAbilitySpecialValueFor("armor_pct")
end
function modifier_brewmaster_earthspirit_2_buff:OnRefresh(params)
	self.armor_pct = self:GetAbilitySpecialValueFor("armor_pct")
end
function modifier_brewmaster_earthspirit_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_brewmaster_earthspirit_2_buff:OnTooltip()
	self.iTooltip = ((self.iTooltip or -1) + 1) % 2
	if 0 == self.iTooltip then
		return self:GetPhysicalArmorBonus()
	end
	return self:GetMagicalArmorBonus()
end
function modifier_brewmaster_earthspirit_2_buff:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ARMOR_BONUS,
		EMDF_MAGICAL_ARMOR_BONUS,
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_brewmaster_earthspirit_2_buff:GetPhysicalArmorBonus()
	if IsServer() then
		if self.GetCaster and IsValid(self:GetCaster()) then
		else
			self:Destroy()
			return
		end
	end

	if not self._GetPhysicalArmorBonus then
		self._GetPhysicalArmorBonus = true
		local fVal = self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self.armor_pct * 0.01
		self._GetPhysicalArmorBonus = nil
		return fVal
	end
	return 0
end
function modifier_brewmaster_earthspirit_2_buff:GetMagicalArmorBonus()
	if IsServer() then
		if self.GetCaster and IsValid(self:GetCaster()) then
		else
			self:Destroy()
			return
		end
	end

	if not self._GetMagicalArmorBonus then
		self._GetMagicalArmorBonus = true
		local fVal = self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalAttack) * self.armor_pct * 0.01
		self._GetMagicalArmorBonus = nil
		return fVal
	end
	return 0
end
function modifier_brewmaster_earthspirit_2_buff:OnBattleEnd()
	self:Destroy()
end