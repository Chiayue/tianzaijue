LinkLuaModifier("modifier_sp_crit_buff", "abilities/spell/sp_crit.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_crit == nil then
	sp_crit = class({}, nil, sp_base)
end
function sp_crit:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_crit:OnSpellStart()
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
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(86, 47, 47))
	ParticleManager:SetParticleControl(iParticleID, 4, Vector(255, 0, 0))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(vPosition, "DOTA_Item.MaskOfMadness.Activate", hCaster)

	local tTargets = FindUnitsInRadius(iTeamNumber, vPosition, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
	for _, hTarget in pairs(tTargets) do
		hTarget:AddNewModifier(hCaster, self, "modifier_sp_crit_buff", { duration = duration })
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_crit_buff == nil then
	modifier_sp_crit_buff = class({}, nil, eom_modifier)
end
function modifier_sp_crit_buff:IsHidden()
	return false
end
function modifier_sp_crit_buff:IsDebuff()
	return false
end
function modifier_sp_crit_buff:IsPurgable()
	return true
end
function modifier_sp_crit_buff:IsPurgeException()
	return true
end
function modifier_sp_crit_buff:IsStunDebuff()
	return false
end
function modifier_sp_crit_buff:GetEffectName()
	return "particles/items2_fx/mask_of_madness.vpcf"
end
function modifier_sp_crit_buff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
function modifier_sp_crit_buff:OnCreated(params)
	self.attack_speed_pct = self:GetAbilitySpecialValueFor("attack_speed_pct")
	self.crit_chance = self:GetAbilitySpecialValueFor("crit_chance")
	self.crit_damage = self:GetAbilitySpecialValueFor("crit_damage")
end
function modifier_sp_crit_buff:OnRefresh(params)
	self.attack_speed_pct = self:GetAbilitySpecialValueFor("attack_speed_pct")
	self.crit_chance = self:GetAbilitySpecialValueFor("crit_chance")
	self.crit_damage = self:GetAbilitySpecialValueFor("crit_damage")
end
function modifier_sp_crit_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		[EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE] = self.attack_speed_pct,
		EMDF_DAMAGE_CRIT_BONUS
	}
end
function modifier_sp_crit_buff:OnBattleEnd()
	self:Destroy()
end
function modifier_sp_crit_buff:GetAttackSpeedPercentage()
	return self.attack_speed_pct
end
function modifier_sp_crit_buff:GetDamageCritBonus()
	return self.crit_damage, self.crit_chance
end