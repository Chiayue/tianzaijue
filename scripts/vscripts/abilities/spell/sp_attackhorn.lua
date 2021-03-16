LinkLuaModifier("modifier_sp_attackhorn_buff", "abilities/spell/sp_attackhorn.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_attackhorn == nil then
	sp_attackhorn = class({}, nil, sp_base)
end
function sp_attackhorn:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_attackhorn:OnSpellStart()
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
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(160, 82, 45))
	ParticleManager:SetParticleControl(iParticleID, 4, Vector(139, 69, 19))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(vPosition, "Hero_OgreMagi.Bloodlust.Target", hCaster)

	local tTargets = FindUnitsInRadius(iTeamNumber, vPosition, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), 0, false)
	for i, hTarget in pairs(tTargets) do
		hTarget:AddNewModifier(hCaster, self, "modifier_sp_attackhorn_buff", { duration = duration })
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_attackhorn_buff == nil then
	modifier_sp_attackhorn_buff = class({}, nil, eom_modifier)
end
function modifier_sp_attackhorn_buff:IsDebuff()
	return false
end
function modifier_sp_attackhorn_buff:IsHidden()
	return false
end
function modifier_sp_attackhorn_buff:IsPurgable()
	return true
end
function modifier_sp_attackhorn_buff:IsPurgeException()
	return true
end
function modifier_sp_attackhorn_buff:GetEffectName()
	return "particles/econ/items/invoker/invoker_ti7/invoker_ti7_alacrity_buff.vpcf"
end
function modifier_sp_attackhorn_buff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
function modifier_sp_attackhorn_buff:ShouldUseOverheadOffset()
	return true
end
function modifier_sp_attackhorn_buff:OnCreated(params)
	self.base_recover = self:GetAbilitySpecialValueFor("base_recover")
	self.recocer_pct = self:GetAbilitySpecialValueFor("recocer_pct")
end
function modifier_sp_attackhorn_buff:OnRefresh(params)
	self.base_recover = self:GetAbilitySpecialValueFor("base_recover")
	self.recocer_pct = self:GetAbilitySpecialValueFor("recocer_pct")
end
function modifier_sp_attackhorn_buff:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK] = { self:GetParent() },
	}
end
function modifier_sp_attackhorn_buff:OnAttack(params)
	local hParent = self:GetParent()
	hParent:Heal(self.base_recover + hParent:GetMaxHealth() * self.recocer_pct * 0.01, self:GetAbility())
end
function modifier_sp_attackhorn_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_sp_attackhorn_buff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self.base_recover
	elseif self._tooltip == 2 then
		return self.recocer_pct
	end
end