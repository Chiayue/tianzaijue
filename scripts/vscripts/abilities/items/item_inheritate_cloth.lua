LinkLuaModifier("modifier_item_inheritate_cloth", "abilities/items/item_inheritate_cloth.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_inheritate_cloth_buff", "abilities/items/item_inheritate_cloth.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--幽灵披风
if item_inheritate_cloth == nil then
	item_inheritate_cloth = class({}, nil, base_ability_attribute)
end
function item_inheritate_cloth:GetIntrinsicModifierName()
	return "modifier_item_inheritate_cloth"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_inheritate_cloth == nil then
	modifier_item_inheritate_cloth = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_inheritate_cloth:OnCreated(params)
	self.inheritate_attribute = self:GetAbilitySpecialValueFor("inheritate_attribute")
	self.range = self:GetAbilitySpecialValueFor("range")
	if IsServer() then
	end
end
function modifier_item_inheritate_cloth:OnRefresh(params)
	self.inheritate_attribute = self:GetAbilitySpecialValueFor("inheritate_attribute")
	self.range = self:GetAbilitySpecialValueFor("range")
	if IsServer() then
	end
end
function modifier_item_inheritate_cloth:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_inheritate_cloth:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH
	}
end
function modifier_item_inheritate_cloth:OnDeath(params)
	if params.unit == self:GetParent() then
		local tTargets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), params.unit:GetAbsOrigin(), nil, self.range, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		if tTargets[1] then
			local iPhysicalAttack = self:GetParent():GetVal(ATTRIBUTE_KIND.PhysicalAttack)
			local iMagicalAttack = self:GetParent():GetVal(ATTRIBUTE_KIND.MagicalAttack)
			local iPhysicalarmor = self:GetParent():GetVal(ATTRIBUTE_KIND.PhysicalArmor)
			local iMagicalarmor = self:GetParent():GetVal(ATTRIBUTE_KIND.MagicalArmor)
			local iAttackspeed = self:GetParent():GetVal(ATTRIBUTE_KIND.AttackSpeed)
			tTargets[1]:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_inheritate_cloth_buff", {
				iPhysicalAttack = iPhysicalAttack,
				iMagicalAttack = iMagicalAttack,
				iMagicalarmor = iMagicalarmor,
				iPhysicalarmor = iPhysicalarmor,
				iAttackspeed = iAttackspeed
			})
		end
	end
end

---------------------------------------------------------------
--Modifiers
if modifier_item_inheritate_cloth_buff == nil then
	modifier_item_inheritate_cloth_buff = class({}, nil, eom_modifier)
end
function modifier_item_inheritate_cloth_buff:AddCustomTransmitterData()
	return self.tAttributes
end
function modifier_item_inheritate_cloth_buff:HandleCustomTransmitterData(tData)
	self.tAttributes = tData
end
function modifier_item_inheritate_cloth_buff:OnCreated(params)
	self:SetHasCustomTransmitterData(true)
	self.inheritate_attribute = self:GetAbilitySpecialValueFor("inheritate_attribute")
	self.range = self:GetAbilitySpecialValueFor("range")
	self:SetHasCustomTransmitterData(true)
	if IsServer() then
		self.tAttributes = {}
		self.tAttributes.iPhysicalAttack = params.iPhysicalAttack
		self.tAttributes.iMagicalAttack = params.iMagicalAttack
		self.tAttributes.iMagicalarmor = params.iMagicalarmor
		self.tAttributes.iPhysicalarmor = params.iPhysicalarmor
		self.tAttributes.iAttackspeed = params.iAttackspeed
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_spirit_breaker/spirit_breaker_haste_owner_status.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_item_inheritate_cloth_buff:OnRefresh(params)
	self.inheritate_attribute = self:GetAbilitySpecialValueFor("inheritate_attribute")
	self.range = self:GetAbilitySpecialValueFor("range")
	if IsServer() then
		self.tAttributes.iPhysicalAttack = params.iPhysicalAttack
		self.tAttributes.iMagicalAttack = params.iMagicalAttack
		self.tAttributes.iMagicalarmor = params.iMagicalarmor
		self.tAttributes.iPhysicalarmor = params.iPhysicalarmor
		self.tAttributes.iAttackspeed = params.iAttackspeed
	end
end

function modifier_item_inheritate_cloth_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		[EMDF_MAGICAL_ATTACK_BONUS] = self.tAttributes.iMagicalAttack,
		[EMDF_PHYSICAL_ATTACK_BONUS] = self.tAttributes.iPhysicalAttack,
		[EMDF_ATTACKT_SPEED_BONUS] = self.tAttributes.iAttackspeed,
		[EMDF_MAGICAL_ARMOR_BONUS] = self.tAttributes.iMagicalarmor,
		[EMDF_PHYSICAL_ARMOR_BONUS] = self.tAttributes.iPhysicalarmor,
	}
end
function modifier_item_inheritate_cloth_buff:OnBattleEnd()
	self:Destroy()
end
function modifier_item_inheritate_cloth_buff:OnDestroy()
	if IsServer() then
		if GSManager:getStateType() == GS_Battle then
			local hParent = self:GetParent()
			local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.range, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			if tTargets[1] then
				local iPhysicalAttack = self:GetParent():GetVal(ATTRIBUTE_KIND.PhysicalAttack)
				local iMagicalAttack = self:GetParent():GetVal(ATTRIBUTE_KIND.MagicalAttack)
				local iPhysicalarmor = self:GetParent():GetVal(ATTRIBUTE_KIND.PhysicalArmor)
				local iMagicalarmor = self:GetParent():GetVal(ATTRIBUTE_KIND.MagicalArmor)
				local iAttackspeed = self:GetParent():GetVal(ATTRIBUTE_KIND.AttackSpeed)
				tTargets[1]:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_inheritate_cloth_buff", {
					iPhysicalAttack = iPhysicalAttack,
					iMagicalAttack = iMagicalAttack,
					iMagicalarmor = iMagicalarmor,
					iPhysicalarmor = iPhysicalarmor,
					iAttackspeed = iAttackspeed,
				})
			end
		end
	end
end
function modifier_item_inheritate_cloth_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_item_inheritate_cloth_buff:OnTooltip()
	self._iTooltip = ((self._iTooltip or -1) + 1) % 5
	if 0 == self._iTooltip then
		return self.tAttributes.iPhysicalAttack
	elseif 1 == self._iTooltip then
		return self.tAttributes.iMagicalAttack
	elseif 2 == self._iTooltip then
		return self.tAttributes.iPhysicalarmor
	elseif 3 == self._iTooltip then
		return self.tAttributes.iMagicalarmor
	elseif 4 == self._iTooltip then
		return self.tAttributes.iAttackspeed
	end
	return 0
end