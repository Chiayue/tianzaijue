LinkLuaModifier("modifier_cmd_juggernaut_1", "abilities/commander/cmd_juggernaut/cmd_juggernaut_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_juggernaut_1_buff", "abilities/commander/cmd_juggernaut/cmd_juggernaut_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_juggernaut_1 == nil then
	cmd_juggernaut_1 = class({})
end
function cmd_juggernaut_1:GetIntrinsicModifierName()
	return "modifier_cmd_juggernaut_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_juggernaut_1 == nil then
	modifier_cmd_juggernaut_1 = class({}, nil, eom_modifier)
end
function modifier_cmd_juggernaut_1:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
	end
	self:UpdateValues()
end
function modifier_cmd_juggernaut_1:OnRefresh(params)
	self:UpdateValues()
end
function modifier_cmd_juggernaut_1:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_cmd_juggernaut_1:IsHidden()
	return true
end
function modifier_cmd_juggernaut_1:UpdateValues()
	self.attack_bonus_pct = self:GetAbilitySpecialValueFor('attack_bonus_pct')
	if IsServer() then
		self:OnIntervalThink()
	end
end
function modifier_cmd_juggernaut_1:OnIntervalThink()
	if IsServer() and not self:GetParent():IsIllusion() then
		if IsValid(self:GetAbility())
		and self:GetAbility():GetLevel() > 0 then
			local hCaster = self:GetCaster()
			local iPlayerID = self:GetPlayerID()
			EachUnits(iPlayerID, function(hUnit)
				if not hUnit:IsRangedAttacker() then
					self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_cmd_juggernaut_1_buff", nil)
				end
			end, UnitType.Building)
			local hCommander = Commander:GetCommander(iPlayerID)
			self.tModifiers[hCommander:entindex()] = hCommander:AddNewModifier(hCaster, self:GetAbility(), "modifier_cmd_juggernaut_1_buff", nil)
		end
	end
end
function modifier_cmd_juggernaut_1:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned },
	}
end
function modifier_cmd_juggernaut_1:OnInBattle()
	self:OnIntervalThink()
end
function modifier_cmd_juggernaut_1:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	if iPlayerID == self:GetPlayerID()
	and IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0
	and not hUnit:IsRangedAttacker() then
		self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_cmd_juggernaut_1_buff", nil)
	end
end

---------------------------------------------------------------------
--Modifiers
if modifier_cmd_juggernaut_1_buff == nil then
	modifier_cmd_juggernaut_1_buff = class({}, nil, eom_modifier)
end
function modifier_cmd_juggernaut_1_buff:OnCreated(params)
	self.attack_bonus_pct = self:GetAbilitySpecialValueFor('attack_bonus_pct')
	if IsServer() then
	end
end
function modifier_cmd_juggernaut_1_buff:OnRefresh(params)
	self.attack_bonus_pct = self:GetAbilitySpecialValueFor('attack_bonus_pct')
	if IsServer() then
	end
end
function modifier_cmd_juggernaut_1_buff:EDeclareFunctions()
	return {
		[EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE] = self.attack_bonus_pct,
		[EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE] = self.attack_bonus_pct,
	}
end
function modifier_cmd_juggernaut_1_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_cmd_juggernaut_1_buff:OnTooltip()
	return self.attack_bonus_pct
end
function modifier_cmd_juggernaut_1_buff:GetMagicalAttackBonusPercentage()
	return self.attack_bonus_pct
end
function modifier_cmd_juggernaut_1_buff:GetPhysicalAttackBonusPercentage()
	return self.attack_bonus_pct
end