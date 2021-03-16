LinkLuaModifier("modifier_sp_recover_buff", "abilities/spell/sp_recover.lua", LUA_MODIFIER_MOTION_NONE)
--回春术
if sp_recover == nil then
	sp_recover = class({}, nil, sp_base)
end
function sp_recover:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_recover:OnSpellStart()
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

	local health_recover_pct = self:GetSpecialValueFor("health_recover_pct")

	local iParticleID = ParticleManager:CreateParticle("particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(1, 5, 1))
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(252, 179, 84))
	ParticleManager:SetParticleControl(iParticleID, 4, Vector(252, 179, 84))
	ParticleManager:SetParticleControl(iParticleID, 5, Vector(11, 0, 0))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(vPosition, "Hero_Omniknight.Purification", hCaster)

	local tTargets = FindUnitsInRadius(iTeamNumber, vPosition, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for i, hTarget in ipairs(tTargets) do
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_purification_ti6_immortal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(hTarget:GetModelRadius(), hTarget:GetModelRadius(), hTarget:GetModelRadius()))
		ParticleManager:ReleaseParticleIndex(iParticleID)
		hTarget:AddNewModifier(hCaster, self, "modifier_sp_recover_buff", { duration = duration })
		hTarget:Heal(hTarget:GetMaxHealth() * health_recover_pct * 0.01, self)
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_recover_buff == nil then
	modifier_sp_recover_buff = class({}, nil, eom_modifier)
end
function modifier_sp_recover_buff:IsDebuff()
	return false
end
function modifier_sp_recover_buff:IsHidden()
	return false
end
function modifier_sp_recover_buff:IsPurgable()
	return true
end
function modifier_sp_recover_buff:IsPurgeException()
	return true
end
function modifier_sp_recover_buff:IsStunDebuff()
	return false
end
function modifier_sp_recover_buff:GetEffectName()
	return "particles/units/heroes/hero_omniknight/omniknight_heavenly_grace_buff.vpcf"
end
function modifier_sp_recover_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_sp_recover_buff:OnCreated(params)
	self.damage_reduction = self:GetAbilitySpecialValueFor("damage_reduction")
end
function modifier_sp_recover_buff:OnRefresh(params)
	self.damage_reduction = self:GetAbilitySpecialValueFor("damage_reduction")
end
function modifier_sp_recover_buff:EDeclareFunctions()
	return {
		[EMDF_INCOMING_PERCENTAGE] = -self.damage_reduction,
	}
end
function modifier_sp_recover_buff:GetIncomingPercentage(params)
	return -self.damage_reduction
end
function modifier_sp_recover_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_sp_recover_buff:OnTooltip()
	return self.damage_reduction
end