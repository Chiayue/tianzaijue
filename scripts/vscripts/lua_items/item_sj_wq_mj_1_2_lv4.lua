require( "lua_items/item_sj_wq_ll_1_1_lv1" )
LinkLuaModifier( "item_weapon", "lua_items/item_weapon", LUA_MODIFIER_MOTION_NONE )
item_sj_wq_mj_1_2_lv4 = class( item_sj_wq_ll_1_1_lv1 )
function item_sj_wq_mj_1_2_lv4:GetIntrinsicModifierName()
	return "item_weapon"
end