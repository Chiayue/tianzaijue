
modifier_bw_2_15_buff = class({})


function modifier_bw_2_15_buff:GetTexture()
	return "item_treasure/modifier_bw_2_15_buff"
end
--------------------------------------------------------------------------------
function modifier_bw_2_15_buff:IsDebuff(  )
	return true
end
function modifier_bw_2_15_buff:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_2_15_buff:OnRefresh()
	
end


function modifier_bw_2_15_buff:DeclareFunctions()
	local funcs = 
	{
		
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end
function modifier_bw_2_15_buff:GetModifierMagicalResistanceBonus( params )
	return  -20
end
