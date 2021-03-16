pray_all={
	"pray_3";
	"pray_4";
	"pray_5";
	"pray_6";
	"pray_7";
	"pray_7";
	"pray_7";
	  
	  
}


pray_qz={
	
	pray_3={
		item_xhp_tzboss_3_1=10;	
		item_xhp_tzboss_3_2=5;	
		item_xhp_tzboss_3_3=2;
		item_xhp_wzts_1=30;
		item_xhp_wzts_2=2;
	};
	pray_4={
		item_xhp_tzboss_4_1=10;	
		item_xhp_tzboss_4_2=5;	
		item_xhp_tzboss_4_3=2;
		item_xhp_wzts_1=10;
		item_xhp_wzts_2=3;

	};
	pray_5={
		item_xhp_tzboss_4_4=10;	
		item_xhp_tzboss_4_5=5;	
		item_xhp_tzboss_4_6=2;
		item_xhp_wzts_1=10;
		item_xhp_wzts_2=4;
		item_xhp_wzts_3=1;
	};
	pray_6={
		item_xhp_tzboss_5_1=100;	
		item_xhp_tzboss_5_2=50;	
		item_xhp_tzboss_5_3=20;
		item_xhp_wzts_1=100;
		item_xhp_wzts_2=40;
		item_xhp_wzts_3=20;
		item_xhp_wzts_4=6;
	};
	pray_7={
		item_xhp_sjboss_1_1=240;	
		item_xhp_sjboss_1_2=120;	
		item_xhp_sjboss_1_3=60;
		item_xhp_sjboss_1_4=30;	
		item_xhp_sjboss_1_5=15;	
		item_xhp_sjboss_1_6=4;
		item_xhp_sjboss_1_7=1;	
		item_xhp_wzts_2=120;
		item_xhp_wzts_3=50;
		item_xhp_wzts_4=20;
		item_xhp_wzts_5=5;
	};

}



pray_itemname={
	
	pray_3={
	"item_xhp_wzts_1";
	"item_xhp_wzts_2";
	"item_xhp_tzboss_3_1";
	"item_xhp_tzboss_3_2";
	"item_xhp_tzboss_3_3";
	};

	pray_4={
	"item_xhp_wzts_1";
	"item_xhp_wzts_2";
	"item_xhp_tzboss_4_1";
	"item_xhp_tzboss_4_2";
	"item_xhp_tzboss_4_3";
	};

	pray_5={
	"item_xhp_wzts_1";
	"item_xhp_wzts_2";
	"item_xhp_wzts_3";
	"item_xhp_tzboss_4_4";
	"item_xhp_tzboss_4_5";
	"item_xhp_tzboss_4_6";
	};
	pray_6={
	"item_xhp_wzts_1";
	"item_xhp_wzts_2";
	"item_xhp_wzts_3";
	"item_xhp_wzts_4";
	"item_xhp_tzboss_5_1";
	"item_xhp_tzboss_5_2";
	"item_xhp_tzboss_5_3";
	};
	pray_7={
	"item_xhp_wzts_2";
	"item_xhp_wzts_3";
	"item_xhp_wzts_4";
	"item_xhp_wzts_5";
	"item_xhp_sjboss_1_1";
	"item_xhp_sjboss_1_2";
	"item_xhp_sjboss_1_3";
	"item_xhp_sjboss_1_4";
	"item_xhp_sjboss_1_5";
	"item_xhp_sjboss_1_6";
	"item_xhp_sjboss_1_7";
	};

}

