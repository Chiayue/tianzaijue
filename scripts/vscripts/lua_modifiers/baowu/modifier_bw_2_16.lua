
modifier_bw_2_16 = class({})

--------------------------------------------------------------------------------

function modifier_bw_2_16:GetTexture()
	return "item_treasure/学徒之礼"
end
--------------------------------------------------------------------------------
function modifier_bw_2_16:IsHidden()
	return true
end
function modifier_bw_2_16:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_2_16:OnRefresh()
	
end


function modifier_bw_2_16:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end
function modifier_bw_2_16:GetModifierBonusStats_Intellect( params )
	if IsServer() then
		
		if self:GetParent():GetPrimaryAttribute()==2 then
			return 0
		end
		return 1500
	end
	return 0
end
function modifier_bw_2_16:GetModifierBonusStats_Agility( params )
	if self:GetParent():GetPrimaryAttribute()==1 then
		return 0
	end
	return 1500
end
function modifier_bw_2_16:GetModifierBonusStats_Strength( params )
	if self:GetParent():GetPrimaryAttribute()==0 then
		return 0
	end
	return 1500
end
function modifier_bw_2_16:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end