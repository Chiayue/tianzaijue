
modifier_bw_3_9_debuff = class({})

--------------------------------------------------------------------------------

function modifier_bw_3_9_debuff:GetTexture()
	return "item_treasure/modifier_bw_3_9_debuff"
end
--------------------------------------------------------------------------------

function modifier_bw_3_9_debuff:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_3_9_debuff:OnRefresh()
	
end


function modifier_bw_3_9_debuff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end
function modifier_bw_3_9_debuff:GetModifierMoveSpeedBonus_Percentage( params )
	return -50
end
