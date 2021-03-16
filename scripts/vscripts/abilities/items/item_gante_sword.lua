LinkLuaModifier("modifier_item_gante_sword", "abilities/items/item_gante_sword.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_gante_sword_armor_reduce_buff", "abilities/items/item_gante_sword.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_gante_sword_buff", "abilities/items/item_gante_sword.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_gante_sword == nil then
	item_gante_sword = class({}, nil, base_ability_attribute)
end
function item_gante_sword:GetIntrinsicModifierName()
	return "modifier_item_gante_sword"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_gante_sword == nil then
	modifier_item_gante_sword = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_gante_sword:OnCreated(params)
	self.debuff_duration = self:GetAbilitySpecialValueFor("debuff_duration")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.chance = self:GetAbilitySpecialValueFor("chance")
end
function modifier_item_gante_sword:OnRefresh(params)
	self.debuff_duration = self:GetAbilitySpecialValueFor("debuff_duration")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	if IsServer() then
	end
end
function modifier_item_gante_sword:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_gante_sword:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
	}
end
function modifier_item_gante_sword:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if tAttackInfo.attacker:IsIllusion() then return end
	if tAttackInfo.attacker:IsClone() then return end
	if IsAttackMiss(tAttackInfo) then return end

	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()

	hTarget:AddNewModifier(hCaster, hAbility, 'modifier_item_gante_sword_armor_reduce_buff', { duration = self.debuff_duration })

	if PRD(hCaster, self.chance, "item_gante_sword") then
		hCaster:AddNewModifier(hCaster, hAbility, 'modifier_item_gante_sword_buff', { duration = self.duration })
	end
end
---------------------------------------------------------------------
--减甲
if modifier_item_gante_sword_armor_reduce_buff == nil then
	modifier_item_gante_sword_armor_reduce_buff = class({}, nil, eom_modifier)
end
function modifier_item_gante_sword_armor_reduce_buff:IsDebuff()
	return true
end
function modifier_item_gante_sword_armor_reduce_buff:OnCreated(params)
	self.armor_reduce_pct = self:GetAbilitySpecialValueFor("armor_reduce_pct")
	self.armor_reduce_pct_boss = self:GetAbilitySpecialValueFor("armor_reduce_pct_boss")
	if IsServer() then
		self.tData = {}

		table.insert(self.tData, {
			fDieTime = self:GetDieTime(),
		})
		self:IncrementStackCount()

		self:StartIntervalThink(0)
	end
end
function modifier_item_gante_sword_armor_reduce_buff:OnRefresh(params)
	if IsServer() then
		table.insert(self.tData, {
			fDieTime = self:GetDieTime(),
		})
		self:IncrementStackCount()
	end
end
function modifier_item_gante_sword_armor_reduce_buff:OnIntervalThink()
	if IsServer() then
		local fGameTime = GameRules:GetGameTime()
		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].fDieTime then
				self:DecrementStackCount()
				table.remove(self.tData, i)
			end
		end
	end
end
function modifier_item_gante_sword_armor_reduce_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_gante_sword_armor_reduce_buff:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ARMOR_BONUS_PERCENTAGE,
	}
end
function modifier_item_gante_sword_armor_reduce_buff:GetPhysicalArmorBonusPercentage()
	local armor_reduce_pct = self:GetParent():IsBoss() and self.armor_reduce_pct_boss or self.armor_reduce_pct
	return -(1-math.pow(1-armor_reduce_pct*0.01, self:GetStackCount()))*100
end
function modifier_item_gante_sword_armor_reduce_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_item_gante_sword_armor_reduce_buff:OnTooltip()
	return self:GetPhysicalArmorBonusPercentage()
end
---------------------------------------------------------------------
--zishen
if modifier_item_gante_sword_buff == nil then
	modifier_item_gante_sword_buff = class({}, nil, eom_modifier)
end
function modifier_item_gante_sword_buff:OnCreated(params)
	self.attack_speed_bonus = self:GetAbilitySpecialValueFor("attack_speed_bonus")
	self.attack_bonus_pct = self:GetAbilitySpecialValueFor("attack_bonus_pct")
	if IsClient() then
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/jakiro/jakiro_ti10_immortal/jakiro_ti10_macropyre_lightshaft.vpcf", PATTACH_ABSORIGIN, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, true, false, -1, false, false)
	end
end
function modifier_item_gante_sword_buff:OnRefresh(params)
	self.attack_speed_bonus = self:GetAbilitySpecialValueFor("attack_speed_bonus")
	self.attack_bonus_pct = self:GetAbilitySpecialValueFor("attack_bonus_pct")
end
function modifier_item_gante_sword_buff:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE
	}
end
function modifier_item_gante_sword_buff:GetPhysicalAttackBonusPercentage()
	return self.attack_bonus_pct
end
function modifier_item_gante_sword_buff:GetAttackSpeedPercentage()
	return self.attack_speed_bonus
end
function modifier_item_gante_sword_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_item_gante_sword_buff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self:GetPhysicalAttackBonusPercentage()
	elseif self._tooltip == 2 then
		return self:GetAttackSpeedPercentage()
	end
end