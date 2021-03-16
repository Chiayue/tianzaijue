LinkLuaModifier("modifier_golemA_2", "abilities/tower/golemA/golemA_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_golemA_2_buff", "abilities/tower/golemA/golemA_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_golemA_2_growup", "abilities/tower/golemA/golemA_2.lua", LUA_MODIFIER_MOTION_NONE)

if golemA_2 == nil then
	golemA_2 = class({})
end
function golemA_2:GetIntrinsicModifierName()
	return "modifier_golemA_2"
end
function golemA_2:GrowUp()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local buff_duration = self:GetSpecialValueFor("buff_duration")

	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), radius, self)
	for _, hUnit in ipairs(tTargets) do
		hUnit:AddBuff(hUnit, BUFF_TYPE.TAUNT, buff_duration)
	end

	hCaster:AddNewModifier(hCaster, self, "modifier_golemA_2_buff", {
		duration = buff_duration
	})
end

------------------------------------------------------------------------------
if modifier_golemA_2 == nil then
	modifier_golemA_2 = class({}, nil, eom_modifier)
end
function modifier_golemA_2:IsHidden()
	return true
end
function modifier_golemA_2:OnCreated(params)
	self.growup_health_pct = self:GetAbilitySpecialValueFor("growup_health_pct")
	if IsServer() then
	end
end
function modifier_golemA_2:OnRefresh(params)
	self.growup_health_pct = self:GetAbilitySpecialValueFor("growup_health_pct")
	if IsServer() then
	end
end
function modifier_golemA_2:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_golemA_2:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() }
	}
end
function modifier_golemA_2:OnBattleEnd(params)
	if IsServer() then
		self:SetStackCount(0)
		local hParent = self:GetParent()
		hParent:RemoveModifierByName("modifier_golemA_2_growup")
	end
end
function modifier_golemA_2:OnTakeDamage(params)
	local hParent = params.unit
	if hParent == self:GetParent() then
		local iStack = math.floor((100 - hParent:GetHealthPercent()) / self.growup_health_pct)
		if iStack >= 1 and iStack > self:GetStackCount() then
			self:SetStackCount(iStack)
			self:GetAbility():GrowUp()
		end
	end
end
------------------------------------------------------------------------------
-- 石化
if modifier_golemA_2_buff == nil then
	modifier_golemA_2_buff = class({}, nil, eom_modifier)
end
function modifier_golemA_2_buff:IsHidden()
	return true
end
function modifier_golemA_2_buff:StatusEffectPriority()
	return 10
end
function modifier_golemA_2_buff:OnCreated(params)
	self.fossil_physical_armor_bonus = self:GetAbilitySpecialValueFor("fossil_physical_armor_bonus")
	self.fossil_magical_armor_bonus = self:GetAbilitySpecialValueFor("fossil_magical_armor_bonus")
	if IsServer() then
	end
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_stone_gaze_active.vpcf", PATTACH_CENTER_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_stone_gaze_debuff_stoned.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 1, self:GetCaster(), PATTACH_CUSTOMORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true)
		self:AddParticle(iParticleID, false, false, -1, false, false)

		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/status_effect_medusa_stone_gaze.vpcf", PATTACH_INVALID, self:GetParent())
		self:AddParticle(iParticleID, false, true, self:StatusEffectPriority(), false, false)
	end
end
function modifier_golemA_2_buff:OnRefresh(params)
	self.fossil_physical_armor_bonus = self:GetAbilitySpecialValueFor("fossil_physical_armor_bonus")
	self.fossil_magical_armor_bonus = self:GetAbilitySpecialValueFor("fossil_magical_armor_bonus")
	if IsServer() then
	end
end
function modifier_golemA_2_buff:OnDestroy(params)
	if IsServer() then
		local hParent = self:GetParent()
		hParent:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_golemA_2_growup", {})
	end
end
function modifier_golemA_2_buff:EDeclareFunctions()
	return {
		[EMDF_PHYSICAL_ARMOR_BONUS] = self.fossil_physical_armor_bonus,
		[EMDF_MAGICAL_ARMOR_BONUS] = self.fossil_magical_armor_bonus,
	}
end
function modifier_golemA_2_buff:GetPhysicalArmorBonus()
	return self.fossil_physical_armor_bonus
end
function modifier_golemA_2_buff:GetMagicalArmorBonus()
	return self.fossil_magical_armor_bonus
end
function modifier_golemA_2_buff:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}
end

------------------------------------------------------------------------------
if modifier_golemA_2_growup == nil then
	modifier_golemA_2_growup = class({}, nil, eom_modifier)
