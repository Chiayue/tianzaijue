require( "ai/shared" )
require( "ai/ai_core" )

--------------------------------------------------------------------------------
function Spawn(  )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end
	
	--可释放的技能，实际释放的时候随机一个
	for index=0, thisEntity:GetAbilityCount() - 1 do
		local ability = thisEntity:GetAbilityByIndex(index);
		--如果对应位置存在技能，技能不是被动，也没有冷却，则释放技能
		if ability and ability:GetLevel() > 0 and not ability:IsPassive() then
			thisEntity._AiNeedCastAbility = true;
			break;
		end
	end
	
	
	thisEntity:SetContextThink( DoUniqueString("AiThink"), AiThink, 0 )
end

--------------------------------------------------------------------------------

function Precache( context )
	
end

--------------------------------------------------------------------------------

function AiThink()
	local flNow = GameRules:GetGameTime()
	
	if thisEntity._attackTarget == nil then
		AIChangeTarget(thisEntity,flNow)
	elseif not EntityIsAlive(thisEntity._attackTarget) then
		--清空目标
		thisEntity._attackTarget = nil
		
		--缩小boss的找敌范围，缓解召唤者死亡的情况下，怪物会快速跑到别人那里被别人击杀的情况。
		if thisEntity.isboss then
			thisEntity._targetDiedTime = flNow
			thisEntity:SetAcquisitionRange(900)
			thisEntity:Stop()--终止当前命令，避免已经使用大范围自动找到了新目标，这里改了范围也就没用了
		end
	elseif thisEntity:IsMoving() then
		AIChangeTarget(thisEntity,flNow)
	end
	
	if thisEntity._AiNeedCastAbility then
		AICastAbility(thisEntity)
	end
	
	--恢复仇恨范围
	if thisEntity._targetDiedTime and flNow - thisEntity._targetDiedTime > 4 then
		thisEntity._targetDiedTime = nil
		thisEntity:SetAcquisitionRange(thisEntity._OriginAcquisitionRange or 9999)
	end

	return 0.25
end

function AIChangeTarget(unit,flNow)
    unit.flLastAggroSwitch = unit.flLastAggroSwitch and unit.flLastAggroSwitch or 0
    
    if (flNow - unit.flLastAggroSwitch) > 2 then
    	--缓存攻击目标，用GetAggroTarget来获取的话，如果目标死亡，会获得nil，导致进不到守尸逻辑里
    	local range = FIND_UNITS_EVERYWHERE
    	if unit.isboss then
    		range = unit:GetAcquisitionRange();
    		if not unit._OriginAcquisitionRange then
    			unit._OriginAcquisitionRange = range
    		end
    	end
		unit._attackTarget = AICore:ClosestEnemyInRange( unit,  range)
		AttackTargetOrder(unit,unit._attackTarget)
		
		unit.flLastAggroSwitch = flNow
    end
end

