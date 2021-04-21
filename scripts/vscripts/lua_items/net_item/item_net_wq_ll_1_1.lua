item_net_wq_ll_1_1 = class({})
function item_net_wq_ll_1_1:Spawn()
	if IsServer() then
		local buff_list={}
		local show_list={}
		local item_zdl ={}
		local zdl = 0 --战斗力
		local rare = {}
		local time = NetTime	--本局第几次创建的
		local itemlevel =NetLevel[time]  --物品的等阶
		local itemrare =NetPz[time]  --物品的品质
		if itemlevel==nil then
			itemlevel=1
		end
		if itemrare==nil then
			itemrare=1
		end
		  --随机装备等级，由阶段固定  --需要由怪物等级控制
		buff_list.itemlevel=itemlevel--存储物品等级
		buff_list.itemrare=itemrare--存储物品等级
		local base_pro_num=Weightsgetvalue_one_se(NetItem_Rare["rare_"..itemrare]['rare_base_pro'])  --普通词条个数
		local spe_pro_num=Weightsgetvalue_one_se(NetItem_Rare["rare_"..itemrare]['rare_spe_pro'])  --特殊词条个数
		local namearray= string.split(self:GetName(), "_")
		local selftype="weapon"
		if namearray[3]== "wq" then
			selftype="weapon"
		end
		if namearray[3]== "fj" then
			selftype="clothes"
		end
		if namearray[3]== "ss" then
			selftype="jewelry"
		end
		if namearray[3]== "ts" then
			selftype="assistitem"
		end
		--local namearray2= namearray[4]	由于有人建议，现在纯随机	
		local baseprotable={}
		local speprotable={}
		if tonumber(namearray[5]) >= 6 and namearray[3] == "wq" then
			baseprotable=Weightsgetvalue_one_key(NetItem_Pro_Weight[selftype]["base_ty_pro2"],base_pro_num)
			speprotable=Weightsgetvalue_one_key(NetItem_Pro_Weight[selftype]["base_ty_pro2"],spe_pro_num)
		else
			baseprotable=Weightsgetvalue_one_key(NetItem_Pro_Weight[selftype]["base_ty_pro"],base_pro_num)
			speprotable=Weightsgetvalue_one_key(NetItem_Pro_Weight[selftype]["base_ty_pro"],spe_pro_num)
		end

		buff_list.item_attributes={}
		buff_list.item_attributes_spe={}
		show_list.item_attributes={}
		show_list.item_attributes_spe={}
		for i=1,#baseprotable do
			local rarevalue=RandomFloat(NetItem_Rare["rare_"..itemrare]["pro_value"][1], NetItem_Rare["rare_"..itemrare]["pro_value"][2]) --品质区间
			local k=baseprotable[i]
			local result=RandomFloat(NetRare_Pro_Value[selftype][k][itemlevel][1],NetRare_Pro_Value[selftype][k][itemlevel][2])
		
			local v=string.format("%.2f",result*rarevalue)	
	
			if not item_zdl[k] then 
				item_zdl[k] = 0
			end
			item_zdl[k] = item_zdl[k] + v
			if buff_list.item_attributes[baseprotable[i]] then
				table.insert(show_list.item_attributes[k],v)
				buff_list.item_attributes[k]=buff_list.item_attributes[k]+v
			else
				show_list.item_attributes[k]={}
				table.insert(show_list.item_attributes[k],v)
				buff_list.item_attributes[k]=v
			end
		end
		
		for i=1,#speprotable do
			local rarevalue=RandomFloat(NetItem_Rare["rare_"..itemrare]["pro_value"][1], NetItem_Rare["rare_"..itemrare]["pro_value"][2]) --品质区间
			local k=speprotable[i]
			local result=RandomFloat(NetRare_Pro_Value[selftype][k][itemlevel][1],NetRare_Pro_Value[selftype][k][itemlevel][2])
			local v=string.format("%.2f",result*rarevalue)	

			if not item_zdl[k] then 
				item_zdl[k] = 0
			end
			item_zdl[k] = item_zdl[k] + v
			if buff_list.item_attributes_spe[k] then
				table.insert(show_list.item_attributes_spe[k],v)
				buff_list.item_attributes_spe[k]=buff_list.item_attributes_spe[k]+v
			else
				show_list.item_attributes_spe[k]={}
				table.insert(show_list.item_attributes_spe[k],v)
				buff_list.item_attributes_spe[k]=v
			end
			
		end
		
		for k,v in pairs(item_zdl) do	--先用 加法的公式来看看装备的战斗力
			zdl = (item_zdl[k] * NetZdl[k])  +zdl 
		end
		
		zdl = math.ceil(zdl)
		
		CustomNetTables:SetTableValue( "ItemsInfo", string.format( "%d", self:GetEntityIndex() ), buff_list)
		self.itemtype=buff_list
		self.pz = itemrare
		self.lv = itemlevel
		self.zdl = zdl
		local js =  Netpzjs[itemrare] * 10 * Netdjjs[itemlevel]
		self.js =  js
		show_list.itemlevel=itemlevel--存储物品等级
		show_list.itemrare=itemrare--存储物品等级
		show_list.js=js--分解装备应该获得的晶石
		show_list.zdl = zdl
		self.show_list = show_list
		CustomNetTables:SetTableValue( "ItemsInfoShow", string.format( "%d", self:GetEntityIndex() ), show_list)
	end
