if SpawnSystem == nil then
	SpawnSystem = {}
end

function SpawnSystem:InitSpawn()
	SpawnSystem.herolist={}
	local loadtext= LoadKeyValues("scripts/npc/activelist.txt")
	for k,v in pairs(loadtext) do
        if v == 1 then
            table.insert(SpawnSystem.herolist,k)
        end
    end
	local loadtext= LoadKeyValues("scripts/customshops.txt")
	CustomNetTables:SetTableValue( "custom_shop", "shop", loadtext )
end
SpawnSystem:InitSpawn()