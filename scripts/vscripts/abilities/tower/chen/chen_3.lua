--Abilities
if chen_3 == nil then
	chen_3 = class({}, nil, ability_base_ai)
end
function chen_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local heal_pct = self:GetSpecialValueFor("heal_pct")
	local heal_increase = self:GetSpecialValueFor("heal_increase")
	local flHealAmount = hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) * heal_pct * 0.01
	local tTargets = {}
	EachUnits(GetPlayerID(hCaster), function (hUnit)
		if hUnit:IsAlive() then
			table.insert(tTargets, hUnit)
		end
	end, UnitType.AllFirends)
	for _, hUnit in ipairs(tTargets) do
		hUnit:Heal(flHealAmount * (1 + heal_increase * (#tTargets - 1) * 0.01), self)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_hand_of_god.vpcf", PATTACH_CENTER_FOLLOW, hUnit)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		hUnit:EmitSound("Hero_Chen.HandOfGodHealCreep")
	end
	-- 
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_hand_of_god.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Hero_Chen.HandOfGodHealHero")
end