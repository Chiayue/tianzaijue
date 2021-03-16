--DoUniqueString("xx")--xx不能少 
--IsServer()
--IsClient()
--IsInToolsMode()

---玩家队伍
TEAM_PLAYER = DOTA_TEAM_GOODGUYS
---敌人队伍
TEAM_ENEMY = DOTA_TEAM_BADGUYS

---在给定的位置和范围内搜寻某队伍的敌军单位
--@param #any team 队伍id或者单位实体。默认为玩家队伍
--@param #table point 坐标点Vector值  (GetAbsOrigin)
--@param #number radius 范围（全屏使用FIND_UNITS_EVERYWHERE）
--@param #number flag 单位标签
--<pre>
--无特殊标记（默认）：DOTA_UNIT_TARGET_FLAG_NONE
--非隐身单位:DOTA_UNIT_TARGET_FLAG_NO_INVIS
--无敌单位:DOTA_UNIT_TARGET_FLAG_INVULNERABLE
--魔法免疫的敌方单位:DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES （魔法免疫不是技能免疫，只是魔抗=100%，可以被释放技能）
--非魔法免疫的友方单位:DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES （魔法免疫不是技能免疫，只是魔抗=100%，可以被释放技能）
--非远古单位（无法使用，单位如果设置为远古单位，则使用kv里面的投射物逻辑会忽略掉该单位，从而不会造成伤害）：DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
--非幻象：DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
--</pre>
--@param #number order 查找的顺序
--<pre>
--FIND_ANY_ORDER（默认）
--FIND_CLOSEST
--FIND_FARTHEST
--</pre>
--@param #number targetType 目标类型
--<pre>
--DOTA_UNIT_TARGET_ALL
--DOTA_UNIT_TARGET_BASIC(默认)
--DOTA_UNIT_TARGET_HERO（默认）
--DOTA_UNIT_TARGET_BUILDING
--DOTA_UNIT_TARGET_TREE
--</pre>
function FindEnemiesInRadiusEx(team,point,radius,flag,order,targetType)
	if type(team) ~= "number" and type(team) == "table" and type(team.GetTeamNumber) == "function" then
		team = team:GetTeamNumber()
	end
	team = team or TEAM_PLAYER
	flag = flag or DOTA_UNIT_TARGET_FLAG_NONE;
	order = order or FIND_ANY_ORDER
	targetType = targetType or (DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO)
	return FindUnitsInRadius( team, point, nil,radius, 
				DOTA_UNIT_TARGET_TEAM_ENEMY, targetType,
				flag, order, false)
end

---指定直线范围内查找敌方单位。宽度较大的时候，在startPos后面的（和endPos相反方向）的单位也会被找到
--@param #any team 队伍id或者单位实体。
--@param #Vector startPos 坐标点Vector值  (GetAbsOrigin)
--@param #Vector endPos 坐标点Vector值  (GetAbsOrigin)
--@param #number width 线的宽度
--@param #number flag 单位标签
--<pre>
--无特殊标记（默认）：DOTA_UNIT_TARGET_FLAG_NONE
--非隐身单位:DOTA_UNIT_TARGET_FLAG_NO_INVIS
--无敌单位:DOTA_UNIT_TARGET_FLAG_INVULNERABLE
--魔法免疫的敌方单位:DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES （魔法免疫不是技能免疫，只是魔抗=100%，可以被释放技能）
--非魔法免疫的友方单位:DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES （魔法免疫不是技能免疫，只是魔抗=100%，可以被释放技能）
--非远古单位（无法使用，单位如果设置为远古单位，则使用kv里面的投射物逻辑会忽略掉该单位，从而不会造成伤害）：DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
--非幻象：DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
--</pre>
function FindEnemiesInLineEx(team,startPos,endPos,width,flag)
	if type(team) ~= "number" and type(team.GetTeamNumber) == "function" then
		team = team:GetTeamNumber()
	end
	
	if type(team) == "number" then
		flag = flag or DOTA_UNIT_TARGET_FLAG_NONE;
		return FindUnitsInLine( team, startPos,endPos, nil,width, 
					DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO,
					flag)
	end
end

---在给定的位置和范围内搜寻某队伍的友军单位
--@param #any team 队伍id或者单位实体。
--@param #table point 坐标点Vector值 (GetAbsOrigin)
--@param #number radius 范围（全屏使用FIND_UNITS_EVERYWHERE）
--@param #number flag 单位标签
--<pre>
--无特殊标记（默认）：DOTA_UNIT_TARGET_FLAG_NONE 
--非隐身单位:DOTA_UNIT_TARGET_FLAG_NO_INVIS 
--无敌单位:DOTA_UNIT_TARGET_FLAG_INVULNERABLE 
--魔法免疫的敌方单位:DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES （魔法免疫不是技能免疫，只是魔抗=100%，可以被释放技能）
--非魔法免疫的友方单位:DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES （魔法免疫不是技能免疫，只是魔抗=100%，可以被释放技能）
--非远古单位（无法使用，单位如果设置为远古单位，则使用kv里面的投射物逻辑会忽略掉该单位，从而不会造成伤害）：DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
--非幻象：DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
--受玩家控制的（如果要排除掉虚拟单位，则可考虑用这个，因为一般虚拟单位都不可控制，但是不排除特殊情况）：DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
--</pre>
--@param #number order 查找的顺序
--<pre>
--FIND_ANY_ORDER（默认）
--FIND_CLOSEST
--FIND_FARTHEST
--</pre>
--@param #number targetType 目标类型
--<pre>
--DOTA_UNIT_TARGET_ALL（默认）
--DOTA_UNIT_TARGET_BASIC
--DOTA_UNIT_TARGET_HERO
--DOTA_UNIT_TARGET_BUILDING
--DOTA_UNIT_TARGET_TREE
--</pre>
function FindAlliesInRadiusEx(team,point,radius,flag,order,targetType)	      -- 找寻玩家友好单位
	if type(team) ~= "number" and type(team.GetTeamNumber) == "function" then
		team = team:GetTeamNumber()
	end
	flag = flag or DOTA_UNIT_TARGET_FLAG_NONE;
	order = order or FIND_ANY_ORDER
	targetType = targetType or DOTA_UNIT_TARGET_ALL
	return FindUnitsInRadius( team, point, nil,radius, 
				DOTA_UNIT_TARGET_TEAM_FRIENDLY, targetType,
				flag, order, false)
