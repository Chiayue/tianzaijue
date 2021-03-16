if shredderA_1 == nil then
	shredderA_1 = class({}, nil, base_attack)
end
function shredderA_1:GetAttackProjectile()
	return 'particles/units/heroes/hero_shredder/shredder_chakram.vpcf'
end
function shredderA_1:GetAttackAnimation()
	return RollPercentage(50) and ACT_DOTA_CAST_ABILITY_4 or ACT_DOTA_CAST_ABILITY_6
end
function shredderA_1:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	local hCaster = self:GetCaster()
	if hTarget then
		vLocation = hTarget:GetAbsOrigin()

		if nil ~= self:GetAttackHitSound() then
			hTarget:EmitSound(self:GetAttackHitSound())
		end
		self:OnDamage(hTarget, GetAttackInfo(ExtraData.record, hCaster))
	else
		if ExtraData.bReturn == nil then
			local radius = self:GetSpecialValueFor("radius")
			local distance = self:GetSpecialValueFor("distance")
			if distance <= 0 then distance = hCaster:Script_GetAttackRange() end
			local speed = self:GetSpecialValueFor("speed")
			if speed <= 0 then speed = hCaster:GetProjectileSpeed() end

			local vDir = (hCaster:GetAbsOrigin() - EntIndexToHScript(ExtraData.iTargetIndex):GetAbsOrigin()):Normalized()
			local tInfo = {
				EffectName = self:GetAttackProjectile(),
				Ability = self,
				Source = hCaster,
				vSpawnOrigin = hCaster:GetAbsOrigin() - vDir * distance,
				vVelocity = vDir * speed,
				fDistance = distance,
				fStartRadius = radius,
				fEndRadius = radius,
				-- iUnitTargetTeam = self:GetAbilityTargetTeam(),
				-- iUnitTargetType = self:GetAbilityTargetType(),
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				iUnitTargetFlags = self:GetAbilityTargetFlags(),
				ExtraData = {
					bReturn = true,
					record = ExtraData.record,
				}
			}
			ProjectileManager:CreateLinearProjectile(tInfo)
		else
			self:OnProjectileEnd(hTarget, vLocation, ExtraData)
		end
	end
end
function shredderA_1:DoAttackBehavior(params)
	local hCaster = self:GetCaster()
	local hTarget = params.target

	local speed = self:GetSpecialValueFor("speed")
	if speed <= 0 then speed = hCaster:GetProjectileSpeed() end
	local distance = self:GetSpecialValueFor("distance")
	if distance <= 0 then distance = hCaster:Script_GetAttackRange() end
	local radius = self:GetSpecialValueFor("radius")

	local vDir = (hTarget:GetAbsOrigin() - hCaster:GetAbsOrigin()):Normalized()

	local tInfo = {
		EffectName = self:GetAttackProjectile(),
		Ability = self,
		Source = hCaster,
		vSpawnOrigin = hCaster:GetAbsOrigin(),
		vVelocity = vDir * speed,
		fDistance = distance,
		fStartRadius = radius,
		fEndRadius = radius,
		-- iUnitTargetTeam = self:GetAbilityTargetTeam(),
		-- iUnitTargetType = self:GetAbilityTargetType(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		iUnitTargetFlags = self:GetAbilityTargetFlags(),
		ExtraData = {
			iTargetIndex = hTarget:GetEntityIndex(),
			record = params.record,
		}
	}
	ProjectileManager:CreateLinearProjectile(tInfo)

	local wdith = radius * 0.5
	local vStart = hCaster:GetAbsOrigin()
	local vDirection = hTarget:GetAbsOrigin() - vStart
	vDirection.z = 0
	vDirection = vDirection:Normalized()

	local vEnd = vStart + vDirection * (distance + wdith)
	local v = Rotation2D(vDirection, math.rad(90))
	local tPolygon = {
		(vStart - vDirection * radius) + v * radius,
		vEnd + v * radius,
		vEnd - v * radius,
		(vStart - vDirection * radius) - v * radius,
	}
	DebugDrawLine(tPolygon[1], tPolygon[2], 255, 255, 255, true, hCaster:GetSecondsPerAttack())
	DebugDrawLine(tPolygon[2], tPolygon[3], 255, 255, 255, true, hCaster:GetSecondsPerAttack())
	DebugDrawLine(tPolygon[3], tPolygon[4], 255, 255, 255, true, hCaster:GetSecondsPerAttack())
	DebugDrawLine(tPolygon[4], tPolygon[1], 255, 255, 255, true, hCaster:GetSecondsPerAttack())
end