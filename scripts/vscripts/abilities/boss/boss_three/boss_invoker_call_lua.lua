boss_invoker_call_lua = class({})
LinkLuaModifier( "modifier_boss_invoker_call_lua","lua_modifiers/boss/boss_three/modifier_boss_invoker_call_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function boss_invoker_call_lua:OnSpellStart()
	if Stage.kezhw==nil then
		Stage.kezhw={}
	end
	if self.times==nil then
		self.times=1
	elseif self.times==1 and self:GetCaster():GetHealthPercent()<95 then
		self.times=2
	elseif self.times==2 and self:GetCaster():GetHealthPercent()<70 then
		self.times=3
	elseif self.times==3 and self:GetCaster():GetHealthPercent()<45 then
		self.times=4
	else
		return
	end
	local num =   math.ceil(Stage.playernum /2  + GetGameDifficulty() /8)
	if num < 2 then
		num = 2
	end
	if num > 4 then
		num = 4
	end
	if #Stage.kezhw>10 then
		num=0
	end

	local hCaster = self:GetCaster()
	if self.monster==nil then
		self.monster={"npc_invoker_fire","npc_invoker_dust","npc_invoker_water","npc_invoker_thender"}
		self.monster_one={}
		
		local unitname=self.monster[RandomInt(1,#self.monster)]
		table.insert(self.monster_one,unitname)
		for i=1,num do
			local unit= CreateUnitByName(unitname, hCaster:GetOrigin()+RandomVector(1200), true, hCaster, hCaster, hCaster:GetTeamNumber())	
			local hp = hCaster:GetMaxHealth()	--设置怪物的动态血量	
			local maxhp = hp * 0.3  --怪物7倍血量
			unit:SetBaseMaxHealth(maxhp)

			local armor = hCaster:GetPhysicalArmorBaseValue()	--设置怪物的动态护甲
			local maxarmor = armor * 0.5
			unit:SetPhysicalArmorBaseValue(maxarmor)

			local mk = hCaster:GetBaseMagicalResistanceValue()
			local maxmk = mk*1
			unit:SetBaseMagicalResistanceValue(maxmk)

			local attack = hCaster:GetBaseDamageMax()
		
			local maxattack = attack * 0.4
			unit:SetBaseDamageMin(maxattack)
			unit:SetBaseDamageMax(maxattack)

			unit.kaer = 1
			table.insert(Stage.kezhw,unit:GetEntityIndex())
			--同步往服务器发怪物目前的数量
			local  nowchs = #Stage.kezhw
			for _, PlayerID in pairs(Stage.playeronline) do
				nowchs = nowchs + Stage.chs["chs"..PlayerID+1]
			end
			CustomGameEventManager:Send_ServerToAllClients("tzj_topbar_update_monster_count",{now=nowchs,max=Stage.maxchs})
	    end
	       
        for k,v in pairs(self.monster) do
			if v==unitname then
				table.remove(self.monster, k)
			end
		end
		hCaster:AddNewModifier( self:GetCaster(), self, "modifier_boss_invoker_call_lua", {} )
	else
		if #self.monster>0 then
			local unitname=self.monster[RandomInt(1,#self.monster)]
			table.insert(self.monster_one,unitname)
			if  #self.monster==1 then
				for i=1,num  do
					local unit= CreateUnitByName(unitname, hCaster:GetOrigin()+RandomVector(1200), true, hCaster, hCaster, hCaster:GetTeamNumber() )	
					local hp = hCaster:GetMaxHealth()	--设置怪物的动态血量	
					local maxhp = hp * 0.3  --怪物7倍血量
					unit:SetBaseMaxHealth(maxhp)

					local armor = hCaster:GetPhysicalArmorBaseValue()	--设置怪物的动态护甲
					local maxarmor = armor * 0.5
					unit:SetPhysicalArmorBaseValue(maxarmor)

					local mk = hCaster:GetBaseMagicalResistanceValue()
					local maxmk = mk*0.5
					unit:SetBaseMagicalResistanceValue(maxmk)

					local attack = hCaster:GetBaseDamageMax()
				
					local maxattack = attack * 0.4
					unit:SetBaseDamageMin(maxattack)
					unit:SetBaseDamageMax(maxattack)
					unit.kaer = 1
					table.insert(Stage.kezhw,unit:GetEntityIndex())
					--同步往服务器发怪物目前的数量
					local  nowchs = #Stage.kezhw
					for _, PlayerID in pairs(Stage.playeronline) do
						nowchs = nowchs + Stage.chs["chs"..PlayerID+1]
					end
					CustomGameEventManager:Send_ServerToAllClients("tzj_topbar_update_monster_count",{now=nowchs,max=Stage.maxchs})
			    end
			else
				for i=1,num do
					local unit= CreateUnitByName(unitname, hCaster:GetOrigin()+RandomVector(1200), true, hCaster, hCaster, hCaster:GetTeamNumber() )	
					local hp = hCaster:GetMaxHealth()	--设置怪物的动态血量	
					local maxhp = hp * 0.3  --怪物7倍血量
					unit:SetBaseMaxHealth(maxhp)

					local armor = hCaster:GetPhysicalArmorBaseValue()	--设置怪物的动态护甲
					local maxarmor = armor * 0.5
					unit:SetPhysicalArmorBaseValue(maxarmor)

					local mk = hCaster:GetBaseMagicalResistanceValue()
					local maxmk = mk*0.5
					unit:SetBaseMagicalResistanceValue(maxmk)

					local attack = hCaster:GetBaseDamageMax()
				
					local maxattack = attack * 0.4
					unit:SetBaseDamageMin(maxattack)
					unit:SetBaseDamageMax(maxattack)
					unit.kaer = 1
					table.insert(Stage.kezhw,unit:GetEntityIndex())
					--同步往服务器发怪物目前的数量
					local  nowchs = #Stage.kezhw
					for _, PlayerID in pairs(Stage.playeronline) do
						nowchs = nowchs + Stage.chs["chs"..PlayerID+1]
					end
					CustomGameEventManager:Send_ServerToAllClients("tzj_topbar_update_monster_count",{now=nowchs,max=Stage.maxchs})
			    end
			end
			
		       
	        for k,v in pairs(self.monster) do
				if v==unitname then
					table.remove(self.monster,k)
				end
			end
		end
	end
    
       
end