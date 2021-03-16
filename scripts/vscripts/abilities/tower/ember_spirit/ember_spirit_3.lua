LinkLuaModifier("modifier_ember_spirit_3_remnant", "abilities/tower/ember_spirit/ember_spirit_3.lua", LUA_MODIFIER_MOTION_NONE)

if ember_spirit_3 == nil then
	ember_spirit_3 = class({})
end
function ember_spirit_3:Spawn()
	self.tRemnant = {}
end
function ember_spirit_3:CreateRemnant(vStart, vPosition)
	local hCaster = self:GetCaster()
	local chance = self:GetSpecialValueFor("chance")
	if not RollPercentage(chance) then
		return
	end
	local info = {
		EffectName = "particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant_trail.vpcf",
		Ability = self,
		vSpawnOrigin = vStart,
		fDistance = (vPosition - vStart):Length2D(),
		vVelocity = (vPosition - vStart):Normalized() * 1800,
		fStartRadius = 100,
		fEndRadius = 100,
		Source = hCaster,
		iUnitTargetTeam = self:GetAbilityTargetTeam(),
		iUnitTargetType = self:GetAbilityTargetType(),
		iUnitTargetFlags = self:GetAbilityTargetFlags(),
	}

	ProjectileManager:CreateLinearProjectile(info)
end
function ember_spirit_3:OnProjectileHit(hTarget, vLocation)
	local hCaster = self:GetCaster()
	if hTarget == nil then

		local count = self:GetSpecialValueFor("count")
		if count <= #self.tRemnant then
			-- 引爆最早的火灵
			local hUnit = self.tRemnant[1]
			if IsValid(hUnit) then
				local hBuff = hUnit:FindModifierByName('modifier_ember_spirit_3_remnant')
				if IsValid(hBuff) then
					hBuff:Destroy()
				end
			end
			table.remove(self.tRemnant, 1)
		end

		local hUnit = CreateUnitByName(hCaster:GetUnitName(), vLocation, true, hCaster:GetPlayerOwner(), hCaster:GetPlayerOwner(), hCaster:GetTeamNumber())
		for i = 0, 5 do
			local hAbility = hUnit:GetAbilityByIndex(i)
			if IsValid(hAbility) then
				hUnit:RemoveAbilityByHandle(hAbility)
			end
		end
		hUnit:AddAbility("base_attack_ember_spirit_remnant"):SetLevel(1)
		Attributes:Register(hUnit)
		hUnit:AddNewModifier(hCaster, self, "modifier_ember_spirit_3_remnant", { duration = self:GetDuration() })
		hUnit:FireSummonned(hCaster)
		table.insert(self.tRemnant, hUnit)
	end
end
---------------------------------------------------------------------
---Modifiers
if modifier_ember_spirit_3_remnant == nil then
	modifier_ember_spirit_3_remnant = class({}, nil, eom_modifier)
end
function modifier_ember_spirit_3_remnant:IsHidden()
	return true
end
function modifier_ember_spirit_3_remnant:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.flAttack = self:GetCaster():GetValConst(ATTRIBUTE_KIND.PhysicalAttack) * self:GetAbilitySpecialValueFor("damage_pct") * 0.01
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/ember_spirit_fire_remnant.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		self:AddParticle(iParticleID, false, true, 10, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_ember_spirit_3_remnant:OnDestroy()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		hParent:MakeIllusion()
		-- hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_illusion", nil)
		hParent:AddNoDraw()
		hParent:ForceKill(false)
		ArrayRemove(self:GetAbility(), hParent)

		-- 范围伤害
		if IsValid(hCaster) then
			local tTargets = FindUnitsInRadiusWithAbility(hCaster, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
			hCaster:DealDamage(tTargets, self:GetAbility())
		end
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_hit.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_ember_spirit_3_remnant:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end
function modifier_ember_spirit_3_remnant:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		[EMDF_MAGICAL_ATTACK_BONUS_UNIQUE] = self.flAttack
	}
end
function modifier_ember_spirit_3_remnant:GetPhysicalAttackBonusPercentage()
	if self._flag then
		self._flag = nil
		return 0
	end
	self._flag = true
	return self:GetParent():GetValPercent(ATTRIBUTE_KIND.PhysicalAttack) * -100
end
function modifier_ember_spirit_3_remnant:GetMagicalAttackBonusUnique()
	return self.flAttack
end