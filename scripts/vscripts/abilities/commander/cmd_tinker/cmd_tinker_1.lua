LinkLuaModifier("modifier_cmd_tinker_1", "abilities/commander/cmd_tinker/cmd_tinker_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_tinker_1 == nil then
	cmd_tinker_1 = class({})
end
function cmd_tinker_1:GetIntrinsicModifierName()
	return "modifier_cmd_tinker_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_tinker_1 == nil then
	modifier_cmd_tinker_1 = class({}, nil, eom_modifier)
end
function modifier_cmd_tinker_1:IsHidden()
	return true
end
function modifier_cmd_tinker_1:OnCreated(params)
	self.discount_rarity = self:GetAbilitySpecialValueFor("discount_rarity")
	self.srbuy_decpct = self:GetAbilitySpecialValueFor("srbuy_decpct")
	if IsServer() then
		self.iPlayerID = GetPlayerID(self:GetParent())
	end
end
function modifier_cmd_tinker_1:OnRefresh(params)
	self.discount_rarity = self:GetAbilitySpecialValueFor("discount_rarity")
	self.srbuy_decpct = self:GetAbilitySpecialValueFor("srbuy_decpct")
	if IsServer() then
	end
end
function modifier_cmd_tinker_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_cmd_tinker_1:EDeclareFunctions()
	return {
		EMDF_BUY_CARD_DISCOUNT_PERCENTAGE
	}
end
function modifier_cmd_tinker_1:GetModifierCardBuyDiscont(sCardName)
	return self.srbuy_decpct
end