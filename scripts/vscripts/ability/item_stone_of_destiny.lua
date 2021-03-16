--精致命运石里面的道具，和权重

mys={
	"mys_1";
	"mys_2";
	"mys_3";
	"mys_4";
	"mys_5";
	"mys_6";
}
--个人BOSS召唤卷轴的出现概率
individualBoss={
	item_xhp_sjboss_1_1 = 1000;
	item_xhp_sjboss_1_2 = 500;
	item_xhp_sjboss_1_3 = 200;
	item_xhp_sjboss_1_4 = 80;
	item_xhp_sjboss_1_5 = 30;
	item_xhp_sjboss_1_6 = 8;
	item_xhp_sjboss_1_7 = 2

}
--团队BOSS召唤卷轴的出现概率
teamBoss={
	item_xhp_sjboss_2_1 = 1000;
	item_xhp_sjboss_2_2 = 500;
	item_xhp_sjboss_2_3 = 200;
	item_xhp_sjboss_2_4 = 80;
	item_xhp_sjboss_2_5 = 30;
	item_xhp_sjboss_2_6 = 8;
	item_xhp_sjboss_2_7 = 2;

}
jyk={
	15000;
	75000;
	200000;
	600000;
	700000;

}

--设置命运石里面的道具和道具的权重
mys_qz={
		mys_3={
			jbbx_1=30;
			sx=200;
			zbbx_3=30;
			item_xhp_individualBoss=4;
			item_xhp_tzboss_3_1=100;	
			item_xhp_tzboss_3_2=30;	
			item_xhp_tzboss_3_3=10;
			mj=200;		
			jy=100;	
			jn=4;
		};
		mys_4={
			sx=20;
			zbbx_4=4;
			ydjk=1;
			item_xhp_individualBoss=5;
			item_xhp_teamBoss=1;
			item_xhp_tzboss_4_1=10;
			item_xhp_tzboss_4_2=3;
			item_xhp_tzboss_4_3=1;
			mj=20;
			jy=10;
			jn=1;
		};
		mys_5={
			zbbx_5=4;
			ydjk=2;
			item_xhp_individualBoss=10;
			item_xhp_teamBoss=5;
			item_xhp_tzboss_4_4=10;
			item_xhp_tzboss_4_5=3;
			item_xhp_tzboss_4_6=1;
			mj=20;
			jy=10;
			jn=1;
		};
		mys_6={
			zbbx_6=4;
			item_xhp_individualBoss=10;
			item_xhp_teamBoss=5;
			item_xhp_tzboss_5_1=10;
			item_xhp_tzboss_5_2=3;
			item_xhp_tzboss_5_3=1;
			mj=20;
			jy=10;
			jn=1;
		};
	
}

--命运石属性奖励

mys_sx={
	15;
	15;
	25;
	40;
	60;
	80;
}
mys_mj={
	1,
	1,
	1,
	2,
	4,
	8,


}

my_jn={
	jn1={
	item_xhp_wzts_1= 5;
	item_xhp_wzts_2= 1;
	};
	jn2={
	item_xhp_wzts_2= 5;
	item_xhp_wzts_3= 1;
	};
	jn3={
	item_xhp_wzts_3= 5;
	item_xhp_wzts_4= 1;
	};
	jn4={
	item_xhp_wzts_4= 5;
	item_xhp_wzts_5= 1;
	};
}



