LinkLuaModifier("modifier_tinker_2_buff", "abilities/tower/tinker/tinker_2.lua", LUA_MODIFIER_MOTION_NONE)
if tinker_2 == nil then
	tinker_2 = class({}, nil, ability_base_ai)
end
function tinker_2:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	return true
end
function tinker_2:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:StartGesture(ACT_DOTA_TINKER_REARM3)
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_rearm.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack2", hCaster:GetAbsOrigin(), false)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	local cooldown_reduce = self:GetSpecialValueFor("cooldown_reduce")
	EachUnits(GetPlayerID(hCaster), function(hFriend)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_defense_matrix_pulse.vpcf", PATTACH_CUSTOMORIGIN, hFriend)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hFriend, PATTACH_POINT_FOLLOW, "attach_hitloc", hFriend:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hFriend, PATTACH_POINT_FOLLOW, "attach_hitloc", hFriend:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		for iIndex = 0, 5 do
			local hAbility = hFriend:GetAbilityByIndex(iIndex)
			if IsValid(hAbility) and hAbility ~= self and hAbility:GetCooldownTimeRemaining() > 0 then
				local flCooldown = math.max(hAbility:GetCooldownTimeRemaining() - cooldown_reduce, 0)
				hAbility:EndCooldown()
				hAbility:StartCooldown(flCooldown)
			end
		end
	end, UnitType.AllFirends)
	hCaster:AddNewModifier(hCaster, self, "modifier_tinker_2_buff", nil)
end
---------------------------------------------------------------------
-- Modifiers
if modifier_tinker_2_buff == nil then
	modifier_tinker_2_buff = class({}, nil, eom_modifier)
end
function modifier_tinker_2_buff:OnCreated(params)
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.attack_count = self:GetAbilitySpecialValueFor("attack_count")
	self.bonus_damage_pct = self:GetAbilitySpecialValueFor("bonus_damage_pct")
	if IsServer() then
		self:SetStackCount(self.attack_count)
	end
end
function modifier_tinker_2_buff:EDeclareFunctions()
	return {
		[EMDF_ATTACKT_SPEED_BONUS] = self.attackspeed,
		EMDF_EVENT_ON_ATTACK_HIT,
		EMDF_EVENT_ON_ATTACK_RECORD_DESTROY
	}
end
function modifier_tinker_2_buff:GetAttackSpeedBonus()
	return self.attackspeed
end
function modifier_tinker_2_buff:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end
	local hParent = self:GetParent()

	for _iDamageType, tDamageInfo in pairs(tAttackInfo.tDamageInfo) do
		if _iDamageType == DAMAGE_TYPE_MAGICAL then
			if not tDamageInfo[self:GetName()] then
				-- 保证只增伤一次
				tDamageInfo[self:GetName()] = true
				tDamageInfo.damage = tDamageInfo.damage * self.bonus_damage_pct * 0.01
			end
		end
	end
end
function modifier_tinker_2_buff:OnCustomAttackRecordDestroy(tAttackInfo)
	if tAttackInfo.attacker == self:GetParent() then
		self:DecrementStackCount()
		if self:GetStackCount() <= 0 then
			self:Destroy()
		end
	end
end
function modifier_tinker_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_tinker_2_buff:OnTooltip()
	local hParent = self:GetParent()
	self._iTooltip = ((self._iTooltip or -1) + 1) % 2
	if 0 == self._iTooltip then
		return self.attackspeed
	elseif 1 == self._iTooltip then
		return self.bonus_damage_pct
	end
end