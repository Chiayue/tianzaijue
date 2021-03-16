LinkLuaModifier("modifier_sp_upheavals_motion", "abilities/spell/sp_upheavals.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
--Abilities
if sp_upheavals == nil then
	sp_upheavals = class({}, nil, sp_base)
end
function sp_upheavals:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_upheavals:OnSpellStart()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local pull_duration = self:GetSpecialValueFor("pull_duration")
	local damage_pct = self:GetSpecialValueFor("damage_pct")
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	local vPosition = self:GetCursorPosition()
	local iTeamNumber = hCaster:GetTeamNumber()

	DotaTD:EachPlayer(function(_, iPlayerID)
		if PlayerData:IsPointInPlayerRange(iPlayerID, vPosition) then
			iTeamNumber = PlayerData:GetHero(iPlayerID):GetTeamNumber()
		end
	end)

	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_vacuum.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, radius, radius))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	local iParticleID = ParticleManager:CreateParticle("particles/econ/generic/generic_aoe_shockwave_1/generic_aoe_shockwave_1.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(pull_duration, 20, 1))
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(72, 61, 139))
	ParticleManager:SetParticleControl(iParticleID, 4, Vector(106, 90, 205))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(vPosition, "Hero_Dark_Seer.Vacuum", hCaster)

	local tTargets = FindUnitsInRadius(iTeamNumber, vPosition, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), 0, false)
	for i, hTarget in pairs(tTargets) do
		if not hTarget:IsBoss() and not hTarget:IsGoldWave() then
			local fDamage = hTarget:GetMaxHealth() * damage_pct * 0.01
			ApplyDamage({
				attacker = hCaster,
				victim = hTarget,
				ability = self,
				damage = fDamage,
				damage_type = self:GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_SPELL,
			})

			hTarget:AddNewModifier(hCaster, self, "modifier_sp_upheavals_motion", { duration = GetStatusDebuffDuration(pull_duration, hTarget, hCaster), position = vPosition })
			hTarget:AddNewModifier(hCaster, self, "modifier_stunned", { duration = GetStatusDebuffDuration(stun_duration+pull_duration, hTarget, hCaster) })
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_upheavals_motion == nil then
	modifier_sp_upheavals_motion = class({})
end
function modifier_sp_upheavals_motion:IsHidden()
	return false
end
function modifier_sp_upheavals_motion:IsDebuff()
	return true
end
function modifier_sp_upheavals_motion:IsPurgable()
	return false
end
function modifier_sp_upheavals_motion:IsPurgeException()
	return false
end
function modifier_sp_upheavals_motion:RemoveOnDeath()
	return false
end
function modifier_sp_upheavals_motion:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end
function modifier_sp_upheavals_motion:OnCreated(params)
	local hParent = self:GetParent()
	self.pull_duration = self:GetAbilitySpecialValueFor("pull_duration")
	if IsServer() then
		local vPosition = StringToVector(params.position)
		if vPosition == nil then
			self:Destroy()
			return
		end
		if self:ApplyHorizontalMotionController() then
			self.vStart = hParent:GetAbsOrigin()
			self.vEnd = vPosition
		else
			self:Destroy()
		end
	end
end
function modifier_sp_upheavals_motion:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)
	end
end
function modifier_sp_upheavals_motion:UpdateHorizontalMotion(hParent, dt)
	if IsServer() then
		if hParent then
			hParent:SetAbsOrigin(VectorLerp(self:GetElapsedTime() / self.pull_duration, self.vStart, self.vEnd))
		end
	end
end
function modifier_sp_upheavals_motion:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_sp_upheavals_motion:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end
function modifier_sp_upheavals_motion:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end
function modifier_sp_upheavals_motion:GetOverrideAnimation(params)
	return ACT_DOTA_FLAIL
end