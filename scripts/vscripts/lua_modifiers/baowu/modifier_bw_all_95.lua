
modifier_bw_all_95 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_95:GetTexture()
	return "item_treasure/力量护腕"
end

function modifier_bw_all_95:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_bw_all_95:OnCreated( kv )
	
end

--------------------------------------------------------------------------------


function modifier_bw_all_95:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

