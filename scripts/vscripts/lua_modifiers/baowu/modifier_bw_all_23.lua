
modifier_bw_all_23 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_23:GetTexture()
	return "item_treasure/提升护甲"
end
--------------------------------------------------------------------------------
function modifier_bw_all_23:IsHidden()
	return true
end
function modifier_bw_all_23:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_all_23:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
	end
end


function modifier_bw_all_23:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end
function modifier_bw_all_23:GetModifierPhysicalArmorBonus( params )
	return self:GetStackCount()*30
end

function modifier_bw_all_23:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end