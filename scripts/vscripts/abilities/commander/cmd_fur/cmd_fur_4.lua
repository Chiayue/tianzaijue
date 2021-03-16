LinkLuaModifier("modifier_cmd_fur_4", "abilities/commander/cmd_fur/cmd_fur_4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_fur_4_buff", "abilities/commander/cmd_fur/cmd_fur_4.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_fur_4 == nil then
	cmd_fur_4 = class({})
end
function cmd_fur_4:GetIntrinsicModifierName()
	return "modifier_cmd_fur_4"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_fur_4 == nil then
	modifier_cmd_fur_4 = class({}, nil, eom_modifier)
end
function modifier_cmd_fur_4:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
	end
	self:UpdateValues()
end
function modifier_cmd_fur_4:OnRefresh(params)
	self:UpdateValues()
end
function modifier_cmd_fur_4:UpdateValues()
	self.health_regen = self:GetAbilitySpecialValueFor('health_regen')
	if IsServer() then
		self:Action()
	end
end
function modifier_cmd_fur_4:OnDestroy()
	if IsServer() then
	end
end
function modifier_cmd_fur_4:Action()
	if IsServer() then
		if IsValid(self:GetAbility())
		and self:GetAbility():GetLevel() > 0 then
			local hCaster = self:GetCaster()
			local iPlayerID = self:GetPlayerID()
			EachUnits(iPlayerID, function(hUnit)
				self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_cmd_fur_4_buff", nil)
			end, UnitType.Building)
		end
	end
end
function modifier_cmd_fur_4:EDeclareFunctions()
	return {
		[EMDF_HEALTH_REGEN_BONUS] = self.health_regen,
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned },
	}
end
function modifier_cmd_fur_4:OnInBattle()
	self:Action()
end
function modifier_cmd_fur_4:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	if iPlayerID == self:GetPlayerID()
	and IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0 then
		print(hUnit)
		self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_cmd_fur_4_buff", nil)
	end
end
function modifier_cmd_fur_4:GetHealthRegenBonus()
	return self.health_regen
end
function modifier_cmd_fur_4:DeclareFunctions()
	return	{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_cmd_fur_4:OnTooltip()
	return self.health_regen
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_fur_4_buff == nil then
	modifier_cmd_fur_4_buff = class({}, nil, eom_modifier)
end
function modifier_cmd_fur_4_buff:OnCreated(params)
	self.health_regen = self:GetAbilitySpecialValueFor('health_regen')
	if IsServer() then
		self:SetStackCount(PLAYER_HEALTH - PlayerData:GetHealth(GetPlayerID(self:GetParent())))
	end
end
function modifier_cmd_fur_4_buff:OnRefresh(params)
	self.health_regen = self:GetAbilitySpecialValueFor('health_regen')
	if IsServer() then
		self:SetStackCount(PLAYER_HEALTH - PlayerData:GetHealth(GetPlayerID(self:GetParent())))
	end
end
function modifier_cmd_fur_4_buff:EDeclareFunctions()
	return {
		[EMDF_HEALTH_REGEN_BONUS] = self.health_regen,
	}
end
function modifier_cmd_fur_4_buff:GetHealthRegenBonus()
	return self.health_regen
end
function modifier_cmd_fur_4_buff:DeclareFunctions()
	return	{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_cmd_fur_4_buff:OnTooltip()
	return self.health_regen
end