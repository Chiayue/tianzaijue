--Abilities
if sp_goldcrystal == nil then
	sp_goldcrystal = class({}, nil, sp_base)
end
function sp_goldcrystal:CastFilterResult()
	local hCaster = self:GetCaster()
	local iPlayerID = hCaster:GetPlayerOwnerID()
	local gold_needed = self:GetSpecialValueFor("gold_needed")
	if PlayerData:GetGold(iPlayerID) >= gold_needed then
		return UF_SUCCESS
	end
	return UF_FAIL_CUSTOM, "dota_hud_error_not_enough_gold"
end
function sp_goldcrystal:OnSpellStart()
	local hCaster = self:GetCaster()
	local iPlayerID = hCaster:GetPlayerOwnerID()
	local gold_needed = self:GetSpecialValueFor("gold_needed")
	local crystal_earn = self:GetSpecialValueFor("crystal_earn")
	if PlayerData:GetGold(iPlayerID) >= gold_needed then
		PlayerData:ModifyGold(iPlayerID, -gold_needed, true)
		PlayerData:ModifyCrystal(iPlayerID, crystal_earn, true)
	end
end