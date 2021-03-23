--初始装备的下标为1

_G.NetTime =1
--每件装备的等级
_G.NetLevel={}
--每件装备的最低品质
_G.NetPz={}

--根据掉宝品质削减物品数量	
_G.Netdbsl={
	1;
	5;
	25;
	300;
	1200;
	10000;
}	

--晶石基础	
_G.Netpzjs={
	1;
	2;
	3;
	5;
	10;
	20;
	40;
}	
_G.Netdjjs={
	1;
	5,
	10,
	20,
	30,
	40,
	60,
	80,

}

--装备种类权重
_G.NetItem_Type={
	200,--武器
	200,--防具
	500,--首饰
	20,--特殊装备
}
_G.NetItem_Type2={
	200,--武器
	200,--防具
	300,--首饰
	50,--特殊装备
}
--装备主属性
_G.NetItem_Attribute={
	200,--武器
	200,--防具
	600,--首饰
	20,--特殊装备
}
_G.NetItem_Type_All={
	"ll",
	"mj",
	"zl",
	"ty",
}
--品质相关
--rare_1一阶
--weight 权重
--pro_value装备品阶词条数值区间
--rare_base_pro基础词条
--rare_spe_pro特殊词条
_G.NetItem_Rare={
	rare_1={
		weight=1,--品质权重		--之前是8W，先屏蔽出白色装备的    1
		pro_value={0.6,1},--品阶词条数值区间      
		rare_base_pro={100,0,0,0,0,0},--基础词条数目权重
		rare_spe_pro={0,0,0,0,0,0},--特殊词条
	},
	rare_2={
		weight=30000,--品质权重 
		pro_value={0.8,1.2},--品阶词条数值区间     				  2
		rare_base_pro={0,100,0,0,0,0},--基础词条 
		rare_spe_pro={0,0,0,0,0,0},--特殊词条
	},
	rare_3={
		weight=12000,--品质权重
		pro_value={1,1.4},--品阶词条数值区间 				     3-4	 
		rare_base_pro={0,0,100,0,0,0},--基础词条
		rare_spe_pro={100,0,0,0,0,0},--特殊词条
	},
	rare_4={
		weight=4000,--品质权重
		pro_value={1.2,1.6},--品阶词条数值区间				   	 5-6
		rare_base_pro={0,0,0,100,0,0},--基础词条
		rare_spe_pro={70,30,0,0,0,0},--特殊词条
	},
	rare_5={
		weight=300,--品质权重
		pro_value={1.5,1.8},--品阶词条数值区间 					 7-8
		rare_base_pro={0,0,0,0,100,0},--基础词条
		rare_spe_pro={0,70,30,0,0,0},--特殊词条
	},
	rare_6={
		weight=10,--品质权重
		pro_value={1.8,2.2},--品阶词条数值区间					9-10
		rare_base_pro={0,0,0,0,0,100},--基础词条
		rare_spe_pro={0,0,70,30,0,0},--特殊词条
	},
	rare_7={
		weight=1,--品质权重
		pro_value={2.2,3},--品阶词条数值区间					12
		rare_base_pro={0,0,0,0,0,100},--基础词条
		rare_spe_pro={0,0,0,0,0,100},--特殊词条
	},
}


