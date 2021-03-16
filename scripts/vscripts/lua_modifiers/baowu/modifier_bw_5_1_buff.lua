
modifier_bw_5_1_buff = class({})


function modifier_bw_5_1_buff:GetTexture()
	return "item_treasure/modifier_bw_5_1_buff"
end
--------------------------------------------------------------------------------
function modifier_bw_5_1_buff:IsDebuff(  )
	return true
end

function modifier_bw_5_1_buff:IsHidden()
	return false
end
function modifier_bw_5_1_buff:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_5_1_buff:OnRefresh()
	
end


function modifier_bw_5_1_buff:DeclareFunctions()
	local funcs = 
	{
		
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
	}
	return funcs
end
function modifier_bw_5_1_buff:GetModifierIncomingPhysicalDamage_Percentage( params )
	return  20
end

