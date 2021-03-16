LinkLuaModifier("modifier_cmd_rattletrap_3", "abilities/commander/cmd_rattletrap/cmd_rattletrap_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_rattletrap_3 == nil then
	cmd_rattletrap_3 = class({})
end
function cmd_rattletrap_3:GetIntrinsicModifierName()
	return "modifier_cmd_rattletrap_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_rattletrap_3 == nil then
	modifier_cmd_rattletrap_3 = class({}, nil, eom_modifier)
end
function modifier_cmd_rattletrap_3:IsHidden()
	return true
end
function modifier_cmd_rattletrap_3:OnCreated(params)
	self.repair_time = self:GetAbilitySpecialValueFor('repair_time')
	self.chance = self:GetAbilitySpecialValueFor('chance')
	if IsServer() then
		self.tParticleIDs = {}
		self.tUnits = {}
	end
end
function modifier_cmd_rattletrap_3:OnRefresh(params)
	self.repair_time = self:GetAbilitySpecialValueFor('repair_time')
	self.chance = self:GetAbilitySpecialValueFor('chance')
	if IsServer() then
	end
end
function modifier_cmd_rattletrap_3:OnDestroy()
	if IsServer() then
		for k, hUnit in pairs(self.tUnits) do
			if IsValid(hUnit) then
				self:UnregisterReincarnation(hUnit)
			end
		end
	end
end
function modifier_cmd_rattletrap_3:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED_FROM_CARD, self.OnTowerSpawnedFromCard },
	}
end
function modifier_cmd_rattletrap_3:RegisterReincarnation(hUnit)
	if TableFindKey(self.tUnits, hUnit) ~= nil then return end
	
	table.insert(self.tUnits, hUnit)
	hUnit:SetVal(ATTRIBUTE_KIND.Reincarnation, function(self)
		if not IsValid(hUnit) then
			if hUnit ~= nil then
				self:UnregisterReincarnation(hUnit)
			end
			return
		end
		if RollPercentage(self.chance) then
			local iParticleID = ParticleManager:CreateParticle("particles/items5_fx/repair_kit.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, hUnit:GetAbsOrigin())
			ParticleManager:SetParticleControl(iParticleID, 1, hUnit:GetAbsOrigin())
			
			table.insert(self.tParticleIDs, iParticleID)

			self:AddParticle(iParticleID, false, false, -1, false, false)

			GameTimer(self.repair_time, function()
				ParticleManager:DestroyParticle(iParticleID, false)
			end)

			return self.repair_time
		end
	end, self, 0)
end
function modifier_cmd_rattletrap_3:UnregisterReincarnation(hUnit)
	ArrayRemove(self.tUnits, hUnit)
	hUnit:SetVal(ATTRIBUTE_KIND.Reincarnation, nil, self, 0)
end
function modifier_cmd_rattletrap_3:OnInBattle()
	if IsServer() then
		local iPlayerID = self:GetPlayerID()
		BuildSystem:EachBuilding(iPlayerID, function(hBuilding, iPlayerID, iEntIndex)
			local hUnit = EntIndexToHScript(iEntIndex)
			if IsValid(hUnit) then
				self:RegisterReincarnation(hUnit)
			end
		end)
	end
end
function modifier_cmd_rattletrap_3:OnBattleEnd()
	if IsServer() then
		local iPlayerID = self:GetPlayerID()
		BuildSystem:EachBuilding(iPlayerID, function(hBuilding, iPlayerID, iEntIndex)
			local hUnit = EntIndexToHScript(iEntIndex)
			if IsValid(hUnit) then
				self:UnregisterReincarnation(hUnit)
			end
		end)
		for i, iParticleID in ipairs(self.tParticleIDs) do
			ParticleManager:DestroyParticle(iParticleID, false)
		end
	end
end
function modifier_cmd_rattletrap_3:OnTowerSpawnedFromCard(tEvents)
	if not PlayerData:IsBattling(self:GetPlayerID()) then return end
	local hBuilding = tEvents.hBuilding
	local hUnit = hBuilding:GetUnitEntity()
	if IsValid(hUnit) then
		self:RegisterReincarnation(hUnit)
	end
end