local m = {}
m.sgd = {
	"sg1",
	"sg2",
	"sg3",
	"sg4"
}

m.sgd = {
	"sg1",
	"sg2",
	"sg3",
	"sg4",
}

m.jygjn={
	"jyg_1";
	"jyg_2";
	"jyg_3";
	"jyg_4";
	"jyg_5";
	"jyg_6";
	"jyg_7";
	"jyg_8";
	"jyg_9";
	"jyg_10";
	"jyg_11";
	"jyg_12";
	"jyg_13";
	"jyg_14";
	"jyg_15";
	"jyg_16";
	"jyg_17";
	"jyg_18";

}


---进攻小怪刷新
--@param #string unitname 单位名称
--@param #table spawnEntity 刷怪点实体
--@param #number max 最大数量，默认1
--@param #number target 进攻点，1表示草庙村，2表示青云
--@param #number interval 刷怪间隔，默认1
--@param #number interval  当前波数
function m.spawnAttackEnemy(max,interval,wave)

	max = max or 1;
	interval = interval or 0.5;

	--记录已经刷新的怪物数量
	local spawnedCount=1
	TimerUtil.createTimer(function()
		if Stage.gameFinished then
			return;
		end
		spawnedCount=spawnedCount+1
		
		local leaved = {}
		
		for idx, PlayerID in pairs(Stage.playeronline) do
			if not PlayerUtil.IsPlayerLeaveGame(PlayerID) then
				local spawner=Entities:FindByName(nil,m.sgd[PlayerID+1])
				local p = spawner:GetAbsOrigin()
				local p2 = FindRandomPoint(p,1800)
				for ii=1,100 do
					if  CanFindPath(p,p2) then
						break;
					else
						p2 = FindRandomPoint(p,1800)
					end
				end
				sg(wave,p2,PlayerID+1)
			else
				local hero = PlayerUtil.GetHero(PlayerID)
				hero.leave = 1
				table.insert(leaved,idx)
			end
		end
		
		--移除已经离开的玩家的单位，并重新计算最大怪物存活数量
		if #leaved > 0 then
			for _, idx in pairs(leaved) do
				local leavePlayerID = table.remove(Stage.playeronline,idx)
				for kk,vv in pairs(Stage["player"..leavePlayerID]) do
					local unit = EntityHelper.findEntityByIndex(vv)
					UTIL_Remove(unit)
				end
				Stage["player"..leavePlayerID] = nil
				
				local total = 0
				for _, PlayerID in pairs(Stage.playeronline) do
					total = total + Stage.zdchs["zdchs"..PlayerID+1]
				end
				Stage.maxchs = total
			end
		end

		--判断是否刷够了总数
		if spawnedCount<max then
			return interval
		end
	end)
end


