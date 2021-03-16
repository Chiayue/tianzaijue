LinkLuaModifier("modifier_courier_sp_focus", "abilities/courier/r/courier_sp_focus.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if courier_sp_focus == nil then
	courier_sp_focus = class({})
end
function courier_sp_focus:GetIntrinsicModifierName()
	return "modifier_courier_sp_focus"
end
---------------------------------------------------------------------
--Modifiers
if modifier_courier_sp_focus == nil then
	modifier_courier_sp_focus = class({}, nil, eom_modifier)
end
function modifier_courier_sp_focus:IsHidden()
	return true
end
function modifier_courier_sp_focus:OnCreated(params)
	self.count = self:GetAbilitySpecialValueFor('count')
	self:OnRefresh(params)
end
function modifier_courier_sp_focus:OnRefresh(params)
	self.count = self:GetAbilitySpecialValueFor('count')
	if IsServer() then
		--集火
		self.iPlayerID = GetPlayerID(self:GetParent())
		local hAblt = self:GetAbility()
		if hAblt and not hAblt.bAddCard then
			local tKV = KeyValues.SpellKv['sp_focus']
			for i = 1, self.count do
				hAblt.bAddCard = true
				HandSpellCards:AddCard(self.iPlayerID, 'sp_focus')
			end
		end
	end
end
function modifier_courier_sp_focus:OnDestroy()
	if IsServer() then
		if GSManager:getStateType() == GS_Ready then
			HandSpellCards:RemoveCardByID(self.iPlayerID, HandSpellCards:GetPlayerCardIDByName(self.iPlayerID, 'sp_focus'))
		end
	end
end