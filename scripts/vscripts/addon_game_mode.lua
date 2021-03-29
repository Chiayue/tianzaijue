-- Generated from template
require("common")
require("ui.backpack")
require("ui.netbackpack")
require 'libraries/notifications'
--第三方lib
LibRegister = require("libraries.reg.LibRegister")
--加载自定义属性
require("modules.reg.register")
--载入UI
require("ui.ui")
require("ui.spawnsystem")
require("event.event_ui")
require("lua_items.itemequip")
require( "event.Itembaolv" )
require( "ui/mission")
require("ui.Sachievement")
require("ui.shopmall")
require("ui.invite")
require("ui.lottery")
require("ui.invite_config")
BossChallenge = require("ui.boss_challenge")
--require("abilities.modifiers.modifier_wyzd_wd")

--游戏流程
CustomSystemRegister = require("youxiliucheng.reg.CustomSystemRegister")

--各种事件的处理
EventHandlerRegister = require('event.reg.EventHandlerRegister')

--全局设置
GlobalConfigRegister = require("global.reg.GlobalConfigRegister")

--各种事件
GlobalConfigRegister = require("utils.reg.UtilRegister")


require("server.reg.register")
--注
_G.Playerlist={}
if PlagueLand == nil then
	PlagueLand = class({})
	_G.PlagueLand = PlagueLand
end


--预载入单位，英雄，技能，物品的数据
function PrecacheEveryThingFromKV( context )
	local kv_files = {"scripts/npc/npc_units_custom.txt","scripts/npc/npc_abilities_custom.txt","scripts/npc/npc_heroes_custom.txt","scripts/npc/npc_abilities_override.txt","npc_items_custom.txt"}
	for _, kv in pairs(kv_files) do
		local kvs = LoadKeyValues(kv)
		if kvs then
			--print("BEGIN TO PRECACHE RESOURCE FROM: ", kv)
			PrecacheEverythingFromTable( context, kvs)
		end
	end
    
    PrecacheResource( "particle", "particles/basic_boss/ab_line/range_finder_cone.vpcf", context ) 
	PrecacheResource( "particle", "particles/add_custom/boss_warning/aoe_warning.vpcf", context ) 
	PrecacheResource( "particle", "particles/econ/items/brewmaster/brewmaster_offhand_elixir/brewmaster_thunder_clap_elixir.vpcf", context ) 
	PrecacheResource( "particle", "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf", context ) 
	PrecacheResource( "particle", "particles/units/heroes/hero_sven/sven_loadout.vpcf", context ) 

	PrecacheResource( "particle", "particles/item_quality/item_quality_lv1.vpcf", context ) 
	PrecacheResource( "particle", "particles/item_quality/item_quality_lv2.vpcf", context ) 
	PrecacheResource( "particle", "particles/item_quality/item_quality_lv3.vpcf", context ) 
	PrecacheResource( "particle", "particles/item_quality/item_quality_lv4.vpcf", context ) 
	PrecacheResource( "particle", "particles/item_quality/item_quality_lv5.vpcf", context ) 
	PrecacheResource( "particle", "particles/item_quality/item_quality_lv6.vpcf", context ) 
	PrecacheResource( "particle", "particles/item_quality/item_quality_lv7.vpcf", context ) 

	PrecacheResource( "particle", "particles/items4_fx/spirit_vessel_heal.vpcf", context ) 
	PrecacheResource( "particle", "particles/items4_fx/spirit_vessel_damage.vpcf", context ) 
	PrecacheResource( "particle", "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", context ) 
	PrecacheResource( "particle", "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf", context ) 
	PrecacheResource( "particle", "particles/items4_fx/bull_whip.vpcf", context ) 
	PrecacheResource( "particle", "particles/econ/items/storm_spirit/strom_spirit_ti8/storm_sprit_ti8_overload_discharge.vpcf", context ) 
	PrecacheResource( "particle", "particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf", context ) 

	PrecacheResource( "particle", "particles/econ/items/morphling/morphling_ethereal/morphling_adaptive_strike_ethereal.vpcf", context ) 
	PrecacheResource( "particle", "particles/econ/items/luna/luna_lucent_ti5_gold/luna_eclipse_impact_notarget_moonfall_gold.vpcf", context ) 
	PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", context ) 
	PrecacheResource( "particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_area.vpcf", context ) 
	PrecacheResource( "particle", "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf", context ) 
	PrecacheResource( "particle", "particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf", context ) 
	PrecacheResource( "particle", "particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf", context ) 
	PrecacheResource( "particle", "particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf", context ) 
	PrecacheResource( "particle", "particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf", context ) 
	PrecacheResource( "particle", "particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf", context ) 
	PrecacheResource( "particle", "particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf", context ) 
	PrecacheResource( "particle", "particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf", context ) 
	PrecacheResource( "particle", "particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf", context ) 
	PrecacheResource( "particle", "particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf", context ) 
	PrecacheResource( "particle", "particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf", context ) 
	PrecacheResource( "particle", "particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf", context ) 





	PrecacheResource( "particle", "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_totem_cast_ti6_combined.vpcf", context ) 
	PrecacheResource( "particle", "particles/units/heroes/hero_lich/lich_ice_age_dmg.vpcf", context ) 
	
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_witchdoctor.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_sven.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_brewmaster.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_leshrac.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_invoker.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_lion.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_shredder.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_phantom_assassin.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_tiny.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_ursa.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_jakiro.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_techies.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_ogre_magi.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_obsidian_destroyer.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_pudge.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_stormspirit.vsndevts", context )
	PrecacheResource( "soundfile","soundevents/game_sounds_heroes/game_sounds_void_spirit.vsndevts", context )
	
