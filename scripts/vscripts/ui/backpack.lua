if Backpack == nil then
	Backpack = {}
	BackpackConfig = {}

	-- 存储单位的物品数据
	Backpack.m_UnitItems = {}
	Backpack.publicitem = {}
	setmetatable(Backpack,Backpack)
end

-- 背包格数（从1开始）
BackpackConfig.MaxItem = 24
BackpackConfig.MaxPersonalItem = 24

-- 公共背包格数（从1开始）
BackpackConfig.MaxPublicItem = 24
--身上物品的最大索引（从0开始）
BackpackConfig.MaxBodyIndex = 8


--更新背包信息
function Backpack:BackpackUpdateBackpack( hero )
	for i=1,BackpackConfig.MaxItem do
		self:UpdateItem( hero, i )
	end
end
function Backpack:UpdateItem( unit, packIndex )
	if EntityNotNull(unit) then
		CustomNetTables:SetTableValue("tzj_storage", "backpack_data_"..unit:GetPlayerOwnerID(),self:GetBackpack(unit))
	end
end

--更新公共仓库
function Backpack:publicUpdateItem( packIndex )
	CustomNetTables:SetTableValue("tzj_storage","public",self:GetPublicBackpack())
end
--物品从公共仓库移出到直接装备
function Backpack:publicoutputinventory(hero, publicpackIndex,slot)
	local publicpack = self:GetPublicBackpack()
	if publicpack[publicpackIndex]~=-1 then
		local itemindex=publicpack[publicpackIndex]
		local item = hero:GetItemInSlot(slot)
		if item ~= nil  then
			hero:TakeItem(item)
			publicpack[publicpackIndex]=item:GetEntityIndex()
		else
			publicpack[publicpackIndex]=-1
		end
		self:publicUpdateItem( publicpackIndex )
		
		hero:AddItem(EntIndexToHScript(itemindex))

		local s = 0
		for i=0,BackpackConfig.MaxBodyIndex do
			local item = hero:GetItemInSlot(i)
			if item == EntIndexToHScript(itemindex) then
				s = i
			end
		end
		hero:SwapItems(s,9)
		hero:SwapItems(9,slot)
		
		
	end
end
--物品从公共仓库移出到个人仓库
function Backpack:publicoutput(hero, publicpackIndex,backpackslot)
	local publicpack = self:GetPublicBackpack()
	if publicpack[publicpackIndex]~=-1 then
		local pack = self:GetBackpack(hero) or {}
		if pack[backpackslot]==-1 then
			pack[backpackslot]=publicpack[publicpackIndex]
			publicpack[publicpackIndex]=-1
		else
			local pitem=pack[backpackslot]
			pack[backpackslot]=publicpack[publicpackIndex]
			publicpack[publicpackIndex]=pitem
		end
		self:UpdateItem( hero, backpackslot )
		self:publicUpdateItem( publicpackIndex )
		
		
	end
end
--物品移动到公共仓库
function Backpack:pulickpack_input( hero, hitem,slot)
	local tt=true
	for item_slot = 0,BackpackConfig.MaxBodyIndex do
		local item = hero:GetItemInSlot(item_slot)
		if item ~= nil and item:GetEntityIndex()==hitem then
			tt=false
			local pack = self:GetPublicBackpack()
			if pack[slot]==-1 then
				hero:TakeItem(item)
				pack[slot] = hitem
				self:publicUpdateItem( slot )
				return
			else
				hero:TakeItem(item)
				local packItem = EntIndexToHScript(pack[slot])
				hero:AddItem(packItem)
				local s = 0
				for i=0,BackpackConfig.MaxBodyIndex do
					local item = hero:GetItemInSlot(i)
					if item == packItem then
						s = i
					end
				end
				hero:SwapItems(s,9)
				hero:SwapItems(9,item_slot)

				pack[slot] = item:GetEntityIndex()
				self:publicUpdateItem( slot )
				return
			end
			--[[for packIndex,itemIndex in pairs(pack) do
				if itemIndex == -1 then
					hero:TakeItem(item)
					pack[packIndex] = hitem
					self:publicUpdateItem( packIndex )
					return
				else

				end
			end]]
		end
	end
	if tt and self:HasBackpack(hero) then
		local pack = self:GetBackpack(hero) or {}
		for packIndex,itemIndex in pairs(pack) do
			if itemIndex == hitem then
				local pack2 = self:GetPublicBackpack()
				if pack2[slot]==-1 then
					pack[packIndex]=-1
					pack2[slot] = hitem
					self:UpdateItem( hero, packIndex )
					self:publicUpdateItem( slot )
					return
				else
					local pitem=pack2[slot]
					pack2[slot] = pack[packIndex]
					pack[packIndex]=pitem
					self:UpdateItem( hero, packIndex )
					self:publicUpdateItem( slot )
					return
				end
				--[[for packIndex2,itemIndex2 in pairs(pack2) do
					if itemIndex2 == -1 then
						pack[packIndex]=-1
						self:UpdateItem( hero, packIndex )
						pack2[packIndex2] = hitem
						self:publicUpdateItem( packIndex2 )
						return
					end
				end]]
			end
		end
	end
