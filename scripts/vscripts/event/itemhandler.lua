--物品相关的时间处理
local m = {}

----物品捡起事件
--<pre>
--keys属性有：
--ItemEntityIndex:物品实体索引
--PlayerID: 对应玩家id
--UnitEntityIndex: 拾取单位实体索引（和HeroEntityIndex互斥）
--HeroEntityIndex：拾取英雄实体索引（和UnitEntityIndex互斥）
--itemname: 掉落的物品名称
--splitscreenplayer:不知道是啥。。。
--</pre>
function m:OnItemPickedUp(keys)

end

--物品被玩家购买时触发
--function m:OnItemPurchased( keys )
----[[  DebugPrint( '[BAREBONES] OnItemPurchased' )
--  DebugPrintTable(keys)
--
--  -- The playerID of the hero who is buying something
--  local plyID = keys.PlayerID
--  if not plyID then return end
--
--  -- The name of the item purchased
--  local itemName = keys.itemname
--
--  -- The cost of the item purchased
--  local itemcost = keys.itemcost--]]
--
--end

return m
