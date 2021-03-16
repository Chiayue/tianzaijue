LinkLuaModifier("modifier_ogre_magi_3", "abilities/tower/ogre_magi/ogre_magi_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ogre_magi_3_buff", "abilities/tower/ogre_magi/ogre_magi_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if ogre_magi_3 == nil then
	ogre_magi_3 = class({})
end
function ogre_magi_3:Precache(context)
	PrecacheResource('particle', 'particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_ignite_burn.vpcf', context)
end
function ogre_magi_3:GetIntrinsicModifierName()
	return "modifier_ogre_magi_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_ogre_magi_3 == nil then
	modifier_ogre_magi_3 = class({}, nil, eom_modifier)
end
function modifier_ogre_magi_3:IsHidden()
	return true
end
function modifier_ogre_magi_3:IsAura()
	return false
end
function modifier_ogre_magi_3:GetAuraRadius()
	return self.radius
end
function modifier_ogre_magi_3:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_ogre_magi_3:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_ogre_magi_3:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_ogre_magi_3:GetModifierAura()
	return "modifier_ogre_magi_3_buff"
end
function modifier_ogre_magi_3:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		if GSManager:getStateType() == GS_Battle then
			self:OnInBattle()
		end
	end
end
function modifier_ogre_magi_3:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = {
			{ ET_GAME.ON_CLONED, self.OnSummoned },
			{ ET_GAME.ON_SUMMONED, self.OnSummoned },
			{ ET_GAME.ON_ILLUSION, self.OnSummoned },
		},
	}
end
function modifier_ogre_magi_3:OnInBattle()
	local hParent = self:GetParent()
	self.roll_pct = 50
	local curPhyAtk = self:GetParent():GetVal(ATTRIBUTE_KIND.PhysicalAttack)
	local curMagAtk = self:GetParent():GetVal(ATTRIBUTE_KIND.MagicalAttack)
	self.bWin = true
	self.roll_pct = math.floor(curPhyAtk * 100 / (curPhyAtk + curMagAtk))
	if curPhyAtk > curMagAtk then
		if RollPercentage(self.roll_pct) then
			self.bWin = true
		else
			self.bWin = false
		end
	else
		self.roll_pct = 100 - self.roll_pct
		if RollPercentage(self.roll_pct) then
			self.bWin = false
		else
			self.bWin = true
		end
	end

	EachUnits(GetPlayerID(hParent), function(hUnit)
		hUnit:AddNewModifier(hParent, self:GetAbility(), self:GetModifierAura(), { bWin = self.bWin })
	end, UnitType.AllFirends)

end
---@param tEvent EventData_ON_SUMMONED
function modifier_ogre_magi_3:OnSummoned(tEvent)
	if IsValid(tEvent.unit) and tEvent.unit:FindModifierByNameAndCaster(self:GetModifierAura(), self:GetParent()) then
		if IsValid(tEvent.target) then
			tEvent.target:AddNewModifier(self:GetParent(), self:GetAbility(), self:GetModifierAura(), { bWin = self.bWin })
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_ogre_magi_3_buff == nil then
	modifier_ogre_magi_3_buff = class({}, nil, eom_modifier)
end
function modifier_ogre_magi_3_buff:OnCreated(params)
	self.mana_regen_reduce_pct = self:GetAbilitySpecialValueFor("mana_regen_reduce")
	self.bonus_physical_attack = self:GetAbilitySpecialValueFor("bonus_physical_attack")
	self.bonus_magical_attack = self:GetAbilitySpecialValueFor("bonus_magical_attack")
	self.extra_bonus_physical_attack = self:GetAbilitySpecialValueFor("extra_bonus_physical_attack")
	self.extra_bonus_magical_attack = self:GetAbilitySpecialValueFor("extra_bonus_magical_attack")
	self.tData = self.tData or {}
	if IsServer() then
		if params.bWin == 1 then
			self.tData.extra_bonus_physical_attack = self.extra_bonus_physical_attack
			self.tData.extra_bonus_magical_attack = 0
		else
			self.tData.extra_bonus_physical_attack = 0
			self.tData.extra_bonus_magical_attack = self.extra_bonus_magical_attack
		end
	end
	self:SetHasCustomTransmitterData(true)
	if self.tData.extra_bonus_physical_attack > 0 then
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_ignite_burn.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 0, Vector(0, 0, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_ignite_secondstyle_burn.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 0, Vector(0, 0, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_ogre_magi_3_buff:OnRefresh(params)

end
function modifier_ogre_magi_3_buff:AddCustomTransmitterData()
	return self.tData
end
function modifier_ogre_magi_3_buff:HandleCustomTransmitterData(tData)
	self.tData = tData
end
function modifier_ogre_magi_3_buff:EDeclareFunctions()
	return {
		[EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE] = self.bonus_physical_attack + self.tData.extra_bonus_physical_attack,
		[EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE] = self.bonus_magical_attack + self.tData.extra_bonus_magical_attack,
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_ogre_magi_3_buff:GetPhysicalAttackBonusPercentage()
	return self.bonus_physical_attack + self.tData.extra_bonus_physical_attack
end
function modifier_ogre_magi_3_buff:GetMagicalAttackBonusPercentage()
	return self.bonus_magical_attack + self.tData.extra_bonus_magical_attack
end
function modifier_ogre_magi_3_buff:OnBattleEnd()
	self:Destroy()
end
function modifier_ogre_magi_3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_ogre_magi_3_buff:OnTooltip()
	local hParent = self:GetParent()
	self.iOnTooltip = ((self.iOnTooltip or -1) + 1) % 4
	if 0 == self.iOnTooltip then	 --1
		return self.bonus_physical_attack + self.tData.extra_bonus_physical_attack
	elseif 1 == self.iOnTooltip then --2
		return hParent:GetValByKey(ATTRIBUTE_KIND.PhysicalAttack, self)
	elseif 2 == self.iOnTooltip then --3
		return self.bonus_magical_attack + self.tData.extra_bonus_magical_attack
	elseif 3 == self.iOnTooltip then --4
		return hParent:GetValByKey(ATTRIBUTE_KIND.MagicalAttack, self)
	end
	return 0
end