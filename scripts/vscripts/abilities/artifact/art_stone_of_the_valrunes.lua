LinkLuaModifier("modifier_art_stone_of_the_valrunes", "abilities/artifact/art_stone_of_the_valrunes.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_stone_of_the_valrunes == nil then
	---@class  art_stone_of_the_valrunes
	art_stone_of_the_valrunes = class({}, nil, artifact_base)
end
function art_stone_of_the_valrunes:GetIntrinsicModifierName()
	return "modifier_art_stone_of_the_valrunes"
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_stone_of_the_valrunes == nil then
	modifier_art_stone_of_the_valrunes = class({}, nil, eom_modifier)
end

function modifier_art_stone_of_the_valrunes:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
	end
end

function modifier_art_stone_of_the_valrunes:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end

function modifier_art_stone_of_the_valrunes:EDeclareFunctions()
	return {
		EMDF_MAX_BUILDING_BONUS
	}
end

function modifier_art_stone_of_the_valrunes:GetModifierMaxBuildingBonus()
	return self:GetAbilitySpecialValueFor("max_building_bonus")
end