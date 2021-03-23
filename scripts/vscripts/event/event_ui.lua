
---为某个玩家显示选择宝物界面
function ShowSelectTreasureUI(iPlayerID,lv)
	if Stage.gameFinished then
		return
	end
	local hero = PlayerUtil.GetHero(iPlayerID)
	if not hero then
		return;
	end
	local level = math.ceil(hero:GetLevel() / 40)
	if level == 0 then
		level = 1
	end
	local bw = {}
	local name={}
	local qz = {}
	local i = 1
	if lv == 0 then
		for k,v in pairs( BaoWu2 ) do
			if v["level"] == 0 or v["level"] <= level then		--添加和波数对应等阶的宝物
				local max = v["maxnum"][iPlayerID+1] or 0
				if max >= 1 then 						--最大数量小于1的也不会进去
					name[i]= k
					qz[i]= v["weight"]
					i = i + 1
				end
			end
		end
	else
		for k,v in pairs( BaoWu2 ) do
			if v["rare"] and v["rare"] == lv  then		--添加相应等级的神秘宝物
				local max = v["maxnum"][iPlayerID+1] or 0
				if max >= 1 then 						--最大数量小于1的也不会进去
					name[i]= k
					qz[i]= v["weight"]
					i = i + 1
				end
			end
		end
	end
	for i=1,3 do
		local randomValue = GetRanomByWeight(name, qz)	
		for i2=1,#name do
			if randomValue == name[i2] then
				table.remove(name,i2)
				table.remove(qz,i2)
			end
		end
		table.insert(bw,randomValue)
	end
	--用来一个个测试单独宝物的
--	bw[1] = "modifier_bw_5_10"
--	bw[2] = "modifier_bw_5_11"
--	bw[3] = "modifier_bw_4_5"
	
	CustomNetTables:SetTableValue( "tzj_storage", "tre_select_"..iPlayerID, bw)

end

---确认选择宝物
function UI_SelectTreasure(event,data,pz)
	--if GameRules:IsGamePaused() then return end -item item_bw_1
	local PlayerID = data.PlayerID;
	local player = PlayerResource:GetPlayer(PlayerID)
	if player == nil then return end
	local hero = player:GetAssignedHero()
	if hero == nil then return end
	if not hero.SelectTreasure and not pz then
		return nil
	end
	hero.SelectTreasure = nil
	local name = data.ab_name;
	
	--由于死亡状态下，无法添加modifier，所以如果英雄死亡了只暂存数据，复活后立刻执行
	if not hero:IsAlive() then
		if hero.deathtreasures then
			table.insert(hero.deathtreasures,name)
		else
			hero.deathtreasures={}
			table.insert(hero.deathtreasures,name)
		end
	else
		local treasures = PlayerUtil.getAttrByPlayer(PlayerID,"treasures")
		if not treasures then
			treasures = {}
			PlayerUtil.setAttrByPlayer(PlayerID,"treasures",treasures)
		end
		
		local needSyncClient = false;
		
		if name == "modifier_bw_all_2" then
			--新增皇者之路buff
			hero:AddNewModifier(hero, nil, data.ab_name, {} )
			--移除其他所有的modifier
			treasures = {}
			PlayerUtil.setAttrByPlayer(data.PlayerID,"treasures",treasures)
			
			table.insert(treasures,{name=name})
			needSyncClient = true;
		else
			if name == "modifier_bw_2_13" or name == "modifier_bw_3_11" then
				local abname="ab_bw_"..string.split(name, "_")[3].."_"..string.split(name, "_")[4]
				local ability = hero:FindAbilityByName(abname);
				if not ability then
					ability = hero:AddAbility(abname)
					table.insert(treasures,{name=name,ability=ability:entindex()})
					needSyncClient = true;
				end
				ability:UpgradeAbility(false)
			else
				if not hero:HasModifier(name) then
					table.insert(treasures,{name=name})
					needSyncClient = true;
				end
				hero:AddNewModifier(hero, nil, name, {} )
			end
		end
		
		if needSyncClient then
			CustomNetTables:SetTableValue( "tzj_storage", "tre_data_"..data.PlayerID,treasures)
		end
		
		--宝物被选择了处理完没有出现任何问题，数量-1
		local config = BaoWu2[name]
		if config then
			config = config["maxnum"]
			if type(config) == "table" and config[PlayerID + 1] then
				config[PlayerID + 1] = config[PlayerID + 1] - 1
			end
		end
	end
	
	--选完以后清空掉选项，掉线重连的时候就不再显示了
	CustomNetTables:SetTableValue( "tzj_storage", "tre_select_"..data.PlayerID, nil )
