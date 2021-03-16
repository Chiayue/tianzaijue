
modifier_bw_all_34 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_34:GetTexture()
	return "item_treasure/钻石化"
end
--------------------------------------------------------------------------------

function modifier_bw_all_34:OnCreated( kv )
	
	self:OnRefresh()
end
function modifier_bw_all_34:IsHidden()
	return true
end

function modifier_bw_all_34:OnRefresh()
	
end


function modifier_bw_all_34:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end
function modifier_bw_all_34:GetModifierMoveSpeedBonus_Percentage( params )
	return -15
end
function modifier_bw_all_34:GetModifierIncomingDamage_Percentage( params )
	return -20
end

function modifier_bw_all_34:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end