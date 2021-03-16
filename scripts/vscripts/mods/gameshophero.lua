if nil == GameShopHero then
	---@class GameShopHero
	GameShopHero = {

	}
	GameShopHero = class({}, GameShopHero)
end
---@type GameShopHero
local public = GameShopHero

function public:init(bReload)
	CustomUIEvent("GameShopHeroBuyPressed", Dynamic_Wrap(public, "OnGameShopHeroBuyPressed"), public)
end

--UI事件************************************************************************************************************************
	do
	--选卡
	function public:OnGameShopHeroBuyPressed(eventSourceIndex, tEvent)
		local iPlayerID = tEvent.PlayerID
		local sCardName = tEvent.card_name

		--验证购买英雄功能是否解锁
		if GAME_SHOP_HERO_UNLOCK_ROUND > Spawner:GetRound() then
			ErrorMessage(iPlayerID, 'dota_hud_error_not_unlock')
			return
		end

		--验证卡组存在否
		local iCardCount = Draw:GetCardCountInPlayerPool(iPlayerID, sCardName)
		if 0 >= iCardCount then return end

		--验证魂晶足够
		local sRarity = string.lower(DotaTD:GetCardRarity(sCardName))
		local iCost = GAME_SHOP_HERO_COST[sRarity]
		if iCost > PlayerData:GetCrystal(iPlayerID) then
			ErrorMessage(iPlayerID, 'dota_hud_error_not_enough_crystal')
			return
		end

		--给卡
		if not HeroCardData:AddCardByName(iPlayerID, sCardName) then return end

		--消耗魂晶
		PlayerData:ModifyCrystal(iPlayerID, -iCost)
		--卡池减少
		Draw:ModifyCardCountInPlayerPool(iPlayerID, sCardName, -1)
	end
end
--事件监听************************************************************************************************************************
	do
end
--事件监听************************************************************************************************************************
--
function public:UpdateNetTables()
	-- CustomNetTables:SetTableValue("common", "player_redraw_chance", self.tReDrawChance)
end

return public