end
function modifier_golemA_2_growup:OnCreated(params)
	self.attack_range_bonus = self:GetAbilitySpecialValueFor("attack_range_bonus")
	self.attack_bonus_pct = self:GetAbilitySpecialValueFor("attack_bonus_pct")
	self.attack_speed_bonus = self:GetAbilitySpecialValueFor("attack_speed_bonus")
	self.modle_scale = self:GetAbilitySpecialValueFor("modle_scale")

	self.cleave_starting_width = self:GetAbilitySpecialValueFor("cleave_starting_width")
	self.cleave_ending_width = self:GetAbilitySpecialValueFor("cleave_ending_width")
	self.cleave_distance = self:GetAbilitySpecialValueFor("cleave_distance")
	self.cleave_damage_pct = self:GetAbilitySpecialValueFor("cleave_damage_pct")

	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_golemA_2_growup:OnRefresh(params)
	if IsServer() then
		if self:GetStackCount() < 3 then
			self:IncrementStackCount()
		end
	end

	self.attack_range_bonus = self:GetAbilitySpecialValueFor("attack_range_bonus")
	self.attack_bonus_pct = self:GetAbilitySpecialValueFor("attack_bonus_pct")
	self.attack_speed_bonus = self:GetAbilitySpecialValueFor("attack_speed_bonus")
	self.modle_scale = self:GetAbilitySpecialValueFor("modle_scale")

	self.cleave_starting_width = self:GetAbilitySpecialValueFor("cleave_starting_width")
	self.cleave_ending_width = self:GetAbilitySpecialValueFor("cleave_ending_width")
	self.cleave_distance = self:GetAbilitySpecialValueFor("cleave_distance")
	self.cleave_damage_pct = self:GetAbilitySpecialValueFor("cleave_damage_pct")
end
function modifier_golemA_2_growup:OnDestroy(params)
end
function modifier_golemA_2_growup:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS,
		[MODIFIER_EVENT_ON_ATTACK_LANDED] = { self:GetParent() },
	}
end
function modifier_golemA_2_growup:GetPhysicalAttackBonus()
	return self.attack_bonus_pct * self:GetStackCount() * self:GetParent():GetValByKey(ATTRIBUTE_KIND.PhysicalAttack, ATTRIBUTE_KEY.BASE) * 0.01
end
function modifier_golemA_2_growup:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_golemA_2_growup:CheckState()
	return {
	}
end
function modifier_golemA_2_growup:GetModifierModelScale()
	return self.modle_scale * self:GetStackCount()
end
function modifier_golemA_2_growup:GetModifierAttackRangeBonus()
	return self.attack_range_bonus * self:GetStackCount()
end
function modifier_golemA_2_growup:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed_bonus * self:GetStackCount()
end
function modifier_golemA_2_growup:OnAttackLanded(params)
	if params.target == nil or params.target:GetClassname() == "dota_item_drop" then return end

	if self:GetStackCount() >= 3
	and params.attacker == self:GetParent() then
		if not params.attacker:AttackFilter(params.record, ATTACK_STATE_NO_CLEAVE) and UnitFilter(params.target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, params.attacker:GetTeamNumber()) == UF_SUCCESS then
			local sParticlePath = ParticleManager:GetParticleReplacement("particles/units/heroes/hero_magnataur/magnataur_empower_cleave_effect.vpcf", self:GetCaster())
			local iParticleID = ParticleManager:CreateParticle(sParticlePath, PATTACH_ABSORIGIN_FOLLOW, params.attacker)
			local n = 0

			DoCleaveAction(params.attacker, params.target, self.cleave_starting_width, self.cleave_ending_width, self.cleave_distance, function(hTarget)
				if IsValid(hTarget) then
					if not params.attacker:IsIllusion() then
						local vPos = params.attacker:GetAbsOrigin()
						local iDis = (vPos - hTarget:GetAbsOrigin()):Length2D()
						local tDamageTable = {
							ability = self:GetAbility(),
							victim = hTarget,
							attacker = params.attacker,
							damage = params.original_damage * self.cleave_damage_pct * 0.01,
							damage_type = DAMAGE_TYPE_PHYSICAL,
							damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_USE_COMBAT_PROFICIENCY,
						}
						ApplyDamage(tDamageTable)
					end

					n = n + 1
					ParticleManager:SetParticleControlEnt(iParticleID, n + 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetAbsOrigin(), true)
				end
			end)

			ParticleManager:SetParticleControl(iParticleID, 1, Vector(2, 17, n))
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end
	end
end
function modifier_golemA_2_growup:OnTooltip()
	return self.attack_bonus_pct * self:GetStackCount() * self:GetParent():GetValByKey(ATTRIBUTE_KIND.PhysicalAttack, ATTRIBUTE_KEY.BASE) * 0.01
end