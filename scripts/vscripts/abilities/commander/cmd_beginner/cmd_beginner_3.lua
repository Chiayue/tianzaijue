LinkLuaModifier("modifier_cmd_beginner_3", "abilities/commander/cmd_beginner/cmd_beginner_3.lua", LUA_MODIFIER_MOTION_NONE)

if cmd_beginner_3 == nil then
	cmd_beginner_3 = class({})
end
function cmd_beginner_3:GetIntrinsicModifierName()
	return "modifier_cmd_beginner_3"
end

---------------------------------------------------------------------
--Modifiers
if modifier_cmd_beginner_3 == nil then
	modifier_cmd_beginner_3 = class({}, nil, eom_modifier)
end
function modifier_cmd_beginner_3:IsHidden()
	return true
end
function modifier_cmd_beginner_3:EDeclareFunctions()
	return {
		[EMDF_EVENT_CUSTOM] = { ET_GAME.GAME_BEGIN, self.OnGameBegin }
	}
end
function modifier_cmd_beginner_3:OnGameBegin()
	self.count = self:GetAbilitySpecialValueFor('count')
	if IsServer() then
		--火球术
		self.iPlayerID = GetPlayerID(self:GetParent())
		local hAblt = self:GetAbility()
		if hAblt then
			for i = 0, self.count - 1 do
				HandSpellCards:AddCard(self.iPlayerID, 'sp_fireball')
			end
		end
	end
end
-- function modifier_cmd_beginner_3:OnCreated(params)
-- 	self.count = self:GetAbilitySpecialValueFor('count')
-- 	self:OnRefresh(params)
-- end
-- function modifier_cmd_beginner_3:OnRefresh(params)
-- 	self.count = self:GetAbilitySpecialValueFor('count')
-- 	if IsServer() then
-- 		--火球术
-- 		self.iPlayerID = GetPlayerID(self:GetParent())
-- 		local hAblt = self:GetAbility()
-- 		if hAblt and not hAblt.bAddCard then
-- 			local tKV = KeyValues.SpellKv['sp_fireball']
-- 			for i = 1, self.count do
-- 				hAblt.bAddCard = true
-- 				HandSpellCards:AddCard(self.iPlayerID, 'sp_fireball')
-- 			end
-- 		end
-- 	end
-- end
-- function modifier_cmd_beginner_3:OnDestroy()
-- 	if IsServer() then
-- 		if GSManager:getStateType() == GS_Ready then
-- 			HandSpellCards:RemoveCardByID(self.iPlayerID, HandSpellCards:GetPlayerCardIDByName(self.iPlayerID, 'sp_fireball'))
-- 		end
-- 	end
-- end