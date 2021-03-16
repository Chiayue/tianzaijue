
modifier_bw_all_62 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_62:GetTexture()
	return "item_treasure/力量护腕"
end

function modifier_bw_all_62:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_bw_all_62:OnCreated( kv )
	
end

--------------------------------------------------------------------------------


function modifier_bw_all_62:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

