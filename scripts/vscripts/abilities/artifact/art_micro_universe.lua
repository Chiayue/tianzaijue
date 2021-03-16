LinkLuaModifier("modifier_art_micro_universe", "abilities/artifact/art_micro_universe.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_art_micro_universe_debuff", "abilities/artifact/art_micro_universe.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_micro_universe == nil then
	art_micro_universe = class({}, nil, artifact_base)
end
function art_micro_universe:GetIntrinsicModifierName()
	return "modifier_art_micro_universe"
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_micro_universe == nil then
	modifier_art_micro_universe = class({}, nil, eom_modifier)
end
function modifier_art_micro_universe:IsHidden()
	return true
end
function modifier_art_micro_universe:OnCreated(params)
	self.max_building_bonus = self:GetAbilitySpecialValueFor("max_building_bonus")
	if IsServer() then
		self.tTargets = {}	-- 记录额外人口
	end
end
function modifier_art_micro_universe:OnRefresh(params)
	self.max_building_bonus = self:GetAbilitySpecialValueFor("max_building_bonus")
	if IsServer() then
	end
end
function modifier_art_micro_universe:OnDestroy()
	if IsServer() then
		for _, hBuilding in ipairs(self.tTargets) do
			local hUnit = hBuilding:GetUnitEntity()
			local iPlayerID = GetPlayerID(hUnit)
			BuildSystem:BuildingToCard(iPlayerID, hUnit, true)
			if hUnit and hUnit:HasModifier("modifier_art_micro_universe_debuff") then
				hUnit:RemoveModifierByName("modifier_art_micro_universe_debuff")
			end
		end
	end
end
function modifier_art_micro_universe:EDeclareFunctions()
	return {
		EMDF_MAX_BUILDING_BONUS,
		-- EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = {
			{ ET_PLAYER.ON_TOWER_SPAWNED_FROM_CARD, self.OnTowerSpawnedFromCard },
			{ ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned },
			{ ET_PLAYER.ON_TOWER_DESTROY, self.OnTowerDestroy }
		},
	}
end
function modifier_art_micro_universe:GetModifierMaxBuildingBonus()
	return self.max_building_bonus
end
function modifier_art_micro_universe:OnTowerSpawnedFromCard(tEvent)
	local iPlayerID = tEvent.PlayerID
	if iPlayerID ~= self:GetPlayerID() then return end
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()
	local iBaseBuildCount = PlayerBuildings:GetPlayerMaxBuildCount(iPlayerID) - self.max_building_bonus	-- 基础建筑数量
	if PlayerBuildings:GetPlayerMaxBuildCount(iPlayerID) - PlayerBuildings:GetPlayerCurBuildCount(iPlayerID) < self.max_building_bonus - TableCount(self.tTargets, nil) and TableCount(self.tTargets, nil) < self.max_building_bonus then
		table.insert(self.tTargets, hBuilding)
	end
	if TableFindKey(self.tTargets, hBuilding) ~= nil then
		hUnit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_art_micro_universe_debuff", nil)
	end
end
function modifier_art_micro_universe:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	if iPlayerID ~= self:GetPlayerID() then return end
	---@type Building
	local hBuilding = tEvent.hBuilding
	if TableFindKey(self.tTargets, hBuilding) ~= nil then
		local hUnit = hBuilding:GetUnitEntity()
		hUnit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_art_micro_universe_debuff", nil)
	end
end
function modifier_art_micro_universe:OnTowerDestroy(tEvent)
	local iPlayerID = tEvent.PlayerID
	if iPlayerID ~= self:GetPlayerID() then return end
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()
	ArrayRemove(self.tTargets, hBuilding)
	local iBaseBuildCount = PlayerBuildings:GetPlayerMaxBuildCount(iPlayerID) - self.max_building_bonus
	-- if PlayerBuildings:GetPlayerCurBuildCount(iPlayerID) - iBaseBuildCount < #self.tTargets then
		-- if IsValid(self.tTargets[#self.tTargets]) and self.tTargets[#self.tTargets]:GetUnitEntity():HasModifier("modifier_art_micro_universe_debuff") then
		if hUnit:HasModifier("modifier_art_micro_universe_debuff") then
			hUnit:RemoveModifierByName("modifier_art_micro_universe_debuff")
			-- table.remove(self.tTargets, #self.tTargets)
		end
	-- end
end
---------------------------------------------------------------------
if modifier_art_micro_universe_debuff == nil then
	modifier_art_micro_universe_debuff = class({}, nil, eom_modifier)
end
function modifier_art_micro_universe_debuff:IsDebuff()
	return true
end
function modifier_art_micro_universe_debuff:OnCreated(params)
	self.attribute_reduce_pct = self:GetAbilitySpecialValueFor("attribute_reduce_pct")
	if IsServer() then
	end
end
function modifier_art_micro_universe_debuff:OnDestroy()
	if IsServer() then
	end
end
function modifier_art_micro_universe_debuff:OnRefresh(params)
	self.attribute_reduce_pct = self:GetAbilitySpecialValueFor("attribute_reduce_pct")
	if IsServer() then
	end
end
function modifier_art_micro_universe_debuff:GetModifierModelScale()
	return -50
end
function modifier_art_micro_universe_debuff:EDeclareFunctions()
	return {
		EMDF_STATUS_HEALTH_BONUS_PERCENTAGE,
		EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_MAGICAL_ARMOR_BONUS_PERCENTAGE,
		EMDF_PHYSICAL_ARMOR_BONUS_PERCENTAGE,
		EMDF_MODEL_SCALE,
	}
end
function modifier_art_micro_universe_debuff:GetStatusHealthBonusPercentage()
	return -self.attribute_reduce_pct
end
function modifier_art_micro_universe_debuff:GetMagicalAttackBonusPercentage()
	return -self.attribute_reduce_pct
end
function modifier_art_micro_universe_debuff:GetPhysicalAttackBonusPercentage()
	return -self.attribute_reduce_pct
end
function modifier_art_micro_universe_debuff:GetMagicalArmorBonusPercentage()
	return -self.attribute_reduce_pct
end
function modifier_art_micro_universe_debuff:GetPhysicalArmorBonusPercentage()
	return -self.attribute_reduce_pct
end
function modifier_art_micro_universe_debuff:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_art_micro_universe_debuff:OnTooltip()
	return -self.attribute_reduce_pct
end