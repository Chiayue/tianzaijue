--Abilities
if sp_exp == nil then
	sp_exp = class({}, nil, sp_base)
end
function sp_exp:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_exp:CastFilterResultTarget(hTarget)
	if type(hTarget.GetBuilding) == "function" and hTarget:GetBuilding() ~= nil then
		return UF_SUCCESS
	end
	return UF_FAIL_CUSTOM, "dota_hud_error_only_can_not_cast"
end
function sp_exp:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local exp = self:GetSpecialValueFor("exp")
	local hBuilding = hTarget:GetBuilding()
	BuildSystem:AddExperience(hTarget, nil, exp)
end