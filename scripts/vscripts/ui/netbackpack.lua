NetEquip=require("server.NetEquip")
if Netbackpack == nil then
	Netbackpack = {}
	NetbackpackConfig = {}
	

	-- 存储单位的物品数据
	Netbackpack.m_UnitItems = {}
	Netbackpack.UnitKeyItems = {} --暂存开箱装备
	Netbackpack.m_Unitposition = {}
	setmetatable(Netbackpack,Netbackpack)
end

-- 背包格数
--1-6就是装备栏（1=武器，2=护甲，3=饰品1,4=饰品2,5=特殊1,6=特殊2） 
NetbackpackConfig.rightposition={}
NetbackpackConfig.rightposition[1]="wq"
NetbackpackConfig.rightposition[2]="fj"
NetbackpackConfig.rightposition[3]="ss"
NetbackpackConfig.rightposition[4]="ss"
NetbackpackConfig.rightposition[5]="ts"
NetbackpackConfig.rightposition[6]="ts"
NetbackpackConfig.EquipNum = 6
NetbackpackConfig.MaxItem = 54

function Netbackpack:refreshmodifier( unit)
	LinkLuaModifier( "modifier_item_net_aaaa", "lua_items/net_item/modifier_item_net_aaaa", LUA_MODIFIER_MOTION_NONE )
	unit:RemoveModifierByName("modifier_item_net_aaaa")
	local buff_list={}
	buff_list.item_attributes={}
	local hasitem=false
	for i=1,6 do
		local itemindex= self:GetItemIndex( unit, i )
		if itemindex~=-1 then
			local item=EntIndexToHScript(self:GetItemIndex( unit, i ))
			local itemattrtable=item.itemtype --CustomNetTables:GetTableValue( "ItemsInfo", tostring(item) )
			if itemattrtable then
				for k,V in pairs(itemattrtable) do 
					if k=="item_attributes" or  k=="item_attributes_spe" then
						if itemattrtable[k]~=nil then
							for kk,vv in pairs(itemattrtable[k]) do
								if  buff_list.item_attributes[kk]==nil then
									buff_list.item_attributes[kk]=itemattrtable[k][kk]
								else
									buff_list.item_attributes[kk]=buff_list.item_attributes[kk]+itemattrtable[k][kk]
								end
								hasitem=true
							end
						end
					end
				end
			end
			
		end
	end
	
	if hasitem then
		CustomNetTables:SetTableValue( "ItemsInfo", "modifier_item_net_aaaa", buff_list) 
		unit:AddNewModifier( unit, nil, "modifier_item_net_aaaa", {} )
	end
	return true
end
Netbackpack.DelEquipState=function( state)
--print("Netbackpack")
--print(state)
end
---直接把物品数据和位置上传服务器
function Netbackpack:SaveNetEquipFromItem( unit, packIndex,item,source,again )
	if item==nil then
		return false
	end
	local tempdata=CustomNetTables:GetTableValue( "ItemsInfoShow", string.format( "%d", item:GetEntityIndex() ))
	local temp={}
	temp['item_attributes']=tempdata['item_attributes']
	temp['item_attributes_spe']=tempdata['item_attributes_spe']
	local savenet=false
	if source==SrvNetEquip.source_drop then --正常掉落 和开宝箱区别
		local pack = self:GetNetbackpack(unit)
		pack[packIndex] = item:GetEntityIndex()
		SrvNetEquip.AddEquip(unit:GetPlayerID(),packIndex,item:GetAbilityName(),item.lv,item.pz,math.ceil(item.zdl),temp,source,function(success,arg2)
			if success then
				item.serverID = arg2
				self:UpdateItem( unit, packIndex )
			else
				if tonumber(arg2)==-1 then
					if again then
						local pack = self:GetNetbackpack(unit)
						pack[packIndex] = -1
						CreateItemOnGround(item,nil,unit:GetAbsOrigin(),100)
					else
						Netbackpack:SaveNetEquipFromItem( unit, packIndex,item,source,true )
					end
				else
					print("SaveEQfail",arg2)
				end
			end
			
		end)
	else
		
		local pack = self:GetNetbackpack(unit)
		pack[packIndex] = item:GetEntityIndex()
		
		if Netbackpack.UnitKeyItems[unit:GetPlayerID()]==nil then
			Netbackpack.UnitKeyItems[unit:GetPlayerID()]={}
		end
		local temptable={}
		temptable['type']=2
		temptable['slot']=packIndex
		temptable['entityindex']=item:GetEntityIndex()
		temptable['item']=item:GetAbilityName()
		temptable['grade']=item.lv
		temptable['quality']=item.pz
		temptable['score']=math.ceil(item.zdl)
		temptable['attr']=JSON.encode(temp)
		table.insert(Netbackpack.UnitKeyItems[unit:GetPlayerID()],temptable)
	end