end

function FindAlliesInRadiusExdd(team,point,radius,flag,order,targetType)		--找寻玩家敌对单位
	if type(team) ~= "number" and type(team.GetTeamNumber) == "function" then
		team = team:GetTeamNumber()
	end
	flag = flag or DOTA_UNIT_TARGET_FLAG_NONE;
	order = order or FIND_ANY_ORDER
	targetType = targetType or DOTA_UNIT_TARGET_ALL
	return FindUnitsInRadius( team, point, nil,radius, 
				DOTA_UNIT_TARGET_TEAM_ENEMY, targetType,
				flag, order, false)
end

---对某个单位造成伤害
--@param #handle caster 攻击者
--@param #handle target 受害者，或者受害者数组
--@param #handle ability 造成伤害的技能，可选
--@param #number damage 伤害量
--@param #number damageType 伤害类型
--<pre>
--DAMAGE_TYPE_PHYSICAL = 1（默认）
--DAMAGE_TYPE_MAGICAL = 2
--DAMAGE_TYPE_PURE = 4
--</pre>
--@param #number damageFlags 伤害标记(查看对应常量)，可选
--<pre>
--DOTA_DAMAGE_FLAG_IGNORES_MAGIC_ARMOR = 1
--DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR = 2
--DOTA_DAMAGE_FLAG_REFLECTION = 16 反弹伤害
--DOTA_DAMAGE_FLAG_HPLOSS = 32
--DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS（忽略增伤减伤效果） = 512
--</pre>
--@return 返回造成的实际伤害，根据target类型不同可能返回一个数字或者一个数组
function ApplyDamageEx(caster,target,ability,damage, damageType, damageFlags)
	local damageTable = {
		victim = nil,
		attacker = caster,
		damage = damage,
		damage_type = damageType or DAMAGE_TYPE_PHYSICAL,
		damage_flags = damageFlags, --Optional.
		ability = ability, --Optional.
	}
	--这里认为传入的target总是合法的（不是单位就是一个单位数组）
	if IsValidEntity(target) then
		damageTable.victim = target
		return ApplyDamage(damageTable)
	else
		local result = {}
		for key, unit in pairs(target) do
			damageTable.victim = unit
			table.insert(result,ApplyDamage(damageTable))
		end
		return result
	end	
end


function ApplyDamageMf(caster,target,ability,damage, damageType, damageFlags)
	local damageTable = {
		victim = nil,
		attacker = caster,
		damage = damage,
		damage_type = damageType or DAMAGE_TYPE_MAGICAL,
		damage_flags = damageFlags, --Optional.
		ability = ability, --Optional.
	}
	--这里认为传入的target总是合法的（不是单位就是一个单位数组）
	if IsValidEntity(target) then
		damageTable.victim = target
		return ApplyDamage(damageTable)
	else
		local result = {}
		for key, unit in pairs(target) do
			damageTable.victim = unit
			table.insert(result,ApplyDamage(damageTable))
		end
		return result
	end	
end

---对所有单位都造成固定物理伤害
--@param #table victimArray 所有的受害者，为空或者不是table，则不会造成伤害
--@param #table attacker 攻击者
--@param #number damage 伤害量,为空则不会造成伤害
function BatchApplyPhysicalDamage(victimArray, attacker, damage,ability)
	if type(victimArray) ~= "table"  or not damage then
		return;
	end
	local damageTable = {
		victim = nil,
		attacker = attacker,
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = ability
	}
	for _, victim in pairs(victimArray) do
		damageTable.victim = victim;
		ApplyDamage(damageTable)
	end
end

---对指定地点周围的<span style="color:red;">敌方单位</span>造成固定<span style="color:red;">物理伤害</span>
--@param #Vector point 攻击点坐标
--@param #number radius 伤害范围
--@param #table attacker 攻击者
--@param #number damage 伤害量,为空则不会造成伤害
--@param #handle ability 造成伤害的技能，可为空
function DamageEnemiesWithinRadius(point, radius,attacker, damage,ability)
	local enemies= FindEnemiesInRadiusEx(attacker,point,radius)
	if enemies~=nil then
		BatchApplyPhysicalDamage(enemies,attacker,damage,ability)
	end
end

---获取一个随机坐标(Vector)
--@param #Vector point 原坐标
--@param #number radius 随机范围
--@return #Vector 随机坐标
function FindRandomPoint(point,radius)
	if point then
		radius = radius or 100
		local re_point=point + RandomVector(RandomFloat(0, radius))
		return re_point;
	end

end

---两点之间的水平距离
function GetDistance2D(vector1,vector2)
	return (vector1 - vector2):Length2D()
end

