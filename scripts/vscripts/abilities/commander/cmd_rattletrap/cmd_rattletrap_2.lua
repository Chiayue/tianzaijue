LinkLuaModifier("modifier_cmd_rattletrap_2", "abilities/commander/cmd_rattletrap/cmd_rattletrap_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spell_mines", "abilities/spell/sp_mine.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_rattletrap_2 == nil then
	cmd_rattletrap_2 = class({})
end
function cmd_rattletrap_2:GetIntrinsicModifierName()
	return "modifier_cmd_rattletrap_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_rattletrap_2 == nil then
	modifier_cmd_rattletrap_2 = class({}, nil, eom_modifier)
end
function modifier_cmd_rattletrap_2:IsHidden()
	return true
end
function modifier_cmd_rattletrap_2:OnCreated(params)
	self.count = self:GetAbilitySpecialValueFor('count')
	if IsServer() then
	end
end
function modifier_cmd_rattletrap_2:OnRefresh(params)
	self.count = self:GetAbilitySpecialValueFor('count')
	if IsServer() then
	end
end
function modifier_cmd_rattletrap_2:OnDestroy()
	if IsServer() then
	end
end
function modifier_cmd_rattletrap_2:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_PREPARATION
	}
end
function modifier_cmd_rattletrap_2:OnPreparation()
	local hParent = self:GetParent()

	local iPlayerID = GetPlayerID(hParent)
	local hCommander = Commander:GetCommander(iPlayerID)
	if Spawner:IsBossRound(Spawner:GetRound() + 1) then
		local vCenter = Spawner.hBossMapPoint:GetAbsOrigin()
		local fHeight = 1800
		local fWidth = 1800
		local v1 = vCenter + Vector(fWidth / 2, fHeight / 2, 0)
		local v2 = vCenter + Vector(fWidth / 2, -fHeight / 2, 0)
		local v3 = vCenter + Vector(-fWidth / 2, fHeight / 2, 0)
		local v4 = vCenter + Vector(-fWidth / 2, -fHeight / 2, 0)
		-- DebugDrawLine(v1, v2, 255, 255, 255, true, 5)
		-- DebugDrawLine(v1, v3, 255, 255, 255, true, 5)
		-- DebugDrawLine(v4, v2, 255, 255, 255, true, 5)
		-- DebugDrawLine(v4, v3, 255, 255, 255, true, 5)
		for i = 1, self.count do
			-- 地雷单位
			local vMine = GetGroundPosition(GetRandomPositionInRectangle(v3, v1, v2, v4), hCommander)
			CreateModifierThinker(hCommander, self:GetAbility(), "modifier_spell_mines", {}, vMine, hCommander:GetTeamNumber(), false)
		end
	else
		local hEntPoint = Spawner.tTeamMapPoints[PlayerData:GetPlayerTeamID(iPlayerID)]
		local fHeight = 1800
		local fWidth = 1800
		-- 3	1
		-- 4	2
		local v1 = hEntPoint:GetAbsOrigin() + Vector(0, fHeight / 2, 0) + Vector(fWidth / 2, 0, 0)
		local v2 = hEntPoint:GetAbsOrigin() - Vector(0, -300, 0) + Vector(fWidth / 2, 0, 0)
		local v3 = hEntPoint:GetAbsOrigin() + Vector(0, fHeight / 2, 0) - Vector(fWidth / 2, 0, 0)
		local v4 = hEntPoint:GetAbsOrigin() - Vector(0, -300, 0) - Vector(fWidth / 2, 0, 0)
		-- DebugDrawLine(v1, v2, 255, 255, 255, true, 5)
		-- DebugDrawLine(v1, v3, 255, 255, 255, true, 5)
		-- DebugDrawLine(v4, v2, 255, 255, 255, true, 5)
		-- DebugDrawLine(v4, v3, 255, 255, 255, true, 5)
		for i = 1, self.count do
			-- 地雷单位
			local vMine = GetGroundPosition(GetRandomPositionInRectangle(v3, v1, v2, v4), hCommander)
			CreateModifierThinker(hCommander, self:GetAbility(), "modifier_spell_mines", {}, vMine, hCommander:GetTeamNumber(), false)
		end
	end
	hParent:EmitSound("Hero_Techies.LandMine.Plant")
	-- DotaTD:EachPlayer(function(_, iPlayerID)
	-- 	if PlayerData:IsPlayerDeath(iPlayerID) then return end
	-- 	local hEntPoint = Spawner.tTeamMapPoints[PlayerData:GetPlayerTeamID(iPlayerID)]
	-- 	local hCommander = Commander:GetCommander(iPlayerID)
	-- 	local fHeight = 1800
	-- 	local fWidth = 1800
	-- 	-- 3	1
	-- 	-- 4	2
	-- 	local v1 = hEntPoint:GetAbsOrigin() + Vector(0, fHeight / 2, 0) + Vector(fWidth / 2, 0, 0)
	-- 	local v2 = hEntPoint:GetAbsOrigin() - Vector(0, -300, 0) + Vector(fWidth / 2, 0, 0)
	-- 	local v3 = hEntPoint:GetAbsOrigin() + Vector(0, fHeight / 2, 0) - Vector(fWidth / 2, 0, 0)
	-- 	local v4 = hEntPoint:GetAbsOrigin() - Vector(0, -300, 0) - Vector(fWidth / 2, 0, 0)
	-- 	-- DebugDrawLine(v1, v2, 255, 255, 255, true, 5)
	-- 	-- DebugDrawLine(v1, v3, 255, 255, 255, true, 5)
	-- 	-- DebugDrawLine(v4, v2, 255, 255, 255, true, 5)
	-- 	-- DebugDrawLine(v4, v3, 255, 255, 255, true, 5)
	-- 	for i = 1, self.count do
	-- 		-- 地雷单位
	-- 		local vMine = GetGroundPosition(GetRandomPositionInRectangle(v3, v1, v2, v4), hCommander)
	-- 		CreateModifierThinker(hCommander, self:GetAbility(), "modifier_spell_mines", {}, vMine, hCommander:GetTeamNumber(), false)
	-- 	end
	-- 	hParent:EmitSound("Hero_Techies.LandMine.Plant")
	-- end, UnitType.Building)
end