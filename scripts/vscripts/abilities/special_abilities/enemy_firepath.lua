LinkLuaModifier("modifier_enemy_firepath", "abilities/special_abilities/enemy_firepath.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if enemy_firepath == nil then
	enemy_firepath = class({})
end
function enemy_firepath:GetIntrinsicModifierName()
	return "modifier_enemy_firepath"
end
---------------------------------------------------------------------
--Modifiers
if modifier_enemy_firepath == nil then
	modifier_enemy_firepath = class({}, nil, eom_modifier)
end
function modifier_enemy_firepath:OnCreated(params)
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.damage_factor = self:GetAbilitySpecialValueFor("damage_factor")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() and self:GetAbility():IsAbilityReady() then
		self:GetParent():EmitSound("Hero_Batrider.Firefly.loop")
		self.particleID_1 = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_firefly_ember.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.particleID_1, 11, Vector(1, 0, 0))
		self:AddParticle(self.particleID_1, false, false, -1, false, false)

		self.particleID_2 = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_firefly.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.particleID_2, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.particleID_2, 11, Vector(1, 0, 0))
		self:AddParticle(self.particleID_2, false, false, -1, false, false)

		self.positions = {}
		self:StartIntervalThink(1)
	end
end
function modifier_enemy_firepath:OnRefresh(params)
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.damage_factor = self:GetAbilitySpecialValueFor("damage_factor")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
function modifier_enemy_firepath:OnIntervalThink()
	if IsServer() then
		local position = self:GetParent():GetAbsOrigin()
		if TableFindKey(self.positions, position) == nil then
			table.insert(self.positions, position)
		end

		local caster = self:GetParent()

		local targets = FindUnitsInRadius(caster:GetTeamNumber(), Vector(0, 0, 0), nil, -1, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false)
		for i = #targets, 1, -1 do
			local bRemove = true
			for n, position in pairs(self.positions) do
				if targets[i]:IsPositionInRange(position, self.radius) then
					bRemove = false
					break
				end
			end
			if bRemove then
				table.remove(targets, i)
			end
		end

		for n, target in pairs(targets) do
			-- local particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_firefly_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			-- ParticleManager:ReleaseParticleIndex(particleID)
			local fDamage = target:GetMaxHealth() * self.damage_factor * 0.01
			caster:DealDamage(target, self:GetAbility(), fDamage, DAMAGE_TYPE_MAGICAL)
		end
	end
end
function modifier_enemy_firepath:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Hero_Batrider.Firefly.loop")
	end
end