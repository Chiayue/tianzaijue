function tg( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local radius = keys.ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel())
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local x = 1 + (level+caster.cas_table.grjndj) / 10
    local point = target:GetAbsOrigin()
	
	if caster.tg_baseDamage == nil then
		caster.tg_baseDamage = 0
	end
	if caster.tg_damage == nil then
		caster.tg_damage = 0
	end
	if caster.tg_radius == nil then
		caster.tg_radius = 0
	end
	if caster.tg_multiple == nil then
		caster.tg_multiple = 0
	end
	local multiple = 1
	if RollPercentage(20) then
		multiple = caster.tg_multiple + multiple
	end	
	local mj = caster:GetAgility()
	local baseDamage2 = baseDamage + caster.tg_baseDamage
	i = i + caster.tg_damage
	local damage = (mj * i + baseDamage2 ) * x * multiple


	radius = radius + caster.tg_radius
	local units = FindAlliesInRadiusEx(target,point,radius)
	if units ~= nil then
	for key, unit in pairs(units) do

		ability:ApplyDataDrivenModifier(caster, unit, "modifier_tg", {})	
		ApplyDamageEx(caster,unit,ability,damage)
		ShowOverheadMsg(unit,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)


		local particleID = CreateParticleEx("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact_dagger.vpcf",PATTACH_CUSTOMORIGIN,unit)
		local cpv = unit:GetAbsOrigin()
		cpv.z = cpv.z + 100
		SetParticleControlEx(particleID,0,cpv)
		SetParticleControlEx(particleID,1,cpv)
		

		end
	end	
	


end





