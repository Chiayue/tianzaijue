LinkLuaModifier( "modifier_void_spirit_1", "abilities/tower/void_spirit/void_spirit_1.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_void_spirit_1_shield", "abilities/tower/void_spirit/void_spirit_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if void_spirit_1 == nil then
	void_spirit_1 = class({}, nil, ability_base_ai)
end
function void_spirit_1:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function void_spirit_1:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("radius")
end
function void_spirit_1:OnSpellStart()
	local hCaster = self:GetCaster()
	-- 幻象的来源者
	local hSource = IsValid(hCaster.hSource) and hCaster.hSource or hCaster
	local fDuration = self:GetDuration()
	local radius = self:GetSpecialValueFor("radius")
	local shield_health = self:GetSpecialValueFor("shield_health")
	local bonus_shield_per_unit = self:GetSpecialValueFor("bonus_shield_per_unit")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), radius, self)
	for _, hUnit in pairs(tTargets) do
		hCaster:DealDamage(hUnit, self)
		local hModifier = hUnit:FindModifierByName("modifier_void_spirit_2_debuff")
		if IsValid(hModifier) then
			hModifier:Explode()
		end
		hUnit:EmitSound("Hero_VoidSpirit.Pulse.Target")
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_absorb.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", hUnit:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hSource:GetAbsOrigin(), false)
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
	local fShieldHealth = bonus_shield_per_unit*#tTargets
	if hSource ~= hCaster then
		hSource:AddNewModifier(hCaster, self, "modifier_void_spirit_1_shield", {duration = fDuration, shield_health = fShieldHealth})
	else
		fShieldHealth = fShieldHealth + shield_health
		hSource:AddNewModifier(hCaster, self, "modifier_void_spirit_1_shield", {duration = fDuration, shield_health = fShieldHealth})
	end
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius * 2, 1, radius))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	if not hCaster:IsIllusion() then
		hCaster:EmitSound("Hero_VoidSpirit.Pulse")
		hCaster:EmitSound("Hero_VoidSpirit.Pulse.Cast")
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_void_spirit_1_shield == nil then
	modifier_void_spirit_1_shield = class({}, nil, ModifierPositiveBuff)
end
function modifier_void_spirit_1_shield:OnCreated(params)
	self:SetHasCustomTransmitterData(true)

	if IsServer() then
		self.flShieldHealth = (self.flShieldHealth or 0) + params.shield_health
	else
		-- particle
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_shield.vpcf", PATTACH_CENTER_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self:GetParent():GetModelRadius(), 0, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_void_spirit_1_shield:OnRefresh(params)
	if IsServer() then
		self.flShieldHealth = (self.flShieldHealth or 0) + params.shield_health
	end
end
function modifier_void_spirit_1_shield:OnDestroy()
	if IsServer() then
		self:GetParent():EmitSound("Hero_VoidSpirit.Pulse.Destroy")
	end
end
function modifier_void_spirit_1_shield:AddCustomTransmitterData()
	return {
		flShieldHealth = self.flShieldHealth,
	}
end
function modifier_void_spirit_1_shield:HandleCustomTransmitterData(tData)
	self.flShieldHealth = tData.flShieldHealth
end
function modifier_void_spirit_1_shield:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
	}
end
function modifier_void_spirit_1_shield:GetModifierTotal_ConstantBlock(params)
	if IsServer() and params.damage > 0 then
		local hParent = self:GetParent()
		local flBlock = self.flShieldHealth
		self.flShieldHealth = self.flShieldHealth - params.damage
		if self.flShieldHealth < 0 then
			self:Destroy()
		else
			self:SendBuffRefreshToClients()
		end
		return flBlock
	else
		return self.flShieldHealth
	end
end