end
-- 获取背包
-- @param unit handle 单位
-- 
function Backpack:GetBackpack( unit )
	if type(unit) ~= "table" then return nil end
	if unit:IsNull() then return nil end

	return Backpack.m_UnitItems[unit:GetEntityIndex()]
end
--获取公共背包
function Backpack:GetPublicBackpack()
	return Backpack.publicitem
end

-- 获取背包物品数量
-- @param unit handle 单位
-- 
function Backpack:GetItemsNum( unit )
	if type(unit) ~= "table" then return BackpackConfig.MaxItem end
	if unit:IsNull() then return BackpackConfig.MaxItem end

	if self:HasBackpack(unit) then
		local pack = self:GetBackpack(unit) or {}
		local num = 0

		for _,itemIndex in pairs(pack) do
			if itemIndex ~= -1 then
				num = num + 1
			end
		end
		return num
	end

	return BackpackConfig.MaxItem
end

-- 获取背包某物品数量
-- @param unit handle 单位
-- 
function Backpack:GetItemsNumByItemName( unit,itemName )
	if type(unit) ~= "table" then return 0 end
	if unit:IsNull() then return 0 end

	if self:HasBackpack(unit) then
		local pack = self:GetBackpack(unit) or {}
		local num = 0

		for _,itemIndex in pairs(pack) do
			if itemIndex ~= -1 then
				local item = EntIndexToHScript(itemIndex)
				if item:GetAbilityName() == itemName then
					num = num + 1
				end
			end
		end

		return num
	end

	return 0
end

-- 判断单位是否有背包
-- @param unit handle 单位
-- 
function Backpack:HasBackpack( unit )
	return self:GetBackpack(unit) ~= nil
end

-- 判断背包是否填满
-- @param unit handle 单位
-- 
function Backpack:IsFull( unit )
	return self:GetItemsNum(unit) == BackpackConfig.MaxItem
end

-- 判断背包中是否有物品
-- @param unit handle 单位
-- @param itemIndex int 物品EntityIndex
-- 
function Backpack:HasItem( unit, itemIndex )
	if self:HasBackpack(unit) then

		local pack = self:GetBackpack(unit)

		for packIndex,index in pairs(pack) do
			
			if index == itemIndex then
				return true,packIndex
			end
		end
	end

	return false
end
-- 判断背包中是否有物品
-- @param unit handle 单位
-- @param itemIndex int 物品EntityIndex
-- 
function Backpack:HasPublicItem( itemIndex )
	

	local pack = self:GetPublicBackpack()

	for packIndex,index in pairs(pack) do
		
		if index == itemIndex then
			return true,packIndex
		end
	end
	

	return false
end


-- 移除公共物品
-- @param unit handle 单位
-- @param packIndex int 背包中的位置
-- 
function Backpack:PublicRemoveItem( packIndex )

	
	if packIndex > BackpackConfig.MaxPublicItem or packIndex < 0 then return false end

	local pack = self:GetPublicBackpack()

	if pack then
	 	pack[packIndex] = -1
	 	self:publicUpdateItem( packIndex )
	end
end

-- 移除物品
-- @param unit handle 单位
-- @param packIndex int 背包中的位置
-- 
function Backpack:RemoveItem( unit, packIndex )

	
	if packIndex > BackpackConfig.MaxItem or packIndex < 0 then return false end

	local pack = self:GetBackpack(unit)

	if pack then
	 	pack[packIndex] = -1
	 	self:UpdateItem( unit, packIndex )
	 	
	end
end

-- 消耗物品
-- @param unit handle 单位
-- @param item handle 物品
-- 
function Backpack:ConsumeItem( unit, item )

	local hasItem,packIndex = self:HasItem( unit, item:GetEntityIndex() )
	
	if hasItem then
		local box = item:GetContainer()
		item:RemoveSelf()

		if box and not box:IsNull() then 
			box:RemoveSelf() 

			local pack = self:GetBackpack(unit)
			pack[packIndex] = -1;
		end

		self:RemoveItem( unit, packIndex )

		return true
	end

	return false
end