function sg(wave,p2,s )
	local difficulty =   GetGameDifficulty()
	local i = RandomInt(1,100)--5%的怪率刷出高级怪
	local i2 = RandomInt(1,100)--1.5%的怪率刷出精英怪
	local xz =math.ceil(Stage.wave*difficulty*0.1) --随着波数的增加，出现精英怪的概率也将提高
	if RollPercent(xz) then
		i2 = 1
	end
	local gjbs = 1 *Stage.gj*Stage["gj"..s]--攻击倍数
	local xlbs = 1 *Stage.xl*Stage["xl"..s]--血量倍数
	local fybs = 1 *Stage.fy*Stage["fy"..s]--防御倍数
	local jqbs = 1 *Stage.jq*Stage["jq"..s]--金钱奖励倍数
	local jybs = 1 *Stage.jy*Stage["jy"..s]--经验倍数
	local mxbs =1 --模型倍数
	if i2 <= Stage.jygchance  then  --精英怪出现的概率
		gjbs = gjbs*3
		xlbs = xlbs*5
		fybs = fybs*1.5
		jqbs = jqbs*4
		jybs = jybs*4
		mxbs = mxbs*1.25
	end
	local unitname
	if i <= Stage.gjgchance then 	--高级怪出现的概率
		unitname = GetRanomByWeight(Ygmz.attackUnits2, Ygmz.attackUnits2qz)
	else
		local r = RandomInt(1,#Ygmz.attackUnits)--普通怪
		unitname = Ygmz.attackUnits[r]
	end
	--创建单位
	local unit = CreateUnitByName(unitname, p2, false, nil, nil, TEAM_ENEMY)
	--if unit ~= nil then --存在该单位的时候刷新
	local hp = ma.hpxs[unitname]	--设置怪物的动态血量
	local maxhp = hp * ma.hp[wave]  *xlbs * ma.nd_hp[difficulty]  --怪物7倍血量
	if maxhp > 500000000 then   --如果boss血量超过5亿，就给加减伤
		unit.shjs = string.format("%.2f",maxhp / 500000000)
		maxhp = 500000000
	end
	unit:SetBaseMaxHealth(maxhp)

	local armor = ma.armorxs[unitname]	--设置怪物的动态护甲
	local maxarmor = armor * ma.armor[wave]  *fybs * ma.nd_hj[difficulty]
	unit:SetPhysicalArmorBaseValue(maxarmor)

	local mk = maxarmor*0.06/(1+maxarmor*0.06)*100    	--设置怪物的魔抗
	unit:SetBaseMagicalResistanceValue(mk)

	local attack = ma.attackxs[unitname]	--设置怪物的动态攻击
	local maxattack = attack * ma.attack[wave]  *1.5 *gjbs * ma.nd_gj[difficulty]--所有怪攻击太高，先削弱测试
	unit:SetBaseDamageMin(maxattack)
	unit:SetBaseDamageMax(maxattack)
	local gold =ma.goldxs[unitname]			--设置怪物的动态金钱奖励
	local maxgold = gold * ma.gold[wave]  *jqbs--先设置10倍金钱
	unit:SetMinimumGoldBounty(maxgold)
	unit:SetMaximumGoldBounty(maxgold)

	local xp = ma.xpxs[unitname]			--设置怪物的动态死亡经验奖励
	local maxxp = xp * ma.xp[wave] * 10 	*jybs		--先设置10倍经验
	unit:SetDeathXP(maxxp)

	local level = Stage.wave*3 	--设置怪物的等级
	unit:CreatureLevelUp(level)
	if mxbs ~=1 then
		local dx = unit:GetModelScale() *mxbs
		local rjn = RandomInt(1,#m.jygjn)		--给精英怪添加一个随机的技能
		unit:AddAbility(m.jygjn[rjn])
		local level2 = 1
		if difficulty<4 then
			level2 = math.ceil(difficulty/3)
		elseif difficulty<8 then
			level2 = math.ceil(difficulty/2.5)
		elseif difficulty<15 then
			level2 = math.ceil(difficulty/2)
		else
			level2 = math.ceil(difficulty/1.5)
		end
		unit:FindAbilityByName(m.jygjn[rjn]):SetLevel(level2)
		unit:SetModelScale(dx)
		unit:SetRenderColor(95,10,10)
		unit.isJY =1 --标记怪物为精英怪
		unit.getsds =5 --杀敌数为5倍
	end
	unit.isAttackEnemy = 1;
	--标记为玩家几的存活怪
	unit.playchs = s;
	--一个怪代表一个存活，boss另算
	unit.playchsl = 1;
	--对应的玩家怪物数量+1
	Stage.chs["chs"..s] = Stage.chs["chs"..s] + unit.playchsl
	--同步往服务器发怪物目前的数量
	local  nowchs = #Stage.kezhw
	for _, PlayerID in pairs(Stage.playeronline) do
		nowchs = nowchs + Stage.chs["chs"..PlayerID+1]
	end
	table.insert(Stage["player"..s-1],unit:GetEntityIndex())
	CustomGameEventManager:Send_ServerToAllClients("tzj_topbar_update_monster_count",{now=nowchs,max=Stage.maxchs})
	--当相位移动的modifier消失，系统会自动计算碰撞，这样就避免了卡位
	unit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
	--unit:AddNewModifier(nil, nil, "modifier_xiangwei", {duration=0.1})
	--local ability = unit:AddAbility("jineng_nandu_gaoji")
	--	ability:SetLevel(1);
	--end
end





---刷新进攻boss怪
--@param #string bossName boss单位名
--@param #int wave 第几个boss
function m.SpwanAttackBoss(bossName,wave)
	if not bossName then
		return;
	end
	for i=0,3 do
		if PlayerUtil.GetHero(i) ~=nil then  --
		local hero = PlayerUtil.GetHero(i)

		if hero:HasModifier("modifier_bw_all_47") then  --如果拥有勇气之心 则增加30%的基础全属性
			local baseStr = hero:GetBaseStrength() *1.3
			local baseAgi = hero:GetBaseAgility() *1.3
			local baseInt = hero:GetBaseIntellect() *1.3
			hero:SetBaseStrength(baseStr)
			hero:SetBaseAgility(baseAgi)
			hero:SetBaseIntellect(baseInt)
			hero:CalculateStatBonus(true)
		end

		if hero:HasModifier("modifiy_shopmall_cmzc_8") then  --如果拥有超魔专长BOSS杀手，则临时增加100%的基础主属性
			local temp={}
			temp["bfbtsqsx"] = 100
			AttributesSet(hero,temp)
			TimerUtil.createTimerWithDelay(180,function() 
				local temp={}
				temp["bfbtsqsx"] = -100
				AttributesSet(hero,temp)
		 	end)
			end
		end
	end
	local difficulty =   GetGameDifficulty()
	--创建单位
	--设置两倍血量，0.2的攻击力
	local p = Entities:FindByName(nil,"fyd1"):GetAbsOrigin()
	local boss = CreateUnitByName(bossName, p, false, nil, nil, TEAM_ENEMY)
	local hjxs = 1
	xpcall(function()
		local hp = ba.hpxs[bossName] 	--设置怪物的动态血量
		local maxhp = hp * ba.hp[wave]  * ma.nd_hp[difficulty]  * ma.bossrs_hp[Stage.playernum]  * ma.nd_hp2[difficulty]

		if maxhp > 500000000 then   --如果boss血量超过5亿，就给加减伤
			boss.shjs = string.format("%.2f",maxhp / 500000000)
			maxhp = 500000000
		end

		boss:SetBaseMaxHealth(maxhp)

		if difficulty >= 7 and wave >=2 then
			hjxs = hjxs + difficulty*0.03
			boss:AddAbility("zelz_qianghua"):SetLevel(difficulty-6)
		end
		local armor = ba.armorxs[bossName]	--设置怪物的动态护甲
		local maxarmor = armor * ba.armor[wave]  * ma.nd_hj[difficulty] * ma.bossrs_hj[Stage.playernum] * hjxs * ma.nd_hj2[difficulty]
		boss:SetPhysicalArmorBaseValue(maxarmor)


		local maxmk = maxarmor / armor * ba.mkxs[bossName]
		local mk = maxmk*0.06/(1+maxmk*0.06)*100    	--设置BOSS的魔抗
		boss:SetBaseMagicalResistanceValue(mk)

		local attack = ba.attackxs[bossName] * ma.nd_gj[difficulty]	 * ma.bossrs_gj[Stage.playernum]* ma.nd_gj2[difficulty]--设置怪物的动态攻击
		local maxattack = attack * ba.attackmax[wave]  --最大攻击力
		local minattack = attack * ba.attackmin[wave] --最小攻击力
		boss:SetBaseDamageMin(minattack)
		boss:SetBaseDamageMax(maxattack)


		local maxgold = ba.gold[wave]
		boss:SetMinimumGoldBounty(maxgold)
		boss:SetMaximumGoldBounty(maxgold)

		local maxxp = ba.xp[wave]
		boss:SetDeathXP(maxxp)

		local level = ba.level[wave] 	--设置怪物的等级
		boss:CreatureLevelUp(level)
		--标记为进攻怪
		boss.isboss = 1
		boss.isAttackBoss = 1;
		boss.getsds =100 --杀敌数为100倍
		boss.wave = wave
		--当相位移动的modifier消失，系统会自动计算碰撞，这样就避免了卡位
		boss:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})
	end,function(msg)
		DebugPrint(msg..'\n'..debug.traceback()..'\n')
	end)

	return boss;
