
modifier_bw_5_2_buff = class({})


function modifier_bw_5_2_buff:GetTexture()
	return "item_treasure/modifier_bw_5_2_buff"
end
--------------------------------------------------------------------------------
function modifier_bw_5_2_buff:IsDebuff(  )
	return true
end

function modifier_bw_5_2_buff:IsHidden()
	return false
end
function modifier_bw_5_2_buff:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_5_2_buff:OnRefresh()
	
end


function modifier_bw_5_2_buff:DeclareFunctions()
	local funcs = 
	{
		
		MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT,
	}
	return funcs
end
function modifier_bw_5_2_buff:GetModifierIncomingSpellDamageConstant( params )
	return  30
end
