LinkLuaModifier( "modifier_disruptor_1_thinker", "abilities/tower/disruptor/disruptor_1.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_disruptor_2_aura", "abilities/tower/disruptor/disruptor_2.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if disruptor_1 == nil then
	disruptor_1 = class({iSearchBehavior = AI_SEARCH_BEHAVIOR_MOST_AOE_TARGET}, nil, ability_base_ai)
end
function disruptor_1:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function disruptor_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	CreateModifierThinker(hCaster, self, "modifier_disruptor_1_thinker", {duration = self:GetDuration()}, vPosition, hCaster:GetTeamNumber(), false)
	hCaster:EmitSound("Hero_Disruptor.ThunderStrike.Cast")
end
---------------------------------------------------------------------
--Modifiers
if modifier_disruptor_1_thinker == nil then
	modifier_disruptor_1_thinker = class({}, nil, ParticleModifierThinker)
end
function modifier_disruptor_1_thinker:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	if IsServer() then
		self:StartIntervalThink(self.interval)
		self:GetParent():EmitSound("Hero_Disruptor.StaticStorm")
		-- 二技能
		if self:GetCaster():HasModifier("modifier_disruptor_2") then
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("disruptor_2"), "modifier_disruptor_2_aura", {duration = self:GetDuration()})
		end
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_disruptor/disruptor_static_storm.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, 1, 1))
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(self:GetDuration(), 1, 1))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_disruptor_1_thinker:OnDestroy()
	if IsServer() then
		if IsValid(self:GetParent()) then
			self:GetParent():StopSound("Hero_Disruptor.StaticStorm")
			self:GetParent():EmitSound("Hero_Disruptor.StaticStorm.End")
			self:GetParent():RemoveSelf()
		end
	end
end
function modifier_disruptor_1_thinker:OnIntervalThink()
	local hCaster = self:GetCaster()
	if not IsValid(hCaster) then
		self:Destroy()
		return
	end
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, self:GetParent():GetAbsOrigin(), self.radius, self:GetAbility())
	hCaster:DealDamage(tTargets, self:GetAbility())
end