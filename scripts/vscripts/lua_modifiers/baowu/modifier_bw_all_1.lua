
modifier_bw_all_1 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_1:GetTexture()
	return "item_treasure/电锯惊魂"
end
function modifier_bw_all_1:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_bw_all_1:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_all_1:OnRefresh()
	
end


function modifier_bw_all_1:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end
function modifier_bw_all_1:GetModifierPhysicalArmorBonus( params )
	return -40
end

function modifier_bw_all_1:GetModifierAttackSpeedBonus_Constant( params )
	return 200
end

function modifier_bw_all_1:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end