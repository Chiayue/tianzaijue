


LinkLuaModifier( "modifiy_achi_hidden_2","lua_modifiers/achievement/modifiy_achi_hidden_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifiy_achi_hidden_3","lua_modifiers/achievement/modifiy_achi_hidden_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifiy_maplevel_3","lua_modifiers/achievement/modifiy_maplevel_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifiy_maplevel_10","lua_modifiers/achievement/modifiy_maplevel_10", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifiy_maplevel_11","lua_modifiers/achievement/modifiy_maplevel_11", LUA_MODIFIER_MOTION_NONE )
if Sachievement == nil then
	Sachievement = {}
	Sachievement.UnitAchi = {}
	Sachievement.UnitAchithis = {}--存放本局完成的成就用来批量发送服务器
	Sachievement.Hero_1 ="hero_str"
	Sachievement.Hero_2 ="hero_agi"
	Sachievement.Hero_3 ="hero_int"
	setmetatable(Sachievement,Sachievement)
	Sachievement.list={
		hero_single={--单英雄通关
				["1"]={--使用斧王每次升级额外+3力量  	sjjll
					bonus=1,--所需完成次数
					reward={Attr_sjPm=3,}
				},
				["2"]={--使用斧王通关三次（任意难度）使用主属性+30，使用斧王的最终伤害增加+5%   hero.zzsh
					bonus=3,--所需完成次数
					reward={Set_Pm=30}
				},
				["3"]={--使用斧王通关十次（任意难度）使用斧王每次杀敌 5% 概率 力量 +2  
					bonus=10,--所需完成次数
					reward={Attr_zzsh=5,}
				},
				["4"]={--使用斧王通关三十次（任意难度）使用斧王英雄天赋等级+1   
					bonus=20,--所需完成次数
					reward={Attr_sjPm=10,}
				},
				["5"]={--使用斧王通关一百次（任意难度）使用斧王英雄天赋等级+1
					bonus=30,--所需完成次数
					reward={Level_all=1,}
				},
		},
		hero_str={
				["1"]={--力量英雄通关  --使用任意英雄每次升级力量+3       	 hero.sjjll
					bonus=1,--所需完成次数
					heronum=10,--英雄所需个数
					reward={Attr_sjjll=3,}					
				},
				["2"]={--10个力量英雄的通关次数在三次以上：使用任意英雄初始力量+100 最终伤害+5%
					bonus=3,--所需完成次数
					heronum=10,--英雄所需个数
					reward={Set_ll=100,}
				},
				["3"]={--10个力量英雄的通关次数在十次以上：使用任意英雄每次杀敌 5% 概率 力量 +2    
					bonus=10,--所需完成次数
					heronum=10,--英雄所需个数
					reward={Attr_zzsh=10,}
				},
				["4"]={---10个力量英雄的通关次数在三十次以上：使用力量英雄天赋等级+1
					bonus=20,--所需完成次数
					heronum=10,--英雄所需个数
					reward={Attr_jyjc=20,}		
				},
				["5"]={---10个力量英雄的通关次数在一百次以上：使用力量英雄天赋等级+1
					bonus=30,--所需完成次数
					heronum=10,--英雄所需个数
					reward={Level_str=1,}
				},
		},
		hero_int={--力量英雄通关
				["1"]={--10个智力英雄的通关次数在一次以上：每次升级智力+3 		sjjzl
					bonus=1,--所需完成次数
					heronum=10,--英雄所需个数
					reward={Attr_sjjzl=3,}
				},
				["2"]={--10个力量英雄的通关次数在三次以上：使用任意英雄初始力量+100 最终伤害+5%
					bonus=3,--所需完成次数
					heronum=10,--英雄所需个数
					reward={Set_mj=100,}
				},
				["3"]={--10个力量英雄的通关次数在十次以上：使用任意英雄每次杀敌 5% 概率 力量 +2    
					bonus=10,--所需完成次数
					heronum=10,--英雄所需个数
					reward={Attr_zzsh=10,}
				},
				["4"]={---10个力量英雄的通关次数在三十次以上：使用力量英雄天赋等级+1
					bonus=20,--所需完成次数
					heronum=10,--英雄所需个数
					reward={Attr_jyjc=20,}		
				},
				["5"]={---10个力量英雄的通关次数在一百次以上：使用力量英雄天赋等级+1
					bonus=30,--所需完成次数
					heronum=10,--英雄所需个数
					reward={Level_int=1,}
				},
		},
		hero_agi={--力量英雄通关
				["1"]={--10个敏捷英雄的通关次数在一次以上：每次升级敏捷+3 		sjjmj
					bonus=1,--所需完成次数
					heronum=10,--英雄所需个数
					reward={Attr_sjjmj=3,}
				},
				["2"]={--10个力量英雄的通关次数在三次以上：使用任意英雄初始力量+30 最终伤害+5%
					bonus=3,--所需完成次数
					heronum=10,--英雄所需个数
					reward={Set_zl=100,}
				},
				["3"]={--10个力量英雄的通关次数在十次以上：使用任意英雄每次杀敌 5% 概率 力量 +2    
					bonus=10,--所需完成次数
					heronum=10,--英雄所需个数
					reward={Attr_zzsh=10,}
				},
				["4"]={---10个力量英雄的通关次数在三十次以上：使用力量英雄天赋等级+1
					bonus=20,--所需完成次数
					heronum=10,--英雄所需个数
					reward={Attr_jyjc=20,}		
				},
				["5"]={---10个力量英雄的通关次数在一百次以上：使用力量英雄天赋等级+1
					bonus=30,--所需完成次数
					heronum=10,--英雄所需个数
					reward={Level_agi=1,}
				},
		},
		hero_all={--全英雄通关 --其它成就达成则解锁   三系的通关次数在一次以上：暴击概率+5% 暴击伤害+20%
				["1"]={
					otherachi={
						hero_str_1=0,
						hero_int_1=0,
						hero_agi_1=0,
					},
					reward={Attr_wlbjsh=20,Attr_wlbjgl=5,Attr_mfbjsh=20,Attr_mfbjgl=5,}
				},
				["2"]={  ---三系的通关次数在三次以上：每次杀敌 5% 概率 全属性 +2  
					otherachi={
						hero_str_2=0,
						hero_int_2=0,
						hero_agi_2=0,
					},
					reward={Attr_jyjc=20,}
				},
				["3"]={ ---三系的通关次数在十次以上：物理，法术吸血+1%
					otherachi={
						hero_str_3=0,
						hero_int_3=0,
						hero_agi_3=0,
					},
					reward={Attr_wlxx=3,Attr_fsxx=3,}
				},
				["4"]={  --三系的通关次数在三十次以上：初始给与一件宝物  物品名：item_bw_1
					otherachi={
						hero_str_4=0,
						hero_int_4=0,
						hero_agi_4=0,
					},
					reward={Giveitem={"item_smbw_2"},}
				},
				["5"]={  ---三系的通关次数在一百次以上：暂定
					otherachi={
						hero_str_5=0,
						hero_int_5=0,
						hero_agi_5=0,
					},
					reward={Giveitem={"item_smbw_3"},}
				},
		},
		difficulty={
			["1"]={
				bonus=1,--所需完成次数  --通关难一	初始三维+30
				reward={Set_AllPRO=30,}
			},
			["2"]={
				bonus=2,--所需完成次数  --通关难二	金钱+20%
				reward={Attr_jqjc=20,}
			},
			["3"]={
				bonus=3,--所需完成次数  --通关难三	经验+20%   
				reward={Attr_jyjc=20,}
			},
			["4"]={
				bonus=4,--所需完成次数---通关难四	个人技能等级+1      hero.grjndj +1
				reward={Attr_grjndj=1,}
			},
			["5_1"]={
				bonus=5,--所需完成次数  
				reward={Giveitem={"item_bw_1"},}
			},
			["5_2"]={
				bonus=5,--所需完成次数   shopmall_26
				reward={Attr_wlct=2,}
			},
		

			["6_1"]={
				bonus=6,--所需完成次数  --通关难六	杀怪金币+30
				reward={Attr_sgzjjb=30,}
			},
			["6_3"]={
				bonus=6,--所需完成次数  shopmall_26
				reward={Attr_lqsj=2,}
			},
			
			["7_1"]={
				bonus=7,--所需完成次数  --通关难七 	初始给与一个物品 物品名：item_xhp_wzts_2
				reward={Giveitem={"item_xhp_wzts_2"}}
			},
			["7_4"]={
				bonus=7,--所需完成次数  shopmall_26
				reward={Attr_mfct=2,}
			},
			

			["8_1"]={
				bonus=8,--所需完成次数  --通关难八 	杀怪金币+20
				reward={Attr_msmjsds=10,}
			},
			["8_2"]={
				bonus=8,--所需完成次数  shopmall_27
				reward={Attr_wlct=2,}
			},
			
			["9_1"]={
				bonus=9,--所需完成次数  --通关难八 	杀怪金币+30
				reward={Attr_sds=500,}
			},
			["9_3"]={
				bonus=9,--所需完成次数  shopmall_27
				reward={Attr_lqsj=2,}
			},
	
			["10_1"]={
				bonus=10,--所需完成次数  --通关难八 	杀怪金币+30
				reward={Giveitem={"item_bw_1"},}
			},
			["10_4"]={
				bonus=10,--所需完成次数  shopmall_27
				reward={Attr_mfct=2,}
			},


			["11_1"]={
				bonus=11,--所需完成次数  --通关难八 	
				reward={Attr_wlbjsh=40,Attr_mfbjsh=40}
			},

			["11_5"]={
				bonus=11,--所需完成次数  
				reward={Attr_ydsd=10,}
			},


			["12_1"]={
				bonus=12,--所需完成次数  --通关难八 	
				reward={Giveitem={"item_xhp_wzts_3"}}
			},
			["12_5"]={
				bonus=12,--所需完成次数  
				reward={Attr_ydsd=10,}
			},


			["13_1"]={
				bonus=13,--所需完成次数  --通关难八 	
				reward={Attr_treasure=1,}
			},
			["13_6"]={
				bonus=13,--所需完成次数 
				reward={Attr_jqjc=10,}
			},

			["14_1"]={
				bonus=14,--所需完成次数  --通关难八 	
				reward={Giveitem={"item_smbw_1"}}
			},
			
			["14_7"]={
				bonus=14,--所需完成次数  
				reward={Attr_zzsh=10,}
			},

			["15_1"]={
				bonus=15,--所需完成次数  
				reward={Attr_tmz=10,}
			},
			["15_2"]={
				bonus=15,--所需完成次数 
				reward={Attr_wlct=2,}
			},

			["16_1"]={
				bonus=16,--所需完成次数  
				reward={Level_all=1,}
			},
			["16_2"]={
				bonus=16,--所需完成次数 
				reward={Attr_gjsd=1,}
			},
			

			["17_1"]={
				bonus=17,--所需完成次数  
				reward={Attr_yxtfdj=1,}
			},
			
			["17_3"]={
				bonus=17,--所需完成次数 
				reward={Attr_lqsj=1,}
			},
			

			["18_1"]={
				bonus=18,--所需完成次数  
				reward={Giveitem={"item_xhp_wzts_4"}}
			},
			
			["18_3"]={
				bonus=18,--所需完成次数 
				reward={Attr_lqsj=1,}
			},
			

			["19_1"]={
				bonus=19,--所需完成次数  
				reward={Attr_jnmjts=0.2,}
			},
			
			["19_4"]={
				bonus=19,--所需完成次数  
				reward={Attr_mfhf=5,}
			},


			["20_1"]={
				bonus=20,--所需完成次数  
				reward={Giveitem={"item_smbw_2"}}
			},
			
			["20_5"]={
				bonus=20,--所需完成次数 
				reward={Attr_ydsd=10,}
			},
			

			["21_1"]={
				bonus=21,--所需完成次数  
				reward={Giveitem={"item_xhp_sjboss_1_5"}}
			},
			
			["21_6"]={
				bonus=21,--所需完成次数 
				reward={Attr_jqjc=10,}
			},
			

			["22_1"]={
				bonus=22,--所需完成次数  
				reward={Attr_tmz=15,}
			},
			["22_7"]={
				bonus=22,--所需完成次数  
				reward={Attr_zzsh=10,}
			},



			["23_1"]={
				bonus=23,--所需完成次数  
				reward={Attr_tmz=10,}
			},
			["23_2"]={
				bonus=23,--所需完成次数  
				reward={Attr_zzsh=0.5,}
			},

			["24_1"]={
				bonus=24,--所需完成次数  
				reward={Attr_fjsh=15,}
			},
			["24_3"]={
				bonus=24,--所需完成次数  
				reward={Attr_zzsh=0.5,}
			},

			["25_1"]={
				bonus=25,--所需完成次数  
				reward={Attr_jqjc=15,Attr_jyjc=15}
			},
			["25_4"]={
				bonus=25,--所需完成次数  
				reward={Attr_zzsh=0.5,}
			},

			["26_1"]={
				bonus=26,--所需完成次数  
				reward={Attr_shjm=15,}
			},
			["26_5"]={
				bonus=26,--所需完成次数  
				reward={Attr_zzsh=0.5,}
			},

			["27_1"]={
				bonus=27,--所需完成次数  
				reward={Attr_sds=1500,}
			},
			["27_6"]={
				bonus=27,--所需完成次数  
				reward={Attr_zzsh=0.5,}
			},

			["28_1"]={
				bonus=28,--所需完成次数  
				reward={Giveitem={"item_bw_1"},}
			},
			["28_7"]={
				bonus=28,--所需完成次数  
				reward={Attr_zzsh=0.5,}
			},

			["29_1"]={
				bonus=29,--所需完成次数  
				reward={Giveitem={"item_xhp_wzts_5"}}
			},
			["29_7"]={
				bonus=29,--所需完成次数  
				reward={Attr_zzsh=0.5,}
			},

			["30_1"]={
				bonus=30,--所需完成次数  
				reward={Attr_treasure=1,}
			},
			["30_2"]={
				bonus=30,--所需完成次数  
				reward={Attr_zzsh=1,}
			},

			["31_1"]={
				bonus=31,--所需完成次数  
				reward={Attr_tmz=15,}
			},
			["31_3"]={
				bonus=31,--所需完成次数  
				reward={Attr_zzsh=1,}
			},

			["32_1"]={
				bonus=32,--所需完成次数  
				reward={Attr_treasure=1,}
			},
			["32_4"]={
				bonus=32,--所需完成次数  
				reward={Attr_zzsh=1,}
			},

			["33_1"]={
				bonus=33,--所需完成次数  
				reward={Attr_treasure=1,}
			},
			["33_5"]={
				bonus=33,--所需完成次数  
				reward={Attr_zzsh=1,}
			},

			["34_1"]={
				bonus=34,--所需完成次数  
				reward={Attr_tmz=15,}
			},
			["34_6"]={
				bonus=34,--所需完成次数  
				reward={Attr_zzsh=1,}
			},

			["35_1"]={
				bonus=35,--所需完成次数  
				reward={Attr_treasure=1,Giveitem={"item_xhp_sjboss_1_6"}}
			},
			["35_7"]={
				bonus=35,--所需完成次数  
				reward={Attr_zzsh=1,}
			},

			["36_1"]={
				bonus=36,--所需完成次数  
				reward={Attr_treasure=1,}
			},
			["36_2"]={
				bonus=36,--所需完成次数  
				reward={Attr_zzsh=1,}
			},

			["37_1"]={
				bonus=37,--所需完成次数  
				reward={Attr_treasure=1,}
			},
			["37_3"]={
				bonus=37,--所需完成次数  
				reward={Attr_zzsh=1,}
			},

			["38_1"]={
				bonus=38,--所需完成次数  
				reward={Attr_treasure=1,}
			},
			["38_4"]={
				bonus=38,--所需完成次数  
				reward={Attr_zzsh=1,}
			},

			["39_1"]={
				bonus=39,--所需完成次数  
				reward={Attr_tmz=15,}
			},
			["39_5"]={
				bonus=39,--所需完成次数  
				reward={Attr_zzsh=1,}
			},

			["40_1"]={
				bonus=40,--所需完成次数  
				reward={Attr_treasure=1,}
			},
			["40_6"]={
				bonus=40,--所需完成次数  
				reward={Attr_zzsh=1,}
			},

			["41_1"]={
				bonus=41,--所需完成次数  
				reward={Attr_treasure=1,Giveitem={"item_xhp_sjboss_1_7"}}
			},
			["41_7"]={
				bonus=41,--所需完成次数  
				reward={Attr_zzsh=1,}
			},



			["42_1"]={
				bonus=42,--所需完成次数  
				reward={Attr_treasure=1,}
			},
			["42_2"]={
				bonus=42,--所需完成次数  
				reward={Attr_zzsh=1,}
			},

			["43_1"]={
				bonus=43,--所需完成次数  
				reward={Attr_treasure=1,}
			},
			["43_3"]={
				bonus=43,--所需完成次数  
				reward={Attr_zzsh=1,}
			},

			["44_1"]={
				bonus=44,--所需完成次数  
				reward={Attr_treasure=1,}
			},
			["44_4"]={
				bonus=44,--所需完成次数  
				reward={Attr_zzsh=1,}
			},

			["45_1"]={
				bonus=45,--所需完成次数  
				reward={Attr_treasure=1,}
			},
			["45_5"]={
				bonus=45,--所需完成次数  
				reward={Attr_zzsh=1,}
			},

			["46_1"]={
				bonus=4,--所需完成次数  
				reward={Attr_treasure=1,}
			},
			["46_6"]={
				bonus=46,--所需完成次数  
				reward={Attr_zzsh=1,}
			},

			["47_1"]={
				bonus=47,--所需完成次数  
				reward={Giveitem={"item_xhp_wzts_6"}}
			},
			["47_7"]={
				bonus=47,--所需完成次数  
				reward={Attr_zzsh=1,}
			},


		},
		hidden={
			["1"]={
				bonus=1,--所需完成次数  --惜命.  		说明：0死亡通关N1  				奖励：出门金币+1000
				--reward={Set_Pm=20,}
				reward={Givegold=1000,}
			},
			["2"]={
				bonus=1,--所需完成次数   --一技到底	说明：不删除技能通关游戏		奖励：技能+10%
				reward={GiveModifity={"modifiy_achi_hidden_2"},}
			},
			["3"]={
				bonus=30,--所需完成次数  --尸体		说明：一局游戏中死亡超过三十次	奖励：每次死亡  奖励1*当前英雄等级的全属性
				reward={GiveModifity={"modifiy_achi_hidden_3"},}
			},
			["4"]={
				bonus=100,--所需完成次数  --死神		说明：一局游戏中死亡超过一百次	奖励:复活时间-1     hero.swfhsj -1
				reward={Attr_swfhsj=-1,}
			},
			["5"]={
				bonus=1,--所需完成次数
				reward={}
			},
		},
		
	}
	Sachievement.levellist={
		--[[1.全属性+10*地图等级
		2.初始金币+500*地图等级
		3.攻击速度+10
		4.击杀怪物金币+10         		
		5.金钱收益+10%					
		6.金钱收益+10%					
		7.个人技能等级+1 				hero.grjndj +1			
		8.每次升级全属性+3 				hero.sjjll   hero.sjjmj  hero.sjjzl 都需要+3
		9.初始杀敌数+200 				hero.sds  +200
		10.每10秒杀敌数+10   			这个没有对应的词条			
		11.技能伤害+15% 					
		12.暴击伤害+25% 				wlbjsh
		13.暴击概率+5% 					wlbjgl
		14.附加伤害+5% 					fjsh
		15.初始杀敌数+300 				sds
		16.最终伤害+5%					zzsh
		17.金钱收益+20%					jqjc
		18.经验收益+20%					jyjc
		19.公共技能等级+1 				hero.ggjndj +1
		20.英雄天赋等级+1	]]
		[0]={},
		[1]={Set_AllPRO=10},
		[2]={Givegold=500},
		[3]={GiveModifity={"modifiy_maplevel_3"},},
		[4]={Attr_sgzjjb=20},
		[5]={Attr_jqjc=10},
		[6]={Attr_jyjc=10},
		[7]={Attr_grjndj=1},
		[8]={Attr_sjjll=5,Attr_sjjmj=5,Attr_sjjzl=5},
		[9]={Attr_sds=200},
		[10]={Attr_msmjsds=10},
		[11]={GiveModifity={"modifiy_maplevel_11"},},
		[12]={Attr_wlbjsh=30,Attr_mfbjsh=30},
		[13]={Attr_wlbjgl=5,Attr_mfbjsh=30},
		[14]={Attr_fjsh=5},
		[15]={Attr_zzsh=5},
		[16]={Attr_sds=300},
		[17]={Attr_jqjc=20},
		[18]={Attr_jyjc=20},
		[19]={Attr_grjndj=1},
		[20]={},

			
	}
end
-- 初始化
function Sachievement:__call( unit )
	if type(unit) ~= "table" then return end
	if unit:IsNull() then return end
	local unitIndex = unit:GetEntityIndex()
	local data=self:DeepCopy(Sachievement.list)
	for k,v in pairs(data) do
		for kk,vv in pairs(v) do
			data[k][kk].state=false
			if data[k][kk]["bonus"] then
				data[k][kk].bonus_count=0	
			end
			if data[k][kk]["heronum"] then
				data[k][kk].herolist={}
				data[k][kk].hero_count=0
			end
		end
	end
	self.UnitAchi[unit:GetPlayerOwnerID()] = data
	self.UnitAchithis[unit:GetPlayerOwnerID()] = {}
	self:initdata(unit)
	local maplevel=SrvMapLevel.GetPlayerLevel(unit:GetPlayerID())-1
	for k,v in pairs(Sachievement.levellist) do
		if k<=maplevel then
			--print("maplevel======"..maplevel)  
			self:SetReWard( unit,v,maplevel)
		end
	end
end
--深度拷贝Table
function Sachievement:DeepCopy(obj)
    local InTable = {};
    local function Func(obj)
        if type(obj) ~= "table" then   --判断表中是否有表  
            return obj;
        end
        local NewTable = {};  --定义一个新表
        InTable[obj] = NewTable;  --若表中有表，则先把表给InTable，再用NewTable去接收内嵌的表
        for k,v in pairs(obj) do  --把旧表的key和Value赋给新表
            NewTable[Func(k)] = Func(v);
        end
        return setmetatable(NewTable, getmetatable(obj))--赋值元表
    end
    return Func(obj) --若表中有表，则把内嵌的表也复制了
end

function Sachievement:initdata(unit)
	local playerid=unit:GetPlayerID()
	local AchiNetdata=SrvAchv.GetPlayerData(playerid)
	local Achidata=self:GetAchiState(playerid)
	local total=0
	local thisdiff=0
	--总通关次数；第二个是当前难度通关次数   
	total,thisdiff=SrvAchv.GetHeroPassCount(playerid,unit:GetUnitName())
	if AchiNetdata==nil then
		for k,v in pairs(Achidata['hero_single']) do
			Achidata['hero_single'][k]["bonus_count"]=total
		end
		return
	end
	--PrintTable(AchiNetdata)
	for k,v in pairs(AchiNetdata) do
		local namearray= string.split(k, "_")
		if namearray[1]=="hero" then
			if namearray[2]=="single" then
				for kk,vv in pairs(v) do
					local ctype=UnitKV.GetHeroPrimaryAttribute(kk)
					if ctype then
						table.insert(Achidata[Sachievement["Hero_"..ctype]][(namearray[3])]["herolist"],kk)
						self:NetSetAchiBtypeState(unit,Sachievement["Hero_"..ctype],(namearray[3]))
					end
					if kk==unit:GetUnitName() then
						for i=1,5 do
							if tostring(i)==(namearray[3]) then
								self:NetSetAchiState( unit,namearray[1].."_"..namearray[2],(namearray[3]),total)--已经有的成就直接设置State
							else
								Achidata[namearray[1].."_"..namearray[2]][tostring(i)]["bonus_count"]=total--没有的成就设置次数，通关后自动加上
							end
						end
					end
					
				end
			else
				self:NetSetAchiState( unit,namearray[1].."_"..namearray[2],namearray[3])
			end
		else
			if #namearray>2 then
				self:NetSetAchiState( unit,namearray[1],namearray[2].."_"..namearray[3])
			else
				self:NetSetAchiState( unit,namearray[1],namearray[2])
			end
		end
	end
end
function Sachievement:NetSetAchiBtypeState( unit,ftype,pid)  --设置从服务器获取的单通关
	local Achi=self:GetAchiState(unit:GetPlayerID())
	Achi[ftype][pid]["hero_count"]=#Achi[ftype][pid]["herolist"]
	if Achi[ftype][pid]["hero_count"]>=Achi[ftype][pid]["heronum"] then  --如果英雄数量超过10个则成就解锁
		Achi[ftype][pid]["state"]=true
		--self:SetReWard( unit,Achi[ftype][pid]["reward"])
		self:SetThreeState(unit,pid,ftype,1)
	end
end
function Sachievement:NetSetAchiState( unit,ftype,pid,num)--设置从服务器获取的除单通关以外的
	local Achi=self:GetAchiState(unit:GetPlayerID())
	pid=(pid) 
	if Achi[ftype][pid]==nil then
		return
	end
	if num then
		Achi[ftype][pid]["bonus_count"]=num
	end
	Achi[ftype][pid]["state"]=true
	self:SetReWard( unit,Achi[ftype][pid]["reward"])
	
	return	
	
end
function Sachievement:SetAchiState( unit,ftype,pid,num)--设置成就
	if SrvAchv.ignore_hero[unit:GetUnitName()]==true then
		return
	end
	local Achi=self:GetAchiState(unit:GetPlayerID())
	if Achi==nil then
		return 
	end
	local basenum=1
	if num then
		basenum=num
	end
	if ftype=="hero_single" then
		for k,v in pairs(Achi[ftype]) do
			Achi[ftype][k]["bonus_count"]=Achi[ftype][k]["bonus_count"]+1  ---每次只加1
			if Achi[ftype][k]["bonus_count"]>=Achi[ftype][k]["bonus"] and  Achi[ftype][k]["state"] == false then
				self:SetSueState(unit,ftype,k) 
				self:SetBtypeState(unit,k)
			end
		end
	else
		if pid then
			pid=tostring(pid)
			if Achi[ftype][pid] then
				Achi[ftype][pid]["bonus_count"]=Achi[ftype][pid]["bonus_count"]+basenum ---每次只加1
				if Achi[ftype][pid]["bonus_count"]>=Achi[ftype][pid]["bonus"] and  Achi[ftype][pid]["state"] == false then
					self:SetSueState(unit,ftype,pid)
				end
			end
		end
	end
	return true
end
function Sachievement:SetBtypeState(unit,bid)--设置10个英雄总成就
	local Achi=self:GetAchiState(unit:GetPlayerID())
	local ftype=Sachievement["Hero_"..(unit:GetPrimaryAttribute()+1)]
	if not self:IsInTable(unit:GetUnitName(),Achi[ftype][bid]["herolist"]) then  --single的bid如果刚完成，侧判断对应的力知敏bid中是否有该英雄，如果没有就加上
		table.insert(Achi[ftype][bid]["herolist"],unit:GetUnitName())
		Achi[ftype][bid]["hero_count"]=#Achi[ftype][bid]["herolist"]
	end
	if Achi[ftype][bid]["hero_count"]>=Achi[ftype][bid]["heronum"] and  Achi[ftype][bid]["state"] == false then  --如果英雄数量超过10个则成就解锁
		self:SetSueState(unit,ftype,bid)
		self:SetThreeState(unit,bid,ftype)
	end

end
function Sachievement:SetSueState(unit,ftype,bid)--设置成就状态
	local Achi=self:GetAchiState(unit:GetPlayerID())
	Achi[ftype][bid]["state"]=true
	
	local id = SrvAchv.GetAchievementServerID(ftype,bid)
	if ftype=='hero_all' then
		local AchiNetdata=SrvAchv.GetPlayerData(unit:GetPlayerID())
		if AchiNetdata and AchiNetdata[id] then
			return 
		end
	end
	local temptable={}
	temptable["id"]=id
	if ftype=="hero_single" then
	temptable["hero"]=unit:GetUnitName()
	end
	table.insert(Sachievement.UnitAchithis[unit:GetPlayerOwnerID()],temptable)
	
end
function Sachievement:SetThreeState(unit,bid,btype,state)--设置三系成就
	local Achi=self:GetAchiState(unit:GetPlayerID())
	local ftype="hero_all"
	if Achi[ftype][bid]["otherachi"][btype.."_"..bid]==0 then
		Achi[ftype][bid]["otherachi"][btype.."_"..bid]=1
	end
	local suc=true
	for k,v in pairs(Achi[ftype][bid]["otherachi"]) do
		if v==0 then
			suc=false
		end
	end
	if suc==true and Achi[ftype][bid]["state"]==false then
		if state==nil then
			self:SetSueState(unit,ftype,bid)
		else
			Achi[ftype][bid]["state"]=true
			
			--if AchiNetdata
			self:SetSueState(unit,ftype,bid)
			--self:SetReWard( unit,Achi[ftype][bid]["reward"])
		end
	end
end
function Sachievement:IsInTable(value, tbl)
	for k,v in ipairs(tbl) do
		if v == value then
		return true;
		end
	end
	return false;
end
function Sachievement:GetAchiThis( playerid)
	return self.UnitAchithis[playerid]
end
function Sachievement:GetAchiState( playerid)
	return self.UnitAchi[playerid]
end
function Sachievement:SetReWard( unit,reward,maplevel)---给成就奖励和地图等级
	local level=1
	if maplevel then
		level=maplevel
	end
	if type(reward) ~= "table" then
		return
	end
	for k,v in pairs(reward) do
		local NameArray=string.split(k, "_")
		if NameArray[1]=="GiveModifity" then --添加modfity
			for kk,vv in pairs(v) do
				unit:AddNewModifier(unit, nil,vv, {})
			end
		elseif NameArray[1]=="Giveitem" then --添加modfity
			for kk,vv in pairs(v) do
				local addItem = CreateItem(vv, unit, unit)
				unit:AddItem(addItem)
			end
		elseif NameArray[1]=="Givegold" then --给钱
			PlagueLand:ModifyCustomGold(unit:GetPlayerID(), v*level)
			
		elseif NameArray[1]=="Attr" then --给属性
			if NameArray[2]=="sjPm" then --给主属性Attr_sjjll=2,Attr_sjjmj=2,Attr_sjjzl 三选一
				local temp={}
				if unit:GetPrimaryAttribute()==0 then
					temp["sjjll"] = v
				end
				if unit:GetPrimaryAttribute()==1 then
					temp["sjjmj"] = v
				end
				if unit:GetPrimaryAttribute()==2 then
					temp["sjjzl"] = v
				end
				AttributesSet(unit,temp)
			else
				local temp={}
				temp[NameArray[2]] = v
				AttributesSet(unit,temp)
			end
		elseif NameArray[1]=="Level" then --升级英雄天赋
			if NameArray[2]=="all" then --
				--TimerUtil.createTimerWithDelay(7,function()
					HeroLevelUp.heroability(unit)
				--end)
			end
			if NameArray[2]=="str" then --
				--TimerUtil.createTimerWithDelay(7,function()
					HeroLevelUp.heroability(unit)
			--	end)
			end
			if NameArray[2]=="agi" then --
				--TimerUtil.createTimerWithDelay(7,function()
					HeroLevelUp.heroability(unit)
			--	end)
			end
			if NameArray[2]=="int" then --
				--TimerUtil.createTimerWithDelay(7,function()
					HeroLevelUp.heroability(unit)
				--end)
			end

		elseif NameArray[1]=="Set" then --直接设置
			if NameArray[2]=="AllPRO" then --直接给全属性
				unit:ModifyStrength(v*level)
				unit:ModifyIntellect(v*level)
				unit:ModifyAgility(v*level)
			elseif  NameArray[2]=="ll" then --直接给力量
				unit:ModifyStrength(v)
			elseif  NameArray[2]=="Pm" then --直接给主属性
				if unit:GetPrimaryAttribute()==0 then
					unit:ModifyStrength(v)
				end
				if unit:GetPrimaryAttribute()==1 then
					unit:ModifyAgility(v)
				end
				if unit:GetPrimaryAttribute()==2 then
					unit:ModifyIntellect(v)
				end
			else

			end
		end
	end
end