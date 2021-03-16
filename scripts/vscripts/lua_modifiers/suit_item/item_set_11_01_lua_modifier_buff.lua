
item_set_11_01_lua_modifier_buff = class({})

function item_set_11_01_lua_modifier_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end
function item_set_11_01_lua_modifier_buff:GetTexture( params )
    return "item_set_11_01_lua_modifier"
end
function item_set_11_01_lua_modifier_buff:GetModifierBonusStats_Intellect( params )	--智力
	
	
	return 10*self:GetStackCount()
end
--------------------------------------------------------------------------------

function item_set_11_01_lua_modifier_buff:IsDebuff()
	return false
end

function item_set_11_01_lua_modifier_buff:GetTexture( params )
    return "item_set_11_01_lua_modifier_buff"
end
function item_set_11_01_lua_modifier_buff:IsHidden()
	return false
	-- body
end
function item_set_11_01_lua_modifier_buff:OnCreated( kv )
	if IsServer() then
		self:SetStackCount(1)
	end
 	
end
function item_set_11_01_lua_modifier_buff:OnDestroy( kv )
	if IsServer() then
		
	end
 	
end

function item_set_11_01_lua_modifier_buff:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end
function item_set_11_01_lua_modifier_buff:OnDeath( params )
    if IsServer() then
       
		if params.unit == self:GetParent() then
			
	    	self:SetStackCount(math.ceil(self:GetStackCount()/2))
	    	
		end
	end

    return 0
end
