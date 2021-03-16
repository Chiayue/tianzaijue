LinkLuaModifier("modifier_omni_knight_3", "abilities/tower/omni_knight/omni_knight_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_omni_knight_3_buff", "abilities/tower/omni_knight/omni_knight_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if omni_knight_3 == nil then
	omni_knight_3 = class({})
end
function omni_knight_3:GetIntrinsicModifierName()
	return "modifier_omni_knight_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_omni_knight_3 == nil then
	modifier_omni_knight_3 = class({}, nil, eom_modifier)
end
function modifier_omni_knight_3:IsHidden()
	return true
end
function modifier_omni_knight_3:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned }
	}
end
function modifier_omni_knight_3:OnInBattle()
	EachUnits(GetPlayerID(self:GetParent()), function(hUnit)
		hUnit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_omni_knight_3_buff", nil)
	end, UnitType.Building)
end
function modifier_omni_knight_3:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()
	hUnit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_omni_knight_3_buff", nil)
end
---------------------------------------------------------------------
if modifier_omni_knight_3_buff == nil then
	modifier_omni_knight_3_buff = class({}, nil, eom_modifier)
end
function modifier_omni_knight_3_buff:OnCreated(params)
	self.damage_reduce = self:GetAbilitySpecialValueFor("damage_reduce")
	self.mana_regen_pct = self:GetAbilitySpecialValueFor("mana_regen_pct")
	if IsServer() then
	end
end
function modifier_omni_knight_3_buff:EDeclareFunctions()
	return {
		[EMDF_INCOMING_PERCENTAGE] = -self.damage_reduce,
		[EMDF_INCOMING_MANA_REGEN_PERCENTAGE] = self.mana_regen_pct,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_omni_knight_3_buff:GetIncomingPercentage()
	return -self.damage_reduce
end
function modifier_omni_knight_3_buff:GetIncomingManaRegenPercentage()
	return self.mana_regen_pct
end
function modifier_omni_knight_3_buff:OnBattleEnd()
	self:Destroy()
end
function modifier_omni_knight_3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_omni_knight_3_buff:OnTooltip()
	self.iTooltip = ((self.iTooltip or -1) + 1) % 2
	if 0 == self.iTooltip then
		return self.damage_reduce
	end
	return self.mana_regen_pct
end