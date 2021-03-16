zswq = {
	"item_zswq_1";
	"item_zswq_2";
	"item_zswq_3";
	"item_zswq_4";
	"item_zswq_5";
	"item_zswq_6";
	"item_zswq_7";
	"item_zswq_8";
	"item_zswq_9";
	"item_zswq_10";
	"item_zswq_11";
}


boss={
	"wq_BOSS_1";
	"fj_BOSS_1";

}


--动态调整BOSS血量
wq_boss_hp={
	1500;
	5000;
	15000;
	75000;
	200000;
	600000;
	2000000;
	6000000;
	6000000;
	6000000;
	6000000;
	6000000;
	6000000;
	6000000;


}
--动态调整BOSS攻击力
wq_boss_damage={
	100;
	500;
	2000;
	7500;
	22500;
	73500;
	223500;
	643500;
	2993500;
	10000000;
	10000000;
	10000000;
	10000000;
}


--动态调整BOSS护甲
wq_boss_armor={
	5;
	10;
	20;
	35;
	45;
	60;
	80;
	100;
	400;
	1500;
	5500;
	17500;
	50000
	
}















function xb( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local radius = ability:GetLevelSpecialValueFor("radius", level)
	local i = ability:GetLevelSpecialValueFor("i", level)	
	
	local sx = 0
	if EntityHelper.IsStrengthHero(caster) then
		 sx = caster:GetStrength()
	else
	if EntityHelper.IsAgilityHero(caster)then
		 sx = caster:GetAgility()
	else
		 sx = caster:GetIntellect()
	end
	end
	
	local point = target:GetAbsOrigin()

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_double_edge.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin()) -- Origin
	ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin()) -- Destination
	ParticleManager:SetParticleControl(particle, 5, target:GetAbsOrigin()) -- Hit Glow				
	

	--local units = FindAlliesInRadiusEx(target,point,radius)
	local units = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false)
	

	local damage = sx * i
	for key, unit in pairs(units) do			
		ApplyDamageEx(caster,unit,ability,damage)
		ShowOverheadMsg(unit,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)

	end

	

end





function sjzswq( keys )
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local lv = ability:GetLevelSpecialValueFor("lv", level)
	local gold =	ability:GetLevelSpecialValueFor("gold", level)
	if caster:HasModifier("modifier_yxtfjn_longqishi") then
		gold = gold / 2
	end
	local playerID = caster:GetPlayerOwnerID()
	local xj = PlagueLand:GetNowGold(playerID)
	--获取装备类型  1代表武器，2代表防具
	local lx =	ability:GetLevelSpecialValueFor("lx", level)
	--如果十阶能量之心，而且不是龙骑士则不饿能升级为11阶
	if lv == 10 then
		if not caster:HasModifier("modifier_yxtfjn_longqishi") and caster.cas_table.nlzx10 ==0 then
			NotifyUtil.ShowError(playerID,"nlzx_not",{value=lv+1})
			return nil
		end
	end
	if lv >= 11 then
		if caster.cas_table["nlzx"..lv] == 0 then
			NotifyUtil.ShowError(playerID,"nlzx_not",{value=lv+1})
			return nil
		end
	end


	if lx == 1 and caster.wq ==1 then
		if xj >= gold then
			gold=-gold
			PlagueLand:ModifyCustomGold(playerID, gold)
			caster.wq = 2
			CallBoss(lv,lx,caster)
			NotifyUtil.ShowSysMsg(caster:GetPlayerID(),"#item_qw")		
		else 
			NotifyUtil.ShowError(caster:GetPlayerID(),"#money_no")		
		end

	end

end





