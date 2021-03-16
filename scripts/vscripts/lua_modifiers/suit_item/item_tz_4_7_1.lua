item_tz_4_7_1 = class({})  --添加
LinkLuaModifier( "item_set_11_01_lua_modifier", "lua_modifiers/suit_item/item_set_11_01_lua_modifier.lua", LUA_MODIFIER_MOTION_NONE ) 
LinkLuaModifier( "item_set_11_01_lua_modifier_buff", "lua_modifiers/suit_item/item_set_11_01_lua_modifier_buff.lua", LUA_MODIFIER_MOTION_NONE )
function item_tz_4_7_1:GetIntrinsicModifierName()
	return "item_set_11_01_lua_modifier"
end

