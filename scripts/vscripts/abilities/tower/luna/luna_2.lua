LinkLuaModifier("modifier_luna_2", "abilities/tower/luna/luna_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if luna_2 == nil then
	luna_2 = class({ iBehavior = DOTA_ABILITY_BEHAVIOR_NO_TARGET }, nil, ability_base_ai)
end
function luna_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local duration = self:GetDuration()
	EachUnits(GetPlayerID(hCaster), function(hUnit)
		if hUnit:IsAlive() then
			hUnit:AddNewModifier(hCaster, self, "modifier_luna_2", { duration = duration })
		end
	end, UnitType.AllFirends)
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/luna/luna_2.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(600, 0, 0))
	hCaster:EmitSound("Hero_Luna.Eclipse.Cast")
end
---------------------------------------------------------------------
--Modifiers
if modifier_luna_2 == nil then
	modifier_luna_2 = class({}, nil, eom_modifier)
end
function modifier_luna_2:OnCreated(params)
	self.damage_add_per = self:GetAbilitySpecialValueFor("damage_add_per")
end
function modifier_luna_2:OnRefresh(params)
	self.damage_add_per = self:GetAbilitySpecialValueFor("damage_add_per")
end
function modifier_luna_2:EDeclareFunctions()
	return {
		[EMDF_PHYSICAL_ATTACK_BONUS] = self.damage_add_per,
		[EMDF_MAGICAL_ATTACK_BONUS] = self.damage_add_per,
	}
end
function modifier_luna_2:GetPhysicalAttackBonus()
	return self.damage_add_per
end
function modifier_luna_2:GetMagicalAttackBonus()
	return self.damage_add_per
end