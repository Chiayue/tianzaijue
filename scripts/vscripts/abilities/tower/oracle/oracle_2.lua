LinkLuaModifier("modifier_oracle_2", "abilities/tower/oracle/oracle_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if oracle_2 == nil then
	oracle_2 = class({})
end
function oracle_2:GetIntrinsicModifierName()
	return "modifier_oracle_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_oracle_2 == nil then
	modifier_oracle_2 = class({}, nil, eom_modifier)
end
function modifier_oracle_2:IsHidden()
	return true
end
function modifier_oracle_2:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.health_regen_pct = self:GetAbilitySpecialValueFor("health_regen_pct")
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
	if IsServer() then
	end
end
function modifier_oracle_2:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_oracle_2:OnDeath(params)
	local hParent = self:GetParent()
	if IsServer() and
	-- hParent:IsAlive() and
	-- params.unit ~= hParent and
	params.unit:IsFriendly(hParent) and
	params.unit:IsIllusion() == false and
	params.unit.GetBuilding and
	GSManager:getStateType() == GS_Battle and
	-- (params.unit:GetAbsOrigin() - hParent:GetAbsOrigin()):Length2D() <= self.radius and
	self:GetAbility():IsCooldownReady() then
		params.unit:GetBuilding():RespawnBuildingUnit()
		local flHealAmount = params.unit:GetMaxHealth() * self.health_regen_pct * 0.01
		params.unit:ModifyHealth(flHealAmount, self:GetAbility(), false, 0)
		SendOverheadEventMessage(params.unit:GetPlayerOwner(), OVERHEAD_ALERT_HEAL, params.unit, flHealAmount, params.unit:GetPlayerOwner())
		-- sound
		params.unit:EmitSound("Hero_Oracle.FalsePromise.Healed")
		self:GetAbility():UseResources(false, false, true)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_cast_enemy.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.unit)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		-- 伤害最近的单位
		local flDamage = flHealAmount * self.damage_pct * 0.01
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, self:GetAbility(), FIND_CLOSEST)
		ArrayRemove(tTargets, hParent)
		ArrayRemove(tTargets, params.unit)
		if IsValid(tTargets[1]) then
			local hTarget = tTargets[1]
			if hTarget:IsFriendly(hParent) then
				hTarget:ModifyHealth(hTarget:GetHealth() - flDamage, self:GetAbility(), false, 0)
			else
				hParent:DealDamage(hTarget, self:GetAbility(), flDamage)
			end
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
			ParticleManager:ReleaseParticleIndex(iParticleID)
			-- sound
			hTarget:EmitSound("Hero_Oracle.FalsePromise.Damaged")
		end
	end
end
function modifier_oracle_2:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH
	}
end