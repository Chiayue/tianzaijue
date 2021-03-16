LinkLuaModifier("modifier_sp_cripple_debuff", "abilities/spell/sp_cripple.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_cripple == nil then
	sp_cripple = class({}, nil, sp_base)
end
function sp_cripple:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_cripple:OnSpellStart()
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
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(1, 1, 1))
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(225, 52, 52))
	ParticleManager:SetParticleControl(iParticleID, 4, Vector(255, 52, 52))
	ParticleManager:SetParticleControl(iParticleID, 4, Vector(9, 0, 0))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(vPosition, "DOTA_Item.HeavensHalberd.Activate", hCaster)

	local tTargets = FindUnitsInRadius(iTeamNumber, vPosition, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), 0, false)
	for i, hTarget in pairs(tTargets) do
		hTarget:AddNewModifier(hCaster, self, "modifier_sp_cripple_debuff", { duration = GetStatusDebuffDuration(duration, hTarget, hCaster) })
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_cripple_debuff == nil then
	modifier_sp_cripple_debuff = class({}, nil, eom_modifier)
end
function modifier_sp_cripple_debuff:IsDebuff()
	return true
end
function modifier_sp_cripple_debuff:IsHidden()
	return false
end
function modifier_sp_cripple_debuff:IsPurgable()
	return true
end
function modifier_sp_cripple_debuff:IsPurgeException()
	return true
end
function modifier_sp_cripple_debuff:OnCreated(params)
	self.damage_reduce_pct = self:GetAbilitySpecialValueFor("damage_reduce_pct")
	self.movespeed_reduce_pct = self:GetAbilitySpecialValueFor("movespeed_reduce_pct")
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_life_stealer/life_stealer_open_wounds.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_sp_cripple_debuff:EDeclareFunctions()
	return {
		[EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE] = -self.movespeed_reduce_pct,
		[EMDF_OUTGOING_PERCENTAGE] = -self.damage_reduce_pct,
	}
end
function modifier_sp_cripple_debuff:GetMoveSpeedBonusPercentage()
	return -self.movespeed_reduce_pct
end
function modifier_sp_cripple_debuff:GetOutgoingPercentage(params)
	return -self.damage_reduce_pct
end
function modifier_sp_cripple_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2
	}
end
function modifier_sp_cripple_debuff:OnTooltip()
	return self.movespeed_reduce_pct
end
function modifier_sp_cripple_debuff:OnTooltip2()
	return self.damage_reduce_pct
end