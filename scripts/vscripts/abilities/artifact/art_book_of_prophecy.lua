LinkLuaModifier("modifier_art_book_of_prophecy", "abilities/artifact/art_book_of_prophecy.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_book_of_prophecy == nil then
	art_book_of_prophecy = class({}, nil, artifact_base)
end
function art_book_of_prophecy:GetIntrinsicModifierName()
	return "modifier_art_book_of_prophecy"
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_book_of_prophecy == nil then
	modifier_art_book_of_prophecy = class({}, nil, eom_modifier)
end
function modifier_art_book_of_prophecy:OnCreated(params)
	self.gold = self:GetAbilitySpecialValueFor("gold")
	if IsServer() then
	end
end
function modifier_art_book_of_prophecy:OnRefresh(params)
	self.gold = self:GetAbilitySpecialValueFor("gold")
	if IsServer() then
	end
end
function modifier_art_book_of_prophecy:OnDestroy()
	if IsServer() then
	end
end
function modifier_art_book_of_prophecy:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_PLAYER_USE_SPELL
	}
end
---@param params {iPlayerID: number, sCardName:string}
function modifier_art_book_of_prophecy:OnHeroUseSpell(params)
	if params.iPlayerID == self:GetPlayerID() then
		PlayerData:ModifyGold(params.iPlayerID, self.gold)
	end
end