end
function item_net_wq_ll_1_1:Weightsgetvalue_one(wtable)
	local keys = {}
	local weights = {}
	
	for key, weight in pairs(wtable) do
		table.insert(keys,key)
		table.insert(weights,weight)
	end
	
	local values = {}
	local total = 0
	for idx, weight in ipairs(weights) do
		total = total + weight
		table.insert(values,total)
	end
	
	local random = RandomInt(1,total)
	
	for idx, value in pairs(values) do
		if random <= value then
			return keys[idx]
		end
	end
end

function item_net_wq_ll_1_1:ReFreshData()
	if IsServer() then
		xpcall(function()
			
			local buff_list={}
			local show_list=self.tempdata
			local item_zdl ={}
			local zdl = 0 --战斗力
			local itemlevel =self.lv  --物品的等阶
			local itemrare =self.pz   --物品的品质
			buff_list.itemlevel=itemlevel--存储物品等级
			buff_list.itemrare=itemrare--存储物品等级
			local attr_addper=0
			if show_list.enhance then
				show_list.enhance=tonumber(show_list.enhance)
				attr_addper=Enhance_qhjc[show_list.enhance ]--加成百分比
			end
			buff_list.item_attributes={}
			buff_list.item_attributes_spe={}
			for k,v in pairs(show_list.item_attributes) do
				local totalvalue=0
				local attrValue = show_list.item_attributes[k];
				if type(attrValue) == "table" then
					for kk,vv in pairs(attrValue) do --获取总数值
						totalvalue=totalvalue+vv
					end
				elseif type(attrValue) == "number" then
					totalvalue = attrValue
				end
				
				buff_list.item_attributes[k]=tonumber(string.format("%.2f",totalvalue*(1+attr_addper/100)))
				if not item_zdl[k] then 
					item_zdl[k] = 0
				end
				item_zdl[k] = item_zdl[k] + tonumber(string.format("%.2f",totalvalue*(1+attr_addper/100)))
				
			end
			
			for k,v in pairs(show_list.item_attributes_spe) do
				local totalvalue=0
				local attrValue = show_list.item_attributes_spe[k]
				if type(attrValue) == "table" then
					for kk,vv in pairs(attrValue) do --获取总数值
						totalvalue=totalvalue+vv
					end
				elseif type(attrValue) == "number" then
					totalvalue = attrValue
				end
				buff_list.item_attributes_spe[k]=tonumber(string.format("%.2f",totalvalue*(1+attr_addper/100))) 
				if not item_zdl[k] then 
					item_zdl[k] = 0
				end
				item_zdl[k] = item_zdl[k] + tonumber(string.format("%.2f",totalvalue*(1+attr_addper/100)))

			end
			
			for k,v in pairs(item_zdl) do	--先用 加法的公式来看看装备的战斗力
				if NetZdl[k] then
					zdl = (item_zdl[k] * NetZdl[k])  +zdl 
				end
			end
			
			zdl = math.ceil(zdl)
			self.itemtype=buff_list
			CustomNetTables:SetTableValue( "ItemsInfo", string.format( "%d", self:GetEntityIndex() ), buff_list)
			self.zdl = zdl
			local js =  Netpzjs[itemrare] * 10 * Netdjjs[itemlevel]
			self.js =  js
			show_list.js=js
			show_list.itemlevel=itemlevel--存储物品等级
			show_list.itemrare=itemrare--存储物品等级
			show_list.zdl = zdl
			CustomNetTables:SetTableValue( "ItemsInfoShow", string.format( "%d", self:GetEntityIndex() ), show_list)
		end,function(msg)
			if IsInToolsMode() then
				print(msg..'\n'..debug.traceback()..'\n')
			end
		
		end)
	end
