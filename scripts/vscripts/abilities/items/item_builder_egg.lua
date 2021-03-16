--Abilities
if item_builder_egg == nil then
	item_builder_egg = class({})
end
function item_builder_egg:OnSpellStart()
	local hCaster = self:GetCaster()
	PlayerData:DropGold(GetPlayerID(hCaster), self:GetContainer():GetAbsOrigin(), self.bonus_gold)
	EmitSoundOnLocationWithCaster(hCaster:GetAbsOrigin(), "General.Coins", hCaster)
	self:SpendCharge()
end