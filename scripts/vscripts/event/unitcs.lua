LinkLuaModifier( "modifier_no_health_bar", "lua_modifiers/modifier_no_health_bar", LUA_MODIFIER_MOTION_NONE )
--NPC刷新（产生对应实体）的时候刷新，每次刷新都会调用
local m = {}
---存储在nettable中的拥有自定义血条的单位，key是单位id，value是单位id代表存在，nil代表不存在
local healthBarUnits = {}

m.first = 0
---npc刷新事件(包括英雄刷新)
--keys:{
--	entindex: (number)
--	splitscreenplayer: (number)
--}
m.fhd={
	"player1";
	"player2";
	"player3";
	"player4";
}
function m:OnNPCSpawned(keys)
	local unit = EntIndexToHScript(keys.entindex)
	local PlayerID = unit:GetPlayerOwnerID();
	
	--添加视野buff，否则敌方单位看不到，就不会攻击了，而且这个buff死亡会消失，所以每次都要添加
	if unit:GetTeamNumber() == TEAM_PLAYER then
		AddLuaModifier(unit,unit,"modifier_provide_vision",{})
	end
	
	UnitKV.AddActivityModifier(unit)
	
	if unit:IsRealHero() and unit.bFirstSpawned == nil then
		unit.bFirstSpawned = true
		m.OnHeroInGame(unit,PlayerID)
		Shopmall:SetHerodata( unit)
		Backpack(unit)
		Netbackpack(unit)
		Sachievement(unit)
	end
	if unit:IsRealHero() and unit.deathtreasures then --复活后添加宝物
		
		for k, v in pairs(unit.deathtreasures) do
			local pz = true
			UI_SelectTreasure(nil,{PlayerID=PlayerID,ab_name=v},pz)
		end
		unit.deathtreasures=nil
	end
	--英雄和作为英雄（boss，精英怪之类的）的，去掉默认的血条，添加自定义的
	if (unit:IsHero() or unit:IsConsideredHero()) and not unit._CreatedHealthBar then
		unit._CreatedHealthBar = true;
		AddLuaModifier(unit,unit,"modifier_no_health_bar",{})
		m.CreateHealthBar(keys.entindex)
	end
end

function m.CreateHealthBar(unitIndex)
	if not unitIndex then
		return;
	end
	healthBarUnits[unitIndex] = unitIndex
	SetNetTableValue("UnitAttributes","health_bar_index",healthBarUnits,true)
end

---清除掉nettable中的数据，节省空间
function m.RemoveHealthBar(unitIndex)
	if not unitIndex then
		return;
	end
	healthBarUnits[unitIndex] = nil
	SetNetTableValue("UnitAttributes","health_bar_index",healthBarUnits,true)
end

--在NPCSpawned事件的.响应中处理
--玩家(每个玩家都会调用)进入游戏，生成英雄时调用，用来初始化
--比如改变英雄初始金钱、属性、等级等等
function m.OnHeroInGame(hero,PlayerID)
	--初始化玩家资源，并缓存
	PlayerUtil.SetHero(PlayerID,hero)
	
	hero:AddNewModifier(hero,nil,"equilibrium_constant",{})
	--1代表力量英雄
	--2代表敏捷英雄
	--3代表智力英雄
	if EntityHelper.IsStrengthHero(hero) then
		if GetGameDifficulty() >35 then
			AddLuaModifier(hero,hero,"llyx_sx2",{})
		else
			AddLuaModifier(hero,hero,"llyx_sx",{})
		end
		hero.zsx=1
	elseif EntityHelper.IsAgilityHero(hero) then
		if hero:GetAttackCapability() == 1 then
			if GetGameDifficulty() >35 then
				AddLuaModifier(hero,hero,"llyx_sx2",{})
			else
				AddLuaModifier(hero,hero,"llyx_sx",{})
			end
		end
		hero.zsx=2
	else
		AddLuaModifier(hero,hero,"zlyx_as",{})
		hero.zsx=3
	end


 	local point= Entities:FindByName(nil,"player"..tostring(PlayerID+1)):GetAbsOrigin()
	TimerUtil.createTimerWithDelay(0.1,function()
		Teleport(hero,point)  --将英雄传送至复活点
	end)
	GameState.gameInProgress(hero,PlayerID) --开始加载英雄数据
	Stage.playernum = Stage.playernum + 1 --玩家数量+1
	table.insert(Stage.playeronline,PlayerID)
	TimerUtil.createTimerWithDelay(1,function()
		PlayerResource:SetCameraTarget( PlayerID, hero )--将镜头跟随英雄
		TimerUtil.createTimerWithDelay(0.5,function()
			PlayerResource:SetCameraTarget( PlayerID, nil )--取消镜头跟随
		end)
	end)

end




function m.initCustomAttribute(hero,point)


end






return m
