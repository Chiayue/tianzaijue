
modifiy_shopmall_cmzc_2_buff = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_cmzc_2_buff:GetTexture()
	return "rune/shopmall_cmzc_2"
end
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------

function modifiy_shopmall_cmzc_2_buff:OnCreated( kv )
	if IsServer() then
		self.cs =  math.ceil(self:GetParent():GetPhysicalArmorBaseValue() *0.2) 
		self:OnRefresh()
	end
end


function modifiy_shopmall_cmzc_2_buff:OnRefresh()
	if IsServer() then
		self:SetStackCount(self.cs)
	end
end


function modifiy_shopmall_cmzc_2_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end
function modifiy_shopmall_cmzc_2_buff:GetModifierPhysicalArmorBonus( params )
	return self:GetStackCount()*-1
end
