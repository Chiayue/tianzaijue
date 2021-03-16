LinkLuaModifier("modifier_item_leader_certificate", "abilities/items/item_leader_certificate.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_leader_certificate_buff", "abilities/items/item_leader_certificate.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_leader_certificate == nil then
	item_leader_certificate = class({}, nil, base_ability_attribute)
end
function item_leader_certificate:GetIntrinsicModifierName()
	return "modifier_item_leader_certificate"
end
---------------------------------------------------------------------
 --Modifiers
if modifier_item_leader_certificate == nil then
	modifier_item_leader_certificate = class({}, nil, modifier_base_ability_attribute)
end

function modifier_item_leader_certificate:OnCreated(params)
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.time_max = self:GetAbilitySpecialValueFor("time_max")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self:StartIntervalThink(self.interval)
	end
end

function modifier_item_leader_certificate:IsHidden()
	return false
end

function modifier_item_leader_certificate:OnRefresh(params)
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.time_max = self:GetAbilitySpecialValueFor("time_max")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end

function modifier_item_leader_certificate:OnIntervalThink()
	if GSManager:getStateType() == GS_Battle then--非战斗阶段不释放
		local hCaster = self:GetCaster()
		local hAbility = self:GetAbility()
		local vPosition = hCaster:GetAbsOrigin()
		local hTeam = hCaster:GetTeamNumber()
		if IsServer() then
			if self:GetStackCount() < math.floor( self.time_max/self.interval ) then
				self:IncrementStackCount()
			end
			--识别范围内友方单位
			local tTarget = FindUnitsInRadius(hTeam, vPosition, nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			--添加modifier
			local multi_para = self:GetStackCount() * hCaster:GetBuilding():GetStar() * #tTarget
			for i, tUnit in ipairs(tTarget) do
				tUnit:AddNewModifier(hCaster, hAbility, "modifier_item_leader_certificate_buff", {multi_para = multi_para})
			end
		end
	end
end

function modifier_item_leader_certificate:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END,
	}
end

function modifier_item_leader_certificate:OnBattleEnd()
	self:SetStackCount(0)
end

function modifier_item_leader_certificate:OnDestroy()
	if IsServer() then
	end
end

---------------------------------------------------------------------
 --buff
if modifier_item_leader_certificate_buff == nil then
	modifier_item_leader_certificate_buff = class({}, nil, eom_modifier)
end

function modifier_item_leader_certificate_buff:OnCreated(params)
	self.armor_bonus = self:GetAbilitySpecialValueFor("armor_bonus")
	self.attack_speed_bonus = self:GetAbilitySpecialValueFor("attack_speed_bonus")
	self.hp_regen = self:GetAbilitySpecialValueFor("hp_regen")
	if IsServer() then
		self:SetStackCount(params.multi_para)
	end
end

function modifier_item_leader_certificate_buff:OnRefresh(params)
	self.armor_bonus = self:GetAbilitySpecialValueFor("armor_bonus")
	self.attack_speed_bonus = self:GetAbilitySpecialValueFor("attack_speed_bonus")
	self.hp_regen = self:GetAbilitySpecialValueFor("hp_regen")
	if IsServer() then
		self:SetStackCount(params.multi_para)
	end
end

function modifier_item_leader_certificate_buff:IsHidden()
	if self:GetStackCount() == 0 or nil then
		return true
	elseif self:GetStackCount() ~= 0 and nil then
		return false
	end
end

function modifier_item_leader_certificate_buff:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ARMOR_BONUS,
		EMDF_MAGICAL_ARMOR_BONUS,
		EMDF_ATTACKT_SPEED_BONUS,
		EMDF_HEALTH_REGEN_BONUS,
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END,
	}
end

function modifier_item_leader_certificate_buff:OnInBattle()
	self:Action()
end

function modifier_item_leader_certificate_buff:OnBattleEnd()
	self:SetStackCount(0)
end

function modifier_item_leader_certificate_buff:OnDestroy()
	if IsServer() then
	end
end

function modifier_item_leader_certificate_buff:GetPhysicalArmorBonus()
	return self:GetStackCount() * self.armor_bonus
end

function modifier_item_leader_certificate_buff:GetMagicalArmorBonus()
	return self:GetStackCount() * self.armor_bonus
end

function modifier_item_leader_certificate_buff:GetAttackSpeedBonus()
	return self:GetStackCount() * self.attack_speed_bonus
end

function modifier_item_leader_certificate_buff:GetHealthRegenBonus()
	return self:GetStackCount() * self.hp_regen
end

function modifier_item_leader_certificate_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_item_leader_certificate_buff:OnTooltip()
	local hParent = self:GetParent()
	self._iTooltip = ((self._iTooltip or -1) + 1) % 4
	if 0 == self._iTooltip then
		return self:GetStackCount() * self.attack_speed_bonus
	elseif 1 == self._iTooltip then
		return self:GetStackCount() * self.hp_regen
	elseif 2 == self._iTooltip then
		return self:GetStackCount() * self.armor_bonus
	elseif 3 == self._iTooltip then
		return self:GetStackCount() * self.armor_bonus
	end
end