---将某个坐标绕着一个中心点旋转一定的角度。Vector:Normalized()
--@param #Vector center 中心点向量
--@param #Vector vector 要旋转的向量值
--@param #number angle 角度值
function RotateVector2DWithCenter(center,vector,angle)
	return RotatePosition(center,QAngle(0,angle,0),vector)
end

---将给定的vector旋转水平angle度。Vector:Normalized()
--@param #Vector vector 要旋转的向量值
--@param #number angle 角度值
function RotateVector2D(vector,angle)
	return RotatePosition(Vector(0,0,0),QAngle(0,angle,0),vector)
end

---获取pos位置要面向point点时所需要的ForwardVector
function GetForwardVector(pos,point)
	return (point - pos):Normalized() --Normalized，将对应的vector缩放为长度为1的向量，方向向量？
end

---懒癌发作，封装dota自带的随机。随机一个[1-100]的数字，如果小于等于给定值，则返回true
--@param #number num 目标数，只能是整数，最小支持1
--@return #boolean (1-100)<=num
function RollPercent(num)
	return RollPercentage(num)
end

---随机一个[0-100]的整数（实际是包括0和100的），如果小于等于给定值，返回true
--RandomInt包含区间两头的值
--@param #number num 目标数，<font color="red">如果是0，则直接返回false</font>
--@return #number [0-100]<=num
function RandomLessInt(num)
	if num == 0 then
		return false;
	end
	return RandomInt(0,100) <= num
end

---随机一个[0-100]的浮点数（实际是包括0和100的），如果小于等于给定值，返回true
--@param #number num 目标数，<font color="red">如果是0，则直接返回false</font>
--@return #boolean [0-100]<=num
function RandomLessFloat(num)
	if num == 0 then
		return false;
	end
	return RandomFloat(0,100) <= num
end

---随机一个距离中心点min-max的点，距离为空则默认为0
function RandomPosInRadius(center,max,min)
	return center + RandomVector(RandomFloat(min or 0,max or 0))
end

---是否是作弊模式(IsInToolsMode()开发模式)
function IsCheatMode()
	return GameRules:IsCheatMode()
end

---获取游戏时间(游戏开始后)，不包括暂停时间
function GetGameTimeWithoutPause()
	return GameRules:GetGameTime();
end

---创建一个特效，返回特效ID
--<p>删除使用：ParticleManager:DestroyParticle(pid,true)
--@param #string path 特效路径
--@param #number AttachType 特效附着类型，常见类型：<br>
--<pre>
--	PATTACH_ABSORIGIN(0)：将特效附着在一个位置（origin）（一般应该是owner的位置，但是不会动）
--	PATTACH_ABSORIGIN_FOLLOW(1)：将特效附着在一个位置（origin），并随着owner移动。可以理解为附着在owner上
--	PATTACH_CUSTOMORIGIN(2)：将特效附着在一个自定义的位置上，通常还需要通过设置一个控制点（一般是0）来指明位置（Vector值）
--	PATTACH_CUSTOMORIGIN_FOLLOW(3)
--	PATTACH_POINT(4)
--	PATTACH_POINT_FOLLOW(5)：附着到指定点上，一般是指attach point，在模型上的点，比如 attack_hitloc
--	PATTACH_EYES_FOLLOW(6)：将特效附着到对应实体的“眼睛”上（如果有的话）
--	PATTACH_OVERHEAD_FOLLOW(7)：将特效附着到对应实体的头顶
--	PATTACH_WORLDORIGIN(8)：将特效附着到地上
--</pre>
--@param #table owner 特效拥有者
--@param #number duration 特效有效时间，结束后将销毁特效
--@param #boolean immediately 销毁的时候是否立刻销毁
--@return #number 特效ID
function CreateParticleEx(path,AttachType,owner,duration,immediately)
	local id = ParticleManager:CreateParticle(path,AttachType,owner)
	if type(duration) == "number" and duration >= 0 then
		if owner then
			local endTime = GetGameTimeWithoutPause() + duration
			TimerUtil.CreateTimerWithEntity(owner,function()
				if GetGameTimeWithoutPause() < endTime then
					return 0.5
				end
				
				
				if immediately == nil then
					immediately = false
				end
				ParticleManager:DestroyParticle(id, immediately)
				ParticleManager:ReleaseParticleIndex(id)
			end)
		else
			TimerUtil.createTimerWithDelay(duration,function()
				if immediately == nil then
					immediately = false
				end
				ParticleManager:DestroyParticle(id, immediately)
				ParticleManager:ReleaseParticleIndex(id)
			end)
		end
	end
	return id
end

---设置特效的控制点数据
--另外几个是：<br/>
--ParticleManager:SetParticleControlEnt(int particleIndex, int cpIndex?, handle owner, int attachType, string 附着点名称？, Vector 坐标？, bool bool_7)<br/>
--ParticleManager:SetParticleControlForward(int nFXIndex, int nPoint, vForward)<br>
--ParticleManager:SetParticleControlOrientation(int nFXIndex, int nPoint, vForward, vRight, vUp)<br>
function SetParticleControlEx(pid,controlPoint,value)
	ParticleManager:SetParticleControl(pid,controlPoint,value)
end

