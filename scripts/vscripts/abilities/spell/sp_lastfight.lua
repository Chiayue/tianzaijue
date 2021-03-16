LinkLuaModifier("modifier_sp_lastfight_buff", "abilities/spell/sp_lastfight.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_general_sp_lastfight", "abilities/spell/sp_lastfight.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_lastfight == nil then
	sp_lastfight = class({}, nil, sp_base)
end
function sp_lastfight:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_lastfight:OnSpellStart()
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
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(90, 26, 206))
	ParticleManager:SetParticleControl(iParticleID, 4, Vector(89, 0, 255))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(vPosition, "Hero_LifeStealer.OpenWounds.Cast", hCaster)

	local tTargets = FindUnitsInRadius(iTeamNumber, vPosition, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), 0, false)
	for i, hTarget in pairs(tTargets) do
		hTarget:AddNewModifier(hCaster, self, "modifier_sp_lastfight_buff", { duration = duration })
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_lastfight_buff == nil then
	modifier_sp_lastfight_buff = class({}, nil, eom_modifier)
end
function modifier_sp_lastfight_buff:IsHidden()
	return false
end
function modifier_sp_lastfight_buff:IsDebuff()
	return false
end
function modifier_sp_lastfight_buff:IsPurgable()
	return true
end
function modifier_sp_lastfight_buff:IsPurgeException()
	return true
end
function modifier_sp_lastfight_buff:AllowIllusionDuplicate()
	return false
end
function modifier_sp_lastfight_buff:OnCreated(params)
	self.base_attack_bonus_pct = self:GetAbilitySpecialValueFor("base_attack_bonus_pct")
	self.hp_loss = self:GetAbilitySpecialValueFor("hp_loss")
	self.extra_attack_bonus_pct = self:GetAbilitySpecialValueFor("extra_attack_bonus_pct")
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/items_fx/armlet.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_sp_lastfight_buff:EDeclareFunctions()
	return {
		EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE
	}
end
function modifier_sp_lastfight_buff:GetMagicalAttackBonusPercentage(params)
	return self.base_attack_bonus_pct + math.floor((100-self:GetParent():GetHealthPercent()) / self.hp_loss)*self.extra_attack_bonus_pct
end
function modifier_sp_lastfight_buff:GetPhysicalAttackBonusPercentage(params)
	return self.base_attack_bonus_pct + math.floor((100-self:GetParent():GetHealthPercent()) / self.hp_loss)*self.extra_attack_bonus_pct
end
function modifier_sp_lastfight_buff:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_sp_lastfight_buff:OnTooltip()
	return self.base_attack_bonus_pct + math.floor((100-self:GetParent():GetHealthPercent()) / self.hp_loss)*self.extra_attack_bonus_pct
end