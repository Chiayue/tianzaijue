--Abilities
if bounty_hunter_1 == nil then
	bounty_hunter_1 = class({ iOrderType = FIND_CLOSEST }, nil, ability_base_ai)
end
function bounty_hunter_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	self:Shuriken(hCaster, hTarget)
end
function bounty_hunter_1:Shuriken(hSource, hTarget, iBounceCount)
	local hCaster = self:GetCaster()
	local info = {
		EffectName = "particles/units/heroes/hero_bounty_hunter/bounty_hunter_suriken_toss.vpcf",
		Ability = self,
		iMoveSpeed = 2000,
		Source = hSource,
		Target = hTarget,
		iSourceAttachment = hSource == hCaster and DOTA_PROJECTILE_ATTACHMENT_ATTACK_1 or DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		vSourceLoc = hCaster:GetAbsOrigin(),
		bDodgeable = true,
		ExtraData = {
			bounce_count = iBounceCount or self:GetSpecialValueFor("bounce_count")
		}
	}
	ProjectileManager:CreateTrackingProjectile(info)
	-- sound
	hCaster:EmitSound("Hero_BountyHunter.Shuriken")
	self:UseResources(false, false, true)
end
function bounty_hunter_1:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if hTarget ~= nil then
		local hCaster = self:GetCaster()
		hCaster:DealDamage(hTarget, self, self:GetAbilityDamage())
		if ExtraData.bounce_count > 0 then
			local tTargets = FindUnitsInRadiusWithAbility(hCaster, vLocation, self:GetSpecialValueFor("bounce_radius"), self, FIND_CLOSEST)
			ArrayRemove(tTargets, hTarget)
			if tTargets[1] then
				self:Shuriken(hTarget, tTargets[1], ExtraData.bounce_count - 1)
			end
		end
	end
end
function bounty_hunter_1:GetIntrinsicModifierName()
	return "modifier_bounty_hunter_1"
end