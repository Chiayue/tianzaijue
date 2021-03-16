require( "lua_items/item_sj_wq_ll_1_1_lv1" )
LinkLuaModifier( "item_jewelry", "lua_items/item_jewelry", LUA_MODIFIER_MOTION_NONE )
item_sj_sp_ty_5_1_lv5 = class( item_sj_wq_ll_1_1_lv1 )
function item_sj_sp_ty_5_1_lv5:GetIntrinsicModifierName()
	return "item_jewelry"
end