end
--source来源
--[[function Netbackpack:SaveNetEquip( unit, packIndex,source )
	local itemindex=self:GetItemIndex( unit, packIndex )
	if itemindex==-1 then
		return false
	else
		local item=EntIndexToHScript(itemindex)
		local tempdata=CustomNetTables:GetTableValue( "ItemsInfoShow", string.format( "%d", item:GetEntityIndex() ))
		local temp={}
		temp['item_attributes']=tempdata['item_attributes']
		temp['item_attributes_spe']=tempdata['item_attributes_spe']
		SrvNetEquip.AddEquip(unit:GetPlayerID(),packIndex,item:GetAbilityName(),item.lv,item.pz,item.zdl,temp,source,function(success)
			return success
		end)
	end
end]]
function Netbackpack:UpdateItem( unit, packIndex )
	if packIndex>0 and packIndex<7 then --1到6格更新modifier
		self:refreshmodifier(unit)
	end
	if EntityNotNull(unit) then
        local pack=self:GetNetbackpack(unit)
        CustomNetTables:SetTableValue("tzj_storage", "net_equip_"..unit:GetPlayerOwnerID(),pack)
	end
	
end
-- 获取背包
-- @param unit handle 单位
-- 
function Netbackpack:GetNetbackpack( unit )
	if type(unit) ~= "table" then return nil end
	if unit:IsNull() then return nil end
	return Netbackpack.m_UnitItems[unit:GetEntityIndex()]
end

-- 获取背包物品数量
-- @param unit handle 单位
-- 
function Netbackpack:GetItemsNum( unit )
	if type(unit) ~= "table" then return NetbackpackConfig.MaxItem end
	if unit:IsNull() then return NetbackpackConfig.MaxItem end

	if self:HasNetbackpack(unit) then
		local pack = self:GetNetbackpack(unit) or {}
		local num = 0

		for kk,itemIndex in pairs(pack) do
			if tonumber(kk)>NetbackpackConfig.EquipNum and itemIndex ~= -1 then
				num = num + 1
			end
		end

		return num
	end

	return NetbackpackkConfig.MaxItem
end

-- 判断单位是否有背包
-- @param unit handle 单位
-- 
function Netbackpack:HasNetbackpack( unit )
	return self:GetNetbackpack(unit) ~= nil
end

-- 判断背包是否填满
-- @param unit handle 单位
-- 
function Netbackpack:IsFull( unit )
	return self:GetItemsNum(unit) == (NetbackpackConfig.MaxItem-NetbackpackConfig.EquipNum)
end

-- 判断背包中是否有物品
-- @param unit handle 单位
-- @param itemIndex int 物品EntityIndex
-- 
function Netbackpack:HasItem( unit, itemIndex )
	if self:HasNetbackpack(unit) then

		local pack = self:GetNetbackpack(unit)

		for packIndex,index in pairs(pack) do
			
			if index == itemIndex then
				return true,packIndex
			end
		end
	end

	return false
end

-- 移除物品
-- @param unit handle 单位
-- @param packIndex int 背包中的位置
-- 
function Netbackpack:RemoveItem( unit, packIndex )
	
	if packIndex > NetbackpackConfig.MaxItem or packIndex < 0 then return false end

	local pack = self:GetNetbackpack(unit)
	if pack then
		if pack[packIndex] == -1 then
			return
		end
		local PlayerID = unit:GetPlayerID()
		local itemtemp = pack[packIndex]
		local item = EntIndexToHScript(itemtemp)
		local js = item.js
		SrvNetEquip.DestroyEquip(PlayerID,item.serverID,item.js,function(success,arg2)
			if success then
				Shopmall:SetStone(PlayerID,"3",2,arg2) 
				pack[packIndex] = -1
				self:UpdateItem( unit, packIndex )
				NotifyUtil.ShowSysMsg2(unit:GetPlayerID(),"nettable_js",{value=js})
				EntityHelper.remove(item)
			else
				if arg2 == 3 then
					pack[packIndex] = -1
					self:UpdateItem( unit, packIndex )
				else
					NotifyUtil.BottomUnique(PlayerID,"#info_operation_faild",3,"red",NotifyUtil.STYLE_BlackBack_Alpha)
				end
				print("DestroyEquipfail",arg2)
			end
		end)
	end
