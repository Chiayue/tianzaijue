
modifier_bw_2_8_buff = class({})
function modifier_bw_2_8_buff:GetTexture()
	return "item_treasure/modifier_bw_2_8_buff"
end
--------------------------------------------------------------------------------

function modifier_bw_2_8_buff:OnCreated( kv )
	if IsServer() then
		--print( "test" )
	end
end

--------------------------------------------------------------------------------

function modifier_bw_2_8_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_bw_2_8_buff:GetModifierAttackSpeedBonus_Constant( params )
	return 30
end

--------------------------------------------------------------------------------
function modifier_bw_2_8_buff:GetModifierMoveSpeedBonus_Percentage( params )
	return 5
end