
modifier_bw_5_5_buff = class({})

--------------------------------------------------------------------------------

function modifier_bw_5_5_buff:GetTexture()
	return "item_treasure/bw_all_45"
end

function modifier_bw_5_5_buff:IsHidden()
	return false
end
--------------------------------------------------------------------------------

function modifier_bw_5_5_buff:OnCreated( kv )
	self:OnRefresh()
end
function modifier_bw_5_5_buff:OnRefresh()
	
end
--------------------------------------------------------------------------------

function modifier_bw_5_5_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
	return funcs
end


function modifier_bw_5_5_buff:GetModifierBonusStats_Agility( params )
	return self:GetStackCount() 
end

-----------------------------------------------------------------------

