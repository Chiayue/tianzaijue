--Abilities
if sp_defend_single == nil then
	sp_defend_single = class({}, nil, sp_base)
end
function sp_defend_single:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_defend_single:CastFilterResultTarget(hTarget)
	if type(hTarget.GetBuilding) == "function" and hTarget:GetBuilding() ~= nil then
		return UF_SUCCESS
	end
	return UF_FAIL_CUSTOM, "dota_hud_error_only_can_not_cast"
end
function sp_defend_single:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local armorbonus = self:GetSpecialValueFor("armorbonus")
	hTarget:Save("sp_defend_single", hTarget:Load("sp_defend_single") + armorbonus)
	if not hCaster:HasModifier("modifier_sp_caster") then
		hCaster:AddNewModifier(hCaster, nil, "modifier_sp_caster", nil)
	end
	if hTarget:HasModifier("modifier_sp_aura") then
		hTarget:FindModifierByName("modifier_sp_aura"):ForceRefresh()
	end
end