LinkLuaModifier("modifier_pugna_1_thinker", "abilities/tower/pugna/pugna_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if pugna_1 == nil then
	pugna_1 = class({iSearchBehavior=AI_SEARCH_BEHAVIOR_MOST_AOE_TARGET}, nil, ability_base_ai)
end
function pugna_1:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function pugna_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local delay = self:GetSpecialValueFor("delay")

	CreateModifierThinker(hCaster, self, "modifier_pugna_1_thinker", {duration=delay}, vPosition, hCaster:GetTeamNumber(), false)
end
---------------------------------------------------------------------
--Modifiers
if modifier_pugna_1_thinker == nil then
	modifier_pugna_1_thinker = class({})
end
function modifier_pugna_1_thinker:IsHidden()
	return true
end
function modifier_pugna_1_thinker:IsDebuff()
	return false
end
function modifier_pugna_1_thinker:IsPurgable()
	return false
end
function modifier_pugna_1_thinker:IsPurgeException()
	return false
end
function modifier_pugna_1_thinker:IsStunDebuff()
	return false
end
function modifier_pugna_1_thinker:AllowIllusionDuplicate()
	return false
end
function modifier_pugna_1_thinker:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.blast_damage = self:GetAbilitySpecialValueFor("blast_damage")
	if IsServer() then
		self.vPosition = self:GetParent():GetAbsOrigin()

		EmitSoundOnLocationWithCaster(self.vPosition, "Hero_Pugna.NetherBlastPreCast", self:GetCaster())

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_netherblast_pre.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self.vPosition)
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, self:GetDuration(), 0))
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
function modifier_pugna_1_thinker:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_pugna_1_thinker:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		hParent:RemoveSelf()

		local hCaster = self:GetCaster()
		local hAbility = self:GetAbility()
		if not IsValid(hCaster) or not IsValid(hAbility) then
			self:Destroy()
			return
		end

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_netherblast.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self.vPosition)
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, self.radius, self.radius))
		ParticleManager:ReleaseParticleIndex(iParticleID)

		EmitSoundOnLocationWithCaster(self.vPosition, "Hero_Pugna.NetherBlast", hCaster)

		local fDamage = self.blast_damage * hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack)*0.01

		local tTargets = FindUnitsInRadiusWithAbility(hCaster, self.vPosition, self.radius, hAbility, FIND_CLOSEST)
		for _, hTarget in pairs(tTargets) do
			ApplyDamage({
				attacker = hCaster,
				victim = hTarget,
				ability = hAbility,
				damage = fDamage,
				damage_type = hAbility:GetAbilityDamageType(),
			})
		end
	end
end
function modifier_pugna_1_thinker:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true
	}
end