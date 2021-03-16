LinkLuaModifier("modifier_sp_shallowgrave_buff", "abilities/spell/sp_shallowgrave.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_shallowgrave == nil then
	sp_shallowgrave = class({}, nil, sp_base)
end
function sp_shallowgrave:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_shallowgrave:OnSpellStart()
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
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(1, 1, 1))
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(130, 56, 120))
	ParticleManager:SetParticleControl(iParticleID, 4, Vector(116, 95, 251))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(vPosition, "Hero_Dazzle.Shallow_Grave", hCaster)

	local tTargets = FindUnitsInRadius(iTeamNumber, vPosition, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), 0, false)
	for i, hTarget in pairs(tTargets) do
		hTarget:AddNewModifier(hCaster, self, "modifier_sp_shallowgrave_buff", { duration = duration })
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_shallowgrave_buff == nil then
	modifier_sp_shallowgrave_buff = class({}, nil, eom_modifier)
end
function modifier_sp_shallowgrave_buff:IsDebuff()
	return false
end
function modifier_sp_shallowgrave_buff:IsHidden()
	return false
end
function modifier_sp_shallowgrave_buff:IsPurgable()
	return true
end
function modifier_sp_shallowgrave_buff:IsPurgeException()
	return true
end
function modifier_sp_shallowgrave_buff:OnCreated(params)
	if IsServer() then
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/dazzle/dazzle_ti6/dazzle_ti6_shallow_grave.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 7, Vector(self:GetDuration(), 0, 0))
		ParticleManager:SetParticleControl(iParticleID, 8, Vector(0, 0, 0.5*25*self:GetDuration()^2))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_sp_shallowgrave_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MIN_HEALTH
	}
end
function modifier_sp_shallowgrave_buff:GetMinHealth(params)
	return 1
end