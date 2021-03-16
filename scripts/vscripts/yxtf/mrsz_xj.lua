
function xj( keys )
	local caster = keys.caster
	local ability= keys.ability
	local lv = caster:GetLevel()
	local level =  ability:GetLevel() - 1
	local playerID = caster:GetPlayerOwnerID()
	local gold = ability:GetLevelSpecialValueFor("gold", level) 
	local add = ability:GetLevelSpecialValueFor("add", level) 
	if caster.xjcs then 
		gold = gold * (1+caster.xjcs/50)
	end
	local xj = PlagueLand:GetNowGold(playerID)
	if xj >= gold  then
		if caster.xjcs then
			caster.xjcs = caster.xjcs +1
			local modifier = caster:FindModifierByName("modifier_yxtfjn_mrsz")
			modifier:SetStackCount(modifier:GetStackCount()+1)
		else
			caster.xjcs = 1
			local modifier = ability:ApplyDataDrivenModifier(caster,caster,"modifier_yxtfjn_mrsz",{})
			modifier:SetStackCount(1)
		end 

		gold=-gold
		PlagueLand:ModifyCustomGold(playerID, gold)
		add = add*(1+level/5)

		local sx = caster:GetBaseStrength() + add
		caster:SetBaseStrength(sx)	
		sx = caster:GetBaseAgility() + add
		caster:SetBaseAgility(sx)
		sx = caster:GetBaseIntellect() + add
		caster:SetBaseIntellect(sx)
		caster:CalculateStatBonus(true)
		NotifyUtil.ShowSysMsg2(playerID,"mrsz_xj",{value=add})
		if caster.xjcs % 10 ==0 then
			local unitKey = tostring(EntityHelper.getEntityIndex(caster))
			if not caster.cas_table then
				caster.cas_table = {}
			end
			local netTable = caster.cas_table --服务端存储，避免使用getNetTable方法
			netTable["zzsh"] = netTable["zzsh"] + 1
			SetNetTableValue("UnitAttributes",unitKey,netTable)
		end
	else
		gold = gold - xj
		NotifyUtil.ShowError(playerID,"money_not",{value=gold})
	end

	

end