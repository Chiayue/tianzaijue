LinkLuaModifier( "modifier_void_runner_3", "abilities/tower/void_runner/void_runner_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if void_runner_3 == nil then
	void_runner_3 = class({})
end
function void_runner_3:OnSpellStart(vPosition, flMana)
	local hCaster = self:GetCaster()
	local flRadius = self:GetSpecialValueFor("radius")
	local flDamage = flMana * self:GetSpecialValueFor("damage_per_mana")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, flRadius, self)
	for _, hUnit in ipairs(tTargets) do
		hCaster:DealDamage(hUnit, self, flDamage)
		if hUnit:IsAlive() then
			local vDirection = (hUnit:GetAbsOrigin() - vPosition):Normalized()
			hCaster:KnockBack(hUnit:GetAbsOrigin() + vDirection, hUnit, (vPosition - hUnit:GetAbsOrigin()):Length2D(), 0, 0.5, true)
		end
	end
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_vacuum.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(flRadius, 0, 0))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Hero_Dark_Seer.Vacuum")
end
function void_runner_3:GetIntrinsicModifierName()
	return "modifier_void_runner_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_void_runner_3 == nil then
	modifier_void_runner_3 = class({}, nil, ModifierHidden)
end