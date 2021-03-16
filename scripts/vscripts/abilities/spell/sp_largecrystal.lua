--Abilities
if sp_largecrystal == nil then
	sp_largecrystal = class({}, nil, sp_base)
end
function sp_largecrystal:OnSpellStart()
	local hCaster = self:GetCaster()
	local PlayerID = hCaster:GetPlayerOwnerID()
	local crystalearn_min = self:GetSpecialValueFor("crystalearn_min")
	local crystalearn_max = self:GetSpecialValueFor("crystalearn_max")
	if hCaster then
		local crysital = RandomInt(crystalearn_min, crystalearn_max)
		PlayerData:ModifyCrystal(PlayerID, crysital, true)
		Notification:Combat({
			player_id = PlayerID,
			int_crystal = crysital,
			teamnumber = -1,
			message = "Combat_sp_largecrystal",
		})
	end
end