-- 查找物品
-- @param unit handle 单位
-- @param itemName string 物品名称
-- 
function Backpack:FindItemByName( unit, itemName )
	local pack = self:GetBackpack(unit)

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
function Backpack:HasItemInBackpack( unit, item )
	if type(item) ~= "table" then return false end
	if item:IsNull() then return false end

	return self:HasItem( unit, item:GetEntityIndex() )
end

-- 获取一个空的物品格
-- @param unit handle 单位
-- 
function Backpack:GetNotUseIndex( unit )
	if not self:IsFull(unit) then
		local pack = self:GetBackpack(unit) or {}

		for packIndex,itemIndex in pairs(pack) do
			if itemIndex == -1 then
				return packIndex
			end
		end
	end

	return -1
end

-- 获取物品
-- @param unit handle 单位
-- @param packIndex int 背包中的位置
-- 
function Backpack:GetItemIndex( unit, packIndex )
	local pack = self:GetBackpack(unit)

	if pack then
	 	local itemIndex = pack[packIndex]

	 	if itemIndex then
	 		return itemIndex
	 	end
	end

	return -1
end

-- 添加物品到背包
-- @param unit handle 单位
-- @param item handle 物品
-- 
function Backpack:AddItem( unit, item )
	
	if type(item) ~= "table" then return false end
	if item:IsNull() then return false end

	if self:IsFull(unit) then return false end
	
	if self:HasItemInBackpack( unit, item ) then return false end

	local box = item:GetContainer()
	if box then box:RemoveSelf() end

	if unit:GetNumItemsInInventory() >= 6 then
		if not item:IsStackable() then 
			unit:AddItem(item)
		end
	end
	local tt=item
	if item:IsStackable() then --是不是消耗品
		local bpitem,ddpackIndex=self:FindItemByName(unit,item:GetAbilityName())
		if bpitem~=nil then
			tt=bpitem
			bpitem:SetCurrentCharges(bpitem:GetCurrentCharges()+item:GetCurrentCharges())
			item:RemoveSelf()
			self:UpdateItem(unit, ddpackIndex )
		else
			local packIndex = self:GetNotUseIndex(unit)
			if packIndex ~= - 1 then
				local pack = self:GetBackpack(unit)

				if pack then
					if item:IsNull() then return false end
					pack[packIndex] = item:GetEntityIndex()
					unit:TakeItem(item)
					self:UpdateItem( unit, packIndex )
					
				end
			end
		end
	else
		local packIndex = self:GetNotUseIndex(unit)

		if packIndex ~= -1 then
			local pack = self:GetBackpack(unit)

			if pack then
				pack[packIndex] = item:GetEntityIndex()
				unit:TakeItem(item)
				self:UpdateItem( unit, packIndex )
			end
		end
	end
	
	return true,tt
end

-- 立即添加物品到背包

