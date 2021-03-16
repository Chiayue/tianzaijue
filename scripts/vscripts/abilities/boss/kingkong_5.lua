LinkLuaModifier("modifier_kingkong_5", "abilities/boss/kingkong_5.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if kingkong_5 == nil then
	kingkong_5 = class({})
end
function kingkong_5:GetIntrinsicModifierName()
	return "modifier_kingkong_5"
end
---------------------------------------------------------------------
--Modifiers
if modifier_kingkong_5 == nil then
	modifier_kingkong_5 = class({}, nil, eom_modifier)
end
function modifier_kingkong_5:IsHidden()
	return true
end
function modifier_kingkong_5:OnCreated(params)
	self.trigger_pct = self:GetAbilitySpecialValueFor("trigger_pct")
	self.start_width = self:GetAbilitySpecialValueFor("start_width")
	self.end_width = self:GetAbilitySpecialValueFor("end_width")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.knockback_duration = self:GetAbilitySpecialValueFor("knockback_duration")
	self.knockback_distance = self:GetAbilitySpecialValueFor("knockback_distance")
	if IsServer() then
	end
end
function modifier_kingkong_5:OnRefresh(params)
	self.cleave_starting_width = self:GetAbilitySpecialValueFor("cleave_starting_width")
	self.cleave_ending_width = self:GetAbilitySpecialValueFor("cleave_ending_width")
	self.cleave_distance = self:GetAbilitySpecialValueFor("cleave_distance")
	self.cleave_damage = self:GetAbilitySpecialValueFor("cleave_damage")
	self.bonus_damage_pct = self:GetAbilitySpecialValueFor("bonus_damage_pct")
end
function modifier_kingkong_5:EDeclareFunctions()
	return {
		EMDF_ATTACKT_SPEED_BONUS,
		[MODIFIER_EVENT_ON_ATTACK_LANDED] = { self:GetParent(), nil },
	}
end
function modifier_kingkong_5:GetAttackSpeedBonus()
	if self:GetParent():GetHealthPercent() <= self.trigger_pct then
		return self.attackspeed
	end
end
function modifier_kingkong_5:OnAttackLanded(params)
	if not IsValid(params.target) or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() and params.attacker:GetHealthPercent() <= self.trigger_pct then
		if not params.attacker:PassivesDisabled()
		and not params.attacker:AttackFilter(params.record, ATTACK_STATE_NO_CLEAVE)
		and UnitFilter(params.target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, params.attacker:GetTeamNumber()) == UF_SUCCESS then
			if self.iParticleID == nil then
				self.iParticleID = ParticleManager:CreateParticle("particles/units/boss/kingkong/kingkong_5_bloodlust.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
				self:AddParticle(self.iParticleID, false, false, -1, false, false)
			end
			local tAttackInfo = GetAttackInfo(params.record, params.attacker)

			local sParticlePath = "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf"
			local iParticleID = ParticleManager:CreateParticle(sParticlePath, PATTACH_ABSORIGIN_FOLLOW, params.attacker)
			local n = 0

			DoCleaveAction(params.attacker, params.target, self.start_width, self.end_width, params.attacker:Script_GetAttackRange() + params.attacker:GetHullRadius(), function(hTarget)
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
					-- 击退
					params.attacker:KnockBack(params.attacker:GetAbsOrigin(), hTarget, self.knockback_distance, 0, self.knockback_duration, true)

					n = n + 1

					ParticleManager:SetParticleControlEnt(iParticleID, n + 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetAbsOrigin(), true)
				end
			end)
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(2, 17, n))
			ParticleManager:ReleaseParticleIndex(iParticleID)

			-- 击退
			params.attacker:KnockBack(params.attacker:GetAbsOrigin(), params.target, self.knockback_distance, 0, self.knockback_duration, true)

			params.attacker:EmitSound("Hero_Sven.GreatCleave")
		end
	end
end