---设置实体控制点。
--<pre>
--	PATTACH_ABSORIGIN(0)：将特效附着在一个位置（origin）（一般应该是owner的位置，但是不会动）
--	PATTACH_ABSORIGIN_FOLLOW(1)：将特效附着在一个位置（origin），并随着owner移动。可以理解为附着在owner上
--	PATTACH_CUSTOMORIGIN(2)：将特效附着在一个自定义的位置上，通常还需要通过设置一个控制点（一般是0）来指明位置（Vector值）
--	PATTACH_CUSTOMORIGIN_FOLLOW(3)
--	PATTACH_POINT(4)
--	PATTACH_POINT_FOLLOW(5)：附着到指定点上，一般是指attach point，在模型上的点，比如 attack_hitloc
--	PATTACH_EYES_FOLLOW(6)：将特效附着到对应实体的“眼睛”上（如果有的话）
--	PATTACH_OVERHEAD_FOLLOW(7)：将特效附着到对应实体的头顶
--	PATTACH_WORLDORIGIN(8)：将特效附着到地上
--</pre>
function SetParticleControlEnt(pid,controlPoint,owner,attachType,attachPointName,vector)
	ParticleManager:SetParticleControlEnt(pid,controlPoint,owner,attachType,attachPointName,vector,true)
end

---创建单位。要让单位可以被玩家控制：unit:SetControllableByPlayer(playerid,true)
--@param #string unitName 单位名称
--@param #Vector pos 位置
--@param #boolean findClear 是否在空旷的位置创建。为true则单位不会堆叠；否则会在位置上堆叠（无论是否处于相位状态）
--@param #handle owner 拥有者实体。新创建的单位的owner可以通过GetOwner获取，但是对于英雄单位，返回的是玩家实体（即便传入的是一个英雄）；
--对于普通单位(creature)，返回的是创建传入的owner实体
--@param #number team 所属队伍。如果为空：有owner，则和owner一队；否则属于TEAM_ENEMY
function CreateUnitEX(unitName,pos,findClear,owner,team)
	if findClear == nil then
		findClear = false
	end

	if not team then
		if owner then
			team = owner:GetTeamNumber()
		else
			team = TEAM_ENEMY
		end
	end
	---两个owner：
	--第一个是npcOwner，不知道有啥用，为空了貌似也没有影响
	--第二个是unitOwner，如果传入的是英雄实体，新创建的单位通过GetPlayerOwnerID才能获取所属的玩家id（否则获取-1），部分逻辑会依赖这个（比如单位攻击敌人要在敌人身上显示血量，必须是单位归当前查看的玩家所有才行）
	--
	--Entity中的GetOwner和GetOwnerEntity返回的都是第二个owner
	--
	--对于unitName对应的单位不是英雄的，走上边的逻辑。
	--如果unitName对应的单位是英雄的，则只要unitOwner被某个玩家所有，创建出来的单位的owner就是拥有unitOwner的玩家，此时GetOwner获取到的是玩家实体而不是传入的单位
	return CreateUnitByName(unitName, pos, findClear, owner, owner, team)
end

---创建一个虚拟单位，属于owner，并且和owner同队
--@param #Vector pos 出生点
--@param #handle owner 拥有者
--@param #boolean noBaseBuff 是否去掉虚拟单位buff：无生命条、无小地图、无碰撞、攻击魔法免疫
--@param #boolean noSelectBuff 是否去掉不可选择buff
--@param #boolean noMoveBuff 是否去掉不可移动buff
function CreateDummyUnit(pos,owner,noBaseBuff,noSelectBuff,noMoveBuff)
	local unit = CreateUnitByName("npc_dummy_unit", pos, true, owner, owner, owner:GetTeamNumber())
	local ability = unit:FindAbilityByName("dummy_unit")
	if ability then
		ability:SetLevel(1)
	end
	if noBaseBuff then
		unit:RemoveModifierByName("modifier_dummy_unit")
	end
	if noSelectBuff then
		unit:RemoveModifierByName("modifier_dummy_unit_select")
	end
	if noMoveBuff then
		unit:RemoveModifierByName("modifier_dummy_unit_move")
	end
	return unit
end

--function CreateThinkerDota(caster,ability,modifier,modifierParam,origin,team,PhantomBlocker)
--	return CreateModifierThinker(caster,ability,modifier,modifierParam,origin,team,PhantomBlocker)
--end

---为指定单位添加一个lua定义的modifier，重复添加会刷新modifier <p>
--(移除：RemoveModifierByName,RemoveModifierByNameAndCaster) <p>
--(handle ApplyDataDrivenModifier(handle hCaster, handle hTarget, string pszModifierName, handle hModifierTable))
--@param #table caster 发出该modifer的单位。如果为空的，会出现一些莫名其妙的问题
--（比如增加回血速度的bufff，如果没有caster，则客户端不显示回血速度的变化。即caster为你来，则客户端就不调用这个buff的逻辑。所以如果需要在客户端显示的话，则必须传入caster，否则可以不传入）
--@param #table target 被添加modifier的单位
--@param #string modifierName modifier名称
--@param #table modifierData modifier初始化参数。比如{duration=10}
--@param #handle ability 技能实体，在modifier中可以通过self:GetAbility()获取
--@return #table 添加成功后返回该modifier对象
function AddLuaModifier(caster,target,modifierName,modifierData,ability)
	return target:AddNewModifier(caster,ability,modifierName,modifierData or {})
end

---添加一个数据驱动的buff(移除：RemoveModifierByName)<br>
--@param #handle ability 如果ability是技能的话，返回添加成功的modifier对象；<font color="red">如果是物品，则无返回</font>
--@return #handle 如果ability是技能的话，返回添加成功的modifier对象；<font color="red">如果是物品，则无返回</font>
function AddDataDrivenModifier(ability,caster,target,modifierName,modifierData)
	return ability:ApplyDataDrivenModifier(caster,target,modifierName,modifierData or {})
end

