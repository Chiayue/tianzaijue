modifier_boss_wood_bot_lunpan_lua_effect = class({})

--------------------------------------------------------------------------------

function modifier_boss_wood_bot_lunpan_lua_effect:IsHidden()
	return true
end




--------------------------------------------------------------------------------

function modifier_boss_wood_bot_lunpan_lua_effect:OnCreated( kv )
	
	if IsServer() then
		
		self:SetStackCount(1)
	end
end

function modifier_boss_wood_bot_lunpan_lua_effect:OnRefresh( kv )
	
	if IsServer() then
		
		self:SetStackCount(1+self:GetStackCount())
	end
end
function modifier_boss_wood_bot_lunpan_lua_effect:OnDestroy( kv )
	
	
end
--------------------------------------------------------------------------------