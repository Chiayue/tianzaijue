LinkLuaModifier("modifier_boss", "abilities/boss/boss.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if boss == nil then
	boss = class({})
end
function boss:GetIntrinsicModifierName()
	return "modifier_boss"
end
---------------------------------------------------------------------
--Modifiers
if modifier_boss == nil then
	modifier_boss = class({}, nil, eom_modifier)
end
function modifier_boss:IsHidden()
	return false
end
function modifier_boss:OnCreated(params)
	self:SetHasCustomTransmitterData(true)
	self.stage_3_cooldown_reduction = self:GetAbilitySpecialValueFor("stage_3_cooldown_reduction")
	self.tStageHealth = {
		self:GetAbility():GetLevelSpecialValueFor("stage_health_pct", 0),
		self:GetAbility():GetLevelSpecialValueFor("stage_health_pct", 1),
		self:GetAbility():GetLevelSpecialValueFor("stage_health_pct", 2)
	}
	if IsServer() then
		self:StartIntervalThink(0.1)
		self.iLevel = 0

		if nil == self.tAttribute then
			self.tAttribute = {}

			--所有玩家漏过导致的属性成长
			local bToast = true
			for _, tIntensifyAttribute in pairs(Spawner.tPlayerBossIntensify) do
				for k, v in pairs(tIntensifyAttribute) do
					if not self.tAttribute[k] then
						self.tAttribute[k] = v
					else
						self.tAttribute[k] = v + self.tAttribute[k]
					end
					self:SetStackCount(v)
					-- if GSManager:getStateType() == GS_Preparation and bToast == true then
					-- 	Notification:Boss_Enhance({
					-- 		boss_enhance = self.tAttribute[k],
					-- 		tAttribute = k,
					-- 		message = "#Boss_Enhance",
					-- 	})
					-- end
				end
				bToast = false
			end
			self:ForceRefresh()
		end
	end
end
function modifier_boss:AddCustomTransmitterData()
	return self.tAttribute
end
function modifier_boss:HandleCustomTransmitterData(tData)
	self.tAttribute = tData
end
function modifier_boss:OnIntervalThink()
	local hParent = self:GetParent()
	local iLevel = self.iLevel
	for i = 1, #self.tStageHealth do
		if hParent:GetHealthPercent() <= self.tStageHealth[i] and self.iLevel < i then
			iLevel = i
		end
	end

	if iLevel ~= self.iLevel then
		self.iLevel = iLevel
		local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, -1, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		local function set(sSpecial, typeEMDF, iBase)
			iBase = iBase or 0
			local iFactor = self:GetAbilityLevelSpecialValueFor(sSpecial, iLevel)
			local iRote = 0
			if iFactor and 0 < iFactor then
				iRote = #tTargets / iFactor
			end
			self.tAttribute[typeEMDF] = iBase * iRote + (self.tAttribute[typeEMDF] or 0)
		end

		-- 攻击力加成
		set("stage_attack_factor", EMDF_PHYSICAL_ATTACK_BONUS, self:GetParent():GetValByKey(ATTRIBUTE_KIND.PhysicalAttack, ATTRIBUTE_KEY.BASE))
		set("stage_attack_factor", EMDF_MAGICAL_ATTACK_BONUS, self:GetParent():GetValByKey(ATTRIBUTE_KIND.MagicalAttack, ATTRIBUTE_KEY.BASE))

		-- 防御力加成
		set("stage_armor_factor", EMDF_PHYSICAL_ARMOR_BONUS, self:GetParent():GetValByKey(ATTRIBUTE_KIND.PhysicalArmor, ATTRIBUTE_KEY.BASE))
		set("stage_armor_factor", EMDF_MAGICAL_ARMOR_BONUS, self:GetParent():GetValByKey(ATTRIBUTE_KIND.MagicalArmor, ATTRIBUTE_KEY.BASE))

		self:ForceRefresh()
	end
end
function modifier_boss:EDeclareFunctions()
	local tFuncs = {}
	if self.tAttribute then
		for k, v in pairs(self.tAttribute) do
			tFuncs[k] = v
		end
	end
	return tFuncs
end
function modifier_boss:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_boss:OnTooltip()
	self._iToolTip = ((self._iToolTip or -1) + 1) % 5
	if 0 == self._iToolTip then
		return self:GetParent():GetValByKey(ATTRIBUTE_KIND.StatusHealth, self)
	elseif 1 == self._iToolTip then
		return self:GetParent():GetValByKey(ATTRIBUTE_KIND.PhysicalAttack, self)
	elseif 2 == self._iToolTip then
		return self:GetParent():GetValByKey(ATTRIBUTE_KIND.MagicalAttack, self)
	elseif 3 == self._iToolTip then
		return self:GetParent():GetValByKey(ATTRIBUTE_KIND.PhysicalArmor, self)
	elseif 4 == self._iToolTip then
		return self:GetParent():GetValByKey(ATTRIBUTE_KIND.MagicalArmor, self)
	end
	return 0
end
function modifier_boss:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true
	}
end