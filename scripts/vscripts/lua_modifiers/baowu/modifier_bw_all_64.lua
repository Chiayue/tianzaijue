
modifier_bw_all_64 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_64:GetTexture()
	return "item_treasure/力量护腕"
end

function modifier_bw_all_64:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_bw_all_64:OnCreated( kv )
	
end

--------------------------------------------------------------------------------


function modifier_bw_all_64:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

