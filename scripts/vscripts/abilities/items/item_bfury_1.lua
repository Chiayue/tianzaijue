--- LinkLuaModifier("modifier_item_bfury_1_1_1_buff", "abilities/items/item_bfury_1_1_1.lua", LUA_MODIFIER_MOTION_NONE)
---狂战斧
if nil == item_bfury_1 then
	item_bfury_1 = class({}, nil, base_ability_attribute)
end
---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_bfury_1 then
	modifier_item_bfury_1 = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_bfury_1:IsHidden()
	return true
end
function modifier_item_bfury_1:OnCreated(params)
	self:UpdateValues()
end
function modifier_item_bfury_1:OnRefresh(params)
	self:UpdateValues()
end

function modifier_item_bfury_1:UpdateValues()
	self.cleave_starting_width = self:GetAbilitySpecialValueFor("cleave_starting_width")
	self.cleave_ending_width = self:GetAbilitySpecialValueFor("cleave_ending_width")
	self.cleave_distance = self:GetAbilitySpecialValueFor("cleave_distance")
	self.cleave_damage = self:GetAbilitySpecialValueFor("cleave_damage")
end

function modifier_item_bfury_1:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK_LANDED] = { self:GetParent(), nil },
	}
end

function modifier_item_bfury_1:OnAttackLanded(params)
	if not IsValid(params.target) or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker:IsRangedAttacker() then return end
	if params.attacker == self:GetParent() then
		if not params.attacker:PassivesDisabled()
		and not params.attacker:AttackFilter(params.record, ATTACK_STATE_NO_CLEAVE)
		and UnitFilter(params.target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, params.attacker:GetTeamNumber()) == UF_SUCCESS then

			local tAttackInfo = GetAttackInfo(params.record, params.attacker)

			local sParticlePath = "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf"
			local iParticleID = ParticleManager:CreateParticle(sParticlePath, PATTACH_ABSORIGIN_FOLLOW, params.attacker)
			local n = 0

			DoCleaveAction(params.attacker, params.target, self.cleave_starting_width, self.cleave_ending_width, self.cleave_distance, function(hTarget)
				if IsValid(hTarget) and tAttackInfo.tDamageInfo then
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

					ParticleManager:SetParticleControlEnt(iParticleID, n + 1, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetAbsOrigin(), true)
				end
			end)
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(2, 17, n))
			ParticleManager:ReleaseParticleIndex(iParticleID)

			params.attacker:EmitSound("Hero_Sven.GreatCleave")
		end
	end
end

AbilityClassHook('item_bfury_1', getfenv(1), 'abilities/items/item_bfury_1.lua', { KeyValues.ItemsKv })