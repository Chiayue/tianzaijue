
modifiy_shopmall_tszc_6_buff = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_tszc_6_buff:GetTexture()
	return "rune/shopmall_tszc_6"
end

function modifiy_shopmall_tszc_6_buff:IsHidden()
	return false
end
--------------------------------------------------------------------------------

function modifiy_shopmall_tszc_6_buff:OnCreated( kv )
	self:OnRefresh()
end
function modifiy_shopmall_tszc_6_buff:OnRefresh()
	
end
--------------------------------------------------------------------------------

function modifiy_shopmall_tszc_6_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_BONUS_DAY_VISION,
	}
	return funcs
end
function modifiy_shopmall_tszc_6_buff:GetBonusDayVision( params )
	return self:GetStackCount()
end

function modifiy_shopmall_tszc_6_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

