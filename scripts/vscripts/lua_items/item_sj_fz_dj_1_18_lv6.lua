require( "lua_items/item_sj_wq_ll_1_1_lv1" )
LinkLuaModifier( "item_assistitem", "lua_items/item_assistitem", LUA_MODIFIER_MOTION_NONE )
item_sj_fz_dj_1_18_lv6 = class( item_sj_wq_ll_1_1_lv1 )
function item_sj_fz_dj_1_18_lv6:GetIntrinsicModifierName()
	return "item_assistitem"
end