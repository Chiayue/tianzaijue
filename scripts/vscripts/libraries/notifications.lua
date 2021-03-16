--notify_VERSION = "1.00"

--[[
  Sample Panorama notify Library by BMD
  Installation
  -"require" this file inside your code in order to gain access to the notify class for sending notify to players, teams, or all clients.
  -Ensure that you have the barebones_notify.xml, barebones_notify.js, and barebones_notify.css files in your panorama content folder.
  -Ensure that barebones_notify.xml is included in your custom_ui_manifest.xml with
    <CustomUIElement type="Hud" layoutfile="file://{resources}/layout/custom_game/barebones_notify.xml" />
  Usage
  -notify can be sent to the Top or Bottom notification panel of an individual player, a whole team, or all clients at once.
  -notify can be sent in pieces consisting of Labels, Images, HeroImages, and AbilityImages.
  -notify are specified by a table which has 4 potential parameters:
    -duration: The duration to display the notification for on screen.  Ignored for a notification which "continues" a previous notification line.
    -class: An optional (leave as nil for default) string which will be used as the class to add to the notification piece.
    -style: An optional (leave as nil for default) table of css properties to add to this notification, such as {["font-size"]="60px", color="green"}.
    -continue: An optional (leave as nil for false) boolean which tells the notification system to add this notification to the current notification line if 'true'.  
      This lets you place multiple individual notification pieces on the same overall notification.
  -For Labels, there is one additional mandatory parameter:
    -text:  The text to display in the notification.  Can provide localization tokens ("#addonname") or non-localized text.
  -For HeroImages, there is two additional parameters:
    -hero:  (Mandatory) The hero name, e.g. "npc_dota_hero_axe".
    -imagestyle:  (Optional)  The image style to display for this hero image.  Default when 'nil' is 'icon'.  'portrait' and 'landscape' are two other options.
  -For AboilityImages, there is one additional mandatory parameter:
    -ability:  The ability name, e.g. "lina_fiery_soul".
  -For Images, there is one additional mandatory parameter:
    -image:  The image src string, e.g. "file://{images}/status_icons/dota_generic.psd".
  -For ItemImages, there is one additional mandatory parameter:
    -item:  The item name, e.g. "item_force_staff".
  -notify can be removed from the Top/Bottom or cleared
  -Call the notify:Top, notify:TopToAll, or notify:TopToTeam to send a top-area notification to the appropriate players 
  -Call the notify:Bottom, notify:BottomToAll, or notify:BottomToTeam to send a bottom-area notify to the appropriate players 
  -Call the notify:ClearTop, notify:ClearTopFromAll, or notify:ClearTopFromTeam to clear all existing top-area notify from appropriate players
  -Call the notify:ClearBottom, notify:ClearBottomFromAll, or notify:ClearBottomFromTeam to clear all existing bottom-area notify from appropriate players
  -Call the notify:RemoveTop, notify:RemoveTopFromAll, or notify:RemoveTopFromTeam to remove all existing top-area notify from appropriate players up to the provided count of notify
  -Call the notify:RemoveBottom, notify:RemoveBottomFromAll, or notify:RemoveBottomFromTeam to remove all existing bottom-area notify from appropriate players up to the provided count of notify
  
  Examples:
  -- Send a notification to all players that displays up top for 5 seconds
  notify:TopToAll({text="Top Notification for 5 seconds ", duration=5.0})
  -- Send a notification to playerID 0 which will display up top for 9 seconds and be green, on the same line as the previous notification
  notify:Top(0, {text="GREEEENNNN", duration=9, style={color="green"}, continue=true})
  -- Display 3 styles of hero icons on the same line for 5 seconds.
  notify:TopToAll({hero="npc_dota_hero_axe", duration=5.0})
  notify:TopToAll({hero="npc_dota_hero_axe", imagestyle="landscape", continue=true})
  notify:TopToAll({hero="npc_dota_hero_axe", imagestyle="portrait", continue=true})
  -- Display a generic image and then 2 ability icons and an item on the same line for 5 seconds
  notify:TopToAll({image="file://{images}/status_icons/dota_generic.psd", duration=5.0})
  notify:TopToAll({ability="nyx_assassin_mana_burn", continue=true})
  notify:TopToAll({ability="lina_fiery_soul", continue=true})
  notify:TopToAll({item="item_force_staff", continue=true})
  -- Send a notification to all players on radiant (GOODGUYS) that displays near the bottom of the screen for 10 seconds to be displayed with the NotificationMessage class added
  notify:BottomToTeam(DOTA_TEAM_GOODGUYS, {text="AAAAAAAAAAAAAA", duration=10, class="NotificationMessage"})
  -- Send a notification to player 0 which will display near the bottom a large red notification with a solid blue border for 5 seconds
  notify:Bottom(PlayerResource:GetPlayer(0), {text="Super Size Red", duration=5, style={color="red", ["font-size"]="110px", border="10px solid blue"}})
  -- Remove 1 bottom and 2 top notify 2 seconds later
  Timers:CreateTimer(2,function()
    notify:RemoveTop(0, 2)
    notify:RemoveBottomFromTeam(DOTA_TEAM_GOODGUYS, 1)
    -- Add 1 more notification to the bottom
    notify:BottomToAll({text="GREEEENNNN again", duration=9, style={color="green"}})
  end)
  -- Clear all notify from the bottom
  Timers:CreateTimer(7, function()
    notify:ClearBottomFromAll()
  end)
]]
local notify = {}

