LinkLuaModifier("modifier_sp_defections", "abilities/spell/sp_defections.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_defections == nil then
	sp_defections = class({}, nil, sp_base)
end
function sp_defections:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_defections:CastFilterResultLocation(vLocation)
	local hCaster = self:GetCaster()
	local iPlayerID = hCaster:GetPlayerOwnerID()
	local hCommander = Commander:GetCommander(iPlayerID)
	if not IsValid(hCommander) then
		return UF_FAIL_CUSTOM, "dota_hud_error_only_can_not_cast"
	end
	return UF_SUCCESS
end
function sp_defections:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()

	local radius = self:GetSpecialValueFor("radius")
	local health_pct = self:GetSpecialValueFor("health_pct")
	local duration = self:GetSpecialValueFor("duration")

	local iPlayerID = hCaster:GetPlayerOwnerID()
	local hCommander = Commander:GetCommander(iPlayerID)
	local iTeamNumber = hCaster:GetTeamNumber()

	DotaTD:EachPlayer(function(_, iPlayerID)
		if PlayerData:IsPointInPlayerRange(iPlayerID, vPosition) then
			iTeamNumber = PlayerData:GetHero(iPlayerID):GetTeamNumber()
		end
	end)

	local iParticleID = ParticleManager:CreateParticle("particles/econ/generic/generic_aoe_shockwave_1/generic_aoe_shockwave_1.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(1, 5, 1))
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(173, 216, 230))
	ParticleManager:SetParticleControl(iParticleID, 4, Vector(100, 149, 237))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(vPosition, "Hero_Chen.HolyPersuasionEnemy", hCaster)

	local tTargets = FindUnitsInRadius(iTeamNumber, vPosition, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), 0, false)
	for i, hTarget in pairs(tTargets) do
		if not hTarget:IsBoss() and not hTarget:IsGoldWave() and not hTarget:IsElite() and hTarget:GetHealth() <= hTarget:GetMaxHealth() * health_pct * 0.01 then
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_holy_persuasion.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
			ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(iParticleID)

			Spawner:Charm(hCommander, hTarget, hAbility)
			hTarget:SetAcquisitionRange(3000)
			hTarget:ChangeTeam(iTeamNumber)
			hTarget:SetOwner(hCaster)
			hTarget:AddNewModifier(hCommander, self, "modifier_sp_defections", { duration = duration })
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_defections == nil then
	modifier_sp_defections = class({}, nil, eom_modifier)
end
function modifier_sp_defections:IsHidden()
	return true
end
function modifier_sp_defections:IsDebuff()
	return false
end
function modifier_sp_defections:IsPurgable()
	return false
end
function modifier_sp_defections:IsPurgeException()
	return false
end
function modifier_sp_defections:IsStunDebuff()
	return false
end
function modifier_sp_defections:OnDestroy()
	if IsServer() then
		self:GetParent():ForceKill(false)
	end
end
function modifier_sp_defections:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_LIFETIME_FRACTION,
	}
end
function modifier_sp_defections:GetUnitLifetimeFraction()
	return self:GetRemainingTime() / self:GetDuration()
end
function modifier_sp_defections:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_sp_defections:OnBattleEnd()
	self:Destroy()
end