LinkLuaModifier("modifier_sp_invincible_buff", "abilities/spell/sp_invincible.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_invincible == nil then
	sp_invincible = class({}, nil, sp_base)
end
function sp_invincible:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_invincible:OnSpellStart()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local vPosition = self:GetCursorPosition()
	local iTeamNumber = hCaster:GetTeamNumber()

	DotaTD:EachPlayer(function(_, iPlayerID)
		if PlayerData:IsPointInPlayerRange(iPlayerID, vPosition) then
			iTeamNumber = PlayerData:GetHero(iPlayerID):GetTeamNumber()
		end
	end)

	local iParticleID = ParticleManager:CreateParticle("particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(2, 2, 1))
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(135, 206, 235))
	ParticleManager:SetParticleControl(iParticleID, 4, Vector(64, 105, 225))
	ParticleManager:SetParticleControl(iParticleID, 5, Vector(11, 0, 0))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(vPosition, "Hero_Omniknight.GuardianAngel.Cast", hCaster)

	local tTargets = FindUnitsInRadius(iTeamNumber, vPosition, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), 0, false)
	for i, hTarget in pairs(tTargets) do
		hTarget:AddNewModifier(hCaster, self, "modifier_sp_invincible_buff", { duration = duration })
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_invincible_buff == nil then
	modifier_sp_invincible_buff = class({}, nil, eom_modifier)
end
function modifier_sp_invincible_buff:IsDebuff()
	return false
end
function modifier_sp_invincible_buff:IsHidden()
	return false
end
function modifier_sp_invincible_buff:IsPurgable()
	return true
end
function modifier_sp_invincible_buff:IsPurgeException()
	return true
end
function modifier_sp_invincible_buff:GetEffectName()
	return "particles/units/heroes/hero_omniknight/omniknight_guardian_angel_ally.vpcf"
end
function modifier_sp_invincible_buff:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end
function modifier_sp_invincible_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE,
	}
end
function modifier_sp_invincible_buff:GetModifierAvoidDamage(params)
	return 1
end