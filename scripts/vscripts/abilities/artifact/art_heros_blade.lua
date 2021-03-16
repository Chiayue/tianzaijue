LinkLuaModifier("modifier_art_heros_blade", "abilities/artifact/art_heros_blade.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_art_heros_blade_buff", "abilities/artifact/art_heros_blade.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_heros_blade == nil then
	art_heros_blade = class({}, nil, artifact_base)
end
function art_heros_blade:GetAttackSpeedPercentage()
	return self:GetSpecialValueFor("attack_speed_bonus_pct")
end
-- function art_heros_blade:GetIntrinsicModifierName()
-- 	return "modifier_art_heros_blade"
-- end
---------------------------------------------------------------------
--Modifiers
if modifier_art_heros_blade == nil then
	modifier_art_heros_blade = class({}, nil, eom_modifier)
end
function modifier_art_heros_blade:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
		self:OnIntervalThink()
	end
end
function modifier_art_heros_blade:OnRefresh(params)
	if IsServer() then
		self:OnIntervalThink()
	end
end
function modifier_art_heros_blade:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_art_heros_blade:OnIntervalThink()
	if IsServer() then
		if IsValid(self:GetAbility())
		and self:GetAbility():GetLevel() > 0 then
			local hCaster = self:GetCaster()
			local iPlayerID = self:GetPlayerID()
			EachUnits(iPlayerID, function(hUnit)
				if not hUnit:HasModifier('modifier_art_heros_blade_buff') then
					self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_art_heros_blade_buff", nil)
				end
			end, UnitType.Building)
		end
	end
end
function modifier_art_heros_blade:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned }
	}
end
function modifier_art_heros_blade:OnInBattle()
	self:OnIntervalThink()
end
function modifier_art_heros_blade:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	if iPlayerID == self:GetPlayerID()
	and IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0 then
		self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_art_heros_blade_buff", nil)
	end
end


------------------------------------------------------------------------------
if modifier_art_heros_blade_buff == nil then
	modifier_art_heros_blade_buff = class({}, nil, eom_modifier)
end
function modifier_art_heros_blade_buff:OnCreated(params)
	if IsServer() then

	end
end
function modifier_art_heros_blade_buff:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_art_heros_blade_buff:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_art_heros_blade_buff:EDeclareFunctions()
	return {
		EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE
	}
end
function modifier_art_heros_blade_buff:GetAttackSpeedPercentage()
	return self:GetAbilitySpecialValueFor("attack_speed_bonus_pct")
end