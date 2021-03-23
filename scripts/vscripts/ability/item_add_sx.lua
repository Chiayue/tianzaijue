-- 获取一个空的技能
--能量晶石
function AddSx(keys)
	local ability = keys.ability
	local caster = keys.caster
	--这种情况下认为是从地上捡起来自动使用了，通过额外的索引获取单位
	if not caster then
		caster = ability._unit
	end

	if caster and caster:IsRealHero() then
		local PlayerID = caster:GetPlayerOwnerID();--获取玩家ID
		local x = RandomInt(1,3)
		local wave = Stage.wave

		local z = RandomInt(1,5) * (0.5+wave/2)
		local nljszjbfb = caster.nljszjbfb
		z = z * nljszjbfb
		if x ==1 then
			NotifyUtil.ShowSysMsg(PlayerID,"add_ll",nil,"item_xhp_nljs",{value=z})


			local y = caster:GetBaseStrength()
			z = z + y
			caster:SetBaseStrength(z)

		elseif x ==2 then
			NotifyUtil.ShowSysMsg(PlayerID,"add_mj",nil,"item_xhp_nljs",{value=z})
			local y = caster:GetBaseAgility()
			z = z + y
			caster:SetBaseAgility(z)
		elseif x ==3 then
			NotifyUtil.ShowSysMsg(PlayerID,"add_zl",nil,"item_xhp_nljs",{value=z})
			local y = caster:GetBaseIntellect()
			z = z + y
			caster:SetBaseIntellect(z)
		end

	end

	ability:RemoveSelf()


end



function Addjb(keys)
	local ability = keys.ability
	local caster = keys.caster
	
	--这种情况下认为是从地上捡起来自动使用了，通过额外的索引获取单位
	if not caster then
		caster = ability._unit
	end
	
	if caster then
		local min = GetAbilitySpecialValueByLevel(ability,"min")
		local max = GetAbilitySpecialValueByLevel(ability,"max")
		
		local gold = RandomInt(min,max)
		
		local jqjc = caster.cas_table.jqjc + 100
		local wave= Stage.wave
		local gold = math.ceil(gold * jqjc / 100 * (wave*0.2 + 1))
		PopupNum:PopupGoldGain(caster,gold)
		PlayerUtil.ModifyGold(caster,gold)
	end
	
	ability:RemoveSelf()
end


function hfys(keys)
	local caster = keys.caster
	local target = keys.target
	local playerID = caster:GetPlayerOwnerID()
	local hero = PlayerUtil.GetHero(playerID)
	local ability =keys.ability
	local health = keys.ability:GetLevelSpecialValueFor("health", ability:GetLevel())
	local max = keys.ability:GetLevelSpecialValueFor("max", ability:GetLevel())
	local hp = hero:GetMaxHealth() * health /100
	local mp = hero:GetMaxMana() * health /100
	--NetItemDrop(hero) 
	--opennetbox(3,4,5,playerID)
	--itemgivesq(hero)
	--itemgive(playerID,6,2)
	hero:GiveMana(mp)
	caster:Heal(hp,hero)
	local p = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
	ParticleManager:ReleaseParticleIndex(p)
end




--模拟一个开宝箱
function kbx(keys)
	local ability =keys.ability

	--local target = keys.target
	local time = ability.zbbx
	local point = UnitDie.zbbx[time]
	local dbl = UnitDie.zbbx_dbl[time]
	local lv =  UnitDie.zbbx_lv[time]
	local dbpz = UnitDie.zbbx_dbpz[time]
	-- 
	local target =  CreateUnitByName("zbbx_1", point, false, nil, nil, TEAM_ENEMY)
	target.dbl = dbl
	target.dbpz = dbpz
	target:CreatureLevelUp(lv)
	LetUnitDoAction(target,3,1)
	AddLuaModifier(target,target,"modifier_kill",{duration=0.1},ability)
	--	itemdrop(caster,target)

	--Timers:CreateTimer(0.1, function()
	--UTIL_RemoveImmediate(ability) end)
	ability:RemoveSelf()
end


