local tLoads, bReload = ...
bReload = bReload or false
---各模块的load funtion
LoadedMods = {}
_G['LoadedMods'] = LoadedMods
local tList = load(tLoads.loadlist)()
for i, sPath in ipairs(tList) do
	local s = tLoads[sPath]
	s = ReplaceLoaderError(s, sPath)
	--初始化模块
	local func = load(s)
	LoadedMods[sPath] = func
	InitClass(bReload, func(sPath, bReload))
end