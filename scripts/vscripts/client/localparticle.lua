-- 针对帧率影响
PARTICLE_DETAIL_LEVEL_ULTRA = 4 -- 默认，不隐藏的特效
PARTICLE_DETAIL_LEVEL_HIGH = 3 -- 关键特效 帧数特低于10帧隐藏
PARTICLE_DETAIL_LEVEL_MEDIUM = 2 -- 中等关键特效 帧数低于15帧隐藏
PARTICLE_DETAIL_LEVEL_LOW = 1 -- 不关键特效 帧数低于30帧隐藏
PARTICLE_DETAIL_LEVEL_NONE = 0
MAX_PARTICLES = 512 -- 记录的特效数量

if nil == LocalParticle then
	---@class LocalParticle
	LocalParticle = {}
	LocalParticle = class({}, LocalParticle)
end
---@type LocalParticle
local public = LocalParticle

function public:init(bReload)
	if not bReload then
		_G.bShowOtherPlayerParticle = false
		_G.tOtherPlayerParticles = {}
		_G.tPlayerParticles = {
			[PARTICLE_DETAIL_LEVEL_ULTRA] = {},
			[PARTICLE_DETAIL_LEVEL_HIGH] = {},
			[PARTICLE_DETAIL_LEVEL_MEDIUM] = {},
			[PARTICLE_DETAIL_LEVEL_LOW] = {},
		}
		_G.fFPS = 240
	end

	GameEvent("custom_toggle_show_other_player_particle", OnToggleShowOtherPlayerParticle, nil)
	GameEvent("custom_update_fps", OnUpdateFPS, nil)
end


function OnUpdateFPS(tEvents)
	_G.fFPS = tEvents.fps
end
function OnToggleShowOtherPlayerParticle(tEvents)
	-- 针对其他玩家特效，无视帧率影响
	bShowOtherPlayerParticle = tEvents.flag == 1
	if bShowOtherPlayerParticle == false then
		for _, iParticleID in ipairs(tOtherPlayerParticles) do
			ParticleManager:DestroyParticle(iParticleID, true)
		end
		_G.tOtherPlayerParticles = {}
	end
end

function LocalPlayerParticle(iPlayerID, func, iLevel)
	local iLocalPlayerID = GetLocalPlayerID()
	if bShowOtherPlayerParticle == false and iPlayerID ~= iLocalPlayerID then
		return
	end
	local iPreventionLevel = PARTICLE_DETAIL_LEVEL_NONE
	if fFPS <= 30 and fFPS > 20 then
		iPreventionLevel = PARTICLE_DETAIL_LEVEL_LOW
	elseif fFPS <= 20 and fFPS > 10 then
		iPreventionLevel = PARTICLE_DETAIL_LEVEL_MEDIUM
	elseif fFPS < 10 then
		iPreventionLevel = PARTICLE_DETAIL_LEVEL_HIGH
	end
	if iLevel <= iPreventionLevel then
		for i = iPreventionLevel, PARTICLE_DETAIL_LEVEL_NONE + 1, -1 do
			for _, iParticleID in ipairs(tPlayerParticles[i]) do
				ParticleManager:DestroyParticle(iParticleID, true)
			end
			_G.tPlayerParticles[i] = {}
		end
		return
	end
	if type(func) == "function" then
		local iParticleID = func()
		if type(iParticleID) == "number" then
			if iPlayerID ~= iLocalPlayerID then
				table.insert(tOtherPlayerParticles, iParticleID)
				if #tOtherPlayerParticles > MAX_PARTICLES then
					table.remove(tOtherPlayerParticles, 1)
				end
			end
			table.insert(tPlayerParticles[iLevel], iParticleID)
			if #tPlayerParticles[iLevel] > MAX_PARTICLES then
				table.remove(tPlayerParticles[iLevel], 1)
			end
		end
	end
end

function LocalPlayerAbilityParticle(hAbility, func, iLevel)
	if not IsValid(hAbility) then return end
	if iLevel == nil then iLevel = PARTICLE_DETAIL_LEVEL_ULTRA end
	local hCaster = hAbility:GetCaster()
	if not IsValid(hCaster) then return end
	local iPlayerID = hCaster:GetPlayerOwnerID()
	LocalPlayerParticle(iPlayerID, func, iLevel)
end

return public