function Backpack:AddItemImmediate( unit, item,slot )

	if type(item) ~= "table" then return false end
	if item:IsNull() then return false end
	if item:IsStackable() then
		if Backpack:GetItemsNumByItemName(unit,item:GetAbilityName()) == 0 then---如果背包里没有这个同名消耗物品，那就检测背包是不是满了
			if self:IsFull(unit) then return false end
		end
	else
		if self:IsFull(unit) then return false end
	end
	if self:HasItemInBackpack( unit, item ) then return false end

	local tt=item
	if item:IsStackable() then --是不是消耗品
		local bpitem,ddpackIndex=self:FindItemByName(unit,item:GetAbilityName())
		if bpitem~=nil then
			
			tt=bpitem
			bpitem:SetCurrentCharges(bpitem:GetCurrentCharges()+item:GetCurrentCharges())
			item:RemoveSelf()
			self:UpdateItem(unit, ddpackIndex )
		else
			if slot==-1 then  --判断有没有传背包格子参数  -1 任意格子
				local packIndex = self:GetNotUseIndex(unit)
				if packIndex ~= - 1 then
					local pack = self:GetBackpack(unit)

					if pack then
						if item:IsNull() then return false end
						pack[packIndex] = item:GetEntityIndex()
						unit:TakeItem(item)
						self:UpdateItem( unit, packIndex )
					end
				end
			else
				local pack = self:GetBackpack(unit)
				if pack[slot]==-1 then --指定格子有没有物品
					if item:IsNull() then return false end
					pack[slot] = item:GetEntityIndex()
					unit:TakeItem(item)
					self:UpdateItem( unit, slot )
				else
					if item:IsNull() then return false end
					local pitem=pack[slot]
					pack[slot] = item:GetEntityIndex()
					local item_slot=0
					for i=0,BackpackConfig.MaxBodyIndex do
						local sitem = unit:GetItemInSlot(i)
						if sitem == item then
							item_slot = i
						end
					end
					unit:TakeItem(item)
					local packItem = EntIndexToHScript(pitem)
					unit:AddItem(packItem)
					local s = 0
					for i=0,BackpackConfig.MaxBodyIndex do
						local sitem = unit:GetItemInSlot(i)
						if sitem == packItem then
							s = i
						end
					end
					unit:SwapItems(s,9)
					unit:SwapItems(9,item_slot)
					self:UpdateItem( unit, slot )
				end
			end
		end
	else
		if slot==-1 then  --判断有没有传背包格子参数  -1 任意格子
			local packIndex = self:GetNotUseIndex(unit)
			if packIndex ~= -1 then
				local pack = self:GetBackpack(unit)

				if pack then
					pack[packIndex] = item:GetEntityIndex()
					unit:TakeItem(item)
					self:UpdateItem( unit, packIndex )
					if item:IsStackable() then 
						unit:SetContextThink(DoUniqueString("AddItem"), function()
							if item:IsNull() then
								pack[packIndex] = -1
								self:UpdateItem( unit, packIndex )
							return nil 
							end
						end, 0.1)

					end
					
				end
			end
		else
			if slot==-1 then  --判断有没有传背包格子参数  -1 任意格子
				local packIndex = self:GetNotUseIndex(unit)
				if packIndex ~= - 1 then
					local pack = self:GetBackpack(unit)

					if pack then
						if item:IsNull() then return false end
						pack[packIndex] = item:GetEntityIndex()
						unit:TakeItem(item)
						self:UpdateItem( unit, packIndex )
					end
				end
			else
				local pack = self:GetBackpack(unit)
				if pack[slot]==-1 then --指定格子有没有物品
					if item:IsNull() then return false end
					pack[slot] = item:GetEntityIndex()
					unit:TakeItem(item)
					self:UpdateItem( unit, slot )
				else
					if item:IsNull() then return false end
					local pitem=pack[slot]
					pack[slot] = item:GetEntityIndex()
					local item_slot=0
					for i=0,BackpackConfig.MaxBodyIndex do
						local sitem = unit:GetItemInSlot(i)
						if sitem == item then
							item_slot = i
						end
					end
					unit:TakeItem(item)
					local packItem = EntIndexToHScript(pitem)
					unit:AddItem(packItem)
					local s = 0
					for i=0,BackpackConfig.MaxBodyIndex do
						local sitem = unit:GetItemInSlot(i)
						if sitem == packItem then
							s = i
						end
					end
					unit:SwapItems(s,9)
					unit:SwapItems(9,item_slot)
					self:UpdateItem( unit, slot )
				end
			end
		end
	end
	
	return true,tt
	
	
end

-- 掉落物品
-- @param unit handle 单位
-- @param item handle 物品
-- 
function Backpack:DropItem( unit, item )
	if type(item) ~= "table" then return nil end
	if item:IsNull() then return nil end

	local hasItem,packIndex = self:HasItem(unit,item:GetEntityIndex())

	if hasItem then
		self:RemoveItem( unit, packIndex )
		DropItemEx(item,unit:GetAbsOrigin())
	end
	
end

-- 掉落物品到其它单位
-- 
function Backpack:DropItemToOtherUnit( parent, unit, item )
	if type(item) ~= "table" then return nil end
	if item:IsNull() then return nil end

	local hasItem,packIndex = self:HasItem(parent,item:GetEntityIndex())

	if hasItem then
		self:RemoveItem( parent, packIndex )
		DropItemEx(item,unit:GetAbsOrigin())
	end
	
end