end
--预载入特效，模型，音效
function PrecacheEverythingFromTable( context, kvtable)
	for key, value in pairs(kvtable) do
		if type(value) == "table" then
			PrecacheEverythingFromTable( context, value )
		else
			if string.find(value, "vpcf") then
				PrecacheResource( "particle",  value, context)
				--print("PRECACHE PARTICLE RESOURCE", value)
			end
			if string.find(value, "vmdl") then 	
				PrecacheResource( "model",  value, context)
				--print("PRECACHE MODEL RESOURCE", value)
			end
			if string.find(value, "vsndevts") then
				PrecacheResource( "soundfile",  value, context)
				--print("PRECACHE SOUND RESOURCE", value)
			end
		end
	end

   
end

function Precache( context )
	PrecacheEveryThingFromKV( context )
	PrecacheResource("particle_folder", "particles/buildinghelper", context)
	PrecacheUnitByNameSync("npc_dota_hero_tinker", context)
	PrecacheResource( "soundfile",  "soundevents/custom_sounds_ui.vsndevts", context)
	PrecacheResource( "soundfile",  "soundevents/custom_sounds_bgm.vsndevts", context)
	PrecacheResource( "soundfile","sounds/music/dsadowski_01/stingers/dire_win.vsnd", context )
	PrecacheResource( "soundfile","sounds/music/valve_ti5/stingers/radiant_lose.vsnd", context )
end

-- Create the game mode when we activate
--激活某些函数
function Activate()
	GameRules.AddonTemplate = PlagueLand()
	GameRules.AddonTemplate:InitGameMode()
	EventHandlerRegister.register(GameRules.AddonTemplate);

end

--用于游戏的初始化
function PlagueLand:InitGameMode()
	DebugPrint( "Template addon is loaded." )
	
	settings.ConfigGame();--设置游戏规则
	
	Filters.register(self)
	
	PlagueLand.playergold={}
	
	GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter(Dynamic_Wrap( PlagueLand, "AddedToInventoryFilter" ), self) --设置一个过滤器，物品添加的时候
	
	--仅开发模式使用
	if IsInToolsMode() then
		ListenToGameEvent("player_chat", Dynamic_Wrap(PlagueLand, "OnPlayerSay"), self)
	end
end