end

---直接关闭选择界面，则清空选项，这样重连以后也不会再显示了
function UI_CloseTreasureSelection(_,keys)
	local PlayerID = keys.PlayerID
	if PlayerUtil.IsValidPlayer(PlayerID) then
		--选完以后清空掉选项，掉线重连的时候就不再显示了
		local hero = PlayerUtil.GetHero(PlayerID)
		if hero == nil then return end
		if hero.SelectTreasure then
			hero.SelectTreasure = nil
		end
		CustomNetTables:SetTableValue( "tzj_storage", "tre_select_"..PlayerID, nil )
	end
end


function UI_BackpackMenuDropItem( event,data )

	if type(data.itemIndex) == "number" and type(data.unitIndex) == "number" then
		local unit = EntIndexToHScript(data.unitIndex)
		if unit == nil then return end

		local item = EntIndexToHScript(data.itemIndex)
		if item == nil then return end

		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end

		local hero = player:GetAssignedHero()
		if hero == nil then return end
		
		Backpack:DropItemToOtherUnit( hero, unit, item )
	end
end

function UI_BackpackMenuSellItem( event,data )
	--if GameRules:IsGamePaused() then return end
	if type(data.itemIndex) == "number" then
		local item = EntIndexToHScript(data.itemIndex)
		if item == nil then return end

		local player = PlayerResource:GetPlayer(data.PlayerID)
		if player == nil then return end

		local hero = player:GetAssignedHero()
		if hero == nil then return end
		
		Backpack:SellItem( hero, item )
	end
end

function playerbuyitem(event,data)
	if Stage.gameFinished then
		return
	end

	if GameRules:IsGamePaused() then return end
	local player = PlayerResource:GetPlayer(data.PlayerID)
	if player == nil then return end
	local hero = player:GetAssignedHero()
	if not EntityIsAlive(hero) then return end
	
	if hero.shop_buy_item_time and hero.shop_buy_item_time > GameRules:GetGameTime() then
		return;
	else
		hero.shop_buy_item_time = GameRules:GetGameTime() + 0.1
	end
	
	
	if PlagueLand:ModifyCustomGold(data.PlayerID, -GetItemCost(data.item_name)) then
		local newItem = CreateItem( data.item_name, nil, nil )
		hero:AddItem(newItem)
	else
		NotifyUtil.ShowError(data.PlayerID,"#money_no")
	end
	
end


function DoSellItem(PlayerID,hero,itemIndex)
	local item=EntIndexToHScript(itemIndex)
	for i=0,BackpackConfig.MaxBodyIndex do
		local itemss = hero:GetItemInSlot(i)
		if itemss == item then
			cswp2(item,PlayerID)
			return;
		end
	end
	
	local hasItem,packIndex = Backpack:HasItem( hero,  itemIndex )
	if hasItem then
		cswp2(item,PlayerID)
		local pack = Backpack:GetBackpack(hero)
		pack[packIndex] = -1;
		Backpack:UpdateItem( hero, packIndex )
	end
end

function UI_SellItem(event,data)
	local PlayerID = data.PlayerID;
	local player = PlayerResource:GetPlayer(PlayerID)
	if player == nil then return end
	local hero = player:GetAssignedHero()
	if hero == nil then return end
	if data.itemIndex==nil and data.items == nil then
		return
	end
	
	if data.itemIndex then
		DoSellItem(PlayerID,hero,data.itemIndex)
	elseif data.items then
		for _, itemID in pairs(data.items) do
			DoSellItem(PlayerID,hero,itemID)
		end
	end
	
end
--ui触发技能提升
function AbilityEnhance(_,data )
	local pid = data.PlayerID
	local caster = PlayerUtil.GetHero(pid)
	if caster:IsAlive() then
		if data.all == 1 then
			local item = CreateItem("item_mj_random_3", caster, caster)
			caster:AddItem(item)
		else
			local item = CreateItem("item_mj_random_1", caster, caster)
			caster:AddItem(item)	
		end
	end
