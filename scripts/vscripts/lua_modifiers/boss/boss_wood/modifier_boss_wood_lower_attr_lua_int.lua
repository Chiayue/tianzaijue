modifier_boss_wood_lower_attr_lua_int = class({})
function modifier_boss_wood_lower_attr_lua_int:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end

function modifier_boss_wood_lower_attr_lua_int:GetModifierBonusStats_Intellect( params )	--智力
	return -self:GetStackCount()
end
function modifier_boss_wood_lower_attr_lua_int:OnCreated( kv )
	if IsServer() then
			self:SetStackCount(math.ceil(self:GetParent():GetPrimaryStatValue()*0.33))
	end
end
function modifier_boss_wood_lower_attr_lua_int:OnRefresh( kv )
	if IsServer() then
			self:SetStackCount(math.ceil(self:GetParent():GetPrimaryStatValue()*0.33)+self:GetStackCount())
	end
end