end





---野外刷怪起始。
--@param #string spawnEntityName 刷怪点名称
--@param #string unitName 怪物名称
--@param #number interval 刷怪间隔
--@param #number minNum 最小单位数量，当少于这个数量的时候开始刷怪
--@param #number maxNum 最大单位数量，当超过这个数量的时候，停止刷怪
--@param #number radius 刷怪范围
--@param #boolean faceRandom 是否随机面向。一般boss类的不随机，普通单位随机
--@param #number stage 章节限制。从该章节开始不再刷怪，已经刷新的也都会被移除掉。
--@param #number respwanCheckRadius 刷新怪物的时候的检查范围，默认通过刷怪实体点的缓存怪物去检查数量。有些特殊地域需要屯怪，比如练功房，这个时候需要单独设置一个检查范围
function m.SpawnCreature(spawnEntityName,unitName,interval,minNum,maxNum,radius,faceRandom,stage,respwanCheckRadius)
	local ent_spawn =Entities:FindByName(nil,spawnEntityName)--通过名字寻找刷怪点实体
	if ent_spawn == nil then
		return;
	end
	TimerUtil.createTimer(function()
		if (stage and GetStage() >= stage) then --超过对应章节，则移除所有怪物
			m.RemoveUnits(ent_spawn)
			return nil;
		end
		m.SpawnUnits(unitName,ent_spawn,radius,minNum,maxNum,faceRandom,respwanCheckRadius)
		return interval
	end)

end

---游戏结束，移除所有玩家的敌方单位
function m.DeletePlayerUnits()
	if Stage.gameFinished then
		for k,v in pairs(Stage.playeronline) do
			local units = Stage["player"..v]
			if units then
				for kk,vv in pairs(units) do
					local unit = EntityHelper.findEntityByIndex(vv)
					UTIL_Remove(unit)
				end
			end
		end
	end
end

return m;