end
-- 批量移除物品
-- @param unit handle 单位
-- @param packIndex int 背包中的位置
-- 
function Netbackpack:RemoveItemBatch( unit, slots )
	local serverid={}
	local packindextable={}
	local totaljs=0
	local pack = self:GetNetbackpack(unit)
	local PlayerID = unit:GetPlayerID()
	if pack then
		for k,v in pairs(slots) do
			if pack[v] ~= -1 then
				local itemtemp = pack[v]
				local item = EntIndexToHScript(itemtemp)
				local js = item.js
				totaljs=totaljs+item.js	
				table.insert(serverid,item.serverID)
				table.insert(packindextable,v)
			end
		end
		
		
---从服务器上批量销毁存档装备
--@param #number PlayerID 玩家id(0,1,2....)
--@param #table serverIDs 存档装备的服务器id组成的table，数组结构
--@param #number jing 分解装备返还的晶石数量
--@param #function callback 回调函数，第一个参数代表处理结果，true表示删除成功，false表示失败 
--如果成功了，第二个参数代表玩家现在的晶石总量 
--如果失败了，第二个参数代表失败代码：-1=服务器未响应，0=未知错误，1=传入的参数非法（检查PlayerID和ServerIDs），2=装备销毁失败（可能是装备不存在），3=晶石增加失败

		SrvNetEquip.DestroyEquipBatch(PlayerID,serverid,totaljs,function(success,arg2)
			SendToClient(PlayerID,"ui_event_netbackpack_del_item_batch_return",{success=success})
			if success then
				Shopmall:SetStone(PlayerID,"3",2,arg2) 
				for k,v in pairs(packindextable) do
					pack[v] = -1
				end
				self:UpdateItem( unit, 1 )
				
				NotifyUtil.ShowSysMsg2(unit:GetPlayerID(),"nettable_js",{value=totaljs})
				EntityHelper.remove(item)
			else
				if arg2 == 3 then
					--pack[packIndex] = -1
					--self:UpdateItem( unit, 1 )
				else
					NotifyUtil.BottomUnique(PlayerID,"#info_operation_faild",3,"red",NotifyUtil.STYLE_BlackBack_Alpha)
				end
				print("DestroyEquipfail",arg2)
			end
		end)
	end
end

-- 查找物品
-- @param unit handle 单位
-- @param itemName string 物品名称
-- 
function Netbackpack:FindItemByName( unit, itemName )
	local pack = self:GetNetbackpack(unit)

	if pack then
	 	for packIndex,itemIndex in pairs(pack) do
	 		local item = EntIndexToHScript(itemIndex)
	 		if item and item:GetAbilityName() == itemName then
	 			return item,packIndex
	 		end
	 	end
	end

	return nil
end

-- 查看物品是否在背包中
-- @param unit handle 单位
-- @param item handle 物品
-- 
function Netbackpack:HasItemInNetbackpack( unit, item )
	if type(item) ~= "table" then return false end
	if item:IsNull() then return false end

	return self:HasItem( unit, item:GetEntityIndex() )
end

-- 获取一个空的物品格
-- @param unit handle 单位
-- 
function Netbackpack:GetNotUseIndex( unit )
	if not self:IsFull(unit) then
		local pack = self:GetNetbackpack(unit) or {}

		for packIndex,itemIndex in pairs(pack) do
			if packIndex >NetbackpackConfig.EquipNum and itemIndex == -1 then
				return packIndex
			end
		end
	end

	return -1
end
-- 获取背包空位个数
-- @param unit handle 单位
-- 
function Netbackpack:GetNotUseNum( unit )
	if not self:IsFull(unit) then
		local pack = self:GetNetbackpack(unit) or {}
		local num=0
		for packIndex,itemIndex in pairs(pack) do
			if packIndex >NetbackpackConfig.EquipNum and itemIndex == -1 then
				num=num+1
			end
		end
		return num
	end

	return 0
end

-- 获取物品
-- @param unit handle 单位
-- @param packIndex int 背包中的位置
-- 
function Netbackpack:GetItemIndex( unit, packIndex )
	local pack = self:GetNetbackpack(unit)

	if pack then
	 	local itemIndex = pack[packIndex]

	 	if itemIndex then
	 		return itemIndex
	 	end
	end

	return -1
end
-- 立即添加物品到背包
-- 立即添加物品到背包

