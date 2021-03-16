LinkLuaModifier("modifier_cmd_enchantress_1", "abilities/commander/cmd_enchantress/cmd_enchantress_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_enchantress_1 == nil then
	cmd_enchantress_1 = class({})
end
function cmd_enchantress_1:GetIntrinsicModifierName()
	return "modifier_cmd_enchantress_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_enchantress_1 == nil then
	modifier_cmd_enchantress_1 = class({}, nil, eom_modifier)
end
function modifier_cmd_enchantress_1:OnCreated(params)
	self.interval = self:GetAbilitySpecialValueFor('interval')
	self.gold = self:GetAbilitySpecialValueFor('gold')
	self.initTime = 0
	if IsServer() then
	end
end
function modifier_cmd_enchantress_1:OnRefresh(params)
	self.interval = self:GetAbilitySpecialValueFor('interval')
	self.gold = self:GetAbilitySpecialValueFor('gold')
	if IsServer() then
	end
end
function modifier_cmd_enchantress_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_cmd_enchantress_1:IsHidden()
	return true
end
function modifier_cmd_enchantress_1:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ROUND_RESULT, self.OnRoundResult }
	}
end
function modifier_cmd_enchantress_1:OnRoundResult(tEvent)
	local iRound = Spawner:GetRound()
	if tEvent.is_win == 1 then
		local fTime = Spawner:GetRoundBattleTime(iRound) - GameRules:GetGameTime() + self.initTime
		local iPlayerID = GetPlayerID(self:GetParent())
		if fTime > self.interval then
			local goldTiems = math.floor(fTime / self.interval)
			local vDrop = self:GetParent():GetAbsOrigin()
			PlayerData:DropGold(iPlayerID, vDrop, self.gold * goldTiems)
		end
	end
end
function modifier_cmd_enchantress_1:OnInBattle()
	self.initTime = GameRules:GetGameTime()
end