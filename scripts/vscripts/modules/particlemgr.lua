local m = {}

local cache = {}

--TODO 需要实现具体显隐逻辑

---创建特效 
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
--@param #handle ownerEntity 特效拥有者（一般是单位实体）
--@param #boolean suppressible 特效是否可被屏蔽（玩家选择性屏蔽）
--@param #boolean isPermanent 是否是常驻的特效。非常驻的特效仅在创建特效的时候根据屏蔽等级来判断是否创建，常驻特效会在玩家切换屏蔽等级的时候动态改变显隐性。
function m.Create(path,AttachType,ownerEntity,suppressible,isPermanent)
	return ParticleManager:CreateParticle(path,AttachType,ownerEntity)
	
--	if not suppressible then
--		return ParticleManager:CreateParticle(path,AttachType,ownerEntity)
--	else
--		local owner = nil
--		local PlayerID = nil
--		if ownerEntity then
--			owner = ownerEntity:GetOwner()
--			while owner and not owner:IsPlayer() do
--				owner = owner:GetOwner()
--			end
--			
--			if owner then
--				PlayerID = owner:GetPlayerID()
--			end
--		end
--		
--		local prefix = PlayerID == nil and "x_" or tostring(PlayerID).."_"
--		local pid = nil --测试了连续创建了几十万个，也没有重复，应该是不会重复的，即便release
--		if owner then
--			pid = ParticleManager:CreateParticleForPlayer(path,AttachType,ownerEntity,owner)
--		else
--			pid = ParticleManager:CreateParticle(path,AttachType,ownerEntity)
--		end
--	end
	
end

--function m.Destroy(particleID,immediately,PlayerID)
--	CreateParticleEx(path,AttachType,owner,duration,immediately)
--
--	if PlayerID then
--		local data = cache[PlayerID]
--		if data and data[particleID] then
--			ParticleManager:DestroyParticle(particleID, immediately)
--			ParticleManager:ReleaseParticleIndex(particleID)
--			data[particleID] = nil
--		end
--	else
--		for _, data in pairs(cache) do
--			if data[particleID] then
--				
--			end
--		end
--	end
--end

---为某个单位创建一个警告圈
--@param #handle unit 单位实体，特效依附单位，不可为空。并且如果不设置point，会以单位所在的位置为特效出现的位置
--@param #Vector point 特效出现的位置，可为空。为空以拥有者所在位置创建特效
--@param #number radius 圈的大小
--@param #number duration 圈持续的时间
function m.CreateWarnRing(unit,point,radius,duration)
	if not unit then
		return;
	end
--	duration = string.format("%.2f",duration)
	if duration <= 0 then
		return;
	end

	local pid = CreateParticleEx("particles/boss/tsq/clicked_rings_red2.vpcf",PATTACH_CUSTOMORIGIN,unit,duration+1)
	if point then
		SetParticleControlEx(pid,0,point)
	else
		SetParticleControlEnt(pid,0,unit,PATTACH_POINT_FOLLOW,"attach_origin",unit:GetOrigin())
	end
	SetParticleControlEx(pid,1,Vector(radius,1,1))
	SetParticleControlEx(pid,2, Vector(duration,0,0))
--	SetParticleControlEx(pid,3, Vector(178,34,34))
end

return m;