LinkLuaModifier("modifier_cmd_juggernaut_2", "abilities/commander/cmd_juggernaut/cmd_juggernaut_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_juggernaut_2_buff", "abilities/commander/cmd_juggernaut/cmd_juggernaut_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_juggernaut_2 == nil then
	cmd_juggernaut_2 = class({ iSearchBehavior = AI_SEARCH_BEHAVIOR_MOST_AOE_TARGET }, nil, ability_base_ai)
end
function cmd_juggernaut_2:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function cmd_juggernaut_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")

	local hIllusion = CreateIllusion(hCaster, vPosition, true, hCaster, hCaster, hCaster:GetTeamNumber(), duration, 0, 0)
	hIllusion:StartGesture(ACT_DOTA_CAST_ABILITY_1)
	hIllusion:AddNewModifier(hCaster, self, "modifier_cmd_juggernaut_2_buff", nil)
	-- hCaster:Purge(false, true, false, false, false)
	-- CreateModifierThinker(hCaster, self, "modifier_cmd_juggernaut_2_buff", { duration = duration }, vPosition, hCaster:GetTeamNumber(), false)
	-- hCaster:AddNewModifier(hCaster, self, "modifier_cmd_juggernaut_2_buff", { duration = duration })
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_juggernaut_2_buff == nil then
	modifier_cmd_juggernaut_2_buff = class({}, nil, eom_modifier)
end
function modifier_cmd_juggernaut_2_buff:OnCreated(params)
	self.damage_tick = self:GetAbilitySpecialValueFor("damage_tick")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.attack_pct = self:GetAbilitySpecialValueFor("attack_pct")
	if IsServer() then
		self:StartIntervalThink(self.damage_tick)

		self:GetParent():EmitSound("Hero_Juggernaut.BladeFuryStart")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_blade_fury_abyssal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 5, Vector(self.radius, 1, 1))
		self:AddParticle(iParticleID, false, false, -1, false, false)

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_null.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_cmd_juggernaut_2_buff:OnRefresh(params)
	self.damage_tick = self:GetAbilitySpecialValueFor("damage_tick")
	self.radius = self:GetAbilitySpecialValueFor("blade_fury_radius")
	self.attack_pct = self:GetAbilitySpecialValueFor("attack_pct")
end
function modifier_cmd_juggernaut_2_buff:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Hero_Juggernaut.BladeFuryStart")
		self:GetParent():EmitSound("Hero_Juggernaut.BladeFuryStop")
		if IsValid(self:GetParent()) then
			self:GetParent():RemoveSelf()
		end
	end
end
function modifier_cmd_juggernaut_2_buff:OnIntervalThink()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()

		if not IsValid(hAbility) or not IsValid(hCaster) then
			self:Destroy()
			return
		end

		local fDamage = self.attack_pct * hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self.damage_tick * 0.01
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, hAbility)
		for n, hTarget in pairs(tTargets) do
			local iParticleID = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf", hCaster), PATTACH_CUSTOMORIGIN, hTarget)
			ParticleManager:SetParticleControlEnt(iParticleID, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(iParticleID)

			EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_Juggernaut.BladeFury.Impact", hCaster)

			hCaster:DealDamage(hTarget, hAbility, fDamage)
		end
	end
end
function modifier_cmd_juggernaut_2_buff:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
end
function modifier_cmd_juggernaut_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}
end
function modifier_cmd_juggernaut_2_buff:GetOverrideAnimation(params)
	return ACT_DOTA_OVERRIDE_ABILITY_1
end
function modifier_cmd_juggernaut_2_buff:GetOverrideAnimationRate(params)
	return 1
end
function modifier_cmd_juggernaut_2_buff:IsHidden()
	return true
end