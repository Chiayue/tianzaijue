LinkLuaModifier("modifier_sp_fear_debuff", "abilities/spell/sp_fear.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_fear == nil then
	sp_fear = class({}, nil, sp_base)
end
function sp_fear:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_fear:OnSpellStart()
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
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(2, 2, 1))
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(47, 79, 79))
	ParticleManager:SetParticleControl(iParticleID, 4, Vector(65, 105, 225))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(vPosition, "Hero_DarkWillow.Fear.Target", hCaster)

	local tTargets = FindUnitsInRadius(iTeamNumber, vPosition, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
	for i, hTarget in pairs(tTargets) do
		hTarget:AddNewModifier(hCaster, self, "modifier_sp_fear_debuff", { duration = GetStatusDebuffDuration(duration, hTarget, hCaster) })
		hTarget:AddBuff(hCaster, BUFF_TYPE.FEAR, duration)
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_fear_debuff == nil then
	modifier_sp_fear_debuff = class({}, nil, eom_modifier)
end
function modifier_sp_fear_debuff:IsHidden()
	return false
end
function modifier_sp_fear_debuff:IsDebuff()
	return true
end
function modifier_sp_fear_debuff:IsPurgable()
	return true
end
function modifier_sp_fear_debuff:IsPurgeException()
	return true
end
function modifier_sp_fear_debuff:AllowIllusionDuplicate()
	return false
end
function modifier_sp_fear_debuff:OnCreated(params)
	self.incoming_damage = self:GetAbilitySpecialValueFor("incoming_damage")
end
function modifier_sp_fear_debuff:OnRefresh(params)
	self.incoming_damage = self:GetAbilitySpecialValueFor("incoming_damage")
end
function modifier_sp_fear_debuff:EDeclareFunctions()
	return {
		[EMDF_INCOMING_PERCENTAGE] = self.incoming_damage,
	}
end
function modifier_sp_fear_debuff:GetIncomingPercentage()
	return self.incoming_damage
end
function modifier_sp_fear_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_sp_fear_debuff:OnTooltip()
	return self.incoming_damage
end