



local m = {};

--level
--player_id
--game_event_listener
--game_event_name
--splitscreenplayer
--hero_entindex
function m:OnHeroLevelUp(keys)
	--如果英雄等级超过可获得技能点的等级，则设置技能点为：最大点数-使用的技能点
--	local player = EntityHelper.findEntityByIndex(keys.player_id)
	local player = keys.player_id
	if player then
		local hero = PlayerUtil.GetHero(player)
	--	local hero = player:GetAssignedHero();	--获取玩家单位
		local PlayerID = hero:GetPlayerOwnerID();--获取玩家ID
		if hero then
			m.addptsx(hero)
			local lv = hero:GetLevel()
			if hero:HasModifier("modifier_yxtfjn_aiou") then
				 m.aiou(hero,PlayerID)
			end
		   if lv == 30 then
		    	m.heroability(hero)
		   elseif lv == 60 then
		    	m.heroability(hero)
		    
		   elseif lv == 90 then
		    	m.heroability(hero)
		    	
		   elseif lv == 120 then
		    m.heroability(hero)
		    	
		   elseif lv == 150 then
		   	m.heroability(hero)    	
		   elseif lv == 17 then
			   	local jnd = hero:GetAbilityPoints() +1
				hero:SetAbilityPoints(jnd)
		   elseif lv == 19 then
			   	local jnd = hero:GetAbilityPoints() +1
				hero:SetAbilityPoints(jnd)
		   elseif lv == 21 then
			   local jnd = hero:GetAbilityPoints() +1
				hero:SetAbilityPoints(jnd)
		   elseif lv == 22 then
			   	local jnd = hero:GetAbilityPoints() +1
				hero:SetAbilityPoints(jnd)
		   elseif lv == 23 then
			    local jnd = hero:GetAbilityPoints() +1
				hero:SetAbilityPoints(jnd)
		   elseif lv == 24 then
			   	local jnd = hero:GetAbilityPoints() +1
				hero:SetAbilityPoints(jnd)
		   elseif lv == 26 then
			    local jnd = hero:GetAbilityPoints() +1
				hero:SetAbilityPoints(jnd)
		   elseif lv == 27 then
			    local jnd = hero:GetAbilityPoints() +1
				hero:SetAbilityPoints(jnd)
		   end

		end
	end

end


function m.heroability(caster )
	for i=0, 4 do
		if caster:GetAbilityByIndex(i) then
			local current_ability = caster:GetAbilityByIndex(i)
			local level = current_ability:GetLevel()
			local name = current_ability:GetAbilityName()
			local name2 = string.sub(name,1,3)
			if  name2 == "yxt"  then
				if level < caster.cas_table.yxtfdj then
					current_ability:SetLevel(level+1)
					return nil
				end
			end
		end
	end
	
end

---增加 攻击力，全属性这些
function m.addptsx(hero)
	--每次升级增加基础属性
	local sjjll = hero.cas_table.sjjll
	local sjjmj = hero.cas_table.sjjmj
	local sjjzl = hero.cas_table.sjjzl
	if sjjll ~= 0 and sjjll then
		local ll = hero:GetBaseStrength() + sjjll
		hero:SetBaseStrength(ll)
	end

	if sjjmj ~= 0 and sjjmj then
		local mj = hero:GetBaseAgility() + sjjmj
		hero:SetBaseAgility(mj)
	end

	if sjjzl ~= 0 and sjjzl then
		local zl = hero:GetBaseIntellect() + sjjzl
		hero:SetBaseIntellect(zl)
	end
	
end







---设置可用技能点
function m.calculateAbilityPoints(playerID,hero,totalPoint)
	if PlayerUtil.getAttrByPlayer(playerID,"NoAbilityPoints") then--技能点已经分配完毕的话，就直接设置当前可用为0
		hero:SetAbilityPoints(0);
		return;
	else --如果技能点尚未分配完，则计算已经分配的
		local usedAbilityPoints = 0
		for index=1, 4 do --目前所有英雄只有1-4技能是可以升级的
			local ability = hero:GetAbilityByIndex(index);
			if ability then
				usedAbilityPoints = usedAbilityPoints + ability:GetLevel();--每升一级使用一点
			end
		end

		local canUse = totalPoint - usedAbilityPoints;
		if canUse == 0 then--已用尽，可用设置为0，并记录当前玩家已经没有技能点可用
			hero:SetAbilityPoints(0);
			PlayerUtil.setAttrByPlayer(playerID,"NoAbilityPoints",true);
		else --未用尽的时候，设置可分配点数
			hero:SetAbilityPoints(canUse);
		end
	end
end


function m.aiou(hero,playerID)
	local b = {
	100,--金钱奖励权重
	80,--属性权重奖励
	20,--装备权重
	8--宝物


}
	local wei = Weightsgetvalue_one(b)
	local level =  hero:GetLevel()
	if wei == 1 then
		local gold = RandomInt(level*40,level*120)
		PlagueLand:ModifyCustomGold(playerID, gold)
		NotifyUtil.ShowSysMsg2(playerID,"aiou_gold",{value=gold})
	elseif wei== 2 then
		local r = RandomInt(1,3)
		local add = RandomInt(level*2,level*4)
	if r == 1 then
		local sx = hero:GetBaseStrength() + add
		hero:SetBaseStrength(sx)
		NotifyUtil.ShowSysMsg2(playerID,"aiou_jll",{value=add})
	end
	if r == 2 then
		local sx = hero:GetBaseAgility() + add
		hero:SetBaseAgility(sx)
		NotifyUtil.ShowSysMsg2(playerID,"aiou_jmj",{value=add})
	end
	if r == 3 then
		local sx = hero:GetBaseIntellect() + add
		hero:SetBaseIntellect(sx)
		NotifyUtil.ShowSysMsg2(playerID,"aiou_jzl",{value=add})
	end

	elseif wei== 3 then	
		local b ={
			96,
			48,
			12,
			4,
			1
		}
		local  pz = Weightsgetvalue_one(b)  +1
		NotifyUtil.ShowSysMsg2(playerID,"#aiou_item")
		itemgive(playerID,pz,1)
	elseif wei== 4 then
		local item = CreateItem("item_bw_1", hero, hero)
		hero:AddItem(item)	
		NotifyUtil.ShowSysMsg2(playerID,"#aiou_bw")
	end



	-- body
end






return m;

