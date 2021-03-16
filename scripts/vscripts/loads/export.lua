--导出JSON数据
--用于 PHP Call Lua 获取需加载文件数据
local sPath = ...
local tLoads = require('loads/loadlist')
local function file2str(sFile)
    local file = io.open(sPath .. '/' .. sFile .. ".lua", 'r')
    local s = file:read('*a')
    file:close()
    return s
end
for k, v in ipairs(tLoads) do
    tLoads[v] = file2str(v)
    tLoads[k] = nil
end
tLoads.main = file2str('loads/main')
tLoads.loadlist = file2str('loads/loadlist')
return require('lib/dkjson').encode(tLoads)