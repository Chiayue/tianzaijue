LinkLuaModifier("modifier_art_time_tuner", "abilities/artifact/art_time_tuner.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_art_time_tuner_buff", "abilities/artifact/art_time_tuner.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--时间协调器
if art_time_tuner == nil then
	---@class  art_time_tuner
	art_time_tuner = class({}, nil, artifact_base)
end
function art_time_tuner:GetIntrinsicModifierName()
	return "modifier_art_time_tuner"
end
--------------------------------------
---Modifiers
if modifier_art_time_tuner == nil then
	modifier_art_time_tuner = class({}, nil, eom_modifier)
end
function modifier_art_time_tuner:OnCreated(params)
	if IsServer() then
		local hCaster = self:GetCaster()
		self.tModifiers = {}
		self:StartIntervalThink(1)
	end
end
function modifier_art_time_tuner:OnRefresh(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_art_time_tuner:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_art_time_tuner:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned }
	}
end
function modifier_art_time_tuner:OnIntervalThink()
	if IsServer() then
		if IsValid(self:GetAbility()) then
			local hCaster = self:GetCaster()
			local iPlayerID = GetPlayerID(self:GetParent())
			EachUnits(iPlayerID, function(hUnit)
				if not hUnit:HasModifier("modifier_art_time_tuner_buff") then
					table.insert(self.tModifiers, hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_art_time_tuner_buff", nil))
				end
			end, UnitType.Building)
		end
	end
end
function modifier_art_time_tuner:OnInBattle()
	self:OnIntervalThink()
end
function modifier_art_time_tuner:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	if iPlayerID == self:GetPlayerID()
	and IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0 then
		table.insert(self.tModifiers, hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_art_time_tuner_buff", nil))
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_time_tuner_buff == nil then
	modifier_art_time_tuner_buff = class({}, nil, eom_modifier)
end
function modifier_art_time_tuner_buff:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor('chance')
	self.hero_count = self:GetAbilitySpecialValueFor('hero_count')
	if IsServer() then
	end
end
function modifier_art_time_tuner_buff:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor('chance')
	self.hero_count = self:GetAbilitySpecialValueFor('hero_count')
	if IsServer() then
	end
end
function modifier_art_time_tuner_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_art_time_tuner_buff:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ABILITY_EXECUTED] = { self:GetParent() }
	}
end

function modifier_art_time_tuner_buff:OnAbilityExecuted(params)
	self.tUnits = {}
	local hParent = self:GetParent()
	local hArtAbility = self:GetAbility()
	local iPlayerID = GetPlayer(self:GetParent())
	-- 重置冷却
	if params.unit == self:GetParent() and hArtAbility:IsCooldownReady() then
		EachUnits(iPlayerID, function(hUnit)
			if hUnit:IsAlive() and hUnit ~= self:GetParent() then
				table.insert(self.tUnits, hUnit:GetEntityIndex())
			end
		end, UnitType.Building)
		if RollPercentage(100) and #self.tUnits > 0 then
			for i = 1, self.hero_count do
				self.hUnit = EntIndexToHScript(RandomValue(self.tUnits))
				self.tAbilities = {}
				for i = 0, self.hUnit:GetAbilityCount() - 1 do
					local hAbility = self.hUnit:GetAbilityByIndex(i)
					if IsValid(hAbility) then
						if hAbility:GetCooldown(hAbility:GetLevel()) > 0 and hAbility:GetLevel() > 0 then
							table.insert(self.tAbilities, hAbility:GetAbilityIndex())
						end
					end
				end
			end
			-- self.hUnit:GetAbilityByIndex(RandomValue(self.tAbilities)):EndCooldown()
			if 0 < #self.tAbilities then
				-- 刷新
				local endAbility =	self.hUnit:GetAbilityByIndex(RandomValue(self.tAbilities))
				endAbility:EndCooldown()
				endAbility:StartCooldown(0)
				local iPtclID = ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_CENTER_FOLLOW, self.hUnit)
				ParticleManager:ReleaseParticleIndex(iPtclID)
				-- 表现力
			end
		end
	end
	hArtAbility:UseResources(false, false, true)
end
function modifier_art_time_tuner_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_art_time_tuner_buff:OnTooltip()
	return self.chance
end