LinkLuaModifier("modifier_enemy_towerking", "abilities/special_abilities/enemy_towerking.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_towerking_towerbuff", "abilities/special_abilities/enemy_towerking.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_towerking_tower_start", "abilities/special_abilities/enemy_towerking.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if enemy_towerking == nil then
	enemy_towerking = class({})
end
function enemy_towerking:GetIntrinsicModifierName()
	return "modifier_enemy_towerking"
end
function enemy_towerking:OnSpellStart()
	local hCaster = self:GetCaster()
	local summon_interval = self:GetSpecialValueFor("summon_interval")
	local tower_duration = self:GetSpecialValueFor("tower_duration")
	if GSManager:getStateType() == GS_Battle then
		GameTimer(summon_interval * 1.2, function()
			if IsValid(hCaster) then
				local hTower = CreateUnitByName("king_of_tower", hCaster:GetAbsOrigin(), false, hCaster, hCaster, hCaster:GetTeamNumber())
				local summon_health_pct = self:GetSpecialValueFor("summon_health_pct")
				hTower:AddNewModifier(hCaster, self, "modifier_enemy_towerking_towerbuff", { duration = tower_duration })
				FindClearSpaceForUnit(hTower, hCaster:GetAbsOrigin(), false)
				hTower:SetHealth(summon_health_pct)
			end
		end)
	end
end

---------------------------------------------------------------------
--Modifiers
if modifier_enemy_towerking == nil then
	modifier_enemy_towerking = class({}, nil, eom_modifier)
end
function modifier_enemy_towerking:OnCreated(params)
	self.summon_interval = self:GetAbilitySpecialValueFor("summon_interval")

	if IsServer() then
	end
end
function modifier_enemy_towerking:OnRefresh(params)
	self.summon_interval = self:GetAbilitySpecialValueFor("summon_interval")
	if IsServer() then
	end
end
function modifier_enemy_towerking:OnDestroy()
	if IsServer() then
	end
end
function modifier_enemy_towerking:OnBattleEnd()
	if IsServer() then
		self:GetParent():ForceKill(true)
	end
end
function modifier_enemy_towerking:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() },
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_enemy_towerking:OnTakeDamage(parmas)
	local hParent = self:GetParent()
	if hParent:IsClone() then
		return
	end
	if self:GetParent():IsAbilityReady(self:GetAbility()) then
		ExecuteOrderFromTable({
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self:GetAbility():entindex(),
		})
	end
end

---------------------------------------------------------------------
--Modifiers
if modifier_enemy_towerking_towerbuff == nil then
	modifier_enemy_towerking_towerbuff = class({}, nil, eom_modifier)
end
function modifier_enemy_towerking_towerbuff:OnCreated(params)
	self.summon_interval = self:GetAbilitySpecialValueFor("summon_interval")
	self.summon_count = self:GetAbilitySpecialValueFor("summon_count")
	local hParent = self:GetParent()
	if IsServer() then
		self:StartIntervalThink(self.summon_interval)
	end
end
function modifier_enemy_towerking_towerbuff:OnRefresh(params)
	self.summon_interval = self:GetAbilitySpecialValueFor("summon_interval")
	self.summon_count = self:GetAbilitySpecialValueFor("summon_count")
	if IsServer() then
	end
end
function modifier_enemy_towerking_towerbuff:OnDestroy()
	if IsServer() then
	end
end
function modifier_enemy_towerking_towerbuff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_enemy_towerking_towerbuff:OnBattleEnd()
	if IsServer() then
		self:GetParent():ForceKill(true)
	end
end
function modifier_enemy_towerking_towerbuff:OnIntervalThink()
	local vPos = self:GetParent():GetAbsOrigin()
	local vDir = self:GetParent():GetForwardVector()
	local hCaster = self:GetCaster()
	if IsServer() and hCaster then
		for i = 1, self.summon_count do
			local hDiversion = Spawner:CreateWave(hCaster:GetUnitName(), vPos, vDir, GetPlayerID(hCaster))
			FindClearSpaceForUnit(hDiversion, hCaster:GetAbsOrigin(), true)
			hDiversion:FireClone(hCaster)

			hDiversion:AddNewModifier(hCaster, self, "modifier_enemy_towerking_tower_start", {})

		end
	end
end

---------------------------------------------------------------------
--Modifiers
if modifier_enemy_towerking_tower_start == nil then
	modifier_enemy_towerking_tower_start = class({}, nil, eom_modifier)
end
function modifier_enemy_towerking_tower_start:OnCreated(params)
	if IsServer() then
	end
end
function modifier_enemy_towerking_tower_start:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_enemy_towerking_tower_start:OnDestroy()
	if IsServer() then
		local iPlayerID = GetPlayerID(self:GetParent())
		self:GetParent():ForceKill(true)
	end
end
function modifier_enemy_towerking_tower_start:OnIntervalThink()
	if IsServer() then
	end
end
function modifier_enemy_towerking_tower_start:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_CANNOT_TARGET_ENEMIES] = true,
	}
end