--武器的基础词条属性权重]]
--base_pro--基础词条表
--spe_pro--特殊词条表
_G.NetItem_Pro_Weight={
	weapon={
		base_ll_pro={ --基础词条
			damage_bfb=100,			--攻击力百分比，绿字
			jnsh=100,				--技能伤害
			wlbjgl=20,				--物理暴击概率
			wlbjsh=20,				--物理暴击伤害
			fjsh=8,					--附加伤害
			zzsh=4,					--最终伤害	
		},

		base_mj_pro={ --力量基础词条
			damage_bfb=100,			--攻击力百分比，绿字
			attack_speed=100,		--攻击速度
			wlbjgl=20,				--物理暴击概率
			wlbjsh=20,				--物理暴击伤害
			fjsh=8,					--附加伤害
			zzsh=4,					--最终伤害	
		},

		base_zl_pro={ --力量基础词条
			jnsh=100,				--技能伤害
			mfhf=100,		        --魔法回复
			wlbjgl=20,				--物理暴击概率
			wlbjsh=20,				--物理暴击伤害
			fjsh=8,					--附加伤害
			zzsh=4,					--最终伤害	
		},

		base_ty_pro={ --基础词条
			damage_bfb=85,			--攻击力百分比，绿字
			attack_speed=85,		--攻击速度
			mfhf=85,		        --魔法回复
			jnsh=60,				--技能伤害
			wlbjgl=20,				--物理暴击概率
			wlbjsh=20,				--物理暴击伤害
			mfbjgl=20,				--魔法暴击概率
			mfbjsh=20,				--魔法暴击伤害
			wlshts=10,				--物理伤害提升
			mfshts=10,				--魔法伤害提升
			wlct=50,					--护甲穿透
			mfct=50,					--魔法穿透
			zhwsh=10,				--召唤物强度提升
			gjjl=10,				--攻击距离
			fjsh=8,					--附加伤害
			zzsh=4,					--最终伤害	
		},
		base_ty_pro2={ --基础词条
			damage_bfb=85,			--攻击力百分比，绿字
			attack_speed=85,		--攻击速度
			mfhf=85,		        --魔法回复
			jnsh=60,				--技能伤害
			wlbjgl=20,				--物理暴击概率
			wlbjsh=20,				--物理暴击伤害
			mfbjgl=20,				--魔法暴击概率
			mfbjsh=20,				--魔法暴击伤害
			wlshts=10,				--物理伤害提升
			mfshts=10,				--魔法伤害提升
			wlct=50,					--护甲穿透
			mfct=50,					--魔法穿透
			zhwsh=10,				--召唤物强度提升
			gjjl=10,				--攻击距离
			fjsh=8,					--附加伤害
			zzsh=4,					--最终伤害	
			tswsh=2,				--投射物伤害
		},
	
	},
	clothes={
		base_ty_pro={ --基础词条表
			bfbtssm=100,		--百分比提升生命值
			smzhfbfb=20,		--生命值百分比恢复
			hj=100,				--护甲
			mfkx=50,			--魔法抗性
			sb=50,				--闪避
			wlxx=10,			--物理吸血
			fsxx=10,			--法术吸血
			qjxx=5,			--全局吸血
			shjm=5,			--伤害减免
			shhm=2,			--伤害豁免
		},

		
	},
	jewelry={
		base_ll_pro={ --基础词条
			bfbtsll=100;	--百分比提升力量
			bfbtsqsx=30;	--百分比提升全属性
			jnsh=60;		--技能伤害
			bfbtssm=30;		--百分比提升生命值
			ydsd=10;		--移动速度	
		},
		base_mj_pro={ --基础词条
			bfbtsmj=100;	--百分比提升敏捷
			bfbtsqsx=30;	--百分比提升全属性
			attack_speed=60;--技能伤害
			bfbtssm=30;		--百分比提升生命值
			ydsd=10;		--移动速度	
		},
		base_zl_pro={ --基础词条
			bfbtszl=100;	--百分比提升智力
			bfbtsqsx=30;	--百分比提升全属性
			jnsh=60;		--技能伤害
			mfz=30;			--魔法值
			mfhf=10;		--魔法回复	
		},
		base_ty_pro={ --基础词条
			bfbtsll=100;	--百分比提升力量
			bfbtsmj=100;	--百分比提升敏捷
			bfbtszl=100;	--百分比提升智力
			bfbtsqsx=30;	--百分比提升全属性
			sjjll=30;		--升级加力量
			sjjmj=30;		--升级加敏捷
			sjjzl=30;		--升级加智力
			sjjqsx=10;		--升级加智力
			attack_speed=60;		--攻击速度
			jnsh=60;		--技能伤害
			bfbtssm=30;		--百分比提升生命值
			mfz=30;			--魔法值	
			mfhf=30;		--魔法回复	
			ydsd=10;		--移动速度	
		},
		
	},
	assistitem={
		base_ty_pro={ --基础词条
		--	yxtfjndjjc=1;		--英雄天赋技能等级加成   (该词条不受品质浮动)
		--	yxtfjnbfbjc=1;		--英雄天赋技能百分比加成 --取消该词条
			grjndj=10;			--个人技能等级加成
		--	ggjndj=2;			--公共技能等级加成
			jqjc=100;			--金钱收益提升
			jyjc=100;			--经验收益提升
			sgzjjb=100;			--杀怪获得额外金币
			msmjq=100;			--每十秒增加金币
			lqsj=5;				--冷却缩减
		}
		
	},
	
}

