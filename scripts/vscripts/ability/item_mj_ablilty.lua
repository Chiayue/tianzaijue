--获取随机到的词条属性和数值
local function ctsx(abilityName,n,playerID,caster,name)
	local z = 0
	local x = 0
	local y = 0
	local m = 0
	local qz = {}
	local sx = {}
	local result ={}

	local originAbility = name

	local unitKey = tostring(EntityHelper.getEntityIndex(caster))
	if not caster.cas_table then
		caster.cas_table = {}
	end
	local netTable = caster.cas_table --服务端存储，避免使用getNetTable方法

	--获取最高的概率加成
	for i=1, n do
		y = Mj.jnctqz[Mj.jnct[abilityName][i]][1]
		x = x + Mj.jnctqz[Mj.jnct[abilityName][i]][1]
		--建立权重表
		qz[i] = y
		--建立词条表
		sx[i] = Mj.jnct[abilityName][i]
		--测试用的,测试百万次的概率分布
		--result[Mj.jnct[abilityName][i]] = 0
	end
	--根据权重获得到的词条
	local randomValue = GetRanomByWeight(sx, qz)
	if not caster.cas_table.jnmjts then
		caster.cas_table.jnmjts = 1
	end
	z = Mj.jnctsx[randomValue][1] * caster.cas_table.jnmjts
				if abilityName =="jqz" then 
					if randomValue == "baseDamage" then
						if caster.jqz_baseDamage == nil then
							caster.jqz_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))*5
						caster.jqz_baseDamage = caster.jqz_baseDamage + z
						netTable["jqz_baseDamage"] = caster.jqz_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
			 			NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.jqz_damage == nil then
							caster.jqz_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z*2))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.jqz_damage = caster.jqz_damage + z
						netTable["jqz_damage"] = caster.jqz_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)			
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "radius" then
						if caster.jqz_radius == nil then
							caster.jqz_radius = 0
						end
						z = math.ceil(RandomInt(10,z)/2)
						caster.jqz_radius = caster.jqz_radius + z
						netTable["jqz_radius"] = caster.jqz_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "distance" then
						if caster.jqz_distance == nil then
							caster.jqz_distance = 0
						end
						z = RandomInt(10,z)/2
						caster.jqz_distance = caster.jqz_distance + z
						netTable["jqz_distance"] = caster.jqz_distance
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_distance",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil
					elseif randomValue == "max" then
						if caster.jqz_max == nil then
							caster.jqz_max = 0
						end
						z = 0.5
						caster.jqz_max = caster.jqz_max + z
						netTable["jqz_max"] = caster.jqz_max
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_max",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil
					elseif randomValue == "time" then
						if caster.jqz_time == nil then
							caster.jqz_time = 0
						end
						z = RandomInt(1,z)
						caster.jqz_time = caster.jqz_time + z
						netTable["jqz_time"] = caster.jqz_time
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_time",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil
					elseif randomValue == "multiple" then
						if caster.jqz_multiple == nil then
							caster.jqz_multiple = 0
						end
						z = RandomInt(1,z)
						caster.jqz_multiple = caster.jqz_multiple + z
						netTable["jqz_multiple"] = caster.jqz_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil
					end
				

				--*******************************************************************************************
				--雷霆一击
				elseif abilityName =="ltyj" then 
					if randomValue == "baseDamage" then
						if caster.ltyj_baseDamage == nil then
							caster.ltyj_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5)) *5
						caster.ltyj_baseDamage = caster.ltyj_baseDamage + z
						netTable["ltyj_baseDamage"] = caster.ltyj_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.ltyj_damage == nil then
							caster.ltyj_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.4,z*4))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.ltyj_damage = caster.ltyj_damage + z
						netTable["ltyj_damage"] = caster.ltyj_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "radius" then
						if caster.ltyj_radius == nil then
							caster.ltyj_radius = 0
						end
						z = RandomInt(10,z)
						caster.ltyj_radius = caster.ltyj_radius + z
						netTable["ltyj_radius"] = caster.ltyj_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "duration" then
						if caster.ltyj_duration == nil then
							caster.ltyj_duration = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))
						caster.ltyj_duration = caster.ltyj_duration + z
						netTable["ltyj_duration"] = caster.ltyj_duration
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_duration",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil
					elseif randomValue == "time" then
						if caster.ltyj_time == nil then
							caster.ltyj_time = 0
						end
						z = RandomInt(1,z)
						caster.ltyj_time = caster.ltyj_time + z
						netTable["ltyj_time"] = caster.ltyj_time
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_time",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil
					elseif randomValue == "multiple" then
						if caster.ltyj_multiple == nil then
							caster.ltyj_multiple = 0
						end
						z = RandomInt(1,z)
						caster.ltyj_multiple = caster.ltyj_multiple + z
						netTable["ltyj_multiple"] = caster.ltyj_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil
					end
				



				--*******************************************************************************************
				--战争践踏
				elseif abilityName =="zzjt" then 
					if randomValue == "baseDamage" then
						if caster.zzjt_baseDamage == nil then
							caster.zzjt_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))*5
						caster.zzjt_baseDamage = caster.zzjt_baseDamage + z
						netTable["zzjt_baseDamage"] = caster.zzjt_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.zzjt_damage == nil then
							caster.zzjt_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.5,z*5))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.zzjt_damage = caster.zzjt_damage + z
						netTable["zzjt_damage"] = caster.zzjt_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "radius" then
						if caster.zzjt_radius == nil then
							caster.zzjt_radius = 0
						end
						z = RandomInt(10,z)
						caster.zzjt_radius = caster.zzjt_radius + z
						netTable["zzjt_radius"] = caster.zzjt_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "duration" then
						if caster.zzjt_duration == nil then
							caster.zzjt_duration = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))
						caster.zzjt_duration = caster.zzjt_duration + z
						netTable["zzjt_duration"] = caster.zzjt_duration
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_duration",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil
					elseif randomValue == "time" then
						if caster.zzjt_time == nil then
							caster.zzjt_time = 0
						end
						z = RandomInt(1,z)
						caster.zzjt_time = caster.zzjt_time + z
						netTable["zzjt_time"] = caster.zzjt_time
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_time",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil
					elseif randomValue == "multiple" then
						if caster.zzjt_multiple == nil then
							caster.zzjt_multiple = 0
						end
						z = RandomInt(1,z)
						caster.zzjt_multiple = caster.zzjt_multiple + z
						netTable["zzjt_multiple"] = caster.zzjt_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					     NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")
					      return nil	
					end
				


				--*******************************************************************************************
				--震荡波
				elseif abilityName =="zdb" then 
					if randomValue == "baseDamage" then
						if caster.zdb_baseDamage == nil then
							caster.zdb_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))*5
						caster.zdb_baseDamage = caster.zdb_baseDamage + z
						netTable["zdb_baseDamage"] = caster.zdb_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						 return nil
					elseif randomValue == "damage" then
						if caster.zdb_damage == nil then
							caster.zdb_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z*2))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.zdb_damage = caster.zdb_damage + z
						netTable["zdb_damage"] = caster.zdb_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						 return nil
					elseif randomValue == "radius" then
						if caster.zdb_radius == nil then
							caster.zdb_radius = 0
						end
						z = math.ceil(RandomInt(10,z)/2)
						caster.zdb_radius = caster.zdb_radius + z
						netTable["zdb_radius"] = caster.zdb_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "distance" then
						if caster.zdb_distance == nil then
							caster.zdb_distance = 0
						end
						z = RandomInt(10,z)
						caster.zdb_distance = caster.zdb_distance + z
						netTable["zdb_distance"] = caster.zdb_distance
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_distance",{value=tostring(z)}}},3,"#ADFF2F") 
					    return nil	
					elseif randomValue == "max" then
						if caster.zdb_max == nil then
							caster.zdb_max = 0
						end
						z = 0.5
						caster.zdb_max = caster.zdb_max + z
						netTable["zdb_max"] = caster.zdb_max
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_max",{value=tostring(z)}}},3,"#ADFF2F") 
					    return nil	
					elseif randomValue == "time" then
						if caster.zdb_time == nil then
							caster.zdb_time = 0
						end
						z = RandomInt(1,z)
						caster.zdb_time = caster.zdb_time + z
						netTable["zdb_time"] = caster.zdb_time
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_time",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "multiple" then
						if caster.zdb_multiple == nil then
							caster.zdb_multiple = 0
						end
						z = RandomInt(1,z)
						caster.zdb_multiple = caster.zdb_multiple + z
						netTable["zdb_multiple"] = caster.zdb_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					     NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F") 
					    return nil	
					end
				




				--*******************************************************************************************
				--力之粉碎 
				elseif abilityName =="lzfs" then 
					if randomValue == "baseDamage" then
						if caster.lzfs_baseDamage == nil then
							caster.lzfs_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5)) *1.5
						caster.lzfs_baseDamage = caster.lzfs_baseDamage + z
						netTable["lzfs_baseDamage"] = caster.lzfs_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.lzfs_damage == nil then
							caster.lzfs_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.2,z*1.7))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.lzfs_damage = caster.lzfs_damage + z
						netTable["lzfs_damage"] = caster.lzfs_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F") 
						return nil
					elseif randomValue == "radius" then
						if caster.lzfs_radius == nil then
							caster.lzfs_radius = 0
						end
						z = RandomInt(1,z/2)
						caster.lzfs_radius = caster.lzfs_radius + z
						netTable["lzfs_radius"] = caster.lzfs_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "chance" then
						if caster.lzfs_chance == nil then
							caster.lzfs_chance = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))
						caster.lzfs_chance = caster.lzfs_chance + z
						netTable["lzfs_chance"] = caster.lzfs_chance
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_chance",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "time" then
						if caster.lzfs_time == nil then
							caster.lzfs_time = 0
						end
						z = RandomInt(1,z)
						caster.lzfs_time = caster.lzfs_time + z
						netTable["lzfs_time"] = caster.lzfs_time
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					     NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_time",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "multiple" then
						if caster.lzfs_multiple == nil then
							caster.lzfs_multiple = 0
						end
						z = RandomInt(1,z)
						caster.lzfs_multiple = caster.lzfs_multiple + z
						netTable["lzfs_multiple"] = caster.lzfs_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					     NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					end
				

				--*******************************************************************************************
				--反击螺旋 
				elseif abilityName =="fjlx" then 
					if randomValue == "baseDamage" then
						if caster.fjlx_baseDamage == nil then
							caster.fjlx_baseDamage = 0
						end
						z = RandomInt(z,z*4) * (0.5+(Stage.wave*0.5))
						caster.fjlx_baseDamage = caster.fjlx_baseDamage + z
						netTable["fjlx_baseDamage"] = caster.fjlx_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F") 
						return nil
					elseif randomValue == "damage" then
						if caster.fjlx_damage == nil then
							caster.fjlx_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.4,z*4))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.fjlx_damage = caster.fjlx_damage + z
						netTable["fjlx_damage"] = caster.fjlx_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "radius" then
						if caster.fjlx_radius == nil then
							caster.fjlx_radius = 0
						end
						z = RandomInt(10,z)
						caster.fjlx_radius = caster.fjlx_radius + z
						netTable["fjlx_radius"] = caster.fjlx_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "chance" then
						if caster.fjlx_chance == nil then
							caster.fjlx_chance = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))
						caster.fjlx_chance = caster.fjlx_chance + z
						netTable["fjlx_chance"] = caster.fjlx_chance
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_chance",{value=tostring(z)}}},3,"#ADFF2F")   
					    return nil	
					elseif randomValue == "multiple" then
						if caster.fjlx_multiple == nil then
							caster.fjlx_multiple = 0
						end
						z = RandomInt(1,z)
						caster.fjlx_multiple = caster.fjlx_multiple + z
						netTable["fjlx_multiple"] = caster.fjlx_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					     NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					end
							


				--*******************************************************************************************
				--刺针扫射 
				elseif abilityName =="czss" then 
					if randomValue == "baseDamage" then
						if caster.czss_baseDamage == nil then
							caster.czss_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))*3
						caster.czss_baseDamage = caster.czss_baseDamage + z
						netTable["czss_baseDamage"] = caster.czss_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						 return nil
					elseif randomValue == "damage" then
						if caster.czss_damage == nil then
							caster.czss_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.2,z))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.czss_damage = caster.czss_damage + z
						netTable["czss_damage"] = caster.czss_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F") 
						return nil
					elseif randomValue == "radius" then
						if caster.czss_radius == nil then
							caster.czss_radius = 0
						end
						z = RandomInt(10,z)
						caster.czss_radius = caster.czss_radius + z
						netTable["czss_radius"] = caster.czss_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "multiple" then
						if caster.czss_multiple == nil then
							caster.czss_multiple = 0
						end
						z = RandomInt(1,z)
						caster.czss_multiple = caster.czss_multiple + z
						netTable["czss_multiple"] = caster.czss_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
					


				--*******************************************************************************************
				--酸性喷雾
				elseif abilityName =="sxpw" then 
					if randomValue == "baseDamage" then
						if caster.sxpw_baseDamage == nil then
							caster.sxpw_baseDamage = 0
						end
						z = RandomInt(z,z*2) * (0.5+(Stage.wave*0.5))
						caster.sxpw_baseDamage = caster.sxpw_baseDamage + z
						netTable["sxpw_baseDamage"] = caster.sxpw_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.sxpw_damage == nil then
							caster.sxpw_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z*2))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.sxpw_damage = caster.sxpw_damage + z
						netTable["sxpw_damage"] = caster.sxpw_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "radius" then
						if caster.sxpw_radius == nil then
							caster.sxpw_radius = 0
						end
						z = RandomInt(10,z)
						caster.sxpw_radius = caster.sxpw_radius + z
						netTable["sxpw_radius"] = caster.sxpw_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "multiple" then
						if caster.sxpw_multiple == nil then
							caster.sxpw_multiple = 0
						end
						z = RandomInt(1,z)
						caster.sxpw_multiple = caster.sxpw_multiple + z
						netTable["sxpw_multiple"] = caster.sxpw_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
						


				--*******************************************************************************************
				--天国恩赐
				elseif abilityName =="tgec" then 
					if randomValue == "baseHeal" then
						if caster.tgec_baseHeal == nil then
							caster.tgec_baseHeal = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))
						caster.tgec_baseHeal = caster.tgec_baseHeal + z
						netTable["tgec_baseHeal"] = caster.tgec_baseHeal
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseHeal",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "heal" then
						if caster.tgec_heal == nil then
							caster.tgec_heal = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.tgec_heal = caster.tgec_heal + z
						netTable["tgec_heal"] = caster.tgec_heal
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_heal",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "duration" then
						if caster.tgec_duration == nil then
							caster.tgec_duration = 0
						end
						z = RandomInt(1,z)
						caster.tgec_duration = caster.tgec_duration + z
						netTable["tgec_duration"] = caster.tgec_duration
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_duration",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					end	
							


				--*******************************************************************************************
				--旋风飞斧
				elseif abilityName =="xfff" then 
					if randomValue == "baseDamage" then
						if caster.xfff_baseDamage == nil then
							caster.xfff_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))
						caster.xfff_baseDamage = caster.xfff_baseDamage + z
						netTable["xfff_baseDamage"] = caster.xfff_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.xfff_damage == nil then
							caster.xfff_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.xfff_damage = caster.xfff_damage + z
						netTable["xfff_damage"] = caster.xfff_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "radius" then
						if caster.xfff_radius == nil then
							caster.xfff_radius = 0
						end
						z = RandomInt(10,z)
						caster.xfff_radius = caster.xfff_radius + z
						netTable["xfff_radius"] = caster.xfff_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						 return nil
					elseif randomValue == "distance" then
						if caster.xfff_distance == nil then
							caster.xfff_distance = 0
						end
						z = RandomInt(10,z)
						caster.xfff_distance = caster.xfff_distance + z
						netTable["xfff_distance"] = caster.xfff_distance
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					  	 NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_distance",{value=tostring(z)}}},3,"#ADFF2F") 
					     return nil	
					elseif randomValue == "max" then
						if caster.xfff_max == nil then
							caster.xfff_max = 0
						end
						z = RandomInt(1,z)
						caster.xfff_max = caster.xfff_max + z
						netTable["xfff_max"] = caster.xfff_max
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_max",{value=tostring(z)}}},3,"#ADFF2F") 
					     return nil	
					elseif randomValue == "time" then
						if caster.xfff_time == nil then
							caster.xfff_time = 0
						end
						z = RandomInt(1,z)
						caster.xfff_time = caster.xfff_time + z
						netTable["xfff_time"] = caster.xfff_time
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_time",{value=tostring(z)}}},3,"#ADFF2F")
					     return nil	
					elseif randomValue == "multiple" then
						if caster.xfff_multiple == nil then
							caster.xfff_multiple = 0
						end
						z = RandomInt(1,z)
						caster.xfff_multiple = caster.xfff_multiple + z
						netTable["xfff_multiple"] = caster.xfff_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				



				--*******************************************************************************************
				--剑刃风暴
				elseif abilityName =="jrfb" then 
					if randomValue == "baseDamage" then
						if caster.jrfb_baseDamage == nil then
							caster.jrfb_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5)) 
						caster.jrfb_baseDamage = caster.jrfb_baseDamage + z
						netTable["jrfb_baseDamage"] = caster.jrfb_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.jrfb_damage == nil then
							caster.jrfb_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z/6))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.jrfb_damage = caster.jrfb_damage + z
						netTable["jrfb_damage"] = caster.jrfb_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "radius" then
						if caster.jrfb_radius == nil then
							caster.jrfb_radius = 0
						end
						z = RandomInt(10,z)
						caster.jrfb_radius = caster.jrfb_radius + z
						netTable["jrfb_radius"] = caster.jrfb_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F") 
						return nil
					elseif randomValue == "duration" then
						if caster.jrfb_duration == nil then
							caster.jrfb_duration = 0
						end
						z = RandomInt(1,z)
						caster.jrfb_duration = caster.jrfb_duration + z
						netTable["jrfb_duration"] = caster.jrfb_duration
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_duration",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "interval" then
						if caster.jrfb_interval == nil then
							caster.jrfb_interval = 0
						end
						z = 0.02
						caster.jrfb_interval = caster.jrfb_interval + z
						netTable["jrfb_interval"] = caster.jrfb_interval
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					     NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_interval",{value=tostring(z)}}},3,"#ADFF2F")  
					    return nil	
					elseif randomValue == "multiple" then
						if caster.jrfb_multiple == nil then
							caster.jrfb_multiple = 0
						end
						z = RandomInt(1,z)
						caster.jrfb_multiple = caster.jrfb_multiple + z
						netTable["jrfb_multiple"] = caster.jrfb_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				



				--*******************************************************************************************
				--瞬斩
				elseif abilityName =="sz" then 
					if randomValue == "baseDamage" then
						if caster.sz_baseDamage == nil then
							caster.sz_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5)) / 5 
						z= string.format("%.2f",z)
						caster.sz_baseDamage = caster.sz_baseDamage + z
						netTable["sz_baseDamage"] = caster.sz_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.sz_damage == nil then
							caster.sz_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z)/ 5) 		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.sz_damage = caster.sz_damage + z
						netTable["sz_damage"] = caster.sz_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")   
						return nil
					elseif randomValue == "radius" then
						if caster.sz_radius == nil then
							caster.sz_radius = 0
						end
						z = RandomInt(10,z)
						caster.sz_radius = caster.sz_radius + z
						netTable["sz_radius"] = caster.sz_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "distance" then
						if caster.sz_distance == nil then
							caster.sz_distance = 0
						end
						z = RandomInt(10,z)
						caster.sz_distance = caster.sz_distance + z
						netTable["sz_distance"] = caster.sz_distance
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_distance",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "count" then
						if caster.sz_count == nil then
							caster.sz_count = 0
						end
						z = RandomInt(1,z)
						caster.sz_count = caster.sz_count + z
						netTable["sz_count"] = caster.sz_count
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_count",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "multiple" then
						if caster.sz_multiple == nil then
							caster.sz_multiple = 0
						end
						z = RandomInt(1,z)
						caster.sz_multiple = caster.sz_multiple + z
						netTable["sz_multiple"] = caster.sz_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				



				--*******************************************************************************************
				--飞星
				elseif abilityName =="fx" then 
					if randomValue == "baseDamage" then
						if caster.fx_baseDamage == nil then
							caster.fx_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))
						caster.fx_baseDamage = caster.fx_baseDamage + z
						netTable["fx_baseDamage"] = caster.fx_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						 return nil
					elseif randomValue == "damage" then
						if caster.fx_damage == nil then
							caster.fx_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.fx_damage = caster.fx_damage + z
						netTable["fx_damage"] = caster.fx_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "radius" then
						if caster.fx_radius == nil then
							caster.fx_radius = 0
						end
						z = RandomInt(10,z)
						caster.fx_radius = caster.fx_radius + z
						netTable["fx_radius"] = caster.fx_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "chance" then
						if caster.fx_chance == nil then
							caster.fx_chance = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))
						caster.fx_chance = caster.fx_chance + z
						netTable["fx_chance"] = caster.fx_chance
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_chance",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "distance" then
						if caster.fx_distance == nil then
							caster.fx_distance = 0
						end
						z = RandomInt(10,z)
						caster.fx_distance = caster.fx_distance + z
						netTable["fx_distance"] = caster.fx_distance
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_distance",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "max" then
						if caster.fx_max == nil then
							caster.fx_max = 0
						end
						z = RandomInt(1,z)
						caster.fx_max = caster.fx_max + z
						netTable["fx_max"] = caster.fx_max
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					     NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_max",{value=tostring(z)}}},3,"#ADFF2F") 
					    return nil	
					elseif randomValue == "time" then
						if caster.fx_time == nil then
							caster.fx_time = 0
						end
						z = RandomInt(1,z)
						caster.fx_time = caster.fx_time + z
						netTable["fx_time"] = caster.fx_time
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_time",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "multiple" then
						if caster.fx_multiple == nil then
							caster.fx_multiple = 0
						end
						z = RandomInt(1,z)
						caster.fx_multiple = caster.fx_multiple + z
						netTable["fx_multiple"] = caster.fx_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				



				--*******************************************************************************************
				--穿云箭
				elseif abilityName =="cyj" then 
					if randomValue == "baseDamage" then
						if caster.cyj_baseDamage == nil then
							caster.cyj_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5)) /2
						caster.cyj_baseDamage = caster.cyj_baseDamage + z
						netTable["cyj_baseDamage"] = caster.cyj_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.cyj_damage == nil then
							caster.cyj_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z)/2)		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.cyj_damage = caster.cyj_damage + z
						netTable["cyj_damage"] = caster.cyj_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "radius" then
						if caster.cyj_radius == nil then
							caster.cyj_radius = 0
						end
						z = RandomInt(10,z)
						caster.cyj_radius = caster.cyj_radius + z
						netTable["cyj_radius"] = caster.cyj_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")  
						return nil
					elseif randomValue == "distance" then
						if caster.cyj_distance == nil then
							caster.cyj_distance = 0
						end
						z = RandomInt(10,z)
						caster.cyj_distance = caster.cyj_distance + z
						netTable["cyj_distance"] = caster.cyj_distance
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_distance",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "count" then
						if caster.cyj_count == nil then
							caster.cyj_count = 0
						end
						z = RandomInt(1,z)
						caster.cyj_count = caster.cyj_count + z
						netTable["cyj_count"] = caster.cyj_count
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					     NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_count",{value=tostring(z)}}},3,"#ADFF2F") 
					    return nil	
					elseif randomValue == "time" then
						if caster.cyj_time == nil then
							caster.cyj_time = 0
						end
						z = RandomInt(1,z)
						caster.cyj_time = caster.cyj_time + z
						netTable["cyj_time"] = caster.cyj_time
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_time",{value=tostring(z)}}},3,"#ADFF2F")
					     return nil	
					elseif randomValue == "multiple" then
						if caster.cyj_multiple == nil then
							caster.cyj_multiple = 0
						end
						z = RandomInt(1,z)
						caster.cyj_multiple = caster.cyj_multiple + z
						netTable["cyj_multiple"] = caster.cyj_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				


				--*******************************************************************************************
				--爆裂攻击 
				elseif abilityName =="blgj" then 
					if randomValue == "baseDamage" then
						if caster.blgj_baseDamage == nil then
							caster.blgj_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))
						caster.blgj_baseDamage = caster.blgj_baseDamage + z
						netTable["blgj_baseDamage"] = caster.blgj_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.blgj_damage == nil then
							caster.blgj_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.2,z*1.35))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.blgj_damage = caster.blgj_damage + z
						netTable["blgj_damage"] = caster.blgj_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "radius" then
						if caster.blgj_radius == nil then
							caster.blgj_radius = 0
						end
						z = RandomInt(1,z/2)
						caster.blgj_radius = caster.blgj_radius + z
						netTable["blgj_radius"] = caster.blgj_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "chance" then
						if caster.blgj_chance == nil then
							caster.blgj_chance = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))
						caster.blgj_chance = caster.blgj_chance + z
						netTable["blgj_chance"] = caster.blgj_chance
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_chance",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "time" then
						if caster.blgj_time == nil then
							caster.blgj_time = 0
						end
						z = RandomInt(1,z)
						caster.blgj_time = caster.blgj_time + z
						netTable["blgj_time"] = caster.blgj_time
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_time",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "multiple" then
						if caster.blgj_multiple == nil then
							caster.blgj_multiple = 0
						end
						z = RandomInt(1,z)
						caster.blgj_multiple = caster.blgj_multiple + z
						netTable["blgj_multiple"] = caster.blgj_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				



				--*******************************************************************************************
				--御剑诀
				elseif abilityName =="yjj" then 
					if randomValue == "baseDamage" then
						if caster.yjj_baseDamage == nil then
							caster.yjj_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))
						caster.yjj_baseDamage = caster.yjj_baseDamage + z
						netTable["yjj_baseDamage"] = caster.yjj_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.yjj_damage == nil then
							caster.yjj_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.yjj_damage = caster.yjj_damage + z
						netTable["yjj_damage"] = caster.yjj_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "radius" then
						if caster.yjj_radius == nil then
							caster.yjj_radius = 0
						end
						z = RandomInt(10,z)
						caster.yjj_radius = caster.yjj_radius + z
						netTable["yjj_radius"] = caster.yjj_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "distance" then
						if caster.yjj_distance == nil then
							caster.yjj_distance = 0
						end
						z = RandomInt(10,z)
						caster.yjj_distance = caster.yjj_distance + z
						netTable["yjj_distance"] = caster.yjj_distance
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_distance",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "max" then
						if caster.yjj_max == nil then
							caster.yjj_max = 0
						end
						z = RandomInt(1,z)
						caster.yjj_max = caster.yjj_max + z
						netTable["yjj_max"] = caster.yjj_max
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					     NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_max",{value=tostring(z)}}},3,"#ADFF2F") 
					    return nil	
					elseif randomValue == "time" then
						if caster.yjj_time == nil then
							caster.yjj_time = 0
						end
						z = RandomInt(1,z)
						caster.yjj_time = caster.yjj_time + z
						netTable["yjj_time"] = caster.yjj_time
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_time",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "multiple" then
						if caster.yjj_multiple == nil then
							caster.yjj_multiple = 0
						end
						z = RandomInt(1,z)
						caster.yjj_multiple = caster.yjj_multiple + z
						netTable["yjj_multiple"] = caster.yjj_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				end



				--*******************************************************************************************
				--寒霜剑气
				if abilityName =="hsjq" then 
					if randomValue == "baseDamage" then
						if caster.hsjq_baseDamage == nil then
							caster.hsjq_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))*5
						caster.hsjq_baseDamage = caster.hsjq_baseDamage + z
						netTable["hsjq_baseDamage"] = caster.hsjq_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						 return nil
					elseif randomValue == "damage" then
						if caster.hsjq_damage == nil then
							caster.hsjq_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.5,z*5))	--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.hsjq_damage = caster.hsjq_damage + z
						netTable["hsjq_damage"] = caster.hsjq_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						 return nil
					elseif randomValue == "radius" then
						if caster.hsjq_radius == nil then
							caster.hsjq_radius = 0
						end
						z = RandomInt(10,z)
						caster.hsjq_radius = caster.hsjq_radius + z
						netTable["hsjq_radius"] = caster.hsjq_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "distance" then
						if caster.hsjq_distance == nil then
							caster.hsjq_distance = 0
						end
						z = RandomInt(10,z)
						caster.hsjq_distance = caster.hsjq_distance + z
						netTable["hsjq_distance"] = caster.hsjq_distance
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_distance",{value=tostring(z)}}},3,"#ADFF2F")
					     return nil	
					elseif randomValue == "time" then
						if caster.hsjq_time == nil then
							caster.hsjq_time = 0
						end
						z = RandomInt(1,z)
						caster.hsjq_time = caster.hsjq_time + z
						netTable["hsjq_time"] = caster.hsjq_time
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_time",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "multiple" then
						if caster.hsjq_multiple == nil then
							caster.hsjq_multiple = 0
						end
						z = RandomInt(1,z)
						caster.hsjq_multiple = caster.hsjq_multiple + z
						netTable["hsjq_multiple"] = caster.hsjq_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				


				--*******************************************************************************************
				--霜天雪舞
				elseif abilityName =="stxw" then 
					if randomValue == "baseDamage" then
						if caster.stxw_baseDamage == nil then
							caster.stxw_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5)) 
						caster.stxw_baseDamage = caster.stxw_baseDamage + z
						netTable["stxw_baseDamage"] = caster.stxw_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.stxw_damage == nil then
							caster.stxw_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.stxw_damage = caster.stxw_damage + z
						netTable["stxw_damage"] = caster.stxw_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						 return nil
					elseif randomValue == "radius" then
						if caster.stxw_radius == nil then
							caster.stxw_radius = 0
						end
						z = RandomInt(10,z)
						caster.stxw_radius = caster.stxw_radius + z
						netTable["stxw_radius"] = caster.stxw_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "duration" then
						if caster.stxw_duration == nil then
							caster.stxw_duration = 0
						end
						z = string.format("%.2f",RandomFloat(0.5,z))
						caster.stxw_duration = caster.stxw_duration + z
						netTable["stxw_duration"] = caster.stxw_duration
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_duration",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "count" then
						if caster.stxw_count == nil then
							caster.stxw_count = 0
						end
						z = RandomInt(1,z)
						caster.stxw_count = caster.stxw_count + z
						netTable["stxw_count"] = caster.stxw_count
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_count",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "multiple" then
						if caster.stxw_multiple == nil then
							caster.stxw_multiple = 0
						end
						z = RandomInt(1,z)
						caster.stxw_multiple = caster.stxw_multiple + z
						netTable["stxw_multiple"] = caster.stxw_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					  NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				



				--*******************************************************************************************
				--剔骨
				elseif abilityName =="tg" then 
					if randomValue == "baseDamage" then
						if caster.tg_baseDamage == nil then
							caster.tg_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))*6
						caster.tg_baseDamage = caster.tg_baseDamage + z
						netTable["tg_baseDamage"] = caster.tg_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.tg_damage == nil then
							caster.tg_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.6,z*6))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.tg_damage = caster.tg_damage + z
						netTable["tg_damage"] = caster.tg_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")   
						return nil
					elseif randomValue == "radius" then
						if caster.tg_radius == nil then
							caster.tg_radius = 0
						end
						z = RandomInt(10,z)
						caster.tg_radius = caster.tg_radius + z
						netTable["tg_radius"] = caster.tg_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "multiple" then
						if caster.tg_multiple == nil then
							caster.tg_multiple = 0
						end
						z = RandomInt(1,z)
						caster.tg_multiple = caster.tg_multiple + z
						netTable["tg_multiple"] = caster.tg_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				


				--*******************************************************************************************
				--死亡绞杀
				elseif abilityName =="swjs" then 
					if randomValue == "baseDamage" then
						if caster.swjs_baseDamage == nil then
							caster.swjs_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))*8
						caster.swjs_baseDamage = caster.swjs_baseDamage + z
						netTable["swjs_baseDamage"] = caster.swjs_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.swjs_damage == nil then
							caster.swjs_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.6,z*6))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.swjs_damage = caster.swjs_damage + z
						netTable["swjs_damage"] = caster.swjs_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "radius" then
						if caster.swjs_radius == nil then
							caster.swjs_radius = 0
						end
						z = RandomInt(10,z)
						caster.swjs_radius = caster.swjs_radius + z
						netTable["swjs_radius"] = caster.swjs_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "multiple" then
						if caster.swjs_multiple == nil then
							caster.swjs_multiple = 0
						end
						z = RandomInt(1,z)
						caster.swjs_multiple = caster.swjs_multiple + z
						netTable["swjs_multiple"] = caster.swjs_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				


				--*******************************************************************************************
				--妖邪之火
				elseif abilityName =="yxzh" then 
					if randomValue == "baseDamage" then
						if caster.yxzh_baseDamage == nil then
							caster.yxzh_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))*2
						caster.yxzh_baseDamage = caster.yxzh_baseDamage + z
						netTable["yxzh_baseDamage"] = caster.yxzh_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.yxzh_damage == nil then
							caster.yxzh_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.2,z*2))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.yxzh_damage = caster.yxzh_damage + z
						netTable["yxzh_damage"] = caster.yxzh_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "radius" then
						if caster.yxzh_radius == nil then
							caster.yxzh_radius = 0
						end
						z = RandomInt(10,z)
						caster.yxzh_radius = caster.yxzh_radius + z
						netTable["yxzh_radius"] = caster.yxzh_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "distance" then
						if caster.yxzh_distance == nil then
							caster.yxzh_distance = 0
						end
						z = RandomInt(10,z)
						caster.yxzh_distance = caster.yxzh_distance + z
						netTable["yxzh_distance"] = caster.yxzh_distance
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_distance",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "time" then
						if caster.yxzh_time == nil then
							caster.yxzh_time = 0
						end
						z = RandomInt(1,z)
						caster.yxzh_time = caster.yxzh_time + z
						netTable["yxzh_time"] = caster.yxzh_time
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_time",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "multiple" then
						if caster.yxzh_multiple == nil then
							caster.yxzh_multiple = 0
						end
						z = RandomInt(1,z)
						caster.yxzh_multiple = caster.yxzh_multiple + z
						netTable["yxzh_multiple"] = caster.yxzh_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				


				--*******************************************************************************************
				--地穴虫群
				elseif abilityName =="dxcq" then 
					if randomValue == "baseDamage" then
						if caster.dxcq_baseDamage == nil then
							caster.dxcq_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))
						caster.dxcq_baseDamage = caster.dxcq_baseDamage + z
						netTable["dxcq_baseDamage"] = caster.dxcq_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.dxcq_damage == nil then
							caster.dxcq_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.dxcq_damage = caster.dxcq_damage + z
						netTable["dxcq_damage"] = caster.dxcq_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "radius" then
						if caster.dxcq_radius == nil then
							caster.dxcq_radius = 0
						end
						z = RandomInt(10,z)
						caster.dxcq_radius = caster.dxcq_radius + z
						netTable["dxcq_radius"] = caster.dxcq_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "distance" then
						if caster.dxcq_distance == nil then
							caster.dxcq_distance = 0
						end
						z = RandomInt(10,z)
						caster.dxcq_distance = caster.dxcq_distance + z
						netTable["dxcq_distance"] = caster.dxcq_distance
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_distance",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "max" then
						if caster.dxcq_max == nil then
							caster.dxcq_max = 0
						end
						z = RandomInt(1,z)
						caster.dxcq_max = caster.dxcq_max + z
						netTable["dxcq_max"] = caster.dxcq_max
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_max",{value=tostring(z)}}},3,"#ADFF2F") 
					    return nil	
					elseif randomValue == "time" then
						if caster.dxcq_time == nil then
							caster.dxcq_time = 0
						end
						z = RandomInt(1,z)
						caster.dxcq_time = caster.dxcq_time + z
						netTable["dxcq_time"] = caster.dxcq_time
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_time",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "multiple" then
						if caster.dxcq_multiple == nil then
							caster.dxcq_multiple = 0
						end
						z = RandomInt(1,z)
						caster.dxcq_multiple = caster.dxcq_multiple + z
						netTable["dxcq_multiple"] = caster.dxcq_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				


				--*******************************************************************************************
				--龙破斩
				elseif abilityName =="lpz" then 
					if randomValue == "baseDamage" then
						if caster.lpz_baseDamage == nil then
							caster.lpz_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))*2.4
						caster.lpz_baseDamage = caster.lpz_baseDamage + z
						netTable["lpz_baseDamage"] = caster.lpz_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.lpz_damage == nil then
							caster.lpz_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z*2.4))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.lpz_damage = caster.lpz_damage + z
						netTable["lpz_damage"] = caster.lpz_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "radius" then
						if caster.lpz_radius == nil then
							caster.lpz_radius = 0
						end
						z = math.ceil(RandomInt(10,z)/5)
						caster.lpz_radius = caster.lpz_radius + z
						netTable["lpz_radius"] = caster.lpz_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "distance" then
						if caster.lpz_distance == nil then
							caster.lpz_distance = 0
						end
						z = RandomInt(10,z)/2
						caster.lpz_distance = caster.lpz_distance + z
						netTable["lpz_distance"] = caster.lpz_distance
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_distance",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "max" then
						if caster.lpz_max == nil then
							caster.lpz_max = 0
						end
						z = 0.5
						caster.lpz_max = caster.lpz_max + z
						netTable["lpz_max"] = caster.lpz_max
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_max",{value=tostring(z)}}},3,"#ADFF2F") 
					    return nil	
					elseif randomValue == "time" then
						if caster.lpz_time == nil then
							caster.lpz_time = 0
						end
						z = RandomInt(1,z)
						caster.lpz_time = caster.lpz_time + z
						netTable["lpz_time"] = caster.lpz_time
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_time",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "multiple" then
						if caster.lpz_multiple == nil then
							caster.lpz_multiple = 0
						end
						z = RandomInt(1,z)
						caster.lpz_multiple = caster.lpz_multiple + z
						netTable["lpz_multiple"] = caster.lpz_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
							


				--*******************************************************************************************
				--天玄焚火
				elseif abilityName =="txfh" then 
					if randomValue == "baseDamage" then
						if caster.txfh_baseDamage == nil then
							caster.txfh_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))*8
						caster.txfh_baseDamage = caster.txfh_baseDamage + z
						netTable["txfh_baseDamage"] = caster.txfh_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.txfh_damage == nil then
							caster.txfh_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.4,z*4))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.txfh_damage = caster.txfh_damage + z
						netTable["txfh_damage"] = caster.txfh_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "radius" then
						if caster.txfh_radius == nil then
							caster.txfh_radius = 0
						end
						z = RandomInt(10,z)
						caster.txfh_radius = caster.txfh_radius + z
						netTable["txfh_radius"] = caster.txfh_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "time" then
						if caster.txfh_time == nil then
							caster.txfh_time = 0
						end
						z = RandomInt(1,z)
						caster.txfh_time = caster.txfh_time + z
						netTable["txfh_time"] = caster.txfh_time
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_time",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "multiple" then
						if caster.txfh_multiple == nil then
							caster.txfh_multiple = 0
						end
						z = RandomInt(1,z)
						caster.txfh_multiple = caster.txfh_multiple + z
						netTable["txfh_multiple"] = caster.txfh_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				


				--*******************************************************************************************
				--光击阵
				elseif abilityName =="gjz" then 
					if randomValue == "baseDamage" then
						if caster.gjz_baseDamage == nil then
							caster.gjz_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))*4
						caster.gjz_baseDamage = caster.gjz_baseDamage + z
						netTable["gjz_baseDamage"] = caster.gjz_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.gjz_damage == nil then
							caster.gjz_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))*4		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.gjz_damage = caster.gjz_damage + z
						netTable["gjz_damage"] = caster.gjz_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "radius" then
						if caster.gjz_radius == nil then
							caster.gjz_radius = 0
						end
						z = RandomInt(1,z/2)
						caster.gjz_radius = caster.gjz_radius + z
						netTable["gjz_radius"] = caster.gjz_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "duration" then
						if caster.gjz_duration == nil then
							caster.gjz_duration = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))
						caster.gjz_duration = caster.gjz_duration + z
						netTable["gjz_duration"] = caster.gjz_duration
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_duration",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "time" then
						if caster.gjz_time == nil then
							caster.gjz_time = 0
						end
						z = RandomInt(1,z)
						caster.gjz_time = caster.gjz_time + z
						netTable["gjz_time"] = caster.gjz_time
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_time",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "multiple" then
						if caster.gjz_multiple == nil then
							caster.gjz_multiple = 0
						end
						z = RandomInt(1,z)
						caster.gjz_multiple = caster.gjz_multiple + z
						netTable["gjz_multiple"] = caster.gjz_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					end
				


				--*******************************************************************************************
				--痛苦尖叫
				elseif abilityName =="tkjj" then 
					if randomValue == "baseDamage" then
						if caster.tkjj_baseDamage == nil then
							caster.tkjj_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))*3
						caster.tkjj_baseDamage = caster.tkjj_baseDamage + z
						netTable["tkjj_baseDamage"] = caster.tkjj_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.tkjj_damage == nil then
							caster.tkjj_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))*3		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.tkjj_damage = caster.tkjj_damage + z
						netTable["tkjj_damage"] = caster.tkjj_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "radius" then
						if caster.tkjj_radius == nil then
							caster.tkjj_radius = 0
						end
						z = RandomInt(10,z)
						caster.tkjj_radius = caster.tkjj_radius + z
						netTable["tkjj_radius"] = caster.tkjj_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "multiple" then
						if caster.txjj_multiple == nil then
							caster.txjj_multiple = 0
						end
						z = RandomInt(1,z)
						caster.txjj_multiple = caster.txjj_multiple + z
						netTable["txjj_multiple"] = caster.txjj_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				


				--*******************************************************************************************
				--冰霜新星
				elseif abilityName =="bsxx" then 
					if randomValue == "baseDamage" then
						if caster.bsxx_baseDamage == nil then
							caster.bsxx_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))*4
						caster.bsxx_baseDamage = caster.bsxx_baseDamage + z
						netTable["bsxx_baseDamage"] = caster.bsxx_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.bsxx_damage == nil then
							caster.bsxx_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.3,z*3))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.bsxx_damage = caster.bsxx_damage + z
						netTable["bsxx_damage"] = caster.bsxx_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "radius" then
						if caster.bsxx_radius == nil then
							caster.bsxx_radius = 0
						end
						z = RandomInt(10,z)
						caster.bsxx_radius = caster.bsxx_radius + z
						netTable["bsxx_radius"] = caster.bsxx_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "duration" then
						if caster.bsxx_duration == nil then
							caster.bsxx_duration = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))
						caster.bsxx_duration = caster.bsxx_duration + z
						netTable["bsxx_duration"] = caster.bsxx_duration
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_duration",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "time" then
						if caster.bsxx_time == nil then
							caster.bsxx_time = 0
						end
						z = RandomInt(1,z)
						caster.bsxx_time = caster.bsxx_time + z
						netTable["bsxx_time"] = caster.bsxx_time
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_time",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "multiple" then
						if caster.bsxx_multiple == nil then
							caster.bsxx_multiple = 0
						end
						z = RandomInt(1,z)
						caster.bsxx_multiple = caster.bsxx_multiple + z
						netTable["bsxx_multiple"] = caster.bsxx_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				


				--*******************************************************************************************
				--苍穹震击
				elseif abilityName =="cqzj" then 
					if randomValue == "baseDamage" then
						if caster.cqzj_baseDamage == nil then
							caster.cqzj_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))
						caster.cqzj_baseDamage = caster.cqzj_baseDamage + z
						netTable["cqzj_baseDamage"] = caster.cqzj_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.cqzj_damage == nil then
							caster.cqzj_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.cqzj_damage = caster.cqzj_damage + z
						netTable["cqzj_damage"] = caster.cqzj_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "max" then
						if caster.cqzj_max == nil then
							caster.cqzj_max = 0
						end
						z = RandomInt(1,z)
						caster.cqzj_max = caster.cqzj_max + z
						netTable["cqzj_max"] = caster.cqzj_max
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					     NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_max",{value=tostring(z)}}},3,"#ADFF2F") 
					    return nil	
					elseif randomValue == "multiple" then
						if caster.cqzj_multiple == nil then
							caster.cqzj_multiple = 0
						end
						z = RandomInt(1,z)
						caster.cqzj_multiple = caster.cqzj_multiple + z
						netTable["cqzj_multiple"] = caster.cqzj_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
						


				--*******************************************************************************************
				--连锁闪电
				elseif abilityName =="lssd" then 
					if randomValue == "baseDamage" then
						if caster.lssd_baseDamage == nil then
							caster.lssd_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))
						caster.lssd_baseDamage = caster.lssd_baseDamage + z
						netTable["lssd_baseDamage"] = caster.lssd_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.lssd_damage == nil then
							caster.lssd_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.lssd_damage = caster.lssd_damage + z
						netTable["lssd_damage"] = caster.lssd_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "max" then
						if caster.lssd_max == nil then
							caster.lssd_max = 0
						end
						z = RandomInt(1,z)
						caster.lssd_max = caster.lssd_max + z
						netTable["lssd_max"] = caster.lssd_max
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_max",{value=tostring(z)}}},3,"#ADFF2F") 
					    return nil	
					elseif randomValue == "multiple" then
						if caster.lssd_multiple == nil then
							caster.lssd_multiple = 0
						end
						z = RandomInt(1,z)
						caster.lssd_multiple = caster.lssd_multiple + z
						netTable["lssd_multiple"] = caster.lssd_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
					

				--*******************************************************************************************
				--死亡脉冲
				elseif abilityName =="swmc" then 
					if randomValue == "baseDamage" then
						if caster.swmc_baseDamage == nil then
							caster.swmc_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))*3
						caster.swmc_baseDamage = caster.swmc_baseDamage + z
						netTable["swmc_baseDamage"] = caster.swmc_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "baseHeal" then
						if caster.swmc_baseHeal == nil then
							caster.swmc_baseHeal = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))*3
						caster.swmc_baseHeal = caster.swmc_baseHeal + z
						netTable["swmc_baseHeal"] = caster.swmc_baseHeal
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseHeal",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "heal" then
						if caster.swmc_heal == nil then
							caster.swmc_heal = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))*3		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.swmc_heal = caster.swmc_heal + z
						netTable["swmc_heal"] = caster.swmc_heal
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_heal",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.swmc_damage == nil then
							caster.swmc_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))*3		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.swmc_damage = caster.swmc_damage + z
						netTable["swmc_damage"] = caster.swmc_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "radius" then
						if caster.swmc_radius == nil then
							caster.swmc_radius = 0
						end
						z = RandomInt(10,z)
						caster.swmc_radius = caster.swmc_radius + z
						netTable["swmc_radius"] = caster.swmc_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "multiple" then
						if caster.swmc_multiple == nil then
							caster.swmc_multiple = 0
						end
						z = RandomInt(1,z)
						caster.swmc_multiple = caster.swmc_multiple + z
						netTable["swmc_multiple"] = caster.swmc_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				


				--*******************************************************************************************
				--死亡之指
				elseif abilityName =="swzz" then 
					if randomValue == "baseDamage" then
						if caster.swzz_baseDamage == nil then
							caster.swzz_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))*8
						caster.swzz_baseDamage = caster.swzz_baseDamage + z
						netTable["swzz_baseDamage"] = caster.swzz_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.swzz_damage == nil then
							caster.swzz_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))*8		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.swzz_damage = caster.swzz_damage + z
						netTable["swzz_damage"] = caster.swzz_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "max" then
						if caster.swzz_max == nil then
							caster.swzz_max = 0
						end
						z = RandomInt(1,z)
						caster.swzz_max = caster.swzz_max + z
						netTable["swzz_max"] = caster.swzz_max
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_max",{value=tostring(z)}}},3,"#ADFF2F") 
					    return nil	
					elseif randomValue == "multiple" then
						if caster.swzz_multiple == nil then
							caster.swzz_multiple = 0
						end
						z = RandomInt(1,z)
						caster.swzz_multiple = caster.swzz_multiple + z
						netTable["swzz_multiple"] = caster.swzz_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				

				--*******************************************************************************************
				--唤星术
				elseif abilityName =="hxs" then 
					if randomValue == "baseDamage" then
						if caster.hxs_baseDamage == nil then
							caster.hxs_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))*5
						caster.hxs_baseDamage = caster.hxs_baseDamage + z
						netTable["hxs_baseDamage"] = caster.hxs_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.hxs_damage == nil then
							caster.hxs_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.4,z*4))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.hxs_damage = caster.hxs_damage + z
						netTable["hxs_damage"] = caster.hxs_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "max" then
						if caster.hxs_max == nil then
							caster.hxs_max = 0
						end
						z = RandomInt(1,z)
						caster.hxs_max = caster.hxs_max + z
						netTable["hxs_max"] = caster.hxs_max
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_max",{value=tostring(z)}}},3,"#ADFF2F") 
					    return nil	
					elseif randomValue == "multiple" then
						if caster.hxs_multiple == nil then
							caster.hxs_multiple = 0
						end
						z = RandomInt(1,z)
						caster.hxs_multiple = caster.hxs_multiple + z
						netTable["hxs_multiple"] = caster.hxs_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				


				--*******************************************************************************************
				--竭心光环
				elseif abilityName =="jxgh" then 
					if randomValue == "baseDamage" then
						if caster.jxgh_baseDamage == nil then
							caster.jxgh_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))/2
						caster.jxgh_baseDamage = caster.jxgh_baseDamage + z
						netTable["jxgh_baseDamage"] = caster.jxgh_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.jxgh_damage == nil then
							caster.jxgh_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.jxgh_damage = caster.jxgh_damage + z
						netTable["jxgh_damage"] = caster.jxgh_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "radius" then
						if caster.jxgh_radius == nil then
							caster.jxgh_radius = 0
						end
						z = RandomInt(10,z)		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.jxgh_radius = caster.jxgh_radius + z
						netTable["jxgh_radius"] = caster.jxgh_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "interval" then
						if caster.jxgh_interval == nil then
							caster.jxgh_interval = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))
						caster.jxgh_interval = caster.jxgh_interval + z
						netTable["jxgh_interval"] = caster.jxgh_interval
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_interval",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "multiple" then
						if caster.jxgh_multiple == nil then
							caster.jxgh_multiple = 0
						end
						z = RandomInt(1,z)
						caster.jxgh_multiple = caster.jxgh_multiple + z
						netTable["jxgh_multiple"] = caster.jxgh_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				

				--*******************************************************************************************
				--治愈光波
				elseif abilityName =="zygb" then 
					if randomValue == "baseHeal" then
						if caster.zygb_baseHeal == nil then
							caster.zygb_baseHeal = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))*4
						caster.zygb_baseHeal = caster.zygb_baseHeal + z
						netTable["zygb_baseHeal"] = caster.zygb_baseHeal
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseHeal",{value=tostring(z)}}},3,"#ADFF2F") 
						return nil
					elseif randomValue == "heal" then
						if caster.zygb_heal == nil then
							caster.zygb_heal = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.zygb_heal = caster.zygb_heal + z
						netTable["zygb_heal"] = caster.zygb_heal
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_heal",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					end
								


				--*******************************************************************************************
				--炫龙震天
				elseif abilityName =="xlzt" then 
					if randomValue == "baseDamage" then
						if caster.xlzt_baseDamage == nil then
							caster.xlzt_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))
						caster.xlzt_baseDamage = caster.xlzt_baseDamage + z
						netTable["xlzt_baseDamage"] = caster.xlzt_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.xlzt_damage == nil then
							caster.xlzt_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.xlzt_damage = caster.xlzt_damage + z
						netTable["xlzt_damage"] = caster.xlzt_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "radius" then
						if caster.xlzt_radius == nil then
							caster.xlzt_radius = 0
						end
						z = RandomInt(10,z)		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.xlzt_radius = caster.xlzt_radius + z
						netTable["xlzt_radius"] = caster.xlzt_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "multiple" then
						if caster.xlzt_multiple == nil then
							caster.xlzt_multiple = 0
						end
						z = RandomInt(1,z)
						caster.xlzt_multiple = caster.xlzt_multiple + z
						netTable["xlzt_multiple"] = caster.xlzt_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
					


				--*******************************************************************************************
				--死亡绽放
				elseif abilityName =="swzf" then 
					if randomValue == "baseDamage" then
						if caster.swzf_baseDamage == nil then
							caster.swzf_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))
						caster.swzf_baseDamage = caster.swzf_baseDamage + z
						netTable["swzf_baseDamage"] = caster.swzf_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F") 
						return nil
					elseif randomValue == "damage" then
						if caster.swzf_damage == nil then
							caster.swzf_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.swzf_damage = caster.swzf_damage + z
						netTable["swzf_damage"] = caster.swzf_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						 return nil
					end


					if randomValue == "count" then
						if caster.swzf_count == nil then
							caster.swzf_count = 0
						end
						z = RandomInt(1,z)
						caster.swzf_count = caster.swzf_count + z
						netTable["swzf_count"] = caster.swzf_count
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_count",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "multiple" then
						if caster.swzf_multiple == nil then
							caster.swzf_multiple = 0
						end
						z = RandomInt(1,z)
						caster.swzf_multiple = caster.swzf_multiple + z
						netTable["swzf_multiple"] = caster.swzf_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				

				--*******************************************************************************************
				--天玄破神荒
				elseif abilityName =="txpsh" then 
					if randomValue == "baseDamage" then
						if caster.txpsh_baseDamage == nil then
							caster.txpsh_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))
						caster.txpsh_baseDamage = caster.txpsh_baseDamage + z
						netTable["txpsh_baseDamage"] = caster.txpsh_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.txpsh_damage == nil then
							caster.txpsh_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.txpsh_damage = caster.txpsh_damage + z
						netTable["txpsh_damage"] = caster.txpsh_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						 return nil
					elseif randomValue == "radius" then
						if caster.txpsh_radius == nil then
							caster.txpsh_radius = 0
						end
						z = RandomInt(10,z)
						caster.txpsh_radius = caster.txpsh_radius + z
						netTable["txpsh_radius"] = caster.txpsh_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "count" then
						if caster.txpsh_count == nil then
							caster.txpsh_count = 0
						end
						z = RandomInt(1,z)
						caster.txpsh_count = caster.txpsh_count + z
						netTable["txpsh_count"] = caster.txpsh_count
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_count",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "multiple" then
						if caster.txpsh_multiple == nil then
							caster.txpsh_multiple = 0
						end
						z = RandomInt(1,z)
						caster.txpsh_multiple = caster.txpsh_multiple + z
						netTable["txpsh_multiple"] = caster.txpsh_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				


				--*******************************************************************************************
				--神剑御雷真诀
				elseif abilityName =="sjylzj" then 
					if randomValue == "baseDamage" then
						if caster.sjylzj_baseDamage == nil then
							caster.sjylzj_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))
						caster.sjylzj_baseDamage = caster.sjylzj_baseDamage + z
						netTable["sjylzj_baseDamage"] = caster.sjylzj_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.sjylzj_damage == nil then
							caster.sjylzj_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.sjylzj_damage = caster.sjylzj_damage + z
						netTable["sjylzj_damage"] = caster.sjylzj_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F") 
						 return nil
					elseif randomValue == "count" then
						if caster.sjylzj_count == nil then
							caster.sjylzj_count = 0
						end
						z = RandomInt(1,z)
						caster.sjylzj_count = caster.sjylzj_count + z
						netTable["sjylzj_count"] = caster.sjylzj_count
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_count",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "multiple" then
						if caster.sjylzj_multiple == nil then
							caster.sjylzj_multiple = 0
						end
						z = RandomInt(1,z)
						caster.sjylzj_multiple = caster.sjylzj_multiple + z
						netTable["sjylzj_multiple"] = caster.sjylzj_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					  NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				

				--*******************************************************************************************
				--连斩
				elseif abilityName =="lz" then 				
					if randomValue == "duration" then
						if caster.lz_duration == nil then
							caster.lz_duration = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))
						caster.lz_duration = caster.lz_duration + z
						netTable["lz_duration"] = caster.lz_duration
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_duration",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil
					end		
				


				--*******************************************************************************************
				--无敌斩
				elseif abilityName =="wdz" then 			
					if randomValue == "radius" then
						if caster.wdz_radius == nil then
							caster.wdz_radius = 0
						end
						z = RandomInt(10,z)
						caster.wdz_radius = caster.wdz_radius + z
						netTable["wdz_radius"] = caster.wdz_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "count" then
						if caster.wdz_count == nil then
							caster.wdz_count = 0
						end
						z = 0.5	--削弱这个技能
						caster.wdz_count = caster.wdz_count + z
						netTable["wdz_count"] = caster.wdz_count
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					  NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_count",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
					


				--*******************************************************************************************
				--幻影突袭
				elseif abilityName =="hytx" then 
					if randomValue == "baseDamage" then
						if caster.hytx_baseDamage == nil then
							caster.hytx_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5)) / 4
						caster.hytx_baseDamage = caster.hytx_baseDamage + z
						netTable["hytx_baseDamage"] = caster.hytx_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.hytx_damage == nil then
							caster.hytx_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z)/4)		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.hytx_damage = caster.hytx_damage + z
						netTable["hytx_damage"] = caster.hytx_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						 return nil
					end					
				

				--*******************************************************************************************
				--暗影突袭
				elseif abilityName =="aytx" then 
					if randomValue == "baseDamage" then
						if caster.aytx_baseDamage == nil then
							caster.aytx_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))
						caster.aytx_baseDamage = caster.aytx_baseDamage + z
						netTable["aytx_baseDamage"] = caster.aytx_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")  
						return nil
					elseif randomValue == "damage" then
						if caster.aytx_damage == nil then
							caster.aytx_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.aytx_damage = caster.aytx_damage + z
						netTable["aytx_damage"] = caster.aytx_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						 return nil
					elseif randomValue == "multiple" then
						if caster.aytx_multiple == nil then
							caster.aytx_multiple = 0
						end
						z = RandomInt(1,z)
						caster.aytx_multiple = caster.aytx_multiple + z
						netTable["aytx_multiple"] = caster.aytx_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				

				--*******************************************************************************************
				--火焰风暴
				elseif abilityName =="hyfb" then 
					if randomValue == "baseDamage" then
						if caster.hyfb_baseDamage == nil then
							caster.hyfb_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))*2
						caster.hyfb_baseDamage = caster.hyfb_baseDamage + z
						netTable["hyfb_baseDamage"] = caster.hyfb_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.hyfb_damage == nil then
							caster.hyfb_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))*2		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.hyfb_damage = caster.hyfb_damage + z
						netTable["hyfb_damage"] = caster.hyfb_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "duration" then
						if caster.hyfb_duration == nil then
							caster.hyfb_duration = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))
						caster.hyfb_duration = caster.hyfb_duration + z
						netTable["hyfb_duration"] = caster.hyfb_duration
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_duration",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil
					elseif randomValue == "multiple" then
						if caster.hyfb_multiple == nil then
							caster.hyfb_multiple = 0
						end
						z = RandomInt(1,z)
						caster.hyfb_multiple = caster.hyfb_multiple + z
						netTable["hyfb_multiple"] = caster.hyfb_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil
					end
				

				--*******************************************************************************************
				--野蛮冲撞
				elseif abilityName =="ymcz" then 
					if randomValue == "baseDamage" then
						if caster.ymcz_baseDamage == nil then
							caster.ymcz_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))
						caster.ymcz_baseDamage = caster.ymcz_baseDamage + z
						netTable["ymcz_baseDamage"] = caster.ymcz_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.ymcz_damage == nil then
							caster.ymcz_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.ymcz_damage = caster.ymcz_damage + z
						netTable["ymcz_damage"] = caster.ymcz_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					end
			
					if randomValue == "multiple" then
						if caster.ymcz_multiple == nil then
							caster.ymcz_multiple = 0
						end
						z = RandomInt(1,z)
						caster.ymcz_multiple = caster.ymcz_multiple + z
						netTable["ymcz_multiple"] = caster.ymcz_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil
					end
				

				--*******************************************************************************************
				--霜冻护甲
				elseif abilityName =="sdhj" then 
					if randomValue == "baseDamage" then
						if caster.sdhj_baseDamage == nil then
							caster.sdhj_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))
						caster.sdhj_baseDamage = caster.sdhj_baseDamage + z
						netTable["sdhj_baseDamage"] = caster.sdhj_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.sdhj_damage == nil then
							caster.sdhj_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.sdhj_damage = caster.sdhj_damage + z
						netTable["sdhj_damage"] = caster.sdhj_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "max" then
						if caster.sdhj_max == nil then
							caster.sdhj_max = 0
						end
						z = RandomInt(z,3)
						caster.sdhj_max = caster.sdhj_max + z
						netTable["sdhj_max"] = caster.sdhj_max
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.Top(playerID,"霜冻护甲的增加"..z.."点",3,"#ADFF2F")
						return nil
					elseif randomValue == "duration" then
						if caster.sdhj_duration == nil then
							caster.sdhj_duration = 0
						end
						z = string.format("%.2f",RandomFloat(z,2))
						caster.sdhj_duration = caster.sdhj_duration + z
						netTable["sdhj_duration"] = caster.sdhj_duration
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil
					elseif randomValue == "multiple" then
						if caster.sdhj_multiple == nil then
							caster.sdhj_multiple = 0
						end
						z = RandomInt(1,z)
						caster.sdhj_multiple = caster.sdhj_multiple + z
						netTable["sdhj_multiple"] = caster.sdhj_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.Top(playerID,"霜冻护甲的完美伤害增加"..z.."倍",3,"#ADFF2F")	
					    return nil
					end
				

				--*******************************************************************************************
				--水刀
				elseif abilityName =="sd" then 				
					if randomValue == "interval" then
						if caster.sd_interval == nil then
							caster.sd_interval = 0
						end
						z = 0.02
						caster.sd_interval = caster.sd_interval + z
						netTable["sd_interval"] = caster.sd_interval
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					     NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_interval",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil
					end				
				


				--*******************************************************************************************
				--碎甲一击
				elseif abilityName =="sjyj" then 
					if randomValue == "baseDamage" then
						if caster.sjyj_baseDamage == nil then
							caster.sjyj_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))
						caster.sjyj_baseDamage = caster.sjyj_baseDamage + z
						netTable["sjyj_baseDamage"] = caster.sjyj_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.sjyj_damage == nil then
							caster.sjyj_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.sjyj_damage = caster.sjyj_damage + z
						netTable["sjyj_damage"] = caster.sjyj_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "max" then
						if caster.sjyj_max == nil then
							caster.sjyj_max = 0
						end
						z = RandomInt(z,3)
						caster.sjyj_max = caster.sjyj_max + z
						netTable["sjyj_max"] = caster.sjyj_max
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.Top(playerID,"碎甲一击的减甲降低"..z.."点",3,"#ADFF2F")	--与其他的不同，
						return nil
					elseif randomValue == "interval" then
						if caster.sjyj_interval == nil then
							caster.sjyj_interval = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))
						caster.sjyj_interval = caster.sjyj_interval + z
						netTable["sjyj_interval"] = caster.sjyj_interval
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_interval",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil
					end			

					if randomValue == "multiple" then
						if caster.sjyj_multiple == nil then
							caster.sjyj_multiple = 0
						end
						z = RandomInt(1,z)
						caster.sjyj_multiple = caster.sjyj_multiple + z
						netTable["sjyj_multiple"] = caster.sjyj_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil
					end
				



				--*******************************************************************************************
				--神圣之光
				elseif abilityName =="sszg" then 					
					if randomValue == "heal" then
						if caster.sszg_heal == nil then
							caster.sszg_heal = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))*2	--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.sszg_heal = caster.sszg_heal + z
						netTable["sszg_heal"] = caster.sszg_heal
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_heal",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "baseHeal" then
						if caster.sszg_baseHeal == nil then
							caster.sszg_baseHeal = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))*2		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.sszg_baseHeal = caster.sszg_baseHeal + z
						netTable["sszg_baseHeal"] = caster.sszg_baseHeal
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseHeal",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "multiple" then
						if caster.sszg_multiple == nil then
							caster.sszg_multiple = 0
						end
						z = RandomInt(1,z)
						caster.sszg_multiple = caster.sszg_multiple + z
						netTable["sszg_multiple"] = caster.sszg_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				

				--*******************************************************************************************
				--冲天拳
				elseif abilityName =="hpq" then 
					if randomValue == "baseDamage" then
						if caster.hpq_baseDamage == nil then
							caster.hpq_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))
						caster.hpq_baseDamage = caster.hpq_baseDamage + z
						netTable["hpq_baseDamage"] = caster.hpq_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.hpq_damage == nil then
							caster.hpq_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z*2.2))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.hpq_damage = caster.hpq_damage + z
						netTable["hpq_damage"] = caster.hpq_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "chance" then
						if caster.hpq_chance == nil then
							caster.hpq_chance = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))
						caster.hpq_chance = caster.hpq_chance + z
						netTable["hpq_chance"] = caster.hpq_chance
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_chance",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "time" then
						if caster.hpq_time == nil then
							caster.hpq_time = 0
						end
						z = RandomInt(1,z)
						caster.hpq_time = caster.hpq_time + z
						netTable["hpq_time"] = caster.hpq_time
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_time",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil
					elseif randomValue == "multiple" then
						if caster.hpq_multiple == nil then
							caster.hpq_multiple = 0
						end
						z = RandomInt(1,z)
						caster.hpq_multiple = caster.hpq_multiple + z
						netTable["hpq_multiple"] = caster.hpq_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					 	 NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil
					end
				


				--*******************************************************************************************
				--裂地击
				elseif abilityName =="ldj" then 
					if randomValue == "baseDamage" then
						if caster.ldj_baseDamage == nil then
							caster.ldj_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))
						caster.ldj_baseDamage = caster.ldj_baseDamage + z
						netTable["ldj_baseDamage"] = caster.ldj_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						 return nil
					elseif randomValue == "damage" then
						if caster.ldj_damage == nil then
							caster.ldj_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z*1.4))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.ldj_damage = caster.ldj_damage + z
						netTable["ldj_damage"] = caster.ldj_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "radius" then
						if caster.ldj_radius == nil then
							caster.ldj_radius = 0
						end
						z = RandomInt(10,z)
						caster.ldj_radius = caster.ldj_radius + z
						netTable["ldj_radius"] = caster.ldj_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "chance" then
						if caster.ldj_chance == nil then
							caster.ldj_chance = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))
						caster.ldj_chance = caster.ldj_chance + z
						netTable["ldj_chance"] = caster.ldj_chance
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_chance",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "distance" then
						if caster.ldj_distance == nil then
							caster.ldj_distance = 0
						end
						z = RandomInt(10,z)
						caster.ldj_distance = caster.ldj_distance + z
						netTable["ldj_distance"] = caster.ldj_distance
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_distance",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "time" then
						if caster.ldj_time == nil then
							caster.ldj_time = 0
						end
						z = RandomInt(1,z)
						caster.ldj_time = caster.ldj_time + z
						netTable["ldj_time"] = caster.ldj_time
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_time",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "max" then
						if caster.ldj_max == nil then
							caster.ldj_max = 0
						end
						z = RandomInt(1,z)
						caster.ldj_max = caster.ldj_max + z
						netTable["ldj_max"] = caster.ldj_max
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					     NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_max",{value=tostring(z)}}},3,"#ADFF2F") 
					    return nil	
					elseif randomValue == "multiple" then
						if caster.ldj_multiple == nil then
							caster.ldj_multiple = 0
						end
						z = RandomInt(1,z)
						caster.ldj_multiple = caster.ldj_multiple + z
						netTable["ldj_multiple"] = caster.ldj_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				

				--*******************************************************************************************
				--混元七击
				elseif abilityName =="hyqj" then 
					if randomValue == "baseDamage" then
						if caster.hyqj_baseDamage == nil then
							caster.hyqj_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))
						caster.hyqj_baseDamage = caster.hyqj_baseDamage + z
						netTable["hyqj_baseDamage"] = caster.hyqj_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.hyqj_damage == nil then
							caster.hyqj_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z*1.4))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.hyqj_damage = caster.hyqj_damage + z
						netTable["hyqj_damage"] = caster.hyqj_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "chance" then
						if caster.hyqj_chance == nil then
							caster.hyqj_chance = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))
						caster.hyqj_chance = caster.hyqj_chance + z
						netTable["hyqj_chance"] = caster.hyqj_chance
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_chance",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "time" then
						if caster.hyqj_time == nil then
							caster.hyqj_time = 0
						end
						z = RandomInt(1,z)
						caster.hyqj_time = caster.hyqj_time + z
						netTable["hyqj_time"] = caster.hyqj_time
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_time",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil
					elseif randomValue == "multiple" then
						if caster.hyqj_multiple == nil then
							caster.hyqj_multiple = 0
						end
						z = RandomInt(1,z)
						caster.hyqj_multiple = caster.hyqj_multiple + z
						netTable["hyqj_multiple"] = caster.hyqj_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					 	 NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil
					end
				


				--*******************************************************************************************
				--死亡守卫
				elseif abilityName =="swsw" then 
					if randomValue == "baseDamage" then
						if caster.swsw_baseDamage == nil then
							caster.swsw_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5)) /4
						caster.swsw_baseDamage = caster.swsw_baseDamage + z
						netTable["swsw_baseDamage"] = caster.swsw_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.swsw_damage == nil then
							caster.swsw_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z)/4)		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.swsw_damage = caster.swsw_damage + z
						netTable["swsw_damage"] = caster.swsw_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "duration" then
						if caster.swsw_duration == nil then
							caster.swsw_duration = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))
						caster.swsw_duration = caster.swsw_duration + z
						netTable["swsw_duration"] = caster.swsw_duration
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_duration",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil
					elseif randomValue == "max" then
						if caster.swsw_max == nil then
							caster.swsw_max = 0
						end
						z = RandomInt(1,z)
						caster.swsw_max = caster.swsw_max + z
						netTable["swsw_max"] = caster.swsw_max
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_max",{value=tostring(z)}}},3,"#ADFF2F") 
					    return nil	
					elseif randomValue == "multiple" then
						if caster.swsw_multiple == nil then
							caster.swsw_multiple = 0
						end
						z = RandomInt(1,z) *5
						caster.swsw_multiple = caster.swsw_multiple + z
						netTable["swsw_multiple"] = caster.swsw_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					 	 NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil
					end
				


				--*******************************************************************************************
				--群蛇守卫
				elseif abilityName =="qssw" then 
					if randomValue == "baseDamage" then
						if caster.qssw_baseDamage == nil then
							caster.qssw_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5)) /4
						caster.qssw_baseDamage = caster.qssw_baseDamage + z
						netTable["qssw_baseDamage"] = caster.qssw_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.qssw_damage == nil then
							caster.qssw_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z)/4)		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.qssw_damage = caster.qssw_damage + z
						netTable["qssw_damage"] = caster.qssw_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "duration" then
						if caster.qssw_duration == nil then
							caster.qssw_duration = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))
						caster.qssw_duration = caster.qssw_duration + z
						netTable["qssw_duration"] = caster.qssw_duration
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_duration",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil
					elseif randomValue == "max" then
						if caster.qssw_max == nil then
							caster.qssw_max = 0
						end
						z = RandomInt(1,3) --可能还是2比较好
						caster.qssw_max = caster.qssw_max + z
						netTable["qssw_max"] = caster.qssw_max
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_max",{value=tostring(z)}}},3,"#ADFF2F") 
					    return nil	
					elseif randomValue == "multiple" then
						if caster.qssw_multiple == nil then
							caster.qssw_multiple = 0
						end
						z = RandomInt(1,z) * 5
						caster.qssw_multiple = caster.qssw_multiple + z
						netTable["qssw_multiple"] = caster.qssw_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					 	 NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil
					end
				




				--*******************************************************************************************
				--地狱火
				elseif abilityName =="dyh" then 
					if randomValue == "baseDamage" then
						if caster.dyh_baseDamage == nil then
							caster.dyh_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5)) * 1.5
						caster.dyh_baseDamage = caster.dyh_baseDamage + z
						netTable["dyh_baseDamage"] = caster.dyh_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.dyh_damage == nil then
							caster.dyh_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z)*1.5)		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.dyh_damage = caster.dyh_damage + z
						netTable["dyh_damage"] = caster.dyh_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "duration" then
						if caster.dyh_duration == nil then
							caster.dyh_duration = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z)*3)
						caster.dyh_duration = caster.dyh_duration + z
						netTable["dyh_duration"] = caster.dyh_duration
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_duration",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil
					elseif randomValue == "multiple" then
						if caster.dyh_multiple == nil then
							caster.dyh_multiple = 0
						end
						z = RandomInt(1,z)*5
						caster.dyh_multiple = caster.dyh_multiple + z
						netTable["dyh_multiple"] = caster.dyh_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					 	 NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil
					end
				


				--*******************************************************************************************
				--真空粉碎
				elseif abilityName =="zkfs" then 
					if randomValue == "baseDamage" then
						if caster.zkfs_baseDamage == nil then
							caster.zkfs_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))
						caster.zkfs_baseDamage = caster.zkfs_baseDamage + z
						netTable["zkfs_baseDamage"] = caster.zkfs_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.zkfs_damage == nil then
							caster.zkfs_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.2,z*0.55))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.zkfs_damage = caster.zkfs_damage + z
						netTable["zkfs_damage"] = caster.zkfs_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "radius" then
						if caster.zkfs_radius == nil then
							caster.zkfs_radius = 0
						end
						z = RandomInt(10,z)
						caster.zkfs_radius = caster.zkfs_radius + z
						netTable["zkfs_radius"] = caster.zkfs_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "chance" then
						if caster.zkfs_chance == nil then
							caster.zkfs_chance = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))
						caster.zkfs_chance = caster.zkfs_chance + z
						netTable["zkfs_chance"] = caster.zkfs_chance
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_chance",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "time" then
						if caster.zkfs_time == nil then
							caster.zkfs_time = 0
						end
						z = RandomInt(1,z)
						caster.zkfs_time = caster.zkfs_time + z
						netTable["zkfs_time"] = caster.zkfs_time
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_time",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "multiple" then
						if caster.zkfs_multiple == nil then
							caster.zkfs_multiple = 0
						end
						z = RandomInt(1,z)
						caster.zkfs_multiple = caster.zkfs_multiple + z
						netTable["zkfs_multiple"] = caster.zkfs_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				



				--*******************************************************************************************
				--混沌一击
				elseif abilityName =="hdyj" then 
					if randomValue == "baseDamage" then
						if caster.hdyj_baseDamage == nil then
							caster.hdyj_baseDamage = 0
						end
						z = RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))
						caster.hdyj_baseDamage = caster.hdyj_baseDamage + z
						netTable["hdyj_baseDamage"] = caster.hdyj_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.hdyj_damage == nil then
							caster.hdyj_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.2,z*0.75))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.hdyj_damage = caster.hdyj_damage + z
						netTable["hdyj_damage"] = caster.hdyj_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "chance" then
						if caster.hdyj_chance == nil then
							caster.hdyj_chance = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))
						caster.hdyj_chance = caster.hdyj_chance + z
						netTable["hdyj_chance"] = caster.hdyj_chance
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_chance",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "time" then
						if caster.hdyj_time == nil then
							caster.hdyj_time = 0
						end
						z = RandomInt(1,z)
						caster.hdyj_time = caster.hdyj_time + z
						netTable["hdyj_time"] = caster.hdyj_time
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_time",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil
					elseif randomValue == "multiple" then
						if caster.hdyj_multiple == nil then
							caster.hdyj_multiple = 0
						end
						z = RandomInt(1,z)
						caster.hdyj_multiple = caster.hdyj_multiple + z
						netTable["hdyj_multiple"] = caster.hdyj_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					 	 NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil
					end
				


				--*******************************************************************************************
				--血潮
				elseif abilityName =="xc" then 
					if randomValue == "baseDamage" then
						if caster.xc_baseDamage == nil then
							caster.xc_baseDamage = 0
						end
						z = math.ceil(RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))/3)
						caster.xc_baseDamage = caster.xc_baseDamage + z
						netTable["xc_baseDamage"] = caster.xc_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.xc_damage == nil then
							caster.xc_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z)/2.2)		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.xc_damage = caster.xc_damage + z
						netTable["xc_damage"] = caster.xc_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "radius" then
						if caster.xc_radius == nil then
							caster.xc_radius = 0
						end
						z = RandomInt(10,z)
						caster.xc_radius = caster.xc_radius + z
						netTable["xc_radius"] = caster.xc_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "multiple" then
						if caster.xc_multiple == nil then
							caster.xc_multiple = 0
						end
						z = RandomInt(1,z)
						caster.xc_multiple = caster.xc_multiple + z
						netTable["xc_multiple"] = caster.xc_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				


				--*******************************************************************************************
				--生命爆发
				elseif abilityName =="smbf" then 
					if randomValue == "baseDamage" then
						if caster.smbf_baseDamage == nil then
							caster.smbf_baseDamage = 0
						end
						z = math.ceil(RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))*6)
						caster.smbf_baseDamage = caster.smbf_baseDamage + z
						netTable["smbf_baseDamage"] = caster.smbf_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.smbf_damage == nil then
							caster.smbf_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.2,z*1.4))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.smbf_damage = caster.smbf_damage + z
						netTable["smbf_damage"] = caster.smbf_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "radius" then
						if caster.smbf_radius == nil then
							caster.smbf_radius = 0
						end
						z = RandomInt(10,z)
						caster.smbf_radius = caster.smbf_radius + z
						netTable["smbf_radius"] = caster.smbf_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "multiple" then
						if caster.smbf_multiple == nil then
							caster.smbf_multiple = 0
						end
						z = RandomInt(1,z)
						caster.smbf_multiple = caster.smbf_multiple + z
						netTable["smbf_multiple"] = caster.smbf_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				

				--*******************************************************************************************
				--流血刀法
				elseif abilityName =="lxdf" then 
					if randomValue == "baseDamage" then
						if caster.lxdf_baseDamage == nil then
							caster.lxdf_baseDamage = 0
						end
						z = math.ceil(RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))*2)
						caster.lxdf_baseDamage = caster.lxdf_baseDamage + z
						netTable["lxdf_baseDamage"] = caster.lxdf_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.lxdf_damage == nil then
							caster.lxdf_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z*4.5))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.lxdf_damage = caster.lxdf_damage + z
						netTable["lxdf_damage"] = caster.lxdf_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "chance" then
						if caster.lxdf_chance == nil then
							caster.lxdf_chance = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))
						caster.lxdf_chance = caster.lxdf_chance + z
						netTable["lxdf_chance"] = caster.lxdf_chance
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_chance",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "time" then
						if caster.lxdf_time == nil then
							caster.lxdf_time = 0
						end
						z = RandomInt(1,z)
						caster.lxdf_time = caster.lxdf_time + z
						netTable["lxdf_time"] = caster.lxdf_time
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_time",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil
					elseif randomValue == "multiple" then
						if caster.lxdf_multiple == nil then
							caster.lxdf_multiple = 0
						end
						z = RandomInt(1,z)
						caster.lxdf_multiple = caster.lxdf_multiple + z
						netTable["lxdf_multiple"] = caster.lxdf_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					 	 NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil
					end
				


				--*******************************************************************************************
				--嗜血术
				elseif abilityName =="sxs" then 
					if randomValue == "baseDamage" then
						if caster.sxs_baseDamage == nil then
							caster.sxs_baseDamage = 0
						end
						z = math.ceil(RandomInt(z/2,z) * (0.5+(Stage.wave*0.5)))
						caster.sxs_baseDamage = caster.sxs_baseDamage + z
						netTable["sxs_baseDamage"] = caster.sxs_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.sxs_damage == nil then
							caster.sxs_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z)/30)		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.sxs_damage = caster.sxs_damage + z
						netTable["sxs_damage"] = caster.sxs_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					end


					if randomValue == "multiple" then
						if caster.sxs_multiple == nil then
							caster.sxs_multiple = 0
						end
						z = RandomInt(1,z)
						caster.sxs_multiple = caster.sxs_multiple + z
						netTable["sxs_multiple"] = caster.sxs_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					 	 NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil
					end
				




				--*******************************************************************************************
				--冰霜爆破
				elseif abilityName =="bsbp" then 
					if randomValue == "baseDamage" then
						if caster.bsbp_baseDamage == nil then
							caster.bsbp_baseDamage = 0
						end
						z = math.ceil(RandomInt(z/2,z) * (0.5+(Stage.wave*0.5)))
						caster.bsbp_baseDamage = caster.bsbp_baseDamage + z
						netTable["bsbp_baseDamage"] = caster.bsbp_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.bsbp_damage == nil then
							caster.bsbp_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z*1.55))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.bsbp_damage = caster.bsbp_damage + z
						netTable["bsbp_damage"] = caster.bsbp_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "radius" then
						if caster.bsbp_radius == nil then
							caster.bsbp_radius = 0
						end
						z = RandomInt(1,z/2)
						caster.bsbp_radius = caster.bsbp_radius + z
						netTable["bsbp_radius"] = caster.bsbp_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "chance" then
						if caster.bsbp_chance == nil then
							caster.bsbp_chance = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))
						caster.bsbp_chance = caster.bsbp_chance + z
						netTable["bsbp_chance"] = caster.bsbp_chance
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_chance",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "time" then
						if caster.bsbp_time == nil then
							caster.bsbp_time = 0
						end
						z = RandomInt(1,z)
						caster.bsbp_time = caster.bsbp_time + z
						netTable["bsbp_time"] = caster.bsbp_time
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_time",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "multiple" then
						if caster.bsbp_multiple == nil then
							caster.bsbp_multiple = 0
						end
						z = RandomInt(1,z)
						caster.bsbp_multiple = caster.bsbp_multiple + z
						netTable["bsbp_multiple"] = caster.bsbp_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				




				--*******************************************************************************************
				--烈焰破击
				elseif abilityName =="lypj" then 
					if randomValue == "baseDamage" then
						if caster.lypj_baseDamage == nil then
							caster.lypj_baseDamage = 0
						end
						z = math.ceil(RandomInt(z/2,z) * (0.5+(Stage.wave*0.5))*1.5)
						caster.lypj_baseDamage = caster.lypj_baseDamage + z
						netTable["lypj_baseDamage"] = caster.lypj_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "damage" then
						if caster.lypj_damage == nil then
							caster.lypj_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z*2.4))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.lypj_damage = caster.lypj_damage + z
						netTable["lypj_damage"] = caster.lypj_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "chance" then
						if caster.lypj_chance == nil then
							caster.lypj_chance = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))
						caster.lypj_chance = caster.lypj_chance + z
						netTable["lypj_chance"] = caster.lypj_chance
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_chance",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "time" then
						if caster.lypj_time == nil then
							caster.lypj_time = 0
						end
						z = RandomInt(1,z)
						caster.lypj_time = caster.lypj_time + z
						netTable["lypj_time"] = caster.lypj_time
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_time",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil
					elseif randomValue == "multiple" then
						if caster.lypj_multiple == nil then
							caster.lypj_multiple = 0
						end
						z = RandomInt(1,z)
						caster.lypj_multiple = caster.lypj_multiple + z
						netTable["lypj_multiple"] = caster.lypj_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					 	 NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil
					end
				



				--*******************************************************************************************
				--飞星
				elseif abilityName =="dxcq" then 
					if randomValue == "baseDamage" then
						if caster.dxcq_baseDamage == nil then
							caster.dxcq_baseDamage = 0
						end
						z = math.ceil(RandomInt(z/2,z) * (0.5+(Stage.wave*0.5)))
						caster.dxcq_baseDamage = caster.dxcq_baseDamage + z
						netTable["dxcq_baseDamage"] = caster.dxcq_baseDamage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_baseDamage",{value=tostring(z)}}},3,"#ADFF2F")
						 return nil
					elseif randomValue == "damage" then
						if caster.dxcq_damage == nil then
							caster.dxcq_damage = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))		--这个系数也应该弄一个权重占比分布，还是以后再弄吧
						caster.dxcq_damage = caster.dxcq_damage + z
						netTable["dxcq_damage"] = caster.dxcq_damage
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)		
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_damage",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "radius" then
						if caster.dxcq_radius == nil then
							caster.dxcq_radius = 0
						end
						z = RandomInt(10,z)
						caster.dxcq_radius = caster.dxcq_radius + z
						netTable["dxcq_radius"] = caster.dxcq_radius
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_radius",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "chance" then
						if caster.dxcq_chance == nil then
							caster.dxcq_chance = 0
						end
						z = string.format("%.2f",RandomFloat(0.1,z))
						caster.dxcq_chance = caster.dxcq_chance + z
						netTable["dxcq_chance"] = caster.dxcq_chance
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
						NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_chance",{value=tostring(z)}}},3,"#ADFF2F")
						return nil
					elseif randomValue == "distance" then
						if caster.dxcq_distance == nil then
							caster.dxcq_distance = 0
						end
						z = RandomInt(10,z)
						caster.dxcq_distance = caster.dxcq_distance + z
						netTable["dxcq_distance"] = caster.dxcq_distance
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					    NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_distance",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "max" then
						if caster.dxcq_max == nil then
							caster.dxcq_max = 0
						end
						z = RandomInt(1,z)
						caster.dxcq_max = caster.dxcq_max + z
						netTable["dxcq_max"] = caster.dxcq_max
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					     NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_max",{value=tostring(z)}}},3,"#ADFF2F") 
					    return nil	
					elseif randomValue == "time" then
						if caster.dxcq_time == nil then
							caster.dxcq_time = 0
						end
						z = RandomInt(1,z)
						caster.dxcq_time = caster.dxcq_time + z
						netTable["dxcq_time"] = caster.dxcq_time
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_time",{value=tostring(z)}}},3,"#ADFF2F")
					    return nil	
					elseif randomValue == "multiple" then
						if caster.dxcq_multiple == nil then
							caster.dxcq_multiple = 0
						end
						z = RandomInt(1,z)
						caster.dxcq_multiple = caster.dxcq_multiple + z
						netTable["dxcq_multiple"] = caster.dxcq_multiple
			 			SetNetTableValue("UnitAttributes",unitKey,netTable)	
					   NotifyUtil.BottomGroup(playerID,{"DOTA_Tooltip_ability_"..originAbility,{"ability_mj_multiple",{value=tostring(z)}}},3,"#ADFF2F")--
					    return nil	
					end
				end

