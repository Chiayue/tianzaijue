LinkLuaModifier("modifier_enemy_bfuryaxe", "abilities/special_abilities/enemy_bfuryaxe.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if enemy_bfuryaxe == nil then
	enemy_bfuryaxe = class({})
end
function enemy_bfuryaxe:GetIntrinsicModifierName()
	return "modifier_enemy_bfuryaxe"
end
---------------------------------------------------------------------
--Modifiers
if nil == modifier_enemy_bfuryaxe then
	modifier_enemy_bfuryaxe = class({}, nil, modifier_base_ability_attribute)
end
function modifier_enemy_bfuryaxe:IsHidden()
	return true
end
function modifier_enemy_bfuryaxe:OnCreated(params)
	self:UpdateValues()
end
function modifier_enemy_bfuryaxe:OnRefresh(params)
	self:UpdateValues()
end

function modifier_enemy_bfuryaxe:UpdateValues()
	self.cleave_starting_width = self:GetAbilitySpecialValueFor("cleave_starting_width")
	self.cleave_ending_width = self:GetAbilitySpecialValueFor("cleave_ending_width")
	self.cleave_distance = self:GetAbilitySpecialValueFor("cleave_distance")
	self.cleave_damage = self:GetAbilitySpecialValueFor("cleave_damage")
end

function modifier_enemy_bfuryaxe:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK_LANDED] = { self:GetParent(), nil },
	}
end

function modifier_enemy_bfuryaxe:OnAttackLanded(params)
	if not IsValid(params.target) or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker:IsRangedAttacker() then return end
	if params.attacker == self:GetParent() then
		if not params.attacker:PassivesDisabled()
		and not params.attacker:AttackFilter(params.record, ATTACK_STATE_NO_CLEAVE)
		and UnitFilter(params.target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, params.attacker:GetTeamNumber()) == UF_SUCCESS then

			local tAttackInfo = GetAttackInfo(params.record, params.attacker)
			if not tAttackInfo then
				return
			end

			local sParticlePath = "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf"
			local iParticleID = ParticleManager:CreateParticle(sParticlePath, PATTACH_ABSORIGIN_FOLLOW, params.attacker)
			local n = 0

			DoCleaveAction(params.attacker, params.target, self.cleave_starting_width, self.cleave_ending_width, self.cleave_distance, function(hTarget)
				if IsValid(hTarget) and tAttackInfo.tDamageInfo then
					ParticleManager:SetParticleControlEnt(iParticleID, n, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetAbsOrigin(), true)

					for typeDamage, tDamageDota in pairs(tAttackInfo.tDamageInfo) do
						if 0 < tDamageDota.damage and tDamageDota then
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
				end
			end)
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(2, 17, n))
			ParticleManager:ReleaseParticleIndex(iParticleID)

			params.attacker:EmitSound("Hero_Sven.GreatCleave")
		end
	end
end

AbilityClassHook('item_bfury_1', getfenv(1), 'abilities/items/item_bfury_1.lua', { KeyValues.ItemsKv })