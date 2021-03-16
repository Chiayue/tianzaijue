LinkLuaModifier("modifier_cmd_huskar_1", "abilities/commander/cmd_huskar/cmd_huskar_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_huskar_1 == nil then
	cmd_huskar_1 = class({})
end
function cmd_huskar_1:GetIntrinsicModifierName()
	return "modifier_cmd_huskar_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_huskar_1 == nil then
	modifier_cmd_huskar_1 = class({}, nil, eom_modifier)
end
function modifier_cmd_huskar_1:OnCreated(params)
	self.number = self:GetAbilitySpecialValueFor('number')
	if IsServer() then
	end
end
function modifier_cmd_huskar_1:OnRefresh(params)
	self.number = self:GetAbilitySpecialValueFor('number')
	if IsServer() then
	end
end
function modifier_cmd_huskar_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_cmd_huskar_1:IsHidden()
	return true
end
function modifier_cmd_huskar_1:EDeclareFunctions()
	return {
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ROUND_RESULT, self.OnRoundResult }
	}
end
function modifier_cmd_huskar_1:OnRoundResult(tEvent)
	local iCount = 0
	EachUnits(tEvent.PlayerID, function(hUnit)
		if not hUnit:IsAlive() then
			iCount = iCount + 1
		end
	end, UnitType.Building)
	local vDrop = self:GetParent():GetAbsOrigin()
	PlayerData:DropGold(tEvent.PlayerID, vDrop, iCount * self.number)
end