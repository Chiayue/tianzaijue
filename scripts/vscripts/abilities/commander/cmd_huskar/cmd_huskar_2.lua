LinkLuaModifier("modifier_cmd_huskar_2", "abilities/commander/cmd_huskar/cmd_huskar_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_huskar_2_buff", "abilities/commander/cmd_huskar/cmd_huskar_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_huskar_2 == nil then
	cmd_huskar_2 = class({})
end
function cmd_huskar_2:GetIntrinsicModifierName()
	return "modifier_cmd_huskar_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_huskar_2 == nil then
	modifier_cmd_huskar_2 = class({}, nil, eom_modifier)
end
function modifier_cmd_huskar_2:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
	end
	self:UpdateValues()
end
function modifier_cmd_huskar_2:OnRefresh(params)
	self:UpdateValues()
end
function modifier_cmd_huskar_2:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_cmd_huskar_2:IsHidden()
	return true
end
function modifier_cmd_huskar_2:UpdateValues()
	self.number = self:GetAbilitySpecialValueFor('number')
	if IsServer() then
		self:OnIntervalThink()
	end
end
function modifier_cmd_huskar_2:OnIntervalThink()
	if IsServer() then
		if IsValid(self:GetAbility())
		and self:GetAbility():GetLevel() > 0 then
			local hCaster = self:GetCaster()
			local iPlayerID = self:GetPlayerID()
			EachUnits(iPlayerID, function(hUnit)
				self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_cmd_huskar_2_buff", nil)
			end, UnitType.Building)
		end
	end
end
function modifier_cmd_huskar_2:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned },
	}
end
function modifier_cmd_huskar_2:OnInBattle()
	self:OnIntervalThink()
end
function modifier_cmd_huskar_2:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	if iPlayerID == self:GetPlayerID()
	and IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0 then
		self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_cmd_huskar_2_buff", nil)
	end
end

---------------------------------------------------------------------
--Modifiers
if modifier_cmd_huskar_2_buff == nil then
	modifier_cmd_huskar_2_buff = class({}, nil, eom_modifier)
end
function modifier_cmd_huskar_2_buff:OnCreated(params)
	self.number = self:GetAbilitySpecialValueFor('number')
	if IsServer() then
		-- self:SetStackCount(PLAYER_HEALTH - PlayerData:GetHealth(GetPlayerID(self:GetParent())))
	end
end
function modifier_cmd_huskar_2_buff:OnRefresh(params)
	self.number = self:GetAbilitySpecialValueFor('number')
	if IsServer() then
		-- self:SetStackCount(PLAYER_HEALTH - PlayerData:GetHealth(GetPlayerID(self:GetParent())))
	end
end
function modifier_cmd_huskar_2_buff:EDeclareFunctions()
	return {
		EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_DEATH, self.OnTowerDeath },
	}
end
function modifier_cmd_huskar_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_cmd_huskar_2_buff:OnTooltip()
	return self.number * self:GetStackCount()
end
function modifier_cmd_huskar_2_buff:OnTowerDeath(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	local iCount = 0
	EachUnits(iPlayerID, function(hUnit)
		if not hUnit:IsAlive() then
			iCount = iCount + 1
		end
	end, UnitType.Building)
	self:SetStackCount(iCount)
end
function modifier_cmd_huskar_2_buff:GetMagicalAttackBonusPercentage()
	return self.number * self:GetStackCount()
end
function modifier_cmd_huskar_2_buff:GetPhysicalAttackBonusPercentage()
	return self.number * self:GetStackCount()
end