--
--词条的属性值，
--得到的数值与品阶范围随机值相乘，保留两位小数点
_G.NetRare_Pro_Value={
	weapon={
		damage_bfb={{1,8},{9,16},{17,24},{25,36},{37,52},{53,68},{69,84},{85,105}},
		attack_speed={{1,4},{4,8},{8,12},{12,18},{18,26},{26,34},{34,42},{42,52}},
		mfhf={{1,2},{3,4},{5,6},{7,9},{9,12},{12,15},{15,18},{18,22}},
		jnsh={{1,3},{3,5},{5,7},{7,10},{10,14},{14,18},{18,22},{22,28}},
		wlbjgl={{1,2},{3,4},{5,6},{7,9},{9,12},{12,15},{15,18},{18,22}},
		wlbjsh={{1,7},{8,14},{15,21},{22,32},{33,48},{49,64},{65,80},{80,100}},
		mfbjgl={{1,2},{3,4},{5,6},{7,9},{9,12},{12,15},{15,18},{18,22}},
		mfbjsh={{1,7},{8,14},{15,21},{22,32},{33,48},{49,64},{65,80},{80,100}},
		wlshts={{1,2},{3,4},{5,6},{7,9},{9,12},{12,15},{15,18},{18,22}},
		mfshts={{1,2},{3,4},{5,6},{7,9},{9,12},{12,15},{15,18},{18,22}},
		wlct={{0.1,0.5},{0.6,1},{1.1,1.5},{1.6,2},{2.1,2.5},{2.6,3},{3.1,3.5},{3.5,4.2}},
		mfct={{0.1,0.5},{0.6,1},{1.1,1.5},{1.6,2},{2.1,2.5},{2.6,3},{3.1,3.5},{3.5,4.2}},
		zhwsh={{1,4},{4,8},{8,12},{12,18},{18,26},{26,34},{34,42},{42,52}},
		gjjl={{1,4},{4,8},{8,12},{12,18},{18,26},{26,34},{34,42},{42,52}},
		fjsh={{1,2},{3,4},{5,6},{7,9},{9,12},{12,15},{15,18},{18,22}},
		zzsh={{1,2},{3,4},{5,6},{7,9},{9,12},{12,15},{15,18},{18,22}},
		tswsh={{0,0},{0,0},{0,0},{0,0},{0,0},{20,30},{30,50},{50,80}},
		};
	clothes={
		bfbtssm={{1,3},{3,5},{5,7},{7,11},{11,16},{16,21},{21,26},{26,31}},
		smzhfbfb={{0.1,0.5},{0.5,1},{1,1.5},{1.5,2.3},{2.3,3.3},{3.3,3.8},{3.8,4.3},{4.3,4.8}},
		hj={{1,2},{2,3},{3,4},{5,7},{8,12},{12,16},{16,20},{21,25}},
		mfkx={{1,2},{2,3},{3,4},{4,5},{5,6},{6,7},{7,8},{8,9}},
		sb={{1,2},{2,3},{3,4},{4,5},{5,6},{6,7},{7,8},{8,9}},
		wlxx={{0.1,0.5},{0.5,1},{1,1.5},{1.5,2},{2,2.5},{2.5,3},{3,3.5},{3.5,4}},
		fsxx={{0.1,0.5},{0.5,1},{1,1.5},{1.5,2},{2,2.5},{2.5,3},{3,3.5},{3.5,4}},
		qjxx={{0.1,0.5},{0.5,1},{1,1.5},{1.5,2},{2,2.5},{2.5,3},{3,3.5},{3.5,4}},
		shjm={{1,5},{5,10},{10,15},{15,20},{21,25},{26,30},{31,35},{36,45}},
		shhm={{0.1,1},{1,2},{2,3},{3,4},{4,5},{5,6},{6,7},{7,8}}
		};
	jewelry={	
		bfbtsll={{0.1,1},{1,2},{2,3},{3,5},{5,8},{8,11},{11,14},{14,19}},
		bfbtsmj={{0.1,1},{1,2},{2,3},{3,5},{5,8},{8,11},{11,14},{14,19}},
		bfbtszl={{0.1,1},{1,2},{2,3},{3,5},{5,8},{8,11},{11,14},{14,19}},
		bfbtsqsx={{0.1,1},{1,2},{2,3},{3,5},{5,8},{8,11},{11,14},{14,19}},
		attack_speed={{1,2},{3,4},{4,6},{6,9},{9,12},{12,15},{15,18},{18,22}},
		jnsh={{0.1,1},{1,2},{2,3},{3,5},{5,8},{8,11},{11,14},{14,19}},
		bfbtssm={{0.5,1},{1,2},{2,3},{4,6},{7,9},{9,11},{11,13},{13,15}},
		mfz={{1,5},{6,10},{11,15},{16,24},{25,35},{36,45},{46,55},{56,65}},
		mfhf={{0.1,1},{1,2},{2,3},{3,5},{5,8},{8,11},{11,14},{14,18}},
		ydsd={{1,3},{4,6},{7,9},{10,13},{14,18},{18,22},{22,26},{26,30}},
		sjjll={{0.1,1},{1.1,2.5},{2.6,4},{5,7.5},{8,10},{10,12},{12,14},{14,17}},
		sjjmj={{0.1,1},{1.1,2.5},{2.6,4},{5,7.5},{8,10},{10,12},{12,14},{14,17}},
		sjjzl={{0.1,1},{1.1,2.5},{2.6,4},{5,7.5},{8,10},{10,12},{12,14},{14,17}},
		sjjqsx={{0.1,1},{1.1,2.5},{2.6,4},{5,7.5},{8,10},{10,12},{12,14},{14,17}},
		};
	assistitem={
	--	yxtfjndjjc={{1,1},{1,1},{1,1},{1,1}},
	--	yxtfjnbfbjc={{1,3},{4,6},{7,9}},	--取消该词条
		grjndj={{1,1},{1.2,1.4},{1.6,1.8},{2,2.3},{2.5,3},{3,3.5},{3.5,4},{4,5}},
		ggjndj={{1,1},{1.2,1.4},{1.6,1.8},{2,2.3},{2.5,3},{3,3.5},{3.5,4},{4,5}},
		jqjc={{1,2},{2,3},{3,4},{4,6},{6,8},{8,10},{10,12},{12,15}},
		jyjc={{1,2},{2,3},{3,4},{4,6},{6,8},{8,10},{10,12},{12,15}},
		sgzjjb={{1,2},{3,4},{5,6},{7,9},{10,12},{13,15},{16,18},{19,22}},
		msmjq={{10,25},{30,55},{60,85},{90,135},{140,190},{200,250},{250,300},{300,400}},
		lqsj={{0.1,1},{1,2},{2,3},{3,4},{4,5},{5,6},{6,7},{7,8}}
		};

}


