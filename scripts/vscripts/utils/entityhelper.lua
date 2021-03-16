require("libraries.DotaEx")

---判断一个实体是否不为空：lua对象不为空，并且对应的c++实体也不为空
--@param #table entity 实体对象
function EntityNotNull(entity)
	return entity and not entity:IsNull()
end

---判断一个实体是否为空：lua对象为空，或对应的c++实体为空
--@param #table entity 实体对象
function EntityIsNull(entity)
	return not entity or entity:IsNull()
end
---判断一个实体是否存活：lua对象不为空，并且对应的c++实体也不为空，并且活着
function EntityIsAlive(entity)
	return EntityNotNull(entity) and entity:IsAlive()
end

--*****************************************************************************************************************************
--实体操作工具类，封装了dota2的接口以便于使用(写代码的时候可以在ide中通过提示获取方法，而不容易出错，也便于查找)
--*****************************************************************************************************************************
local m = {}
--根据实体的索引获取实体对象
function m.findEntityByIndex(index)
	if index then
		return EntIndexToHScript( index )
	end
end

--根据实体对象获取实体索引
function m.getEntityIndex(entity)
	if entity then
		return entity:entindex();
	end
end

---根据实体名称获取实体对象
function m.findEntityByName(name)
	if name then
		return Entities:FindByName(nil,name)
	end
end

---移除一个不为空的实体。这个会移除掉对应的c++对象，但是lua对象还是可用的<p>
--由于C++对象被直接移除，很多依赖该对象的逻辑都可能会出错。<br>
--比如该对象通过光环给其他单位加了buff，当删除对象后，光环消失，buff在销毁的时候需要用到caster，但是这个时候通过buff去获取caster就会获取不到。<br>
--<font color="red">所以，如果是npc单位，建议使用kill</font>
function m.remove(entity)
	if EntityNotNull(entity) then
		--如果是可杀死的，使用杀死的逻辑，避免直接移除不触发相应的死亡事件，导致一些声音和特效不消失
		if entity.ForceKill then
			m.kill(entity,true)
		else
			entity:RemoveSelf();
		end
	end
end

---强制杀死一个单位，比直接remove实体要好一些，因为单位死了并不会立即移除c++对象，且会触发OnDeath事件。
--这样在一些特殊逻辑中，比如buff的destroy等，就不会出错了。<p>
--但是如果单位有模型，就会播放死亡动画（没有该动画，就什么也不做），即不会立刻消失。<br>
--此时如果需要立刻消失，可以设置hide为true
--<p>注意：杀死单位会进入damageFilter逻辑中
--@param #handle npc 单位实体。只有这些实体才可以“杀死”。
--@param #boolean hide 是否隐藏单位实体。隐藏以后，其身上的特效和模型都会立刻消失
function m.kill(npc,hide)
	if EntityIsAlive(npc) and npc.ForceKill then
		--这样的话，单位身上特效还有模型都会被立刻隐藏掉
		if hide then
			npc:AddNoDraw()
		end
		npc:ForceKill(false) --参数是是否可以重生
	end
end

---在地图上某个实体点的位置显示提示信息
function m.ShowOnMiniMap(entity)
	if entity and entity.GetAbsOrigin then
		SendToAllClient("zxj_ping_minimap",{loc=entity:GetAbsOrigin()})
	end
end

---判断给定实体是否是英雄：不为空，并且是英雄的时候才返回true
function m.IsHero(entity)
	return EntityNotNull(entity) and entity.IsHero and entity:IsHero()
end

--给定的实体是否是力量型英雄
function m.IsStrengthHero(entity)
	return m.IsHero(entity) and entity:GetPrimaryAttribute() ==  DOTA_ATTRIBUTE_STRENGTH;
end

--给定的实体是否是敏捷型英雄
function m.IsAgilityHero(entity)
	return m.IsHero(entity) and entity:GetPrimaryAttribute() ==  DOTA_ATTRIBUTE_AGILITY;
end

--给定的实体是否是智力型英雄
function m.IsIntellectHero(entity)
	return m.IsHero(entity) and entity:GetPrimaryAttribute() ==  DOTA_ATTRIBUTE_INTELLECT;
end


return m;