function aytx( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local radius = keys.ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel())
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", keys.ability:GetLevel() - 1)	
	local mf = keys.ability:GetLevelSpecialValueFor("mf", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local x = 1 + (level+caster.cas_table.grjndj) / 10
    local point = target:GetAbsOrigin()
	if caster.aytx_baseDamage == nil then
		caster.aytx_baseDamage = 0
	end
	if caster.aytx_damage == nil then
		caster.aytx_damage = 0
	end
	if caster.aytx_multiple == nil then
		caster.aytx_multiple = 0
	end
	local multiple = 1
	if RollPercentage(20) then
		multiple = caster.aytx_multiple + multiple
	end	
	local mj = caster:GetAgility()
	local baseDamage2 = baseDamage + caster.aytx_baseDamage
	local damage = (mj * i + baseDamage2 ) * x * multiple
	

	--??????
	local ParticleID = CreateParticleEx("particles/hero/jpe/ruodiandaji/jpe_rddj.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster)
	SetParticleControlEx(ParticleID,0,target:GetAbsOrigin())--?????????????????????
	SetParticleControlEx(ParticleID,1,caster:GetAbsOrigin())--?????????????????????
	SetParticleControlEx(ParticleID,3,caster:GetAbsOrigin())--?????????????????????
	--??????
	Teleport(caster,point)

	ApplyDamageEx(caster,target,ability,damage)
		ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	if target:IsAlive() ==false then
		local mf = ability:GetManaCost(-1) /mf /100
		print(mf)
		caster:GiveMana(mf)
		ability:EndCooldown()
	end
	


end


---??????????????????
--@param #table caster ?????????
--@param #table target ????????????
--@param #number num ????????????
local CreateJiaoShaParticle = function(caster,target,num)
	local onePiece = math.floor(360 / num) --??????????????????????????????????????????
	for pieceIndex=1, num do
		local angle = onePiece * (pieceIndex - 1)--????????????
		
		if pieceIndex == 1 then --????????????????????????????????????????????????????????????????????????????????????
			local particle = CreateParticleEx("particles/hero/jpe/jiaosha/jpe_js.vpcf",PATTACH_POINT,caster)
			SetParticleControlEx(particle,1,target:GetAbsOrigin())
		else --???????????????????????????????????????????????????????????????
			local temp = Entities:CreateByClassname("prop_dynamic")
			temp:SetModel("models/props_gameplay/tombstoneb01.vmdl")--????????????????????????
			temp:SetModelScale(0.01)--????????????????????????????????????
			--?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
			temp:SetAbsOrigin(caster:GetOrigin());
			temp:SetForwardVector(RotateVector2D(caster:GetForwardVector(),angle))
			
			local particle = CreateParticleEx("particles/hero/jpe/jiaosha/jpe_js.vpcf",PATTACH_POINT,temp)
			SetParticleControlEx(particle,1,target:GetAbsOrigin())
			
			--????????????????????????????????????????????????????????????1.5???????????????????????????2??????????????????
			TimerUtil.createTimerWithDelay(2,function()
				if temp then
					temp:RemoveSelf()
				end
			end)
		end
	end
end







function swjs( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local radius = keys.ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel())
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local x = 1 + (level+caster.cas_table.grjndj) / 10
    local point = target:GetAbsOrigin()
	if caster.swjs_baseDamage == nil then
		caster.swjs_baseDamage = 0
	end
	if caster.swjs_damage == nil then
		caster.swjs_damage = 0
	end
	if caster.swjs_radius == nil then
		caster.swjs_radius = 0
	end
	if caster.swjs_multiple == nil then
		caster.swjs_multiple = 0
	end
	local multiple = 1
	if RollPercentage(20) then
		multiple = caster.swjs_multiple + multiple
	end	

	local mj = caster:GetAgility()
	local baseDamage2 = baseDamage + caster.swjs_baseDamage
	i = i + caster.swjs_damage
	local damage = (mj * i + baseDamage2 ) * x * multiple
	radius = radius + caster.swjs_radius
	
	ability:ApplyDataDrivenModifier(caster,target,"modifier_swjs",{});
	CreateJiaoShaParticle(caster,target,1)
	local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_spell_bloodbath_bubbles.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle2, 0, target:GetAbsOrigin()) -- Origin
	ParticleManager:SetParticleControl(particle2, 1, Vector(radius,0,0)) -- Origin

		TimerUtil.createTimerWithDelay(1.3,function()
			local units = FindAlliesInRadiusEx(target,target:GetAbsOrigin(),radius)
			
			if units ~= nil then
			for key, unit in pairs(units) do

				ParticleManager:DestroyParticle(particle2,false)
				ApplyDamageEx(caster,unit,ability,damage)
				ShowOverheadMsg(unit,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
				end
			end	
	
		end)
end


local GetRotationPoint = function(originPoint, radius, angle)
	local radAngle = math.rad(angle)
	local x = math.cos(radAngle) * radius + originPoint.x
	local y = math.sin(radAngle) * radius + originPoint.y
	local position = Vector(x, y, originPoint.z)
	return position
end





function swzf( keys )
	
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local radius = keys.ability:GetLevelSpecialValueFor("radius", level)
	local i = keys.ability:GetLevelSpecialValueFor("i", level)	
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", level)	
	--????????????
	local damageTime = ability:GetLevelSpecialValueFor( "damage_times",level )
	
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	if caster.swzf_baseDamage == nil then
		caster.swzf_baseDamage = 0
	end
	if caster.swzf_damage == nil then
		caster.swzf_damage = 0
	end
	if caster.swzf_count == nil then
		caster.swzf_count = 0
	end
	if caster.swzf_multiple == nil then
		caster.swzf_multiple = 0
	end
	local multiple = 1
	if RollPercentage(20) then
		multiple = caster.swzf_multiple + multiple
	end	


	local mj = caster:GetAgility()
	local baseDamage2 = baseDamage + caster.swzf_baseDamage
	i = i + caster.swzf_damage
	local damage = (mj * i + baseDamage2 ) * x * multiple *1.4

	damageTime= damageTime+ caster.swzf_count

	--????????????????????????
	ability:ApplyDataDrivenModifier(caster,caster,"modifier_swzf",{});
	--???????????????
	local casterPos = caster:GetAbsOrigin()
	local targetPos = target:GetAbsOrigin()

	--????????????????????????
	local moveParticle = "particles/hero/jpe/siwangzhanfang/jpe_swzf_line_model.vpcf"
	local fallParticle = "particles/hero/jpe/siwangzhanfang/jpe_swzf_line_fall_trail.vpcf"


		TimerUtil.createTimer(function ()
		--????????????
		if damageTime > 0 then
			local angle = RandomInt(0, 360)
			local point = GetRotationPoint(targetPos, radius, angle)
			local casterOrigin = caster:GetAbsOrigin()
			local targetDirection = (point - casterOrigin):Normalized() 
			caster:SetForwardVector(targetDirection)
			
			local fxIndex = CreateParticleEx(moveParticle,PATTACH_ABSORIGIN,caster,1)
			ParticleManager:SetParticleControlForward(fxIndex,0,targetDirection)
			ParticleManager:SetParticleControl( fxIndex, 0, casterOrigin )
			ParticleManager:SetParticleControl( fxIndex, 1, point )
			ProjectileManager:ProjectileDodge(caster)
			
			Teleport(caster,point,true)
			
			--???????????????????????????????????????????????????
			if damageTime % 2 == 0 then
				EmitSoundOn("Hero_PhantomAssassin.Dagger.Cast",target)
			end
			--???????????????????????????
			ApplyDamageEx(caster,target,ability,damage)
			--?????????????????????
		
			
			damageTime = damageTime - 1
			return 0.04
		end

		--????????????
		for i=1,8 do
			local delay = RandomFloat(0, 0.5)
			Timers:CreateTimer(delay,function ()
				local point = GetRotationPoint(targetPos, 600, 45 * i)
				local fxIndex = CreateParticleEx(fallParticle,PATTACH_ABSORIGIN,caster,1)
				ParticleManager:SetParticleControl( fxIndex, 0, point )
			end)
		end
		for i=1,6 do
			local delay = RandomFloat(0, 0.3)
			Timers:CreateTimer(delay,function ()
				local radius = RandomInt(300, 400)
				local point = GetRotationPoint(targetPos, radius, 60 * i)
				local fxIndex = CreateParticleEx(fallParticle,PATTACH_ABSORIGIN,caster,1)
				ParticleManager:SetParticleControl( fxIndex, 0, point )
			end)
		end	


		--????????????
		caster:SetAbsOrigin(casterPos)
		--??????????????????
		caster:RemoveModifierByName("modifier_swzf")
		EmitSoundOn("Hero_PhantomAssassin.CoupDeGrace",caster)



	local units = FindAlliesInRadiusEx(target,target:GetAbsOrigin(),radius)

		
			if units ~= nil then
			for key, unit in pairs(units) do	
				
				ApplyDamageEx(caster,unit,ability,damage)
				ShowOverheadMsg(unit,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
				end
			end	
	
		end)
end






