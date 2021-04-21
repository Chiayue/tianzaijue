--初始装备的下标为1
_G.Color={
	"particles/test/neutral_item_drop_1.vpcf";
	"particles/test/neutral_item_drop_2.vpcf";
	"particles/test/neutral_item_drop_3.vpcf";
	"particles/test/neutral_item_drop_4.vpcf";
	"particles/test/neutral_item_drop_5.vpcf";
	"particles/test/neutral_item_drop_6.vpcf";
	"particles/test/neutral_item_drop_7.vpcf";
}
_G.SjTime =1
--每件装备的等级
_G.SjLevel={}
--每件装备的最低品质
_G.SjPz={}

_G.CC_AB={
	
	ablist={"aoshuzhuanjin","medusa_split_shot","wenyiguanghuan","guwu","longwei","qiangzhuangtizhi","xianji","shuizhihongliu","bingzhishijie","leifa","tuzhimaidong","fenzhizhufu","dadifusu","throw_attack"},
	ablist_plus={"yilibudao","jiqizhiming","phantom_assassin_coup_de_grace_datadriven","buqunuhou","yunshi","siwangzuzhou","anjiannanfang","firefly","ascension_magic_immunity","changbiyuan","aoshukuangxiang","xingfengji","weaver_geminate_attack","ascension_bulwark"}
}
--根据掉宝品质削减物品数量	
_G.dbsl={
	1;
	5;
	25;
	300;
	1200;
	10000;
}	


_G.HERO_CUSTOM_PRO =
{
	ascension_crit =
	{
		
		wlbjgl = 0,
		wlbjsh = 0,
		mfbjgl = 0,
		mfbjsh = 0,
		attack_damage_plus= 0,
		gjdtsxsh=0,
		gjqtsxsh= 0,
		gjxx= 0,
		fsxx= 0,
		fjsh= 0,
		zzsh= 0,
		bgjyglhx=0,
		bgjyglhl=0,
		gjjshj=0,
		gjhfxl=0,
	
	},
	

	hero_state_pro =
	{
	
			

		bfbtsqsx = 0,
		bfbtsll = 0,
		bfbtszl = 0,
		bfbtsmj = 0,
		gjzjqsx = 0,
		sgzjzl = 0,
		sgzjsmz = 0,
		sgzjqsx = 0,
		sgzjmj = 0,
		sgzjll = 0,
		gjzjzl = 0,
		gjzjmj = 0,
		gjzjll = 0,
	},	
	hero_state_pro_se=
	{
		jqjc=0,			
		jyjc=0,
		msmjq=0,			
		sgzjjb=0,	
	},	
	
}
_G.Wild_Monster_Burst_Rate={		--千分制，超过一千以上数值会爆多次，如数值=1100，则百分百掉落一次装备，然后还有10%的概率再触发一次掉落
	yg1=1,  --还是不整合到一起了
	yg2=1,
	yg3=1,
	yg4=1,
	yg5=2,
	yg6=2,
	yg7=2,
	yg8=2,
	yg9=2,
	yg10=3,
	yg11=3,
	yg12=3,
	yg13=3,
	yg14=3,
	yg15=3,
	yg16=4,
	yg17=4,
	yg18=4,
	yg19=4,
	yg20=5,
	yg21=6,
	yg22=7,
	yg23=8,
	yg24=9,
	yg25=10,
	yg26=10,
	yg27=10,
	yg28=20,
	yg29=20,
	yg30=20,
	zlg_1=5, --预计可能5调整至10
	zlg_3=5,
	zlg_4=5,
	zlg_5=5,
	zlg_6=5,
	zlg_7=5,
	zlg_8=5,
	zlg_9=5,
	zlg_10=5,
	zlg_11=5,
	zlg_12=5,
	zlg_13=5,
	zlg_14=5,
	zlg_15=5,
	zlg_16=5,
	zlg_17=5,
	zlg_18=5,
	zlg_19=5,
	zlg_20=5,
	zlg_21=5,
	zljyg_1=5,
	zljyg_2=5,
	zljyg_3=5,
	zljyg_4=5,
	zljyg_5=5,
	zljyg_6=5,
	yw_BOSS_1_1=50,
	yw_BOSS_1_2=50,
	yw_BOSS_1_3=50,
	yw_BOSS_1_4=50,
	yw_BOSS_1_5=50,
	yw_BOSS_2_1=70,
	yw_BOSS_2_2=70,
	yw_BOSS_2_3=70,
	yw_BOSS_2_4=70,
	yw_BOSS_2_5=70,
	yw_BOSS_3_1=90,
	yw_BOSS_3_2=90,
	yw_BOSS_3_3=90,
	yw_BOSS_3_4=90,
	yw_BOSS_3_5=90,
	yw_BOSS_4_1=100,
	yw_BOSS_4_2=100,
	yw_BOSS_4_3=100,
	yw_BOSS_4_4=100,
	yw_BOSS_4_5=100,
	yw_BOSS_5_1=100,
	yw_BOSS_5_2=100,
	yw_BOSS_5_3=100,
	yw_BOSS_5_4=100,
	yw_BOSS_5_5=100,
	npc_boss_01=1,
	npc_boss_02=1,
	npc_boss_03=1,
	npc_boss_04=1,
	npc_boss_05=1,
	npc_boss_06=1,
	npc_boss_07=1,
	npc_boss_08=1,
	zbbx_1=1000,
	sj_boss_1=25000,
	sj_boss_2=25000,
	sj_boss_3=25000,
	sj_boss_4=25000,
	sj_boss_5=25000,
	sj_boss_6=25000,
	sj_boss_7=25000,
	sj_boss_8=25000,
	sj_boss_9=25000,
	sj_boss_10=25000,
	sj_boss_11=25000,
	sj_boss_12=25000,
	sj_boss_13=25000,
	sj_boss_14=25000,
	sj_boss_15=25000,

}
--难度爆率加成
_G.Different_Burst_Rate={
	Different_1=1,
	Different_2=1.2,
	Different_3=1.4,
	Different_4=1.6,
	Different_5=1.8,
	Different_6=2,
	Different_7=2.4,
}

--人数爆率加成(用于无尽boss的装备掉落，因为不是每个人都计算一次掉落)
_G.PlayerNum_Burst_Rate={
	PlayerNum_1=1;
	PlayerNum_2=1.4;
	PlayerNum_3=1.8;
	PlayerNum_4=2.5;
}

--[[装备的品质权重
_G.pzgl={
	pz1=80000,
	pz2=30000,
	pz3=12000,
	pz4=4000,
	pz5=300,
	pz6=10,
	pz7=1,

}]]

--装备等阶(根据怪物的等级决定物品的等阶)
_G.Itemlevel={
	level_1={1,30},--(20级以内的怪物只会爆一阶装备)
	level_2={31,60},
	level_3={61,90},
	level_4={91,120},
	level_5={121,150},
	level_6={151,180}
}

--装备品阶词条数值区间
--[[_G.ctszqj={
	pz1={0.6,1},
	pz2={0.8,1.2},
	pz3={1,1.4},
	pz4={1.2,1.6},
	pz5={1.5,1.8},
	pz6={1.8,2.2},
	pz7={2.2,3},

}]]


