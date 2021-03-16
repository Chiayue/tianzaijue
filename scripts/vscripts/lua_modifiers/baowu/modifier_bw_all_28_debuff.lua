
modifier_bw_all_28_debuff = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_28_debuff:GetTexture()
	return "item_treasure/modifier_bw_all_28_debuff"
end
--------------------------------------------------------------------------------

function modifier_bw_all_28_debuff:OnCreated( kv )
	
	self:OnRefresh()
end
function modifier_bw_all_28_debuff:IsHidden()
	return false
	
end
function modifier_bw_all_28_debuff:IsDebuff()
	return true
	
end
function modifier_bw_all_28_debuff:OnRefresh()
	
end


function modifier_bw_all_28_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end