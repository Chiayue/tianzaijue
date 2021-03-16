modifier_ch_1_3 = class({})

--------------------------------------------------------------------------------

function modifier_ch_1_3:GetTexture()
	return "item_treasure/学徒之礼"
end
--------------------------------------------------------------------------------
function modifier_ch_1_3:IsHidden()
	return true
end
function modifier_ch_1_3:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_ch_1_3:OnRefresh()
	
end


function modifier_ch_1_3:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end
function modifier_ch_1_3:GetModifierBonusStats_Intellect( params )
	if IsServer() then
		
		if self:GetParent():GetPrimaryAttribute()==2 then
			return 50
		end
		return 0
	end
	return 0
end
function modifier_ch_1_3:GetModifierBonusStats_Agility( params )
	if self:GetParent():GetPrimaryAttribute()==1 then
		return 50
	end
	return 0
end
function modifier_ch_1_3:GetModifierBonusStats_Strength( params )
	if self:GetParent():GetPrimaryAttribute()==0 then
		return 50
	end
	return 0
end
function modifier_ch_1_3:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end