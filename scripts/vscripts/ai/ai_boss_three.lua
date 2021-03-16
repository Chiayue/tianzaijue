
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	--thisEntity:AddNewModifier( nil, nil, "modifier_invulnerable", { duration = -1 } )

	OneAbility = thisEntity:FindAbilityByName( "boss_invoker_call_lua" )
	TwoAbility = thisEntity:FindAbilityByName( "boss_invoker_end_lua" )
	
	thisEntity.timeOfLastAggro = GameRules:GetGameTime()
	thisEntity:SetContextThink( "BossthreeThink", BossthreeThink, 1 )
end

function BossthreeThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
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
		LinkLuaModifier( "modifier_boss_invoker_end_lua_bloodfier","lua_modifiers/boss/boss_three/modifier_boss_invoker_end_lua_bloodfier", LUA_MODIFIER_MOTION_NONE )
		thisEntity:AddNewModifier( thisEntity, nil, "modifier_boss_invoker_end_lua_bloodfier", {} )
	end

	if OneAbility ~= nil and OneAbility:IsCooldownReady()  then
		return CastNoTarget( OneAbility)
	end
	
	if TwoAbility ~= nil and TwoAbility:IsCooldownReady() and thisEntity:GetHealthPercent() < 90 then

		return CastNoTarget( TwoAbility)
	end
	
	return 0.5
end


function Smash( enemy )
	if enemy == nil then
		return
	end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		AbilityIndex = SmashAbility:entindex(),
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
