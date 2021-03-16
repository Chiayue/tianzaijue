require( "lua_items/item_sj_wq_ll_1_1_lv1" )
LinkLuaModifier( "item_clothes", "lua_items/item_clothes", LUA_MODIFIER_MOTION_NONE )
item_sj_fj_zl_3_1_lv5 = class( item_sj_wq_ll_1_1_lv1 )
function item_sj_fj_zl_3_1_lv5:GetIntrinsicModifierName()
	return "item_clothes"
end