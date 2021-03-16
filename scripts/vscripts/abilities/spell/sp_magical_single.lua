--Abilities
if sp_magical_single == nil then
	sp_magical_single = class({}, nil, sp_base)
end
function sp_magical_single:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_magical_single:CastFilterResultTarget(hTarget)
	if type(hTarget.GetBuilding) == "function" and hTarget:GetBuilding() ~= nil then
		return UF_SUCCESS
	end
	return UF_FAIL_CUSTOM, "dota_hud_error_only_can_not_cast"
end
function sp_magical_single:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local magical_atkbonus = self:GetSpecialValueFor("magical_atkbonus")
	hTarget:Save("sp_magical_single", hTarget:Load("sp_magical_single") + magical_atkbonus)
	if not hCaster:HasModifier("modifier_sp_caster") then
		hCaster:AddNewModifier(hCaster, nil, "modifier_sp_caster", nil)
	end
	if hTarget:HasModifier("modifier_sp_aura") then
		hTarget:FindModifierByName("modifier_sp_aura"):ForceRefresh()
	end
end