end
function item_net_wq_ll_1_1:GetstoneData(level,neednum,isfocus)
	local stonename=Enhance_stonename[level]
	local stonenum=Shopmall:GetItemNum(self:GetPurchaser():GetPlayerOwnerID(),stonename)
	if level==2 then
		
		if stonenum<neednum then
			SendToClient(self:GetPurchaser():GetPlayerOwnerID(),"tzj_net_equip_enhance_return",{success=false,item=self:GetEntityIndex(),error=3})
			self.error=3
			return 3
		else
			if isfocus==false then
				SendToClient(self:GetPurchaser():GetPlayerOwnerID(),"tzj_net_equip_enhance_return",{success=false,error=2,item=self:GetEntityIndex(),data={item=Enhance_stonename[level],count=neednum}})
			end
			self.error=-1
			self.rightlevel=level
			self.stone=neednum
			return -1,level,neednum
		end
	else
		
		if stonenum<neednum then
			self:GetstoneData(level-1,neednum*4,isfocus)
		else
			if isfocus==false then
				SendToClient(self:GetPurchaser():GetPlayerOwnerID(),"tzj_net_equip_enhance_return",{success=false,error=2,item=self:GetEntityIndex(),data={item=Enhance_stonename[level],count=neednum}})
			end
			self.error=-1
			self.rightlevel=level
			self.stone=neednum
			return -1,level,neednum
		end
	end
