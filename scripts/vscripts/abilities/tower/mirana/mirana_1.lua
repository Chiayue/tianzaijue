LinkLuaModifier("modifier_mirana_1", "abilities/tower/mirana/mirana_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mirana_1_buff", "abilities/tower/mirana/mirana_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if mirana_1 == nil then
	mirana_1 = class({})
end
function mirana_1:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	local tAttackInfo = GetAttackInfo(ExtraData.record, self:GetCaster())
	local hAttackAbility = EntIndexToHScript(ExtraData.iAbilityIndex)
	if hTarget ~= nil then
		EModifier:NotifyEvt(EMDF_EVENT_ON_ATTACK_HIT, hTarget, tAttackInfo)
		hAttackAbility:OnDamage(hTarget, tAttackInfo)
	else
		if tAttackInfo then
			tAttackInfo.arrow = tAttackInfo.arrow - 1
			if tAttackInfo.arrow <= 0 then
				DelAttackInfo(ExtraData.record)
			end
		end
	end
end
function mirana_1:GetIntrinsicModifierName()
	return "modifier_mirana_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_mirana_1 == nil then
	modifier_mirana_1 = class({}, nil, eom_modifier)
end
function modifier_mirana_1:IsHidden()
	return true
end
function modifier_mirana_1:OnCreated(params)
	self.max_count = self:GetAbilitySpecialValueFor("max_count")
	self.arrow_count = self:GetAbilitySpecialValueFor("arrow_count")
	self.angle_per_arrow = self:GetAbilitySpecialValueFor("angle_per_arrow")
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.width = self:GetAbilitySpecialValueFor("width")
	self.magical_armor_reduce = self:GetAbilitySpecialValueFor("magical_armor_reduce")
	self.arrow_speed = self:GetAbilitySpecialValueFor("arrow_speed")
end
function modifier_mirana_1:EDeclareFunctions()
	return {
		EMDF_DO_ATTACK_BEHAVIOR,
		EMDF_EVENT_ON_ATTACK_HIT,
	}
end
function modifier_mirana_1:DoAttackBehavior(tAttackInfo, hAttackAbility)
	local hParent = self:GetParent()
	if self:GetStackCount() >= self.max_count then
		self:SetStackCount(0)

		for iDamageType, tDamageInfo in pairs(tAttackInfo.tDamageInfo) do
			if iDamageType == DAMAGE_TYPE_MAGICAL and tDamageInfo.damage > 0 then
				tDamageInfo.damage = tDamageInfo.damage * self.damage_pct * 0.01
				break
			end
		end

		local vStart = hParent:GetAbsOrigin()
		local vForward = hParent:GetForwardVector()
		local flAngle = (self.arrow_count - 1) * self.angle_per_arrow
		local tDirection = {}
		for i = 1, self.arrow_count do
			table.insert(tDirection, RotatePosition(Vector(0, 0, 0), QAngle(0, -flAngle * 0.5 + (i - 1) * self.angle_per_arrow, 0), vForward))
		end
		tAttackInfo.arrow = #tDirection
		for _, vDirection in ipairs(tDirection) do
			local info = {
				Ability = self:GetAbility(),
				Source = hParent,
				EffectName = "particles/units/heroes/mirana/mirana_1_arrow.vpcf",
				vSpawnOrigin = vStart,
				vVelocity = self.arrow_speed * vDirection:Normalized(),
				fDistance = self.distance,
				fStartRadius = self.width,
				fEndRadius = self.width,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				ExtraData = {
					record = tAttackInfo.record,
					iAbilityIndex = hAttackAbility:entindex()
				},
			}
			ProjectileManager:CreateLinearProjectile(info)
		end
	else
		self:IncrementStackCount()
		local speed = hParent:GetProjectileSpeed()

		local info = {
			EffectName = hAttackAbility:GetAttackProjectile(),
			Ability = hAttackAbility,
			iMoveSpeed = speed,
			Source = hParent,
			Target = tAttackInfo.target,
			iSourceAttachment = hAttackAbility:GetAttackAttachment(),
			bDodgeable = true,
			bRebound = true, --支持弹道反弹
			ExtraData = {
				record = tAttackInfo.record
			}
		}

		ProjectileManager:CreateTrackingProjectile(info)
	end
end
function modifier_mirana_1:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	hTarget:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_mirana_1_buff", nil)
end
---------------------------------------------------------------------
if modifier_mirana_1_buff == nil then
	modifier_mirana_1_buff = class({}, nil, eom_modifier)
end
function modifier_mirana_1_buff:IsDebuff()
	return true
end
function modifier_mirana_1_buff:OnCreated(params)
	self.max_stack = self:GetAbilitySpecialValueFor("max_stack")
	self.magical_armor_reduce = self:GetAbilitySpecialValueFor("magical_armor_reduce")
	if IsServer() then
		self:IncrementStackCount()
	else
		--特效
		LocalPlayerAbilityParticle(self:GetAbility(), function()
			local iPtclID = ParticleManager:CreateParticle('particles/units/heroes/mirana/mirana_1_blingbling.vpcf', PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl(iPtclID, 0, self:GetParent():GetAbsOrigin())
			self:AddParticle(iPtclID, false, false, -1, false, false)
			return iPtclID
		end, PARTICLE_DETAIL_LEVEL_MEDIUM)
	end
end
function modifier_mirana_1_buff:OnRefresh(params)
	if IsServer() then
		local hCaster = self:GetCaster()
		if self:GetStackCount() < self.max_stack then
			self:IncrementStackCount()
		else
			local hAbility2 = hCaster:FindAbilityByName("mirana_2")
			if IsValid(hAbility2) and hAbility2.MoonHit then
				hAbility2:MoonHit(self:GetParent())
			end
		end
	end
end
function modifier_mirana_1_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_mirana_1_buff:EDeclareFunctions()
	return {
		EMDF_MAGICAL_ARMOR_BONUS_PERCENTAGE
	}
end
function modifier_mirana_1_buff:GetMagicalArmorBonusPercentage()
	return -self:GetStackCount() * self.magical_armor_reduce
end
function modifier_mirana_1_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_mirana_1_buff:OnTooltip()
		return self:GetStackCount() * self.magical_armor_reduce
end