--词条对应的战斗力
_G.NetZdl={
	
		damage_bfb=10,
		attack_speed=10,
		mfhf=20,
		jnsh=14,
		wlbjgl=25,
		wlbjsh=4,
		mfbjgl=25,
		mfbjsh=4,
		wlshts=30,
		mfshts=30,
		wlct=20,
		mfct=20,
		zhwsh=10,
		gjjl=10,
		fjsh=40,
		zzsh=50,
		tswsh=30,
		

		bfbtssm=10,
		smzhfbfb=30,
		hj=10,
		mfkx=10,
		sb=10,
		wlxx=25,
		fsxx=25,
		qjxx=50,
		shjm=3,
		shhm=40,
		
	
		bfbtsll=10,
		bfbtsmj=10,
		bfbtszl=10,
		bfbtsqsx=30,
		sjjll=10,
		sjjmj=10,
		sjjzl=10,
		sjjqsx=30,
		mfz=5,
		ydsd=10,
		
		yxtfjndjjc=100,
		grjndj=100,
		ggjndj=100,
		jqjc=10,
		jyjc=10,
		sgzjjb=2,
		msmjq=1,
		lqsj=20,
		

}


---根据名字创造随机装备实体
function CreateRandomItem2(itemname,unit)
	local rare = {}
	local difficulty =  GetGameDifficulty()
	local minitemrare = ba.difficultyconfig[difficulty][1]
	local maxitemrare = ba.difficultyconfig[difficulty][2]

	for i=minitemrare,maxitemrare do
		if unit.cas_table.tmz > 0 and i > minitemrare then
			rare[i] = math.ceil(ba["netbl"..NetLevel[NetTime]][i] * (1+unit.cas_table.tmz/100))
		else
			rare[i] = ba["netbl"..NetLevel[NetTime]][i]
		end			--table.insert(rare,ba["netbl"..NetLevel[NetTime]][i])
		if unit.cas_table.tmz3 > 0 and i == maxitemrare then
			rare[i] = math.ceil(rare[i] * (unit.cas_table.tmz3/100+1))
		end
	end
	local pz =  Weightsgetvalue_one(rare)
	local itemrare = pz  --随机装备品质，普通（白色1）优良（绿色2）稀有（蓝色3）极品（紫色4）史诗（橙色5）传奇（金色6）神话（红色7）
 	if itemrare > 7 then
 		itemrare = 7
 	end
 	if unit.cas_table.tmz2 then
 		if unit.cas_table.tmz2 >100 and RollPercentage(33) then
	 		unit.cas_table.tmz2 = 0
	 		itemrare = 7
	 	end
 	end

	NetPz[NetTime] = itemrare
	local self = CreateItem(itemname, unit, unit )
	
	return self;
