LinkLuaModifier("modifier_puck_3", "abilities/tower/puck/puck_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_puck_3_effect", "abilities/tower/puck/puck_3.lua", LUA_MODIFIER_MOTION_NONE)

if puck_3 == nil then
	puck_3 = class({})
end
function puck_3:GetIntrinsicModifierName()
	return "modifier_puck_3"
end

------------------------------------------------------------------------------
if modifier_puck_3 == nil then
	modifier_puck_3 = class({}, nil, BaseModifier)
end
function modifier_puck_3:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		self.restore_mana = self:GetAbilitySpecialValueFor("restore_mana")
		self.damage_radius = self:GetAbilitySpecialValueFor("damage_radius")
		self.silenced_duration = self:GetAbilitySpecialValueFor("silenced_duration")
		self.blink_radius = self:GetAbility():GetCastRange(hParent:GetAbsOrigin(), hParent) + hParent:GetCastRangeBonus()

		AddModifierEvents(MODIFIER_EVENT_ON_ATTACKED, self)
	end
end
function modifier_puck_3:OnRefresh(params)
	if IsServer() then
		local hParent = self:GetParent()
		self.restore_mana = self:GetAbilitySpecialValueFor("restore_mana")
		self.damage_radius = self:GetAbilitySpecialValueFor("damage_radius")
		self.silenced_duration = self:GetAbilitySpecialValueFor("silenced_duration")
		self.blink_radius = self:GetAbility():GetCastRange(hParent:GetAbsOrigin(), hParent) + hParent:GetCastRangeBonus()
	end
end
function modifier_puck_3:OnDestroy(params)
	if IsServer() then
		RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACKED, self)
	end
end
function modifier_puck_3:OnAttacked(params)
	local hTarget = params.target
	local hAbility = self:GetAbility()

	if hTarget:IsAlive()
	and hTarget == self:GetParent()
	and IsValid(hAbility)
	and hAbility:IsCooldownReady() then
		local fMana = hAbility:GetManaCost(hAbility:GetLevel())
		if hTarget:GetMana() >= fMana then
			hTarget:ReduceMana(fMana)
			hAbility:StartCooldown(hAbility:GetCooldown(hAbility:GetLevel() - 1))

			local vRandom
			for i = 1, 100 do
				vRandom = hTarget:GetAbsOrigin() + RandomVector(self.blink_radius)
				if GridNav:CanFindPath(self:GetParent():GetAbsOrigin(), vRandom) then
					break
				end
			end
			FindClearSpaceForUnit(hTarget, vRandom, true)

			hTarget:AddNewModifier(hTarget, hAbility, "modifier_puck_3_effect", {})

			local vLocation = hTarget:GetAbsOrigin()
			local tUnits = FindUnitsInRadius(
			hTarget:GetTeamNumber(),
			vLocation,
			nil,
			self.damage_radius,
			DOTA_UNIT_TARGET_TEAM_BOTH,
			hAbility:GetAbilityTargetType(),
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)
			local damage_table = {
				ability = self:GetAbility(),
				attacker = hTarget,
				damage = 0,
				damage_type = DAMAGE_TYPE_MAGICAL
			}

			for k, hUnit in pairs(tUnits) do
				if IsValid(hUnit) and hUnit:IsAlive() then
					if hUnit:GetTeamNumber() == hTarget:GetTeamNumber() then
						hUnit:GiveMana(self.restore_mana)
					else
						damage_table.victim = hUnit
						ApplyDamage(damage_table)

						if hUnit:IsAlive() then
							hUnit:AddNewModifier(hTarget, hAbility, "modifier_silent", {
								duration = self.silenced_duration
							})
						end
					end
				end
			end
		end
	end
end
function modifier_puck_3:IsHidden()
	return true
end

------------------------------------------------------------------------------
if modifier_puck_3_effect == nil then
	modifier_puck_3_effect = class({}, nil, BaseModifier)
end
function modifier_puck_3_effect:OnCreated(params)
	if IsClient() then
		local damage_radius = self:GetAbilitySpecialValueFor("damage_radius")
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_puck/puck_waning_rift.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(iParticle, 1, Vector(damage_radius, 1, damage_radius))
		ParticleManager:ReleaseParticleIndex(iParticle)
	end
end
function modifier_puck_3_effect:OnRefresh(params)
	if IsClient() then
		local damage_radius = self:GetAbilitySpecialValueFor("damage_radius")
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_puck/puck_waning_rift.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(iParticle, 1, Vector(damage_radius, 1, damage_radius))
		ParticleManager:ReleaseParticleIndex(iParticle)
	end
end
function modifier_puck_3_effect:IsHidden()
	return true
end