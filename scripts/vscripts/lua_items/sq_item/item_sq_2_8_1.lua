require( "lua_items/sq_item/item_sq_1_1_1" )
LinkLuaModifier( "item_sq_pd", "lua_items/sq_item/item_sq_pd", LUA_MODIFIER_MOTION_NONE )
item_sq_2_8_1 = class( item_sq_1_1_1 )
function item_sq_2_8_1:GetIntrinsicModifierName()
	return "item_sq_pd"
end