---召唤武器BOSS，击杀便能升级装备
--@param #int lv 	boss等级
--@param #int lx	boss的类型
function CallBoss(lv,lx,caster)
		local unitname = boss[lx]
		local id = caster:GetPlayerOwnerID() +1
		local spawner=Entities:FindByName(nil,shuaguai.sgd[id])
		local p = spawner:GetAbsOrigin()
		local unit = CreateUnitByName(unitname, p, false, nil, nil, TEAM_ENEMY)
		local difficulty =   GetGameDifficulty()
		--设置BOSS的等级
		unit:SetContextNum("zbboss",lv,0)
		--设置是哪个玩家的
		unit:SetContextNum("player",caster:GetPlayerOwnerID(),0)
		--设置套装BOSS的掉落权  
		--暂时不设置
		--unit:SetContextNum("ywboss",pz,0)

		--设置怪物的动态血量
		local maxhp = wq_boss_hp[lv] * ma.nd_hp[difficulty]
		unit:SetBaseMaxHealth(maxhp)
	--
		--设置怪物的动态护甲
		local maxarmor = wq_boss_armor[lv] * ma.nd_hj[difficulty]
		unit:SetPhysicalArmorBaseValue(maxarmor)
	--	
		local mk = maxarmor*0.06/(1+maxarmor*0.06)*100    	--设置BOSS的魔抗

		unit:SetBaseMagicalResistanceValue(mk)
		--设置怪物的动态攻击
		local maxattack = wq_boss_damage[lv]  * ma.nd_gj[difficulty] --所有怪攻击太高，先削弱测试

		unit:SetBaseDamageMin(maxattack)
		unit:SetBaseDamageMax(maxattack)

		unit.isboss = 1
		if lv >= 10 then
			unit:AddAbility("nlzx_boss_1"):SetLevel(lv-9)
		end
		--标记为玩家几的存活怪
		unit.playchs = id;
		--一个怪代表一个存活，boss另算
		unit.playchsl = 1;
		--对应的玩家怪物数量+1
		Stage.chs["chs"..id] = Stage.chs["chs"..id] + unit.playchsl
		--同步往服务器发怪物目前的数量
		local  nowchs = #Stage.kezhw
		for _, PlayerID in pairs(Stage.playeronline) do
			nowchs = nowchs + Stage.chs["chs"..PlayerID+1]
		end
		table.insert(Stage["player"..id-1],unit:GetEntityIndex())
		--当相位移动的modifier消失，系统会自动计算碰撞，这样就避免了卡位
		unit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1})

		--小地图显示
		--EntityHelper.ShowOnMiniMap(boss)
end






function add_zsx(keys)
	local caster = keys.caster
	local ability = keys.ability
	local zsx = keys.ability:GetLevelSpecialValueFor("zsx", ability:GetLevel() - 1)
--	if caster:IsHero() and caster.zsx then
	local x = caster.zsx
			if x ==1 then
			local sx = caster:GetBaseStrength()	
			sx = sx + zsx
			caster:SetBaseStrength(sx)

			end

			if x ==2 then
			local sx = caster:GetBaseAgility()	
			sx = sx + zsx
			caster:SetBaseAgility(sx)
			end

			if x ==3 then
			local sx = caster:GetBaseIntellect()	
			sx = sx + zsx
			caster:SetBaseIntellect(sx)
			end

	--end
	
end



function reduce_zsx(keys )
	local caster = keys.caster
	local ability = keys.ability
	local zsx = keys.ability:GetLevelSpecialValueFor("zsx", ability:GetLevel() - 1)

			local x = caster.zsx

			if x ==1 then
			local sx = caster:GetBaseStrength()	
			sx = sx - zsx
			caster:SetBaseStrength(sx)

			end

			if x ==2 then
			local sx = caster:GetBaseAgility()	
			sx = sx - zsx
			caster:SetBaseAgility(sx)
			end

			if x ==3 then
			local sx = caster:GetBaseIntellect()	
			sx = sx - zsx
			caster:SetBaseIntellect(sx)
			end


	
end



























--	local count =0
--	TimerUtil.createTimer(function()
	--	if count < 50 then
	--	local x = RandomInt(1,255)	
--		local y = RandomInt(1,255)	
--		local z = RandomInt(1,255)	
	--	caster:SetRenderColor(x,y,z)
	--	count =count +1

--			return 0.1
--		end
--	end)
