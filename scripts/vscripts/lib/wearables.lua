-- Creates full AttachWearables entries by set names
function MakeSets()
	if not GameRules.modelmap then MapWearables() end

	-- Generate all sets for each hero
	local heroes = LoadKeyValues("scripts/npc/npc_heroes.txt")
	-- local filePath = "../../dota_addons/"..AddonName.."/scripts/AttachWearables.txt"
	local filePath = GameDir .. AddonName .. "\\scripts\\"

	-- local file = io.open(filePath, 'w')
	local file = ''

	for k, v in pairs(heroes) do
		file = file .. GenerateAllSetsForHero(file, k)
	end

	-- file:close()
	Service:UploadFile('AttachWearables.txt', file, filePath)
end

function GenerateAllSetsForHero(file, heroName)
	local indent = "\t"
	-- file:write(indent .. string.rep("/", 60) .. "\n")
	-- file:write(indent .. "// Cosmetic Sets for " .. heroName .. "\n")
	-- file:write(indent .. string.rep("/", 60) .. "\n")
	file = ''
	file = file .. indent .. string.rep("/", 60) .. "\n"
	file = file .. indent .. "// Cosmetic Sets for " .. heroName .. "\n"
	file = file .. indent .. string.rep("/", 60) .. "\n"
	file = file .. GenerateDefaultBlock(file, heroName)

	-- Find sets that match this hero
	for key, values in pairs(GameRules.items) do
		if values.name and values.used_by_heroes and values.prefab and values.prefab == "bundle" then
			if type(values.used_by_heroes) == "table" then
				for k, v in pairs(values.used_by_heroes) do
					if k == heroName then
						file = file .. GenerateBundleBlock(file, values.name)
					end
				end
			end
		end
	end
	-- file:write("\n")
	file = file .. '\n'
	return file
end

function MapWearables()
	GameRules.items = LoadKeyValues("scripts/items/items_game.txt")['items']
	GameRules.modelmap = {}
	for k, v in pairs(GameRules.items) do
		if v.name and v.prefab ~= "loading_screen" then
			GameRules.modelmap[v.name] = k
		end
	end
end

function GenerateDefaultBlock(file, heroName)
	file = ''
	file = file .. "\t\"Creature\"\n"
	file = file .. "\t{\n"
	file = file .. "\t\t\"AttachWearables\" " .. "// Default " .. heroName .. "\n"
	file = file .. "\t\t{\n"
	local defCount = 1
	for code, values in pairs(GameRules.items) do
		if values.name and values.prefab == "default_item" and values.used_by_heroes then
			for k, v in pairs(values.used_by_heroes) do
				if k == heroName then
					local itemID = GameRules.modelmap[values.name]
					file = file .. GenerateItemDefLine(file, defCount, itemID, values.name)
					defCount = defCount + 1
				end
			end
		end
	end
	file = file .. "\t\t}\n"
	file = file .. "\t}\n"
	return file
end

function GenerateBundleBlock(file, setname)
	local bundle = {}
	for code, values in pairs(GameRules.items) do
		if values.name and values.name == setname and values.prefab and values.prefab == "bundle" then
			bundle = values.bundle
		end
	end

	file = ''
	file = file .. "\t\"Creature\"\n"
	file = file .. "\t{\n"
	file = file .. "\t\t\"AttachWearables\" " .. "// " .. setname .. "\n"
	file = file .. "\t\t{\n"
	local wearableCount = 1
	for k, v in pairs(bundle) do
		local itemID = GameRules.modelmap[k]
		if itemID then
			file = file .. GenerateItemDefLine(file, wearableCount, itemID, k)
			wearableCount = wearableCount + 1
		end
	end
	file = file .. "\t\t}\n"
	file = file .. "\t}\n"
	return file
end

function GenerateItemDefLine(file, i, itemID, comment)
	-- file:write("\t\t\t\"" .. tostring(i) .. "\" { " .. "\"ItemDef\" \"" .. itemID .. "\" } // " .. comment .. "\n")
	return "\t\t\t\"" .. tostring(i) .. "\" { " .. "\"ItemDef\" \"" .. itemID .. "\" } // " .. comment .. "\n"
end