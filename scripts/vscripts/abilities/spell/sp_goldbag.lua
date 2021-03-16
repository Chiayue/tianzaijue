--Abilities
if sp_goldbag == nil then
	sp_goldbag = class({}, nil, sp_base)
end
function sp_goldbag:OnSpellStart()
	local hCaster = self:GetCaster()
	local PlayerID = hCaster:GetPlayerOwnerID()
	local goldearn_min = self:GetSpecialValueFor("goldearn_min")
	local goldearn_max = self:GetSpecialValueFor("goldearn_max")
	if hCaster then
		local gold = RandomInt(goldearn_min, goldearn_max)
		PlayerData:ModifyGold(PlayerID, gold, true)
		Notification:Combat({
			player_id = PlayerID,
			int_good = gold,
			teamnumber = -1,
			message = "Combat_sp_goldbag",
		})
	end
end