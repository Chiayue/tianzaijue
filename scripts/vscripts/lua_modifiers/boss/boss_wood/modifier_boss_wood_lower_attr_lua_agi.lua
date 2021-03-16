modifier_boss_wood_lower_attr_lua_agi = class({})
function modifier_boss_wood_lower_attr_lua_agi:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
	return funcs
end
function modifier_boss_wood_lower_attr_lua_agi:GetModifierBonusStats_Agility( params )	--智力
	return -self:GetStackCount()
end
function modifier_boss_wood_lower_attr_lua_agi:OnCreated( kv )
	if IsServer() then
			self:SetStackCount(math.ceil(self:GetParent():GetPrimaryStatValue()*0.33))
	end
end
function modifier_boss_wood_lower_attr_lua_agi:OnRefresh( kv )
	if IsServer() then
			self:SetStackCount(math.ceil(self:GetParent():GetPrimaryStatValue()*0.33)+self:GetStackCount())
	end
end