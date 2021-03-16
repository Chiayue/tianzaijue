
modifier_bw_4_3 = class({})

--------------------------------------------------------------------------------

function modifier_bw_4_3:GetTexture()
	return "item_treasure/神盾镜"
end
--------------------------------------------------------------------------------
function modifier_bw_4_3:IsHidden()
	return true
end
function modifier_bw_4_3:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_4_3:OnRefresh()
	
end


function modifier_bw_4_3:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end
function modifier_bw_4_3:GetModifierBonusStats_Intellect( params )
	return 8888
end
function modifier_bw_4_3:GetModifierBonusStats_Agility( params )
	return 8888
end
function modifier_bw_4_3:GetModifierBonusStats_Strength( params )
	return 8888
end

function modifier_bw_4_3:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end