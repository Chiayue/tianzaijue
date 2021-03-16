LinkLuaModifier("modifier_cmd_huskar_4", "abilities/commander/cmd_huskar/cmd_huskar_4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_huskar_4_missles", "abilities/commander/cmd_huskar/cmd_huskar_4.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_huskar_4 == nil then
	cmd_huskar_4 = class({})
end
function cmd_huskar_4:GetIntrinsicModifierName()
	return "modifier_cmd_huskar_4"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_huskar_4 == nil then
	modifier_cmd_huskar_4 = class({}, nil, eom_modifier)
end
function modifier_cmd_huskar_4:IsHidden()
	return true
end
function modifier_cmd_huskar_4:OnCreated(params)
	self.number = self:GetAbilitySpecialValueFor("number")
	self.trigger_count = self:GetAbilitySpecialValueFor("trigger_count")
	if IsServer() then

	end
end
function modifier_cmd_huskar_4:OnRefresh(params)
	self.number = self:GetAbilitySpecialValueFor("number")
	self.trigger_count = self:GetAbilitySpecialValueFor("trigger_count")
	if IsServer() then
	end
end
function modifier_cmd_huskar_4:OnDestroy()
	if IsServer() then
	end
end
function modifier_cmd_huskar_4:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_PLAYER_USE_SPELL,
	}
end
function modifier_cmd_huskar_4:OnHeroUseSpell(params)
	if params.iPlayerID == GetPlayerID(self:GetParent()) then
		self:IncrementStackCount()
		if self:GetStackCount() >= self.trigger_count then
			self:SetStackCount(0)
			EachUnits(params.iPlayerID, function(hUnit)
				hUnit:Heal(hUnit:GetMaxHealth() * self.number * 0.01, self:GetAbility())
				local iParticleID = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_fall20_immortal/jugg_fall20_immortal_healing_ward_death.vpcf", PATTACH_ABSORIGIN, hUnit)
				ParticleManager:ReleaseParticleIndex(iParticleID)
			end, UnitType.AllFirends)
		end
	end
end