
--吞噬神器
function ts_sq( keys )
	local caster = keys.caster
	local ability = keys.ability
	local playerID = caster:GetPlayerOwnerID()
	local hero = PlayerUtil.GetHero(playerID)
	local iname = ability:GetAbilityName()
	local itemtable = PlayerUtil.getAttrByPlayer(playerID,"itemtable")
	local gold2 = itemtable[iname]
	local xj = PlagueLand:GetNowGold(playerID)
	ability:RemoveSelf()
	if xj < gold2 then
		NotifyUtil.ShowError(playerID,"money_not",{value=gold2-xj})
		return nil
	end
	if caster.tscs > 3 then
		NotifyUtil.ShowError(playerID,"#tscs_not")
		return nil
	end
	local item = hero:GetItemInSlot(5)
	if item then
		if string.sub(item:GetName(),1,7) == "item_sq"  then
			gold2=-gold2
			caster.tscs = caster.tscs + 1
			PlagueLand:ModifyCustomGold(playerID, gold2)
			if caster.tscs == 1 then
				itemtable[iname] = 5000000
			elseif caster.tscs == 2 then
				itemtable[iname] = 20000000

			elseif caster.tscs == 3 then
				itemtable[iname] = 50000000
			else
				itemtable[iname] = 500000000
			end
			PlayerUtil.setAttrByPlayer(playerID,"itemtable",itemtable)
			SetNetTableValue("custom_shop","dynamic_cost_"..playerID,itemtable)
			local att = {} --存特殊词条
			local att2 = {} --存技能词条
			if not hero.sq_ts then
				hero.sq_ts = {}
			end
			for k,v in pairs(item.itemtype.item_attributes) do
				if k == "wlbjgl" then	
					att[k] = v
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
				elseif k == "wlbjsh" then
					att[k] = v
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
				elseif k == "mfbjgl" then
					att[k] = v
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
				elseif k == "mfbjsh" then
					att[k] = v
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
				elseif k == "gjl" then
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
					AddLuaModifier(hero,hero,"item_sqts_gjl",{},nil)
				elseif k == "gjsd" then
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
					AddLuaModifier(hero,hero,"item_sqts_gjsd",{},nil)
				elseif k == "bfbtsqsx" then
					att[k] = v
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
				elseif k == "jnsh" then
					att[k] = v
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
					AddLuaModifier(hero,hero,"item_sqts_jnsh",{},nil)
				elseif k == "zzsh" then
					att[k] = v
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
				elseif k == "jqjc" then
					att[k] = v
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
				elseif k == "jyjc" then
					att[k] = v
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
				elseif k == "shjm" then
					att[k] = v
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
				elseif k == "grjndj" then
					att[k] = v
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
				elseif k == "lqsj" then
					att[k] = v
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
					AddLuaModifier(hero,hero,"item_sqts_lqsj",{},nil)
				else  
					att2[k] = v
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
				end
			end
			NotifyUtil.ShowSysMsg(playerID,"#tscs_cg")
			AttributesSet(hero,att)
			AttributesSet2(hero,att2)
			item:RemoveSelf()
  		end
	else
		NotifyUtil.ShowError(playerID,"not_item")
		return nil
	end
end



--吞噬神器
function ts_sq2( keys )
	local caster = keys.caster
	local ability = keys.ability
	local playerID = caster:GetPlayerOwnerID()
	local hero = PlayerUtil.GetHero(playerID)
	local iname = ability:GetAbilityName()
	local itemtable = PlayerUtil.getAttrByPlayer(playerID,"itemtable")
	local item = hero:GetItemInSlot(5)
	if item then
		if string.sub(item:GetName(),1,7) == "item_sq"  then
			local att = {} --存特殊词条
			local att2 = {} --存技能词条
			if not hero.sq_ts then
				hero.sq_ts = {}
			end
			for k,v in pairs(item.itemtype.item_attributes) do
				if k == "wlbjgl" then	
					att[k] = v
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
				elseif k == "wlbjsh" then
					att[k] = v
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
				elseif k == "mfbjgl" then
					att[k] = v
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
				elseif k == "mfbjsh" then
					att[k] = v
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
				elseif k == "gjl" then
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
					AddLuaModifier(hero,hero,"item_sqts_gjl",{},nil)
				elseif k == "gjsd" then
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
					AddLuaModifier(hero,hero,"item_sqts_gjsd",{},nil)
				elseif k == "bfbtsqsx" then
					att[k] = v
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
				elseif k == "jnsh" then
					att[k] = v
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
					AddLuaModifier(hero,hero,"item_sqts_jnsh",{},nil)
				elseif k == "zzsh" then
					att[k] = v
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
				elseif k == "jqjc" then
					att[k] = v
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
				elseif k == "jyjc" then
					att[k] = v
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
				elseif k == "shjm" then
					att[k] = v
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
				elseif k == "grjndj" then
					att[k] = v
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
				elseif k == "lqsj" then
					att[k] = v
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
					AddLuaModifier(hero,hero,"item_sqts_lqsj",{},nil)
				else  
					att2[k] = v
					if not hero.sq_ts[k] then
						hero.sq_ts[k] = 0
					end
					hero.sq_ts[k] = hero.sq_ts[k] + v
				end
			end
			NotifyUtil.ShowSysMsg(playerID,"#tscs_cg")
			AttributesSet(hero,att)
			AttributesSet2(hero,att2)
			UTIL_RemoveImmediate(ability)
			item:RemoveSelf()
  		end
	else
		NotifyUtil.ShowError(playerID,"not_item")
		return nil
	end
end