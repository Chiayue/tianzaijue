
modifier_bw_3_19_buff = class({})


function modifier_bw_3_19_buff:GetTexture()
	return "item_treasure/modifier_bw_3_19_buff"
end
--------------------------------------------------------------------------------
function modifier_bw_3_19_buff:IsDebuff(  )
	return true
end
function modifier_bw_3_19_buff:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_3_19_buff:OnRefresh()
	
end


function modifier_bw_3_19_buff:DeclareFunctions()
	local funcs = 
	{
		
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end
function modifier_bw_3_19_buff:GetModifierMagicalResistanceBonus( params )
	return  -20
end