function PlagueLand:AddedToInventoryFilter(event )
	local unit=EntIndexToHScript(event.inventory_parent_entindex_const)
	local item=EntIndexToHScript(event.item_entindex_const)
	
	--不是自己的宝物，不能捡起来。即不能共享宝物
	if ItemManger.IsTreasureItem(item:GetAbilityName()) and item:GetPurchaser() and item:GetPurchaser() ~= unit then
		CreateItemOnGround(item,nil,unit:GetAbsOrigin(),100) 
		return false;
	end
	
	
	local nameArray = string.split(item:GetAbilityName(), "_");
	if #nameArray > 1 and nameArray[2]=="net" then 
		if item:GetPurchaser() and item:GetPurchaser()==unit then
			if not Netbackpack:AddItemImmediate(unit,item,-1,SrvNetEquip.source_drop) then
				CreateItemOnGround(item,nil,unit:GetAbsOrigin(),100)
			end
		else
			CreateItemOnGround(item,nil,unit:GetAbsOrigin(),100)  --不是自己的存储装备不能拾取
		end
		return false
	end
	--拾取自动使用的物品特殊处理，
	if item:IsCastOnPickup() then
		local noUse = GetAbilitySpecialValueByLevel(item,"not_pick_up_use")
		if item:GetContainer() and noUse ~= 1 then
			---地上捡起来的，就不往物品栏添加了。
			--由于物品设置了拾起使用后，掉落在地上，设置自动捡起来并且这里返回true的话，会触发两次默认的函数，
			--这里返回false，触发一次技能，但是又获取不到caster，所以这里在物品上索引一下单位信息，
			--在具体的调用函数里，先通过传入的caster去获取，如果获取不到的话，再尝试获取物品的_unit字段
			item._unit = unit;
			return false;
		else
			return true;
		end
	end
	
	if item:IsStackable() then
		local existItem = nil;
		local hasPos = false;
		for i=0,BackpackConfig.MaxBodyIndex do
			local slotItem = unit:GetItemInSlot(i);
			if slotItem then
				if item:GetAbilityName() == slotItem:GetAbilityName() then
					existItem = slotItem
					break;
				end	
			else
				hasPos = true
			end
		end
		
		if existItem then
			--修复无限叠加的物品的bug（当同时拥有自己的和别人的消耗品的时候，新增消耗品两者会同时叠加）
			existItem:SetCurrentCharges(existItem:GetCurrentCharges() + item:GetCurrentCharges())
			return false;
		elseif hasPos then
			return true
		elseif not Backpack:AddItemImmediate(unit,item,-1) then
			CreateItemOnGround(item,nil,unit:GetAbsOrigin(),100)
		end
	else
		for i=0,BackpackConfig.MaxBodyIndex do
			if unit:GetItemInSlot(i) == nil then
				return true
			end
		end
		if not Backpack:AddItemImmediate(unit,item,-1) then
			CreateItemOnGround(item,nil,unit:GetAbsOrigin(),100)
		end
	end
	
	return false
	
end

function PlagueLand:CorrectGold()
	EachPlayer(function(n, iPlayerID)
		local iGold = PlayerResource:GetGold(iPlayerID)
		
		if iGold > 0 then
			self:ModifyCustomGold(iPlayerID, iGold)
			PlayerUtil.ModifyGold(iPlayerID,-iGold)
		end
	end)
end
function PlagueLand:ModifyCustomGold(iPlayerID, Gold)
	
	if self.playergold[iPlayerID].nowgold+Gold >=0 then
		if Gold<0 then
			MisSion:SetCostGold(iPlayerID,-Gold)
			self.playergold[iPlayerID].costgold=self.playergold[iPlayerID].costgold+Gold
		else
			MisSion:SetGetGold(iPlayerID,Gold)
			--SendOverheadEventMessage(iPlayerID, 0, PlayerResource:GetSelectedHeroEntity( iPlayerID ), Gold, nil)
			self.playergold[iPlayerID].totalgold=self.playergold[iPlayerID].totalgold+Gold
		end
		self.playergold[iPlayerID].nowgold=self.playergold[iPlayerID].nowgold+Gold
		self:SetPlayerGold(iPlayerID)
		return true
	else
		return false
	end
