LinkLuaModifier("modifier_cmd_huskar_3", "abilities/commander/cmd_huskar/cmd_huskar_3.lua", LUA_MODIFIER_MOTION_NONE)

if cmd_huskar_3 == nil then
	cmd_huskar_3 = class({})
end
function cmd_huskar_3:GetIntrinsicModifierName()
	return "modifier_cmd_huskar_3"
end

---------------------------------------------------------------------
--Modifiers
if modifier_cmd_huskar_3 == nil then
	modifier_cmd_huskar_3 = class({}, nil, eom_modifier)
end
function modifier_cmd_huskar_3:IsHidden()
	return true
end
function modifier_cmd_huskar_3:OnCreated(params)
	self.number = self:GetAbilitySpecialValueFor('number')
	-- self:OnRefresh(params)
end
function modifier_cmd_huskar_3:EDeclareFunctions()
	return {
		[EMDF_EVENT_CUSTOM] = { ET_GAME.GAME_BEGIN, self.OnGameBegin }
	}
end
function modifier_cmd_huskar_3:OnGameBegin()
	self.number = self:GetAbilitySpecialValueFor('number')
	if IsServer() then
		--肉体忍耐
		self.iPlayerID = GetPlayerID(self:GetParent())
		local hAblt = self:GetAbility()
		if hAblt then
			for i = 0, self.number - 1 do
				HandSpellCards:AddCard(self.iPlayerID, 'sp_physicalendurance')
			end
		end
	end
end
-- function modifier_cmd_huskar_3:OnRefresh(params)-- 	self.number = self:GetAbilitySpecialValueFor('number')-- 	if IsServer() then-- 		--肉体忍耐-- 		self.iPlayerID = GetPlayerID(self:GetParent())-- 		local hAblt = self:GetAbility()-- 		if hAblt and not hAblt.bAddCard then-- 			local tKV = KeyValues.SpellKv['sp_physicalendurance']-- 			for i = 1, self.number do-- 				hAblt.bAddCard = true-- 				HandSpellCards:AddCard(self.iPlayerID, 'sp_physicalendurance')-- 			end-- 		end-- 	end-- end-- function modifier_cmd_huskar_3:OnDestroy()-- 	if IsServer() then-- 		if GSManager:getStateType() == GS_Ready then-- 			HandSpellCards:RemoveCardByID(self.iPlayerID, HandSpellCards:GetPlayerCardIDByName(self.iPlayerID, 'sp_physicalendurance'))-- 		end-- 	end-- end