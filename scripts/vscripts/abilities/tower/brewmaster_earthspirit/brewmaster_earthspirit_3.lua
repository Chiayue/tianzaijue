LinkLuaModifier("modifier_brewmaster_earthspirit_3", "abilities/tower/brewmaster_earthspirit/brewmaster_earthspirit_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_brewmaster_earthspirit_3_aura", "abilities/tower/brewmaster_earthspirit/brewmaster_earthspirit_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if brewmaster_earthspirit_3 == nil then
	brewmaster_earthspirit_3 = class({})
end
function brewmaster_earthspirit_3:GetIntrinsicModifierName()
	return "modifier_brewmaster_earthspirit_3_aura"
end
---------------------------------------------------------------------
--Modifiers
if modifier_brewmaster_earthspirit_3_aura == nil then
	modifier_brewmaster_earthspirit_3_aura = class({}, nil, eom_modifier)
end
function modifier_brewmaster_earthspirit_3_aura:IsHidden()
	return true
end
function modifier_brewmaster_earthspirit_3_aura:IsAura()
	return false
end
function modifier_brewmaster_earthspirit_3_aura:GetAuraRadius()
	return self.radius
end
function modifier_brewmaster_earthspirit_3_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_brewmaster_earthspirit_3_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_brewmaster_earthspirit_3_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_brewmaster_earthspirit_3_aura:GetModifierAura()
	return "modifier_brewmaster_earthspirit_3"
end
function modifier_brewmaster_earthspirit_3_aura:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		if GSManager:getStateType() == GS_Battle then
			self:OnInBattle()
		end
	end
end
function modifier_brewmaster_earthspirit_3_aura:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = {
			{ ET_GAME.ON_CLONED, self.OnSummoned },
			{ ET_GAME.ON_SUMMONED, self.OnSummoned },
			{ ET_GAME.ON_ILLUSION, self.OnSummoned },
		},
	}
end
function modifier_brewmaster_earthspirit_3_aura:OnInBattle()
	local hParent = self:GetParent()
	EachUnits(GetPlayerID(hParent), function(hUnit)
		hUnit:AddNewModifier(hParent, self:GetAbility(), self:GetModifierAura(), nil)
	end, UnitType.AllFirends)
end
---@param tEvent EventData_ON_SUMMONED
function modifier_brewmaster_earthspirit_3_aura:OnSummoned(tEvent)
	if IsValid(tEvent.unit) and tEvent.unit:FindModifierByNameAndCaster(self:GetModifierAura(), self:GetParent()) then
		if IsValid(tEvent.target) then
			tEvent.target:AddNewModifier(self:GetParent(), self:GetAbility(), self:GetModifierAura(), nil)
		end
	end
end

---------------------------------------------------------------------
if modifier_brewmaster_earthspirit_3 == nil then
	modifier_brewmaster_earthspirit_3 = class({}, nil, eom_modifier)
end
function modifier_brewmaster_earthspirit_3:OnCreated(params)
	self.mana_regen_bonus	= self:GetAbilitySpecialValueFor("mana_regen_bonus")
end
function modifier_brewmaster_earthspirit_3:EDeclareFunctions()
	return {
		[EMDF_MANA_REGEN_BONUS] = self.mana_regen_bonus,
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_brewmaster_earthspirit_3:GetManaRegenBonus()
	return self.mana_regen_bonus
end
function modifier_brewmaster_earthspirit_3:OnBattleEnd()
	self:Destroy()
end
function modifier_brewmaster_earthspirit_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_brewmaster_earthspirit_3:OnTooltip()
	return self.mana_regen_bonus
end