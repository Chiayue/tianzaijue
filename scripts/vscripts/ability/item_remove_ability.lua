kjn={

	"kjn_1";
	"kjn_2";
	"kjn_3";
	"kjn_4";
	"kjn_5";
	"kjn_6";
}

function RemoveAbility(_,data)
	local pid = data.PlayerID
	local abilities = data.ability
	if abilities then
		local caster = PlayerUtil.GetHero(pid)
		for _, name in pairs(abilities) do
			for i=1,5 do			 
				 if name == caster:GetAbilityByIndex(i-1):GetAbilityName() then
					local name2 = kjn[i] 		

					local jnd = caster:GetAbilityPoints()
					local jnd2 = caster:GetAbilityByIndex(i-1):GetLevel() -1
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