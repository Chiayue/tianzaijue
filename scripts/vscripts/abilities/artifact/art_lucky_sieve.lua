LinkLuaModifier("modifier_art_lucky_sieve", "abilities/artifact/art_lucky_sieve.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_lucky_sieve == nil then
	art_lucky_sieve = class({}, nil, artifact_base)
end
function art_lucky_sieve:GetIntrinsicModifierName()
	return "modifier_art_lucky_sieve"
end

---------------------------------------------------------------------
--Modifiers
if modifier_art_lucky_sieve == nil then
	modifier_art_lucky_sieve = class({}, nil, eom_modifier)
end
function modifier_art_lucky_sieve:OnCreated(params)
	self.health_pct = self:GetAbilitySpecialValueFor("health_pct")
	self.mana_regen = self:GetAbilitySpecialValueFor("mana_regen")
	if IsServer() then
	end
end
function modifier_art_lucky_sieve:OnRefresh(params)
	self.health_pct = self:GetAbilitySpecialValueFor("health_pct")
	self.mana_regen = self:GetAbilitySpecialValueFor("mana_regen")
	if IsServer() then
	end
end
function modifier_art_lucky_sieve:OnDestroy()
	if IsServer() then
	end
end
function modifier_art_lucky_sieve:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_PLAYER_USE_SPELL
	}
end
---@param params {iPlayerID: number, sCardName:string}
function modifier_art_lucky_sieve:OnHeroUseSpell(params)
	if params.iPlayerID == self:GetPlayerID() then
		local iRandom = RandomInt(1, 2)
		if iRandom == 1 then
			self.mana_regen = 20
			PlayerData:AddMana(self:GetPlayerID(), self.mana_regen)
		end
	end
end