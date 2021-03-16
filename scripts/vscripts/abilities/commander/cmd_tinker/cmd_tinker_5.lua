LinkLuaModifier("modifier_cmd_tinker_5", "abilities/commander/cmd_tinker/cmd_tinker_5.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("cmd_tinker_5_buff", "abilities/commander/cmd_tinker/cmd_tinker_5.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_tinker_5 == nil then
	cmd_tinker_5 = class({})
end
function cmd_tinker_5:GetIntrinsicModifierName()
	return "modifier_cmd_tinker_5"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_tinker_5 == nil then
	modifier_cmd_tinker_5 = class({}, nil, eom_modifier)
end
function modifier_cmd_tinker_5:IsHidden()
	return true
end
function modifier_cmd_tinker_5:OnCreated(params)
	self.spells_times = self:GetAbilitySpecialValueFor("spells_times")
	self.mana_regen = self:GetAbilitySpecialValueFor("mana_regen")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_cmd_tinker_5:OnRefresh(params)
	self.spells_times = self:GetAbilitySpecialValueFor("spells_times")
	self.mana_regen = self:GetAbilitySpecialValueFor("mana_regen")
	if IsServer() then
	end
end
function modifier_cmd_tinker_5:OnDestroy()
	if IsServer() then
	end
end
function modifier_cmd_tinker_5:OnIntervalThink()
	if IsServer() then
		if IsValid(self:GetAbility()) then
			local hCaster = self:GetCaster()
			local iPlayerID = GetPlayerID(hCaster)
			EachUnits(iPlayerID, function(hUnit)
				self.bBuff = false
				local tags = DotaTD:GetCardTags(hUnit:GetUnitName())
				for _, sTag in pairs(tags) do
					if string.find(sTag, 'techie') or string.find(sTag, 'warframe') then
						self.bBuff = true
					end
				end


				if not hUnit:HasModifier('cmd_tinker_5_buff') and self.bBuff == true then
					hUnit:AddNewModifier(hCaster, self:GetAbility(), 'cmd_tinker_5_buff', {})
				end
			end, UnitType.Building)
		end
	end
end
function modifier_cmd_tinker_5:DeclareFunctions()
	return {
	}
end
---------------------------------------------------------------------
--Modifiers
if cmd_tinker_5_buff == nil then
	cmd_tinker_5_buff = class({}, nil, eom_modifier)
end
function cmd_tinker_5_buff:OnCreated(params)
	self.spells_times = self:GetAbilitySpecialValueFor("spells_times")
	self.mana_regen = self:GetAbilitySpecialValueFor("mana_regen")
	self.spelltimes = 0
	if IsServer() then
	end
end
function cmd_tinker_5_buff:OnRefresh(params)
	self.spells_times = self:GetAbilitySpecialValueFor("spells_times")
	self.mana_regen = self:GetAbilitySpecialValueFor("mana_regen")
	if IsServer() then
	end
end
function cmd_tinker_5_buff:OnDestroy()
	if IsServer() then
	end
end
function cmd_tinker_5_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_PLAYER_USE_SPELL,
	}
end
function cmd_tinker_5_buff:OnHeroUseSpell(params)
	if params.iPlayerID == GetPlayerID(self:GetParent()) then
		self.spelltimes = self.spelltimes + 1
		if self.spelltimes == self.spells_times then
			self:GetParent():GiveMana(self.mana_regen)
			self.spelltimes = 0
		end
	end
end
function cmd_tinker_5_buff:DeclareFunctions()
	return	{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function cmd_tinker_5_buff:OnTooltip()
	return self.mana_regen
end