
local m = {}
m.wjsx={
	"sjjll";
	"sjjmj";
	"sjjzl";
	"jyjc";
	"jqjc";
	"wlbjgl";
	"wlbjsh";
	"msmjq";
	"grjndj";
	"ggjndj";
	"jnsh";
	"fjsh";
	"zzsh";
	"shjm";
	"shhm";
	"nljszj";
	"nljszjbfb";
	"swfhsj";
	"sds";
	"bosspoint";
	"wlxx";
	"fsxx";
	"qjxx";
	"xyz";
	"sgzjjb";
	"zhwsh";
	"msmjsds";
	"bfbtsll";
	"bfbtsmj";
	"bfbtszl";
	"bfbtsqsx";
	"jnmjts";
	"dcsfcs"; --多重施法次数+1
	"zhwslbs";	--召唤物数量倍数
	"treasure";--宝物额外槽位
	"nlzx10";
	"nlzx11";
	"nlzx12";
	"nlzx13";
	"mfbjgl";
	"mfbjsh";
	"wlshts";
	"mfshts";
	"wlct";
	"mfct";
	"tmz";
	"tmz2";
	"tmz3";
	"yxtfdj";
	"tswsh";
	
}





---游戏开始，进入游戏准备阶段
function m.startGame()
	--60秒的准备时间,这个时间段英雄选择，出生，随机，
	--60秒结束后，关闭英雄随机系统，开始出怪

	m.preGame()
end

function m.preGame()
	--SetStage(1) --游戏阶段
	--显示准备时间

	--难度选择

	--	ZXJ_InitGame()
	TimerUtil.createTimerWithDelay(2,function()
		--QingYunHouShan.init()
		StageControl.PreGame()
	end)

end