--使用命运石
function my( keys )
	local caster = keys.caster
	local ability = keys.ability
	local pz = ability:GetLevelSpecialValueFor("pz", ability:GetLevel() - 1)
	local gold =	ability:GetLevelSpecialValueFor("gold", ability:GetLevel() - 1)
	local point =	ability:GetLevelSpecialValueFor("point", ability:GetLevel() - 1)
	local charges = ability:GetCurrentCharges()
	local playerID = caster:GetPlayerOwnerID()
	local hero = PlayerUtil.GetHero(playerID)
	local xj = PlagueLand:GetNowGold(playerID)
	local iname = ability:GetAbilityName()
	local itemtable = PlayerUtil.getAttrByPlayer(playerID,"itemtable")
	local gold2 = itemtable[iname]
	if xj >= gold2 then
		if charges > 1 then
			ability:SetCurrentCharges(charges - 1)
		else
		--	if ability then
			UTIL_RemoveImmediate(ability)
		--	end
		end
		gold2=-gold2
		PlagueLand:ModifyCustomGold(playerID, gold2)
		--通过品质获取对应道具
		local itemname = mys[pz]
		local qz = {}
		local sx = {}
		--获取最高的概率加成
		--获取权重
		local i = 1
		for k,v in pairs(mys_qz[itemname]) do
			sx[i] = k
			qz[i] = v
			i = i+1
		end			
		--根据权重获得到的道具名
		local randomValue = GetRanomByWeight(sx, qz)
		myjl(randomValue,playerID,pz)	
		hero.stonetime = hero.stonetime + point
		hero.mys[pz] = hero.mys[pz] + 1
		
		itemtable[iname] = gold * (1+(hero.mys[pz])*0.1)
		PlayerUtil.setAttrByPlayer(playerID,"itemtable",itemtable)
		SetNetTableValue("custom_shop","dynamic_cost_"..playerID,itemtable)

		MisSion:SetStone(playerID,point)
	else
		gold2 = gold2 -xj
		NotifyUtil.ShowError(playerID,"money_not",{value=gold2})
	end


end