-- 掉落物品到某位置
-- @param unit handle 单位
-- @param item handle 物品
-- @param pos vector 位置
-- 
function Backpack:DropItemToPosition( unit, item, pos )
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

		unit.m_Backpack_DropItemToPosition_OrderType = DOTA_UNIT_ORDER_DROP_ITEM

		unit:SetContextThink(DoUniqueString("DropItemToPosition"), function()

			if unit.m_Backpack_DropItemToPosition_OrderType ~= DOTA_UNIT_ORDER_DROP_ITEM then
				return nil
			end

			if (unit:GetOrigin() - pos):Length2D() <= 150 then
				-- unit:AddItem(item)
				-- unit:DropItemAtPositionImmediate(item,pos)

				DropItemEx(item,pos)
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
function Backpack:DropItemToOtherUnitPosition( parent, unit, item, pos )
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

		unit.m_Backpack_DropItemToPosition_OrderType = DOTA_UNIT_ORDER_DROP_ITEM

		local itemIndex = item:GetEntityIndex()
		local pack = self:GetBackpack(parent)

		unit:SetContextThink(DoUniqueString("DropItemToPosition"), function()

			if unit.m_Backpack_DropItemToPosition_OrderType ~= DOTA_UNIT_ORDER_DROP_ITEM then
				return nil
			end

			if (unit:GetOrigin() - pos):Length2D() <= 150 then
				

				if pack[packIndex] ~= itemIndex then
					return nil
				end
				
				DropItemEx(item,pos)

				unit:Stop()

				self:RemoveItem( parent, packIndex )

				return nil
			end
			
			return 0.2
		end, 0)
			
	end
end

-- 掉落物品其它单位的某位置
-- 
function Backpack:PublicDropItemToOtherUnitPosition( parent, unit, item, pos )
	if type(item) ~= "table" then return nil end
	if type(pos) ~= "userdata" then return nil end
	if item:IsNull() then return nil end
	local hasItem,packIndex = self:HasPublicItem(item:GetEntityIndex())

	if hasItem then
	

		ExecuteOrderFromTable
		{
			UnitIndex = unit:GetEntityIndex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = pos,
			Queue = 0
		}

		unit.m_Backpack_DropItemToPosition_OrderType = DOTA_UNIT_ORDER_DROP_ITEM

		local itemIndex = item:GetEntityIndex()
		local pack = self:GetPublicBackpack()

		unit:SetContextThink(DoUniqueString("DropItemToPosition"), function()

			if unit.m_Backpack_DropItemToPosition_OrderType ~= DOTA_UNIT_ORDER_DROP_ITEM then
				return nil
			end

			if (unit:GetOrigin() - pos):Length2D() <= 150 then
				
				if pack[packIndex] ~= itemIndex then
					return nil
				end
				
				DropItemEx(item,pos)

				unit:Stop()

				self:PublicRemoveItem( packIndex )

				return nil
			end
			
			return 0.2
		end, 0)
	end
end

-- 对换位置
-- @param unit handle 单位
-- @param packIndex1 int 背包中的位置
-- @param packIndex2 int 背包中的位置
-- 
function Backpack:SwapItem( unit, packIndex1, packIndex2 )
	
	if packIndex1 > BackpackConfig.MaxItem or packIndex1 < 0 then return false end
	if packIndex2 > BackpackConfig.MaxItem or packIndex2 < 0 then return false end

	local pack = self:GetBackpack(unit)

	if pack then
	 	local temp = pack[packIndex1]
	 	pack[packIndex1] = pack[packIndex2]
	 	pack[packIndex2] = temp

	 	self:UpdateItem( unit, packIndex1 )
	 	self:UpdateItem( unit, packIndex2 )
	 	
	end
end
-- 公共背包对换位置
-- @param unit handle 单位
-- @param packIndex1 int 背包中的位置
-- @param packIndex2 int 背包中的位置
-- 
function Backpack:PublicSwapItem( packIndex1, packIndex2 )
	
	if packIndex1 > BackpackConfig.MaxPublicItem or packIndex1 < 0 then return false end
	if packIndex2 > BackpackConfig.MaxPublicItem or packIndex2 < 0 then return false end

	local pack = self:GetPublicBackpack()

	if pack then
	 	local temp = pack[packIndex1]
	 	pack[packIndex1] = pack[packIndex2]
	 	pack[packIndex2] = temp

	 	self:publicUpdateItem( packIndex1 )
	 	self:publicUpdateItem( packIndex2 )
	 	
	end
end
-- 与物品栏位置对换
function Backpack:SwapInInventory( unit, packIndex, slot )

	if self:HasBackpack(unit) then
		if slot > BackpackConfig.MaxBodyIndex then return false end

		local pack = self:GetBackpack(unit)
		local item = unit:GetItemInSlot(slot)

		if item == nil and pack[packIndex] == -1 then return false end
		local packItem = EntIndexToHScript(pack[packIndex])
		

		local hasnosame=true
		for i=0,BackpackConfig.MaxBodyIndex do
			local itemss = unit:GetItemInSlot(i)
			if itemss and itemss:GetAbilityName() == packItem:GetAbilityName() then
				if itemss:IsStackable() then --是不是消耗品
					hasnosame=false
					itemss:SetCurrentCharges(itemss:GetCurrentCharges()+packItem:GetCurrentCharges())
				end  
			end
		end
		if hasnosame then
			if item then
				pack[packIndex] = item:GetEntityIndex()
				unit:TakeItem(item)
			else
				pack[packIndex] = -1
			end
			unit:AddItem(packItem)
			if packItem:GetItemSlot() ~= slot then
				unit:SwapItems(packItem:GetItemSlot(),slot)
			end
		else
			pack[packIndex] = -1
		end
		self:UpdateItem( unit, packIndex )
	end
end

-- 遍历
-- @param unit handle 单位
-- @param func function 函数，每遍历一个物品调用一次，空的格子不遍历，返回true终止遍历，固有参数(pack,packIndex,itemIndex)
-- 
function Backpack:Traverse( unit, func )
	if self:HasBackpack(unit) then
		local pack = self:GetBackpack(unit)

		for packIndex,itemIndex in pairs(pack) do
			if itemIndex ~= -1 then
				if func(pack,packIndex,itemIndex) then return end
			end
		end
	end
end

-- 创建物品
-- 
function Backpack:CreateItem( unit, itemName )
	
	if self:HasBackpack(unit) then
		if self:IsFull(unit) then
			local pos = unit:GetOrigin()
			local addItem = CreateItem(itemName, nil, nil)
			DropItemEx(addItem,pos,150)
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
function Backpack:SellItem( unit, item )
	if type(item) ~= "table" then return nil end
	if item:IsNull() then return nil end
	
	if GameRules.m_ItemData_Items[item:GetAbilityName()].ItemSellable and GameRules.m_ItemData_Items[item:GetAbilityName()].ItemSellable==0 then
		--senderrormessage(unit,"#cantsell")
		return
	end
	local cost = item:GetCost(); 
	if item:IsStackable() then
		cost=(cost/item:GetInitialCharges()*item:GetCurrentCharges())/2

	else 
		cost=cost/2
	end
	
	if cost == 0 then return end

	if Backpack:ConsumeItem( unit, item ) then
		PlayerUtil.ModifyGold(unit,cost)
		EmitSoundOnClient("General.Coins",unit:GetPlayerOwner())
		local p = ParticleManager:CreateParticle("particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf",PATTACH_CUSTOMORIGIN,unit)
		ParticleManager:SetParticleControl(p,1,unit:GetOrigin())
		ParticleManager:ReleaseParticleIndex(p)
	end
end

-- 放置末尾
-- 
function Backpack:ItemPosToEnd( unit, packIndex )
	if packIndex > BackpackConfig.MaxItem or packIndex < 0 then return false end
	local pack = self:GetBackpack(unit)

	if pack then
		for i=BackpackConfig.MaxItem,1,-1 do
			if pack[i] == -1 then
				Backpack:SwapItem( unit, packIndex, i )
				break
			end
		end

	 
	end
end

-- 重新获取背包
-- @param unit handle 单位
-- 
function Backpack:GetOldBackpack( unit,oldheroindex)
	if type(unit) ~= "table" then return nil end
	if unit:IsNull() then return nil end

	Backpack.m_UnitItems[unit:GetEntityIndex()]=Backpack.m_UnitItems[oldheroindex]
end

--初始化公共背包
function Backpack:setpublic()
	local public_data = {}
	for i=1,BackpackConfig.MaxPublicItem do
		public_data[i] = -1
	end
	Backpack.publicitem=public_data
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("PublicBackpack"), function( )--包裹列表
		local pack = self:GetPublicBackpack()

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
end
-- 初始化
function Backpack:__call( unit )
	if type(unit) ~= "table" then return end
	if unit:IsNull() then return end
	if not unit:HasInventory() then return end

	local unitIndex = unit:GetEntityIndex()

	local data = {}

	for i=1,BackpackConfig.MaxItem do
		data[i] = -1
	end

	Backpack.m_UnitItems[unitIndex] = data
	
	unit:SetContextThink(DoUniqueString("Backpack"), function( )--包裹列表
		
		local pack = self:GetBackpack(unit)

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


end

-- 物品从背包中丢出
function UI_BackpackDropItem( event,data )
	
	if GameRules:IsGamePaused() then return end
	if type(data.itemIndex) == "number" and type(data.unitIndex) == "number" and type(data.pos_x) == "number" and type(data.pos_y) == "number" and type(data.pos_z) == "number" then
		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end
		
		--目标点无法到达，不执行操作
		local pos = Vector(data.pos_x,data.pos_y,data.pos_z)
		if not GridNav:IsTraversable(pos) then
			NotifyUtil.ShowError(data.PlayerID,"#error_position_unreachable")
			return;
		end
		
		local hero = player:GetAssignedHero()
		if not EntityIsAlive(hero) then return end
		
		local unit = EntIndexToHScript(data.unitIndex)
		if not EntityIsAlive(unit) then return end
		
		
		local item = EntIndexToHScript(data.itemIndex)

		Backpack:DropItemToOtherUnitPosition(hero, unit, item, pos)
		
		
	end
end
-- 物品从公共背包中丢出
function UI_PublicBackpackDropItem( event,data )
	
	if GameRules:IsGamePaused() then return end
	if type(data.itemIndex) == "number" and type(data.unitIndex) == "number" and type(data.pos_x) == "number" and type(data.pos_y) == "number" and type(data.pos_z) == "number" then
		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end
		
		--目标点无法到达，不执行操作
		local pos = Vector(data.pos_x,data.pos_y,data.pos_z)
		if not GridNav:IsTraversable(pos) then
			NotifyUtil.ShowError(data.PlayerID,"#error_position_unreachable")
			return;
		end
		
		local hero = player:GetAssignedHero()
		if not EntityIsAlive(hero) then return end
		
		local unit = EntIndexToHScript(data.unitIndex)
		if not EntityIsAlive(unit) then return end
		
		
		local item = EntIndexToHScript(data.itemIndex)

		Backpack:PublicDropItemToOtherUnitPosition(hero, unit, item, pos)
	end
end
-- 背包物品对换位置
function UI_BackpackSwapPosition( event,data )
	
	if GameRules:IsGamePaused() then return end
	if type(data.packIndex1) == "number" and type(data.packIndex2) == "number" then
		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end

		local hero = player:GetAssignedHero()
		if hero == nil then return end
		if hero:IsNull() and not hero:IsAlive() then return end
		
		Backpack:SwapItem( hero, data.packIndex1, data.packIndex2 )
	end
end
-- 公共背包物品对换位置
function UI_publicBackpackSwapPosition( event,data )
	
	if GameRules:IsGamePaused() then return end
	if type(data.packIndex1) == "number" and type(data.packIndex2) == "number" then
		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end

		local hero = player:GetAssignedHero()
		if hero == nil then return end
		if hero:IsNull() and not hero:IsAlive() then return end
		
		Backpack:PublicSwapItem( data.packIndex1, data.packIndex2 )
	end
end

-- 物品移动到公共仓库
function ui_pulickpack_input( event,data )
	if type(data.item) == "number" then
		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end

		local hero = player:GetAssignedHero()
		if hero == nil then return end
		if hero:IsNull() and not hero:IsAlive() then return end
		Backpack:pulickpack_input( hero, data.item,data.slot)
	end
end
function  UI_Backpackoutput( event,data )
	if type(data.packIndex1) == "number"  then
		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end

		local hero = player:GetAssignedHero()
		if hero == nil then return end
		if hero:IsNull() and not hero:IsAlive() then return end
		
		Backpack:publicoutput( hero, data.packIndex1,data.slot)
	end
end
function On_UI_update_publicpack(event,data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player == nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	for i=1,BackpackConfig.MaxItem do
		Backpack:publicUpdateItem(i )
	end
end
function On_UI_swapequip(event,data)
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player == nil then return end

	local hero = player:GetAssignedHero()
	if hero == nil then return end

	hero:SwapItems(data.slot1, data.slot2)
end

function On_UI_inventorydrop(event,data)
	if GameRules:IsGamePaused() then return end
	if type(data.itemIndex) == "number" and type(data.unitIndex) == "number" and type(data.pos_x) == "number" and type(data.pos_y) == "number" and type(data.pos_z) == "number" then
		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end
		
		--目标点无法到达，不执行操作
		local pos = Vector(data.pos_x,data.pos_y,data.pos_z)
		if not GridNav:IsTraversable(pos) then
			NotifyUtil.ShowError(data.PlayerID,"#error_position_unreachable")
			return;
		end
		local unit = EntIndexToHScript(data.unitIndex)
		if not EntityIsAlive(unit) then return end
		
		
		local item = EntIndexToHScript(data.itemIndex)

		for i=0,BackpackConfig.MaxBodyIndex do
			local itemss = unit:GetItemInSlot(i)
			if itemss == item then
				local index=i
				ExecuteOrderFromTable
				{
					UnitIndex = unit:GetEntityIndex(),
					OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
					Position = pos,
					Queue = 0
				}

				unit.m_inventory_DropItemToPosition_OrderType = DOTA_UNIT_ORDER_DROP_ITEM

				unit:SetContextThink(DoUniqueString("DropItemToPosition"), function()

					if unit.m_inventory_DropItemToPosition_OrderType ~= DOTA_UNIT_ORDER_DROP_ITEM then
						return nil
					end
					
					if (unit:GetOrigin() - pos):Length2D() <= 150 then
						local itemss = unit:GetItemInSlot(index) --修正
						if itemss then
							DropItemEx(itemss,pos)
							unit:TakeItem(itemss)
							unit:Stop()
						end
						return nil
					end
					
					return 0.2
				end, 0)
				
				break;
			end
		end
		
	end
end
-- 拖拽装备
function Backpack:OnDrapEquip( data )
	
	if type(data.packIndex) == "number" and type(data.slot) == "number" then
		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end
		
		local hero = player:GetAssignedHero()
		if hero == nil then return end
		if hero:IsNull() then return end
		local itemIndex = Backpack:GetItemIndex( hero, data.packIndex )
		
		local item = EntIndexToHScript(itemIndex)
		Backpack:OnEquip(data)
		
	end
end
function Backpack:OnDrapEquippublic( data )
	if type(data.packIndex) == "number" and type(data.slot) == "number" then
		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end
		
		local hero = player:GetAssignedHero()
		if hero == nil then return end
		if hero:IsNull() then return end
		local itemIndex = Backpack:GetItemIndex( hero, data.packIndex )
		local item = EntIndexToHScript(itemIndex)
		Backpack:publicoutputinventory(hero, data.packIndex,data.slot)
	end
end
-- 双击装备
function Backpack:OnDoubleClickEquip( data )
	if type(data.packIndex) == "number" and type(data.itemIndex) == "number" then
		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end
		
		local hero = player:GetAssignedHero()
		if hero == nil then return end
		if hero:IsNull() then return end
		local item = EntIndexToHScript(data.itemIndex)

		if item == nil then return end
	
		local slot = -1
		for i=0,BackpackConfig.MaxBodyIndex do
			if hero:GetItemInSlot(i) == nil then
				slot=i
				break;
			end
		end
		if slot ~= -1 then
			data.slot = slot
			Backpack:OnEquip(data)
		end
	end
end
-- 装备事件
function Backpack:OnEquip( data )
	
	if type(data.packIndex) == "number" and type(data.slot) == "number" then
		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end
		
		local hero = player:GetAssignedHero()
		if hero == nil then return end
		if hero:IsNull() then return end
		Backpack:SwapInInventory( hero, data.packIndex, data.slot )
	end
end

-- 双击卸载
function Backpack:OnDoubleClickUninstall( data )
	if type(data.itemIndex) == "number" then
		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end
		
		local hero = player:GetAssignedHero()
		if hero == nil then return end
		if hero:IsNull() then return end

		local item = EntIndexToHScript(data.itemIndex)
		local hasitem=false
		for item_slot = 0,BackpackConfig.MaxBodyIndex do
			local item = hero:GetItemInSlot(item_slot)
			if item ~= nil and item:GetEntityIndex()==data.itemIndex then  --修正
				hasitem=true
			end
		end
		if hasitem then
			Backpack:AddItemImmediate( hero, item,data.slot )
		end
	end
end


-- 物品从背包中丢出
CustomGameEventManager:RegisterListener("ui_event_backpack_drop_item",UI_BackpackDropItem)

CustomGameEventManager:RegisterListener("ui_event_publicbackpack_drop_item",UI_PublicBackpackDropItem)

CustomGameEventManager:RegisterListener("ui_event_inventory_drop_item",On_UI_inventorydrop)

-- 背包物品对换位置
CustomGameEventManager:RegisterListener("ui_event_backpack_swap_pos",UI_BackpackSwapPosition)

-- 公共背包物品对换位置
CustomGameEventManager:RegisterListener("ui_event_publicbackpack_swap_pos",UI_publicBackpackSwapPosition)

-- 移动物品到公共仓库
CustomGameEventManager:RegisterListener("ui_event_pulickpack_input",ui_pulickpack_input)
-- 公共仓库拉取物品
CustomGameEventManager:RegisterListener("ui_event_backpack_swap_public",UI_Backpackoutput)
-- 公共仓库交互1
CustomGameEventManager:RegisterListener("ui_event_update_publicpack",On_UI_update_publicpack)   
CustomGameEventManager:RegisterListener("ui_event_equip_system_swapequip",On_UI_swapequip)

CustomGameEventManager:RegisterListener("ui_event_equip_system_equip",Dynamic_Wrap(Backpack,"OnDrapEquip"))
CustomGameEventManager:RegisterListener("ui_event_equip_system_publicbag",Dynamic_Wrap(Backpack,"OnDrapEquippublic"))
CustomGameEventManager:RegisterListener("ui_event_equip_system_dblclick_equip",Dynamic_Wrap(Backpack,"OnDoubleClickEquip"))
CustomGameEventManager:RegisterListener("ui_event_equip_system_dblclick_uninstall",Dynamic_Wrap(Backpack,"OnDoubleClickUninstall"))