function Netbackpack:AddItemImmediate( unit, item,slot,source )

	if type(item) ~= "table" then return false end
	if item:IsNull() then return false end

	if self:IsFull(unit) then return false end

	if self:HasItemInNetbackpack( unit, item ) then return false end

	local tt=item
	if item:IsStackable() then --是不是消耗品
		return false
	else
		if slot==-1 then  --判断有没有传背包格子参数  -1 任意格子
			local pack = self:GetNetbackpack(unit)
			local packIndex=-1
			local hasitem=false
			for i=1,6 do ---检测没有装备物品就直接装备物品
				if hasitem==false and pack[i]==-1 and self:rightpositionItem(item,i) then
					hasitem=true
					packIndex=i
				end
			end
			if packIndex==-1 then
				packIndex = self:GetNotUseIndex(unit)
			end
			if packIndex ~= -1 then
				self:SaveNetEquipFromItem( unit, packIndex,item,source )
				unit:TakeItem(item)
				return true
			else
				return false
			end
		else
			return false
		end
	end
	SendToClient(unit:GetPlayerOwnerID(),"tzj_new_net_equip_hint",{itemName=item:GetAbilityName()})
	return true,tt
	
	
end

-- 掉落物品
-- @param unit handle 单位
-- @param item handle 物品
-- 
function Netbackpack:DropItem( unit, item )
	if type(item) ~= "table" then return nil end
	if item:IsNull() then return nil end

	local hasItem,packIndex = self:HasItem(unit,item:GetEntityIndex())

	if hasItem then
		local pos = unit:GetOrigin()


		local drop = CreateItemOnPositionSync( pos + RandomVector(RandomFloat(50, 150)) , item)
		if drop then
			drop:SetContainedItem( item )
		end

		self:RemoveItem( unit, packIndex )
	end
	
end

-- 掉落物品到其它单位
-- 
function Netbackpack:DropItemToOtherUnit( parent, unit, item )
	if type(item) ~= "table" then return nil end
	if item:IsNull() then return nil end

	local hasItem,packIndex = self:HasItem(parent,item:GetEntityIndex())

	if hasItem then
		
		local pos = unit:GetOrigin()
		local drop = CreateItemOnPositionSync( pos + RandomVector(RandomFloat(50, 150)) , item)
		if drop then
			drop:SetContainedItem( item )
		end
		self:RemoveItem( parent, packIndex )
	end
	
end

-- 掉落物品到某位置
-- @param unit handle 单位
-- @param item handle 物品
-- @param pos vector 位置
-- 
function Netbackpack:DropItemToPosition( unit, item, pos )
	if type(item) ~= "table" then return nil end
	if type(pos) ~= "userdata" then return nil end
	if item:IsNull() then return nil end

	local hasItem,packIndex = self:HasItem(unit,item:GetEntityIndex())

	if hasItem then

		ExecuteOrderFromTable
		{
			UnitIndex = unit:GetEntityIndex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = pos,
			Queue = 0
		}

		unit.m_Netbackpack_DropItemToPosition_OrderType = DOTA_UNIT_ORDER_DROP_ITEM

		unit:SetContextThink(DoUniqueString("DropItemToPosition"), function()

			if unit.m_Netbackpack_DropItemToPosition_OrderType ~= DOTA_UNIT_ORDER_DROP_ITEM then
				return nil
			end

			if (unit:GetOrigin() - pos):Length2D() <= 150 then
				-- unit:AddItem(item)
				-- unit:DropItemAtPositionImmediate(item,pos)

				local drop = CreateItemOnPositionSync( pos , item)
				if drop then
					drop:SetContainedItem( item )
					-- item:LaunchLoot( false, 100, 0.35, pos )
				end

				unit:Stop()

				self:RemoveItem( unit, packIndex )

				return nil
			end
			
			return 0.2
		end, 0)
			
	end
end

-- 掉落物品其它单位的某位置
-- 
function Netbackpack:DropItemToOtherUnitPosition( parent, unit, item, pos )
	if type(item) ~= "table" then return nil end
	if type(pos) ~= "userdata" then return nil end
	if item:IsNull() then return nil end

	local hasItem,packIndex = self:HasItem(parent,item:GetEntityIndex())

	if hasItem then

		ExecuteOrderFromTable
		{
			UnitIndex = unit:GetEntityIndex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = pos,
			Queue = 0
		}

		unit.m_Netbackpack_DropItemToPosition_OrderType = DOTA_UNIT_ORDER_DROP_ITEM

		local itemIndex = item:GetEntityIndex()
		local pack = self:GetNetbackpack(parent)

		unit:SetContextThink(DoUniqueString("DropItemToPosition"), function()

			if unit.m_Netbackpack_DropItemToPosition_OrderType ~= DOTA_UNIT_ORDER_DROP_ITEM then
				return nil
			end

			if (unit:GetOrigin() - pos):Length2D() <= 150 then
				

				if pack[packIndex] ~= itemIndex then
					return nil
				end

				local drop = CreateItemOnPositionSync( pos , item)
				if drop then
					drop:SetContainedItem( item )
					-- item:LaunchLoot( false, 100, 0.35, pos )
				end

				unit:Stop()

				self:RemoveItem( parent, packIndex )

				return nil
			end
			
			return 0.2
		end, 0)
			
	end
