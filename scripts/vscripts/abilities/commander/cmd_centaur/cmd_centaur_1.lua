LinkLuaModifier("modifier_cmd_centaur_1", "abilities/commander/cmd_centaur/cmd_centaur_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_centaur_1_buff", "abilities/commander/cmd_centaur/cmd_centaur_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_centaur_1 == nil then
	cmd_centaur_1 = class({ funcCondition = function()
		return GSManager:getStateType() == GS_Battle
	end }, nil, ability_base_ai)
end
function cmd_centaur_1:Prechace(context)
	PrecacheResource("particle", "particles/units/commander/cmd_centaur/cmd_centaur_1.vpcf", context)
end
function cmd_centaur_1:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	-- DotaTD:EachPlayer(function(_, iPlayerID)
	-- 	local hEntPoint = Spawner.tTeamMapPoints[PlayerData:GetPlayerTeamID(iPlayerID)]
	-- 	local hIllusion = CreateIllusion(hCaster, hEntPoint:GetAbsOrigin(), true, hCaster, hCaster, hCaster:GetTeamNumber(), self:GetCastPoint(), 0, 0)
	-- 	hIllusion:StartGesture(ACT_DOTA_CAST_ABILITY_1)
	-- 	hIllusion:AddNewModifier(hCaster, self, "modifier_cmd_centaur_1_buff", nil)
	-- end, UnitType.Building)
	local iPlayerID = GetPlayerID(hCaster)
	local hEntPoint = Spawner.tTeamMapPoints[PlayerData:GetPlayerTeamID(iPlayerID)]
	local hIllusion = CreateIllusion(hCaster, hEntPoint:GetAbsOrigin(), true, hCaster, hCaster, hCaster:GetTeamNumber(), self:GetCastPoint(), 0, 0)
	hIllusion:StartGesture(ACT_DOTA_CAST_ABILITY_1)
	hIllusion:AddNewModifier(hCaster, self, "modifier_cmd_centaur_1_buff", nil)
	return true
end
function cmd_centaur_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local flDamage = self:GetSpecialValueFor("attack_pct") * hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack) * 0.01

	local iPlayerID = GetPlayerID(hCaster)
	local hEntPoint = Spawner.tTeamMapPoints[PlayerData:GetPlayerTeamID(iPlayerID)]
	if Spawner:IsBossRound() then
		local iParticleID = ParticleManager:CreateParticle("particles/units/commander/cmd_centaur/cmd_centaur_1.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hCaster:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, 0, radius))
		ParticleManager:ReleaseParticleIndex(iParticleID)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/commander/cmd_centaur/cmd_centaur_1.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hEntPoint:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, 0, radius))
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
	EachUnits(iPlayerID, function(hUnit)
		hCaster:DealDamage(hUnit, self, flDamage)
		hUnit:AddBuff(hCaster, BUFF_TYPE.STUN, duration)
	end, UnitType.AllEnemies)
	-- DotaTD:EachPlayer(function(_, iPlayerID)
	-- end, UnitType.Building)
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_centaur_1_buff == nil then
	modifier_cmd_centaur_1_buff = class({}, nil, eom_modifier)
end
function modifier_cmd_centaur_1_buff:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
end