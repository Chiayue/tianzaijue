if not IsClient() then return end

if Activated == nil then
	_G.Activated = false
else
	_G.Activated = true
	for i = #GameEventListenerIDs, 1, -1 do
		StopListeningToGameEvent(GameEventListenerIDs[i])
	end
end
_G.GameEventListenerIDs = {}


function GameEvent(eventName, func, context)
	table.insert(GameEventListenerIDs, ListenToGameEvent(eventName, func, context))
end

require("lib/enum")
require("core.utils")
require("core.kv")
require("core/settings")
require("core/event")
require("core/Attribute/AttributeSystem")
require("core/NetEventData"):init(Activated)
require("modifiers/init")
require("abilities/init")
require("client/LocalParticle"):init(Activated)
require("client/js_get"):init(Activated)