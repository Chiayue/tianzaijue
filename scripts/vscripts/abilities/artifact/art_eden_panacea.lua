LinkLuaModifier("modifier_art_eden_panacea", "abilities/artifact/art_eden_panacea.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_eden_panacea == nil then
	art_eden_panacea = class({}, nil, artifact_base)
end
function art_eden_panacea:GetIntrinsicModifierName()
	return "modifier_art_eden_panacea"
end

---------------------------------------------------------------------
--Modifiers
if modifier_art_eden_panacea == nil then
	modifier_art_eden_panacea = class({}, nil, eom_modifier)
end
function modifier_art_eden_panacea:OnCreated(params)
	self.health_pct = self:GetAbilitySpecialValueFor("health_pct")
	self.health_regen = self:GetAbilitySpecialValueFor("health_regen")
	if IsServer() then
	end
end
function modifier_art_eden_panacea:OnRefresh(params)
	self.health_pct = self:GetAbilitySpecialValueFor("health_pct")
	self.health_regen = self:GetAbilitySpecialValueFor("health_regen")
	if IsServer() then
	end
end
function modifier_art_eden_panacea:OnDestroy()
	if IsServer() then
	end
end
function modifier_art_eden_panacea:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_PLAYER_USE_SPELL
	}
end
---@param params {iPlayerID: number, sCardName:string}
function modifier_art_eden_panacea:OnHeroUseSpell(params)
	if params.iPlayerID == self:GetPlayerID() then
		PlayerData:ModifyHealth(params.iPlayerID, self.health_regen)
	end
end