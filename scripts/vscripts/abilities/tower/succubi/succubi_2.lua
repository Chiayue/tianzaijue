--Abilities
if succubi_2 == nil then
	succubi_2 = class({ iSearchBehavior = AI_SEARCH_BEHAVIOR_MOST_LINE_TARGET }, nil, ability_base_ai)
end
function succubi_2:GetAOERadius()
	return self:GetSpecialValueFor("starting_aoe")
end
function succubi_2:GetAbilityTextureName()
	return "queenofpain_sanguine_scream_of_pain"
end
function succubi_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local delay = self:GetSpecialValueFor("delay")
	local starting_aoe = self:GetSpecialValueFor("starting_aoe")
	local distance = self:GetSpecialValueFor("distance")
	local final_aoe = self:GetSpecialValueFor("final_aoe")
	local speed = self:GetSpecialValueFor("speed")

	local vDirection = vPosition - hCaster:GetAbsOrigin()

	local fOffsetDistance = delay * 200 + starting_aoe

	local vPosition = hCaster:GetAbsOrigin()

	local tInfo = {
		Ability = self,
		Source = hCaster,
		EffectName = "particles/econ/items/queen_of_pain/qop_arcana/qop_arcana_sonic_wave.vpcf",
		vSpawnOrigin = vPosition,
		fDistance = distance,
		fStartRadius = starting_aoe,
		fEndRadius = final_aoe,
		vVelocity = vDirection:Normalized() * speed,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile(tInfo)

	EmitSoundOnLocationWithCaster(vPosition, AssetModifiers:GetSoundReplacement("Hero_QueenOfPain.SonicWave", hCaster), hCaster)
end

function succubi_2:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if IsValid(hTarget) then
		local hCaster = self:GetCaster()
		local damage = self:GetSpecialValueFor("damage")
		local bleeding_duration = self:GetSpecialValueFor("bleeding_duration")
		local debuffCount = 1
		EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), AssetModifiers:GetSoundReplacement("Hero_QueenOfPain.ShadowStrike.Target", hCaster), hCaster)
		-- if hTarget:HasModifier("modifier_succubi_1_shadow_strike_debuff") then
		-- 	debuffCount = hTarget:GetModifierStackCount("modifier_succubi_1_shadow_strike_debuff", hCaster)
		-- else
		-- 	debuffCount = 1
		-- end
		if hTarget:HasModifier("modifier_poison") then
			debuffCount = hTarget:FindModifierByName("modifier_poison"):GetStackCount()
		else
			debuffCount = 1
		end

		local tDamageTable = {
			ability = self,
			victim = hTarget,
			attacker = hCaster,
			damage = damage * 0.01 * hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) * debuffCount + hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) * self:GetSpecialValueFor("bonus_damage") * 0.01,
			damage_type = self:GetAbilityDamageType(),
		}
		ApplyDamage(tDamageTable)
		return false
	end

	return true
end