function AICastAbility(unit)
	local time = unit._AiCastAbilityTime
	if (time and GameRules:GetGameTime() - time < 3) or not EntityIsAlive(unit._attackTarget) then
		return;
	end

	--可释放的技能，实际释放的时候随机一个
	local castable = {}
	for index=0, unit:GetAbilityCount() - 1 do
		local ability = unit:GetAbilityByIndex(index);
		--如果对应位置存在技能，技能不是被动，也没有冷却，则释放技能
		if ability and ability:GetLevel() > 0 and not ability:IsPassive() 
			and ability:IsFullyCastable() then
			table.insert(castable,ability)
		end
	end
	
	--随机释放一个技能
	if #castable > 0 then
		local ability = castable[RandomInt(1,#castable)]
		
		--技能属性
		local targetTeam = ability:GetAbilityTargetTeam()
		local targetType = ability:GetAbilityTargetType()
		local targetFlag = ability:GetAbilityTargetFlags()
		
		--默认对敌军释放
		if targetTeam == DOTA_UNIT_TARGET_TEAM_NONE then
			targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY 
		end
		--默认英雄+普通单位
		if targetType == DOTA_UNIT_TARGET_NONE then
			targetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
		end
		
		local unitLoc = unit:GetAbsOrigin()
		local unitTeam = unit:GetTeamNumber()
		
		--根据技能类型决定施法方式，只应用一个
		local behavior = ability:GetBehaviorInt();
		if BitAndTest(behavior,DOTA_ABILITY_BEHAVIOR_NO_TARGET) then --无目标的技能
			local attackRange = unit:Script_GetAttackRange()
			--对友方释放的，附近有友军才释放；对敌方释放的，附近有敌方才释放。如果是其他队伍类型，则不释放。这样某些不需要自动释放的技能就可以设置成没有队伍即可
			if BitAndTest(targetTeam,DOTA_UNIT_TARGET_TEAM_FRIENDLY) then
				local allies = FindAlliesInRadiusEx(unitTeam,unit:GetAbsOrigin(),attackRange,targetFlag,nil,targetType)
				if allies and #allies > 0 then
					--切换类技能
					if ability:IsToggle() then
						if not ability:GetToggleState() then
							ability:ToggleAbility()
						end
					else
						unit:CastAbilityNoTarget(ability,-1);
					end
					unit._AiCastAbilityTime = GameRules:GetGameTime()
				end
			elseif BitAndTest(targetTeam,DOTA_UNIT_TARGET_TEAM_ENEMY) then
				local enemies = FindEnemiesInRadiusEx(unitTeam,unitLoc,attackRange,targetFlag,nil,targetType)
				if enemies and #enemies > 0 then
					--切换类技能
					if ability:IsToggle() then
						if not ability:GetToggleState() then
							ability:ToggleAbility()
						end
					else
						unit:CastAbilityNoTarget(ability,-1);
					end
					unit._AiCastAbilityTime = GameRules:GetGameTime()
				end
			end
		elseif BitAndTest(behavior,DOTA_ABILITY_BEHAVIOR_POINT) then --点目标
			local castRange = ability:GetCastRange();
			if castRange == 0 then --没有设置施法距离，默认以基础攻击距离为准
				castRange = unit:Script_GetAttackRange()
			end
			--如果是作用于友军的，则直接在自己所在位置释放。否则检查是否有攻击目标，有目标在目标点释放
			if BitAndTest(targetTeam,DOTA_UNIT_TARGET_TEAM_FRIENDLY) then
				unit:CastAbilityOnPosition(unitLoc,ability,-1);
				unit._AiCastAbilityTime = GameRules:GetGameTime()
			else
				local target = unit:GetAggroTarget()
				if target then
					local targetLoc = target:GetAbsOrigin()
					if (targetLoc - unitLoc):Length2D() <= castRange then --在施法范围内，才使用。
						unit:CastAbilityOnPosition(targetLoc,ability,-1);
						unit._AiCastAbilityTime = GameRules:GetGameTime()
					end
				end
			end
		elseif BitAndTest(behavior,DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) then --单位目标
			local castRange = ability:GetCastRange();
			if castRange == 0 then --没有设置施法距离，默认以基础攻击距离为准
				castRange = unit:Script_GetAttackRange()
			end
			--技能目标，根据技能属性获取目标
			local target = nil
			--判断是对友方还是对敌方释放
			if BitAndTest(targetTeam,DOTA_UNIT_TARGET_TEAM_FRIENDLY) then
				--在自身周围找一个合适的友方单位，排除掉幻象和魔免单位（马甲）
				if not BitAndTest(targetFlag,DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS) then
					targetFlag = targetFlag + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
				end
				if not BitAndTest(targetFlag,DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES) then
					targetFlag = targetFlag + DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES
				end
				local allies = FindAlliesInRadiusEx(unitTeam,unit:GetAbsOrigin(),castRange,targetFlag,nil,targetType)
				if allies and #allies > 0 then
					target = allies[RandomInt(1,#allies)]
				end
			else
				--检查目标单位是否符合条件，不符合的话，尝试在施法范围内找一个
				local attackingTarget = unit:GetAggroTarget()
				if not attackingTarget or UnitFilter(attackingTarget,targetTeam,targetType,targetFlag,unitTeam) ~= UF_SUCCESS then
					local enemies = FindEnemiesInRadiusEx(unitTeam,unitLoc,castRange,targetFlag,nil,targetType)
					if enemies and #enemies > 0 then
						target = enemies[RandomInt(1,#enemies)]
					end
				else
					target = attackingTarget;
				end
			end
			
			if target then
				local targetLoc = target:GetAbsOrigin()
				if (targetLoc - unitLoc):Length2D() <= castRange then --在施法范围内，才使用。
					unit:CastAbilityOnTarget(target,ability,-1);
					unit._AiCastAbilityTime = GameRules:GetGameTime()
				end
			end
		end
	end
end

--------------------------------------------------------------------------------