local m = {}

local allData = {}


function m.LoadData()
	local params = PlayerUtil.GetAllAccount(true,true)
	params.mode = 1
	params.exp_count = 100
	params.equip_count = 100
	params.equip_type = "wq,fj,ss,ts"

	SrvHttp.load("tzj_rank",params,function(srv_data)
		if srv_data then
			allData = srv_data
			m.SendToClient()
			
--			dumpTable(allData,"tzj_rank")
		end
	end)
end

function m.SendToClient(PlayerID)
	if PlayerUtil.IsValidPlayer(PlayerID) then
		SendToClient(PlayerID,"tzj_ranklist_update",allData)
	else
		SendToAllClient("tzj_ranklist_update",allData)
	end
end


function m.Client_Init(_,keys)
	m.SendToClient(keys.PlayerID)
end

RegisterEventListener("tzj_ranklist_init",m.Client_Init)
return m;