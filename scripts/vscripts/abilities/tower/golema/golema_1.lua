LinkLuaModifier("modifier_golemA_1_effect", "abilities/tower/golemA/golemA_1.lua", LUA_MODIFIER_MOTION_NONE)

if golemA_1 == nil then
	golemA_1 = class({ iOrderType = FIND_FARTHEST }, nil, ability_base_ai)
end
function golemA_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local vTarget = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")

	local stun_duration = self:GetSpecialValueFor("stun_duration")
	local obstacle_duration = self:GetSpecialValueFor("obstacle_duration")

	local dummy = CreateUnitByName("npc_dota_dummy", vTarget, true, hCaster, hCaster:GetOwner(), hCaster:GetTeamNumber())
	-- dummy:AddNewModifier(hCaster, self, "modifier_dummy", {})
	dummy:SetHullRadius(radius)
	dummy:AddNewModifier(hCaster, self, "modifier_golemA_1_effect", {
		duration = obstacle_duration,
		entindex = dummy:GetEntityIndex()
	})
	hCaster:GameTimer(0.5, function()
		dummy:SetHullRadius(10)
	end)

	local tEnemies = FindUnitsInRadius(
	hCaster:GetTeamNumber(),
	vTarget,
	nil,
	radius,
	self:GetAbilityTargetTeam(),
	self:GetAbilityTargetType(),
	DOTA_UNIT_TARGET_FLAG_NONE,
	FIND_ANY_ORDER,
	false)
	local damage_table = {
		attacker = hCaster,
		-- victim = hUnit,
		damage = self:GetAbilityDamage(),
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self,
	}
	for k, hEnemy in pairs(tEnemies) do
		if IsValid(hEnemy) then
			damage_table.victim = hEnemy
			ApplyDamage(damage_table)
			if hEnemy:IsAlive() then
				hEnemy:AddBuff(hCaster, BUFF_TYPE.STUN, stun_duration)
			end
		end
	end

	local tUnits = FindUnitsInRadius(
	hCaster:GetTeamNumber(),
	vTarget,
	nil,
	radius,
	DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	self:GetAbilityTargetType(),
	DOTA_UNIT_TARGET_FLAG_NONE,
	FIND_ANY_ORDER,
	false)
	dummy:Timer(0,
	function()
		for k, hUnit in pairs(tUnits) do
			if IsValid(hUnit) and hUnit:IsAlive() then
				FindClearSpaceForUnit(hUnit, hUnit:GetAbsOrigin(), false)
			end
		end
		for k, hUnit in pairs(tEnemies) do
			if IsValid(hUnit) and hUnit:IsAlive() then
				FindClearSpaceForUnit(hUnit, hUnit:GetAbsOrigin(), false)
			end
		end
	end)
end
------------------------------------------------------------------------------
if modifier_golemA_1_effect == nil then
	modifier_golemA_1_effect = class({}, nil, BaseModifier)
end
function modifier_golemA_1_effect:OnCreated(params)
	local radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self.hDummy = EntIndexToHScript(params.entindex)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/golem_a_1_avalanche.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, 0, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_golemA_1_effect:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_golemA_1_effect:OnDestroy(params)
	if IsServer() then
		if IsValid(self.hDummy) then
			UTIL_Remove(self.hDummy)
		end
	end
end
function modifier_golemA_1_effect:DeclareFunctions()
	return {
	}
end
function modifier_golemA_1_effect:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] = true,
		[MODIFIER_STATE_NO_TEAM_SELECT] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}
end