LinkLuaModifier("modifier_rattletrap_2", "abilities/tower/rattletrap/rattletrap_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rattletrap_2_buff", "abilities/tower/rattletrap/rattletrap_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if rattletrap_2 == nil then
	rattletrap_2 = class({})
end
function rattletrap_2:GetIntrinsicModifierName()
	return "modifier_rattletrap_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_rattletrap_2 == nil then
	modifier_rattletrap_2 = class({}, nil, BaseModifier)
end
function modifier_rattletrap_2:IsHidden()
	return true
end
function modifier_rattletrap_2:OnCreated(params)
	self.threshold = self:GetAbilitySpecialValueFor("threshold")

	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_rattletrap_2:OnRefresh(params)
	self.threshold = self:GetAbilitySpecialValueFor("threshold")
end
function modifier_rattletrap_2:OnIntervalThink()
	if GSManager:getStateType() ~= GS_Battle then
		return
	end

	if self:GetParent():GetHealthPercent() <= self.threshold then
		if not self:GetParent():HasModifier("modifier_rattletrap_2_buff") then
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_rattletrap_2_buff", nil)
		end
	else
		self:GetParent():RemoveModifierByName("modifier_rattletrap_2_buff")
	end
end

---------------------------------------------------------------------
if modifier_rattletrap_2_buff == nil then
	modifier_rattletrap_2_buff = class({}, nil, eom_modifier)
end
function modifier_rattletrap_2_buff:OnCreated(params)
	self.cleave_starting_width = self:GetAbilitySpecialValueFor("cleave_starting_width")
	self.cleave_ending_width = self:GetAbilitySpecialValueFor("cleave_ending_width")
	self.cleave_distance = self:GetAbilitySpecialValueFor("cleave_distance")
	self.cleave_damage = self:GetAbilitySpecialValueFor("cleave_damage")
	self.bonus_damage_pct = self:GetAbilitySpecialValueFor("bonus_damage_pct")
end
function modifier_rattletrap_2_buff:OnRefresh(params)
	self.cleave_starting_width = self:GetAbilitySpecialValueFor("cleave_starting_width")
	self.cleave_ending_width = self:GetAbilitySpecialValueFor("cleave_ending_width")
	self.cleave_distance = self:GetAbilitySpecialValueFor("cleave_distance")
	self.cleave_damage = self:GetAbilitySpecialValueFor("cleave_damage")
	self.bonus_damage_pct = self:GetAbilitySpecialValueFor("bonus_damage_pct")
end
function modifier_rattletrap_2_buff:OnDestroy()
end
function modifier_rattletrap_2_buff:EDeclareFunctions()
	return {
		[EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE] = self.bonus_damage_pct,
		[MODIFIER_EVENT_ON_ATTACK_LANDED] = { self:GetParent(), nil },
	-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
end
--buff tips
function modifier_rattletrap_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_rattletrap_2_buff:OnTooltip()
	return self.bonus_damage_pct
end
function modifier_rattletrap_2_buff:GetPhysicalAttackBonusPercentage()
	return self.bonus_damage_pct
end
function modifier_rattletrap_2_buff:OnAttackLanded(params)
	if not IsValid(params.target) or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() then
		if not params.attacker:PassivesDisabled()
		and not params.attacker:AttackFilter(params.record, ATTACK_STATE_NO_CLEAVE)
		and UnitFilter(params.target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, params.attacker:GetTeamNumber()) == UF_SUCCESS then

			local tAttackInfo = GetAttackInfo(params.record, params.attacker)

			local sParticlePath = "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf"
			local iParticleID = ParticleManager:CreateParticle(sParticlePath, PATTACH_ABSORIGIN_FOLLOW, params.attacker)
			local n = 0

			DoCleaveAction(params.attacker, params.target, self.cleave_starting_width, self.cleave_ending_width, self.cleave_distance, function(hTarget)
				if IsValid(hTarget) then
					for typeDamage, tDamageDota in pairs(tAttackInfo.tDamageInfo) do
						if 0 < tDamageDota.damage then
							local tDamage = {
								ability = self:GetAbility(),
								attacker = params.attacker,
								victim = hTarget,
								damage = tDamageDota.damage * self.cleave_damage * 0.01,
								damage_type = typeDamage,
								damage_flags = bit.bor(tDamageDota.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_USE_COMBAT_PROFICIENCY),
							}
							ApplyDamage(tDamage)
						end
					end

					n = n + 1

					ParticleManager:SetParticleControlEnt(iParticleID, n + 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetAbsOrigin(), true)
				end
			end)
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(2, 17, n))
			ParticleManager:ReleaseParticleIndex(iParticleID)

			params.attacker:EmitSound("Hero_Sven.GreatCleave")
		end
	end
end
-- function modifier_rattletrap_2_buff:GetModifierTotalDamageOutgoing_Percentage(params)
-- 	return 1000
-- end