function pray(keys)
	local caster = keys.caster
	local ability =keys.ability
	--许愿的金币
	local wave = Stage.wave +1 
	local gold = RandomInt(100,200) * wave

	local i = caster:GetPlayerOwnerID();--获取玩家ID
	caster= PlayerUtil.GetHero(i)
	local jqjc = 100
	--受到VIP加成
	if caster.jqjc then
		jqjc = caster.jqjc + jqjc		
	end
	local gold = gold * jqjc / 100
	PopupNum:PopupGoldGain(caster,gold)
	PlayerUtil.ModifyGold(caster,gold)
	NotifyUtil.ShowSysMsg2(i,"pray_money",{value=gold})
	local level = caster:GetLevel()
	local itemname = pray_item_name(level)
	--是否是第一次祝福
	if caster.pray then
		--不是就正常流程	
		local item = CreateItem(itemname, caster, caster)
		caster:AddItem(item)

	else
		--是的话就送一颗宝石,再走流程 
		caster.pray = true
		if RollPercentage(20) then
			local item = CreateItem(itemname, caster, caster)
			caster:AddItem(item)
		end


		local zsx = PlayerUtil.GetHero(i).zsx
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

	end

end



--祈愿得到的物品名字
function pray_item_name(level)
	-- body
	wave = math.ceil(level/30)
	local itemname = pray_all[wave]

	local x = 0
	local y = 0
	local qz = {}
	local sx = {}
	local n = #pray_itemname[itemname]
	--获取最高的概率加成
	for i=1, n do
		--获取权重
		y = pray_qz[itemname][pray_itemname[itemname][i]]
		--建立权重表
		qz[i] = y
		--建立词条表
		sx[i] = pray_itemname[itemname][i]
	end
	--根据权重获得到的道具名
	local randomValue = GetRanomByWeight(sx, qz)

	return randomValue
end