end



-- 获取一个表的随机词条
local function RandomCiTiao(abilityName,playerID,caster,abn)
	if Mj.jnct[abilityName] ~= nil then
	local n = #Mj.jnct[abilityName]
	ctsx(abilityName,n,playerID,caster,abn)
	else
		-- NotifyUtil.ShowError(playerID,"#ct_not")
	end
end




function AddMjAbility(keys)
	local caster = keys.caster
	if not caster:IsRealHero() then return end
	local playerID = caster:GetPlayerID()
	local ability = keys.ability
	local abilityName = string.sub(ability:GetAbilityName(), 16)
	

	local playerAbility = caster:FindAbilityByName(abilityName)

	RandomCiTiao(abilityName,playerID,caster)

	ability:RemoveSelf()

	
end

--随机增加人物已经拥有技能的数值
--需要杀敌数
function AddRandomMj(keys)
	local caster = keys.caster
	local ability = keys.ability
	local playerID = caster:GetPlayerID()
	caster = PlayerUtil.GetHero(playerID)
	ability:RemoveSelf()
	if not caster:IsRealHero() then 
		return 
	end

	local jg = 100

	if 	caster:HasModifier("modifier_bw_all_64") then
		jg = 20
	elseif caster:HasModifier("modifier_bw_all_63") then
		jg = 40
	elseif caster:HasModifier("modifier_bw_all_62") then
		jg = 60
	elseif caster:HasModifier("modifier_bw_all_61") then
		jg = 80
	end
	if caster.cas_table.sds >=jg  then
		caster.cas_table.sds =caster.cas_table.sds -jg
		local jnk ={}
		local x = 0
		for i=0,4 do
			if caster:GetAbilityByIndex(i) then
			local name = caster:GetAbilityByIndex(i):GetAbilityName()
				local name2 = string.sub(name,1,3)
				local name5 = string.sub(name,8,-2)
				if name2 ~= "kjn" and  name2 ~= "yxt" then
					if Mj.jnct[name5] ~= nil then
						if name2 ~= "abi" then
							x =x +1
							jnk[x]=name
						end
					end
				end
			end
		end
		if jnk[1]~=nil then
			local rd = RandomInt(1,#jnk)
			local name3 = jnk[rd]
			local name4 =  string.sub(name3,8,-2)
			RandomCiTiao(name4,playerID,caster,name3)
		else
			caster.cas_table.sds = caster.cas_table.sds + jg
			NotifyUtil.ShowError(playerID,"#ablity_not")
		end
		local unitKey = tostring(EntityHelper.getEntityIndex(caster))
		local netTable = caster.cas_table
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	else
		NotifyUtil.ShowError(playerID,"sds_not2",{value=jg-caster.cas_table.sds})
	end
end


--随机增加人物已经拥有技能的数值
--需要杀敌数
function AddRandomMj4(keys)
	local caster = keys.caster
	local ability = keys.ability
	local playerID = caster:GetPlayerID()
	caster = PlayerUtil.GetHero(playerID)
	ability:RemoveSelf()
	if not caster:IsRealHero() then 
		return 
	end

	local jg = 100

	if 	caster:HasModifier("modifier_bw_all_64") then
		jg = 20
	elseif caster:HasModifier("modifier_bw_all_63") then
		jg = 40
	elseif caster:HasModifier("modifier_bw_all_62") then
		jg = 60
	elseif caster:HasModifier("modifier_bw_all_61") then
		jg = 80
	end

	for i=1,500 do
		if caster.cas_table.sds >=jg  then
			caster.cas_table.sds =caster.cas_table.sds -jg
			local jnk ={}
			local x = 0
			for i=0,4 do
				if caster:GetAbilityByIndex(i) then
				local name = caster:GetAbilityByIndex(i):GetAbilityName()
					local name2 = string.sub(name,1,3)
					local name5 = string.sub(name,8,-2)
					if name2 ~= "kjn" and  name2 ~= "yxt" then
						if Mj.jnct[name5] ~= nil then
							if name2 ~= "abi" then
								x =x +1
								jnk[x]=name
							end
						end
					end
				end
			end
			if jnk[1]~=nil then
				local rd = RandomInt(1,#jnk)
				local name3 = jnk[rd]
				local name4 =  string.sub(name3,8,-2)
				RandomCiTiao(name4,playerID,caster,name3)
			else
				caster.cas_table.sds = caster.cas_table.sds + jg
				NotifyUtil.ShowError(playerID,"#ablity_not")
				break;
			end
			local unitKey = tostring(EntityHelper.getEntityIndex(caster))
			local netTable = caster.cas_table
			SetNetTableValue("UnitAttributes",unitKey,netTable)
		else
			NotifyUtil.ShowError(playerID,"sds_not2",{value=jg-caster.cas_table.sds})
			break;
		end
	end	
	

end

--随机增加人物已经拥有技能的数值
--通过技能使用，不是通过使用物品
--如果玩家没有学习技能，则使用失败，但是物品一样会消耗
--不需要杀敌数
function AddRandomMj2(keys)

	local caster = keys.caster
	local ability = keys.ability
	local playerID = caster:GetPlayerID()
	caster = PlayerUtil.GetHero(playerID)
	local charges = ability:GetCurrentCharges()
	if not caster:IsRealHero() then 
		return 
	end
	
		local jnk ={}
		local x = 0
		for i=0,4 do
			if caster:GetAbilityByIndex(i) then
			local name = caster:GetAbilityByIndex(i):GetAbilityName()
				local name2 = string.sub(name,1,3)
				local name5 = string.sub(name,8,-2)
				if name2 ~= "kjn" and  name2 ~= "yxt" then
					if Mj.jnct[name5] ~= nil then
						if name2 ~= "abi" then
							x =x +1
							jnk[x]=name
						end
					end
				end
			end
		end
		if jnk[1]~=nil then
			local rd = RandomInt(1,#jnk)
			local name3 = jnk[rd]
			local name4 =  string.sub(name3,8,-2)
			RandomCiTiao(name4,playerID,caster,name3)
			if charges > 1 then
				ability:SetCurrentCharges(charges - 1)
			else
				UTIL_RemoveImmediate(ability)
				--ability:RemoveSelf()
			end
		else
			NotifyUtil.ShowError(playerID,"#ablity_not")
		end
end


--随机增加人物已经拥有技能的数值
--通过技能使用，不是通过使用物品
--不需要杀敌数
function AddRandomMj3(keys)

	local caster = keys.caster
	local ability = keys.ability
	local playerID = caster:GetPlayerID()
	caster = PlayerUtil.GetHero(playerID)
	if not caster:IsRealHero() then 
		return 
	end
	
		local jnk ={}
		local x = 0
		for i=0,4 do
			if caster:GetAbilityByIndex(i) then
			local name = caster:GetAbilityByIndex(i):GetAbilityName()
				local name2 = string.sub(name,1,3)
				if name2 ~= "kjn" and  name2 ~= "yxt" then
					if name2 ~= "abi" then
						x =x +1
						jnk[x]=name
					end
				end
			end
		end
		if jnk[1]~=nil then
			local rd = RandomInt(1,#jnk)
			local name3 = jnk[rd]
			local name4 =  string.sub(name3,8,-2)
			RandomCiTiao(name4,playerID,caster,name3)
		end
	
end

