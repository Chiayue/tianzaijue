LinkLuaModifier("modifier_cmd_huskar_6", "abilities/commander/cmd_huskar/cmd_huskar_6.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_huskar_6 == nil then
	cmd_huskar_6 = class({})
end
function cmd_huskar_6:GetIntrinsicModifierName()
	return "modifier_cmd_huskar_6"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_huskar_6 == nil then
	modifier_cmd_huskar_6 = class({}, nil, eom_modifier)
end
function modifier_cmd_huskar_6:OnCreated(params)
	self.number = self:GetAbilitySpecialValueFor('number')
	if IsServer() then
	end
end
function modifier_cmd_huskar_6:OnRefresh(params)
	self.number = self:GetAbilitySpecialValueFor('number')
	if IsServer() then
	end
end
function modifier_cmd_huskar_6:OnDestroy()
	if IsServer() then
	end
end
function modifier_cmd_huskar_6:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_cmd_huskar_6:OnBattleEnd()
	local iPlayerID = GetPlayerID(self:GetParent())
	local vDrop = self:GetParent():GetAbsOrigin()
	local iCrystal = 0
	EachUnits(iPlayerID, function(hUnit)
		if not hUnit:IsAlive() then
			iCrystal = iCrystal + 1 * self.number
		end
	end, UnitType.Building)
	PlayerData:DropCrystal(iPlayerID, vDrop, iCrystal)
end
function modifier_cmd_huskar_6:IsHidden()
	return true
end