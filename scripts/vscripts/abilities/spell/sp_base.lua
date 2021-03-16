if sp_base == nil then
	---@class sp_base 法术卡基类
	sp_base = class({})
end
function sp_base:GetManaCost(iLevel)
	local C
	local iBouns = self:GetCaster():GetVal(ATTRIBUTE_KIND.SpellCardManaCostBonus, self)
	local fPer = self:GetCaster():GetVal(ATTRIBUTE_KIND.SpellCardManaCostPercentage, self)
	if IsServer() then
		C = CDOTA_Ability_Lua
	else
		C = C_DOTA_Ability_Lua
	end
	local iVal = C.GetManaCost(self, iLevel)
	return (iVal + iBouns) * (1 + fPer * 0.01)
end
function sp_base:IsHidden()
	return true
end