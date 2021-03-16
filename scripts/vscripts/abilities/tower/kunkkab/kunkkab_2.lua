--Abilities
if kunkkaB_2 == nil then
	kunkkaB_2 = class({ iSearchBehavior = AI_SEARCH_BEHAVIOR_MOST_LINE_TARGET }, nil, ability_base_ai)
end
function kunkkaB_2:GetAOERadius()
	return self:GetSpecialValueFor("stun_radius")
end
function kunkkaB_2:Ghostship(caster_position, target_position)
	local caster = self:GetCaster()
	local ghostship_distance = self:GetSpecialValueFor("ghostship_distance")
	local stun_radius = self:GetSpecialValueFor("stun_radius")
	local ghostship_speed = self:GetSpecialValueFor("ghostship_speed")

	local vDirection = target_position - caster_position
	vDirection.z = 0

	local vTargetPosition = target_position
	local vStartPosition = vTargetPosition - vDirection:Normalized() * ghostship_distance

	-- local hPtclThinker = CreateModifierThinker(caster, self, 'modifier_kunkka_3_particle_marker', {}, vTargetPosition, caster:GetTeamNumber(), false)
	-- hPtclThinker.sBuffName = 'modifier_kunkka_3_particle_marker'
	local particleID = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_kunkka/kunkka_ghostship_marker.vpcf", PATTACH_CUSTOMORIGIN, nil, caster:GetTeamNumber())
	ParticleManager:SetParticleControl(particleID, 0, vTargetPosition)
	ParticleManager:SetParticleControl(particleID, 1, Vector(stun_radius, stun_radius, stun_radius))

	local hModifier = caster:FindModifierByName(self:GetIntrinsicModifierName())
	if IsValid(hModifier) then
		-- hModifier.hPtclThinker = hPtclThinker
		hModifier:AddParticle(particleID, false, false, -1, false, false)
	end

	local thinker = CreateUnitByName("npc_dota_dummy", vStartPosition, false, caster, caster, caster:GetTeamNumber())
	thinker:AddNewModifier(caster, self, "modifier_dummy", nil)
	EmitSoundOn("Ability.Ghostship", thinker)

	local info = {
		Ability = self,
		Source = caster,
		EffectName = "particles/units/heroes/hero_kunkka/kunkka_ghost_ship.vpcf",
		vSpawnOrigin = vStartPosition,
		vVelocity = vDirection:Normalized() * ghostship_speed,
		fDistance = ghostship_distance,
		fStartRadius = stun_radius,
		fEndRadius = stun_radius,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		bProvidesVision = true,
		iVisionTeamNumber = caster:GetTeamNumber(),
		iVisionRadius = stun_radius,
		ExtraData = {
			thinker_index = thinker:entindex(),
			maker_particle_id = particleID,
		},
	}
	ProjectileManager:CreateLinearProjectile(info)

	EmitSoundOnLocationForAllies(caster_position, "Ability.Ghostship.bell", caster)
end
function kunkkaB_2:OnSpellStart()
	local caster = self:GetCaster()
	local caster_position = caster:GetAbsOrigin()
	local target_position = self:GetCursorPosition()
	local stun_radius = self:GetSpecialValueFor("stun_radius")

	self:Ghostship(caster_position, target_position)
end
function kunkkaB_2:OnProjectileThink_ExtraData(vLocation, ExtraData)
	local thinker = EntIndexToHScript(ExtraData.thinker_index or -1)
	if thinker then
		thinker:SetAbsOrigin(vLocation)
	end
end
function kunkkaB_2:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	local hCaster = self:GetCaster()

	if hTarget ~= nil then
		local flDuration = self:GetDuration()
		local flDamage = hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self:GetSpecialValueFor("damage_factor") * 0.01
		if hTarget:HasModifier("modifier_cold_curse") then
			flDamage = flDamage * 2
		end
		hCaster:DealDamage(hTarget, self, flDamage)
		hTarget:AddBuff(hCaster, BUFF_TYPE.STUN, flDuration)
	else
		local thinker = EntIndexToHScript(ExtraData.thinker_index)
		if thinker then
			thinker:StopSound("Ability.Ghostship")
			UTIL_Remove(thinker)
		end
		if ExtraData.maker_particle_id ~= nil then
			ParticleManager:DestroyParticle(ExtraData.maker_particle_id, false)
		end
		EmitSoundOnLocationWithCaster(vLocation, "Ability.Ghostship.crash", hCaster)
		return true
	end
end