end


function SpawnitemEntity2( itemname,unit)
	local newItem = CreateRandomItem2(itemname,unit)
	if newItem then
		if not unit.netItem then
			unit.netItem={}
		end
		table.insert(unit.netItem,newItem)		
	end
--	local itemid = newItem:entindex()
--	local playerID = unit:GetPlayerOwnerID()
--	unit:AddItem(newItem)
	
end


--物品掉落
function NetItemDrop(unit)
	local difficulty =  GetGameDifficulty() 
	local itemlevel = 1
	local maxitemlevel= ba.difficultyzgdj[difficulty][2]
	local minitemlevel= ba.difficultyzgdj[difficulty][1]
	if maxitemlevel == minitemlevel then
		itemlevel=  minitemlevel
	else	
		if RollPercentage(85) then
			itemlevel=  minitemlevel
		else
			itemlevel=  maxitemlevel
		end
	end
	local itemName=""
	local itemtype=Weightsgetvalue_one(NetItem_Type) --衣服武器首饰等物品类型 

	if unit.cas_table.tmz2 then
 		if unit.cas_table.tmz2 >100 then
	 		itemtype=Weightsgetvalue_one(NetItem_Type2)
	 	end
 	end
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
--	itemname = "item_net_wq_ll_1_1"
--	print("itemname=",itemname)

	NetTime = NetTime +1
	NetLevel[NetTime] = itemlevel
	SpawnitemEntity2(itemName,unit)

end

--宝箱开启
--level 代表宝箱等级

--rare 代表宝箱的品质
  -- 1 代表白色
  -- 2 代表优良绿色
  -- 3 代表稀有蓝色
  -- 4 代表极品紫色
  -- 5 代表史诗橙色
  -- 6 代表传奇金色
  -- 7 代表神话红色

--type 代表宝箱的部位，默认是5
  -- 1 代表武器
  -- 2 代表防具
  -- 3 代表首饰
  -- 4 代表特殊装备
  -- 5 代表通用 

--playerID ,玩家Id 
function OpenNetbox(playerID,level,rare,type)
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
		hero:AddItem(newItem)
	end
	
end





--击杀年兽掉落存档装备
function YearNetItemDrop(unit)
	local difficulty =  GetGameDifficulty() 
	local itemlevel = 1
	local maxitemlevel= ba.difficultyzgdj[difficulty][2]
	local minitemlevel= ba.difficultyzgdj[difficulty][1]+1
	if maxitemlevel == minitemlevel then
		itemlevel=  minitemlevel
	else	
		if RollPercentage(80) then
			itemlevel=  minitemlevel
		else
			itemlevel=  maxitemlevel
		end
	end
	local itemName=""
	local itemtype=Weightsgetvalue_one(NetItem_Type) --衣服武器首饰等物品类型 
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
--	itemname = "item_net_wq_ll_1_1"
--	print("itemname=",itemname)
	local minitemrare = ba.difficultyconfig[difficulty][1] +1
	local maxitemrare = ba.difficultyconfig[difficulty][2]
	for i=minitemrare,maxitemrare do
		rare[i] = ba["netbl"..NetLevel[NetTime]][i]
	end
	local itemrare = Weightsgetvalue_one(rare)  --随机装备品质，普通（白色1）优良（绿色2）稀有（蓝色3）极品（紫色4）史诗（橙色5）传奇（金色6）神话（红色7）
 	
	if itemName then
		NetTime = NetTime +1
		NetLevel[NetTime] = itemlevel
		NetPz[NetTime] = itemrare
		local newItem = CreateItem(itemName, hero, hero )
		hero:AddItem(newItem)
	end

end