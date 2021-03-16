LinkLuaModifier("modifier_sp_revolt_buff", "abilities/spell/sp_revolt.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_revolt == nil then
	sp_revolt = class({}, nil, sp_base)
end
function sp_revolt:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_revolt:OnSpellStart()
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
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(178, 34, 34))
	ParticleManager:SetParticleControl(iParticleID, 4, Vector(255, 99, 71))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(vPosition, "Hero_OgreMagi.Bloodlust.Target", hCaster)

	local tTargets = FindUnitsInRadius(iTeamNumber, vPosition, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), 0, false)
	for i, hTarget in pairs(tTargets) do
		hTarget:AddNewModifier(hCaster, self, "modifier_sp_revolt_buff", { duration = duration })
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_revolt_buff == nil then
	modifier_sp_revolt_buff = class({}, nil, eom_modifier)
end
function modifier_sp_revolt_buff:IsDebuff()
	return false
end
function modifier_sp_revolt_buff:IsHidden()
	return false
end
function modifier_sp_revolt_buff:IsPurgable()
	return true
end
function modifier_sp_revolt_buff:IsPurgeException()
	return true
end
function modifier_sp_revolt_buff:GetEffectName()
	return "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf"
end
function modifier_sp_revolt_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_sp_revolt_buff:OnCreated(params)
	self.crit_chance = self:GetAbilitySpecialValueFor("crit_chance")
	self.crit_damage = self:GetAbilitySpecialValueFor("crit_damage")
end
function modifier_sp_revolt_buff:EDeclareFunctions()
	return {
		EMDF_DAMAGE_CRIT_BONUS,
	}
end
function modifier_sp_revolt_buff:GetDamageCritBonus(params)
	return self.crit_chance, self.crit_damage
end
function modifier_sp_revolt_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_sp_revolt_buff:OnTooltip(params)
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self.crit_chance
	elseif self._tooltip == 2 then
		return self.crit_damage
	end
end