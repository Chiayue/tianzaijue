
modifier_bw_all_99_buff = class({})


function modifier_bw_all_99_buff:GetTexture()
	return "item_treasure/modifier_bw_all_99_buff"
end
--------------------------------------------------------------------------------
function modifier_bw_all_99_buff:IsDebuff(  )
	return true
end

function modifier_bw_all_99_buff:IsHidden()
	return true
end
function modifier_bw_all_99_buff:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_all_99_buff:OnRefresh()
	
end


function modifier_bw_all_99_buff:DeclareFunctions()
	local funcs = 
	{
		
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end
function modifier_bw_all_99_buff:GetModifierPhysicalArmorBonus( params )
	return  -self:GetStackCount()
end

function modifier_bw_all_99_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end