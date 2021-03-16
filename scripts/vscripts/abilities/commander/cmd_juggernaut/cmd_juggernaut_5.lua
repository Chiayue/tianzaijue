LinkLuaModifier("modifier_cmd_juggernaut_5", "abilities/commander/cmd_juggernaut/cmd_juggernaut_5.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_juggernaut_5_buff", "abilities/commander/cmd_juggernaut/cmd_juggernaut_5.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_juggernaut_5_damage", "abilities/commander/cmd_juggernaut/cmd_juggernaut_5.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_juggernaut_5 == nil then
	cmd_juggernaut_5 = class({})
end
function cmd_juggernaut_5:GetIntrinsicModifierName()
	return "modifier_cmd_juggernaut_5"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_juggernaut_5 == nil then
	modifier_cmd_juggernaut_5 = class({}, nil, eom_modifier)
end
function modifier_cmd_juggernaut_5:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
	end
	self:UpdateValues()
end
function modifier_cmd_juggernaut_5:OnRefresh(params)
	self:UpdateValues()
end
function modifier_cmd_juggernaut_5:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_cmd_juggernaut_5:IsHidden()
	return true
end
function modifier_cmd_juggernaut_5:UpdateValues()
	if IsServer() then
		self:OnIntervalThink()
	end
end
function modifier_cmd_juggernaut_5:OnIntervalThink()
	if IsServer() and not self:GetParent():IsIllusion() then
		if IsValid(self:GetAbility())
		and self:GetAbility():GetLevel() > 0 then
			local hCaster = self:GetCaster()
			local iPlayerID = self:GetPlayerID()
			EachUnits(iPlayerID, function(hUnit)
				if not hUnit:IsRangedAttacker() then
					self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_cmd_juggernaut_5_buff", nil)
				end
			end, UnitType.Building)
			local hCommander = Commander:GetCommander(iPlayerID)
			self.tModifiers[hCommander:entindex()] = hCommander:AddNewModifier(hCaster, self:GetAbility(), "modifier_cmd_juggernaut_5_buff", nil)
		end
	end
end
function modifier_cmd_juggernaut_5:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned },
	}
end
function modifier_cmd_juggernaut_5:OnInBattle()
	self:OnIntervalThink()
end
function modifier_cmd_juggernaut_5:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	if iPlayerID == self:GetPlayerID()
	and IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0
	and not hUnit:IsRangedAttacker() then
		self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_cmd_juggernaut_5_buff", nil)
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_juggernaut_5_buff == nil then
	modifier_cmd_juggernaut_5_buff = class({}, nil, eom_modifier)
end
function modifier_cmd_juggernaut_5_buff:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor('chance')
	self.cd = self:GetAbilitySpecialValueFor('cd')
	if IsServer() then
		self:SetStackCount(1)
	end
end
function modifier_cmd_juggernaut_5_buff:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor('chance')
	self.cd = self:GetAbilitySpecialValueFor('cd')
	if IsServer() then
	end
end
function modifier_cmd_juggernaut_5_buff:OnIntervalThink()
	if IsServer() then
		self:SetStackCount(1)
		self:StartIntervalThink(-1)
	end
end
function modifier_cmd_juggernaut_5_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE
	}
end
function modifier_cmd_juggernaut_5_buff:GetModifierAvoidDamage()
	if RollPercentage(self.chance) and self:GetStackCount() == 1 then
		self:SetStackCount(0)
		self:StartIntervalThink(self.cd)
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_cmd_juggernaut_5_damage", nil)
		return 1
	end
end
function modifier_cmd_juggernaut_5_buff:IsHidden()
	return true
end
---------------------------------------------------------------------
if modifier_cmd_juggernaut_5_damage == nil then
	modifier_cmd_juggernaut_5_damage = class({}, nil, eom_modifier)
end
function modifier_cmd_juggernaut_5_damage:OnCreated(params)
	self.damage_pct = self:GetAbilitySpecialValueFor('damage_pct')
	if IsServer() then
	end
end
function modifier_cmd_juggernaut_5_damage:OnRefresh(params)
	self.damage_pct = self:GetAbilitySpecialValueFor('damage_pct')
	if IsServer() then
	end
end
function modifier_cmd_juggernaut_5_damage:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT
	}
end
function modifier_cmd_juggernaut_5_damage:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	local hParent = self:GetParent()
	for iDamageType, tDamageInfo in pairs(tAttackInfo.tDamageInfo) do
		tDamageInfo.damage = tDamageInfo.damage + tDamageInfo.damage_base * self.damage_pct * 0.01
	end
	self:Destroy()
end
function modifier_cmd_juggernaut_5_damage:IsHidden()
	return false
end