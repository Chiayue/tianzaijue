item_sj_wq_ll_1_1 = class({})
LinkLuaModifier( "item_weapon", "lua_items/item_weapon", LUA_MODIFIER_MOTION_NONE )


--function item_sj_wq_ll_1_1:Spawn()
--	if IsServer() then
--
--	end
--end
function item_sj_wq_ll_1_1:GetIntrinsicModifierName()
	return "item_weapon"
end
