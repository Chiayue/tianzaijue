
modifier_bw_4_1 = class({})

--------------------------------------------------------------------------------

function modifier_bw_4_1:GetTexture()
	return "item_treasure/原力鞋"
end
--------------------------------------------------------------------------------
function modifier_bw_4_1:IsHidden()
	return true
end
function modifier_bw_4_1:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_4_1:OnRefresh()
	
end


function modifier_bw_4_1:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	}
	return funcs
end
function modifier_bw_4_1:GetModifierMoveSpeedBonus_Constant( params )
	return 150
end
function modifier_bw_4_1:GetModifierIgnoreMovespeedLimit()
    return 1
end

function modifier_bw_4_1:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end