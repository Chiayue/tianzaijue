kjn={

	"kjn_1";
	"kjn_2";
	"kjn_3";
	"kjn_4";
	"kjn_5";
	"kjn_6";
}

-- 获取一个空的技能
local function findEmptyAbility2(caster)
	local name = {}
	for i=1,5 do
		table.insert(name,"kjn_"..i)
	end
	for i=0,4 do			 
		local ability = caster:GetAbilityByIndex(i)
		if ability then
			for k,v in pairs(name) do
				if ability:GetAbilityName() == v then
					table.remove(name,k)
				end
			end
		end
	end
	return name[1]
end

function RemoveAbility(_,data)
	local pid = data.PlayerID
	local abilities = data.ability
	if abilities then
		local caster = PlayerUtil.GetHero(pid)
		for _, name in pairs(abilities) do
			for i=1,5 do			 
				local ability = caster:GetAbilityByIndex(i-1)
				 if ability and name == ability:GetAbilityName() then
					local name2 = findEmptyAbility2(caster) 		
					local jnd = caster:GetAbilityPoints()
					local jnd2 = ability:GetLevel() -1
				 	jnd = jnd +jnd2
				    caster:SetAbilityPoints(jnd)
					caster:AddAbility(name2)
					caster:FindAbilityByName(name2):SetLevel(1)
					caster:SwapAbilities(name2,name,true,true)
					caster:RemoveAbility(name)
						if name == "zljcjn_dyh1" then	--如果删除了技能，就让玩家所有的地狱火死亡
							killdyh(caster)
						elseif name == "zljcjn_dyh3" then	--如果删除了技能，就让玩家所有的地狱火死亡
							killdyh(caster)
						elseif name == "zljcjn_dyh6" then	--如果删除了技能，就让玩家所有的地狱火死亡
							killdyh(caster)
						end
					-- 移除技能的modifier
					local modifiers = caster:FindAllModifiers()
					for _, modifier in pairs(modifiers) do
						if modifier:GetAbility() ~= nil  then
							if modifier:GetAbility():GetAbilityName() == name then
								modifier:Destroy()
							end
						end
					end			
				 end
			end	
		end
	end	
end


--SetAbilityIndex 只能通过技能实体来设置技能下标，不能通过技能名字来设置

function SwapAbility(_,data)
	local pid = data.PlayerID
	local abilities = data.ability
	if abilities then
		local caster = PlayerUtil.GetHero(pid)
		for k,v in pairs(abilities) do
			local name = caster:GetAbilityByIndex(tonumber(k)):GetAbilityName()
			caster:SwapAbilities(v,name,true,true)
		end
	end
end

function killdyh( caster )
	local units = caster.dyhunits;
	if units and #units > 0 then
		local count = #units
		for index=count, 1, -1 do
			local unit = units[index]
			if unit then
				if unit:IsAlive() then
					unit:ForceKill(true)
				end
			end
			table.remove(units,index)
		end
	end
end