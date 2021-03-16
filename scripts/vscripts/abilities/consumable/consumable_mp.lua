---星光闪耀
---本回合场上英雄星级+1
if consumable_mp == nil then
	consumable_mp = class({})
end

function consumable_mp:Precache(context)
	-- PrecacheResource("particle", "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_chakra_magic.vpcf", context)
	-- PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_keeper_of_the_light.vsndevts", context)
end

function consumable_mp:OnSpellStart()
	local hCaster = self:GetCaster()
	local iPlayerID = GetPlayerID(hCaster)
	local tBuildings = {}
	self.hCommander = Commander:GetCommander(iPlayerID)

	local iLevel = self:GetSpecialValueFor('level')
	---@param hBuilding Building
	BuildSystem:EachBuilding(iPlayerID, function(hBuilding)
		if hBuilding then
			if hBuilding:GetStar() and hBuilding:GetStar() < 5 then
				hBuilding:ModifyLevelBonus(iLevel, self)
				table.insert(tBuildings, hBuilding:GetUnitEntityIndex())
			end
		end
	end)

	EventManager:register(ET_BATTLE.ON_BATTLEING_END, function()
		for _, iEntID in pairs(tBuildings) do
			local hBuidling = BuildSystem:GetBuildingByEntID(iEntID)
			if hBuidling then
				hBuidling:ModifyLevelBonus(nil, self)
			end
		end
		return true
	end, nil, nil, self:GetAbilityName() .. iPlayerID)
end