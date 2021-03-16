modifier_boss_wood_lower_attr_lua_str = class({})
function modifier_boss_wood_lower_attr_lua_str:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end
function modifier_boss_wood_lower_attr_lua_str:GetModifierBonusStats_Strength( params )	--智力

	return -self:GetStackCount()
end
function modifier_boss_wood_lower_attr_lua_str:OnCreated( kv )
	if IsServer() then
			self:SetStackCount(math.ceil(self:GetParent():GetPrimaryStatValue()*0.33))
	end
end
function modifier_boss_wood_lower_attr_lua_str:OnRefresh( kv )
	if IsServer() then
			self:SetStackCount(math.ceil(self:GetParent():GetPrimaryStatValue()*0.33)+self:GetStackCount())
	end
end