---为某队伍添加临时视野。默认给玩家队伍
--<p>AddFOWViewer(nTeamID, vLocation, flRadius, flDuration, bObstructedVision)<br>
--bObstructedVision:阻塞视野
function AddTempFOWViewer(location,radius,duration,teamID)
	if not teamID then
		teamID = TEAM_PLAYER
	end
	AddFOWViewer(teamID, location, radius, duration, false)
end

-- **************自定义事件相关

---向所有客户端发送事件
function SendToAllClient(eventName,data)
	CustomGameEventManager:Send_ServerToAllClients(eventName,data);
end

---向某个玩家发送事件
--@param #number player 玩家id、玩家实体、或者单位实体。如果为nil，则发送给所有客户端
function SendToClient(player,eventName,data)
	if player == nil then
		SendToAllClient(eventName,data)
		return;
	end

	if type(player) == "number" then
		player = PlayerResource:GetPlayer(player)
	elseif type(player) == "table" and player.GetPlayerOwner then
		player = player:GetPlayerOwner()
	end
	if player then
		CustomGameEventManager:Send_ServerToPlayer(player,eventName,data);
	end
end

---注册自定义事件的监听器
--@param #string eventName 时间名称
--@param #function handler 处理函数。函数参数有两个(unknown,data)，第一个是一个数字（暂时不知道有什么用），第二个是一个table，包括PlayerID（发送这个事件的玩家id）和所有客户端传送过来的其他参数。
--@return #number 处理器id，可以用来注销
function RegisterEventListener(eventName,handler)
	return CustomGameEventManager:RegisterListener(eventName,handler)
end

---dota7.07后，技能的behavior变成了用户自定义类型(uint64)，不是数字了。<br>
--但是在位运算比较类型的时候，仍然需要数字，所以将其转换为数字类型。
--虽然后来又改成了int，这里还这样处理
function GetAbilityBehaviorNum(ability)
	if ability then
		local behavior = ability:GetBehavior();
		if type(behavior) == "number" then
			return behavior
		else
			return tonumber(tostring(behavior)) 
		end
	end
end

---播放一个音效<br>
--EmitGlobalSound(soundName)<br>
--Entity:StopSound(soundName)<br>
--StopSoundOn(soundName,caster)<br>
--EmitSoundOnLocationForAllies(loc, soundName, caster)<br>
--EmitSoundOnLocationWithCaster(loc, soundName, caster)
function EmitSound(entity,soundName)
	if entity and entity.EmitSound and type(soundName) == "string" then
		entity:EmitSound(soundName)
	end
end

function StopSoundOnEntity(entity,soundName)
	entity:StopSound(soundName)
end

---在指定位置播放音效
function EmitSoundOnLoc(point, soundName, caster)
	EmitSoundOnLocationWithCaster(point, soundName, caster)
end

---播放一个音效
--@param #string soundName 音效名字
--@param #any Player 玩家实体或者玩家id
function EmitSoundForPlayer(soundName,Player)
	if Player and type(soundName) == "string" then
		if type(Player) == "number" then
			Player = PlayerUtil.GetPlayer(Player,false)
		end
		if type(Player) == "table" then
			EmitSoundOnClient(soundName,Player)
		end
	end
end

---获取技能当前等级的特殊值，没有对应的键，返回0
--@param #handle ability 技能实体
--@param #string svName 特殊值名字
--@param #number level 技能等级，为空的话将获取当前等级对应的键值
--@return #number 没有对应的键，就返回0
function GetAbilitySpecialValueByLevel(ability,svName,level)
	if type(level) == "number" then
		return ability:GetLevelSpecialValueFor(svName,level - 1) or 0
	else
		return ability:GetSpecialValueFor(svName) or 0
	end
end

---设置nettable的value，valueTable可以为nil，其他参数不可为空
--@param #string tableName
--@param #string key
--@param #table valueTable 必须是一个表
function SetNetTableValue(tableName,key,valueTable)
	if type(tableName) == "string" and type(key) == "string" then
		CustomNetTables:SetTableValue(tableName,key,valueTable);
	end
end
---调用频率高的场景尽量别用。比如在modifier的客户端处理逻辑中，会导致内存上涨过快
function GetNetTableValue(tableName,key)
	if type(tableName) == "string" and type(key) == "string" then
		return CustomNetTables:GetTableValue(tableName,key);
	end
end

---返回YYYYMMDDHHmmss（字符串）
--@param #boolean onlyDate 只返回日期，如果是true，则只返回 YYYYMMDD
function GetDateTime(onlyDate)
	local date = Split(GetSystemDate(),"/");
	date = "20"..date[3]..date[1]..date[2]
	if onlyDate then
		return date;
	end
	local time = string.gsub(GetSystemTime(),":","")
	return date..time	
end

-----
----包装FindClearSpaceForUnit函数。<p>
----使用FindClearSpaceForUnit实现传送的时候，虽然界面上是瞬间过去了，
----但是实际需要一段延迟才能触发triggerArea的enter事件。为了解决这个问题，添加了一些特殊的逻辑。<p>
----具体的可以查看modifier_custom_teleporting。
----@param #handle unit 单位实体
----@param #Vector postion 目标点坐标
----@param #boolean needCollision 传送过程中是否需要碰撞，某些特殊逻辑里面可能需要在传送过程中保持碰撞，比如为了触发触发区域等，此时设置为true
----(貌似最新版的只需要设置最后一个参数为true就能立刻触发触发区域的touch事件了。 先注释掉modifier，以后有变化了再说)
--function Teleport(unit,postion,needCollision)
--	if unit and postion then
--		if needCollision then
--			FindClearSpaceForUnit( unit, postion, true )
--		else
----			AddLuaModifier(unit,unit,"modifier_custom_teleporting")
--			FindClearSpaceForUnit( unit, postion, true ) --貌似最新版的只需要设置最后一个参数为true就能立刻触发触发区域的touch事件了。 先注释掉modifier，以后有变化了再说
----			unit:RemoveModifierByName("modifier_custom_teleporting")
--		end
--	end
--end

