LinkLuaModifier("modifier_art_fate_gear", "abilities/artifact/art_fate_gear.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
-- 命运齿轮
if art_fate_gear == nil then
	art_fate_gear = class({}, nil, artifact_base)
end
function art_fate_gear:GetIntrinsicModifierName()
	return "modifier_art_fate_gear"
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_fate_gear == nil then
	modifier_art_fate_gear = class({}, nil, eom_modifier)
end
function modifier_art_fate_gear:OnCreated(params)
	self.card_star = self:GetAbilitySpecialValueFor('card_star')
	self.up_star_chance = self:GetAbilitySpecialValueFor('up_star_chance')
	if IsServer() then
	end
end
function modifier_art_fate_gear:OnRefresh(params)
	self.card_star = self:GetAbilitySpecialValueFor('card_star')
	self.up_star_chance = self:GetAbilitySpecialValueFor('up_star_chance')
	if IsServer() then
	end
end
function modifier_art_fate_gear:OnDestroy()
	if IsServer() then
	end
end
function modifier_art_fate_gear:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_art_fate_gear:OnBattleEnd()
	local iPlayerID = GetPlayerID(self:GetParent())
	if iPlayerID ~= nil then
		local status = 0
		function _Add()
			local iCount = RandomInt(0, HeroCardData:GetPlayerHeroCardsCount(iPlayerID))
			local i = 0
			HeroCardData:EachCard(iPlayerID, function(hCard)
				if status == 0 and hCard.iXP < HERO_XP_PER_LEVEL_TABLE[self.card_star] then
					if iCount ~= i then
						i = i + 1
					else
						if RollPercentage(self.up_star_chance) then
							HeroCardData:LevelUpCard(iPlayerID, hCard, 1)
							local sCardName = Draw:DrawReservoir("default", iPlayerID, {})
							HeroCardData:RemoveCard(iPlayerID, hCard.iCardID)
							-- 卡池变化
							Draw:ModifyCardCountInPlayerPool(iPlayerID, sCardName, -hCard.iXP)
							GameTimer(1, function()
								local nCard = HeroCardData:AddCardByName(iPlayerID, sCardName)
								HeroCardData:LevelUpCard(iPlayerID, nCard, hCard.iXP)
							end)
							status = 1
						else
						end
					end
				end
			end)
		end
		-- local iMax = HAND_HERO_CARD_MAX[math.min(level, #HAND_HERO_CARD_MAX)]
		for i = 1, 7 do
			if status == 0 then
				_Add()
			end
		end
	end
end