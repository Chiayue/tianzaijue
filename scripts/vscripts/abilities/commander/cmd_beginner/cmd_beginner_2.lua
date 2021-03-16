LinkLuaModifier("modifier_cmd_beginner_2", "abilities/commander/cmd_beginner/cmd_beginner_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("cmd_beginner_2_buff", "abilities/commander/cmd_beginner/cmd_beginner_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_beginner_2 == nil then
	cmd_beginner_2 = class({})
end
function cmd_beginner_2:GetIntrinsicModifierName()
	return "modifier_cmd_beginner_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_beginner_2 == nil then
	modifier_cmd_beginner_2 = class({}, nil, eom_modifier)
end
function modifier_cmd_beginner_2:IsHidden()
	return true
end
function modifier_cmd_beginner_2:OnCreated(params)
	self:UpdateValues()
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_cmd_beginner_2:OnRefresh(params)
	self:UpdateValues()
end
function modifier_cmd_beginner_2:UpdateValues()
	self.manaregen_bonus = self:GetAbilitySpecialValueFor('manaregen_bonus')
end
function modifier_cmd_beginner_2:OnIntervalThink()
	if IsServer() then
		if IsValid(self:GetAbility()) then
			local hCaster = self:GetCaster()
			local iPlayerID = GetPlayerID(hCaster)
			EachUnits(iPlayerID, function(hUnit)
				if not hUnit:HasModifier('cmd_beginner_2_buff') then
					hUnit:AddNewModifier(hCaster, self:GetAbility(), 'cmd_beginner_2_buff', {})
				end
			end, UnitType.Building)
		end
	end
end
function modifier_cmd_beginner_2:OnDestroy()
	if IsServer() then
	end
end
---------------------------------------------------------------------
--Modifiers
if cmd_beginner_2_buff == nil then
	cmd_beginner_2_buff = class({}, nil, eom_modifier)
end
function cmd_beginner_2_buff:OnCreated(params)
	self.manaregen_bonus = self:GetAbilitySpecialValueFor('manaregen_bonus')
	if IsServer() then
	end
end
function cmd_beginner_2_buff:OnRefresh(params)
	self.manaregen_bonus = self:GetAbilitySpecialValueFor('manaregen_bonus')
	if IsServer() then
	end
end
function cmd_beginner_2_buff:EDeclareFunctions()
	return {
		[EMDF_MANA_REGEN_BONUS] = self.manaregen_bonus
	}
end
function cmd_beginner_2_buff:DeclareFunctions()
	return	{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function cmd_beginner_2_buff:OnTooltip()
	return self.manaregen_bonus
end