---
--传送，包装FindClearSpaceForUnit函数。<p>
--@param #handle unit 单位实体
--@param #Vector postion 目标点坐标
function Teleport(unit,postion)
	if unit and postion then
		FindClearSpaceForUnit( unit, postion, true )
	end
end


---创建一个有明确目标的投射物特效，不提供视野
--@param #handle source 投射物发出单位
--@param #handle target 目标实体
--@param #handle ability 来源技能
--@param #string effectName 特效路径
--@param #number speed 飞行速度，为空的时候默认为source的投射物速度
function CreateProjectileWithTarget(source,target,ability, effectName, speed)
	local info = {
		Source = source,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		vSourceLoc = nil,
		Target = target,
		Ability = ability,	
		EffectName = effectName,
        iMoveSpeed = speed or source:GetProjectileSpeed(),
		bDrawsOnMinimap = false,
        bDodgeable = false,
        bIsAttack = false, --如果是的话，应该会触发OnAttack事件？未测试
        bVisibleToEnemies = true,
        bReplaceExisting = false,
        flExpireTime = GameRules:GetGameTime() + 20,
	}
	return ProjectileManager:CreateTrackingProjectile(info)
end

---创建一个没有明确目标的投射物特效，该特效以敌方英雄和普通单位为目标，不提供视野
--@param #handle caster 施法者
--@param #handle ability 来源技能
--@param #string effectName 特效路径
--@param #Vector startLoc 特效产生点，为空则默认为caster的位置
--@param #number distance 飞行距离
--@param #number startRadius 开始的宽度
--@param #number endRadius 结束的宽度
--@param #Vector vVelocity 飞行速度（带有方向因素）
--@param #boolean deleteOnHit 碰到单位是否删除，如果是技能中添加了“投射物命中”的事件，则这个不会生效
function CreateProjectileNoTarget(caster,ability,effectName,
	startLoc,distance,startRadius,endRadius,vVelocity,deleteOnHit)
	local info = {
		Source = caster,
		Ability = ability,
		EffectName = effectName,
		vSpawnOrigin = startLoc or caster:GetAbsOrigin(),
		fDistance = distance,
		fStartRadius = startRadius,
		fEndRadius = endRadius,
		vVelocity = vVelocity,
		bHasFrontalCone = false, --正面锥形？？？？？
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + 20,
		bDeleteOnHit = deleteOnHit,
	}
	return ProjectileManager:CreateLinearProjectile(info)
end

---移除一个Dota实体数组中所有死亡或者为Null的实体
--@return #number 数组中非空数量
--@return #number null的数量
function RemoveDiedEntityInArray(array)
	local notNull = 0
	local null = 0
	if type(array) == "table" and #array > 0 then
		for index=#array, 1, -1 do
			local entity = array[index]
			if EntityIsAlive(entity) then
				notNull = notNull + 1
			else
				table.remove(array,index)
				null = null + 1
			end
		end
	end
	return notNull,null
end

---清空一个单位的数组：移除所有的单位实体，并清空数组空间。
--@param #table array 要处理的数组
--@param #boolean showDied 是否显示单位死亡动画。如果显示的话，
--并不会立刻移除单位模型以及附着在该单位身上的特效等，并且会播放单位的死亡动画（如果没有的话，单位会变得僵直，并渐渐沉入地下）
function ClearUnitArray(array,showDied)
	for index=#array, 1, -1 do
		local unit = array[index]
		EntityHelper.kill(unit,not showDied)
		table.remove(array,index)
	end
end

---强制播放单位动画
--@param #handle unit 单位实体
--@param #number actConst 动作常量。比如：
--<pre>
--ACT_DOTA_IDLE
--ACT_DOTA_RUN
--ACT_DOTA_ATTACK
--ACT_DOTA_DIE
--ACT_DOTA_SPAWN
--</pre>
--@param #number duration 该动画播放多久，可为空
function LetUnitDoAction(unit,actConst,duration)
	if duration then
		unit:StartGestureWithPlaybackRate(actConst,duration)
	else
		unit:StartGesture(actConst)
	end
end

---净化单位身上的buff
--@param #handle unit 单位实体
--@param #boolean bRemovePositiveBuffs 移除正面buff
--@param #boolean bRemoveDebuffs 移除负面buff
--@param #boolean bFrameOnly ？？？
--@param #boolean bRemoveStuns 移除眩晕效果
--@param #boolean bRemoveExceptions 移除异常状态，可能指的是kv中的状态属性？
function PurgeUnit(unit,bRemovePositiveBuffs,bRemoveDebuffs,bFrameOnly,bRemoveStuns,bRemoveExceptions)
	unit:Purge(bRemovePositiveBuffs,bRemoveDebuffs,bFrameOnly,bRemoveStuns,bRemoveExceptions)
end

---围绕单位实体画一个绿色的圆圈。实际是一个特效，返回该特效的id用来销毁()。
function DrawGreenRing(unit,radius,duration)
	local path = "particles/ui_mouseactions/range_display.vpcf"
	local pid = CreateParticleEx(path,PATTACH_ABSORIGIN_FOLLOW,unit,duration,true)
	SetParticleControlEx(pid,1,Vector(radius,0,0))	
	return pid
