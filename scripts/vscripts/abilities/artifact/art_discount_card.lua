LinkLuaModifier("modifier_art_discount_card", "abilities/artifact/art_discount_card.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_discount_card == nil then
	art_discount_card = class({}, nil, artifact_base)
end
function art_discount_card:GetIntrinsicModifierName()
	return "modifier_art_discount_card"
end

---------------------------------------------------------------------
--Modifiers
if modifier_art_discount_card == nil then
	modifier_art_discount_card = class({}, nil, eom_modifier)
end
function modifier_art_discount_card:IsHidden()
	return true
end
function modifier_art_discount_card:OnCreated(params)
	self.percent = self:GetAbilitySpecialValueFor("percent")
	if IsServer() then
		local hParent = self:GetParent()
		local iPlayerID = GetPlayerID(hParent)
		hParent:Timer(0, function()
			--更新抽卡，升级的消耗金币数
			if PlayerData.playerDatas[iPlayerID] then
				PlayerData.playerDatas[iPlayerID].gold_cost_draw_card = GET_DRAW_CARD_COST_GOLD_ALL(iPlayerID)
				PlayerData.playerDatas[iPlayerID].gold_cost_levelup = GET_LEVELUP_COST_GOLD(iPlayerID)
				PlayerData:UpdateNetTables()
			end
		end)
	end
end
function modifier_art_discount_card:OnRefresh(params)
	self.percent = self:GetAbilitySpecialValueFor("percent")
	if IsServer() then
	end
end
function modifier_art_discount_card:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		local iPlayerID = GetPlayerID(hParent)
		hParent:Timer(0, function()
			--更新抽卡，升级的消耗金币数
			if PlayerData.playerDatas[iPlayerID] then
				PlayerData.playerDatas[iPlayerID].gold_cost_draw_card = GET_DRAW_CARD_COST_GOLD_ALL(iPlayerID)
				PlayerData.playerDatas[iPlayerID].gold_cost_levelup = GET_LEVELUP_COST_GOLD(iPlayerID)
				PlayerData:UpdateNetTables()
			end
		end)
	end
end
function modifier_art_discount_card:EDeclareFunctions()
	return {
		EMDF_CARD_REFRESH_COST_PERCENTAGE
	}
end
function modifier_art_discount_card:GetModifierCardRefreshCostPercent()
	return self.percent
end