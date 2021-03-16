--Abilities
if sp_crystalbag == nil then
	sp_crystalbag = class({}, nil, sp_base)
end
function sp_crystalbag:OnSpellStart()
	local hCaster = self:GetCaster()
	local PlayerID = hCaster:GetPlayerOwnerID()
	local crystalearn_min = self:GetSpecialValueFor("crystalearn_min")
	local crystalearn_max = self:GetSpecialValueFor("crystalearn_max")
	if hCaster then
		local gold = RandomInt(crystalearn_min, crystalearn_max)
		PlayerData:ModifyCrystal(PlayerID, gold, true)
		Notification:Combat({
			player_id = PlayerID,
			int_crystal = gold,
			teamnumber = -1,
			message = "Combat_sp_crystalbag",
		})
	end
end