LinkLuaModifier("modifier_luna_3_slow", "abilities/tower/luna/luna_3.lua", LUA_MODIFIER_MOTION_NONE)
if luna_3 == nil then
	luna_3 = class({iSearchBehavior = AI_SEARCH_BEHAVIOR_MOST_AOE_TARGET}, nil, ability_base_ai)
end
function luna_3:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function luna_3:OnAbilityPhaseStart()
	local iPreParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_luna/luna_lucent_beam_precast.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
	ParticleManager:SetParticleControlEnt(iPreParticleID, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(iPreParticleID)
	return true
end
function luna_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	if hTarget:TriggerSpellAbsorb(self) then
		return
	end

	local iAtk = hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack)
	local moon_damage = self:GetSpecialValueFor("moon_damage_per") * 0.01 * iAtk
	local star_damage = self:GetSpecialValueFor("star_damage_per") * 0.01 * iAtk

	local radius = self:GetSpecialValueFor("radius")
	local slow_per = self:GetSpecialValueFor("slow_per")
	local slow_duration = self:GetSpecialValueFor("slow_duration")
	local pull_duration = self:GetSpecialValueFor("pull_duration")

	--月光
	local iParticleID = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_luna/luna_lucent_beam.vpcf", hCaster), PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticleID, 5, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticleID, 6, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_Luna.LucentBeam.Target", hCaster)

	hTarget:AddNewModifier(hCaster, self, 'modifier_knockback', {
		duration = pull_duration,
		knockback_duration = pull_duration,
		center_x = hTarget:GetAbsOrigin().x,
		center_y = hTarget:GetAbsOrigin().y,
		center_z = hTarget:GetAbsOrigin().z,
		should_stun = 0,
		knockback_distance = 0,
		knockback_height = 200,
	})

	local tDamageTable = {
		ability = self,
		attacker = hCaster,
		victim = hTarget,
		damage = moon_damage,
		damage_type = self:GetAbilityDamageType()
	}
	ApplyDamage(tDamageTable)

	hCaster:EmitSound("Hero_Luna.LucentBeam.Cast")

	--牵引
	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hTarget:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
	for n, hTarget2 in pairs(tTargets) do
		if hTarget2 ~= hTarget then
			local vDir = (hTarget2:GetAbsOrigin() - hTarget:GetAbsOrigin()):Normalized()
			local vCenter = vDir * 100 + hTarget2:GetAbsOrigin()
			local fLen = (hTarget2:GetAbsOrigin() - hTarget:GetAbsOrigin()):Length2D()
			hTarget2:AddNewModifier(hCaster, self, 'modifier_knockback', {
				duration = pull_duration,
				knockback_duration = pull_duration,
				center_x = vCenter.x,
				center_y = vCenter.y,
				center_z = vCenter.z,
				should_stun = 0,
				knockback_distance = fLen * 0.5,
				knockback_height = 150 * (fLen / radius),
			})
		end
	end

	local particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_mirana/mirana_starfall_moonray.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hTarget)
	ParticleManager:SetParticleControl(particleID, 1, Vector(radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(particleID)

	--流星
	hCaster:GameTimer(0.1, function()
		for n, hTarget2 in pairs(tTargets) do
			if IsValid(hTarget2) then
				local particleID = ParticleManager:CreateParticle('particles/units/heroes/luna/luan_3_star.vpcf', PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControlEnt(particleID, 0, hTarget2, PATTACH_CUSTOMORIGIN_FOLLOW, nil, hTarget2:GetAbsOrigin(), true)
				ParticleManager:SetParticleControl(particleID, 5, Vector(0.5, 0, 0))
				ParticleManager:ReleaseParticleIndex(particleID)

				local hTargetTmp = hTarget2
				hTarget2:GameTimer(0.5, function()
					EmitSoundOnLocationWithCaster(hTargetTmp:GetAbsOrigin(), "Ability.StarfallImpact", hCaster)

					hTarget2:AddNewModifier(hCaster, self, 'modifier_luna_3_slow', { duration = slow_duration })

					tDamageTable.victim = hTargetTmp
					tDamageTable.damage = star_damage
					ApplyDamage(tDamageTable)
				end)
			end
		end
		hCaster:EmitSound("Ability.Starfall")
	end)

end
---------------------------------------------------------------------
--Modifiers
if modifier_luna_3_slow == nil then
	modifier_luna_3_slow = class({}, nil, eom_modifier)
end
function modifier_luna_3_slow:IsDebuff()
	return true
end
function modifier_luna_3_slow:OnCreated(table)
	self.slow_per = self:GetAbilitySpecialValueFor("slow_per")
end
function modifier_luna_3_slow:OnRefresh(table)
	self.slow_per = self:GetAbilitySpecialValueFor("slow_per")
end
function modifier_luna_3_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_luna_3_slow:EDeclareFunctions()
	return {
		EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE
	}
end
function modifier_luna_3_slow:GetMoveSpeedBonusPercentage()
	return -self.slow_per * self:GetParent():GetStatusResistanceFactor(self:GetCaster())
end
function modifier_luna_3_slow:OnTooltip()
	return self.slow_per
end