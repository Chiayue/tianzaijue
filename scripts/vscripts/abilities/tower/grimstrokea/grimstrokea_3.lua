LinkLuaModifier( "modifier_grimstrokeA_3", "abilities/tower/grimstrokeA/grimstrokeA_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_grimstrokeA_3_thinker", "abilities/tower/grimstrokeA/grimstrokeA_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if grimstrokeA_3 == nil then
	grimstrokeA_3 = class({iSearchBehavior = AI_SEARCH_BEHAVIOR_MOST_AOE_TARGET}, nil, ability_base_ai)
end
function grimstrokeA_3:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function grimstrokeA_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	CreateModifierThinker(hCaster, self, "modifier_grimstrokeA_3_thinker", {duration = self:GetSpecialValueFor("delay")}, vPosition, hCaster:GetTeamNumber(), false)
	hCaster:EmitSound("Hero_Bloodseeker.BloodRite.Cast")
end
---------------------------------------------------------------------
--Modifiers
if modifier_grimstrokeA_3_thinker == nil then
	modifier_grimstrokeA_3_thinker = class({}, nil, ParticleModifierThinker)
end
function modifier_grimstrokeA_3_thinker:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.magical_factor = self:GetAbilitySpecialValueFor("magical_factor")
	self.heal_pct = self:GetAbilitySpecialValueFor("heal_pct")
	if IsServer() then
		self:GetParent():EmitSound("hero_bloodseeker.bloodRite")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_spell_bloodbath_bubbles.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, 200, 1))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_grimstrokeA_3_thinker:OnDestroy()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, hParent:GetAbsOrigin(), self.radius, hAbility)
		local flDamage = self.magical_factor * hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) * 0.01
		local flHealAmount = 0
		for _, hUnit in pairs(tTargets) do
			hUnit:AddBuff(hCaster, BUFF_TYPE.ROOT, hAbility:GetDuration())
			hCaster:DealDamage(hUnit, hAbility, flDamage / #tTargets)
			flHealAmount = flHealAmount + flDamage / #tTargets
		end
		hCaster:Heal(flHealAmount * self.heal_pct * 0.01, hAbility)
		hParent:EmitSound("hero_bloodseeker.bloodRite.silence")
		if IsValid(hParent) then
			hParent:RemoveSelf()
		end
	end
end