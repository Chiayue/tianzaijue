--Abilities
if meepo_2 == nil then
	meepo_2 = class({ funcCondition = function(self)
		return self:GetCaster():GetHealthPercent() < self:GetSpecialValueFor("trigger_health_pct")
	end }, nil, ability_base_ai)
end
function meepo_2:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	self.health_recover = self:GetSpecialValueFor('health_recover')
	self.time_delay = self:GetSpecialValueFor('time_delay')
	EmitSoundOn("Hero_Meepo.Poof.Channel", hCaster)

	self.nfx = ParticleManager:CreateParticle("particles/units/heroes/hero_meepo/meepo_poof_start.vpcf", PATTACH_POINT, hCaster)
	ParticleManager:SetParticleControl(self.nfx, 0, hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.nfx, 1, hCaster:GetAbsOrigin())

	return true
end

function meepo_2:OnAbilityPhaseInterrupted()
	StopSoundOn("Hero_Meepo.Poof.Channel", self:GetCaster())
	if self.nfx then
		ParticleManager:DestroyParticle(self.nfx, true)
	end
end

function meepo_2:OnSpellStart()
	local hCaster = self:GetCaster()
	if not IsValid(hCaster) then
		return
	end

	local point = self:GetCursorPosition()
	local target = self:GetCursorTarget()

	local damage = self:GetSpecialValueFor("damage")
	local radius = self:GetSpecialValueFor("radius")
	local time_delay = self:GetSpecialValueFor("time_delay")


	StopSoundOn("Hero_Meepo.Poof.Channel", hCaster)
	if self.nfx then
		ParticleManager:DestroyParticle(self.nfx, true)
	end

	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, hUnit in pairs(tTargets) do
		if not hUnit:TriggerSpellAbsorb(self) then
			EmitSoundOn("Hero_Meepo.Poof.Damage", enemy)
			local damage_table = {
				ability = self,
				attacker = hCaster,
				victim = hUnit,
				damage = damage * 0.01 * hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack),
				damage_type = DAMAGE_TYPE_MAGICAL
			}
			ApplyDamage(damage_table)
			EmitSoundOn("Hero_Meepo.Poof.Damage", hUnit)
			hUnit:AddBuff(hCaster, BUFF_TYPE.ROOT, time_delay)
		end
	end

	--位移
	local hBuilding = hCaster:GetBuilding()
	if hBuilding.vLocation then
		FindClearSpaceForUnit(hCaster, hBuilding.vLocation, true)
	end

	--恢复
	hCaster:Heal(hCaster:GetMaxHealth() * self.health_recover * 0.01, self)

	local nfx = ParticleManager:CreateParticle("particles/units/heroes/hero_meepo/meepo_poof_end.vpcf", PATTACH_POINT, hCaster)
	ParticleManager:SetParticleControl(nfx, 0, hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControl(nfx, 1, hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControl(nfx, 2, Vector(radius, radius, radius))
	ParticleManager:ReleaseParticleIndex(nfx)
end