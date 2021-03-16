LinkLuaModifier("modifier_cmd_juggernaut_8", "abilities/commander/cmd_juggernaut/cmd_juggernaut_8.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_juggernaut_8_buff", "abilities/commander/cmd_juggernaut/cmd_juggernaut_8.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_juggernaut_8 == nil then
	cmd_juggernaut_8 = class({})
end
function cmd_juggernaut_8:GetIntrinsicModifierName()
	return "modifier_cmd_juggernaut_8"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_juggernaut_8 == nil then
	modifier_cmd_juggernaut_8 = class({}, nil, eom_modifier)
end
function modifier_cmd_juggernaut_8:IsHidden()
	return true
end
function modifier_cmd_juggernaut_8:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
	end
	self:UpdateValues()
end
function modifier_cmd_juggernaut_8:OnRefresh(params)
	self:UpdateValues()
end
function modifier_cmd_juggernaut_8:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_cmd_juggernaut_8:IsHidden()
	return true
end
function modifier_cmd_juggernaut_8:UpdateValues()
	if IsServer() then
		self:OnIntervalThink()
	end
end
function modifier_cmd_juggernaut_8:OnIntervalThink()
	if IsServer() and not self:GetParent():IsIllusion() then
		if IsValid(self:GetAbility())
		and self:GetAbility():GetLevel() > 0 then
			local hCaster = self:GetCaster()
			local iPlayerID = self:GetPlayerID()
			EachUnits(iPlayerID, function(hUnit)
				self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_cmd_juggernaut_8_buff", nil)
			end, UnitType.Building)
			-- local hCommander = Commander:GetCommander(iPlayerID)
			-- self.tModifiers[hCommander:entindex()] = hCommander:AddNewModifier(hCaster, self:GetAbility(), "modifier_cmd_juggernaut_8_buff", nil)
		end
	end
end
function modifier_cmd_juggernaut_8:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned },
	}
end
function modifier_cmd_juggernaut_8:OnInBattle()
	self:OnIntervalThink()
end
function modifier_cmd_juggernaut_8:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	if iPlayerID == self:GetPlayerID()
	and IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0 then
		self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_cmd_juggernaut_8_buff", nil)
	end
end
---------------------------------------------------------------------
if modifier_cmd_juggernaut_8_buff == nil then
	modifier_cmd_juggernaut_8_buff = class({}, nil, eom_modifier)
end
function modifier_cmd_juggernaut_8_buff:OnCreated(params)
	self.period = self:GetAbilitySpecialValueFor('period')
	self.pct = self:GetAbilitySpecialValueFor('pct')
	if IsServer() then
		self:SetStackCount(1)
	end
end
function modifier_cmd_juggernaut_8_buff:OnRefresh(params)
	self.period = self:GetAbilitySpecialValueFor('period')
	self.pct = self:GetAbilitySpecialValueFor('pct')
	if IsServer() then
	end
end
function modifier_cmd_juggernaut_8_buff:OnIntervalThink()
	if IsServer() then
		self:SetStackCount(1)
		self:StartIntervalThink(-1)
	end
end
function modifier_cmd_juggernaut_8_buff:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() },
		EMDF_OUTGOING_PERCENTAGE
	}
end
function modifier_cmd_juggernaut_8_buff:OnTakeDamage(params)
	if IsServer() and params.damage > 0 then
		self:SetStackCount(0)
		self:StartIntervalThink(self.period)
	end
end
function modifier_cmd_juggernaut_8_buff:GetOutgoingPercentage()
	if self:GetStackCount() == 1 then
		return self.pct
	end
end
function modifier_cmd_juggernaut_8_buff:IsHidden()
	return true
end