end
function item_net_wq_ll_1_1:EnhanceData(isfocus)----强化装备消耗石头，改变self.enhance的值之后重新计算属性
	if IsServer() then
			self.stone=0--需要的石头 
			local stonename=""--需要的石头 
			if self.lv<2 then
				SendToClient(self:GetPurchaser():GetPlayerOwnerID(),"tzj_net_equip_enhance_return",{success=false,item=self:GetEntityIndex(),error=1})
				return  1
			end
			if self.pz<2 then
				SendToClient(self:GetPurchaser():GetPlayerOwnerID(),"tzj_net_equip_enhance_return",{success=false,item=self:GetEntityIndex(),error=1})
				return 1
			end
			stonename=Enhance_stonename[self.lv]
			local stonenum=Shopmall:GetItemNum(self:GetPurchaser():GetPlayerOwnerID(),stonename)
			if self.tempdata==nil then
				local tempdata=CustomNetTables:GetTableValue( "ItemsInfoShow", string.format( "%d", self:GetEntityIndex() ))
				self.tempdata={}
				self.tempdata['item_attributes']=tempdata['item_attributes']
				self.tempdata['item_attributes_spe']=tempdata['item_attributes_spe']
			end
			if self.tempdata.enhance==nil then
				self.stone=Enhance_qhxh[1]
			else
				if self.tempdata.enhance<EnhanceTimes[self.lv][self.pz] then  --是否强化满了
					self.stone=Enhance_qhxh[self.tempdata.enhance+1]
				else
					SendToClient(self:GetPurchaser():GetPlayerOwnerID(),"tzj_net_equip_enhance_return",{success=false,item=self:GetEntityIndex(),error=1})
					return 1
				end
			end
			self.error=-1
			self.rightlevel=self.lv
			local isuseother=false
			if stonenum<self.stone then
				if self.lv>2 then
					isuseother=true
					self:GetstoneData(self.lv-1,self.stone*4,isfocus)
				else
					SendToClient(self:GetPurchaser():GetPlayerOwnerID(),"tzj_net_equip_enhance_return",{success=false,item=self:GetEntityIndex(),error=3})
					self.error=3
				end
			end
			if isuseother==true and isfocus==false then  --是否确认使用其它强化石
				return self.error,self.rightlevel,self.stone
			end
			if self.error==-1 then
				local issuc=false
				if self.tempdata.enhance==nil then
					self.tempdata.enhance=0
				end
				self.tempdata.enhance=tonumber(self.tempdata.enhance)
				if self.tempdata.enhance<EnhanceTimes[self.lv][self.pz] then  --是否强化满了
					if RollPercentage(EnhanceRoll[self.tempdata.enhance+1]) then  --概率强化
						issuc=true
					end
				else
					SendToClient(self:GetPurchaser():GetPlayerOwnerID(),"tzj_net_equip_enhance_return",{success=false,item=self:GetEntityIndex(),error=1})
					return 1 --不可强化
				end
				local tempdata=CustomNetTables:GetTableValue( "ItemsInfoShow", string.format( "%d", self:GetEntityIndex() ))
				local temp={}
				temp['item_attributes']=tempdata['item_attributes']
				temp['item_attributes_spe']=tempdata['item_attributes_spe']
				if issuc==true then
					temp['enhance']=self.tempdata.enhance+1 --强化成功存入新的数据
				else
					temp['enhance']=self.tempdata.enhance--强化失败存入旧的数据
				end
				---装备强化
				--@param #number PlayerID 玩家ID
				--@param #string itemServerID 装备服务器ID
				--@param #number score 装备新的战斗力
				--@param #table attr 装备强化以后新的属性数据
				--@param #string stoneName 强化石名称
				--@param #number stoneCount 消耗的强化石数量
				--@param #function callback 回调函数，调用参数：success,arg2,arg3
				--success=true时，arg2、arg3均为nil
				--success=false时，arg2代表失败原因：-1=服务器未响应，100=本地调用传入的参数异常，0=未知错误，1=服务器返回的参数异常，2=该装备在服务器上不存在，3=减少强化石数量失败（如果是数量不足，则arg3就代表实际拥有的强化石数量），4=装备数据更新失败
				stonenum=Shopmall:GetItemNum(self:GetPurchaser():GetPlayerOwnerID(),Enhance_stonename[self.rightlevel])
				SrvNetEquip.Enhance(self:GetPurchaser():GetPlayerOwnerID(),self.serverID,self.zdl,temp,Enhance_stonename[self.rightlevel],self.stone,issuc,function(success,arg2,arg3)
					if success then
						print("Enhance_true")
						Shopmall:UpdatePlayerdata( self:GetPurchaser():GetPlayerOwnerID(),Enhance_stonename[self.rightlevel],(stonenum-self.stone),nil)
						if issuc==true then
							self.tempdata.enhance=self.tempdata.enhance+1
							self:ReFreshData()
							SendToClient(self:GetPurchaser():GetPlayerOwnerID(),"tzj_net_equip_enhance_return",{success=true,item=self:GetEntityIndex()})
						else
							SendToClient(self:GetPurchaser():GetPlayerOwnerID(),"tzj_net_equip_enhance_return",{success=false,error=4,item=self:GetEntityIndex()})
						end
						return 5
					else
						if arg2==3 then
							Shopmall:UpdatePlayerdata( self:GetPurchaser():GetPlayerOwnerID(),Enhance_stonename[self.rightlevel],arg3,nil)
						end
						SendToClient(self:GetPurchaser():GetPlayerOwnerID(),"tzj_net_equip_enhance_return",{success=false,error=arg2,item=self:GetEntityIndex()})
						print("Enhance_false",arg2,arg3)
						return 6
					end
				
				end)
				
			end
		
	end
