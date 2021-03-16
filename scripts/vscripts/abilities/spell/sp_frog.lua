LinkLuaModifier("modifier_sp_frog_debuff", "abilities/spell/sp_frog.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_frog == nil then
	sp_frog = class({}, nil, sp_base)
end
function sp_frog:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_frog:OnSpellStart()
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

	local iParticleID = ParticleManager:CreateParticle("particles/econ/generic/generic_aoe_shockwave_1/generic_aoe_shockwave_1.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(1, 5, 1))
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(255, 91, 254))
	ParticleManager:SetParticleControl(iParticleID, 4, Vector(180, 99, 255))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(vPosition, "Hero_Lion.Voodoo", hCaster)

	local tTargets = FindUnitsInRadius(iTeamNumber, vPosition, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
	for _, hTarget in pairs(tTargets) do
		if not hTarget:IsBoss() and not hTarget:IsGoldWave() then
			hTarget:AddNewModifier(hCaster, self, "modifier_sp_frog_debuff", { duration = GetStatusDebuffDuration(duration, hTarget, hCaster) })
			hTarget:EmitSound("Hero_Lion.Hex.Target")
		end
	end
end
---------------------------------------------------------------------
-- Modifiers
if modifier_sp_frog_debuff == nil then
	modifier_sp_frog_debuff = class({})
end
function modifier_sp_frog_debuff:IsHidden()
	return false
end
function modifier_sp_frog_debuff:IsDebuff()
	return true
end
function modifier_sp_frog_debuff:IsPurgable()
	return false
end
function modifier_sp_frog_debuff:IsPurgeException()
	return true
end
function modifier_sp_frog_debuff:IsStunDebuff()
	return false
end
function modifier_sp_frog_debuff:OnCreated(params)
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lion/lion_spell_voodoo.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(iParticleID)

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lion/lion_spell_voodoo_ambient.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_sp_frog_debuff:OnRefresh(params)
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
end
function modifier_sp_frog_debuff:CheckState()
	return {
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_HEXED] = true,
	}
end
function modifier_sp_frog_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_PRESERVE_PARTICLES_ON_MODEL_CHANGE,
	}
end
function modifier_sp_frog_debuff:GetModifierMoveSpeedOverride()
	return self.movespeed
end
function modifier_sp_frog_debuff:GetModifierModelChange()
	return "models/props_gameplay/frog.vmdl"
end
function modifier_sp_frog_debuff:PreserveParticlesOnModelChanged(params)
	return 1
end