function m.gameInProgress(hero,i)
	--准备阶段结束，统一给所有玩家的英雄单位添加 天赋效果，vip效果，存档效果

	hero.wqzb=hero:AddItemByName("item_zswq_1")  --给予的武器和防具要全程追踪，免得找不到
	hero.wq = 1 	--升级武器的时候做判断
	--hero.fjzb=hero:AddItemByName("item_fj_ty_1")
	--hero.fj = 1
	hero:AddItemByName("item_xhp_hfys_1")
	local point= EntityHelper.findEntityByName("courier_spawn"):GetAbsOrigin()
	local courier = CreateUnitByName("npc_xinshi", point, false, hero, hero, DOTA_TEAM_NOTEAM)--信使
	courier:AddNoDraw()
	hero._courier = courier
		

	hero.sjjll = 0		--初始每升一级增加的力量
	hero.sjjmj = 0		--初始每升一级增加的敏捷
	hero.sjjzl = 0		--初始每升一级增加的智力


	
	hero.jnmjts = 1     --技能秘籍提升
	hero.swfhsj = 7   	--死亡复活时间
	hero.shjm = 0		--初始的伤害减免百分比
	hero.shhm =0
	hero.zllzjbfb = 1	--初始的治疗量增加百分比
	hero.fsxx = 0		--初始的法术吸血
	hero.wlxx = 0		--初始的物理吸血
	hero.qjxx = 0		--初始的全局吸血
	hero.nljszj =0 		--初始的能量晶石增加属性
	hero.nljszjbfb = 1  --初始的能量晶石增加属性倍数
	hero.sds = 0       --初始英雄的杀敌数
	hero.xyz = 70      --初始英雄的幸运值
	hero.tmz = 0 	   --英雄的天命值，增加更高品质装备的掉落
	hero.tmz2 = 0 	   --英雄的天命值，增加更高品质装备的掉落
	hero.tmz3 = 0 	   --英雄的天命值，增加更高品质装备的掉落
	hero.bbtime=0      --不爆存档的次数
	hero.bfbtsll=0    	--百分比提升力量
	hero.bfbtsmj=0 		--百分比提升敏捷
	hero.bfbtszl=0 	  	--百分比提升智力
	hero.bfbtsqsx=0 	--百分比提升全属性	
	hero.tybosstime=1   
	hero.dcsfcs = 0
	hero.tswsh = 100  --投射物伤害
	hero.zhwslbs=1  --召唤物数量倍数
	PlayerUtil.setAttrByPlayer(i,"jnsds",0)	--技能书掉落点数（掉落技能书-1，点数为0的时候不会掉落技能书，每个回合开始+1）
	hero.jyjc = 0	--玩家的初始经验加成
	hero.jqjc = 0	--玩家的初始金钱加成
	hero.sgzjjb=0 	--玩家的初始杀怪+金币
	hero.msmjq=0   --每十秒增加钱
	hero.msmjsds=0   --每十秒增加杀敌数
	hero.wlbjgl = 0		--玩家的物理暴击概率
	hero.wlbjsh = 50	--玩家的魔法暴击伤害
	hero.mfbjgl = 0		--玩家的物理暴击概率
	hero.mfbjsh = 50	--玩家的魔法暴击伤害
	hero.wlshts = 0		--玩家的物理伤害提升
	hero.mfshts = 0		--玩家的魔法伤害提升
	hero.wlct = 0		--玩家的护甲穿透
	hero.mfct = 0		--玩家的魔法穿透
	hero.yxtfdj = 6 	--玩家可以提升的英雄等级上限
	hero.grjndj = 0	--玩家的初始个人技能等级
	hero.ggjndj = 0	--玩家的初始公共技能等级
	hero.jnsh = 0	--玩家的初始技能伤害
	hero.fjsh = 0	--玩家的初始附加伤害
	hero.zzsh = 0	--玩家的初始最终伤害
	hero.zhwsh = 0--玩家的初始召唤物伤害
	hero.jbboss =1	--玩家的召唤
	hero.bosspoint = 0	--玩家的BOSS点数
	hero.buybwnum= 0  --玩家通过商店购买宝物的次数
	hero.zh_ym= 0  --玩家通过商店购买宝物的次数
	hero.stonetime = 0 --命运石的使用次数
	hero.treasure = 0 --宝物的额外槽位
	hero.tscs = 0 --吞噬神器的次数
	hero.mys={}
	hero.nlzx10 = 0   --升级能量之心的凭证，不等于0就能升级
	hero.nlzx11 = 0
	hero.nlzx12 = 0
	hero.nlzx13 = 0
	hero.mys[3]=0 --各个品质命运石的使用次数，根据使用次数增加金币消耗
	hero.mys[4]=0
	hero.mys[5]=0
	hero.mys[6]=0

	local unitKey = tostring(EntityHelper.getEntityIndex(hero))

	if not hero.cas_table then
		hero.cas_table = {}
	end
	local netTable = hero.cas_table --服务端存储，避免使用getNetTable方法
	
	netTable._courier_ = courier:entindex()
	
	for key, sx in pairs(m.wjsx) do
		if  netTable[sx]  then
			netTable[sx] = netTable[sx] + hero[sx]
		else
			netTable[sx] = hero[sx]
		end
	end
	
	--赏金模式
	if GetGameDifficultyModel() == 6 then
		netTable["jqjc"] = netTable["jqjc"] + 100
	end
	
	SetNetTableValue("UnitAttributes",unitKey,netTable)

	--发送到客户端的数	据


	local item = {}
	item["item_xhp_mys_3"]=1000
	item["item_xhp_mys_4"]=5000
	item["item_xhp_mys_5"]=30000
	item["item_xhp_mys_6"]=90000
	item["item_xhp_tssq_1"]=1000000
	item["item_buy_bw_1"]={
		cost= 1,
		currency = 3
							}
	item["item_buy_sds_1"]={
		cost= 1,
		currency = 3
							}						
	 PlayerUtil.setAttrByPlayer(i,"itemtable",item)
	 SetNetTableValue("custom_shop","dynamic_cost_"..i,item)

	

	hero:GetAbilityByIndex(0):SetLevel(1)

	--添加闪烁技能  或许改成UI
	hero:AddAbility("ability_hero_2"):SetLevel(1)
	local empty_abilities = {
			'kjn_3',
			'kjn_4',
			'kjn_5',
		--'kjn_6',

	}

	for _, name in ipairs(empty_abilities) do
		hero:AddAbility(name):SetLevel(1)
	end
	local name = hero:GetAbilityByIndex(0):GetAbilityName()
	local name2 = hero:GetAbilityByIndex(1):GetAbilityName()
	local name3 = hero:GetAbilityByIndex(4):GetAbilityName()
	hero:SwapAbilities(name,name2,true,true)
	hero:SwapAbilities(name,name3,true,true)
	hero:AddAbility("hero_state_pro"):SetLevel(1)
	Stage.msmjq(hero) --开启每十秒加钱
	Stage.msmtbnettable(hero)
end


return m;
