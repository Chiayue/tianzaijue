LinkLuaModifier("modifier_cmd_beginner_1", "abilities/commander/cmd_beginner/cmd_beginner_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("cmd_beginner_1_buff", "abilities/commander/cmd_beginner/cmd_beginner_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_beginner_1 == nil then
	cmd_beginner_1 = class({})
end
function cmd_beginner_1:GetIntrinsicModifierName()
	return "modifier_cmd_beginner_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_beginner_1 == nil then
	modifier_cmd_beginner_1 = class({}, nil, eom_modifier)
end
function modifier_cmd_beginner_1:IsHidden()
	return true
end
function modifier_cmd_beginner_1:OnCreated(params)
	self:UpdateValues()
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_cmd_beginner_1:OnRefresh(params)
	self:UpdateValues()
end
function modifier_cmd_beginner_1:UpdateValues()
	self.magiatk_bonuspct = self:GetAbilitySpecialValueFor('magiatk_bonuspct')
end
function modifier_cmd_beginner_1:OnIntervalThink()
	if IsServer() then
		if IsValid(self:GetAbility()) then
			local hCaster = self:GetCaster()
			local iPlayerID = GetPlayerID(hCaster)
			EachUnits(iPlayerID, function(hUnit)
				if not hUnit:HasModifier('cmd_beginner_1_buff') then
					hUnit:AddNewModifier(hCaster, self:GetAbility(), 'cmd_beginner_1_buff', {})
				end
			end, UnitType.Building)
		end
	end
end
function modifier_cmd_beginner_1:OnDestroy()
	if IsServer() then
	end
end
---------------------------------------------------------------------
--Modifiers
if cmd_beginner_1_buff == nil then
	cmd_beginner_1_buff = class({}, nil, eom_modifier)
end
function cmd_beginner_1_buff:OnCreated(params)
	self.magiatk_bonuspct = self:GetAbilitySpecialValueFor('magiatk_bonuspct')
	if IsServer() then
	end
end
function cmd_beginner_1_buff:OnRefresh(params)
	self.magiatk_bonuspct = self:GetAbilitySpecialValueFor('magiatk_bonuspct')
	if IsServer() then
	end
end
function cmd_beginner_1_buff:EDeclareFunctions()
	return {
		[EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE] = self.magiatk_bonuspct,
	}
end
function cmd_beginner_1_buff:DeclareFunctions()
	return	{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function cmd_beginner_1_buff:OnTooltip()
	return self.magiatk_bonuspct
end