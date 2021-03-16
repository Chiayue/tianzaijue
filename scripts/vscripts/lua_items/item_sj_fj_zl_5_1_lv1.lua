require( "lua_items/item_sj_wq_ll_1_1_lv1" )
LinkLuaModifier( "item_clothes", "lua_items/item_clothes", LUA_MODIFIER_MOTION_NONE )
item_sj_fj_zl_5_1_lv1 = class( item_sj_wq_ll_1_1_lv1 )
function item_sj_fj_zl_5_1_lv1:GetIntrinsicModifierName()
	return "item_clothes"
end