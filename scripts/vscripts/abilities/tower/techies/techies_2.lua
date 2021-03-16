LinkLuaModifier("modifier_techies_2", "abilities/tower/techies/techies_2.lua", LUA_MODIFIER_MOTION_NONE)
if techies_2 == nil then
	techies_2 = class({})
end
function techies_2:OnSpellStart(hTarget)
	local hCaster = self:GetCaster()
	hTarget:AddBuff(hCaster, BUFF_TYPE.IGNITE, self:GetDuration(), true, {iCount = self:GetSpecialValueFor("ignite_count") * 0.2})
end
function techies_2:GetIntrinsicModifierName()
	return "modifier_techies_2"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_techies_2 == nil then
	modifier_techies_2 = class({}, nil, ModifierHidden)
end