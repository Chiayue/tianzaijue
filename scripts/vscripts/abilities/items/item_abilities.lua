function item_select_bw(keys)
	local caster = keys.caster
	local ability = keys.ability
	local PlayerID = caster:GetPlayerOwnerID()
	local lv = ability:GetLevelSpecialValueFor("lv", ability:GetLevel() - 1) or 0
	local charges = ability:GetCurrentCharges()
	if charges > 1 then
		ability:SetCurrentCharges(charges - 1)
	else
		UTIL_RemoveImmediate(ability)
	end
	--如果有了皇者之路，选择宝物之后也没效果，自动添加一次皇者之路BUFF
	local modifier = caster:FindModifierByName("modifier_bw_all_2")
	if modifier then
		if modifier:GetStackCount() < 18 then
			caster:AddNewModifier(caster, nil, "modifier_bw_all_2", {} )
			NotifyUtil.ShowSysMsg2(PlayerID,"#tip_item_treasure_give_nothing")
		else
			NotifyUtil.ShowError(PlayerID,"tip_item_treasure_full")
			return nil
		end
	else
		local treasures = PlayerUtil.getAttrByPlayer(PlayerID,"treasures")
		if not treasures then
			treasures = {}
			PlayerUtil.setAttrByPlayer(PlayerID,"treasures",treasures)
		end
		if #treasures >=18+caster.cas_table.treasure then
			NotifyUtil.ShowError(PlayerID,"tip_item_treasure_full")
			return nil
		else
			caster.SelectTreasure = true
			ShowSelectTreasureUI(PlayerID,lv)
		end

		
	end
	
		--如果有宝物收集，则有概率会获得一次宝物
		local ability = caster:FindAbilityByName("yxtfjn_hdfl") 
		if ability then
			local chance = ability:GetLevelSpecialValueFor("chance", ability:GetLevel() - 1)
			if RollPercent(chance) then
				local item = CreateItem("item_bw_1", caster, caster)
				caster:AddItem(item)
				NotifyUtil.ShowSysMsg(PlayerID,"#hdfl_bw")
			end	
		end

		--ability:RemoveSelf()
end