function notify:ClearTop(player,value)
	if not value then
		value = 50
	end
	notify:RemoveTop(player, value)
end

---value可以是字符串或者数字，数字的话表示要清除多少条信息
--字符串的话，表示要清除内容是该字符串的所有内容
function notify:ClearBottom(player,value)
	if not value then
		value = 50
	end
	notify:RemoveBottom(player, value)
end


function notify:ClearTopFromAll(value)
	if not value then
		value = 50
	end
	notify:RemoveTopFromAll(value)
end

---value可以是字符串或者数字，数字的话表示要清除多少条信息
--字符串的话，表示要清除内容是该字符串的所有内容
function notify:ClearBottomFromAll(value)
	if not value then
		value = 50
	end
	notify:RemoveBottomFromAll(value)
end

function notify:ClearTopFromTeam(team)
	notify:RemoveTopFromTeam(team, 50)
end

function notify:ClearBottomFromTeam(team)
	notify:RemoveBottomFromTeam(team, 50)
end


function notify:RemoveTop(player, value)
	if type(player) == "number" then
		player = PlayerResource:GetPlayer(player)
	end
	
	local data = {}
	if type(value) == "number" then
		data.count = value
	elseif type(value) == "string" then
		data.text = value
	end

	CustomGameEventManager:Send_ServerToPlayer(player, "top_remove_notification", data)
end

function notify:RemoveBottom(player, value)
	if type(player) == "number" then
		player = PlayerResource:GetPlayer(player)
	end

	local data = {}
	if type(value) == "number" then
		data.count = value
	elseif type(value) == "string" then
		data.text = value
	end

	CustomGameEventManager:Send_ServerToPlayer(player, "bottom_remove_notification", data)
end

function notify:RemoveTopFromAll(value)
	local data = {}
	if type(value) == "number" then
		data.count = value
	elseif type(value) == "string" then
		data.text = value
	end
	CustomGameEventManager:Send_ServerToAllClients("top_remove_notification", data)
end

function notify:RemoveBottomFromAll(value)
	local data = {}
	if type(value) == "number" then
		data.count = value
	elseif type(value) == "string" then
		data.text = value
	end
	CustomGameEventManager:Send_ServerToAllClients("bottom_remove_notification", data)
end

function notify:RemoveTopFromTeam(team, count)
	CustomGameEventManager:Send_ServerToTeam(team, "top_remove_notification", {count=count} )
end

function notify:RemoveBottomFromTeam(team, count)
	CustomGameEventManager:Send_ServerToTeam(team, "bottom_remove_notification", {count=count})
end