--装备种类权重
_G.Item_Type={
	200,--武器
	100,--衣服
	600,--首饰
	10,--辅助装备
	10,--收益装备
	--1,--特殊装备
}
_G.Item_Type_All={
	200,--武器
	100,--衣服
	600,--首饰
	10,--辅助装备
	10,--收益装备
	--1,--特殊装备
}
--品质相关
--rare_1一阶
--weight 权重
--pro_value装备品阶词条数值区间
--rare_base_pro基础词条
--rare_spe_pro特殊词条
_G.Item_Rare={
	rare_1={
		weight=1,--品质权重		--之前是8W，先屏蔽出白色装备的
		pro_value={0.6,1},--品阶词条数值区间
		rare_base_pro={50,50,0,0,0,0},--基础词条数目权重
		rare_spe_pro={0,0,0,0,0,0},--特殊词条
	},
	rare_2={
		weight=30000,--品质权重
		pro_value={0.8,1.2},--品阶词条数值区间
		rare_base_pro={0,70,30,0,0,0},--基础词条
		rare_spe_pro={0,0,0,0,0,0},--特殊词条
	},
	rare_3={
		weight=12000,--品质权重
		pro_value={1,1.4},--品阶词条数值区间
		rare_base_pro={0,20,80,0,0,0},--基础词条
		rare_spe_pro={50,0,0,0,0,0},--特殊词条
	},
	rare_4={
		weight=4000,--品质权重
		pro_value={1.2,1.6},--品阶词条数值区间
		rare_base_pro={0,0,70,30,0,0},--基础词条
		rare_spe_pro={30,70,0,0,0,0},--特殊词条
	},
	rare_5={
		weight=300,--品质权重
		pro_value={1.5,1.8},--品阶词条数值区间
		rare_base_pro={0,0,20,60,20,0},--基础词条
		rare_spe_pro={0,65,35,0,0,0},--特殊词条
	},
	rare_6={
		weight=10,--品质权重
		pro_value={1.8,2.2},--品阶词条数值区间
		rare_base_pro={0,0,0,20,80,0},--基础词条
		rare_spe_pro={0,0,50,40,10,0},--特殊词条
	},
	rare_7={
		weight=1,--品质权重
		pro_value={2.2,3},--品阶词条数值区间
		rare_base_pro={0,0,0,0,0,100},--基础词条
		rare_spe_pro={0,0,0,30,40,30},--特殊词条
	},
}
--品质1基础词条
--[[_G.pz1jcct={
	r1=50,
	r2=50,

}
--品质1特殊词条
_G.pz1tsct={
	r1=0,
}
--品质2基础词条
_G.pz2jcct={
	r1=15,
	r2=55,
	r3=30,

}
--品质2特殊词条
_G.pz2tsct={
	r1=0,
}
--品质3基础词条
_G.pz3jcct={
	r1=10,
	r2=50,
	r3=40,

}
--品质3特殊词条
_G.pz3tsct={
	r0=50,
	r1=50,
}


_G.pz4jcct={
	r2=20,
	r3=55,
	r4=25,

}
_G.pz4tsct={
	r1=70,
	r2=30,
}


_G.pz5jcct={
	r2=10,
	r3=45,
	r4=45,

}
_G.pz5tsct={
	r2=65,
	r3=35,
}

_G.pz6jcct={
	r3={20},
	r4={45},
	r5={35},

}
m.pz6tsct={
	r2={30},
	r3={40},
	r4={30},

}


m.pz7jcct={
	r4={20},
	r5={40},
	r6={40},

}
m.pz7tsct={
	r3={10},
	r4={40},
	r5={30},
	r6={20},

}

--武器的基础词条属性权重]]
--base_pro--基础词条表
--spe_pro--特殊词条表
_G.Item_Pro_Weight={
	wq={
		item={"item_sj_wq_ll_1_1","item_sj_wq_mj_1_1","item_sj_wq_zl_1_1","item_sj_wq_ll_1_2","item_sj_wq_mj_1_2","item_sj_wq_zl_1_2",
	          "item_sj_wq_ll_2_1","item_sj_wq_mj_2_1","item_sj_wq_zl_2_1","item_sj_wq_ll_2_2","item_sj_wq_mj_2_2","item_sj_wq_zl_2_2",
	          "item_sj_wq_ll_3_1","item_sj_wq_mj_3_1","item_sj_wq_zl_3_1","item_sj_wq_ll_3_2","item_sj_wq_mj_3_2","item_sj_wq_zl_3_2",
	          "item_sj_wq_ll_4_1","item_sj_wq_mj_4_1","item_sj_wq_zl_4_1","item_sj_wq_ll_4_2","item_sj_wq_mj_4_2","item_sj_wq_zl_4_2",
	          "item_sj_wq_ll_5_1","item_sj_wq_mj_5_1","item_sj_wq_zl_5_2","item_sj_wq_ll_5_2","item_sj_wq_mj_5_2","item_sj_wq_zl_5_2"},
		base_pro={ --基础词条
			damage=100,			--攻击力
			attack_speed=20,		--攻击速度
			attack_damage_plus=20,		--普通攻击触发额外伤害
			gjdtsxsh=10,		--攻击附带单体主属性伤害
			gjqtsxsh=5,		--攻击附带群体主属性伤害
			--zs={5,			--攻击灼烧目标
			--gjsfdjjn={10,	--攻击施法低级技能	
			--jgsfdjjn={10,	--间隔施法低级技能

			jnsh=30,		--技能伤害
			ll=50,			--力量
			mj=50,			--敏捷				
			zl=50,			--智力				
			qsx=20,			--全属性		
			gjxx=20,		--攻击吸血													
			wlxx=5,		--物理吸血	-----------？									
			fsxx=5,		--法术吸血										
		--zmyj={20,		--致命一击		
		},
		spe_pro={		--特殊词条
			wlbjgl=5,		--物理暴击概率
			wlbjsh=10,		--物理暴击伤害
			mfbjgl=5,		--物理暴击概率
			mfbjsh=10,		--物理暴击伤害
			lqsj=2,		--冷却缩减
			--gjjgjd=2,		--攻击间隔降低
			--gjsfgjjn=2,	--攻击释放高级技能
			--jgsfgjjn=2,	--间隔释放高级技能
			fjsh=2,		--附加伤害
			zzsh=1,		--最终伤害
				},
	},
	fj={
		item={"item_sj_fj_ll_1_1","item_sj_fj_mj_1_1","item_sj_fj_zl_1_1",
			  "item_sj_fj_ll_2_1","item_sj_fj_mj_2_1","item_sj_fj_zl_2_1",
			  "item_sj_fj_ll_3_1","item_sj_fj_mj_3_1","item_sj_fj_zl_3_1",
			  "item_sj_fj_ll_4_1","item_sj_fj_mj_4_1","item_sj_fj_zl_4_1",
			  "item_sj_fj_ll_5_1","item_sj_fj_mj_5_1","item_sj_fj_zl_5_1"},  
		base_pro={ --基础词条
			smhf=100,		--生命回复
			mfhf=50,		--魔法恢复
			smz=100,		--生命值
			mfz=50,			--魔法值
			bgjyglhx=20,		--被攻击20%概率回复血量
			bgjyglhl=10,		--被攻击20%概率回复蓝量
			hj=50,			--护甲
			mfkx=20,			--魔法抗性
			ll=50,			--力量
			mj=50,			--敏捷				
			zl=50,		--智力				
			qsx=20,		--全属性	
			sb=20,			--闪避

			smzhfbfb=5,		--生命值回复（百分比）
			pgshjs=20,			--格挡，普通攻击伤害减少
			shjm=1,			--伤害减少
			rx=1,				--韧性重复了
		},
		spe_pro={		--特殊词条
			wlxx=10,			--物理吸血
			fsxx=10,			--法术吸血
			qjxx=3,			--全局吸血
			shjm=4,			--伤害减免（百分比）
			shhm=1,			--伤害豁免（不受到该伤害）
			--jgsfgjjn={2};
			--jndjjc={2};
			rx=4,				--韧性
				},
	},
	sp={
		item={"item_sj_sp_ty_1_1","item_sj_sp_ty_1_2","item_sj_sp_ty_1_3",
	          "item_sj_sp_ty_2_1","item_sj_sp_ty_2_2","item_sj_sp_ty_2_3",
              "item_sj_sp_ty_3_1","item_sj_sp_ty_3_2","item_sj_sp_ty_3_3",
              "item_sj_sp_ty_4_1","item_sj_sp_ty_4_2","item_sj_sp_ty_4_3",
	          "item_sj_sp_ty_5_1","item_sj_sp_ty_5_2","item_sj_sp_ty_5_3"},

		base_pro={ --基础词条
			smhf=100,		--生命回复
			mfhf=50,		--魔法恢复
			smz=100,		--生命值
			mfz=50,			--魔法值
			bgjyglhx=20,		--被攻击20%概率回复血量
			bgjyglhl=10,		--被攻击20%概率回复蓝量
			hj=50,			--护甲
			mfkx=20,			--魔法抗性
			ll=50,			--力量
			mj=50,			--敏捷				
			zl=50,		--智力				
			qsx=20,		--全属性	
			sb=20,			--闪避
			damage=75,			--攻击力
			attack_speed=20,			--攻击速度
			gjxx=10,			--攻击吸血

			jnsh=20,			--技能伤害
			gjjshj=10,		--攻击减少目标护甲，持续5s，不叠加（同一个buff只会受到最后的作用或者最大数值的作用）
			gjhfxl=20,		--攻击回复自身血量

			--zlts={20};
			--bzlts={20};
			--jgsfdjjn={20};
		},
		spe_pro={		--特殊词条
			wlbjgl=20,			--暴击 概率
			wlbjsh=20,			--暴击伤害
			mfbjgl=20,			--暴击 概率
			mfbjsh=20,			--暴击伤害
			--jndjjc=20,		--技能等级加成
			shjm=20,			--伤害减免
			--jgsfgjjn={20};		--间隔释放技能
			fjsh=20,			--附加伤害
			},
	},
	fz={
		item={"item_sj_fz_dj_1_1","item_sj_fz_dj_1_2",  "item_sj_fz_dj_1_3", "item_sj_fz_dj_1_4",
	          "item_sj_fz_dj_1_5","item_sj_fz_dj_1_6",  "item_sj_fz_dj_1_7", "item_sj_fz_dj_1_8",
	          "item_sj_fz_dj_1_9","item_sj_fz_dj_1_10", "item_sj_fz_dj_1_11","item_sj_fz_dj_1_12",
	          "item_sj_fz_dj_1_13","item_sj_fz_dj_1_14","item_sj_fz_dj_1_15","item_sj_fz_dj_1_16",
	          "item_sj_fz_dj_1_17","item_sj_fz_dj_1_18","item_sj_fz_dj_1_19","item_sj_fz_dj_1_20",
	          "item_sj_fz_dj_1_21"},

		base_pro={ --基础词条
			gjzjll=10,		--攻击有5%的概率增加力量
			gjzjmj=10,		--攻击有5%的概率增加敏捷
			gjzjzl=10,		--攻击有5%的概率增加智力
			gjzjqsx=5,		--攻击有5%的概率增加全属性
			sgzjll=10,		--杀怪有5%的概率增加力量
			sgzjmj=10,		--杀怪有5%的概率增加敏捷		
			sgzjzl=10,		--杀怪有5%的概率增加智力
			sgzjqsx=5,		--杀怪有5%的概率增加全属性
			sgzjsmz=10,		--杀怪有5%的概率增加生命值
			smzhfbfb=2,		--生命值回复每秒百分比
			gjhfxl=10,		--攻击回复自身血量

			lqsj=1,			--冷却缩减
		--	gjjgjd=1,			--攻击间隔降低
			--bfbtsll=2,		--百分比提升力量
			--bfbtsmj=2,		--百分比提升敏捷
			--bfbtszl=2,		--百分比提升智力
			--bfbtsqsx=1,		--百分比提升全属性
		},
		spe_pro={		--特殊词条
			bfbtsll=2,		--百分比提升力量
			bfbtsmj=2,		--百分比提升敏捷
			bfbtszl=2,		--百分比提升智力
			bfbtsqsx=1,		--百分比提升全属性
			},
	},
	sy={
		item={"item_sj_sy_dj_1_1","item_sj_sy_dj_1_2","item_sj_sy_dj_1_3","item_sj_sy_dj_1_4"},
		base_pro={ --基础词条
			jqjc=2,			--金钱收益提升
			jyjc=2,			--经验收益提升
			msmjq=10,			--每十秒+金钱
			sgzjjb=5,			--杀怪增加金币
		},
		spe_pro={		--特殊词条
			jqjc=2,		    	--金钱收益提升
			jyjc=2,			--经验收益提升
			msmjq=10,			--每十秒+金钱
			sgzjjb=5,			--杀怪增加金币
			},
	},
}
--[[
m.wqjcct={
	gjl={100};			--攻击力
	gjsd={20};		--攻击速度
	ewsh={20};		--普通攻击触发额外伤害
	gjdtsxsh={10};		--攻击附带单体主属性伤害
	gjqtsxsh={5};		--攻击附带群体主属性伤害
	--zs={5};			--攻击灼烧目标
	--gjsfdjjn={10};	--攻击施法低级技能	
	--jgsfdjjn={10};	--间隔施法低级技能

	jnsh={30};		--技能伤害
	ll={50};			--力量
	mj={50};			--敏捷				
	zl={50};			--智力				
	qsx={20};			--全属性		
	gjxx={20};		--攻击吸血													
	wlxx={5};		--物理吸血										
	fsxx={5};		--法术吸血										
--zmyj={20};		--致命一击											

}

m.wqtsct={
	bjgl={5};		--暴击概率
	bjsh={10};		--暴击伤害
	lqsj={2};		--冷却缩减
	gjjgjd={2};		--攻击间隔降低
	gjsfgjjn={2};	--攻击释放高级技能
	jgsfgjjn={2};	--间隔释放高级技能
	fjsh={2};		--附加伤害
	zzsh={1};		--最终伤害

}

m.yfjcct={
	smhf={100};		--生命回复
	mfhf={50};		--魔法恢复
	smz={100};		--生命值
	mfz={50};			--魔法值
	bgjyglhx={20};		--被攻击20%概率回复血量
	bgjyglhl={10};		--被攻击20%概率回复蓝量
	hj={50};			--护甲
	mfkx={20};			--魔法抗性
	ll={50};			--力量
	mj={50};			--敏捷				
	zl={50};		--智力				
	qsx={20};		--全属性	
	sb={20};			--闪避

	smzhfbfb={5};		--生命值回复（百分比）
	pgshjs={20};			--格挡，普通攻击伤害减少
	shjm={1};			--伤害减少
	rx={1};				--韧性


}

m.yftsct={
	wlxx={10};			--物理吸血
	fsxx={10};			--法术吸血
	qjxx={3};			--全局吸血
	shjm={4};			--伤害减免（百分比）
	shhm={1};			--伤害豁免（不受到该伤害）
	--jgsfgjjn={2};
	--jndjjc={2};
	rx={4};				--韧性
}


m.ssjcct={
	smhf={100};		--生命回复
	mfhf={50};		--魔法恢复
	smz={100};		--生命值
	mfz={50};			--魔法值
	bgjyglhx={20};		--被攻击20%概率回复血量
	bgjyglhl={10};		--被攻击20%概率回复蓝量
	hj={50};			--护甲
	mfkx={20};			--魔法抗性
	ll={50};			--力量
	mj={50};			--敏捷				
	zl={50};		--智力				
	qsx={20};		--全属性	
	sb={20};			--闪避
	gjl={75};			--攻击力
	gjsd={20};			--攻击速度
	gjxx={10};			--攻击吸血

	jnsh={20};			--技能伤害
	gjjshj={10};		--攻击减少目标护甲，持续5s，不叠加（同一个buff只会受到最后的作用或者最大数值的作用）
	gjhfxl={20};		--攻击回复自身血量

	--zlts={20};
	--bzlts={20};
	--jgsfdjjn={20};

}

m.sstsct={
	bjgl={20};			--暴击 概率
	bjsh={20};			--暴击伤害
	jndjjc={20};		--技能等级加成
	shjm={20};			--伤害减免
	--jgsfgjjn={20};		--间隔释放技能
	fjsh={20};			--附加伤害


}

m.fzzbjcct={
	gjzjll={10};		--攻击有5%的概率增加力量
	gjzjmj={10};		--攻击有5%的概率增加敏捷
	gjzjzl={10};		--攻击有5%的概率增加智力
	gjzjqsx={5};		--攻击有5%的概率增加全属性
	sgzjll={10};		--杀怪有5%的概率增加力量
	sgzjmj={10};		--杀怪有5%的概率增加敏捷		
	sgzjzl={10};		--杀怪有5%的概率增加智力
	sgzjqsx={5};		--杀怪有5%的概率增加全属性
	sgzjsmz={10};		--杀怪有5%的概率增加生命值
	smzhfbfb={2};		--生命值回复每秒百分比
	gjhfxl={10};		--攻击回复自身血量

	lqsj={1};			--冷却缩减
	gjjgjd={1};			--攻击间隔降低
	bfbtsll={2};		--百分比提升力量
	bfbtsmj={2};		--百分比提升敏捷
	bfbtszl={2};		--百分比提升智力
	bfbtsqsx={1};		--百分比提升全属性




}

m.fzzbtsct={
	
	bfbtsll={2};		--百分比提升力量
	bfbtsmj={2};		--百分比提升敏捷
	bfbtszl={2};		--百分比提升智力
	bfbtsqsx={1};		--百分比提升全属性
}

m.syzbjcct={
	jqjc={2};			--金钱收益提升
	msmjq={10};			--每十秒+金钱
	sgzjjb={5};			--杀怪增加金币

}
m.syzbtsct={
	jqjc={2};			--金钱收益提升
	msmjq={10};			--每十秒+金钱
	sgzjjb={5};			--杀怪增加金币

}



--

]]
--词条的属性值，
--得到的数值与品阶范围随机值相乘，保留两位小数点
_G.Rare_Pro_Value={
	smhf={{10,30},{50,100},{100,300},{400,800},{900,1500},{1600,2500},{2600,4000},{5000,8000}},	--生命回复
	mfhf={{1,2},{3,4},{4,6},{7,8},{9,10},{11,14},{15,18},{19,22}},			--魔法回复
	smz={{200,600},{800,2000},{3000,5000},{6000,12000},{14000,25000},{30000,50000},{55000,80000},{85000,120000}},	--生命值
	mfz={{10,20},{30,40},{40,60},{70,80},{90,100},{110,140},{150,180},{190,220}},								--魔法值
	bgjyglhx={{10,30},{50,100},{100,300},{400,800},{1000,2000},{3000,5000},{5500,7500},{8000,10000}},	--被攻击有20%概率回血
	bgjyglhl={{1,4},{5,8},{9,12},{13,16},{17,20},{21,26},{27,32},{33,38}},		--被攻击有20%概率回蓝
	damage={{20,60},{100,300},{600,1000},{1200,2000},{3000,6000},{7000,12000},{13000,20000},{20000,30000}},	--攻击力
	hj={{1,4},{5,10},{12,16},{18,24},{28,32},{36,40},{44,48},{50,60}},				--护甲
	mfkx={{1,3},{3,5},{5,7},{7,9},{9,11},{11,13},{13,15},{15,17}},			--魔法抗性
	jnsh={{1,5},{6,10},{11,15},{16,25},{26,35},{36,45},{46,60},{65,90}},			--技能伤害
	ll={{10,30},{40,100},{120,240},{360,800},{900,1350},{1500,2200},{2300,3500},{4000,6000}},		--力量
	mj={{10,30},{40,100},{120,240},{360,800},{900,1350},{1500,2200},{2300,3500}},		--敏捷
	zl={{10,30},{40,100},{120,240},{360,800},{900,1350},{1500,2200},{2300,3500}},		--智力
	qsx={{10,20},{40,100},{120,240},{360,800},{900,1350},{1500,2200},{2300,3500}},	--全属性
	attack_speed={{1,10},{11,20},{21,30},{31,40},{41,50},{51,60},{61,70}},			--攻击速度
	sb={{1,5},{6,10},{11,15},{16,20},{21,25},{26,30},{31,35}},			--闪避
	ydsd={{10,20},{20,30},{30,40},{40,50},{50,60},{60,70},{70,80}},		--移动速度（固定值）
	gjxx={{2,2},{3,3},{5,5},{7,7},{9,9},{11,11},{13,13}},					--攻击吸血
	attack_damage_plus={{10,100},{200,400},{600,1000},{1500,2500},{3000,5000},{5500,8000},{8500,12500}},--攻击20%触发额外魔法伤害
	--shmz={},
	gjzjll={{1,2},{3,4},{5,6},{7,8},{9,10},{11,12},{13,14}},			---攻击增加力量	5%的概率
	gjzjmj={{1,2},{3,4},{5,6},{7,8},{9,10},{11,12},{13,14}},		--攻击增加敏捷	5%的概率	
	gjzjzl={{1,2},{3,4},{5,6},{7,8},{9,10},{11,12},{13,14}},		--攻击增加智力	5%的概率
	gjzjqsx={{1,2},{3,4},{5,6},{7,8},{9,10},{11,12},{13,14}},		--攻击增加全属性	5%的概率
	sgzjll={{1,2},{3,4},{5,6},{7,8},{9,10},{11,12},{13,14}},		--杀怪增加力量	5%的概率
	sgzjmj={{1,2},{3,4},{5,6},{7,8},{9,10},{11,12},{13,14}},			--杀怪增加敏捷	5%的概率	
	sgzjzl={{1,2},{3,4},{5,6},{7,8},{9,10},{11,12},{13,14}},		--杀怪增加敏捷	5%的概率
	sgzjqsx={{1,2},{3,4},{5,6},{7,8},{9,10},{11,12},{13,14}},		--杀怪增加全属性	5%的概率
	sgzjsmz={{1,8},{10,20},{25,40},{45,60},{80,100},{120,150},{180,220}},--杀怪增加生命值		5%的概率
	smzhfbfb={{0.1,0.5},{0.5,1},{1,1.5},{1.5,2},{2,2.5},{2.5,3},{3,3.5}},		--生命回复（百分比）
	ydsdbfb={{1,2},{3,4},{5,6},{7,8},{9,10},{11,12},{13,14}},	--移动速度（百分比）
	pgshjs={{1,8},{10,20},{25,40},{45,60},{80,100},{120,150},{180,220}},--普通攻击伤害减少（固定值）

	gjjshj={{1,5},{6,10},{11,15},{16,20},{21,25},{26,30},{31,35}},	--攻击减少目标护甲，持续5s
	gjdtsxsh={{1,2},{3,4},{5,6},{7,9},{10,14},{15,20},{21,25}},	--攻击附带单体主属性物理伤害（20%概率）
	gjqtsxsh={{1,2},{3,4},{5,6},{7,9},{10,14},{15,20},{21,25}},		--攻击附带群体主属性物理伤害（20%概率）
	--sjjn={},
	--zs={},

	gjhfxl={{5,15},{25,50},{50,150},{200,400},{450,750},{800,1200},{1300,2000}},--攻击回复血量 20%概率
	--gjhfll={},
	--sfhfll={},

	--hk={},
	--fk={},
	--lk={},
	--sk={},
	--tk={},
	--dk={},

	lqsj={{0.1,1},{1,2},{2,3},{3,4},{4,5},{5,6},{6,7}},--冷却缩减
	--gjjgjd={{0.1,0.02},{0.02,0.04},{0.04,0.06},{0.06,0.08},{0.08,0.1},{0.08,0.1}},--攻击间隔降低
	--kssf={},
	--zlts={},
	--bzlts={},
	--zs={},


	jqjc={{1,3},{3,6},{6,9},{9,12},{12,15},{15,18},{18,22}},		--金钱收益提升%
	jyjc={{1,3},{3,6},{6,9},{9,12},{12,15},{15,18},{18,22}},		--经验收益提升%
	msmjq={{10,100},{100,200},{200,400},{500,700},{800,1000},{1100,1400},{1500,2000}},--每十秒增加金币
	sgzjjb={{1,10},{11,20},{21,30},{31,50},{51,80},{81,120},{125,175}},		--杀怪获得额外金币

	bfbtsll={{1,2},{3,4},{5,6},{7,8},{9,11},{12,15},{16,20}};		--百分比提升力量
	bfbtsmj={{1,2},{3,4},{5,6},{7,8},{9,11},{12,15},{16,20}};		--百分比提升敏捷
	bfbtszl={{1,2},{3,4},{5,6},{7,8},{9,11},{12,15},{16,20}};		--百分比提升智力
	bfbtsqsx={{1,2},{3,4},{5,6},{7,8},{9,11},{12,15},{16,20}};		--百分比提升全属性



	wlxx={{0.1,0.5},{0.6,1},{1.1,1.5},{1.6,2},{2.1,2.5},{2.6,3},{3.1,3.5}},		--物理吸血
	fsxx={{0.1,0.5},{0.6,1},{1.1,1.5},{1.6,2},{2.1,2.5},{2.6,3},{3.1,3.5}},		--法术吸血
	qjxx={{0.1,0.5},{0.6,1},{1.1,1.5},{1.6,2},{2.1,2.5},{2.6,3},{3.1,3.5}},		--全局吸血
	wlbjgl={{1,1},{2,2},{3,3},{4,4},{5,5},{6,6},{7,7}},		--物理暴击概率
	wlbjsh={{1,7},{8,14},{15,21},{22,29},{30,37},{38,45},{46,53}},		--物理暴击伤害
	mfbjgl={{1,1},{2,2},{3,3},{4,4},{5,5},{6,6},{7,7}},		--魔法暴击概率
	mfbjsh={{1,7},{8,14},{15,21},{22,29},{30,37},{38,45},{46,53}},		--魔法暴击伤害
	fjsh={{1,3},{4,6},{7,9},{10,12},{13,15},{16,18},{19,21}},--附加伤害
	zzsh={{1,2},{3,4},{5,6},{7,8},{9,10},{11,12},{13,14}},	--最终伤害
	grjndj={{1,1},{1,1},{1,1},{1,1},{1,1},{1,1},{2,2}},		--个人技能等级
	--ggjndj={{1,1},{2,2},{3,3},{4,4},{5,5},{5,5}},		--公共技能等级
	shjm={{1,3},{4,6},{7,9},{10,12},{13,15},{16,18},{19,21}},---伤害减免
	shhm={{0.1,0.5},{0.6,1},{1.1,1.5},{1.6,2},{2.1,2.5},{2.6,3},{3.1,3.5}},		--伤害豁免
	rx={{1,2},{3,4},{5,6},{7,8},{9,10},{11,12},{13,14}},		--韧性
	--zyyj={},
	--xyz={},
}


_G.Rare_Pro_zdl={
	10,
	20,
	40,
	80,
	160,
	320,
	640,		
}

function Weightsgetvalue_one(wtable)
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

function Spawnitemgivehero( hero,itemname)
	local newItem = CreateRandomItem(itemname)
	hero:AddItem(newItem)	
	return newItem
end

---根据名字创造随机装备实体
function CreateRandomItem(baseItemName)
	local buff_list={}
	local rare = {}
	local time = SjTime
	local itemlevel =SjLevel[time]
	local dbpz = SjPz[time]
	if dbpz == 1 then
		rare={0,30000,12000,4000,300,20,1}	--至少会开出优良装备
	end
	if dbpz == 2 then
		rare={0,0,12000,3000,300,20,1}
	end
	if dbpz == 3 then
		rare={0,0,0,30000,3000,200,10}
	end
	if dbpz == 4 then
		rare={0,0,0,0,3000,200,10}
	end
	if dbpz == 5  then
		rare={0,0,0,0,0,400,20}
	end
	if dbpz == 6  then
		rare={0,0,0,0,0,0,200}	--由于权重方法小于100会出现BUG，怕出问题，先不改方法，所以数值之和必须大于100，
	end

	local itemrare=Weightsgetvalue_one(rare)  --随机装备品质，普通（白色1）优良（绿色2）稀有（蓝色3）极品（紫色4）史诗（橙色5）传奇（金色6）神话（红色7）
	local self = CreateItem(baseItemName.."_lv"..itemrare, nil, nil )
	
	
	
	
	
	return self;
end


function SpawnitemEntity( unit,itemname,spawnPoint)

	local newItem = CreateRandomItem(itemname)
	newItem.SjTime = SjTime
	
	
	CreateItemOnGround(newItem,nil,spawnPoint,300,true)
	newItem:EmitSound("Item.DropGemShop")
end


--物品掉落
function itemdrop(unit,monster)
	local monstername=monster:GetUnitName()
	local monsterlevel=monster:GetLevel()

	local itemlevel=math.ceil(monsterlevel/30)--物品等阶	--根据怪物的等级来获得物品等阶
	if itemlevel>7 then
		itemlevel = 7
	end
	local dropitemnum=0 ---掉落次数
	if Wild_Monster_Burst_Rate[monstername]==nil then
		dropitemnum=0
		return
	end
	local dropweight=math.ceil(Wild_Monster_Burst_Rate[monstername])
	local dbl =  monster.dbl  --获得单位的掉宝倍率，没有就默认为1
	if dbl== nil then
		dbl = 1
	end
	local dbpz =  monster.dbpz  --获得单位的掉宝品质
	--品质1 ，必爆优良以上的装备
	--品质2 ，必爆稀有以上的装备
	--品质3 ，必爆极品以上的装备
	--品质4 ，必爆史诗色以上的装备
	--品质5 ，必爆传奇色以上的装备
	--品质6 ，必爆神话品质装备
	if dbpz== nil then
		dbpz = 1
	end
	dropweight = dropweight * dbl  --提高掉宝品质会降低物品的爆的数量

	if dropweight<1 then  --权重最低不会小于1
		dropweight =1
	end
	if dropweight>=1000 then
		while( dropweight >= 1000 )
		do
		   dropitemnum=dropitemnum+1
		   dropweight = dropweight-1000
		   
		end
	end

	if RandomInt(1,1000)<=dropweight then
		dropitemnum=dropitemnum+1
	end
	
	if dropitemnum==0 then
		return false
	end

	local rare={}
	for k,v in pairs(Item_Rare) do
		table.insert(rare,v.weight)
	end
	for i=1,dropitemnum do
		local itemtype=Weightsgetvalue_one(Item_Type) --衣服武器首饰等物品类型 
		--local itemrare=Weightsgetvalue_one(rare)
		local itemname=""
		if itemtype==1 then
			itemname= Item_Pro_Weight['wq']['item'][RandomInt(1,#Item_Pro_Weight['wq']['item'])]
		end
		if itemtype==2 then
			itemname= Item_Pro_Weight['fj']['item'][RandomInt(1,#Item_Pro_Weight['fj']['item'])]
		end
		if itemtype==3 then
			itemname= Item_Pro_Weight['sp']['item'][RandomInt(1,#Item_Pro_Weight['sp']['item'])]
		end
		if itemtype==4 then
			itemname= Item_Pro_Weight['fz']['item'][RandomInt(1,#Item_Pro_Weight['fz']['item'])]
		end
		if itemtype==5 then
			itemname= Item_Pro_Weight['sy']['item'][RandomInt(1,#Item_Pro_Weight['sy']['item'])]
		end
		
		--local newItem = CreateItem( itemname, nil, nil )
		--newItem:SetLevel(itemrare)
		--print(newItem:GetLevel())
		--unit:AddItem(newItem)
		SjTime = SjTime +1
		SjLevel[SjTime]= itemlevel
		SjPz[SjTime] = dbpz
		SpawnitemEntity(unit,itemname,monster:GetOrigin())
	end
	return 1
end


--给予指定等阶指定品质的随机装备
--玩家ID
--装备品质
	--品质1 ，必爆优良以上的装备
	--品质2 ，必爆稀有以上的装备
	--品质3 ，必爆极品以上的装备
	--品质4 ，必爆史诗色以上的装备
	--品质5 ，必爆传奇色以上的装备
	--品质6 ，必爆神话品质装备
--掉落几件装备
function itemgive(playerID,pz,dropitemnum)
	local hero = PlayerUtil.GetHero(playerID)
	
	local itemlevel  = math.ceil(hero:GetLevel()/30) +1

	if itemlevel>7 then
		itemlevel = 7
	end
	local dbpz =  pz  --获得单位的掉宝品质
	
	if dbpz== nil then
		dbpz = 1
	end

	local rare={}
	for k,v in pairs(Item_Rare) do
		table.insert(rare,v.weight)
	end
	for i=1,dropitemnum do
		local itemtype=Weightsgetvalue_one(Item_Type) --衣服武器首饰等物品类型 
		local itemrare=Weightsgetvalue_one(rare)
		local itemname=""
		if itemtype==1 then
			itemname= Item_Pro_Weight['wq']['item'][RandomInt(1,#Item_Pro_Weight['wq']['item'])]
		end
		if itemtype==2 then
			itemname= Item_Pro_Weight['fj']['item'][RandomInt(1,#Item_Pro_Weight['fj']['item'])]
		end
		if itemtype==3 then
			itemname= Item_Pro_Weight['sp']['item'][RandomInt(1,#Item_Pro_Weight['sp']['item'])]
		end
		if itemtype==4 then
			itemname= Item_Pro_Weight['fz']['item'][RandomInt(1,#Item_Pro_Weight['fz']['item'])]
		end
		if itemtype==5 then
			itemname= Item_Pro_Weight['sy']['item'][RandomInt(1,#Item_Pro_Weight['sy']['item'])]
		end

		SjTime = SjTime +1
		SjLevel[SjTime]= itemlevel
		SjPz[SjTime] = dbpz
		return Spawnitemgivehero(hero,itemname)
	end	
end


_G.BaoWu2={
	modifier_bw_1_1={	--守护指环
		maxnum=0,		--宝物的最大数量，当宝物数量为0时，则不会被选择，或者宝物有问题，也可以设置为0
		level=1,		--宝物的等阶。	0为全等阶宝物，
		weight=20,		--宝物的权重
	},
	modifier_bw_1_2={	--治疗指环
		maxnum=5,		
		level=1,	
		weight=7500,	
	},
	modifier_bw_1_3={	--魔法指环
		maxnum=5,		
		level=1,		
		weight=7500,	
	},
	modifier_bw_1_4={	--力量护腕
		maxnum=4,		
		level=1,		
		weight=7500,		
	},
	modifier_bw_1_5={	--怨灵细带
		maxnum=5,		
		level=1,		
		weight=7500,		
	},
	modifier_bw_1_6={	--空灵挂件
		maxnum=5,		
		level=1,		
		weight=7500,		
	},
	modifier_bw_1_7={	--王冠
		maxnum=5,		
		level=1,		
		weight=7500,		
	},
	modifier_bw_1_8={	--贤者石
		maxnum=5,		
		level=1,		
		weight=7500,		
	},
	modifier_bw_1_9={	--金币宝藏
		maxnum=5,		
		level=1,		
		weight=7500,		
	},
	modifier_bw_1_10={	--经验宝藏
		maxnum=5,		
		level=1,		
		weight=7500,		
	},
	modifier_bw_1_11={	--扫帚柄
		maxnum=1,		
		level=1,		
		weight=7500,		
	},
	modifier_bw_1_12={	--杀猪刀
		maxnum=1,		
		level=1,		
		weight=7500,		
	},
	modifier_bw_1_13={	--基恩镜片
		maxnum=1,		
		level=1,		
		weight=7500,		
	},
	modifier_bw_1_14={	--奥术指环
		maxnum=1,		
		level=1,		
		weight=7500,		
	},

	modifier_bw_2_1={	--刃甲
		maxnum=1,		
		level=2,		
		weight=6000,		
	},
	modifier_bw_2_2={	--挑战头巾
		maxnum=1,		
		level=2,		
		weight=6000,		
	},
	modifier_bw_2_3={	--水晶剑
		maxnum=1,		
		level=2,		
		weight=6000,		
	},
	modifier_bw_2_4={	--慧光
		maxnum=1,		
		level=2,		
		weight=6000,		
	},
	modifier_bw_2_5={	--夜叉
		maxnum=1,		
		level=2,		
		weight=6000,		
	},
	modifier_bw_2_6={	--散华
		maxnum=1,		
		level=2,		
		weight=6000,		
	},
	modifier_bw_2_7={	--梅肯斯姆
		maxnum=1,		
		level=2,		
		weight=6000,		
	},
	modifier_bw_2_8={	--韧鼓
		maxnum=1,		
		level=2,		
		weight=6000,		
	},
	modifier_bw_2_9={	--动力鞋
		maxnum=1,		
		level=2,		
		weight=6000,		
	},
	modifier_bw_2_10={	--莫尔迪基安的臂章
		maxnum=1,		
		level=2,		
		weight=6000,		
	},
	modifier_bw_2_11={	--先锋盾
		maxnum=1,		
		level=2,		
		weight=6000,		
	},
	modifier_bw_2_12={	--魔龙枪
		maxnum=1,		
		level=2,		
		weight=6000,		
	},
	modifier_bw_2_13={	--漩涡
		maxnum=1,		
		level=2,		
		weight=6000,		
	},
	modifier_bw_2_14={	--幽冥披巾
		maxnum=1,		
		level=2,		
		weight=6000,		
	},
	modifier_bw_2_15={	--林野长弓
		maxnum=1,		
		level=2,		
		weight=6000,		
	},
	modifier_bw_2_16={	--学徒之礼
		maxnum=1,		
		level=2,		
		weight=6000,		
	},
	modifier_bw_2_17={	--崎岖外衣
		maxnum=1,		
		level=2,		
		weight=6000,		
	},
	modifier_bw_2_18={	--无知小帽
		maxnum=1,		
		level=2,		
		weight=1000,		
	},
	modifier_bw_2_19={	--加速护符
		maxnum=1,		
		level=2,		
		weight=6000,		
	},
	modifier_bw_2_20={	--精华指环
		maxnum=1,		
		level=2,		
		weight=6000,		
	},
	modifier_bw_2_21={	--EUL的神圣法杖
		maxnum=1,		
		level=2,		
		weight=6000,		
	},
	modifier_bw_2_22={	--以太之境
		maxnum=1,		
		level=2,		
		weight=6000,		
	},
	modifier_bw_2_23={	--暗淡胸针
		maxnum=1,		
		level=2,		
		weight=6000,		
	},
	modifier_bw_2_24={	--海洋之心
		maxnum=1,		
		level=2,		
		weight=6000,		
		},
	modifier_bw_2_25={	--迈达斯之手
		maxnum=1,		
		level=2,		
		weight=6000,		
	},
	modifier_bw_2_26={	--剥皮刀
		maxnum=1,		
		level=2,		
		weight=6000,		
	},
	modifier_bw_2_27={	--影之灵龛
		maxnum=1,		
		level=2,		
		weight=6000,		
	},


	modifier_bw_3_1={	--魔力箭袋
		maxnum=1,		
		level=3,		
		weight=4444,		
	},
	modifier_bw_3_2={	--骑士剑
		maxnum=1,		
		level=3,		
		weight=4444,		
	},
	modifier_bw_3_3={	--巨神残铁
		maxnum=1,		
		level=3,		
		weight=4444,		
	},
	modifier_bw_3_4={	--智灭
		maxnum=1,		
		level=3,		
		weight=4444,		
	},
	modifier_bw_3_5={	--永恒遗物
		maxnum=1,		
		level=3,		
		weight=4444,		
	},
	modifier_bw_3_6={	--法术棱镜
		maxnum=1,		
		level=3,		
		weight=4444,		
	},
	modifier_bw_3_7={	--神妙明灯
		maxnum=1,		
		level=3,		
		weight=4444,		
	},
	modifier_bw_3_8={	--幻术师披风
		maxnum=0,		
		level=3,		
		weight=4444,		
	},
	modifier_bw_3_9={	--浩劫巨锤
		maxnum=1,		
		level=3,		
		weight=4444,		
	},
	modifier_bw_3_10={	--黯灭
		maxnum=1,		
		level=3,		
		weight=4444,		
	},
	modifier_bw_3_11={	--雷神之锤
		maxnum=1,		
		level=3,		
		weight=4444,		
	},
	modifier_bw_3_12={	--蝴蝶
		maxnum=1,		
		level=3,		
		weight=4444,		
	},
	modifier_bw_3_13={	--代达罗斯之殇
		maxnum=1,		
		level=3,		
		weight=4444,		
	},
	modifier_bw_3_14={	--撒旦邪之力
		maxnum=1,		
		level=3,		
		weight=1000,		
	},
	modifier_bw_3_15={	--恐鳌之心
		maxnum=1,		
		level=3,		
		weight=1000,		
	},
	modifier_bw_3_16={	--强袭胸甲
		maxnum=1,		
		level=3,		
		weight=4444,		
	},
	modifier_bw_3_17={	--血精石
		maxnum=1,		
		level=3,		
		weight=4444,		
	},
	modifier_bw_3_18={	--玲珑心
		maxnum=1,		
		level=3,		
		weight=4444,		
	},
	modifier_bw_3_19={	--纷争面纱
		maxnum=1,		
		level=3,		
		weight=4444,		
	},
	modifier_bw_3_20={	--达贡之神力
		maxnum=1,		
		level=3,		
		weight=4444,		
	},
	modifier_bw_3_21={	--炼金之手
		maxnum=1,		
		level=3,		
		weight=4444,		
	},
	modifier_bw_3_22={	--贤者之刃
		maxnum=1,		
		level=3,		
		weight=4444,		
	},
	modifier_bw_3_23={	--魂之灵龛
		maxnum=1,		
		level=3,		
		weight=4444,		
	},



	modifier_bw_4_1={	--原力鞋
		maxnum=1,		
		level=4,		
		weight=2500,		
	},
	modifier_bw_4_2={	--寂灭
		maxnum=1,		
		level=4,		
		weight=2500,		
	},
	modifier_bw_4_3={	--神盾镜
		maxnum=1,		
		level=4,		
		weight=2500,		
	},
	modifier_bw_4_4={	--极
		maxnum=1,		
		level=4,		
		weight=2500,		
	},
	modifier_bw_4_5={	--弩炮
		maxnum=1,		
		level=4,		
		weight=2500,		
	},
	modifier_bw_4_6={	--三元重戟
		maxnum=1,		
		level=4,		
		weight=800,		
	},
	modifier_bw_4_7={	--疯狂的海盗帽
		maxnum=1,		
		level=4,		
		weight=1333,		
	},
	modifier_bw_4_8={	--先哲之石
		maxnum=1,		
		level=4,		
		weight=1333,		
	},
	modifier_bw_5_1={	--逐风者的祝福之剑
		maxnum=1,		
		level=5,		
		weight=750,		
	},
	modifier_bw_5_2={	--虚灵法杖
		maxnum=1,		
		level=5,		
		weight=750,		
	},
	modifier_bw_5_3={	--裂魂之剑
		maxnum=1,		
		level=5,		
		weight=750,		
	},
	modifier_bw_5_4={	--艾萨拉女王的浴衣
		maxnum=1,		
		level=5,		
		weight=750,		
	},
	modifier_bw_5_5={	--群星之怒
		maxnum=1,		
		level=5,		
		weight=750,		
	},
	modifier_bw_5_6={	--天灾骨钟
		maxnum=1,		
		level=5,		
		weight=750,		
	},
	modifier_bw_5_7={	--天堂审判·米迦勒之剑
		maxnum=1,		
		level=5,		
		weight=750,		
	},
	modifier_bw_5_8={	--无尽长夜法杖
		maxnum=1,		
		level=5,		
		weight=750,		
	},
	modifier_bw_5_9={	--卡拉波水晶之塔
		maxnum=1,		
		level=5,		
		weight=750,		
	},
	modifier_bw_5_10={	--恶魔之爪
		maxnum=1,		
		level=5,		
		weight=750,		
	},

	modifier_bw_5_11={	--圣剑
		maxnum=1,		
		level=5,		
		weight=750,		
	},
	modifier_bw_all_1={	--电锯惊魂
		maxnum=1,		
		level=0,		
		weight=100,		
		rare = 2,  --代表几级的神秘宝物
	},
	modifier_bw_all_2={	--皇者之路
		maxnum=1,		
		level=0,		
		weight=30,		
		rare = 4,
	},
	modifier_bw_all_3={	--沉默的羔羊
		maxnum=1,		
		level=0,		
		weight=30,	
		rare = 4,	
	},
	modifier_bw_all_4={	--内家拳
		maxnum=1,		
		level=0,		
		weight=50,	
		rare = 4,	
	},
	modifier_bw_all_5={	--力量偏科
		maxnum=1,		
		level=0,		
		weight=200,		
		rare = 1,
	},
	modifier_bw_all_6={	--敏捷偏科
		maxnum=1,		
		level=0,		
		weight=200,		
		rare = 1,
	},
	modifier_bw_all_7={	--智力偏科
		maxnum=1,		
		level=0,		
		weight=200,		
		rare = 1,
	},
	modifier_bw_all_8={	--法术偏科
		maxnum=1,		
		level=0,		
		weight=200,		
		rare = 1,
	},
	modifier_bw_all_9={	--孤注一掷
		maxnum=0,		--设置护甲的时候可能会出问题，先设置为1，不可重复
		level=0,		
		weight=50,		
	},
	modifier_bw_all_10={	--保命要紧
		maxnum=0,		--设置护甲的时候可能会出问题，先设置为1，不可重复
		level=0,		
		weight=50,		
	},
	modifier_bw_all_11={	--愿赌服输
		maxnum=0,		--设置护甲的时候可能会出问题，先设置为1，不可重复
		level=0,		
		weight=50,		
	},
	modifier_bw_all_12={	--宿敌克星
		maxnum=1,		
		level=0,		
		weight=100,		
	},
	modifier_bw_all_13={	--格斗箭术
		maxnum=1,		
		level=0,		
		weight=100,		
	},
	modifier_bw_all_14={	--狙击手
		maxnum=1,		
		level=0,		
		weight=100,		
	},
	modifier_bw_all_15={	--巨人化
		maxnum=1,		
		level=0,		
		weight=100,		
	},
	modifier_bw_all_16={	--快速恢复
		maxnum=10,		
		level=0,		
		weight=500,		
		rare = 1,
	},
	modifier_bw_all_17={	--智力冥想
		maxnum=1,		
		level=0,		
		weight=500,		
		rare = 1,
	},
	modifier_bw_all_18={	--提升体质
		maxnum=10,		
		level=0,		
		weight=200,		
		rare = 1,
	},
	modifier_bw_all_19={	--提升力量
		maxnum=10,		
		level=0,		
		weight=200,		
		rare = 1,
	},
	modifier_bw_all_20={	--提升敏捷
		maxnum=10,		
		level=0,		
		weight=200,	
		rare = 1,	
	},
	modifier_bw_all_21={	--提升智力
		maxnum=10,		
		level=0,		
		weight=200,		
		rare = 1,
	},
	modifier_bw_all_22={	--提升攻击
		maxnum=10,		
		level=0,		
		weight=200,		
		rare = 1,
	},
	modifier_bw_all_23={	--提升护甲
		maxnum=10,		
		level=0,		
		weight=200,		
		rare = 1,
	},
	modifier_bw_all_24={	--提高灵巧
		maxnum=10,		
		level=0,		
		weight=500,		
		rare = 1,
	},
	modifier_bw_all_25={	--强化施法
		maxnum=10,		
		level=0,		
		weight=500,		
		rare = 1,
	},
	modifier_bw_all_26={	--超远射
		maxnum=10,		
		level=0,		
		weight=200,		
		rare = 2,
	},
	modifier_bw_all_27={	--多重射击
		maxnum=1,		
		level=0,		
		weight=300,		
		rare = 2,
	},
	modifier_bw_all_28={	--重击
		maxnum=1,		
		level=0,		
		weight=100,		
	},
	modifier_bw_all_29={	--先发制人
		maxnum=1,		
		level=0,		
		weight=100,		
	},
	modifier_bw_all_30={	--强人所难
		maxnum=1,		
		level=0,		
		weight=100,		
	},
	modifier_bw_all_31={	--伤害豁免
		maxnum=1,		
		level=0,		
		weight=100,		
	},
	modifier_bw_all_32={	--集束箭
		maxnum=0,			--无法实现，先取消
		level=0,		
		weight=10,		
	},
	modifier_bw_all_33={	--博格达之锤
		maxnum=1,		
		level=0,		
		weight=50,		
	},
	modifier_bw_all_34={	--钻石化
		maxnum=1,		
		level=0,		
		weight=100,		
		rare = 2,
	},
	modifier_bw_all_35={	--奥术节能
		maxnum=5,		
		level=0,		
		weight=300,		
		rare = 1,
	},
	modifier_bw_all_39={	--炼金石
		maxnum=1,		
		level=0,		
		weight=1000,	
		rare = 1,	
	},
	modifier_bw_all_40={	--智慧石
		maxnum=1,		
		level=0,		
		weight=1000,		
		rare = 1,
	},
	modifier_bw_all_41={	--地狱火
		maxnum=10,		
		level=0,		
		weight=200,		
		rare = 2,
	},
	modifier_bw_all_42={	--群蛇守卫
		maxnum=10,		
		level=0,		
		weight=200,		
		rare = 2,
	},
	modifier_bw_all_43={	--死亡守卫
		maxnum=10,		
		level=0,		
		weight=200,		
		rare = 2,
	},
	modifier_bw_all_44={	--掠夺之斧
		maxnum=1,		
		level=0,		
		weight=10,		
		rare = 4,
	},
	modifier_bw_all_45={	--贪魔面具
		maxnum=1,		
		level=0,		
		weight=30,		
		rare = 4,
	},
	modifier_bw_all_46={	--财富宝瓶
		maxnum=1,		
		level=0,		
		weight=100,		
		rare = 2,
	},
	modifier_bw_all_47={	--勇气之心
		maxnum=1,		
		level=0,		
		weight=60,		
		rare = 3,
	},
	modifier_bw_all_48={	--死亡回溯
		maxnum=0,		
		level=0,		
		weight=100,		
		rare = 3,
	},
	modifier_bw_all_49={	--死亡之吻
		maxnum=1,		
		level=0,		
		weight=50,		
		rare = 3,
	},
	modifier_bw_all_50={	--死亡回归
		maxnum=1,		
		level=0,		
		weight=5,		
		rare = 3,
	},
	modifier_bw_all_51={	--高级炼金石
		maxnum=1,		
		level=0,		
		weight=40,		
		rare = 3,
	},
	modifier_bw_all_52={	--高级智慧石
		maxnum=1,		
		level=0,		
		weight=40,		
		rare = 3,
	},
	modifier_bw_all_53={	--黄金神石
		maxnum=1,		
		level=0,		
		weight=10,		
		rare = 4,
	},
	modifier_bw_all_54={	--智慧女神的权杖
		maxnum=1,		
		level=0,		
		weight=10,	
		rare = 4,	
	},
	modifier_bw_all_55={	--智慧女神的皇冠
		maxnum=1,		
		level=0,		
		weight=80,		
		rare = 3,
	},
	modifier_bw_all_56={	--神格--碎裂
		maxnum=1,		
		level=0,		
		weight=20,	
		rare = 4,	
	},
	modifier_bw_all_57={	--宝物管理员
		maxnum=1,		
		level=0,		
		weight=50,		
		rare = 3,
	},
	modifier_bw_all_58={	--宝物箱-小
		maxnum=1,		
		level=0,		
		weight=500,		
		rare = 1,
	},
	modifier_bw_all_59={	--宝物箱-中
		maxnum=1,		
		level=0,		
		weight=100,		
		rare = 2,
	},
	modifier_bw_all_60={	--宝物箱-大
		maxnum=1,		
		level=0,		
		weight=50,		
		rare = 3,
	},
	modifier_bw_all_61={	--图书证-银卡
		maxnum=1,		
		level=0,		
		weight=400,		
		rare = 2,
	},
	modifier_bw_all_62={	--图书证-金卡
		maxnum=1,		
		level=0,		
		weight=70,		
		rare = 3,
	},
	modifier_bw_all_63={	--图书证-钻石卡
		maxnum=1,		
		level=0,		
		weight=15,		
		rare = 4,
	},
	modifier_bw_all_64={	--图书证-黑曜卡
		maxnum=1,		
		level=0,		
		weight=1,		
		rare = 5,
	},
	modifier_bw_all_65={	--神格
		maxnum=1,		
		level=0,		
		weight=1,		
		rare = 5,
	},
	modifier_bw_all_66={	--萃取之刃
		maxnum=1,		
		level=0,		
		weight=400,		
		rare = 1,
	},
	modifier_bw_all_67={	--吞噬之刃
		maxnum=1,		
		level=0,		
		weight=160,		
		rare = 2,
	},
	modifier_bw_all_68={	--召唤之镰
		maxnum=1,		
		level=0,		
		weight=500,	
		rare = 1,	
	},
	modifier_bw_all_69={	--野性之心
		maxnum=1,		
		level=0,		
		weight=100,		
		rare = 3,
	},
	modifier_bw_all_70={	--大地图腾
		maxnum=1,		
		level=0,		
		weight=30,		
		rare = 4,
	},
	modifier_bw_all_71={	--图书管理员
		maxnum=1,		
		level=0,		
		weight=50,	
		rare = 4,	
	},
	modifier_bw_all_72={	--初级铁匠
		maxnum=1,		
		level=0,		
		weight=500,		
		rare = 2,
	},
	modifier_bw_all_73={	--中级铁匠
		maxnum=1,		
		level=0,		
		weight=100,		
		rare = 3,
	},
	modifier_bw_all_74={	--高级铁匠	
		maxnum=1,		
		level=0,		
		weight=30,		
		rare = 4,
	},
	modifier_bw_all_75={	--匠神	
		maxnum=1,		
		level=0,		
		weight=2,	
		rare = 5,	
	},
	modifier_bw_all_76={	--潘多拉之心
		maxnum=1,		
		level=0,		
		weight=300,		
		rare = 2,
	},
	modifier_bw_all_77={	--龙气
		maxnum=1,		
		level=0,		
		weight=75,		
		rare = 3,
	},
	modifier_bw_all_78={	--黄金之盾
		maxnum=1,		
		level=0,		
		weight=50,		
		rare = 3,
	},
	modifier_bw_all_79={	--怨念-小
		maxnum=1,		
		level=0,		
		weight=500,		
		rare = 1,
	},
	modifier_bw_all_80={	--怨念-中
		maxnum=1,		
		level=0,		
		weight=80,		
		rare = 3,
	},
	modifier_bw_all_81={	--怨念-大
		maxnum=1,		
		level=0,		
		weight=20,	
		rare = 4,	
	},
	modifier_bw_all_82={	--怨念-超
		maxnum=1,		
		level=0,		
		weight=1,	
		rare = 5,	
	},
	modifier_bw_all_83={	--怨念之息
		maxnum=1,		
		level=0,		
		weight=400,		
		rare = 1,
	},
	modifier_bw_all_84={	--怨念之骨
		maxnum=1,		
		level=0,		
		weight=80,		
		rare = 3,
	},
	modifier_bw_all_85={	--怨念之心
		maxnum=1,		
		level=0,		
		weight=20,		
		rare = 4,
	},
	modifier_bw_all_86={	--冤魂之心
		maxnum=1,		
		level=0,		
		weight=1,	
		rare = 5,	
	},
	modifier_bw_all_87={	--英灵附体
		maxnum=1,		
		level=0,		
		weight=100,	
		rare = 2,	
	},
	modifier_bw_all_88={	--炙热之火
		maxnum=0,		
		level=0,		
		weight=100,		
		rare = 2,
	},
	modifier_bw_all_89={	--冰冻之息
		maxnum=1,		
		level=0,		
		weight=100,		
		rare = 2,
	},
	modifier_bw_all_90={	--女王鞭笞
		maxnum=1,		
		level=0,		
		weight=100,		
		rare = 2,
	},
	modifier_bw_all_91={	--时间河流
		maxnum=1,		
		level=0,		
		weight=15,		
		rare = 4,
	},
	modifier_bw_all_92={	--生命源泉
		maxnum=1,		
		level=0,		
		weight=30,		
		rare = 4,
	},
	modifier_bw_all_93={	--跳跃--力 
		maxnum=1,		
		level=0,		
		weight=200,	
		rare = 2,	
	},
	modifier_bw_all_94={	--跳跃--敏
		maxnum=1,		
		level=0,		
		weight=200,	
		rare = 2,	
	},
	modifier_bw_all_95={	--跳跃--智
		maxnum=1,		
		level=0,		
		weight=200,		
		rare = 2,
	},
	modifier_bw_all_96={	--激怒号角
		maxnum=1,		
		level=0,		
		weight=100,		
		rare = 3,
	},
	modifier_bw_all_97={	--痛苦面具
		maxnum=1,		
		level=0,		
		weight=30,	
		rare = 4,	
	},
	modifier_bw_all_98={	--压制战刃
		maxnum=1,		
		level=0,		
		weight=80,		
		rare = 3,
	},
	modifier_bw_all_99={	--剜心匕首
		maxnum=1,		
		level=0,		
		weight=50,
		rare = 3,		
	},
	modifier_bw_all_100={	--聚合长袍  有bug
		maxnum=0,		
		level=0,		
		weight=30,		
	},
	modifier_bw_all_101={	--法神秘典
		maxnum=1,		
		level=0,		
		weight=30,		
		rare = 4,
	},

	
}
for modifierName, config in pairs(BaoWu2) do
	local count = config.maxnum or 0
	config.maxnum = {count,count,count,count}
end

_G.EnhanceTimes={
	[2]={
		--随机装备品质，普通（白色1）优良（绿色2）稀有（蓝色3）极品（紫色4）史诗（橙色5）传奇（金色6）神话（红色7）
		[2]=2,
		[3]=2,
		[4]=3,
		[5]=3,
		[6]=4,
		[7]=5,
	},
	[3]={
		--随机装备品质，普通（白色1）优良（绿色2）稀有（蓝色3）极品（紫色4）史诗（橙色5）传奇（金色6）神话（红色7）
		[2]=3,
		[3]=3,
		[4]=4,
		[5]=4,
		[6]=5,
		[7]=6,
	},
	[4]={
		--随机装备品质，普通（白色1）优良（绿色2）稀有（蓝色3）极品（紫色4）史诗（橙色5）传奇（金色6）神话（红色7）
		[2]=4,
		[3]=4,
		[4]=5,
		[5]=5,
		[6]=6,
		[7]=7,
	},
	[5]={
		--随机装备品质，普通（白色1）优良（绿色2）稀有（蓝色3）极品（紫色4）史诗（橙色5）传奇（金色6）神话（红色7）
		[2]=5,
		[3]=5,
		[4]=6,
		[5]=6,
		[6]=7,
		[7]=8,
	},
	[6]={
		--随机装备品质，普通（白色1）优良（绿色2）稀有（蓝色3）极品（紫色4）史诗（橙色5）传奇（金色6）神话（红色7）
		[2]=6,
		[3]=6,
		[4]=7,
		[5]=7,
		[6]=8,
		[7]=9,
	},
	[7]={
		--随机装备品质，普通（白色1）优良（绿色2）稀有（蓝色3）极品（紫色4）史诗（橙色5）传奇（金色6）神话（红色7）
		[2]=7,
		[3]=7,
		[4]=8,
		[5]=8,
		[6]=9,
		[7]=10,
	},
	[8]={
		--随机装备品质，普通（白色1）优良（绿色2）稀有（蓝色3）极品（紫色4）史诗（橙色5）传奇（金色6）神话（红色7）
		[2]=7,
		[3]=7,
		[4]=8,
		[5]=8,
		[6]=9,
		[7]=10,
	},
	[9]={
		--随机装备品质，普通（白色1）优良（绿色2）稀有（蓝色3）极品（紫色4）史诗（橙色5）传奇（金色6）神话（红色7）
		[2]=7,
		[3]=7,
		[4]=8,
		[5]=9,
		[6]=10,
		[7]=11,
	},


}
_G.EnhanceRoll={
	[1]=100,
	[2]=90,
	[3]=80,
	[4]=70,
	[5]=60,
	[6]=50,
	[7]=40,
	[8]=30,
	[9]=20,
	[10]=15,
	[11]=10,
	
}

_G.Enhance_qhjc={
	[0]=0,
	[1]=2,
	[2]=4,
	[3]=7,
	[4]=10,
	[5]=14,
	[6]=19,
	[7]=25,	
	[8]=32,	
	[9]=40,	
	[10]=50,
	[11]=65,	
}
--强化石消耗
_G.Enhance_qhxh={
	[1]=10,
	[2]=20,
	[3]=30,
	[4]=40,
	[5]=50,
	[6]=60,
	[7]=70,
	[8]=80,
	[9]=90,
	[10]=100,
	[11]=120,
}
--强化石名称
_G.Enhance_stonename={
	[2]="shopmall_sstone_2",
	[3]="shopmall_sstone_3",
	[4]="shopmall_sstone_4",
	[5]="shopmall_sstone_5",
	[6]="shopmall_sstone_6",
	[7]="shopmall_sstone_7",
	[8]="shopmall_sstone_8",
	[9]="shopmall_sstone_9",
}