--根据道具名来执行接下来的奖励
--@param #string randomValue 	道具名字
--@param #int playerId 	玩家号
function myjl(randomValue,playerID,pz)
	--当前波数
	local wave = Stage.wave
	if wave ==0 then
		wave= 1
	end
	--获取使用单位的主英雄
	local caster = PlayerUtil.GetHero(playerID)
	local zf = string.sub(randomValue,10,15)
	if randomValue then
		--当随机到属性道具 自动使用，给与英雄属性
		if randomValue == "sx" then
			--当前波数
			local baseStr = caster:GetBaseStrength()
			local baseAgi = caster:GetBaseAgility()
			local baseInt = caster:GetBaseIntellect()
			wave = math.ceil(wave/5)
			local min = mys_sx[wave]
			local max = mys_sx[wave+1]
			local add = RandomInt(min,max)
			local pow = math.pow(2,(pz-3))
			add = add * pow
			addStr = baseStr + add
			caster:SetBaseStrength(addStr)
			addAgi = baseAgi + add
			caster:SetBaseAgility(addAgi)
			addInt = baseInt + add
			caster:SetBaseIntellect(addInt)
			NotifyUtil.ShowSysMsg2(playerID,"mys_qsx",{value=add})
			return nil
		 end



		 --当随机到套装BOSS召唤券，则直接给与英雄召唤券
		 if zf == "tzboss" then	
		 	local item = CreateItem(randomValue, caster, caster)
			caster:AddItem(item)
			NotifyUtil.ShowSysMsg(caster:GetPlayerID(),"#add_tz_boss")
			return nil
		 end

		 --接下来要做的

		 --秘诀
		 if randomValue == "mj" then	
		 	local x = RandomInt(1,mys_mj[pz])
		 	for i=1,x do
		 		local item = CreateItem("item_mj_random_2", caster, caster)
				caster:AddItem(item)
		 	end
			
		
			NotifyUtil.ShowSysMsg2(playerID,"add_ablity_mj",{value=x})
			return nil
		end

	

		 --个人BOSS召唤
		 if randomValue == "item_xhp_individualBoss" then	
		 	local sx = {}
			local qz = {}
			local i = 0
				--开出更高级的BOSS卷轴的概率会随着命运石的品质提高而提高
		 		for k,v in pairs(individualBoss) do
		 			i= i+1
		 			local zf = string.sub(k,19,19)
			 		if pz ==4 then
			 			
			 			if zf ~= "1" then		 			
			 				v=v*2
			 			end
			 		end

			 		if pz ==5 then
			 			if zf =="2" then
			 				v=v*2
			 			end
			 			if zf=="3" then
			 				v= v*4
			 			end
			 			if zf=="4" then
			 				v= v*4
			 			end
			 			if zf=="5" then
			 				v= v*4
			 			end
			 			if zf=="6" then
			 				v= v*4
			 			end
			 			if zf=="7" then
			 				v= v*4
			 			end
			 		end

			 		if pz ==6 then
			 			if zf =="2" then
			 				v=v*2
			 			end
			 			if zf=="3" then
			 				v= v*4
			 			end
			 			if zf=="4" then
			 				v= v*8
			 			end
			 			if zf=="5" then
			 				v= v*8
			 			end
			 			if zf=="6" then
			 				v= v*8
			 			end
			 			if zf=="7" then
			 				v= v*8
			 			end
			 		end

			 		if pz ==7 then
			 			if zf =="2" then
			 				v=v*2
			 			end
			 			if zf=="3" then
			 				v= v*4
			 			end
			 			if zf=="4" then
			 				v= v*8
			 			end
			 			if zf=="5" then
			 				v= v*16
			 			end
			 			if zf=="6" then
			 				v= v*16
			 			end
			 			if zf=="7" then
			 				v= v*16
			 			end
			 		end
		 		sx[i] = k
			 	qz[i] = v
			 end
		 --根据权重获得到的物品名字
		local randomValue = GetRanomByWeight(sx, qz)
		local item = CreateItem(randomValue, caster, caster)
		caster:AddItem(item)
		NotifyUtil.ShowSysMsg(caster:GetPlayerID(),"#add_individualBoss")
		return nil
	 end
	 --团队BOSS召唤

	 if randomValue == "item_xhp_teamBoss" then	
		 	local sx = {}
			local qz = {}
			local i = 0
				--开出更高级的BOSS卷轴的概率会随着命运石的品质提高而提高
		 		for k,v in pairs(teamBoss) do
		 			i= i+1
		 			local zf = string.sub(k,19,19)
			 		if pz ==4 then
			 			
			 			if zf ~= "1" then		 			
			 				v=v*2
			 			end
			 		end

			 		if pz ==5 then
			 			if zf =="2" then
			 				v=v*2
			 			end
			 			if zf=="3" then
			 				v= v*4
			 			end
			 			if zf=="4" then
			 				v= v*4
			 			end
			 			if zf=="5" then
			 				v= v*4
			 			end
			 			if zf=="6" then
			 				v= v*4
			 			end
			 			if zf=="7" then
			 				v= v*4
			 			end
			 		end

			 		if pz ==6 then
			 			if zf =="2" then
			 				v=v*2
			 			end
			 			if zf=="3" then
			 				v= v*4
			 			end
			 			if zf=="4" then
			 				v= v*8
			 			end
			 			if zf=="5" then
			 				v= v*8
			 			end
			 			if zf=="6" then
			 				v= v*8
			 			end
			 			if zf=="7" then
			 				v= v*8
			 			end
			 		end

			 		if pz ==7 then
			 			if zf =="2" then
			 				v=v*2
			 			end
			 			if zf=="3" then
			 				v= v*4
			 			end
			 			if zf=="4" then
			 				v= v*8
			 			end
			 			if zf=="5" then
			 				v= v*16
			 			end
			 			if zf=="6" then
			 				v= v*16
			 			end
			 			if zf=="7" then
			 				v= v*16
			 			end
			 		end
		 		sx[i] = k
			 	qz[i] = v
		 	end
		 --根据权重获得到的物品名字
		local randomValue = GetRanomByWeight(sx, qz)
		local item = CreateItem(randomValue, caster, caster)
		caster:AddItem(item)
		NotifyUtil.ShowSysMsg(caster:GetPlayerID(),"#add_teamBoss")
		return nil
	 end
	 	local max = 50 
		 --金币宝箱
		if randomValue == "jbbx_1" then	
			NotifyUtil.ShowSysMsg(caster:GetPlayerID(),"#add_money_box")
			local point =caster:GetAbsOrigin()+RandomVector(RandomFloat(150,300))
			local target =  CreateUnitByName("jbbx_1", point, false, nil, nil, DOTA_TEAM_GOODGUYS)
			AddLuaModifier(target,target,"modifier_kill",{duration=0.1},ability)
			TimerUtil.createTimerWithDelay(0.5,function()
			-- If the dummy traveled the whole distance then kill it
			
				if max>0 then
					CreateItemOnGround("item_xhp_xjb",nil,point,300)
					EmitSoundOnLoc(point,"Item.DropGemShop",caster)
					max = max-1
				return 0.03
				end
			end)
		
			return nil
		end 
		 --移动金矿

		 --装备宝箱
		 if randomValue == "zbbx_3" then
		    NotifyUtil.ShowSysMsg(caster:GetPlayerID(),"#add_zbbx")	
		 	local wave = caster:GetLevel()
		 	if wave <=0 then
		 		wave = 1
		 	end
		 	wave = wave  +20
		 	local point =caster:GetAbsOrigin()+RandomVector(RandomFloat(150,300))	
		 	local target =  CreateUnitByName("zbbx_1", point, false, nil, nil, TEAM_ENEMY)
		 	target.dbpz =2
			target.dbl = RandomInt(1,3)
			target:CreatureLevelUp(wave)
			LetUnitDoAction(target,3,1)
			AddLuaModifier(target,target,"modifier_kill",{duration=0.1},ability)
			return nil
		 end

		  if randomValue == "zbbx_4" then	
		  	NotifyUtil.ShowSysMsg(caster:GetPlayerID(),"#add_zbbx")	
		 	local wave = caster:GetLevel()
		 	if wave <=0 then
		 		wave = 1
		 	end
		 	wave = wave  +20
		 	local point =caster:GetAbsOrigin()+RandomVector(RandomFloat(150,300))	
		 	local target =  CreateUnitByName("zbbx_1", point, false, nil, nil, TEAM_ENEMY)
		 	target.dbpz = 3
			target.dbl = RandomInt(1,3)
			target:CreatureLevelUp(wave)
			LetUnitDoAction(target,3,1)
			AddLuaModifier(target,target,"modifier_kill",{duration=0.1},ability)
			return nil
		 end


		  if randomValue == "zbbx_5" then	
		  	NotifyUtil.ShowSysMsg(caster:GetPlayerID(),"#add_zbbx")	
		 	local wave = caster:GetLevel()
		 	if wave <=0 then
		 		wave = 1
		 	end
		 	wave = wave  +20
		 	local point =caster:GetAbsOrigin()+RandomVector(RandomFloat(150,300))	
		 	local target =  CreateUnitByName("zbbx_1", point, false, nil, nil, TEAM_ENEMY)
		 	target.dbpz =3
			target.dbl = RandomInt(1,3)
			target:CreatureLevelUp(wave)
			LetUnitDoAction(target,3,1)
			AddLuaModifier(target,target,"modifier_kill",{duration=0.1},ability)
			return nil
		 end


		  if randomValue == "zbbx_6" then	
		  	NotifyUtil.ShowSysMsg(caster:GetPlayerID(),"#add_zbbx")	
		 	local wave = caster:GetLevel()
		 	if wave <=0 then
		 		wave = 1
		 	end
		 	wave = wave  +20
		 	local point =caster:GetAbsOrigin()+RandomVector(RandomFloat(150,300))	
		 	local target =  CreateUnitByName("zbbx_1", point, false, nil, nil, TEAM_ENEMY)
		 	target.dbpz =4
			target.dbl = RandomInt(1,3)
			target:CreatureLevelUp(wave)
			LetUnitDoAction(target,3,1)
			AddLuaModifier(target,target,"modifier_kill",{duration=0.1},ability)
			return nil
		 end
		 --经验
		  if randomValue == "jy" then	
		  	local x = pz -2	  
		  	local lv = jyk[pz-2]	
			caster:AddExperience(lv, DOTA_ModifyXP_Unspecified, false, false)
			NotifyUtil.ShowSysMsg2(playerID,"pray_exp",{value=lv})
			return nil
		 end

		  --技能
		  if randomValue == "jn" then	
		  	 --根据权重获得到的物品名字
		  	local itemname = "item_xhp_wzts_"..pz-2
		  	if RollPercent(20)  then
		  		itemname = "item_xhp_wzts_"..pz-1
			end
		  	local item = CreateItem(itemname, caster, caster)
			caster:AddItem(item)
			NotifyUtil.ShowSysMsg(caster:GetPlayerID(),"#mys_jns")
			return nil
		 end
		


	end