end
--error 0:未知错误1满级了2=该装备在服务器上不存在，3=洗练石数量不足，4=装备数据更新失败
function item_net_wq_ll_1_1:ReFineData()----洗练
	if IsServer() then
			self.refinestone=1--需要的石头 
			local stonename="shopmall_xlstone_1"--需要的石头 
			if self.tempdata==nil then
				local tempdata=CustomNetTables:GetTableValue( "ItemsInfoShow", string.format( "%d", self:GetEntityIndex() ))
				self.tempdata={}
				self.tempdata['item_attributes']=tempdata['item_attributes']
				self.tempdata['item_attributes_spe']=tempdata['item_attributes_spe']
				self.tempdata['rf']=tempdata['rf']
				
			end
			if self.tempdata.rf==nil then
				self.tempdata.rf=1
			else
				if self.tempdata.rf<=10 then  --是否强化满了
					self.refinestone=self.tempdata.rf+1
				else
					SendToClient(self:GetPurchaser():GetPlayerOwnerID(),"tzj_ui_refine_return",{success=false,item=self:GetEntityIndex(),error=1})
					return 1
				end
			end
			local stonenum=Shopmall:GetItemNum(self:GetPurchaser():GetPlayerOwnerID(),stonename)
			if stonenum<self.refinestone then
				SendToClient(self:GetPurchaser():GetPlayerOwnerID(),"tzj_ui_refine_return",{success=false,item=self:GetEntityIndex(),error=3})
				return 3
			end
			local issuc=true
			self.tempdata.rf=tonumber(self.tempdata.rf)
			local tempdata=CustomNetTables:GetTableValue( "ItemsInfoShow", string.format( "%d", self:GetEntityIndex() ))
			local temp=tempdata
			if issuc==true then
				temp['rf']=self.tempdata.rf+1 --强化成功存入新的数据
			end
			self.baseattr=Sachievement:DeepCopy(temp)    --暂存洗练前的属性，用来恢复用
			local namearray= string.split(self:GetName(), "_")
			local selftype="weapon"
			if namearray[3]== "wq" then
				selftype="weapon"
			end
			if namearray[3]== "fj" then
				selftype="clothes"
			end
			if namearray[3]== "ss" then
				selftype="jewelry"
			end
			if namearray[3]== "ts" then
				selftype="assistitem"
			end
			
			for k,v in pairs(temp.item_attributes) do
				if type(v) == "table" then
					for kk,vv in pairs(v) do --获取总数值
						local cc=(NetItem_Rare["rare_"..self.pz]["pro_value"][2])*(NetRare_Pro_Value[selftype][k][self.lv][2])
						local tempmax=cc-vv
						local tempmin=(cc-vv)/10
						local result=RandomFloat(tempmin,tempmax)	
						--print("===",tempmin,tempmax,result)
						temp.item_attributes[k][kk]=string.format("%.2f",vv+result)
					end
				elseif type(v) == "number" then
					local cc=(NetItem_Rare["rare_"..self.pz]["pro_value"][2])*(NetRare_Pro_Value[selftype][k][self.lv][2])
					local tempmax=cc-v
					local tempmin=tempmax/10
					local result=RandomFloat(tempmin,tempmax)
					--print("===",tempmin,tempmax,result)
					temp.item_attributes[v] = string.format("%.2f",v+result)
				end
			end
			
			for k,v in pairs(temp.item_attributes_spe) do
				if type(v) == "table" then
					for kk,vv in pairs(v) do --获取总数值
						local cc=(NetItem_Rare["rare_"..self.pz]["pro_value"][2])*(NetRare_Pro_Value[selftype][k][self.lv][2])
						local tempmax=cc-vv
						local tempmin=tempmax/10
						local result=RandomFloat(tempmin,tempmax)
						--print("===",tempmin,tempmax,result)
						temp.item_attributes_spe[k][kk]=string.format("%.2f",vv+result)	
					end
				elseif type(v) == "number" then
					local cc=(NetItem_Rare["rare_"..self.pz]["pro_value"][2])*(NetRare_Pro_Value[selftype][k][self.lv][2])
					local tempmax=cc-v
					local tempmin=tempmax/10
					local result=RandomFloat(tempmin,tempmax)
					--print("===",tempmin,tempmax,result)
					temp.item_attributes_spe[v] = string.format("%.2f",v+result)
				end
			end
			
			self.tempdata=Sachievement:DeepCopy(temp)
			self:ReFreshData()
			---装备强化
			--@param #number PlayerID 玩家ID
			--@param #string itemServerID 装备服务器ID
			--@param #number score 装备新的战斗力
			--@param #table attr 装备强化以后新的属性数据
			--@param #string stoneName 强化石名称
			--@param #number stoneCount 消耗的强化石数量
			--@param #function callback 回调函数，调用参数：success,arg2,arg3
			--success=true时，arg2、arg3均为nil
			--success=false时，arg2代表失败原因：-1=服务器未响应，100=本地调用传入的参数异常，0=未知错误，1=服务器返回的参数异常，2=该装备在服务器上不存在，3=减少强化石数量失败（如果是数量不足，则arg3就代表实际拥有的强化石数量），4=装备数据更新失败
			SrvNetEquip.Enhance(self:GetPurchaser():GetPlayerOwnerID(),self.serverID,self.zdl,temp,stonename,self.refinestone,issuc,function(success,arg2,arg3)
				if success then
					print("rf_true")
					Shopmall:UpdatePlayerdata( self:GetPurchaser():GetPlayerOwnerID(),stonename,(stonenum-self.refinestone),nil)
					if issuc==true then
						self.tempdata.rf=self.tempdata.rf+1
						SendToClient(self:GetPurchaser():GetPlayerOwnerID(),"tzj_ui_refine_return",{success=true,item=self:GetEntityIndex(),old_attr=self.baseattr,attr=temp,score=self.zdl})
					
					end
					return 5
				else
					if self.baseattr then  --如果失败，则数值不变
						self.tempdata=self.baseattr  
						self:ReFreshData()
					end
					if arg2==3 then
						Shopmall:UpdatePlayerdata( self:GetPurchaser():GetPlayerOwnerID(),stonename,arg3,nil)
					end
					SendToClient(self:GetPurchaser():GetPlayerOwnerID(),"tzj_ui_refine_return",{success=false,error=arg2,item=self:GetEntityIndex()})
					print("rf_false",arg2,arg3)
					return 6
				end
			
			end)
				
			
		
	end
