LinkLuaModifier("modifier_sp_frozen_debuff", "abilities/spell/sp_frozen.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_frozen == nil then
	sp_frozen = class({}, nil, sp_base)
end
function sp_frozen:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_frozen:OnSpellStart()
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

	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_crystalmaiden/maiden_crystal_nova.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, duration, radius))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(vPosition, "Hero_Crystal.CrystalNova", hCaster)

	local tTargets = FindUnitsInRadius(iTeamNumber, vPosition, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), 0, false)
	for i, hTarget in pairs(tTargets) do
		hTarget:AddNewModifier(hCaster, self, "modifier_sp_frozen_debuff", { duration = GetStatusDebuffDuration(duration, hTarget, hCaster) })
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_frozen_debuff == nil then
	modifier_sp_frozen_debuff = class({}, nil, eom_modifier)
end
function modifier_sp_frozen_debuff:IsDebuff()
	return true
end
function modifier_sp_frozen_debuff:IsHidden()
	return false
end
function modifier_sp_frozen_debuff:IsPurgable()
	return true
end
function modifier_sp_frozen_debuff:IsPurgeException()
	return true
end
function modifier_sp_frozen_debuff:IsStunDebuff()
	return true
end
function modifier_sp_frozen_debuff:GetEffectName()
	return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end
function modifier_sp_frozen_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_sp_frozen_debuff:OnCreated(params)
	self.incoming_damage_spell = self:GetAbilitySpecialValueFor("incoming_damage_spell")
end
function modifier_sp_frozen_debuff:OnRefresh(params)
	self.incoming_damage_spell = self:GetAbilitySpecialValueFor("incoming_damage_spell")
end
function modifier_sp_frozen_debuff:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}
end
function modifier_sp_frozen_debuff:EDeclareFunctions()
	return {
		EMDF_INCOMING_PERCENTAGE,
	}
end
function modifier_sp_frozen_debuff:GetIncomingPercentage(params)
	if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_SPELL) == DOTA_DAMAGE_FLAG_SPELL then
		return self.incoming_damage_spell
	end
end
function modifier_sp_frozen_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_sp_frozen_debuff:OnTooltip()
	return self.incoming_damage_spell
end