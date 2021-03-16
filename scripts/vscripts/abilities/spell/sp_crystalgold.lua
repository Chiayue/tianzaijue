--Abilities
if sp_crystalgold == nil then
	sp_crystalgold = class({}, nil, sp_base)
end
function sp_crystalgold:CastFilterResult()
	local hCaster = self:GetCaster()
	local iPlayerID = hCaster:GetPlayerOwnerID()
	local crystal_needed = self:GetSpecialValueFor("crystal_needed")
	if PlayerData:GetCrystal(iPlayerID) >= crystal_needed then
		return UF_SUCCESS
	end
	return UF_FAIL_CUSTOM, "dota_hud_error_not_enough_crystal"
end
function sp_crystalgold:OnSpellStart()
	local hCaster = self:GetCaster()
	local iPlayerID = hCaster:GetPlayerOwnerID()
	local crystal_needed = self:GetSpecialValueFor("crystal_needed")
	local gold_earn = self:GetSpecialValueFor("gold_earn")
	if PlayerData:GetCrystal(iPlayerID) >= crystal_needed then
		PlayerData:ModifyCrystal(iPlayerID, -crystal_needed, true)
		PlayerData:ModifyGold(iPlayerID, gold_earn, true)
	end
end