end








--购买宝物
function buy_bw( keys )
	local caster = keys.caster
	local ability = keys.ability
	local playerID = caster:GetPlayerOwnerID()
	local hero = PlayerUtil.GetHero(playerID)
	local iname = ability:GetAbilityName()
	local bosspoint = hero.bosspoint
	local num = hero.buybwnum
	ability:RemoveSelf()
	if num > 4 then
		NotifyUtil.ShowError(playerID,"bw_cc")
		return nil
	end
	local itemtable = PlayerUtil.getAttrByPlayer(playerID,"itemtable")
	local bosspointnum = itemtable[iname].cost
	if num ==0  then
		if bosspoint >= bosspointnum then
			hero.buybwnum = hero.buybwnum + 1
			hero.bosspoint = hero.bosspoint -bosspointnum
			local item = CreateItem("item_bw_1", hero, hero)
			hero:AddItem(item)

			itemtable[iname]["cost"] = 10
			PlayerUtil.setAttrByPlayer(playerID,"itemtable",itemtable)
			SetNetTableValue("custom_shop","dynamic_cost_"..playerID,itemtable)
		else
			NotifyUtil.ShowError(playerID,"buy_bw",{value=num+1,boss_point=bosspointnum - bosspoint})
		end
	end 

	if num ==1  then
		if bosspoint >= bosspointnum then
			hero.buybwnum = hero.buybwnum + 1
			hero.bosspoint = hero.bosspoint -bosspointnum
			local item = CreateItem("item_bw_1", hero, hero)
			hero:AddItem(item)

			itemtable[iname]["cost"] = 50
			PlayerUtil.setAttrByPlayer(playerID,"itemtable",itemtable)
			SetNetTableValue("custom_shop","dynamic_cost_"..playerID,itemtable)
		else
			NotifyUtil.ShowError(playerID,"buy_bw",{value=num+1,boss_point=bosspointnum - bosspoint})
		end
	end 

	if num ==2  then
		if bosspoint >= bosspointnum then
			hero.buybwnum = hero.buybwnum + 1
			hero.bosspoint = hero.bosspoint -bosspointnum
			local item = CreateItem("item_bw_1", hero, hero)
			hero:AddItem(item)

			itemtable[iname]["cost"] = 100
			PlayerUtil.setAttrByPlayer(playerID,"itemtable",itemtable)
			SetNetTableValue("custom_shop","dynamic_cost_"..playerID,itemtable)
		else
			NotifyUtil.ShowError(playerID,"buy_bw",{value=num+1,boss_point=bosspointnum - bosspoint})
		end
	end 


	if num ==3  then
		if bosspoint >= bosspointnum then
			hero.buybwnum = hero.buybwnum + 1
			hero.bosspoint = hero.bosspoint -bosspointnum
			local item = CreateItem("item_bw_1", hero, hero)
			hero:AddItem(item)

			itemtable[iname]["cost"] = 200
			PlayerUtil.setAttrByPlayer(playerID,"itemtable",itemtable)
			SetNetTableValue("custom_shop","dynamic_cost_"..playerID,itemtable)
		else
			NotifyUtil.ShowError(playerID,"buy_bw",{value=num+1,boss_point=bosspointnum - bosspoint})
		end
	end 

	if num ==4  then
		if bosspoint >= bosspointnum then
			hero.buybwnum = hero.buybwnum + 1
			hero.bosspoint = hero.bosspoint -bosspointnum
			local item = CreateItem("item_bw_1", hero, hero)
			hero:AddItem(item)
		else
			NotifyUtil.ShowError(playerID,"buy_bw",{value=num+1,boss_point=bosspointnum - bosspoint})
		end
	end 
	local unitKey = tostring(EntityHelper.getEntityIndex(hero))
 	local netTable = hero.cas_table
  	netTable["bosspoint"] = hero.bosspoint
  	SetNetTableValue("UnitAttributes",unitKey,netTable)	