end
function PlagueLand:GetNowGold(iPlayerID)
	return self.playergold[iPlayerID].nowgold
end
function PlagueLand:SetPlayerGold(iPlayerID)
	PlayerResource:SetLastBuybackTime(iPlayerID, self.playergold[iPlayerID].nowgold)
end
function PlagueLand:OnPlayerSay( keys )
	
	local player = PlayerResource:GetPlayer(keys.playerid)
	local hero = player:GetAssignedHero()
	local tokens =  string.pipei(string.trim(string.lower(keys.text)))

	
	if tokens[1] == "-dd" then
		if tokens[2]=="" then
			local sxxx=CreateUnitByName("npc_boss_02", hero:GetOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
			FindClearSpaceForUnit(sxxx,hero:GetOrigin(),true)
			
		else
			for i=1,1 do
			local sxxx=CreateUnitByName(tokens[2], hero:GetOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS )
			FindClearSpaceForUnit(sxxx,hero:GetOrigin(),true)
			--LinkLuaModifier( "modifier_bw_3_12", "lua_modifiers/baowu/modifier_bw_3_12", LUA_MODIFIER_MOTION_NONE )
			--sxxx:AddNewModifier(sxxx, nil, "modifier_bw_3_12", {})
			end
		end
		
	end
	if tokens[1] == "-cc" then
		NetItemDrop(hero)
		--local pack = Backpack:GetBackpack(hero)
		--for packIndex,index in pairs(pack) do
			
			--if index ~= -1 then
				--local packItem = EntIndexToHScript(index)
					--unit:AddItem(packItem)
				--local cc=CustomNetTables:GetTableValue("ItemsInfoShow",tostring(index) )
				--PrintTable(packItem.itemtype)
			--end
		--end
		
		--Shopmall:FinishQuestBatch("hero_killboss_4",1,1)
		--hero:FindModifierByName("item_0001_modifier"):ForceRefresh()
		--local addItem = CreateItem("item_"..tokens[2], nil, nil)
		--hero:AddItem(addItem)
	end
	if tokens[1] == "-tt" then
--		tzj_net_equip_enhance( "event",{item=7,PlayerID=0} )
--CustomGameEventManager:Send_ServerToPlayer(hero:GetPlayerOwner(),"tzj_net_equip_enhance_return",{open=11111111}) 
--Shopmall:AddJing(keys.playerid,9999999)
		for i=1,2 do
			NetItemDrop(hero)
		end
		
		--Lottery:RandomLottery(keys.playerid,200)
		Stage.PlayerWin()
		--hero:ForceKill(true)
		--modifier_invulnerable
		--SendToClient(keys.playerid,"tzj_net_equip_enhance_return",{success=false,error=2})
		--Netbackpack:EnhanceItem( hero, 8 )
		--for i=1,10 do
			--Lottery:RandomLottery(keys.playerid)
		--end
		--local names = {"item_smbw_1"}
		--local addItem = CreateItem(names[RandomInt(1,#names)], hero, hero)
		--hero:AddAbility("bingzhishijie"):SetLevel(1)
		--print(addItem:GetPurchaser():GetUnitName())
		--CreateItemOnGround(addItem,nil,hero:GetAbsOrigin(),100)
		--[[local arg2={[0]={day=false,week=true}}
		for k,v in pairs(arg2) do
			local cc=false
			for kk,vv in pairs(v) do
				print(vv)
				if vv~=true then
					cc=true
				end
			end
			if cc then
				print(3333333)
				local temp={}
                    temp[0]=arg2[0]
					PrintTable(temp)
			--Shopmall:InitQuestAgain(Shopmall.unit_quest[k],2)---初始化失败再重新初始化该玩家的任务，尝试2次 
			end
		end
]]
		--PrintTable(Sachievement:GetAchiState( hero))
		--Sachievement:SetAchiState( hero, "hero_single")
		--Sachievement:SetAchiState( hero,"hero_single")
		--local cc=Sachievement:GetAchiState( hero)
		--PrintTable()
		--PrintTable(cc)
		--local cc=CustomNetTables:GetTableValue("shopmall","playermall_data_"..keys.playerid )
		--PrintTable(cc)
		--Shopmall:FinishQuestBatch("hero_killboss_4",1,1)
		--print(Invite:IsSameList(keys.playerid))
		--Shopmall:FinishQuestBatch("hero_getboss_1",1,2)
	--	SrvDataMgr.GameFinished(true)
	--	Stage.gameFinished = true
		--print("Stage.gameFinished",Stage.gameFinished)
		--print(SrvAchv.GetHeroPassCount(hero:GetPlayerID(),hero:GetUnitName()))
		--SrvAchv.AddAchievement(hero:GetPlayerID(),"hero_single",1,hero:GetUnitName())
		--SrvAchv.AddAchievement(hero:GetPlayerID(),"hero_single",2,hero:GetUnitName())
		--SrvAchv.AddAchievement(hero:GetPlayerID(),"hero_single",3,hero:GetUnitName())
		--SrvAchv.AddAchievement(hero:GetPlayerID(),"hero_single",4,hero:GetUnitName())
		--SrvAchv.AddAchievement(hero:GetPlayerID(),"hero_single",5,hero:GetUnitName())
		--SrvAchv.AddAchievement(hero:GetPlayerID(),"difficulty",1,hero:GetUnitName())
		--SrvAchv.AddAchievement(hero:GetPlayerID(),"hidden",1,hero:GetUnitName())
		
	end
	if tokens[1] == "-gg" then
		--PrintTable(Shopmall:GetQuestNoFinish(keys.playerid))
		--print(222)
		--CustomGameEventManager:Send_ServerToPlayer(player,"ui_event_allhero_return",{allherolist=SpawnSystem.herolist})
		--local addItem = CreateItem("item_base_five_lua", nil, nil)
		--hero:AddItem(addItem)
		--for i=1,10 do
			--local addItem = CreateItem("item_zswq_2", nil, nil)
			--hero:AddItem(addItem)
		--end
	end
	
	if tokens[1] == "-pause" then
		PauseGame(not GameRules:IsGamePaused())
	end
	
	if tokens[1] == "-jing" then
		local count = tonumber(tokens[2])
		
		if count then
			SrvStore.AddJing(0,count,"1",function(success,count)
				if success then
					Shopmall:SetStone(0,nil,2,count)
				end
			end)
		end
	end
	

	
	if tokens[1] == "-gold" then
		local value = tonumber(tokens[2])
		if value then
			self:ModifyCustomGold(keys.playerid,value)
		end
		
	end
	
	if tokens[1] == "-citem" then
		local name = tokens[2]
		local count = tonumber(tokens[3]) or 1
		
		if name and count then
			for var=1, count do
				hero:AddItemByName(name)
			end
		end
	end
	
	if tokens[1] == "-sds" then
		local value = tonumber(tokens[2])
		if value then
			local netTable = hero.cas_table
			netTable["sds"] = netTable["sds"] + value
			SetNetTableValue("UnitAttributes",tostring(hero:entindex()),netTable)
		end
	end
	
	if tokens[1] == "-bosspoint" then
		local value = tonumber(tokens[2])
		if value then
			hero.bosspoint = (hero.bosspoint or 0) + value
			local unitKey = tostring(EntityHelper.getEntityIndex(hero))
		 	local netTable = hero.cas_table
		  	netTable["bosspoint"] = hero.bosspoint
		  	SetNetTableValue("UnitAttributes",unitKey,netTable)	
		end
	end
	
	if tokens[1] == "-bgm" then
		local value = tonumber(tokens[2])
		if value == 1 then
			bgm.PlaySurvivalBoss(false,1)
		elseif value == 2 then
			bgm.PlaySurvivalBoss(true,1)
		elseif value == 3 then
			bgm.PlaySurvivalBossPre()
		else
			bgm.PlayNormal(false,1)
		end
	end
	
end