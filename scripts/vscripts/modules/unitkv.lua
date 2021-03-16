local m = {}

---所有activelist里的英雄信息
--{
--	heroName={primary=1力量/2敏捷/3智力,talent=abilityName}
--}
local all_hero = {}

---限制英雄，特定玩家才有
local restrictiveHeroes = {
	["npc_dota_hero_hoodwink"] = true,
	["npc_dota_hero_dark_willow"] = true
}

---单位特定的activity modifier
--部分单位使用英雄模型的时候不能正常播放动作，需要添加activity modifier才行。
--先去dota的英雄文件中找到相应英雄的modifier，然后在单位的kv中添加属性“activity_modifiers”，值是要添加的modifier，有多个的话用英文的逗号隔开
--dota的modifier默认会根据单位数据动态变化（比如攻击的在不同的攻击速度下modifier就不一样），这里就简单只取其中一组数据即可
local activityModifiers = {}

---部分单位使用英雄模型的时候不能正常播放动作，需要添加activity modifier才行。
--先去dota的英雄文件中找到相应英雄的modifier，然后在单位的kv中添加属性“activity_modifiers”，值是要添加的modifier，有多个的话用英文的逗号隔开
function m.AddActivityModifier(unit)
	if EntityIsNull(unit) then
		return;
	end
	local modifiers = activityModifiers[unit:GetUnitName()];
	if modifiers then
		for key, modifier in pairs(modifiers) do
			unit:AddActivityModifier(modifier)
		end
	end
end

---获取所有启用的英雄，返回一个表（非副本，不要修改）:<br>
--{
--	heroName={primary=1力量/2敏捷/3智力,talent=abilityName}
--}
function m.GetAllActiveHeroes()
	return all_hero
end

function m.GetRestrictHeroes()
	return restrictiveHeroes
end


---返回一个表（非副本，不要修改）
--{primary=1力量/2敏捷/3智力,talent=abilityName}
function m.GetHeroData(heroName)
	return all_hero[heroName]
end

---获得英雄天赋技能名称
function m.GetHeroTalent(heroName)
	if heroName then
		local hero = all_hero[heroName];
		return hero and hero.talent
	end
end

---获得指定英雄的主属性类型：1=力量，2=敏捷，3=智力。找不到返回nil
function m.GetHeroPrimaryAttribute(heroName)
	if heroName then
		local hero = all_hero[heroName];
		return hero and hero.primary
	end
end

---获取某个主属性的所有英雄名字
--@param #number primaryType 主属性类型。 1=力量，2=敏捷，3=智力
function m.GetHeroesWithPrimary(primaryType)
	if primaryType then
		local result = {}
		for heroName, hero in pairs(all_hero) do
			if hero.primary == primaryType then
				table.insert(result,heroName)
			end
		end
		return result;
	end
end

local init = function()
	local units = LoadKeyValues("scripts/npc/npc_units_custom.txt")
	for unitName, unit in pairs(units) do
		if unit.activity_modifiers then
			activityModifiers[unitName] = Split(unit.activity_modifiers,",")
		end
	end
	
	local heroes = LoadKeyValues("scripts/npc/npc_heroes_custom.txt")
	local activeList = LoadKeyValues("scripts/npc/activelist.txt")
	for unitName, unit in pairs(heroes) do
		if unit.override_hero and activeList[unit.override_hero] == 1 then
			
			local hero = {}
			
			all_hero[unit.override_hero] = hero
			
			local primary = unit.AttributePrimary
			if primary == "DOTA_ATTRIBUTE_STRENGTH" then
				hero.primary = 1
			elseif primary == "DOTA_ATTRIBUTE_AGILITY" then
				hero.primary = 2
			elseif primary == "DOTA_ATTRIBUTE_INTELLECT" then
				hero.primary = 3
			end
			
			if unit.Ability1 ~= "" then
				hero.talent = unit.Ability1
			end
		end
	end
end

init()
return m