end
--error 0:未知错误1满级了2=该装备在服务器上不存在，3=重铸石数量不足，4=装备数据更新失败
function item_net_wq_ll_1_1:ReCastData(save)----重铸
	if IsServer() then
			self.recaststone=1--需要的石头 
			local stonename="shopmall_czstone_1"--需要的石头 
			if self.tempdata==nil then
				local tempdata=CustomNetTables:GetTableValue( "ItemsInfoShow", string.format( "%d", self:GetEntityIndex() ))
				self.tempdata={}
				self.tempdata['item_attributes']=tempdata['item_attributes']
				self.tempdata['item_attributes_spe']=tempdata['item_attributes_spe']
				self.tempdata['recast']=tempdata['recast']
				
			end
			if self.tempdata.recast==nil then
				self.tempdata.recast=1
			else
				if self.tempdata.recast<=3 then  --是否强化满了
					self.recaststone=self.tempdata.recast+1
				else
					SendToClient(self:GetPurchaser():GetPlayerOwnerID(),"tzj_ui_recast_return",{success=false,item=self:GetEntityIndex(),error=1})
					return 1
				end
			end
			local stonenum=Shopmall:GetItemNum(self:GetPurchaser():GetPlayerOwnerID(),stonename)
			if stonenum<self.recaststone then
				SendToClient(self:GetPurchaser():GetPlayerOwnerID(),"tzj_ui_recast_return",{success=false,item=self:GetEntityIndex(),error=3})
				return 3
			end
			local issuc=true
			self.tempdata.recast=tonumber(self.tempdata.recast)
			local tempdata=CustomNetTables:GetTableValue( "ItemsInfoShow", string.format( "%d", self:GetEntityIndex() ))
			local temp=tempdata
			if issuc==true then
				temp['recast']=self.tempdata.recast+1 --强化成功存入新的数据
			end
			if self.baseattr==nil then
				self.baseattr=Sachievement:DeepCopy(temp)    --暂存洗练前的属性，用来恢复用
			end

			local buff_list={}
			local show_list={}
			local item_zdl ={}
			local zdl = 0 --战斗力

			local namearray= string.split(self:GetName(), "_")
			local selftype="weapon"
			if namearray[3]== "wq" then
				selftype="weapon"
			end
			if namearray[3]== "fj" then
				selftype="clothes"
			end
			if namearray[3]== "ss" then
				selftype="jewelry"
			end
			if namearray[3]== "ts" then
				selftype="assistitem"
			end
			
			local base_pro_num=Weightsgetvalue_one_se(NetItem_Rare["rare_"..self.pz]['rare_base_pro'])  --普通词条个数
			local spe_pro_num=Weightsgetvalue_one_se(NetItem_Rare["rare_"..self.pz]['rare_spe_pro'])  --特殊词条个数
			
			local baseprotable={}
			local speprotable={}
			if tonumber(namearray[5]) >= 6 and namearray[3] == "wq" then
				baseprotable=Weightsgetvalue_one_key(NetItem_Pro_Weight[selftype]["base_ty_pro2"],base_pro_num)
				speprotable=Weightsgetvalue_one_key(NetItem_Pro_Weight[selftype]["base_ty_pro2"],spe_pro_num)
			else
				baseprotable=Weightsgetvalue_one_key(NetItem_Pro_Weight[selftype]["base_ty_pro"],base_pro_num)
				speprotable=Weightsgetvalue_one_key(NetItem_Pro_Weight[selftype]["base_ty_pro"],spe_pro_num)
			end

			buff_list.item_attributes={}
			buff_list.item_attributes_spe={}
			show_list.item_attributes={}
			show_list.item_attributes_spe={}
			for i=1,#baseprotable do
				local rarevalue=RandomFloat(NetItem_Rare["rare_"..self.pz]["pro_value"][1], NetItem_Rare["rare_"..self.pz]["pro_value"][2]) --品质区间
				local k=baseprotable[i]
				local result=RandomFloat(NetRare_Pro_Value[selftype][k][self.lv][1],NetRare_Pro_Value[selftype][k][self.lv][2])
				local v=string.format("%.2f",result*rarevalue)	
				if not item_zdl[k] then 
					item_zdl[k] = 0
				end
				item_zdl[k] = item_zdl[k] + v
				if buff_list.item_attributes[baseprotable[i]] then
					table.insert(show_list.item_attributes[k],v)
					buff_list.item_attributes[k]=buff_list.item_attributes[k]+v
				else
					show_list.item_attributes[k]={}
					table.insert(show_list.item_attributes[k],v)
					buff_list.item_attributes[k]=v
				end
			end
		
			for i=1,#speprotable do
				local rarevalue=RandomFloat(NetItem_Rare["rare_"..self.pz]["pro_value"][1], NetItem_Rare["rare_"..self.pz]["pro_value"][2]) --品质区间
				local k=speprotable[i]
				local result=RandomFloat(NetRare_Pro_Value[selftype][k][self.lv][1],NetRare_Pro_Value[selftype][k][self.lv][2])
				local v=string.format("%.2f",result*rarevalue)	

				if not item_zdl[k] then 
					item_zdl[k] = 0
				end
				item_zdl[k] = item_zdl[k] + v
				if buff_list.item_attributes_spe[k] then
					table.insert(show_list.item_attributes_spe[k],v)
					buff_list.item_attributes_spe[k]=buff_list.item_attributes_spe[k]+v
				else
					show_list.item_attributes_spe[k]={}
					table.insert(show_list.item_attributes_spe[k],v)
					buff_list.item_attributes_spe[k]=v
				end
				
			end
			
			for k,v in pairs(item_zdl) do	--先用 加法的公式来看看装备的战斗力
				zdl = (item_zdl[k] * NetZdl[k])  +zdl 
			end
			
			zdl = math.ceil(zdl)
			
			CustomNetTables:SetTableValue( "ItemsInfo", string.format( "%d", self:GetEntityIndex() ), buff_list)
			self.itemtype=buff_list
			self.zdl = zdl
			show_list.zdl = zdl
			self.show_list = show_list
			CustomNetTables:SetTableValue( "ItemsInfoShow", string.format( "%d", self:GetEntityIndex() ), show_list)
			temp.item_attributes=show_list.item_attributes
			temp.item_attributes_spe=show_list.item_attributes_spe
			self.tempdata=Sachievement:DeepCopy(temp)
			self:ReFreshData()
			if save==nil then
				SendToClient(self:GetPurchaser():GetPlayerOwnerID(),"tzj_ui_recast_return",{success=true,item=self:GetEntityIndex(),old_attr=self.baseattr,attr=temp,score=self.zdl})
				return
			end
			---装备强化
			--@param #number PlayerID 玩家ID
			--@param #string itemServerID 装备服务器ID
			--@param #number score 装备新的战斗力
			--@param #table attr 装备强化以后新的属性数据
			--@param #string stoneName 强化石名称
			--@param #number stoneCount 消耗的强化石数量
			--@param #function callback 回调函数，调用参数：success,arg2,arg3
			--success=true时，arg2、arg3均为nil
			--success=false时，arg2代表失败原因：-1=服务器未响应，100=本地调用传入的参数异常，0=未知错误，1=服务器返回的参数异常，2=该装备在服务器上不存在，3=减少强化石数量失败（如果是数量不足，则arg3就代表实际拥有的强化石数量），4=装备数据更新失败
			SrvNetEquip.Enhance(self:GetPurchaser():GetPlayerOwnerID(),self.serverID,self.zdl,temp,stonename,self.recaststone,issuc,function(success,arg2,arg3)
				if success then
					print("rf_true")
					Shopmall:UpdatePlayerdata( self:GetPurchaser():GetPlayerOwnerID(),stonename,(stonenum-self.recaststone),nil)
					if issuc==true then
						self.tempdata.rf=self.tempdata.rf+1
						SendToClient(self:GetPurchaser():GetPlayerOwnerID(),"tzj_ui_recast_return",{success=true,item=self:GetEntityIndex(),old_attr=self.baseattr,attr=temp,score=self.zdl})
					end
					return 5
				else
					if self.baseattr then  --如果失败，则数值不变
						self.tempdata=self.baseattr  
						self:ReFreshData()
					end
					if arg2==3 then
						Shopmall:UpdatePlayerdata( self:GetPurchaser():GetPlayerOwnerID(),stonename,arg3,nil)
					end
					SendToClient(self:GetPurchaser():GetPlayerOwnerID(),"tzj_ui_recast_return",{success=false,error=arg2,item=self:GetEntityIndex()})
					print("rf_false",arg2,arg3)
					return 6
				end
			
			end)
				
			
		
	end
end