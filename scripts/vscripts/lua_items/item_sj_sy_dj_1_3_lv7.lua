require( "lua_items/item_sj_wq_ll_1_1_lv1" )
LinkLuaModifier( "item_inhomeitem", "lua_items/item_inhomeitem", LUA_MODIFIER_MOTION_NONE )
item_sj_sy_dj_1_3_lv7 = class( item_sj_wq_ll_1_1_lv1 )
function item_sj_sy_dj_1_3_lv7:GetIntrinsicModifierName()
	return "item_inhomeitem"
end