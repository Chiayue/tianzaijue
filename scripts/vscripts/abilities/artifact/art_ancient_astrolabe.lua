LinkLuaModifier("modifier_art_ancient_astrolabe", "abilities/artifact/art_ancient_astrolabe.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_ancient_astrolabe == nil then
	art_ancient_astrolabe = class({}, nil, artifact_base)
end
function art_ancient_astrolabe:GetIntrinsicModifierName()
	return "modifier_art_ancient_astrolabe"
end
---------------------------------------------------------------------
--- Modifiers
if modifier_art_ancient_astrolabe == nil then
	modifier_art_ancient_astrolabe = class({}, nil, eom_modifier)
end
function modifier_art_ancient_astrolabe:OnCreated(params)
	self.item_star_bonus = self:GetAbilitySpecialValueFor("item_star_bonus")
	if IsServer() then
	end
end
function modifier_art_ancient_astrolabe:OnRefresh(params)
	self.item_star_bonus = self:GetAbilitySpecialValueFor("item_star_bonus")
	if IsServer() then
	end
end
function modifier_art_ancient_astrolabe:OnDestroy()
	if IsServer() then
	end
end
function modifier_art_ancient_astrolabe:EDeclareFunctions()
	return {
		[EMDF_ITEM_STAR_BONUS] = self.item_star_bonus,
	}
end