end


--购买宝物
function zh_ym( keys )
	local caster = keys.caster
	local ability = keys.ability
	local playerID = caster:GetPlayerOwnerID()
	--local caster = PlayerUtil.GetHero(playerID)
	local iname = ability:GetAbilityName()
	local bosspoint = caster.bosspoint
	local num = caster.zh_ym    -- 召唤冤魔的次数，第一次默认为1
	ability:RemoveSelf()
	if num > 9 then
		NotifyUtil.ShowError(playerID,"ym_cc")
		return nil
	end
	local itemtable = PlayerUtil.getAttrByPlayer(playerID,"itemtable")
	local bosspointnum = itemtable[iname].cost
	if num ==0  then
		if bosspoint >= bosspointnum then
			caster.zh_ym= caster.zh_ym +1
			caster.bosspoint = caster.bosspoint -bosspointnum
			CallYmBoss(caster,playerID)

			itemtable[iname]["cost"] = 10
			PlayerUtil.setAttrByPlayer(playerID,"itemtable",itemtable)
			SetNetTableValue("custom_shop","dynamic_cost_"..playerID,itemtable)
		else
			NotifyUtil.ShowError(playerID,"ym_cs",{value=num+1,boss_point=bosspointnum - bosspoint})
		end

	elseif num ==1  then
		if bosspoint >= bosspointnum then
			caster.zh_ym= caster.zh_ym +1
			caster.bosspoint = caster.bosspoint -bosspointnum
			CallYmBoss(caster,playerID)

			itemtable[iname]["cost"] = 50
			PlayerUtil.setAttrByPlayer(playerID,"itemtable",itemtable)
			SetNetTableValue("custom_shop","dynamic_cost_"..playerID,itemtable)
		else
			NotifyUtil.ShowError(playerID,"ym_cs",{value=num+1,boss_point=bosspointnum - bosspoint})
		end
	elseif num ==2  then
		if bosspoint >= bosspointnum then
			caster.zh_ym= caster.zh_ym +1
			caster.bosspoint = caster.bosspoint -bosspointnum
			CallYmBoss(caster,playerID)

			itemtable[iname]["cost"] = 100
			PlayerUtil.setAttrByPlayer(playerID,"itemtable",itemtable)
			SetNetTableValue("custom_shop","dynamic_cost_"..playerID,itemtable)
		else
			NotifyUtil.ShowError(playerID,"ym_cs",{value=num+1,boss_point=bosspointnum - bosspoint})
		end
	elseif num ==3  then
		if bosspoint >= bosspointnum then
			caster.zh_ym= caster.zh_ym +1
			caster.bosspoint = caster.bosspoint -bosspointnum
			CallYmBoss(caster,playerID)

			itemtable[iname]["cost"] = 200
			PlayerUtil.setAttrByPlayer(playerID,"itemtable",itemtable)
			SetNetTableValue("custom_shop","dynamic_cost_"..playerID,itemtable)
		else
			NotifyUtil.ShowError(playerID,"ym_cs",{value=num+1,boss_point=bosspointnum - bosspoint})
		end
	elseif num >=4 and num <= 10  then
		if bosspoint >= bosspointnum then
			caster.zh_ym= caster.zh_ym +1
			caster.bosspoint = caster.bosspoint -bosspointnum
			CallYmBoss(caster,playerID)
		else
			NotifyUtil.ShowError(playerID,"ym_cs",{value=num+1,boss_point=bosspointnum - bosspoint})
		end
	end 
	local unitKey = tostring(EntityHelper.getEntityIndex(caster))
 	local netTable = caster.cas_table
  	netTable["bosspoint"] = caster.bosspoint
  	SetNetTableValue("UnitAttributes",unitKey,netTable)	



end