--Abilities
if sp_attackspeed_single == nil then
	sp_attackspeed_single = class({}, nil, sp_base)
end
function sp_attackspeed_single:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_attackspeed_single:CastFilterResultTarget(hTarget)
	if type(hTarget.GetBuilding) == "function" and hTarget:GetBuilding() ~= nil then
		return UF_SUCCESS
	end
	return UF_FAIL_CUSTOM, "dota_hud_error_only_can_not_cast"
end
function sp_attackspeed_single:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local attack_speed_bonus = self:GetSpecialValueFor("attack_speed_bonus")
	hTarget:Save("sp_attackspeed_single", hTarget:Load("sp_attackspeed_single") + attack_speed_bonus)
	if not hCaster:HasModifier("modifier_sp_caster") then
		hCaster:AddNewModifier(hCaster, nil, "modifier_sp_caster", nil)
	end
	if hTarget:HasModifier("modifier_sp_aura") then
		hTarget:FindModifierByName("modifier_sp_aura"):ForceRefresh()
	end
end