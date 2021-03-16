LinkLuaModifier("modifier_sp_magdouble_buff", "abilities/spell/sp_magdouble.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_magdouble == nil then
	sp_magdouble = class({}, nil, sp_base)
end
function sp_magdouble:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_magdouble:OnSpellStart()
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
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(94, 156, 255))
	ParticleManager:SetParticleControl(iParticleID, 4, Vector(0, 96, 255))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(vPosition, "Rune.Arcane", hCaster)

	local tTargets = FindUnitsInRadius(iTeamNumber, vPosition, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
	for _, hTarget in pairs(tTargets) do
		hTarget:AddNewModifier(hCaster, self, "modifier_sp_magdouble_buff", { duration = duration })
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_magdouble_buff == nil then
	modifier_sp_magdouble_buff = class({}, nil, eom_modifier)
end
function modifier_sp_magdouble_buff:IsHidden()
	return false
end
function modifier_sp_magdouble_buff:IsDebuff()
	return false
end
function modifier_sp_magdouble_buff:IsPurgable()
	return true
end
function modifier_sp_magdouble_buff:IsPurgeException()
	return true
end
function modifier_sp_magdouble_buff:IsStunDebuff()
	return false
end
function modifier_sp_magdouble_buff:OnCreated(params)
	self.increasepct = self:GetAbilitySpecialValueFor("increasepct")
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/generic_gameplay/rune_doubledamage_owner_glow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_sp_magdouble_buff:OnRefresh(params)
	self.increasepct = self:GetAbilitySpecialValueFor("increasepct")
end
function modifier_sp_magdouble_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		[EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE] = self.increasepct,
	}
end
function modifier_sp_magdouble_buff:OnBattleEnd()
	self:Destroy()
end
function modifier_sp_magdouble_buff:GetMagicalAttackBonusPercentage()
	return self.increasepct
end