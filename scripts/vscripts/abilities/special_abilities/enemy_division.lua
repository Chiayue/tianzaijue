LinkLuaModifier("modifier_enemy_division", "abilities/special_abilities/enemy_division.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_division_start", "abilities/special_abilities/enemy_division.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_division_runrunrun", "abilities/special_abilities/enemy_division.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if enemy_division == nil then
	enemy_division = class({})
end
function enemy_division:GetIntrinsicModifierName()
	return "modifier_enemy_division"
end
function enemy_division:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:StartGesture(ACT_DOTA_VICTORY)
	if self:GetCaster() then

		-- hCaster:AddNewModifier(hCaster, self, pszScriptName, hModifierTable)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_primal_split.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, self:GetCaster():GetAbsOrigin())
		-- self:AddParticle(iParticleID, false, false, -1, false, false)
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end

end
function enemy_division:OnChannelFinish(bInterrupted)
	if bInterrupted then return end
	local hCaster = self:GetCaster()
	-- 召唤
	if GSManager:getStateType() == GS_Battle then
		local diversion_count = self:GetSpecialValueFor('diversion_count')
		for i = 1, diversion_count do
			local vPos = hCaster:GetAbsOrigin()
			local vDir = hCaster:GetForwardVector()
			local hDiversion = Spawner:CreateWave(hCaster:GetUnitName(), vPos, vDir, GetPlayerID(hCaster))
			hDiversion:SetModelScale(0.8)
			FindClearSpaceForUnit(hDiversion, hCaster:GetAbsOrigin(), true)
			hDiversion:FireClone(hCaster)
			--
			hDiversion:AddNewModifier(hCaster, self, "modifier_enemy_division_start", {})
			hDiversion:AddNewModifier(hCaster, self, "modifier_enemy_ai", {
				checked = 1
			})
			hDiversion:SetHealth(hDiversion:GetMaxHealth() * self:GetSpecialValueFor("diversion_healthpct") * 0.01)
		end
	end
	-- Spawner:KillEnemy(hCaster, true, false)
	hCaster:Kill(nil, nil)
end
---------------------------------------------------------------------
--Modifiers
if modifier_enemy_division == nil then
	modifier_enemy_division = class({}, nil, eom_modifier)
end
function modifier_enemy_division:OnCreated(params)
	self.trigger_health_pct = self:GetAbilitySpecialValueFor("trigger_health_pct")
	if IsServer() then
	end
end
function modifier_enemy_division:OnRefresh(params)
	self.trigger_health_pct = self:GetAbilitySpecialValueFor("trigger_health_pct")
	if IsServer() then
	end
end
function modifier_enemy_division:OnIntervalThink()
	if self:GetParent():IsAbilityReady(self:GetAbility()) then
		ExecuteOrderFromTable({
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self:GetAbility():entindex(),
		})
	end
end
function modifier_enemy_division:OnDestroy()
end
function modifier_enemy_division:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() }
	}
end
function modifier_enemy_division:OnTakeDamage(parmas)
	local hParent = self:GetParent()

	if hParent:IsClone() then
		return
	end

	local fHealth = hParent:GetHealth()
	local fMaxHealth = hParent:GetMaxHealth()
	if math.floor(fHealth * 100 / fMaxHealth) <= self.trigger_health_pct then
		self:OnIntervalThink()
	end
end

---------------------------------------------------------------------
--Modifiers
if modifier_enemy_division_start == nil then
	modifier_enemy_division_start = class({}, nil, eom_modifier)
end
function modifier_enemy_division_start:OnCreated(params)
	if IsServer() then
	end
end
function modifier_enemy_division_start:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_enemy_division_start:OnDestroy()
	if IsServer() then
		local iPlayerID = GetPlayerID(self:GetParent())
		-- self:GetParent():Kill(self:GetAbility(), PlayerData:GetHero(iPlayerID))
		self:GetParent():Kill(nil, nil)
	end
end
function modifier_enemy_division_start:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_CANNOT_TARGET_ENEMIES] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end
function modifier_enemy_division_start:IsHidden()
	return true
end