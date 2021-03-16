LinkLuaModifier("modifier_art_ring_of_fealty", "abilities/artifact/art_ring_of_fealty.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_ring_of_fealty == nil then
	art_ring_of_fealty = class({}, nil, artifact_base)
end
function art_ring_of_fealty:GetIntrinsicModifierName()
	return "modifier_art_ring_of_fealty"
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_ring_of_fealty == nil then
	---@class modifier_art_ring_of_fealty:eom_modifier
	modifier_art_ring_of_fealty = class({}, nil, eom_modifier)
end
function modifier_art_ring_of_fealty:OnCreated(params)
end
function modifier_art_ring_of_fealty:OnRefresh(params)
end
function modifier_art_ring_of_fealty:OnDestroy()
end
function modifier_art_ring_of_fealty:DeclareFunctions()
	return {
	}
end
function modifier_art_ring_of_fealty:EDeclareFunctions()
	return {
		EMDF_MAX_HAND_CARD_COUNT_BONUS,
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_EVENT_ON_PREPARATION
	}
end
function modifier_art_ring_of_fealty:GetModifierMaxHandCardCountBonus()
	return self:GetAbilityLevelSpecialValueFor("max_hand_card_count_bonus", 1)
end
-- function modifier_art_ring_of_fealty:OnBattleEnd(params)
-- 	if IsServer() then
-- 		self.iPassRound = self.iPassRound or 0
-- 		self.iPassRound = self.iPassRound + 1
-- 		if self.iPassRound == self:GetAbilitySpecialValueFor("gold_reduce_round") then
-- 			self.iPassRound = 0
-- 			self.bReduceGold = true
-- 		end
-- 	end
-- end
-- function modifier_art_ring_of_fealty:OnPreparation(params)
-- 	if IsServer() then
-- 		if self.bReduceGold then
-- 			self.bReduceGold = false
-- 			local iPlayerID = self:GetPlayerID()
-- 			local iTotalGold = PlayerData:GetGold(iPlayerID)
-- 			local iReduce = -math.floor(iTotalGold * self:GetAbilitySpecialValueFor("gold_reduce_pct") * 0.01)
-- 			PlayerData:ModifyGold(iPlayerID, iReduce, true)
-- 		end
-- 	end
-- end