LinkLuaModifier("modifier_darkmoon_assassin_2", "abilities/tower/darkmoon_assassin/darkmoon_assassin_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_darkmoon_assassin_2_buff", "abilities/tower/darkmoon_assassin/darkmoon_assassin_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if darkmoon_assassin_2 == nil then
	darkmoon_assassin_2 = class({})
end
function darkmoon_assassin_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = hCaster:GetAbsOrigin()
	local flDistance = self:GetSpecialValueFor("distance")
	local dagger_count = self:GetSpecialValueFor("dagger_count")
	local width = self:GetSpecialValueFor("width")
	for i = 1, dagger_count do
		local vDirection = AnglesToVector(QAngle(0, i * 360 / dagger_count, 0)):Normalized()
		local info = {
			Ability = self,
			Source = hCaster,
			EffectName = "particles/units/heroes/darkmoon_assassin/darkmoon_assassin_3_linear.vpcf",
			vSpawnOrigin = hCaster:GetAbsOrigin(),
			vVelocity = vDirection * flDistance * 2,
			fDistance = flDistance,
			fStartRadius = width,
			fEndRadius = width,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			ExtraData = {
				bReturn = 0,
			}
		}
		ProjectileManager:CreateLinearProjectile(info)

		hCaster:EmitSound("Hero_PhantomAssassin.Blur")
	end
end
function darkmoon_assassin_2:GetAOERadius()
	return self:GetCastRange(vec3_invalid, nil)
end
function darkmoon_assassin_2:OnProjectileThink_ExtraData(vLocation, ExtraData)
	local hCaster = self:GetCaster()
	local flDamage = hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self:GetSpecialValueFor("physical_factor") * 0.01
	local hAbility = hCaster:FindAbilityByName("darkmoon_assassin_3")
	if IsValid(hAbility) and hAbility:GetLevel() > 0 then
		flDamage = hAbility:GetCritValue(flDamage)
	end
	if ExtraData.bReturn == 1 then
		local tHash = GetHashtableByIndex(ExtraData.iHashIndex)
		if tHash then
			local tTargets = FindUnitsInRadiusWithAbility(hCaster, vLocation, self:GetSpecialValueFor("width"), self)
			for _, hUnit in ipairs(tTargets) do
				if TableFindKey(tHash, hUnit) == nil then
					table.insert(tHash, hUnit)
					local iParticleID = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_slash_tgt.vpcf", PATTACH_ABSORIGIN, hUnit)
					ParticleManager:SetParticleControl(iParticleID, 1, vLocation)
					ParticleManager:ReleaseParticleIndex(iParticleID)
					hCaster:DealDamage(hUnit, self, flDamage)
				end
			end
		end
	end
end
function darkmoon_assassin_2:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	local hCaster = self:GetCaster()
	local flDamage = hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self:GetSpecialValueFor("physical_factor") * 0.01
	local hAbility = hCaster:FindAbilityByName("darkmoon_assassin_3")
	if IsValid(hAbility) and hAbility:GetLevel() > 0 then
		flDamage = hAbility:GetCritValue(flDamage)
	end
	if hTarget ~= nil then
		if hCaster ~= hTarget then
			hCaster:DealDamage(hTarget, self, flDamage)
			local iParticleID = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_slash_tgt.vpcf", PATTACH_ABSORIGIN, hTarget)
			ParticleManager:SetParticleControl(iParticleID, 1, vLocation)
			ParticleManager:ReleaseParticleIndex(iParticleID)
		else
			RemoveHashtable(ExtraData.iHashIndex)
		end
	else
		if ExtraData.bReturn == 0 then
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/darkmoon_assassin/darkmoon_assassin_3_static.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, vLocation)
			self:GameTimer(1, function()
				ParticleManager:DestroyParticle(iParticleID, true)
				local tHash, iHashIndex = CreateHashtable()
				local info = {
					EffectName = "particles/units/heroes/darkmoon_assassin/darkmoon_assassin_3_track.vpcf",
					Ability = self,
					iMoveSpeed = 2500 + (vLocation - hCaster:GetAbsOrigin()):Length2D(),
					Target = hCaster,
					vSourceLoc = vLocation,
					ExtraData = {
						bReturn = 1,
						iHashIndex = iHashIndex
					}
				}
				ProjectileManager:CreateTrackingProjectile(info)
				hCaster:EmitSound("Hero_PhantomAssassin.Blur.Break")
			end)
		end
	end
end