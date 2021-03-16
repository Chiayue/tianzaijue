--Abilities
if art_destiny_hand == nil then
	art_destiny_hand = class({}, nil, artifact_base)
end
function art_destiny_hand:OnSpellStart()
	local item_account = self:GetSpecialValueFor("item_account")
	local iItemRarityWill = self:GetSpecialValueFor("iItemRarityWill")
	local iPlayerID = GetPlayerID(self:GetCaster())
	local sItemPools = table.concat({ "art_destiny_hand" })
	local tItem = SelectItem:GetRandomItems(1, iPlayerID, sItemPools, {})
	if tItem[1] then
		Items:AddItem(iPlayerID, tItem[1].sItemName)
	end
	-- Artifact:Remove(iPlayerID, self:GetAbilityName())
end