--不用秘诀可以回收掉，可以用来兑换指定秘诀

wzts_all={
	"wzts_1";
	"wzts_2";
	"wzts_3";
	"wzts_4";
	"wzts_5";
	"wzts_6";
	"wzts_7";
	
}
wzts_abilityname={
	
	wzts_1={
	   --技能一
		"jn_1";
		--秘诀一
		"mj"
	};

	wzts_2={
	   --技能一
		"jn_2";
		--秘诀一
		"mj"
	};

	wzts_3={
	   --技能一
		"jn_3";
		--秘诀一
		"mj"
	};

	wzts_4={
	   --技能一
		"jn_4";
		--秘诀一
		"mj"
	};

	wzts_5={
	   --技能一
		"jn_5";
		--秘诀一
		"mj"
	};

	wzts_6={
	   --技能一
		"jn_6";
		--秘诀一
		"mj"
	};






}





function wzts(keys)
	local caster = keys.caster
	local ability = keys.ability
	local pz = ability:GetLevelSpecialValueFor("pz", ability:GetLevel()-1)
	local num = ability:GetLevelSpecialValueFor("num", ability:GetLevel()-1)
	local charges = ability:GetCurrentCharges()
	--获取使用者的玩家ID，哪怕是信使也不会影响
	local playerID = caster:GetPlayerOwnerID()
	--获取玩家英雄的主属性
	local zsx = PlayerUtil.GetHero(playerID).zsx

	if charges > 1 then
		ability:SetCurrentCharges(charges - 1)
	else
		UTIL_RemoveImmediate(ability)
	end

	--开始获取能得到的物品
	local itemname = wzts_abilityname[wzts_all[pz]][1]

	if itemname == "jn_1" then
		if zsx ==1 then
			local length = #Itemjndl.lljn1
			local random = RandomInt(1,length)
			local itemname2 = Itemjndl.lljn1[random]
			local item = CreateItem(itemname2, caster, caster)
			caster:AddItem(item)
		end

		if zsx ==2 then
			local length = #Itemjndl.mjjn1
			local random = RandomInt(1,length)
			local itemname2 = Itemjndl.mjjn1[random]
			local item = CreateItem(itemname2, caster, caster)
			caster:AddItem(item)
		end

		if zsx ==3 then
			local length = #Itemjndl.zljn1
			local random = RandomInt(1,length)
			local itemname2 = Itemjndl.zljn1[random]
			local item = CreateItem(itemname2, caster, caster)
			caster:AddItem(item)
		end
	elseif itemname == "jn_2" then
		if zsx ==1 then
			local length = #Itemjndl.lljn2
			local random = RandomInt(1,length)
			local itemname2 = Itemjndl.lljn2[random]
			local item = CreateItem(itemname2, caster, caster)
			caster:AddItem(item)
			return nil
		end

		if zsx ==2 then
			local length = #Itemjndl.mjjn2
			local random = RandomInt(1,length)
			local itemname2 = Itemjndl.mjjn2[random]
			local item = CreateItem(itemname2, caster, caster)
			caster:AddItem(item)
			return nil
		end

		if zsx ==3 then
			local length = #Itemjndl.zljn2
			local random = RandomInt(1,length)
			local itemname2 = Itemjndl.zljn2[random]
			local item = CreateItem(itemname2, caster, caster)
			caster:AddItem(item)
			return nil
		end
	elseif itemname == "jn_3" then
		if zsx ==1 then
			local length = #Itemjndl.lljn3
			local random = RandomInt(1,length)
			local itemname2 = Itemjndl.lljn3[random]
			local item = CreateItem(itemname2, caster, caster)
			caster:AddItem(item)
			return nil
		end

		if zsx ==2 then
			local length = #Itemjndl.mjjn3
			local random = RandomInt(1,length)
			local itemname2 = Itemjndl.mjjn3[random]
			local item = CreateItem(itemname2, caster, caster)
			caster:AddItem(item)
			return nil
		end

		if zsx ==3 then
			local length = #Itemjndl.zljn3
			local random = RandomInt(1,length)
			local itemname2 = Itemjndl.zljn3[random]
			local item = CreateItem(itemname2, caster, caster)
			caster:AddItem(item)
			return nil
		end
	elseif itemname == "jn_4" then
		if zsx ==1 then
			local length = #Itemjndl.lljn4
			local random = RandomInt(1,length)
			local itemname2 = Itemjndl.lljn4[random]
			local item = CreateItem(itemname2, caster, caster)
			caster:AddItem(item)
			return nil
		end

		if zsx ==2 then
			local length = #Itemjndl.mjjn4
			local random = RandomInt(1,length)
			local itemname2 = Itemjndl.mjjn4[random]
			local item = CreateItem(itemname2, caster, caster)
			caster:AddItem(item)
			return nil
		end

		if zsx ==3 then
			local length = #Itemjndl.zljn4
			local random = RandomInt(1,length)
			local itemname2 = Itemjndl.zljn4[random]
			local item = CreateItem(itemname2, caster, caster)
			caster:AddItem(item)
			return nil
		end
	elseif itemname == "jn_5" then
		if zsx ==1 then
			local length = #Itemjndl.lljn5
			local random = RandomInt(1,length)
			local itemname2 = Itemjndl.lljn5[random]
			local item = CreateItem(itemname2, caster, caster)
			caster:AddItem(item)
			return nil
		end

		if zsx ==2 then
			local length = #Itemjndl.mjjn5
			local random = RandomInt(1,length)
			local itemname2 = Itemjndl.mjjn5[random]
			local item = CreateItem(itemname2, caster, caster)
			caster:AddItem(item)
			return nil
		end

		if zsx ==3 then
			local length = #Itemjndl.zljn5
			local random = RandomInt(1,length)
			local itemname2 = Itemjndl.zljn5[random]
			local item = CreateItem(itemname2, caster, caster)
			caster:AddItem(item)
			return nil
		end
	elseif itemname == "jn_6" then
		if zsx ==1 then
			local length = #Itemjndl.lljn6
			local random = RandomInt(1,length)
			local itemname2 = Itemjndl.lljn6[random]
			local item = CreateItem(itemname2, caster, caster)
			caster:AddItem(item)
			return nil
		end

		if zsx ==2 then
			local length = #Itemjndl.mjjn6
			local random = RandomInt(1,length)
			local itemname2 = Itemjndl.mjjn6[random]
			local item = CreateItem(itemname2, caster, caster)
			caster:AddItem(item)
			return nil
		end

		if zsx ==3 then
			local length = #Itemjndl.zljn6
			local random = RandomInt(1,length)
			local itemname2 = Itemjndl.zljn6[random]
			local item = CreateItem(itemname2, caster, caster)
			caster:AddItem(item)
			return nil
		end
	end








end