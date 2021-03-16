LinkLuaModifier( "modifier_hdsn", "yxtf/modifier_hdsn", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hdsn_debuff", "yxtf/modifier_hdsn_debuff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
yxtfjn_hdsn = class({})

function yxtfjn_hdsn:GetIntrinsicModifierName()
	return "modifier_hdsn"
end

--------------------------------------------------------------------------------
-- Interval Effects


