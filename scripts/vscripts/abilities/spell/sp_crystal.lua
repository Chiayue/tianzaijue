--Abilities
if sp_crystal == nil then
	sp_crystal = class({}, nil, sp_base)
end
function sp_crystal:OnSpellStart()
	local hCaster = self:GetCaster()
	local iPlayerID = hCaster:GetPlayerOwnerID()
	local factor = self:GetSpecialValueFor("factor")
	local iCrystral = 0

	BuildSystem:EachBuilding(iPlayerID, function(hBuilding)
		local iLevel = hBuilding:GetStar()
		iCrystral = iCrystral + iLevel
	end)

	iCrystral = factor * iCrystral
	PlayerData:ModifyCrystal(iPlayerID, iCrystral, true)
	Notification:Combat({
		player_id = iPlayerID,
		int_crystal = iCrystral,
		teamnumber = -1,
		message = "Combat_sp_crystal",
	})
end
