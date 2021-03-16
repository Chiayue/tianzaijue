--Abilities
if contract_priesthood == nil then
	contract_priesthood = class({ iSearchBehavior = AI_SEARCH_BEHAVIOR_MOST_AOE_TARGET }, nil, ability_base_ai)
end
function contract_priesthood:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function contract_priesthood:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local magical_factor = self:GetSpecialValueFor("magical_factor")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, radius, self)
	ArrayRemove(tTargets, Commander:GetCommander(GetPlayerID(hCaster)))
	local flDamage = hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) * magical_factor * 0.01
	if #tTargets > 0 then
		hCaster:DealDamage(tTargets, self, flDamage / #tTargets)
	end
	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/witch_doctor/wd_ti8_immortal_head/wd_ti8_immortal_maledict_aoe.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, 1, 1))
	ParticleManager:ReleaseParticleIndex(iParticleID)
end