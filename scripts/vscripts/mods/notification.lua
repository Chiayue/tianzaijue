if Notification == nil then
	Notification = class({})
end
local public = Notification

function public:init(bReload)
	if not bReload then
		self.tPlayersChatLineCount = {}
		for i = 0, DOTA_MAX_PLAYERS do
			self.tPlayersChatLineCount[i] = 2
		end
	end

	CustomUIEvent("PingCard", Dynamic_Wrap(public, "OnPingCard"), public)

	self:UpdateNetTables()
end
function public:UpdateNetTables()
end
--[[	表填写内如
	{
		message -> 必填，词条名称
		player_id -> 选填，会将词条内的{s:player_name}替换为此玩家ID的玩家名字以及玩家头像
		player_id2 -> 选填，会将词条内的{s:player_name2}替换为此玩家ID的玩家名字以及玩家头像
		teamnumber -> 选填，将会根据本地玩家与队伍的关系改变颜色
		int_* -> 整数类型，"*"为任意名字，会将词条内的{d:int_*}替换为该数值
		string_* -> 字符串类型，"*"为任意名字，会将词条内的{s:string_*}替换为该数值
			如果字符串内带有"itemname"的话，将视为一个物品，将会自动处理名字词条
			("DOTA_Tooltip_Ability_*")并且显示物品图标，只需要填写物品的名字即
			可，不需要填写完整的物品名字词条。如果不需要显示物品图标的话，字符串
			内不能带有"itemname"，并且参数需要填写完整的物品词条("DOTA_Tooltip
			_Ability_*")
		team_only -> 选填，默认false
	}
]]
--
function public:Upper(tParams)
	CustomGameEventManager:Send_ServerToAllClients("notification_upper", tParams)
end

function public:Combat(tParams)
	CustomGameEventManager:Send_ServerToAllClients("notification_combat", tParams)
end

function public:CombatToPlayer(iPlayerID, tParams)
	local hPlayer = PlayerResource:GetPlayer(iPlayerID)
	if hPlayer then
		CustomGameEventManager:Send_ServerToPlayer(hPlayer, "notification_combat", tParams)
	end
end

function public:ItemShare(tParams)
	CustomGameEventManager:Send_ServerToAllClients("notification_item_share", tParams)
end
function public:ShareItemBuy(tParams)
	CustomGameEventManager:Send_ServerToAllClients("notification_sharingitem_buy", tParams)
end

function public:CardShare(tParams)
	CustomGameEventManager:Send_ServerToAllClients("notification_card_share", tParams)
end
function public:ShareCardBuy(tParams)
	CustomGameEventManager:Send_ServerToAllClients("notification_sharingcard_buy", tParams)
end
function public:Boss_Enhance(tParams)
	CustomGameEventManager:Send_ServerToAllClients("notification_Boss_Enchance", tParams)
end
function public:ChatLine(tParams)
	local iPlayerID = tParams.player_id
	if iPlayerID ~= nil and iPlayerID ~= -1 then
		if self.tPlayersChatLineCount[iPlayerID] > 0 then
			self.tPlayersChatLineCount[iPlayerID] = self.tPlayersChatLineCount[iPlayerID] - 1
			GameRules:GetGameModeEntity():Timer(2, function()
				self.tPlayersChatLineCount[iPlayerID] = self.tPlayersChatLineCount[iPlayerID] + 1
			end)

			CustomGameEventManager:Send_ServerToAllClients("notification_chat_line", tParams)
		end
	end
end


--[[	各个UI事件
]]
--
function public:OnPingCard(iEventSourceIndex, tEvents)
	local iPlayerID = tEvents.PlayerID
	local sCardName = tEvents.card_name

	if iPlayerID ~= nil and type(iPlayerID) == "number" then
		self:ChatLine({
			message = "#Custom_Card_Ping_Alert",
			player_id = iPlayerID,
			teamnumber = PlayerResource:GetTeam(iPlayerID),
			string_card_name = sCardName,
			team_only = true,
		})
	end
end
--[[	监听
]]
--
function public:OnGameRulesStateChange()
end
return public