end

--更新背包信息
function Netbackpack:NetbackpackUpdateNetbackpack( hero )
	
	for i=1,NetbackpackConfig.MaxItem do
		self:UpdateItem( hero, i )
	end
end
--检测物品是不是在固定的位置
function Netbackpack:rightpositionItem( item, packIndex )
	local nameArray = string.split(item:GetAbilityName(), "_");
	return nameArray[3]==NetbackpackConfig.rightposition[packIndex]
end

function Netbackpack:equipItem( unit, packIndex )
	if packIndex > NetbackpackConfig.MaxItem or packIndex < 7 then return false end
	local pack = self:GetNetbackpack(unit)
	local temp1 = pack[packIndex]
	local item1=EntIndexToHScript(temp1)
	local nameArray = string.split(item1:GetAbilityName(), "_");
	local swapindex=-1 
	local temp=false
	local setnum=0
	for kk,vv in pairs(NetbackpackConfig.rightposition) do
		if nameArray[3]==vv and temp==false then
			if vv=='ts' or vv=='ss' then  --如果有2个一样的就判断2个位置有没有东西，1个的就不判断直接替换
				setnum=setnum+1
				if pack[kk]==-1 then
					swapindex=kk
				else
					if setnum==2 and swapindex==-1  then
						swapindex=kk
					end
				end
			else
				swapindex=kk
			end
			--swapindex=kk
			--if Netbackpack.m_Unitposition[unit:GetEntityIndex()] == 1 then
				--temp=true
			--end
		end
	end
	
	self:SwapItem( unit, packIndex, swapindex )
	--if temp then
	--	Netbackpack.m_Unitposition[unit:GetEntityIndex()] = 2
	--else
	--	Netbackpack.m_Unitposition[unit:GetEntityIndex()] = 1
	--end
end
function Netbackpack:unequipItem( unit, packIndex)
	if packIndex > 6 and packIndex < 0 then return false end
	local swapindex=self:GetNotUseIndex(unit)
	if swapindex ==-1 then  --包包满了
		local pack = self:GetNetbackpack(unit)
		local temp1 = pack[packIndex]
		local item1=EntIndexToHScript(temp1)
		CreateItemOnGround(item1,nil,unit:GetAbsOrigin(),100)
		pack[packIndex]=-1
		self:UpdateItem( unit, packIndex )
	else
		self:SwapItem( unit, packIndex, swapindex )
	end
end
-- 对换位置
-- @param unit handle 单位
-- @param packIndex1 int 背包中的位置
-- @param packIndex2 int 背包中的位置
-- 
function Netbackpack:SwapItem( unit, packIndex1, packIndex2 )
	if packIndex1 > NetbackpackConfig.MaxItem or packIndex1 < 0 then return false end
	if packIndex2 > NetbackpackConfig.MaxItem or packIndex2 < 0 then return false end
	
	local pack = self:GetNetbackpack(unit)
	--1-6就是装备栏（1=武器，2=护甲，3=饰品1,4=饰品2,5=特殊1,6=特殊2）
	local temp1 = pack[packIndex1]
	local item1=EntIndexToHScript(temp1)
	local temp2 = pack[packIndex2]
	local item2=EntIndexToHScript(temp2)
	if temp2~=-1 then  --(1,1)
		if packIndex1>0 and packIndex1<7 then --(换上装备)
			
			if self:rightpositionItem(item2,packIndex1)==false then
				NotifyUtil.ShowError(unit:GetPlayerOwnerID(),"#error_netequip_swapposition")
				return
			end
		else --(取下装备)
			if packIndex2>0 and packIndex2<7 then
				if self:rightpositionItem(item1,packIndex2)==false then
					NotifyUtil.ShowError(unit:GetPlayerOwnerID(),"#error_netequip_swapposition")
					return
				end
			end
		end
	else--(1,-1)  --(穿上装备)
		if packIndex2>0 and packIndex2<7 then  --只检测packindex1的物品，因为目标位置没有物品
			if self:rightpositionItem(item1,packIndex2)==false then
				NotifyUtil.ShowError(unit:GetPlayerOwnerID(),"#error_netequip_position")
				return
			end
		end
	end
	
	if pack then
		local temp = pack[packIndex1]
	 	pack[packIndex1] = pack[packIndex2]
	 	pack[packIndex2] = temp
		local tempitem1=pack[packIndex1]
		local tempitem2=pack[packIndex2]
		local item1=EntIndexToHScript(tempitem1)
		if item1 then
			SrvNetEquip.UpdateEquipPosition(unit:GetPlayerOwnerID(),item1.serverID,packIndex1)
		end
		local item2=EntIndexToHScript(tempitem2)
		if item2 then
			SrvNetEquip.UpdateEquipPosition(unit:GetPlayerOwnerID(),item2.serverID,packIndex2)
		end
	 	self:UpdateItem( unit, packIndex1 )
	 	self:UpdateItem( unit, packIndex2 )
	 	
	end
