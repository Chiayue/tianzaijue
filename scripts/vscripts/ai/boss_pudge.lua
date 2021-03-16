
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	--thisEntity:AddNewModifier( nil, nil, "modifier_invulnerable", { duration = -1 } )

	OneAbility = thisEntity:FindAbilityByName( "pudge_meat_hook_lua" )--肉勾
	TwoAbility = thisEntity:FindAbilityByName( "boss_pudge_flesh_heap_lua" ) --堆积
	ThreeAbility = thisEntity:FindAbilityByName( "boss_pudge_rot_lua" )--腐烂
	FourAbility = thisEntity:FindAbilityByName( "boss_pudge_tiny_bot_lua" )--血肉分离
	FiveAbility = thisEntity:FindAbilityByName( "boss_pudge_dismember_lua" )--肢解
    SixAbility = thisEntity:FindAbilityByName( "boss_pudge_bot_bome_lua" )--瘟疫寄生
    SevenAbility = thisEntity:FindAbilityByName( "boss_pudge_wenyiyuan_lua" )--瘟疫源
	

	thisEntity.timeOfLastAggro = GameRules:GetGameTime()
	thisEntity:SetContextThink( "BosspudgeThink", BosspudgeThink, 1 )
end

function BosspudgeThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end
    if thisEntity:IsChanneling() then
        return 1 
    end
	if not thisEntity.bInitialized then
		thisEntity.chushengdian = thisEntity:GetOrigin()
		thisEntity.bInitialized = true
	end

	-- Are we too far from our initial spawn position?
	--local fDist = ( thisEntity:GetOrigin() - thisEntity.chushengdian ):Length2D()
	--if fDist > 1300 then
		--RetreatHome()
	--end
	
	if ( not thisEntity.bHasAggro ) and thisEntity:GetAggroTarget() then
		thisEntity.timeOfLastAggro = GameRules:GetGameTime()
		thisEntity.bHasAggro = true
	end
	if thisEntity.timeOfLastAggro+10 < GameRules:GetGameTime() then
		thisEntity.bHasAggro = false
	end
	local nEnemiesRemoved = 0
	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity:GetAcquisitionRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
	if #enemies == 0 and thisEntity.bHasAggro == false then
		--if thisEntity:GetHealthPercent() < 100 and thisEntity:FindModifierByName( "healthquan_modifier" ) == nil then
			--thisEntity:AddNewModifier( thisEntity, nil,"healthquan_modifier", {duration=5})
		--end
		return RetreatHome()
	else
		--thisEntity:RemoveModifierByName("modifier_randomwalk")
		--thisEntity:RemoveModifierByName("healthquan_modifier")
	end

	if #enemies == 0 then
		-- @todo: Could check whether there are ogre magi nearby that I should be positioning myself next to.  Either that or have the magi come to me.
		return 1
	end
	if thisEntity:GetHealthPercent() < 20 then
		--LinkLuaModifier( "modifier_boss_invoker_end_lua_bloodfier","lua_modifiers/boss/boss_three/modifier_boss_invoker_end_lua_bloodfier", LUA_MODIFIER_MOTION_NONE )
		--thisEntity:AddNewModifier( thisEntity, nil, "modifier_boss_invoker_end_lua_bloodfier", {} )
	end
    if FiveAbility ~= nil and FiveAbility:IsCooldownReady() and thisEntity:GetHealthPercent() < 30 then

		return CastTarget(enemies[1] ,FiveAbility)
	end
	if SixAbility ~= nil and SixAbility:IsCooldownReady() and thisEntity:GetHealthPercent() < 45 then

		return CastNoTarget( SixAbility)
	end
	if SevenAbility ~= nil and SevenAbility:IsCooldownReady() and thisEntity:GetHealthPercent() < 60 then

		return CastNoTarget( SevenAbility)
	end
	if OneAbility ~= nil and OneAbility:IsCooldownReady()  then

		return CastNoTarget( OneAbility)
	end
	if ThreeAbility ~= nil and ThreeAbility:IsCooldownReady() and thisEntity:GetHealthPercent() < 90 then

		return CastNoTarget( ThreeAbility)
	end
	
	if FourAbility ~= nil and FourAbility:IsCooldownReady() and thisEntity:GetHealthPercent() < 75 then

		return CastNoTarget( FourAbility)
	end
	
	
	
	
	return 0.5
end


function CastPoint( enemy ,ab)
	if enemy == nil then
		return
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = ab:entindex(),
		Position = enemy:GetOrigin(),
		Queue = false,
	})
	return 3 
end

function RetreatHome()
	if ((thisEntity:GetOrigin()-thisEntity.chushengdian):Length2D()>1300) then
		ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity.chushengdian,
		})
	else
--		local hEnemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity:GetAcquisitionRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
--		local hBuff = thisEntity:FindModifierByName( "modifier_randomwalk" )
--		if hBuff == nil and #hEnemies == 0 then
--
--			thisEntity:AddNewModifier( thisEntity, nil,"modifier_randomwalk", {duration=RandomInt(8,30)})
--		end
		
	end
	return 0.5
end

function CastNoTarget( ab)
	
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = ab:entindex(),
		Queue = false,
	})

	return 1
end
function CastTarget( enemy,ab)
	
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = enemy:entindex(),
		AbilityIndex = ab:entindex(),
	})

	return 1
end


