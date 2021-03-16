LinkLuaModifier("modifier_nian_8_thinker", "abilities/boss/nian_8.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if nian_8 == nil then
	nian_8 = class({})
end
function nian_8:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	hCaster:AddBuff(hCaster, BUFF_TYPE.TENACITY, self:GetCastPoint())
	hCaster:StartGestureWithPlaybackRate(ACT_DOTA_AREA_DENY, 1.8)

	local interval_distance = self:GetSpecialValueFor("interval_distance")
	local max_count = self:GetSpecialValueFor("count")
	local interval = self:GetSpecialValueFor("interval")
	local vDirection = (self:GetCursorPosition() - hCaster:GetAbsOrigin()):Normalized()
	local vCenter = hCaster:GetAbsOrigin() + vDirection * 800
	local count = 0
	hCaster:GameTimer(0.85, function()
		if count < max_count then
			local vPosition = GetGroundPosition(vCenter + vDirection * interval_distance * count, hCaster)
			local hThinker = CreateModifierThinker(hCaster, self, "modifier_nian_8_thinker", { duration = 0.2 }, vPosition, hCaster:GetTeamNumber(), false)
			count = count + 1
			return interval
		end
	end)

	return true
end
function nian_8:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:FadeGesture(ACT_DOTA_AREA_DENY)
end
---------------------------------------------------------------------
if modifier_nian_8_thinker == nil then
	modifier_nian_8_thinker = class({}, nil, ParticleModifierThinker)
end
function modifier_nian_8_thinker:OnCreated(params)
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/boss/nian/nian_8.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(1200, 0, 0))
		ParticleManager:SetParticleControl(iParticleID, 10, Vector(1, 0, 0))
		ParticleManager:SetParticleControl(iParticleID, 11, Vector(1, 1, 0))
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
function modifier_nian_8_thinker:OnDestroy()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
		for _, hUnit in ipairs(tTargets) do
			hCaster:DealDamage(hUnit, self:GetAbility())
			hUnit:AddBuff(hCaster, BUFF_TYPE.STUN, self.stun_duration)
		end
		EmitGlobalSound("Hero_ElderTitan.EchoStomp.ti7")
		-- hCaster:EmitSound("Hero_ElderTitan.EchoStomp.ti7")
		if IsValid(self:GetParent()) then
			self:GetParent():RemoveSelf()
		end
	end
end