end

---使一个单位有持续时间，时间结束，将强制杀死该单位
function MakeUnitTemporary(unit,lifetime,ability)
	AddLuaModifier(unit,unit,"modifier_kill",{duration=lifetime},ability)
end

---在单位头顶显示一个特殊信息。诸如伤害、金币、治疗量等等
-- @param #handle unit 单位实体，显示在它的头顶
-- @param #number msgType JS api中OVERHEAD_ALERT_*的常量。
-- @param #number value 显示数值
-- @param #handle targetPlayer 玩家实体，给哪个玩家显示，可为空。为空应该是显示给所有人的
-- @param #handle sourcePlayer 玩家实体，谁发送的消息，可为空
-- <p>
-- Msg type常量：
--<pre>
--OVERHEAD_ALERT_GOLD	0（显示金币的时候自带增加金币的音效）
--OVERHEAD_ALERT_DENY	1	
--OVERHEAD_ALERT_CRITICAL	2	
--OVERHEAD_ALERT_XP	3	
--OVERHEAD_ALERT_BONUS_SPELL_DAMAGE	4	
--OVERHEAD_ALERT_MISS	5	
--OVERHEAD_ALERT_DAMAGE	6	
--OVERHEAD_ALERT_EVADE	7	
--OVERHEAD_ALERT_BLOCK	8	
--OVERHEAD_ALERT_BONUS_POISON_DAMAGE	9	
--OVERHEAD_ALERT_HEAL	10	
--OVERHEAD_ALERT_MANA_ADD	11	
--OVERHEAD_ALERT_MANA_LOSS	12	
--OVERHEAD_ALERT_LAST_HIT_EARLY	13	
--OVERHEAD_ALERT_LAST_HIT_CLOSE	14	
--OVERHEAD_ALERT_LAST_HIT_MISS	15	
--OVERHEAD_ALERT_MAGICAL_BLOCK	16	
--OVERHEAD_ALERT_INCOMING_DAMAGE	17	
--OVERHEAD_ALERT_OUTGOING_DAMAGE	18	
--OVERHEAD_ALERT_DISABLE_RESIST	19	
--OVERHEAD_ALERT_DEATH	20	
--OVERHEAD_ALERT_BLOCKED	21
--</pre>
function ShowOverheadMsg(unit,msgType,value,targetPlayer,sourcePlayer)
	SendOverheadEventMessage(targetPlayer,msgType,unit,value,sourcePlayer)
end


---GridNav:IsTraversable(vector)<br>
--GridNav:IsBlocked(vector)
function CanFindPath(v1,v2)
	return GridNav:CanFindPath(v1,v2)
end

function GetGround(vector,unit)
	return GetGroundPosition(vector,unit)
end
---设置游戏难度。
function SetDifficulty(difficulty)
	GameRules:SetCustomGameDifficulty(difficulty)
end
---获取游戏难度（没有设置的时候，返回0）
function GetGameDifficulty()
	return GameRules:GetCustomGameDifficulty()
end

---设置当前游戏难度应用的模式
function SetDifficultyMode(mode)
	GameRules:GetGameModeEntity():Attribute_SetIntValue("tzj_difficulty_mode",mode)
end
---获得当前游戏难度应用的模式，默认返回1，即正常模式
function GetGameDifficultyModel()
	return GameRules:GetGameModeEntity():Attribute_GetIntValue("tzj_difficulty_mode",1)
end

---游戏是否已经结束（显示最后的胜利或这失败的界面）
function IsInPostGameState()
	return GameRules:State_Get() == DOTA_GAMERULES_STATE_POST_GAME
end

---尝试在给定点附近随机一个可以到达的位置，有尝试上限，所以有可能获取不到合适的位置
function FindReachablePoint(pos,radiusMin,radiusMax)
	local launchPos = pos+RandomVector(RandomInt(radiusMin,radiusMax));
	--只尝试1000次，如果实在找不到合适的敌方，就放在pos（这里假定pos是一定可以过去的）
	for var=1, 1000 do
		--IsBlocked和IsTraversable不一样。 即使isBlocked是false，也可能是not Traversable的，所以用这种方式来判断比较稳妥
		if not GridNav:IsTraversable(launchPos) then
			if var == 1000 then
				launchPos = pos
			else
				launchPos = pos+RandomVector(RandomInt(radiusMin,radiusMax));
			end
		else
			break;
		end
	end
	return launchPos
end

