--Abilities
if sp_recall == nil then
	sp_recall = class({}, nil, sp_base)
end
function sp_recall:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_recall:CastFilterResultTarget(hTarget)
	if type(hTarget.GetBuilding) == "function" and hTarget:GetBuilding() ~= nil then
		return UF_SUCCESS
	end
	return UF_FAIL_CUSTOM, "dota_hud_error_only_can_not_cast"
end
function sp_recall:OnSpellStart()
	local hCaster = self:GetCaster()
	local health_recover_pct = self:GetSpecialValueFor("health_recover_pct")
	local hTarget = self:GetCursorTarget()
	if not hTarget then return end

	hTarget:Heal(hTarget:GetMaxHealth() * health_recover_pct * 0.01, self)

	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_recall_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
	ParticleManager:SetParticleControl(iParticleID, 1, hTarget:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(iParticleID)

	local hBuilding = hTarget:GetBuilding()
	if hBuilding.vLocation then
		FindClearSpaceForUnit(hTarget, hBuilding.vLocation, true)
	end

	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_recall_poof.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
	ParticleManager:ReleaseParticleIndex(iParticleID)
end