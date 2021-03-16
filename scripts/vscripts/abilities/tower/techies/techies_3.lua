if techies_3 == nil then
	techies_3 = class({})
end
function techies_3:Trigger(hTarget)
	local hCaster = self:GetCaster()
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	local air_duration = self:GetSpecialValueFor("air_duration")

	hCaster:KnockBack(hTarget:GetAbsOrigin(), hTarget, 0, 350, stun_duration, true, air_duration)

	-- 伤害
	hCaster:DealDamage(hTarget, self, 0)
	-- 特效
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lion/lion_spell_impale_hit_spikes.vpcf", PATTACH_ABSORIGIN, hTarget)
	ParticleManager:SetParticleControlEnt(iParticleID, 2, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	-- 音效
	EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_Lion.ImpaleHitTarget", hCaster)
end