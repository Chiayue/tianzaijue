LinkLuaModifier("modifier_cmd_juggernaut_4", "abilities/commander/cmd_juggernaut/cmd_juggernaut_4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_juggernaut_4_buff", "abilities/commander/cmd_juggernaut/cmd_juggernaut_4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_juggernaut_4_attackspeed", "abilities/commander/cmd_juggernaut/cmd_juggernaut_4.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_juggernaut_4 == nil then
	cmd_juggernaut_4 = class({})
end
function cmd_juggernaut_4:GetIntrinsicModifierName()
	return "modifier_cmd_juggernaut_4"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_juggernaut_4 == nil then
	modifier_cmd_juggernaut_4 = class({}, nil, eom_modifier)
end
function modifier_cmd_juggernaut_4:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
	end
	self:UpdateValues()
end
function modifier_cmd_juggernaut_4:OnRefresh(params)
	self:UpdateValues()
end
function modifier_cmd_juggernaut_4:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_cmd_juggernaut_4:IsHidden()
	return true
end
function modifier_cmd_juggernaut_4:UpdateValues()
	if IsServer() then
		self:OnIntervalThink()
	end
end
function modifier_cmd_juggernaut_4:OnIntervalThink()
	if IsServer() and not self:GetParent():IsIllusion() then
		if IsValid(self:GetAbility())
		and self:GetAbility():GetLevel() > 0 then
			local hCaster = self:GetCaster()
			local iPlayerID = self:GetPlayerID()
			EachUnits(iPlayerID, function(hUnit)
				if not hUnit:IsRangedAttacker() then
					self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_cmd_juggernaut_4_buff", nil)
				end
			end, UnitType.Building)
			local hCommander = Commander:GetCommander(iPlayerID)
			self.tModifiers[hCommander:entindex()] = hCommander:AddNewModifier(hCaster, self:GetAbility(), "modifier_cmd_juggernaut_4_buff", nil)
		end
	end
end
function modifier_cmd_juggernaut_4:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned },
	}
end
function modifier_cmd_juggernaut_4:OnInBattle()
	self:OnIntervalThink()
end
function modifier_cmd_juggernaut_4:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	if iPlayerID == self:GetPlayerID()
	and IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0
	and not hUnit:IsRangedAttacker() then
		self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_cmd_juggernaut_4_buff", nil)
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_juggernaut_4_buff == nil then
	modifier_cmd_juggernaut_4_buff = class({}, nil, eom_modifier)
end
function modifier_cmd_juggernaut_4_buff:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor('chance')
	if IsServer() then
	end
end
function modifier_cmd_juggernaut_4_buff:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor('chance')
	if IsServer() then
	end
end
function modifier_cmd_juggernaut_4_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_cmd_juggernaut_4_buff:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK_LANDED] = { self:GetParent(), nil },
	}
end
function modifier_cmd_juggernaut_4_buff:OnAttackLanded(params)
	if not IsValid(params.target) or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() and RollPercentage(self.chance) then
		params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_cmd_juggernaut_4_attackspeed", { duration = 2 })
	end
end
function modifier_cmd_juggernaut_4_buff:DeclareFunctions()
	return	{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_cmd_juggernaut_4_buff:OnTooltip()
	return self.chance
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_juggernaut_4_attackspeed == nil then
	modifier_cmd_juggernaut_4_attackspeed = class({}, nil, eom_modifier)
end
function modifier_cmd_juggernaut_4_attackspeed:IsHidden()
	return true
end
function modifier_cmd_juggernaut_4_attackspeed:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK_LANDED] = { self:GetParent(), nil },
		[EMDF_ATTACKT_SPEED_BONUS] = self:GetAttackSpeedBonus(),
	}
end
function modifier_cmd_juggernaut_4_attackspeed:OnAttackLanded(params)
	if not IsValid(params.target) or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() then
		self:Destroy()
	end
end
function modifier_cmd_juggernaut_4_attackspeed:GetAttackSpeedBonus()
	return 1000
end