end


--减少每波怪物出怪的总时间
function reducesgtime(_,data )
	if Stage.gameFinished then
		return
	end
	local pid = data.PlayerID
	if pid == 0 then
		if Stage.time >=35 then
			Stage.time = Stage.time - 1
			Stage.reducetime = Stage.reducetime + 1
			SendToAllClient("tzj_enemy_interval_reduce_return",{time=Stage.time,reduce=Stage.reducetime})
		else
			--返回不能再减了
			SendToAllClient("tzj_enemy_interval_reduce_return",{max=true})
		end
	end
end

function reducebosstime(_,data )
	if Stage.gameFinished then
		return
	end
	local pid = data.PlayerID
	if pid == 0 then
		if Stage.bosscountdown >=50 then
			Stage.bosscountdown = Stage.bosscountdown - 1
			Stage.reducebosstime = Stage.reducebosstime + 1
			SendToAllClient("tzj_enemy_interval_reduce_boss_return",{time=Stage.bosscountdown,reduce=Stage.reducebosstime})
		else
			--返回不能再减了
			SendToAllClient("tzj_enemy_interval_reduce_boss_return",{max=true})
		end
	end
end

function reduceEnemyTimeInit(_,data)
	
	if PlayerUtil.IsValidPlayer(data.PlayerID) then
		SendToClient(data.PlayerID,"tzj_enemy_interval_init",{boss={time=Stage.bosscountdown,reduce=Stage.reducebosstime},enemy={time=Stage.time,reduce=Stage.reducetime}})
	end
end


function UI_ExecuteCourierAbility(_,keys)
	if Stage.gameFinished then
		return
	end

	local PlayerID = keys.PlayerID
	if PlayerUtil.IsValidPlayer(PlayerID) then
		local hero = PlayerUtil.GetHero(PlayerID)
		if hero._courier and EntityIsAlive(hero) then
			local ability = hero._courier:FindAbilityByName(keys.ability)
			if ability then
				hero._courier:CastAbilityImmediately(ability,PlayerID)
			end
		end
	end
end

---UI事件
CustomGameEventManager:RegisterListener("playerbuyitem",playerbuyitem)
CustomGameEventManager:RegisterListener("ui_event_UI_SellItem",UI_SellItem)
CustomGameEventManager:RegisterListener("ui_event_backpack_menu_drop_item",UI_BackpackMenuDropItem)
CustomGameEventManager:RegisterListener("ui_event_backpack_menu_sell_item",UI_BackpackMenuSellItem)
CustomGameEventManager:RegisterListener("tzj_treasure_selection_confirm",UI_SelectTreasure)
CustomGameEventManager:RegisterListener("tzj_treasure_selection_close",UI_CloseTreasureSelection)
CustomGameEventManager:RegisterListener("tzj_execute_courier_ability",UI_ExecuteCourierAbility)
CustomGameEventManager:RegisterListener("tzj_enemy_interval_reduce",reducesgtime)
CustomGameEventManager:RegisterListener("tzj_enemy_interval_reduce_boss",reducebosstime)
CustomGameEventManager:RegisterListener("tzj_enemy_interval_init",reduceEnemyTimeInit)


