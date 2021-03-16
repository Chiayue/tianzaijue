
modifier_bw_2_18 = class({})
LinkLuaModifier( "modifier_bw_2_18_exbuff", "lua_modifiers/baowu/modifier_bw_2_18_exbuff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function modifier_bw_2_18:GetTexture()
	return "item_treasure/无知小帽"
end
--------------------------------------------------------------------------------
function modifier_bw_2_18:IsHidden()
	return true
end
function modifier_bw_2_18:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_2_18:OnRefresh()
	if IsServer() then 
		self:SetStackCount(1)-- math.ceil(self:GetParent():GetMaxMana()*0.8))
		self:GetParent():AddNewModifier( self:GetParent(), self:GetParent(), "modifier_bw_2_18_exbuff", {} )
	end
end

function modifier_bw_2_18:OnDestroy()
	if IsServer() then 
		
		self:GetParent():RemoveModifierByName( "modifier_bw_2_18_exbuff" )
		-- Removes a modifier.
	end
end
function modifier_bw_2_18:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