end
-- 遍历
-- @param unit handle 单位
-- @param func function 函数，每遍历一个物品调用一次，空的格子不遍历，返回true终止遍历，固有参数(pack,packIndex,itemIndex)
-- 
function Netbackpack:Traverse( unit, func )
	if self:HasNetbackpack(unit) then
		local pack = self:GetNetbackpack(unit)

		for packIndex,itemIndex in pairs(pack) do
			if itemIndex ~= -1 then
				if func(pack,packIndex,itemIndex) then return end
			end
		end
	end
end

-- 创建物品
-- 
function Netbackpack:CreateItem( unit, itemName )
	
	if self:HasNetbackpack(unit) then
		if self:IsFull(unit) then
			local pos = unit:GetOrigin()
			local addItem = CreateItem(itemName, nil, nil)
			local drop = CreateItemOnPositionSync( pos + RandomVector(RandomFloat(50, 150)) , addItem)
			if drop then
				drop:SetContainedItem( addItem )
				-- addItem:LaunchLoot( false, 100, 0.35, pos + RandomVector( RandomFloat( 50, 150 ) ) )
			end
			return addItem
		else
			local addItem = CreateItem(itemName, nil, nil)
			unit:AddItem(addItem)
			return addItem
		end
	end
end


-- 出售物品
-- 
function Netbackpack:SellItem( unit, item )
	if type(item) ~= "table" then return nil end
	if item:IsNull() then return nil end
	
	if GameRules.m_ItemData_Items[item:GetAbilityName()].ItemSellable and GameRules.m_ItemData_Items[item:GetAbilityName()].ItemSellable==0 then
		senderrormessage(unit,"#cantsell")
		return
	end
	local cost = item:GetCost(); 
	if item:IsStackable() then
		cost=(cost/item:GetInitialCharges()*item:GetCurrentCharges())/2

	else 
		cost=cost/2
	end
	
	if cost == 0 then return end

	if Netbackpack:ConsumeItem( unit, item ) then
		PlayerResource:ModifyGold(unit:GetPlayerOwnerID(),cost,false,DOTA_ModifyGold_SellItem)
		EmitSoundOnClient("General.Coins",unit:GetPlayerOwner())

		local p = ParticleManager:CreateParticle("particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf",PATTACH_CUSTOMORIGIN,unit)
		ParticleManager:SetParticleControl(p,1,unit:GetOrigin())
		ParticleManager:ReleaseParticleIndex(p)
	end
end

function Netbackpack:GetNetDataToCreateItem(unit)
	if not SrvNetEquip.PlayerDataInited then
		TimerUtil.CreateTimerWithEntity(unit,function()
			Netbackpack:GetNetDataToCreateItem(unit)
		end,3)
		return;
	end

	local PlayerID = unit:GetPlayerOwnerID()
	local data=SrvNetEquip.GetPlayerData(PlayerID)
	local pack = self:GetNetbackpack(unit)
	local scoretable={}
	if data then
		local noSlotItems = nil
		for id, item in pairs(data) do
			local addItem = CreateItem(item.name, unit, unit)
			
			--记录一下服务器id，其他操作要使用
			addItem.serverID = id
			
			addItem.tempdata= item.attr
			addItem.pz = item.quality
			addItem.lv = item.grade
			addItem:ReFreshData()
			if math.ceil(addItem.zdl)~= item.score then  --重新计算后的战斗值比较，不一样就更新
				scoretable[id]=math.ceil(addItem.zdl)
			end
			if pack then
				if item.slot then
					pack[item.slot] = addItem:GetEntityIndex()
				else
					if not noSlotItems then
						noSlotItems = {}
					end
					noSlotItems[id] = addItem
				end
			end
		end
		
		if noSlotItems then
			for serverID, item in pairs(noSlotItems) do
				--要重新选位置添加一下，但是不用调用保存到服务器的逻辑，只需要下面的缓存更新一下就行了，在游戏结束的时候再推送数据
				local slot = Netbackpack:UpAddSpecilItem(unit,item)--不知道用哪个方法，你处理一下
				--添加完以后，更新缓存：下面的slot要换成最新的位置
				SrvNetEquip.UpdateEmptySlot(PlayerID,serverID,slot)
			end
		end
		
	end
	self:refreshmodifier(unit)--刷新BUFF
	CustomNetTables:SetTableValue("tzj_storage", "net_equip_"..unit:GetPlayerOwnerID(),pack)
	self:refreshscore(unit:GetPlayerOwnerID(),scoretable)
