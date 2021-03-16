LinkLuaModifier( "modifier_affix_mana_inc", "abilities/consumable/affix_mana_inc.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if affix_mana_inc == nil then
	affix_mana_inc = class({})
end
function affix_mana_inc:GetIntrinsicModifierName()
	return "modifier_affix_mana_inc"
end
---------------------------------------------------------------------
--Modifiers
if modifier_affix_mana_inc == nil then
	modifier_affix_mana_inc = class({})
end
function modifier_affix_mana_inc:OnCreated(params)
	if IsServer() then
	end
end
function modifier_affix_mana_inc:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_affix_mana_inc:OnDestroy()
	if IsServer() then
	end
end
function modifier_affix_mana_inc:DeclareFunctions()
	return {
	}
end