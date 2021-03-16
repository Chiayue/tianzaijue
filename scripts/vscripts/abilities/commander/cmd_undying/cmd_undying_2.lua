LinkLuaModifier("modifier_cmd_undying_2", "abilities/commander/cmd_undying/cmd_undying_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_undying_2 == nil then
	cmd_undying_2 = class({})
end
function cmd_undying_2:GetIntrinsicModifierName()
	return "modifier_cmd_undying_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_undying_2 == nil then
	modifier_cmd_undying_2 = class({}, nil, eom_modifier)
end
function modifier_cmd_undying_2:OnCreated(params)
	self.max_hp_pct = self:GetAbilitySpecialValueFor("max_hp_pct")
	if IsServer() then
	end
end
function modifier_cmd_undying_2:OnRefresh(params)
	self.max_hp_pct = self:GetAbilitySpecialValueFor("max_hp_pct")
	if IsServer() then
	end
end
function modifier_cmd_undying_2:OnDestroy()
	if IsServer() then
	end
end
function modifier_cmd_undying_2:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end
function modifier_cmd_undying_2:OnAttackLanded(params)
	if not IsValid(params.target) or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() or self:GetParent() == params.attacker:GetSummoner() then
		local flHealAmount = self:GetParent():GetMaxHealth() * self.max_hp_pct * 0.01
		DotaTD:EachPlayer(function(_, iPlayerID)
			EachUnits(iPlayerID, function(hUnit)
				hUnit:Heal(flHealAmount, self:GetAbility())
			end, UnitType.AllFirends)
		end, UnitType.Building)
	end
end
function modifier_cmd_undying_2:IsHidden()
	return true
end