end
--单独添加部分存档装备到背包
function Netbackpack:UpAddSpecilItem(unit,item)
	local pack = self:GetNetbackpack(unit)
	if pack then
		local packIndex=self:GetNotUseIndex(unit)
		if packIndex ~= -1 then
			pack[packIndex] = item:GetEntityIndex()
			return packIndex
		end
	end
	return -1
end
function Netbackpack:refreshscore(playerid,scoredata)
	--PrintTable(scoredata)
	if TableLen(scoredata) == 0 then
		return;
	end
	
	SrvNetEquip.UpdateItemScore(playerid,scoredata,function(success,arg2)
		if success then
			--print("refreshscore_succ",success)
			--PrintTable(arg2)
		else
			print("refreshscore_fail",success,arg2)
		end
	end)
	
end
function Netbackpack:OpenNetbox(playerID,level,rare,type)
	local itemlevel = tonumber(level) or 1
	local itemrare =  tonumber(rare) or 5
	local itemtype =  tonumber(type) or 1
	if not playerID then
		return nil 
	end 
	local hero = PlayerUtil.GetHero(playerID)
	local rare = {}

	for i=itemrare ,7 do
		rare[i] = ba["netboxbl"..itemlevel][i] --需要注意
	end
	local itemrare = Weightsgetvalue_one(rare)  --随机装备品质，普通（白色1）优良（绿色2）稀有（蓝色3）极品（紫色4）史诗（橙色5）传奇（金色6）神话（红色7）
    --如果要加宝箱开启保底的话，比如说， 开十次紫色宝箱必出一个橙色装备，那么这里可能要往服务器上获取存取 当前开启宝箱的次数

 	if itemtype == 5 then
 		itemtype=Weightsgetvalue_one(NetItem_Type) --衣服武器首饰等物品类型 
 	end
 	
 	local itemName = nil
 	
	if itemtype==1 then
		local sx = NetItem_Type_All[RandomInt(1,4)]
		local idx = RandomInt(1,3)
		if sx == "zl" or sx == "ty" then
			idx = RandomInt(1,2)
		end
		
		itemName= "item_net_wq_"..sx.."_"..itemlevel.."_"..idx
	elseif itemtype==2 then
		itemName= "item_net_fj_ty_"..itemlevel.."_"..RandomInt(1,6)
	elseif itemtype==3 then
		local sx = NetItem_Type_All[RandomInt(1,4)]
		if sx == "ty" then
			itemName= "item_net_ss_"..sx.."_"..itemlevel.."_1"
		else
			itemName= "item_net_ss_"..sx.."_"..itemlevel.."_"..RandomInt(1,2)
		end
	elseif itemtype==4 then
		itemName= "item_net_ts_ty_"..itemlevel.."_"..RandomInt(1,3)
	end
	
	if itemName then
		NetTime = NetTime +1
		NetLevel[NetTime] = itemlevel
		NetPz[NetTime] = itemrare
		local newItem = CreateItem(itemName, hero, hero )
		Netbackpack:AddItemImmediate( hero, newItem,-1,SrvNetEquip.source_box)
	end
	
end

-- 初始化
function Netbackpack:__call( unit )
	if type(unit) ~= "table" then return end
	if unit:IsNull() then return end
	if not unit:HasInventory() then return end

	local unitIndex = unit:GetEntityIndex()

	local data = {}

	for i=1,NetbackpackConfig.MaxItem do
		data[i] = -1
	end
	Netbackpack.m_UnitItems[unitIndex] = data
	Netbackpack.m_Unitposition[unitIndex] = 1
	
	unit:SetContextThink(DoUniqueString("Netbackpack"), function( )--包裹列表
		
		local pack = self:GetNetbackpack(unit)

		for packIndex,itemIndex in pairs(pack) do
			if itemIndex ~= -1 then
				local item = EntIndexToHScript(itemIndex)
				if item == nil then
					pack = -1
				end
			end
		end

		return 3
	end, 3)
	self:GetNetDataToCreateItem( unit)