---lua modifiers
LinkLuaModifier( "modifier_bw_1_1", "lua_modifiers/baowu/modifier_bw_1_1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_1_2", "lua_modifiers/baowu/modifier_bw_1_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_1_3", "lua_modifiers/baowu/modifier_bw_1_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_1_4", "lua_modifiers/baowu/modifier_bw_1_4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_1_5", "lua_modifiers/baowu/modifier_bw_1_5", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_1_6", "lua_modifiers/baowu/modifier_bw_1_6", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_1_7", "lua_modifiers/baowu/modifier_bw_1_7", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_1_8", "lua_modifiers/baowu/modifier_bw_1_8", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_1_9", "lua_modifiers/baowu/modifier_bw_1_9", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_1_10", "lua_modifiers/baowu/modifier_bw_1_10", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_1_11", "lua_modifiers/baowu/modifier_bw_1_11", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_1_12", "lua_modifiers/baowu/modifier_bw_1_12", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_1_13", "lua_modifiers/baowu/modifier_bw_1_13", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_1_14", "lua_modifiers/baowu/modifier_bw_1_14", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_2_1", "lua_modifiers/baowu/modifier_bw_2_1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_2_2", "lua_modifiers/baowu/modifier_bw_2_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_2_3", "lua_modifiers/baowu/modifier_bw_2_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_2_4", "lua_modifiers/baowu/modifier_bw_2_4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_2_5", "lua_modifiers/baowu/modifier_bw_2_5", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_2_6", "lua_modifiers/baowu/modifier_bw_2_6", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_2_7", "lua_modifiers/baowu/modifier_bw_2_7", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_2_8", "lua_modifiers/baowu/modifier_bw_2_8", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_2_9", "lua_modifiers/baowu/modifier_bw_2_9", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_2_10", "lua_modifiers/baowu/modifier_bw_2_10", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_2_11", "lua_modifiers/baowu/modifier_bw_2_11", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_2_12", "lua_modifiers/baowu/modifier_bw_2_12", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_2_13", "lua_modifiers/baowu/modifier_bw_2_13", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_2_14", "lua_modifiers/baowu/modifier_bw_2_14", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_2_15", "lua_modifiers/baowu/modifier_bw_2_15", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_2_16", "lua_modifiers/baowu/modifier_bw_2_16", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_2_17", "lua_modifiers/baowu/modifier_bw_2_17", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_2_18", "lua_modifiers/baowu/modifier_bw_2_18", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_2_19", "lua_modifiers/baowu/modifier_bw_2_19", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_2_20", "lua_modifiers/baowu/modifier_bw_2_20", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_2_21", "lua_modifiers/baowu/modifier_bw_2_21", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_2_22", "lua_modifiers/baowu/modifier_bw_2_22", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_2_23", "lua_modifiers/baowu/modifier_bw_2_23", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_2_24", "lua_modifiers/baowu/modifier_bw_2_24", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_2_25", "lua_modifiers/baowu/modifier_bw_2_25", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_2_26", "lua_modifiers/baowu/modifier_bw_2_26", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_2_27", "lua_modifiers/baowu/modifier_bw_2_27", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_3_1", "lua_modifiers/baowu/modifier_bw_3_1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_3_2", "lua_modifiers/baowu/modifier_bw_3_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_3_3", "lua_modifiers/baowu/modifier_bw_3_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_3_4", "lua_modifiers/baowu/modifier_bw_3_4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_3_5", "lua_modifiers/baowu/modifier_bw_3_5", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_3_6", "lua_modifiers/baowu/modifier_bw_3_6", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_3_7", "lua_modifiers/baowu/modifier_bw_3_7", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_3_8", "lua_modifiers/baowu/modifier_bw_3_8", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_3_9", "lua_modifiers/baowu/modifier_bw_3_9", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_3_10", "lua_modifiers/baowu/modifier_bw_3_10", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_3_12", "lua_modifiers/baowu/modifier_bw_3_12", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_3_13", "lua_modifiers/baowu/modifier_bw_3_13", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_3_14", "lua_modifiers/baowu/modifier_bw_3_14", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_3_15", "lua_modifiers/baowu/modifier_bw_3_15", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_3_16", "lua_modifiers/baowu/modifier_bw_3_16", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_3_17", "lua_modifiers/baowu/modifier_bw_3_17", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_3_18", "lua_modifiers/baowu/modifier_bw_3_18", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_3_19", "lua_modifiers/baowu/modifier_bw_3_19", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_3_20", "lua_modifiers/baowu/modifier_bw_3_20", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_3_21", "lua_modifiers/baowu/modifier_bw_3_21", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_3_22", "lua_modifiers/baowu/modifier_bw_3_22", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_3_23", "lua_modifiers/baowu/modifier_bw_3_23", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_4_1", "lua_modifiers/baowu/modifier_bw_4_1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_4_2", "lua_modifiers/baowu/modifier_bw_4_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_4_3", "lua_modifiers/baowu/modifier_bw_4_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_4_4", "lua_modifiers/baowu/modifier_bw_4_4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_4_5", "lua_modifiers/baowu/modifier_bw_4_5", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_4_6", "lua_modifiers/baowu/modifier_bw_4_6", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_4_7", "lua_modifiers/baowu/modifier_bw_4_7", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_4_8", "lua_modifiers/baowu/modifier_bw_4_8", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_bw_5_1", "lua_modifiers/baowu/modifier_bw_5_1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_5_2", "lua_modifiers/baowu/modifier_bw_5_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_5_3", "lua_modifiers/baowu/modifier_bw_5_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_5_4", "lua_modifiers/baowu/modifier_bw_5_4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_5_5", "lua_modifiers/baowu/modifier_bw_5_5", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_5_6", "lua_modifiers/baowu/modifier_bw_5_6", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_5_7", "lua_modifiers/baowu/modifier_bw_5_7", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_5_8", "lua_modifiers/baowu/modifier_bw_5_8", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_5_9", "lua_modifiers/baowu/modifier_bw_5_9", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_5_10", "lua_modifiers/baowu/modifier_bw_5_10", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_5_11", "lua_modifiers/baowu/modifier_bw_5_11", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_bw_all_11", "lua_modifiers/baowu/modifier_bw_all_11", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_10", "lua_modifiers/baowu/modifier_bw_all_10", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_9", "lua_modifiers/baowu/modifier_bw_all_9", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_8", "lua_modifiers/baowu/modifier_bw_all_8", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_7", "lua_modifiers/baowu/modifier_bw_all_7", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_6", "lua_modifiers/baowu/modifier_bw_all_6", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_5", "lua_modifiers/baowu/modifier_bw_all_5", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_4", "lua_modifiers/baowu/modifier_bw_all_4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_3", "lua_modifiers/baowu/modifier_bw_all_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_2", "lua_modifiers/baowu/modifier_bw_all_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_1", "lua_modifiers/baowu/modifier_bw_all_1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_12", "lua_modifiers/baowu/modifier_bw_all_12", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_13", "lua_modifiers/baowu/modifier_bw_all_13", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_14", "lua_modifiers/baowu/modifier_bw_all_14", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_15", "lua_modifiers/baowu/modifier_bw_all_15", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_16", "lua_modifiers/baowu/modifier_bw_all_16", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_17", "lua_modifiers/baowu/modifier_bw_all_17", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_18", "lua_modifiers/baowu/modifier_bw_all_18", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_19", "lua_modifiers/baowu/modifier_bw_all_19", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_20", "lua_modifiers/baowu/modifier_bw_all_20", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_21", "lua_modifiers/baowu/modifier_bw_all_21", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_22", "lua_modifiers/baowu/modifier_bw_all_22", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_23", "lua_modifiers/baowu/modifier_bw_all_23", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_24", "lua_modifiers/baowu/modifier_bw_all_24", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_25", "lua_modifiers/baowu/modifier_bw_all_25", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_26", "lua_modifiers/baowu/modifier_bw_all_26", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_27", "lua_modifiers/baowu/modifier_bw_all_27", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_28", "lua_modifiers/baowu/modifier_bw_all_28", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_29", "lua_modifiers/baowu/modifier_bw_all_29", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_30", "lua_modifiers/baowu/modifier_bw_all_30", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_31", "lua_modifiers/baowu/modifier_bw_all_31", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_32", "lua_modifiers/baowu/modifier_bw_all_32", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_33", "lua_modifiers/baowu/modifier_bw_all_33", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_34", "lua_modifiers/baowu/modifier_bw_all_34", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_35", "lua_modifiers/baowu/modifier_bw_all_35", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_36", "lua_modifiers/baowu/modifier_bw_all_36", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_37", "lua_modifiers/baowu/modifier_bw_all_37", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_38", "lua_modifiers/baowu/modifier_bw_all_38", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_39", "lua_modifiers/baowu/modifier_bw_all_39", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_40", "lua_modifiers/baowu/modifier_bw_all_40", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_41", "lua_modifiers/baowu/modifier_bw_all_41", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_42", "lua_modifiers/baowu/modifier_bw_all_42", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_43", "lua_modifiers/baowu/modifier_bw_all_43", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_44", "lua_modifiers/baowu/modifier_bw_all_44", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_45", "lua_modifiers/baowu/modifier_bw_all_45", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_46", "lua_modifiers/baowu/modifier_bw_all_46", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_47", "lua_modifiers/baowu/modifier_bw_all_47", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_48", "lua_modifiers/baowu/modifier_bw_all_48", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_49", "lua_modifiers/baowu/modifier_bw_all_49", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_50", "lua_modifiers/baowu/modifier_bw_all_50", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_51", "lua_modifiers/baowu/modifier_bw_all_51", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_52", "lua_modifiers/baowu/modifier_bw_all_52", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_53", "lua_modifiers/baowu/modifier_bw_all_53", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_54", "lua_modifiers/baowu/modifier_bw_all_54", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_55", "lua_modifiers/baowu/modifier_bw_all_55", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_56", "lua_modifiers/baowu/modifier_bw_all_56", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_57", "lua_modifiers/baowu/modifier_bw_all_57", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_58", "lua_modifiers/baowu/modifier_bw_all_58", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_59", "lua_modifiers/baowu/modifier_bw_all_59", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_60", "lua_modifiers/baowu/modifier_bw_all_60", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_61", "lua_modifiers/baowu/modifier_bw_all_61", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_62", "lua_modifiers/baowu/modifier_bw_all_62", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_63", "lua_modifiers/baowu/modifier_bw_all_63", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_64", "lua_modifiers/baowu/modifier_bw_all_64", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_65", "lua_modifiers/baowu/modifier_bw_all_65", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_66", "lua_modifiers/baowu/modifier_bw_all_66", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_67", "lua_modifiers/baowu/modifier_bw_all_67", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_68", "lua_modifiers/baowu/modifier_bw_all_68", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_69", "lua_modifiers/baowu/modifier_bw_all_69", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_70", "lua_modifiers/baowu/modifier_bw_all_70", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_71", "lua_modifiers/baowu/modifier_bw_all_71", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_72", "lua_modifiers/baowu/modifier_bw_all_72", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_73", "lua_modifiers/baowu/modifier_bw_all_73", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_74", "lua_modifiers/baowu/modifier_bw_all_74", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_75", "lua_modifiers/baowu/modifier_bw_all_75", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_76", "lua_modifiers/baowu/modifier_bw_all_76", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_77", "lua_modifiers/baowu/modifier_bw_all_77", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_78", "lua_modifiers/baowu/modifier_bw_all_78", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_79", "lua_modifiers/baowu/modifier_bw_all_79", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_80", "lua_modifiers/baowu/modifier_bw_all_80", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_81", "lua_modifiers/baowu/modifier_bw_all_81", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_82", "lua_modifiers/baowu/modifier_bw_all_82", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_83", "lua_modifiers/baowu/modifier_bw_all_83", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_84", "lua_modifiers/baowu/modifier_bw_all_84", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_85", "lua_modifiers/baowu/modifier_bw_all_85", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_86", "lua_modifiers/baowu/modifier_bw_all_86", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_87", "lua_modifiers/baowu/modifier_bw_all_87", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_88", "lua_modifiers/baowu/modifier_bw_all_88", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_89", "lua_modifiers/baowu/modifier_bw_all_89", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_90", "lua_modifiers/baowu/modifier_bw_all_90", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_91", "lua_modifiers/baowu/modifier_bw_all_91", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_92", "lua_modifiers/baowu/modifier_bw_all_92", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_93", "lua_modifiers/baowu/modifier_bw_all_93", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_94", "lua_modifiers/baowu/modifier_bw_all_94", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_95", "lua_modifiers/baowu/modifier_bw_all_95", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_96", "lua_modifiers/baowu/modifier_bw_all_96", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_97", "lua_modifiers/baowu/modifier_bw_all_97", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_98", "lua_modifiers/baowu/modifier_bw_all_98", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_99", "lua_modifiers/baowu/modifier_bw_all_99", LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier( "modifier_bw_all_100", "lua_modifiers/baowu/modifier_bw_all_100", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bw_all_101", "lua_modifiers/baowu/modifier_bw_all_101", LUA_MODIFIER_MOTION_NONE )


LinkLuaModifier( "modifier_countdown", "lua_modifiers/creature/modifier_countdown", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "zlyx_as", "yxtf/zlyx_as", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "llyx_sx", "yxtf/llyx_sx", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "llyx_sx2", "yxtf/llyx_sx2", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "yxtfjn_hn", "yxtf/yxtfjn_hn", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "yxtfjn_zs", "yxtf/yxtfjn_zs", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "yxtfjn_lxk", "yxtf/yxtfjn_lxk", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "yxtfjn_mjssz", "yxtf/yxtfjn_mjssz", LUA_MODIFIER_MOTION_NONE )


LinkLuaModifier( "modifier_cw_1_1", "lua_modifiers/chongwu/modifier_cw_1_1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_cw_1_2", "lua_modifiers/chongwu/modifier_cw_1_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_cw_1_3", "lua_modifiers/chongwu/modifier_cw_1_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_cw_2_1", "lua_modifiers/chongwu/modifier_cw_2_1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_cw_2_2", "lua_modifiers/chongwu/modifier_cw_2_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_cw_2_3", "lua_modifiers/chongwu/modifier_cw_2_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_cw_3_11", "lua_modifiers/chongwu/modifier_cw_3_11", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_cw_4_22", "lua_modifiers/chongwu/modifier_cw_4_22", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_cw_5_22", "lua_modifiers/chongwu/modifier_cw_5_22", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_cw_6_22", "lua_modifiers/chongwu/modifier_cw_6_22", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_cw_1_101", "lua_modifiers/chongwu/modifier_cw_1_101", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_cw_1_201", "lua_modifiers/chongwu/modifier_cw_1_201", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_cw_2_101", "lua_modifiers/chongwu/modifier_cw_2_101", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_cw_2_201", "lua_modifiers/chongwu/modifier_cw_2_201", LUA_MODIFIER_MOTION_NONE )



LinkLuaModifier( "modifier_ch_1_1", "lua_modifiers/chenghao/modifier_ch_1_1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ch_1_2", "lua_modifiers/chenghao/modifier_ch_1_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ch_1_3", "lua_modifiers/chenghao/modifier_ch_1_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ch_1_4", "lua_modifiers/chenghao/modifier_ch_1_4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ch_2_13", "lua_modifiers/chenghao/modifier_ch_2_13", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ch_3_13", "lua_modifiers/chenghao/modifier_ch_3_13", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ch_4_13", "lua_modifiers/chenghao/modifier_ch_4_13", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ch_2_14", "lua_modifiers/chenghao/modifier_ch_2_14", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ch_3_14", "lua_modifiers/chenghao/modifier_ch_3_14", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ch_4_14", "lua_modifiers/chenghao/modifier_ch_4_14", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_ch_1_101", "lua_modifiers/chenghao/modifier_ch_1_101", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ch_1_201", "lua_modifiers/chenghao/modifier_ch_1_201", LUA_MODIFIER_MOTION_NONE )


LinkLuaModifier( "modifier_gh_1_1", "lua_modifiers/guanghuan/modifier_gh_1_1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gh_1_2", "lua_modifiers/guanghuan/modifier_gh_1_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gh_1_3", "lua_modifiers/guanghuan/modifier_gh_1_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gh_1_4", "lua_modifiers/guanghuan/modifier_gh_1_4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gh_2_1", "lua_modifiers/guanghuan/modifier_gh_2_1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gh_2_2", "lua_modifiers/guanghuan/modifier_gh_2_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gh_2_3", "lua_modifiers/guanghuan/modifier_gh_2_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gh_2_4", "lua_modifiers/guanghuan/modifier_gh_2_4", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_gh_1_101", "lua_modifiers/guanghuan/modifier_gh_1_101", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_gh_1_201", "lua_modifiers/guanghuan/modifier_gh_1_201", LUA_MODIFIER_MOTION_NONE )




LinkLuaModifier( "modifier_yj_1_1", "lua_modifiers/yaoji/modifier_yj_1_1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_yj_1_2", "lua_modifiers/yaoji/modifier_yj_1_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_yj_1_3", "lua_modifiers/yaoji/modifier_yj_1_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_yj_1_4", "lua_modifiers/yaoji/modifier_yj_1_4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_yj_1_5", "lua_modifiers/yaoji/modifier_yj_1_5", LUA_MODIFIER_MOTION_NONE )


LinkLuaModifier( "item_sqts_gjl", "lua_items/sq_item/item_sqts_gjl", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "item_sqts_gjsd", "lua_items/sq_item/item_sqts_gjsd", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "item_sqts_jnsh", "lua_items/sq_item/item_sqts_jnsh", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "item_sqts_lqsj", "lua_items/sq_item/item_sqts_lqsj", LUA_MODIFIER_MOTION_NONE )