LinkLuaModifier("modifier_art_death_seal", "abilities/artifact/art_death_seal.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_death_seal == nil then
	art_death_seal = class({}, nil, artifact_base)
end
function art_death_seal:GetIntrinsicModifierName()
	return "modifier_art_death_seal"
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_death_seal == nil then
	modifier_art_death_seal = class({}, nil, eom_modifier)
end
function modifier_art_death_seal:OnCreated(params)
	self.card_count = self:GetAbilitySpecialValueFor("card_count")
	if IsServer() then
		self.tCard = {}
	end
end
function modifier_art_death_seal:OnRefresh(params)
	self.card_count = self:GetAbilitySpecialValueFor("card_count")
	if IsServer() then
	end
end
function modifier_art_death_seal:OnDestroy()
	if IsServer() then
	end
end
function modifier_art_death_seal:EDeclareFunctions()
	return {
		EMDF_BONUS_SPELL_CARD,
		EMDF_EVENT_ON_PREPARATION,
	-- EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_art_death_seal:GetBonusSpellCard()
	return 1
end
-- function modifier_art_death_seal:OnBattleEnd()
-- 	local iPlayerID = GetPlayerID(self:GetParent())
-- 	for _, iCardID in ipairs(self.tCard) do
-- 		HandSpellCards:RemoveCardByID(iPlayerID, iCardID)
-- 	end
-- end
function modifier_art_death_seal:OnPreparation()
	local iPlayerID = GetPlayerID(self:GetParent())
	local tCards = {}
	SelectSpellCard:EachCardinPool(iPlayerID, 'DEATH_SEAL', function(sCard)
		if not HandSpellCards:HasCard(iPlayerID, sCard) then
			local tKV = KeyValues.SpellKv[sCard]
			if tKV and tKV.DrawWeight and tonumber(tKV.DrawWeight) ~= 0 then
				table.insert(tCards, sCard)
			end
		end
	end)

	for i = 1, self.card_count do
		if #tCards > 0 then
			local iRand = RandomInt(1, #tCards)
			local sCardName = tCards[iRand]
			if HandSpellCards:GetPlayerHandCardKind(iPlayerID) >= HandSpellCards:GetPlayerMaxCardCategory(iPlayerID)
			and not HandSpellCards:HasCard(iPlayerID, sCardName)
			then
				ErrorMessage(iPlayerID, 'dota_hud_error_hand_spell_card_kind_limit')
				return
			end
			local tData = HandSpellCards:AddCard(iPlayerID, tCards[iRand])
			if IsValid(tData) then
				table.insert(self.tCard, tData.iCardID)
				table.remove(tCards, iRand)
			end
		end
	end
end