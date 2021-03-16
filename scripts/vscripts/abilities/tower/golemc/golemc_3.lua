LinkLuaModifier("modifier_golemC_3", "abilities/tower/golemC/golemC_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if golemC_3 == nil then
	golemC_3 = class({})
end
function golemC_3:GetIntrinsicModifierName()
	return "modifier_golemC_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_golemC_3 == nil then
	modifier_golemC_3 = class({}, nil, BaseModifier)
end
function modifier_golemC_3:OnCreated(params)
	if IsServer() then
	end
	AddModifierEvents(MODIFIER_EVENT_ON_DEATH, self, nil, self:GetParent())
end
function modifier_golemC_3:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_golemC_3:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_DEATH, self, nil, self:GetParent())
end
function modifier_golemC_3:DeclareFunctions()
	return {
	-- MODIFIER_EVENT_ON_DEATH,
	}
end
function modifier_golemC_3:OnDeath(params)
	if params.unit == self:GetParent() and self:GetParent():GetBuilding():GetUnitEntity() == self:GetParent() and GSManager:getStateType() == 30 then
		local iPlayerID = GetPlayerID(self:GetParent())
		HandSpellCards:AddCard(iPlayerID, "sp_golem")
		HandSpellCards:AddCard(iPlayerID, "sp_golem")
	end
end