function ss( t )
	
	local caster = t.caster
	
	local ability = t.ability
	local target_location = t.target_points[1]
	local speed = ability:GetSpecialValueFor("speed")
	local max_distance = ability:GetSpecialValueFor("max_distance")
	local distance = (target_location - caster:GetAbsOrigin()):Length2D()
	local height = ability:GetSpecialValueFor("height")
	for var=1, 4 do
		local shoppoint = EntityHelper.findEntityByName("sd_"..tostring(var)):GetAbsOrigin()
		if (shoppoint - target_location):Length2D() <= 300 then
			Teleport(caster,shoppoint,true)
			if caster:HasModifier("modifier_bw_all_93") then
				local damage = caster:GetStrength() * 5
				local units = FindAlliesInRadiusExdd(caster,caster:GetAbsOrigin(),300)
				local particleID= ParticleManager:CreateParticle("particles/items3_fx/blink_overwhelming_end.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster)
				ParticleManager:SetParticleControl(particleID,0,caster:GetAbsOrigin())
				for k,unit in pairs(units) do
					if not unit.isboss and unit:IsAlive() then
						ability:ApplyDataDrivenModifier(caster,unit,"modifier_ability_hero_2_3",{duration = 0.75})
					end
					ApplyDamageEx(caster,unit,ability,damage)
				end
			end
			if caster:HasModifier("modifier_bw_all_94") then	
				local particleID= ParticleManager:CreateParticle("particles/items3_fx/blink_swift_end.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster)
				ParticleManager:SetParticleControl(particleID,0,caster:GetAbsOrigin())		
				ability:ApplyDataDrivenModifier(caster,caster,"modifier_ability_hero_2_4",{duration = 3})
			end
			if caster:HasModifier("modifier_bw_all_95") then			
				if RollPercentage(50) then		
					local particleID= ParticleManager:CreateParticle("particles/items3_fx/blink_arcane_end.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster)
					ParticleManager:SetParticleControl(particleID,0,caster:GetAbsOrigin())
					ability:EndCooldown()
				end
			end
			return nil
		end
	end
	
	local findPath = true
	
	if distance > max_distance then 
		distance = max_distance 
		target_location = caster:GetAbsOrigin() + (target_location - caster:GetAbsOrigin()):Normalized() * distance
	end
--	local i = RandomInt(1,6)
	local pid = "particles/common/jump/jump.vpcf"
--	if i == 2 then
--		pid = "particles/units/heroes/hero_ember_spirit/ember_spirit_remnant_dash.vpcf"
--	elseif i == 3 then
--		pid = "particles/units/heroes/hero_stormspirit/stormspirit_ball_lightning.vpcf"
--	elseif i == 4 then
	--	pid = "particles/common/jump/jump_3.vpcf"
	--elseif i == 5 then
	--	pid = "particles/common/jump/jump_4.vpcf"
--	elseif i == 6 then
	--	pid = "particles/guanghuan/jump_faceless_custom.vpcf"
--	end
	local ParticleID = CreateParticleEx(pid,PATTACH_ABSORIGIN_FOLLOW,caster)
	-- 这里给了一个缠绕的buff
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_ability_hero_2", nil)
	-- 跳跃期间禁用技能
	ability:SetActivated(false)
	-- 调用跳跃函数，findPath为true时不能到达无法寻路的地点
	Jump(caster,ability,target_location,speed,height,findPath,function ()
		-- 这里写跳跃完成后的事件，比如晕和伤害
		caster:RemoveModifierByName("modifier_ability_hero_2")
		ability:SetActivated(true)
	end)
	TimerUtil.createTimerWithDelay(0.4,function()
		--QingYunHouShan.init()
		ParticleManager:DestroyParticle(ParticleID, false)
	end)
	EmitSound(caster,"Hero_Riki.Blink_Strike")
	if modifier then
		modifier:DecrementStackCount()
	end


end







--跳跃函数
 function Jump(caster,ability,target_location,speed,height,findPath,callback)
	local caster_location = caster:GetAbsOrigin()
	local fix_location = target_location
	local direction = (target_location - caster_location):Normalized()
	if findPath then
		if GridNav:CanFindPath(caster_location, target_location) == false then
			while(GridNav:CanFindPath(caster_location, fix_location) == false)
			do
				fix_location = fix_location - direction * 50
			end
			target_location = fix_location
		end
	end
	local distance = (target_location - caster:GetAbsOrigin()):Length2D()
	local height_fix = (caster_location.z - target_location.z) / distance
	local currentPos = Vector(0,0,0)
	speed = speed / 20
	local traveled_distance = 0
	Timers:CreateTimer(function ()
		if traveled_distance < distance then
			currentPos = caster:GetAbsOrigin() + direction * speed
			currentPos.z = caster_location.z + (-4 * height) / (distance ^ 2) * traveled_distance ^ 2 + (4 * height) / distance * traveled_distance - height_fix * traveled_distance
			caster:SetAbsOrigin(currentPos)
			traveled_distance = traveled_distance + speed
			return 0.01
		else--到达目标点
			--避免卡在某些场景里
			Teleport(caster,target_location,true)
			caster:Stop()--在服务器上如果不停止一下的话，单位会一直原地显示跑的动作
			if caster:HasModifier("modifier_bw_all_93") then
				local damage = caster:GetStrength() * 5
				local units = FindAlliesInRadiusExdd(caster,caster:GetAbsOrigin(),300)
				local particleID= ParticleManager:CreateParticle("particles/items3_fx/blink_overwhelming_end.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster)
				ParticleManager:SetParticleControl(particleID,0,caster:GetAbsOrigin())
				for k,unit in pairs(units) do
					if not unit.isboss and unit:IsAlive() then
						ability:ApplyDataDrivenModifier(caster,unit,"modifier_ability_hero_2_3",{duration = 0.75})
					end
					ApplyDamageEx(caster,unit,ability,damage)
				end
			end
			if caster:HasModifier("modifier_bw_all_94") then		
				local particleID= ParticleManager:CreateParticle("particles/items3_fx/blink_swift_end.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster)
				ParticleManager:SetParticleControl(particleID,0,caster:GetAbsOrigin())	
				ability:ApplyDataDrivenModifier(caster,caster,"modifier_ability_hero_2_4",{duration = 3})
			end
			if caster:HasModifier("modifier_bw_all_95") then	
				if RollPercentage(50) then		
					local particleID= ParticleManager:CreateParticle("particles/items3_fx/blink_arcane_end.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster)
					ParticleManager:SetParticleControl(particleID,0,caster:GetAbsOrigin())
					ability:EndCooldown()
				end
			end
			if callback ~= nil then callback() end
		end
	end)
end




