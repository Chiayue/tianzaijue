LinkLuaModifier("modifier_sp_frozenarea", "abilities/spell/sp_frozenarea.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sp_frozenarea_aura", "abilities/spell/sp_frozenarea.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_frozenarea == nil then
	sp_frozenarea = class({}, nil, sp_base)
end
function sp_frozenarea:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_frozenarea:OnSpellStart()
	local hCaster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local vPosition = self:GetCursorPosition()
	local iTeamNumber = hCaster:GetTeamNumber()

	DotaTD:EachPlayer(function(_, iPlayerID)
		if PlayerData:IsPointInPlayerRange(iPlayerID, vPosition) then
			iTeamNumber = PlayerData:GetHero(iPlayerID):GetTeamNumber()
		end
	end)

	EmitSoundOnLocationWithCaster(vPosition, "Hero_Ancient_Apparition.IceVortexCast", hCaster)

	CreateModifierThinker(hCaster, self, "modifier_sp_frozenarea", { duration = duration }, vPosition, iTeamNumber, false)
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_frozenarea == nil then
	modifier_sp_frozenarea = class({})
end
function modifier_sp_frozenarea:IsHidden()
	return true
end
function modifier_sp_frozenarea:IsDebuff()
	return false
end
function modifier_sp_frozenarea:IsPurgable()
	return false
end
function modifier_sp_frozenarea:IsPurgeException()
	return false
end
function modifier_sp_frozenarea:IsStunDebuff()
	return false
end
function modifier_sp_frozenarea:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self.tTargets = {}
		self:GetParent():EmitSound("Hero_Ancient_Apparition.IceVortex")
		self:StartIntervalThink(0)
		self:OnIntervalThink()
	else
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/ancient_apparition/ancient_apparation_ti8/ancient_ice_vortex_ti8.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 5, Vector(self.radius, self.radius, self.radius))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_sp_frozenarea:OnDestroy()
	local hParent = self:GetParent()
	if IsServer() then
		hParent:StopSound("Hero_Ancient_Apparition.IceVortex")
		hParent:RemoveAllModifiers(0, false, true, true)
		hParent:RemoveSelf()
	end
end
function modifier_sp_frozenarea:OnIntervalThink()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	if IsServer() then
		local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.radius, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
		for _, hTarget in pairs(tTargets) do
			if TableFindKey(self.tTargets, hTarget) == nil and not hTarget:HasModifier("modifier_sp_frozenarea_aura") then
				table.insert(self.tTargets, hTarget)
				hTarget:AddNewModifier(hCaster, hAbility, "modifier_sp_frozenarea_aura", {duration=GetStatusDebuffDuration(self:GetRemainingTime(), hTarget, hCaster)})
			end
		end
	end
end
function modifier_sp_frozenarea:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] = true,
		[MODIFIER_STATE_NO_TEAM_SELECT] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}
end
---------------------------------------------------------------------
if modifier_sp_frozenarea_aura == nil then
	modifier_sp_frozenarea_aura = class({})
end
function modifier_sp_frozenarea_aura:IsHidden()
	return false
end
function modifier_sp_frozenarea_aura:IsDebuff()
	return true
end
function modifier_sp_frozenarea_aura:IsPurgable()
	return true
end
function modifier_sp_frozenarea_aura:IsPurgeException()
	return true
end
function modifier_sp_frozenarea_aura:IsStunDebuff()
	return true
end
function modifier_sp_frozenarea_aura:GetEffectName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_cold_feet_frozen.vpcf"
end
function modifier_sp_frozenarea_aura:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
function modifier_sp_frozenarea_aura:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}
end