---在地上创建一个物品
--@param #any itemOrName 物品名称或者物品实体
--@param #handle owner 物品拥有者（比如英雄单位），仅当itemOrName是物品名称的时候有效，会设置物品归属
--@param #Vector pos 掉落点坐标，没有做是否可以到达的判定，在调用处进行判定
--@param #number launchDistance 发射距离，如果大于0，则创建物品后会将物品发射至掉落点附近50~launchDistance距离的随机位置。如果其小于50的话，则会以50处理
--@param #boolean initQualityParticle 是否显示初始（物品第一次出现在地图上）品质特效，用于随机物品初次掉落的时候
function CreateItemOnGround(itemOrName,owner,pos,launchDistance,initQualityParticle)
	local item = itemOrName 
	if type(itemOrName) == "string" then
		item = CreateItem(itemOrName, owner, owner)
	end
	
	if EntityNotNull(item) then
		local launchHeight = 0
		local launchDuration = 0
		local launchPos = pos
		
		if type(launchDistance) == "number" and launchDistance > 0 then
			launchHeight = 200
			launchDuration = 0.6;
			if launchDistance < 50 then
				launchDistance = 50
			end
			launchPos = FindReachablePoint(pos,50,launchDistance)
		end
		---LaunchLoot:当物品掉落在地面时，将物品发射出去，使其落在某个地点。
		--要先用CreateItemOnPositionXXX创建一个物品才行，这里选择CreateItemOnPositionForLaunch(还有个CreateItemOnPositionSync)
		--第一个参数为true，则靠近该物品就会触发拾取逻辑，否则需要右键点击触发拾取。<<不管是否需要发射出去，都使用这个接口来创建地上的物品，就是为了动态设置这个参数>>
		--第二个参数是发射的高度
		--第三个是发射耗时，越小越快
		--第四个参数是掉落地点
		local drop = CreateItemOnPositionForLaunch(pos, item)
		local noUse = GetAbilitySpecialValueByLevel(item,"not_pick_up_use")
		item:LaunchLoot(item:IsCastOnPickup() and noUse ~= 1, launchHeight, launchDuration, launchPos)
    	
    	--随机装备，添加品质特效
    	local quality = item.pz
    	if quality and string.sub(item:GetAbilityName(),1,8) == "item_sj_" then
    		TimerUtil.createTimerWithDelay(launchDuration+0.1,function()
    			--初始化特效
	    		if EntityIsAlive(drop) then
	    			if initQualityParticle then
	    				local pname = Color[quality]
						local p1 = ParticleManager:CreateParticle(pname, PATTACH_ABSORIGIN, drop)
						ParticleManager:SetParticleControl(p1, 0, drop:GetAbsOrigin())
	    			end
	    			--动态创建品质常态特效，使用物品中的特效不知道为啥后期特效会消失
	    			local path = "particles/item_quality/item_quality_lv"..quality..".vpcf"
	    			local p1 = ParticleManager:CreateParticle(path, PATTACH_ABSORIGIN, drop)
					ParticleManager:SetParticleControl(p1, 0, launchPos)
				end
    		end)
    	end
    	
    	--模型皮肤，主要用于技能
    	local skin = item:GetSpecialValueFor("model_skin")
    	if skin and drop then
    		drop:SetSkin(skin)
    	end
    	
		return item;
	else
		DebugPrint("create item faild!!!\t itemName:"..tostring(itemOrName))
	end
end

---将给定物品扔在地上：随机装备会显示品质常态光效；技能会显示技能皮肤；扔完以后会播放一个声音
--@param #handle item 物品实体
--@param #Vector postion 掉落点坐标
--@param #number distance 发射距离，如果为nil或者0，则直接放在掉落点。否则，创建物品后会将物品发射至掉落点附近50~distance码范围的随机位置。如果其小于50的话，则会以50处理
function DropItemEx(item,postion,distance)
	local item = CreateItemOnGround(item,nil,postion,distance)
	if item then
		EmitSound(item,"Item.DropWorld")
	end
end

---在地上生成一个物品
--@param #string item_name 物品名称
--@param #vector pos 掉落地点
--@param #number drop_distance 掉落距离掉落点的范围
--@param #table hero 物品所属英雄，可为空
function CreateSuitItemOnGround(item_name,pos,drop_distance,hero)
	if item_name and pos then
		local item = CreateItem(item_name, nil, nil)
		local name = string.sub(item_name,1,9)
		local name2 =  string.sub(item_name,1,11)
		if name == "item_tz_3" then
			item.pz = 2
			item.lv = 2
		end
		if name2 == "item_tz_4_1" or name2 == "item_tz_4_2"  then
			item.pz = 3
			item.lv = 3
		end
		if name2 == "item_tz_4_3" or name2 == "item_tz_4_4"  then
			item.pz = 3
			item.lv = 3
		end
		if name2 == "item_tz_4_5" or name2 == "item_tz_4_6"  then
			item.pz = 4
			item.lv = 4
		end
		if name2 == "item_tz_4_7" or name2 == "item_tz_4_8"  then
			item.pz = 4
			item.lv = 4
		end
		if name == "item_tz_5" then
			item.pz = 5
			item.lv = 5
		end

		if item then
			CreateItemOnGround(item,nil,pos,300)
		elseif IsInToolsMode() then
			print("create item faild!!!\t itemName:"..tostring(item_name))
		end
	end
end



--随机套装的一个散件
function ZbRoll(unit,tz)

	local zz = #TZ.tzz[tz]
	local z = RandomInt(1,zz)
	local y2 = TZ.tzz[tz][z]
	local pos = unit:GetAbsOrigin()
	CreateSuitItemOnGround(y2,pos,200,unit)


end

--套装三个全出
function ZbAll(unit,tz)

	local zz = #TZ.tzz[tz]
	local pos = unit:GetAbsOrigin()
	for i=1,zz do
		local y2 = TZ.tzz[tz][i]
		
	    CreateSuitItemOnGround(y2,pos,200,unit)
		
	end

end

---使用药剂
--@param #number playerID 玩家ID
--@param #number level 药剂的级别 现在默认是1
--@param #number type 药剂的种类编号
function UseDrug(playerID,level,type)
	if not playerID then
		return nil 
	end
	if not Stage.playeronline then
		return nil
	end
	local modifier = "modifier_yj_"..level.."_"..type
	for _, PlayerID in pairs(Stage.playeronline) do
		local hero = PlayerUtil.GetHero(PlayerID)
		--还是不先加特效了
		StartSoundEvent("Hero_OgreMagi.Bloodlust.Target",hero)
		hero:AddNewModifier(hero,nil,modifier,{duration=30})
	end


end



--打印一个表
function print_r( t )  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end