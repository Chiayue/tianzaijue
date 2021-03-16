
modifier_bw_all_63 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_63:GetTexture()
	return "item_treasure/力量护腕"
end

function modifier_bw_all_63:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_bw_all_63:OnCreated( kv )
	
end

--------------------------------------------------------------------------------


function modifier_bw_all_63:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

