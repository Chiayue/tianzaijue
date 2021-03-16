LinkLuaModifier("modifier_sp_phydouble_buff", "abilities/spell/sp_phydouble.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_phydouble == nil then
	sp_phydouble = class({}, nil, sp_base)
end
function sp_phydouble:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_phydouble:OnSpellStart()
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
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(255, 96, 96))
	ParticleManager:SetParticleControl(iParticleID, 4, Vector(255, 0, 0))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(vPosition, "hero_bloodseeker.bloodRage", hCaster)

	local tTargets = FindUnitsInRadius(iTeamNumber, vPosition, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
	for _, hTarget in pairs(tTargets) do
		hTarget:AddNewModifier(hCaster, self, "modifier_sp_phydouble_buff", { duration = duration })
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_phydouble_buff == nil then
	modifier_sp_phydouble_buff = class({}, nil, eom_modifier)
end
function modifier_sp_phydouble_buff:IsHidden()
	return false
end
function modifier_sp_phydouble_buff:IsDebuff()
	return false
end
function modifier_sp_phydouble_buff:IsPurgable()
	return true
end
function modifier_sp_phydouble_buff:IsPurgeException()
	return true
end
function modifier_sp_phydouble_buff:IsStunDebuff()
	return false
end
function modifier_sp_phydouble_buff:ShouldUseOverheadOffset()
	return true
end
function modifier_sp_phydouble_buff:OnCreated(params)
	self.increasepct = self:GetAbilitySpecialValueFor("increasepct")
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_eztzhok.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, true)
	end
end
function modifier_sp_phydouble_buff:OnRefresh(params)
	self.increasepct = self:GetAbilitySpecialValueFor("increasepct")
end
function modifier_sp_phydouble_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		[EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE] = self.increasepct,
	}
end
function modifier_sp_phydouble_buff:OnBattleEnd()
	self:Destroy()
end
function modifier_sp_phydouble_buff:GetPhysicalAttackBonusPercentage()
	return self.increasepct
end