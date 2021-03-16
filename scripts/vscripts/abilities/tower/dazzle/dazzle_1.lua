--Abilities
if dazzle_1 == nil then
	dazzle_1 = class({})

	local funcSortFunction = function(a, b, hCaster)
		if a == hCaster then
			return false
		elseif b == hCaster then
			return true
		end
		-- 优先损失血多的
		if a:GetHealth()/a:GetMaxHealth() < b:GetHealth()/b:GetMaxHealth() then
			return true
		elseif a:GetHealth()/a:GetMaxHealth() > b:GetHealth()/b:GetMaxHealth() then
			return false
		end
		return false
	end

	dazzle_1 = class({ funcSortFunction = funcSortFunction }, nil, ability_base_ai)
end
function dazzle_1:ShadowWave(hTarget, tAllUnits, iCount)
	ArrayRemove(tAllUnits, hTarget)

	local hCaster = self:GetCaster()
	local bounce_radius = self:GetSpecialValueFor("bounce_radius")
	local max_targets = self:GetSpecialValueFor("max_targets")
	local radius = self:GetSpecialValueFor("radius")
	local fDuration = self:GetDuration()

	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_shadow_wave_impact_heal.vpcf", PATTACH_CUSTOMORIGIN, hTarget)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false)
	ParticleManager:ReleaseParticleIndex(iParticleID)

	local fAmount = hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) * self:GetSpecialValueFor("heal_factor") * 0.01
	hTarget:Heal(fAmount, self)

	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hTarget:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
	for _, hUnit in pairs(tTargets) do
		hUnit:AddBuff(hCaster, BUFF_TYPE.INJURY, fDuration, true)
	end

	iCount = iCount + 1

	if iCount < max_targets then
		table.sort(tAllUnits, function(a, b)
			return CalcDistanceBetweenEntityOBB(a, hTarget) < CalcDistanceBetweenEntityOBB(b, hTarget)
		end)
		for n, hNewTarget in pairs(tAllUnits) do
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(iParticleID, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(iParticleID, 1, hNewTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hNewTarget:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(iParticleID)

			self:ShadowWave(hNewTarget, tAllUnits, iCount)
			break
		end
	end
end
function dazzle_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	local iPlayerID = GetPlayerID(hCaster)

	local tAllUnits = {}
	EachUnits(iPlayerID, function(hUnit)
		if hUnit:IsAlive() and hUnit ~= hCaster then
			table.insert(tAllUnits, hUnit)
		end
	end, UnitType.AllFirends)

	local bounce_radius = self:GetSpecialValueFor("bounce_radius")
	local max_targets = self:GetSpecialValueFor("max_targets")
	local radius = self:GetSpecialValueFor("radius")
	local fDuration = self:GetDuration()

	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
	ParticleManager:ReleaseParticleIndex(iParticleID)

	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_shadow_wave_impact_heal.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
	ParticleManager:ReleaseParticleIndex(iParticleID)

	local fAmount = hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) * self:GetSpecialValueFor("heal_factor") * 0.01
	hCaster:Heal(fAmount, self)

	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
	for _, hUnit in pairs(tTargets) do
		hUnit:AddBuff(hCaster, BUFF_TYPE.INJURY, fDuration, true)
	end

	hCaster:EmitSound("Hero_Dazzle.Shadow_Wave")

	if hTarget ~= hCaster then
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false)
		ParticleManager:ReleaseParticleIndex(iParticleID)

		self:ShadowWave(hTarget, tAllUnits, 1)
	else
		if 1 < max_targets then
			table.sort(tAllUnits, function(a, b)
				return CalcDistanceBetweenEntityOBB(a, hTarget) < CalcDistanceBetweenEntityOBB(b, hTarget)
			end)
			for n, hNewTarget in pairs(tAllUnits) do
				local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(iParticleID, 1, hNewTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hNewTarget:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(iParticleID)

				self:ShadowWave(hNewTarget, tAllUnits, 1)
				break
			end
		end
	end
end