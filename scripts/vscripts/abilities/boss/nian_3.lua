--Abilities
if nian_3 == nil then
	nian_3 = class({})
end
function nian_3:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	hCaster:AddBuff(hCaster, BUFF_TYPE.TENACITY, self:GetCastPoint())
	hCaster:StartGestureWithPlaybackRate(ACT_SMALL_FLINCH, 1)
	return true
end
function nian_3:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:FadeGesture(ACT_SMALL_FLINCH)
	hCaster:AddBuff(hCaster, BUFF_TYPE.STUN, 1.3)
	hCaster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_6, 1.5)

	local radius = self:GetSpecialValueFor("radius")
	local stomp_radius = self:GetSpecialValueFor("stomp_radius")
	local stun_duration = self:GetSpecialValueFor("stun_duration")

	-- 狂暴状态下扔的更高
	local height = hCaster:HasModifier("modifier_nian_7_knockdown_rage") and 1000 or 800

	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAttachmentOrigin(hCaster:ScriptLookupAttachment("attach_mouthbase")), radius, self)
	for _, hUnit in ipairs(tTargets) do
		local vCenter = hUnit:GetAbsOrigin() + hCaster:GetForwardVector() * 900
		hCaster:KnockBack(vCenter, hUnit, 1000, height, 0.7, true, 0.7, true)
	end
	hCaster:GameTimer(1.3, function()
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAttachmentOrigin(hCaster:ScriptLookupAttachment("attach_stump")), stomp_radius, self)
		for _, hUnit in ipairs(tTargets) do
			hCaster:DealDamage(hUnit, self)
			-- 狂暴状态有额外一次伤害
			if hCaster:HasModifier("modifier_nian_7_knockdown_rage") then
				hCaster:DealDamage(hUnit, self)
			end
			hUnit:AddBuff(hCaster, BUFF_TYPE.STUN, stun_duration)
		end
		local iParticleID = ParticleManager:CreateParticle('particles/units/boss/nian/nian_stomp.vpcf', PATTACH_ABSORIGIN, hCaster)
		ParticleManager:SetParticleControl(iParticleID, 0, hCaster:GetAttachmentOrigin(hCaster:ScriptLookupAttachment("attach_stump")))
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(stomp_radius, stomp_radius, stomp_radius))
		ParticleManager:ReleaseParticleIndex(iParticleID)
		hCaster:EmitSound('Hero_Centaur.HoofStomp')
	end)
end