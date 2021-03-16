LinkLuaModifier("modifier_sp_breakarmor_buff", "abilities/spell/sp_breakarmor.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_breakarmor == nil then
	sp_breakarmor = class({}, nil, sp_base)
end
function sp_breakarmor:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_breakarmor:OnSpellStart()
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
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(1, 10, 1))
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(122, 122, 255))
	ParticleManager:SetParticleControl(iParticleID, 4, Vector(129, 129, 255))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(vPosition, "Item.StarEmblem.Enemy", hCaster)

	local tTargets = FindUnitsInRadius(iTeamNumber, vPosition, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
	for _, hTarget in pairs(tTargets) do
		hTarget:AddNewModifier(hCaster, self, "modifier_sp_breakarmor_buff", { duration = duration })
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_breakarmor_buff == nil then
	modifier_sp_breakarmor_buff = class({}, nil, eom_modifier)
end
function modifier_sp_breakarmor_buff:IsHidden()
	return false
end
function modifier_sp_breakarmor_buff:IsDebuff()
	return false
end
function modifier_sp_breakarmor_buff:IsPurgable()
	return true
end
function modifier_sp_breakarmor_buff:IsPurgeException()
	return true
end
function modifier_sp_breakarmor_buff:IsStunDebuff()
	return false
end
function modifier_sp_breakarmor_buff:GetEffectName()
	return "particles/items3_fx/mage_slayer_debuff.vpcf"
end
function modifier_sp_breakarmor_buff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
function modifier_sp_breakarmor_buff:ShouldUseOverheadOffset()
	return true
end
function modifier_sp_breakarmor_buff:OnCreated(params)
	self.ignore_armor_pct = self:GetAbilitySpecialValueFor("ignore_armor_pct")
end
function modifier_sp_breakarmor_buff:OnRefresh(params)
	self.ignore_armor_pct = self:GetAbilitySpecialValueFor("ignore_armor_pct")
end
function modifier_sp_breakarmor_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		[EMDF_ARMOR_IGNORE_PERCENTAGE] = self.ignore_armor_pct
	}
end
function modifier_sp_breakarmor_buff:GetArmorIgnorePercentage()
	return self.ignore_armor_pct
end
function modifier_sp_breakarmor_buff:OnBattleEnd()
	self:Destroy()
end
function modifier_sp_breakarmor_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_sp_breakarmor_buff:OnTooltip()
	return self.ignore_armor_pct
end