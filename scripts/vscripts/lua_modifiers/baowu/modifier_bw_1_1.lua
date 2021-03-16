
modifier_bw_1_1 = class({})

--------------------------------------------------------------------------------

function modifier_bw_1_1:GetTexture()
	return "item_treasure/守护指环"
end



function modifier_bw_1_1:IsHidden()
	return true
end
--------------------------------------------------------------------------------


function modifier_bw_1_1:OnCreated( kv )
	self:OnRefresh()
end
function modifier_bw_1_1:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
	end
end
--------------------------------------------------------------------------------

function modifier_bw_1_1:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end
function modifier_bw_1_1:GetModifierPhysicalArmorBonus( params )
	return self:GetStackCount()*20
end

function modifier_bw_1_1:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

