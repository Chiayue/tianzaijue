LinkLuaModifier("modifier_art_taboo_scroll", "abilities/artifact/art_taboo_scroll.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_taboo_scroll == nil then
	art_taboo_scroll = class({}, nil, artifact_base)
end
function art_taboo_scroll:GetIntrinsicModifierName()
	return "modifier_art_taboo_scroll"
end

---------------------------------------------------------------------
--Modifiers
if modifier_art_taboo_scroll == nil then
	modifier_art_taboo_scroll = class({}, nil, eom_modifier)
end
function modifier_art_taboo_scroll:OnCreated(params)
	self.mana_regen = self:GetAbilitySpecialValueFor("mana_regen")
	if IsServer() then
	end
end
function modifier_art_taboo_scroll:OnRefresh(params)
	self.mana_regen = self:GetAbilitySpecialValueFor("mana_regen")
	if IsServer() then
	end
end
function modifier_art_taboo_scroll:OnDestroy()
	if IsServer() then
	end
end
function modifier_art_taboo_scroll:EDeclareFunctions()
	return {
		-- EMDF_EVENT_ON_PLAYER_USE_SPELL
		-- EMDF_SPELL_CARD_MANA_COST_BONUS，
		EMDF_SPELL_CARD_MANA_COST_PERCENTAGE
	}
end
---@param params {iPlayerID: number, sCardName:string}
function modifier_art_taboo_scroll:OnHeroUseSpell(params)
	if params.iPlayerID == self:GetPlayerID() then
		PlayerData:AddMana(self:GetPlayerID(), self.mana_regen)
	end
end
function modifier_art_taboo_scroll:GetSpellCardManaCostPercentage()
	return -100
end