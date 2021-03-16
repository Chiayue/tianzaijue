LinkLuaModifier("modifier_earth_spirit_2", "abilities/tower/earth_spirit/earth_spirit_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_earth_spirit_2_selfbuff", "abilities/tower/earth_spirit/earth_spirit_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_earth_spirit_2_buff", "abilities/tower/earth_spirit/earth_spirit_2.lua", LUA_MODIFIER_MOTION_NONE)
if earth_spirit_2 == nil then
	earth_spirit_2 = class({}, nil, ability_base_ai)
end
function earth_spirit_2:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function earth_spirit_2:Action(vPosition, iCloneDamagePct)
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local fTotalArmor = hCaster:GetVal(ATTRIBUTE_KIND.PhysicalArmor) + hCaster:GetVal(ATTRIBUTE_KIND.MagicalArmor)
	local flDamage = self:GetSpecialValueFor("damage_pct") * fTotalArmor * 0.01
	if iCloneDamagePct then
		flDamage = flDamage * iCloneDamagePct * 0.01
	end
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, radius, self)
	for _, hUnit in pairs(tTargets) do
		hUnit:AddNewModifier(hCaster, self, "modifier_earth_spirit_2_buff", { duration = self:GetDuration() })
		hCaster:AddNewModifier(hCaster, self, "modifier_earth_spirit_2_selfbuff", { duration = self:GetDuration() })
		hCaster:DealDamage(hUnit, self, flDamage)
	end
	-- particle
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start_fallback_mid.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(1, 0, 0))
	ParticleManager:ReleaseParticleIndex(iParticleID)
end
function earth_spirit_2:OnSpellStart()
	local hCaster = self:GetCaster()
	self:Action(hCaster:GetAbsOrigin())
	-- sound
	hCaster:EmitSound("Hero_EarthShaker.EchoSlam")
	ScreenShake(hCaster:GetCenter(), 20, 12, 0.5, 6000, 0, true)
	-- 技能3
	local hAbility = hCaster:FindAbilityByName("earth_spirit_3")
	if IsValid(hAbility) and hAbility:GetLevel() > 0 then
		local tStone = hAbility.tStone
		for k, hStone in pairs(tStone) do
			if IsValid(hStone) and IsValid(hAbility) then
				self:Action(hStone:GetAbsOrigin(), hAbility:GetSpecialValueFor("clone_damage_pct"))
			end
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_earth_spirit_2_buff == nil then
	modifier_earth_spirit_2_buff = class({}, nil, BaseModifier)
end
function modifier_earth_spirit_2_buff:IsDebuff()
	return true
end
function modifier_earth_spirit_2_buff:OnCreated(params)
	self.movespeed_reduce = self:GetAbilitySpecialValueFor("movespeed_reduce")
end
function modifier_earth_spirit_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end
function modifier_earth_spirit_2_buff:GetModifierMoveSpeedBonus_Percentage()
	return -self.movespeed_reduce
end
---------------------------------------------------------------------
if modifier_earth_spirit_2_selfbuff == nil then
	modifier_earth_spirit_2_selfbuff = class({}, nil, eom_modifier)
end
function modifier_earth_spirit_2_selfbuff:IsDebuff()
	return false
end
function modifier_earth_spirit_2_selfbuff:OnCreated(params)
	self.IncomingDamageReducepct = self:GetAbilitySpecialValueFor("IncomingDamageReducepct")
end
function modifier_earth_spirit_2_selfbuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		EMDF_INCOMING_PERCENTAGE
	}
end
function modifier_earth_spirit_2_selfbuff:GetIncomingPercentage()
	return -self.IncomingDamageReducepct
end