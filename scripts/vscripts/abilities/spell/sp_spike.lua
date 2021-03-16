LinkLuaModifier("modifier_sp_spike_debuff", "abilities/spell/sp_spike.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_spike == nil then
	sp_spike = class({}, nil, sp_base)
end
function sp_spike:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_spike:OnSpellStart()
	local hCaster = self:GetCaster()
	local PlayerID = hCaster:GetPlayerOwnerID()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local vPosition = self:GetCursorPosition()
	local iTeamNumber = hCaster:GetTeamNumber()

	DotaTD:EachPlayer(function(_, iPlayerID)
		if PlayerData:IsPointInPlayerRange(iPlayerID, vPosition) then
			iTeamNumber = PlayerData:GetHero(iPlayerID):GetTeamNumber()
		end
	end)

	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_blinding_light_aoe.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(radius, 1, 1))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(vPosition, "Hero_KeeperOfTheLight.BlindingLight", hCaster)

	local tTargets = FindUnitsInRadius(iTeamNumber, vPosition, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
	for _, hTarget in pairs(tTargets) do
		hTarget:AddNewModifier(hCaster, self, "modifier_sp_spike_debuff", { duration = GetStatusDebuffDuration(duration, hTarget, hCaster) })
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_spike_debuff == nil then
	modifier_sp_spike_debuff = class({}, nil, eom_modifier)
end
function modifier_sp_spike_debuff:IsHidden()
	return false
end
function modifier_sp_spike_debuff:IsDebuff()
	return true
end
function modifier_sp_spike_debuff:IsPurgable()
	return true
end
function modifier_sp_spike_debuff:IsPurgeException()
	return true
end
function modifier_sp_spike_debuff:IsStunDebuff()
	return false
end
function modifier_sp_spike_debuff:GetEffectName()
	return "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_blinding_light_debuff.vpcf"
end
function modifier_sp_spike_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_sp_spike_debuff:OnCreated(params)
	self.miss_chance = self:GetAbilitySpecialValueFor("miss_chance")
end
function modifier_sp_spike_debuff:OnRefresh(params)
	self.miss_chance = self:GetAbilitySpecialValueFor("miss_chance")
end
function modifier_sp_spike_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
	}
end
function modifier_sp_spike_debuff:GetModifierMiss_Percentage()
	return self.miss_chance
end
function modifier_sp_spike_debuff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_sp_spike_debuff:OnBattleEnd()
	self:Destroy()
end
