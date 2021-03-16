HeroLevelUp = require("event.HeroLevelUp") --其他事件
--技能相关的事件处理
--local AbilityHandler = require("eventHandlers.AbilityHandler")
local PlayerConnectHandler = require("event.PlayerConnectHandler") --玩家连接或者断开的处理器
---单位死亡处理，主要是物品掉落，任务处理等<br/>
--通过调用其中的监听注册函数，添加特殊的处理逻辑
UnitDie = require("event.UnitDie")
GameSetup = require("event.GameSetup")
require("event.item_net") 
require("event.item_sq") 

local GameStateChange = require("event.GameStateChange") --游戏阶段改变
Itemjndl = require("event.Itemjndl") 
Ygmz = require("event.ygmz") 
Mj = require("event.mj_ability")
Mjdl = require("event.mjdl")
Itemptwp = require("event.itemptwp") 
ItemHandler = require("event.ItemHandler") 
Ibl=  require("event.Itembaolv")
UnitCs = require("event.UnitCs") 
TZ=  require("event.TaoZhuang") 
Tzboss= require("event.TzBoss") 

require("ability.item_remove_ability") 
local m = {};

--注册各种内置事件的处理器(具体查看workshopAPI)
function m.register(self)
	 ListenToGameEvent('entity_killed', Dynamic_Wrap(UnitDie, 'OnEntityKilled'), self)				--监听单位死亡

   	ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(HeroLevelUp, 'OnHeroLevelUp'), self)		--监听英雄升级
   	ListenToGameEvent('npc_spawned', Dynamic_Wrap(UnitCs, 'OnNPCSpawned'), self)		--监听英雄升级
    ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(GameStateChange, 'OnGameRulesStateChange'), self)
	
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(PlayerConnectHandler, 'OnConnectFull'), self)
	ListenToGameEvent('player_disconnect', Dynamic_Wrap(PlayerConnectHandler, 'OnDisconnect'), self)
	ListenToGameEvent("player_reconnected", Dynamic_Wrap(PlayerConnectHandler, 'OnPlayerReconnect'), self)--MOD事件中也有这一项，两个事件的传入参数不一样（具体查看API），不确定到底注册的是哪个
	
	 --监听UI事件,这是新的事件管理器
    
    CustomGameEventManager:RegisterListener( "tzj_attributes_delete_ability", RemoveAbility )
    CustomGameEventManager:RegisterListener( "tzj_attributes_move_ability", SwapAbility )
	CustomGameEventManager:RegisterListener( "tzj_attributes_open_netbox", OpenNetbox )
	CustomGameEventManager:RegisterListener( "tzj_ability_enhance", AbilityEnhance )
	InitNetTableData();
end

function InitNetTableData()
	--所有技能可能拥有的强化属性
	SetNetTableValue("config","ability_mj",Mj.jnct)
	
	--随机装备的属性范围，没做容错处理，假定配置都正确。一旦有错，再改动
	for attr, baseRanges in pairs(Rare_Pro_Value) do
		local levelData = {}
		
		for level, baseRange in pairs(baseRanges) do
			local qualityData = {}
			levelData[level] = qualityData
			
			for rare, data in pairs(Item_Rare) do
				local rareConfig = data.pro_value
				if #baseRange ~= 2 or #rareConfig ~= 2 then
					dumpTable({base=baseRange,rare=rareConfig},attr,tostring(level),rare)
				else
					--处理成字符串返回，避免在传输过程中精度丢失
					local min = ParseFloatToDecimal(baseRange[1] * rareConfig[1],2);
					local max = ParseFloatToDecimal(baseRange[2] * rareConfig[2],2);
					qualityData[string.gsub(rare,"rare_","")] = {min,max}
				end
			end
			
		end
		
		--每个属性单独一个key，否则会数据溢出
		SetNetTableValue("config","random_item_range_"..attr,levelData)
	end
	--装备名称中的类型缩写和属性定义中用的不一样，这一做一个小转换
	local map = {weapon="wq",clothes="fj",jewelry="ss",assistitem="ts"}
	for itemType,propValues in pairs(NetRare_Pro_Value) do
		local client_itemType = map[itemType]
		if client_itemType then
			for attr, baseRanges in pairs(propValues) do
				local levelData = {}
				
				for level, baseRange in pairs(baseRanges) do
					local qualityData = {}
					levelData[level] = qualityData
					
					for rare, data in pairs(NetItem_Rare) do
						local rareConfig = data.pro_value
						if #baseRange ~= 2 or #rareConfig ~= 2 then
							dumpTable({base=baseRange,rare=rareConfig},attr,tostring(level),rare)
						else
							--处理成字符串返回，避免在传输过程中精度丢失
							local min = ParseFloatToDecimal(baseRange[1] * rareConfig[1],2);
							local max = ParseFloatToDecimal(baseRange[2] * rareConfig[2],2);
							qualityData[string.gsub(rare,"rare_","")] = {min,max}
						end
					end
					
				end
				
				--每个属性单独一个key，否则会数据溢出
				SetNetTableValue("config","net_item_range_"..client_itemType.."_"..attr,levelData)
			end
		else
			DebugPrint("[InitNetTableData] can't find 'client_ItemType' for itemType:",itemType)
		end
	end
	
	--商城物品
	local data= Shopmall.list
    for k,item in pairs(data) do
        local temp={}
        temp.price_magic=item["price_magic"]
        temp.price_jing=item["price_jing"]
        temp.catalog1=item["catalog1"]
        temp.catalog2=item["catalog2"]
        temp.notSale= item["notSale"]
        
        --存档装备钥匙对应的位置
        if item.reward and item.reward.Set_item then
        	local setItem = item.reward.Set_item[1]
        	if setItem then
        		local array = Split(setItem,"_")
        		if #array > 2 then
        			temp.equip_slot = array[3]
        		end
        	end
        end
        
        CustomNetTables:SetTableValue("config",k,temp)
	end
end

return m;