---出售单个物品，对可分解物品会进行分解，返还杀敌数等奖励
function cswp2(item,playerID)
	  local totalMoney = 0;
	  --累计金额,删除物品
	  local sds = 0
	  local pz = 0
	  local lv = 0
	  local sdsnum = 0
  	if item:GetCost() <=50 then
  		--物品价格小于50的都不可出售
  		--专属武器和防具不可出售
  	else
	  	if item.pz then
	    	pz = zbds[item.pz]
	    end
	    if item.lv then
	    	lv =  zbxs[item.lv]
	    end
	    sdsnum =  pz*lv
	    if sds ==0 then
	    	sds = 1
	    end
	    local num =1
	    if item:IsStackable() then
	    	local num = item:GetCurrentCharges()
	   	end
	   totalMoney =  (item:GetCost()*sds * 0.5)  * num
	 
	    item:RemoveSelf() --移除掉掉落物中包含的物品，只删除上面的物品的话，item仍然存在，这样，如果玩家已经持有过25个物品，并卖掉了这些物品，将无法再次进行购买
	    sds=0
  	end
  	local hero = PlayerUtil.GetHero(playerID)
  	local unitKey = tostring(EntityHelper.getEntityIndex(hero))
 	local netTable = hero.cas_table
  	netTable["sds"] = netTable["sds"]+ sdsnum
  	SetNetTableValue("UnitAttributes",unitKey,netTable)	
	PlagueLand:ModifyCustomGold(playerID, totalMoney)
	PopupNum:PopupGoldGain(caster,totalMoney)
	NotifyUtil.ShowSysMsg2(playerID,"add_money",{value=totalMoney})
	if sdsnum > 0 then
		NotifyUtil.ShowSysMsg2(playerID,"add_sds",{value=sdsnum})
	end
end


---批量出售物品，对可分解物品会进行分解，返还杀敌数等奖励
function cswp3(ItemTable,playerID)
	--指定地点所有的物品
  if ItemTable == nil or #ItemTable == 0 or playerID == nil  then return end
	local totalMoney = 0;
  --累计金额,删除物品
  local sds = 0
  local pz = 0
  local lv = 0
  local sdsnum = 0
  for _,item in pairs(ItemTable) do
  	if item:GetCost() <=50 then
  		--物品价格小于50的都不可分解
  		--专属武器和防具不可分解
  	else
	  	if item.pz then
	    	pz = zbds[item.pz]
	    end
	    if item.lv then
	    	lv =  zbxs[item.lv]
	    end
	    sds = pz*lv
	    sdsnum = sdsnum+ sds
	    if sds ==0 then
	    	sds = 1
	    end
	    local num =1
	    if item:IsStackable() then
	    	local num = item:GetCurrentCharges()
	   	end
	    totalMoney = totalMoney + (item:GetCost()*sds * 0.5)
	    item:RemoveSelf() --移除掉掉落物中包含的物品，只删除上面的物品的话，item仍然存在，这样，如果玩家已经持有过25个物品，并卖掉了这些物品，将无法再次进行购买
	    sds=0
  	end
   
  end
  	local hero = PlayerUtil.GetHero(playerID)
  	local unitKey = tostring(EntityHelper.getEntityIndex(hero))
 	local netTable = hero.cas_table
	netTable["sds"] = netTable["sds"]+ sdsnum
  	SetNetTableValue("UnitAttributes",unitKey,netTable)	
	PlagueLand:ModifyCustomGold(playerID, totalMoney)
	PopupNum:PopupGoldGain(caster,totalMoney)
	NotifyUtil.ShowSysMsg2(playerID,"add_money",{value=totalMoney})
	if sdsnum > 0 then
		NotifyUtil.ShowSysMsg2(playerID,"add_sds",{value=sdsnum})
	end
end