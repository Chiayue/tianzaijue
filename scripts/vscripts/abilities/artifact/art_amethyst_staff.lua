LinkLuaModifier("modifier_art_amethyst_staff", "abilities/artifact/art_amethyst_staff.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_amethyst_staff == nil then
	art_amethyst_staff = class({}, nil, artifact_base)
end
function art_amethyst_staff:GetIntrinsicModifierName()
	return "modifier_art_amethyst_staff"
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_amethyst_staff == nil then
	modifier_art_amethyst_staff = class({}, nil, eom_modifier)
end
function modifier_art_amethyst_staff:OnCreated(params)
	if IsServer() then
	end
end
function modifier_art_amethyst_staff:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_art_amethyst_staff:OnDestroy()
	if IsServer() then
	end
end
function modifier_art_amethyst_staff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_PREPARATION,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_art_amethyst_staff:OnBattleEnd()
	local iPlayerID = self:GetPlayerID()
	local iBattleUnit = 0
	BuildSystem:EachBuilding(iPlayerID, function(hBuilding)
		if hBuilding then
			iBattleUnit = iBattleUnit + 1
		end
	end)
	self.iBattleUnit = iBattleUnit
end
function modifier_art_amethyst_staff:OnPreparation()
	local mana_regen_per_hero = self:GetAbilitySpecialValueFor("mana_regen_per_hero")
	if self.iBattleUnit then
		PlayerData:AddMana(self:GetPlayerID(), self.iBattleUnit * mana_regen_per_hero)
	end
end