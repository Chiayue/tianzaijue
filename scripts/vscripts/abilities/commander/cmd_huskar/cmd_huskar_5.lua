LinkLuaModifier("modifier_cmd_huskar_5", "abilities/commander/cmd_huskar/cmd_huskar_5.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_huskar_5_buff", "abilities/commander/cmd_huskar/cmd_huskar_5.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_huskar_5 == nil then
	cmd_huskar_5 = class({})
end
function cmd_huskar_5:GetIntrinsicModifierName()
	return "modifier_cmd_huskar_5"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_huskar_5 == nil then
	modifier_cmd_huskar_5 = class({}, nil, eom_modifier)
end
function modifier_cmd_huskar_5:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
	end
	self:UpdateValues()
end
function modifier_cmd_huskar_5:OnRefresh(params)
	self:UpdateValues()
end
function modifier_cmd_huskar_5:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_cmd_huskar_5:IsHidden()
	return true
end
function modifier_cmd_huskar_5:UpdateValues()
	self.number = self:GetAbilitySpecialValueFor('number')
	if IsServer() then
		self:OnIntervalThink()
	end
end
function modifier_cmd_huskar_5:OnIntervalThink()
	if IsServer() then
		if IsValid(self:GetAbility())
		and self:GetAbility():GetLevel() > 0 then
			local hCaster = self:GetCaster()
			local iPlayerID = self:GetPlayerID()
			EachUnits(iPlayerID, function(hUnit)
				local tags = DotaTD:GetCardTags(hUnit:GetUnitName())
				for _, sTag in pairs(tags) do
					if (sTag == "Tag_warrior" or sTag == "Tag_knight") and not hUnit:HasModifier("modifier_cmd_huskar_5_buff") then
						self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_cmd_huskar_5_buff", nil)
					end
				end
			end, UnitType.Building)
		end
	end
end
function modifier_cmd_huskar_5:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned },
	}
end
function modifier_cmd_huskar_5:OnInBattle()
	self:OnIntervalThink()
end
function modifier_cmd_huskar_5:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	if iPlayerID == self:GetPlayerID()
	and IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0 then
		local tags = DotaTD:GetCardTags(hUnit:GetUnitName())
		PrintTable(tags)
		for _, sTag in pairs(tags) do
			if (sTag == "warrior" or sTag == "knight") and not hUnit:HasModifier("modifier_cmd_huskar_5_buff") then
				self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_cmd_huskar_5_buff", nil)
			end
		end
	end
end

---------------------------------------------------------------------
--Modifiers
if modifier_cmd_huskar_5_buff == nil then
	modifier_cmd_huskar_5_buff = class({}, nil, eom_modifier)
end
function modifier_cmd_huskar_5_buff:OnCreated(params)
	self.number = self:GetAbilitySpecialValueFor('number')
	if IsServer() then
	end
end
function modifier_cmd_huskar_5_buff:OnRefresh(params)
	self.number = self:GetAbilitySpecialValueFor('number')
	if IsServer() then
	end
end
function modifier_cmd_huskar_5_buff:EDeclareFunctions()
	return {
		[EMDF_STATUS_HEALTH_BONUS_PERCENTAGE] = self.number,
	}
end
function modifier_cmd_huskar_5_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_cmd_huskar_5_buff:OnTooltip()
	return self.number
end
function modifier_cmd_huskar_5_buff:GetStatusHealthBonusPercentage()
	return self.number
end