LinkLuaModifier("modifier_tinker_1", "abilities/tower/tinker/tinker_1.lua", LUA_MODIFIER_MOTION_NONE)

if tinker_1 == nil then
	tinker_1 = class({}, nil, base_attack)
end
function tinker_1:GetAttackProjectile()
	if self:GetCaster():HasModifier("modifier_tinker_2_buff") then
		return "particles/econ/items/tinker/tinker_ti10_immortal_laser/tinker_ti10_immortal_laser.vpcf"
	end
	return "particles/units/heroes/hero_tinker/tinker_laser.vpcf"
end
function tinker_1:GetAttackAnimation()
	return ACT_DOTA_CAST_ABILITY_1
end
function tinker_1:OnAttackRecordDestroy(params)
end
function tinker_1:DoAttackBehavior(params)
	local hCaster = self:GetCaster()
	local hTarget = params.target
	local bonuce_count = self:GetSpecialValueFor("bonuce_count")
	self:Laser(hCaster, hTarget, params, bonuce_count, {hTarget})
	hCaster:EmitSound("Hero_Tinker.Laser")
end
function tinker_1:Laser(hSource, hTarget, params, iBounceCount, tUnits)
	local hCaster = self:GetCaster()
	EModifier:NotifyEvt(EMDF_EVENT_ON_ATTACK_HIT, hTarget, params)
	self:OnDamage(hTarget, params)
	hTarget:AddNewModifier(hCaster, self, "modifier_tinker_1", {duration = self:GetDuration()})
	local iParticleID = ParticleManager:CreateParticle(self:GetAttackProjectile(), PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(iParticleID, 9, hSource, PATTACH_POINT_FOLLOW, (hSource == hCaster and "attach_attack2" or "attach_hitloc"), hSource:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	if iBounceCount > 0 then
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, hTarget:GetAbsOrigin(), self:GetSpecialValueFor("bounce_radius"), self, FIND_CLOSEST)
		for _, hUnit in pairs(tTargets) do
			if TableFindKey(tUnits, hUnit) == nil then
				table.insert(tUnits, hUnit)
				self:Laser(hTarget, hUnit, params, iBounceCount - 1, tUnits)
				return
			end
		end
		DelAttackInfo(params.record)
	else
		DelAttackInfo(params.record)
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_tinker_1 == nil then
	modifier_tinker_1 = class({}, nil, BaseModifier)
end
function modifier_tinker_1:IsDebuff()
	return true
end
function modifier_tinker_1:OnCreated(params)
	self.blind = self:GetAbilitySpecialValueFor("blind")
end
function modifier_tinker_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MISS_PERCENTAGE
	}
end
function modifier_tinker_1:GetModifierMiss_Percentage(params)
	return self.blind
end