end
-- 存储背包物品对换位置
function UI_NetbackpackSwapPosition( event,data )
	if Stage.gameFinished then
		--游戏结束后就不会再同步位置了，所以就不让移动了
		NotifyUtil.ShowError(data.PlayerID,"#info_game_finished_tip_net_equip")
		return
	end
	--if GameRules:IsGamePaused() then return end
	if type(data.packIndex1) == "number" and type(data.packIndex2) == "number" then
		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end

		local hero = player:GetAssignedHero()
		if hero == nil then return end
		if hero:IsNull() and not hero:IsAlive() then return end
		
		Netbackpack:SwapItem( hero, data.packIndex1, data.packIndex2 )
	end
end
-- 销毁装备
function UI_NetbackpackDelItem( event,data )
	--if GameRules:IsGamePaused() then return end
	if type(data.packIndex) == "number" then
		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end

		local hero = player:GetAssignedHero()
		if hero == nil then return end
		if hero:IsNull() and not hero:IsAlive() then return end
		Netbackpack:RemoveItem( hero,data.packIndex )
	end
end
-- 销毁装备
function ui_event_netbackpack_del_item_batch( event,data )
	--if GameRules:IsGamePaused() then return end
	
		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end

		local hero = player:GetAssignedHero()
		if hero == nil then return end
		if hero:IsNull() and not hero:IsAlive() then return end
		Netbackpack:RemoveItemBatch( hero,data.slots )
	
end

-- 双击装备物品
function UI_Netbackpack_double_equip( event,data )
	if Stage.gameFinished then
		--游戏结束后就不会再同步位置了，所以就不让移动了
		NotifyUtil.ShowError(data.PlayerID,"#info_game_finished_tip_net_equip")
		return
	end
	--if GameRules:IsGamePaused() then return end
	if type(data.packIndex) == "number" then
		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end

		local hero = player:GetAssignedHero()
		if hero == nil then return end
		if hero:IsNull() and not hero:IsAlive() then return end
		
		Netbackpack:equipItem( hero, data.packIndex)
	end
end
-- 双击取下物品
function UI_Netbackpack_double_unequip( event,data )
	if Stage.gameFinished then
		--游戏结束后就不会再同步位置了，所以就不让移动了
		NotifyUtil.ShowError(data.PlayerID,"#info_game_finished_tip_net_equip")
		return
	end
	--if GameRules:IsGamePaused() then return end
	if type(data.packIndex) == "number" then
		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end

		local hero = player:GetAssignedHero()
		if hero == nil then return end
		if hero:IsNull() and not hero:IsAlive() then return end
		
		Netbackpack:unequipItem( hero, data.packIndex )
	end
end

function tzj_net_equip_enhance( event,data )
	
	if GameRules:GetGameModeEntity().enhancetime==nil  then
		GameRules:GetGameModeEntity().enhancetime={}
	end
	if GameRules:GetGameModeEntity().enhancetime[data.PlayerID]==nil  then
		GameRules:GetGameModeEntity().enhancetime[data.PlayerID]=0
	end
	
	if GameRules:GetGameModeEntity().enhancetime[data.PlayerID]>Time() then
		SendToClient(data.PlayerID,"tzj_net_equip_enhance_return",{success=false,error=5})
		return 
	end
	GameRules:GetGameModeEntity().enhancetime[data.PlayerID]=Time()+1
	if type(data.item) == "number" then
		local item=EntIndexToHScript(data.item)
		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then 
			SendToClient(data.PlayerID,"tzj_net_equip_enhance_return",{success=false,error=0,item=item:GetEntityIndex()})
			return 
		end
		local hero = player:GetAssignedHero()
		if hero == nil then
			SendToClient(data.PlayerID,"tzj_net_equip_enhance_return",{success=false,error=0,item=item:GetEntityIndex()})
		 	return 
		end
		
		if data.force then
			item:EnhanceData(true)
		else
			item:EnhanceData(false)
		end
	else
		SendToClient(data.PlayerID,"tzj_net_equip_enhance_return",{success=false,error=0})
		return 
	end
end
-- 背包物品对换位置
CustomGameEventManager:RegisterListener("ui_event_netbackpack_swap_pos",UI_NetbackpackSwapPosition)
--销毁装备
CustomGameEventManager:RegisterListener("ui_event_netbackpack_del_item",UI_NetbackpackDelItem)
--批量销毁装备
CustomGameEventManager:RegisterListener("ui_event_netbackpack_del_item_batch",ui_event_netbackpack_del_item_batch)

-- 双击装备物品
CustomGameEventManager:RegisterListener("ui_event_netbackpack_double_equip",UI_Netbackpack_double_equip)
-- 双击取下物品
CustomGameEventManager:RegisterListener("ui_event_netbackpack_double_unequip",UI_Netbackpack_double_unequip)
CustomGameEventManager:RegisterListener("tzj_net_equip_enhance",tzj_net_equip_enhance)
