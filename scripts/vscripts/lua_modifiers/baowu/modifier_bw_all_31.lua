
modifier_bw_all_31 = class({})

LinkLuaModifier( "modifier_bw_all_31_buff", "lua_modifiers/baowu/modifier_bw_all_31_buff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function modifier_bw_all_31:GetTexture()
	return "item_treasure/伤害豁免"
end
--------------------------------------------------------------------------------
function modifier_bw_all_31:IsHidden()
	return true
end
function modifier_bw_all_31:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 10 )
	end
	self:OnRefresh()
end


function modifier_bw_all_31:OnRefresh()
	
end


function modifier_bw_all_31:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
	}
	return funcs
end
function modifier_bw_all_31:GetModifierTotal_ConstantBlock( params )
	if IsServer() then
		if RollPercentage(50) then
			return 9999999
		end
	end
	return 0
	
end
function modifier_bw_all_31:OnIntervalThink()
	if IsServer() then
		if self:GetParent() then
			self:GetParent():AddNewModifier( self:GetParent(), nil, "modifier_bw_all_31_buff", {duration=3} )
		end
	end
end
function modifier_bw_all_31:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end