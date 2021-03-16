if Lottery == nil then
    Lottery = {}
    Lottery.PlayerLottery = {}
    setmetatable(Lottery,Lottery)
    Lottery.water={
        [1]=1000,
        [2]=100,
        [3]=10,
        [4]=1,
    }
--征战钥匙,全奖池抽奖
Lottery.list_all={
	shopmall_15={ --基础符文页消耗
		level = 1; --1级商品  等级越高，商品价值越高
		weight= 20; --抽中权重
		num=10; 	--给予商品数量   因为消耗品可能是给与数量
		cf=true; --可重复           
    },
	shopmall_16={ --中级符文页消耗
		level = 1; 
		weight= 10;
		num=10; 
		cf=true;       
    },
    shopmall_17={ --高级符文页消耗
		level = 1; 
		weight= 5; 
		num=10;
		cf=true;        
    },
    jing_1000 = {
    	level = 1; 
		weight= 100; 
		cf=true; 
   	},
    jing_2000={
	    level = 1;
		weight= 100; 
		cf=true; 
   	},
   	jing_5000={
	    level = 1;
		weight= 40;
		cf=true;
   	},
   	jing_10000={
	    level = 1; 
		weight= 20; 
		cf=true;
   	},
   	jing_50000={
	    level = 2; 
		weight= 16; 
		cf=true; 
   	},
   	jing_100000={
	    level = 2; 
		weight= 16; 
		cf=true; 
   	},
   	jing_1000000={
	    level = 3; 
		weight= 120; 
		cf=true; 
   	},
   	shopmall_sstone_2={ --二阶强化石
	    level = 1; 
		weight= 100; 
		num=10; 
		cf=true; 
   	},
   	shopmall_sstone_3={ --三阶强化石
	    level = 1; 
		weight= 50; 
		num=10; 
		cf=true; 
   	},
   	shopmall_sstone_4={ --四阶强化石
	    level = 1; 
		weight= 20; 
		num=10; 
		cf=true; 
   	},
   	shopmall_5={ --初级会员
	    level = 2; 
		weight= 150; 
		cf=false; 
		jing=2000;  
   	},
   	shopmall_6={ --中级会员
	    level = 2; 
		weight= 33; 
		cf=false; 
		jing=4000;  
   	},
   	shopmall_4={ --聚宝盆
	    level = 2; 
		weight= 17; 
		cf=false; 
		jing=8000;  
   	},
   	shopmall_9={ --中级符文页1
	    level = 2; 
		weight= 33; 
		cf=false; 
		jing=4000;  
   	},
   	shopmall_49={ --中级符文页2
	    level = 2; 
		weight= 11; 
		cf=false; 
		jing=12000; 
   	},
   	shopmall_50={ --中级符文页3
	    level = 2; 
		weight= 2; 
		cf=false; 
		jing=30000; 
   	},
   	shopmall_10={ --高级符文页1
	    level = 3; 
		weight= 500; 
		cf=false; 
		jing=60000;  
   	},
   	shopmall_51={ --高级符文页2
	    level = 3; 
		weight= 167; 
		cf=false; 
		jing=200000;  
   	},
   	shopmall_52={ --高级符文页3
	    level = 3; 
		weight= 55; 
		cf=false; 
		jing=600000;  
   	},
   	shopmall_59={ --1阶神秘宝物书
	    level = 2; 
		weight= 15; 
		cf=false; 
		jing=12000;  
   	},
   	shopmall_63={ --11阶能量之心
	    level = 3; 
		weight= 330; 
		cf=false; 
		jing=100000;  
   	},
   	shopmall_64={ --12阶能量之心
	    level = 3; 
		weight= 90; 
		cf=false; 
		jing=300000;  
   	},
   	shopmall_11={ --超魔符文1
	    level = 3; 
		weight= 90; 
		cf=false; 
		jing=300000;  
   	},
   	shopmall_55={ --超魔符文2
	    level = 3; 
		weight= 30; 
		cf=false; 
		jing=900000; 
   	},
   	shopmall_56={ --超魔符文3
	    level = 3; 
		weight= 10; 
		cf=false; 
		jing=3000000;  
   	},
   	shopmall_53={ --白银会员
	    level = 3; 
		weight= 30; 
		cf=false; 
		jing=800000; 
   	},
   	shopmall_67={ --吞噬卡
	    level = 3; 
		weight= 167; 
		cf=false; 
		jing=200000; 
   	},
   	shopmall_60={ --2阶神秘宝物书
	    level = 3; 
		weight= 60; 
		cf=false; 
		jing=500000;  
   	},
   	shopmall_12={ --特殊符文槽1
	    level = 4; 
		weight= 100; 
		cf=false; 
		jing=1800000;  
   	},
   	shopmall_57={ --特殊符文槽2
	    level = 4; 
		weight= 30; 
		cf=false; 
		jing=7200000;  
   	},
   	shopmall_58={ --特殊符文槽3
	    level = 4; 
		weight= 10; 
		cf=false; 
		jing=18000000;  
   	},
   	shopmall_65={ --13阶能量之心
	    level = 4; 
		weight= 100; 
		cf=false; 
		jing=2400000;  
   	},
   	shopmall_66={ --14阶能量之心
	    level = 4; 
		weight= 25; 
		cf=false; 
		jing=9000000;  
   	},
   	shopmall_61={ --3阶神秘宝物书
	    level = 4; 
		weight= 40; 
		cf=false; 
		jing=6000000;  
   	},
   	shopmall_54={ --黄金会员
	    level = 4; 
		weight= 180; 
		cf=false; 
		jing=1500000;  
   	},
}
    
    
 end
 function Lottery:InitLottery(playerid)
    Lottery.PlayerLottery[playerid]={}
 end
 function Lottery:RandomLottery(playerid,num)
    local resulttable={}
    local ddddddd={}
    for i=1,num do
        
        local Lotterywater=Weightsgetvalue_one(Lottery.water)--随机奖池
        local temp={}
        for k, v in pairs(Lottery.list_all) do  

            if v.level== Lotterywater then
                temp[k]=v.weight
            end
        end
        local result=Weightsgetvalue_one(temp)--从奖池中随机一个
        --PrintTable(temp)
        local cc=Lottery.list_all[result]
        local num=cc.num
        cc.name=result
        local jing=0
        if cc.cf==false then
            if Shopmall:HasItem(playerid,result)==true then  --如果已经有这个物品了
                jing=cc.jing
            else
                for k, v in pairs(resulttable) do   --如果没有这个物品，但已经随机到了
                    if v.item==result then
                        jing=cc.jing
                    end 
                end
            end
            
            
        end
        if string.split(result, "_")[1]=="jing" then
            num=string.split(result, "_")[2]
            result=SrvStore.NAME_JING
        end
        local oneresult={item=result,count=num,jing=jing}
        table.insert(resulttable,oneresult)
        table.insert(ddddddd,Lotterywater)
    end
   -- local temp2={}
  --  local temp={}
  --  for k, v in pairs(resulttable) do   
    --    if temp[v.item] then
     --       temp[v.item]=temp[v.item]+1
    --   else
   --       temp[v.item]=1
   --     end
  --  end
  --  for k, v in pairs(ddddddd) do   
   --     if temp2[v] then
   --         temp2[v]=temp2[v]+1
  --      else
   --        temp2[v]=1
   --     end
 --   end
   -- PrintTable(oneresult)
   -- PrintTable(temp2)
   -- PrintTable(temp)

    return resulttable
    
 end
 function Lottery:GetLotteryResult(playerid)
    return Lottery.PlayerLottery[playerid]
 end