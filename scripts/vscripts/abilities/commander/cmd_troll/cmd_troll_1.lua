LinkLuaModifier("modifier_cmd_troll_1", "abilities/commander/cmd_troll/cmd_troll_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_troll_1_buff", "abilities/commander/cmd_troll/cmd_troll_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_troll_1 == nil then
	cmd_troll_1 = class({})
end
function cmd_troll_1:GetIntrinsicModifierName()
	return "modifier_cmd_troll_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_troll_1 == nil then
	modifier_cmd_troll_1 = class({}, nil, eom_modifier)
end
function modifier_cmd_troll_1:OnCreated(params)
	self:UpdateValues()
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_cmd_troll_1:IsHidden()
	return true
end
function modifier_cmd_troll_1:OnRefresh(params)
	self:UpdateValues()
end
function modifier_cmd_troll_1:UpdateValues()
end
function modifier_cmd_troll_1:OnIntervalThink()
	if IsServer() then
		if IsValid(self:GetAbility()) then
			local hCaster = self:GetCaster()
			EachUnits(iPlayerID, function(hUnit)
				if not hUnit:HasModifier('modifier_cmd_troll_1_buff') then
					hUnit:AddNewModifier(hCaster, self:GetAbility(), 'modifier_cmd_troll_1_buff', {})
				end
			end, UnitType.Building)
		end
	end
end
function modifier_cmd_troll_1:OnDestroy()
	if IsServer() then
	end
end

---------------------------------------------------------------------
--Modifiers
if modifier_cmd_troll_1_buff == nil then
	modifier_cmd_troll_1_buff = class({}, nil, eom_modifier)
end
function modifier_cmd_troll_1_buff:OnCreated(params)
	self.attack_speed_bonus = self:GetAbilitySpecialValueFor('attack_speed_bonus')
	if IsServer() then
	end
end
function modifier_cmd_troll_1_buff:OnRefresh(params)
	self.attack_speed_bonus = self:GetAbilitySpecialValueFor('attack_speed_bonus')
	if IsServer() then
	end
end
function modifier_cmd_troll_1_buff:EDeclareFunctions()
	return {
		[EMDF_ATTACKT_SPEED_BONUS] = self.attack_speed_bonus,
	}
end
function modifier_cmd_troll_1_buff:DeclareFunctions()
	return	{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_cmd_troll_1_buff:OnTooltip()
	return self.attack_speed_bonus
end