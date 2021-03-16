LinkLuaModifier("modifier_sp_physicalendurance_buff", "abilities/spell/sp_physicalendurance.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_physicalendurance == nil then
	sp_physicalendurance = class({}, nil, sp_base)
end
function sp_physicalendurance:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_physicalendurance:OnSpellStart()
	local hCaster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")
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
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(118, 150, 61))
	ParticleManager:SetParticleControl(iParticleID, 4, Vector(173, 255, 47))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(vPosition, "Hero_Treant.LivingArmor.Cast", hCaster)

	local tTargets = FindUnitsInRadius(iTeamNumber, vPosition, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), 0, false)
	for i, hTarget in pairs(tTargets) do
		hTarget:AddNewModifier(hCaster, self, "modifier_sp_physicalendurance_buff", { duration = duration })
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_physicalendurance_buff == nil then
	modifier_sp_physicalendurance_buff = class({}, nil, eom_modifier)
end
function modifier_sp_physicalendurance_buff:IsDebuff()
	return false
end
function modifier_sp_physicalendurance_buff:IsHidden()
	return false
end
function modifier_sp_physicalendurance_buff:IsPurgable()
	return true
end
function modifier_sp_physicalendurance_buff:IsPurgeException()
	return true
end
function modifier_sp_physicalendurance_buff:OnCreated(params)
	local hParent = self:GetParent()
	self.health_recocer_pct = self:GetAbilitySpecialValueFor("health_recocer_pct")
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_livingarmor.vpcf", PATTACH_CUSTOMORIGIN, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_sp_physicalendurance_buff:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACKED] = {nil, self:GetParent()}
	}
end
function modifier_sp_physicalendurance_buff:OnAttacked(params)
	local hParent = self:GetParent()
	if params.target == hParent then
		hParent:Heal(hParent:GetMaxHealth() * self.health_recocer_pct * 0.01, self:GetAbility())
	end
end
function modifier_sp_physicalendurance_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_sp_physicalendurance_buff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return self.health_recocer_pct
	end
end