function notify:Top(player, table)
	if type(player) == "number" then
		player = PlayerResource:GetPlayer(player)
	end

	if table.text ~= nil then
		CustomGameEventManager:Send_ServerToPlayer(player, "top_notification", {text=table.text, duration=table.duration, class=table.class, style=table.style, continue=table.continue,fmtKV=table.fmtKV} )
	elseif table.hero ~= nil then
		CustomGameEventManager:Send_ServerToPlayer(player, "top_notification", {hero=table.hero, imagestyle=table.imagestyle, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	elseif table.image ~= nil then
		CustomGameEventManager:Send_ServerToPlayer(player, "top_notification", {image=table.image, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	elseif table.ability ~= nil then
		CustomGameEventManager:Send_ServerToPlayer(player, "top_notification", {ability=table.ability, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	elseif table.item ~= nil then
		CustomGameEventManager:Send_ServerToPlayer(player, "top_notification", {item=table.item, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	else
		CustomGameEventManager:Send_ServerToPlayer(player, "top_notification", {text="No TEXT provided.", duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	end
end

function notify:TopToAll(table)
	if table.text ~= nil then
		CustomGameEventManager:Send_ServerToAllClients("top_notification", {text=table.text, duration=table.duration, class=table.class, style=table.style, continue=table.continue,fmtKV=table.fmtKV} )
	elseif table.hero ~= nil then
		CustomGameEventManager:Send_ServerToAllClients("top_notification", {hero=table.hero, imagestyle=table.imagestyle, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	elseif table.image ~= nil then
		CustomGameEventManager:Send_ServerToAllClients("top_notification", {image=table.image, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	elseif table.ability ~= nil then
		CustomGameEventManager:Send_ServerToAllClients("top_notification", {ability=table.ability, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	elseif table.item ~= nil then
		CustomGameEventManager:Send_ServerToAllClients("top_notification", {item=table.item, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	else
		CustomGameEventManager:Send_ServerToAllClients("top_notification", {text="No TEXT provided.", duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	end
end

function notify:TopToTeam(team, table)
	if table.text ~= nil then
		CustomGameEventManager:Send_ServerToTeam(team, "top_notification", {text=table.text, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	elseif table.hero ~= nil then
		CustomGameEventManager:Send_ServerToTeam(team, "top_notification", {hero=table.hero, imagestyle=table.imagestyle, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	elseif table.image ~= nil then
		CustomGameEventManager:Send_ServerToTeam(team, "top_notification", {image=table.image, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	elseif table.ability ~= nil then
		CustomGameEventManager:Send_ServerToTeam(team, "top_notification", {ability=table.ability, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	elseif table.item ~= nil then
		CustomGameEventManager:Send_ServerToTeam(team, "top_notification", {item=table.item, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	else
		CustomGameEventManager:Send_ServerToTeam(team, "top_notification", {text="No TEXT provided.", duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	end
end


function notify:Bottom(player, table)
	if type(player) == "number" then
		player = PlayerResource:GetPlayer(player)
	end

	if table.text ~= nil then
		CustomGameEventManager:Send_ServerToPlayer(player, "bottom_notification", {text=table.text, duration=table.duration, class=table.class, style=table.style, continue=table.continue,error=table.error,fmtKV=table.fmtKV} )
	elseif table.hero ~= nil then
		CustomGameEventManager:Send_ServerToPlayer(player, "bottom_notification", {hero=table.hero, imagestyle=table.imagestyle, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	elseif table.image ~= nil then
		CustomGameEventManager:Send_ServerToPlayer(player, "bottom_notification", {image=table.image, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	elseif table.ability ~= nil then
		CustomGameEventManager:Send_ServerToPlayer(player, "bottom_notification", {ability=table.ability, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	elseif table.item ~= nil then
		CustomGameEventManager:Send_ServerToPlayer(player, "bottom_notification", {item=table.item, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	else
		CustomGameEventManager:Send_ServerToPlayer(player, "bottom_notification", {text="No TEXT provided.", duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	end
end

function notify:BottomToAll(table)
	if table.text ~= nil then
		CustomGameEventManager:Send_ServerToAllClients("bottom_notification", {text=table.text, duration=table.duration, class=table.class, style=table.style, continue=table.continue,error=table.error,fmtKV=table.fmtKV} )
	elseif table.hero ~= nil then
		CustomGameEventManager:Send_ServerToAllClients("bottom_notification", {hero=table.hero, imagestyle=table.imagestyle, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	elseif table.image ~= nil then
		CustomGameEventManager:Send_ServerToAllClients("bottom_notification", {image=table.image, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	elseif table.ability ~= nil then
		CustomGameEventManager:Send_ServerToAllClients("bottom_notification", {ability=table.ability, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	elseif table.item ~= nil then
		CustomGameEventManager:Send_ServerToAllClients("bottom_notification", {item=table.item, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	else
		CustomGameEventManager:Send_ServerToAllClients("bottom_notification", {text="No TEXT provided.", duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	end
end

function notify:BottomToTeam(team, table)
	if table.text ~= nil then
		CustomGameEventManager:Send_ServerToTeam(team, "bottom_notification", {text=table.text, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	elseif table.hero ~= nil then
		CustomGameEventManager:Send_ServerToTeam(team, "bottom_notification", {hero=table.hero, imagestyle=table.imagestyle, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	elseif table.image ~= nil then
		CustomGameEventManager:Send_ServerToTeam(team, "bottom_notification", {image=table.image, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	elseif table.ability ~= nil then
		CustomGameEventManager:Send_ServerToTeam(team, "bottom_notification", {ability=table.ability, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	elseif table.item ~= nil then
		CustomGameEventManager:Send_ServerToTeam(team, "bottom_notification", {item=table.item, duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	else
		CustomGameEventManager:Send_ServerToTeam(team, "bottom_notification", {text="No TEXT provided.", duration=table.duration, class=table.class, style=table.style, continue=table.continue} )
	end
end

return notify;
