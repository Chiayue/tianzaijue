require( "lua_items/item_sj_wq_ll_1_1_lv1" )
LinkLuaModifier( "item_jewelry", "lua_items/item_jewelry", LUA_MODIFIER_MOTION_NONE )
item_sj_sp_ty_4_3_lv1 = class( item_sj_wq_ll_1_1_lv1 )
function item_sj_sp_ty_4_3_lv1:GetIntrinsicModifierName()
	return "item_jewelry"
end