LinkLuaModifier("modifier_skeleton_king_2_debuff", "abilities/tower/skeleton_king/skeleton_king_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_2_attack_speed", "abilities/tower/skeleton_king/skeleton_king_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_2_force_attack", "abilities/tower/skeleton_king/skeleton_king_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if skeleton_king_2 == nil then
	skeleton_king_2 = class({iOrderType=FIND_CLOSEST}, nil, ability_base_ai)
end
function skeleton_king_2:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function skeleton_king_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local blast_speed = self:GetSpecialValueFor("blast_speed")
	local radius = self:GetSpecialValueFor("radius")

	local tSummons = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, 2000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
	for _, hSummon in pairs(tSummons) do
		if hSummon:IsSummoned() and hSummon:GetSummoner() == hCaster then
			hSummon:RemoveModifierByName("modifier_skeleton_king_2_force_attack")
			hSummon:AddNewModifier(hCaster, self, "modifier_skeleton_king_2_force_attack", {duration=2, target_ent_index=hTarget:entindex()})
		end
	end

	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hTarget:GetAbsOrigin(), radius, self, FIND_CLOSEST)

	for _, hUnit in pairs(tTargets) do
		ProjectileManager:CreateTrackingProjectile({
			Ability = self,
			Source = hCaster,
			Target = hUnit,
			EffectName = "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_wraithfireblast.vpcf",
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
			iMoveSpeed = blast_speed,
		})
	end

	hCaster:EmitSound("Hero_SkeletonKing.Hellfire_Blast")
end
function skeleton_king_2:OnProjectileHit(hTarget, vLocation)
	local hCaster = self:GetCaster()

	if not IsValid(hTarget) then
		return true
	end

	EmitSoundOnLocationWithCaster(vLocation, "Hero_SkeletonKing.Hellfire_BlastImpact", hCaster)

	local blast_damage = self:GetSpecialValueFor("blast_damage")
	local blast_stun_duration = self:GetSpecialValueFor("blast_stun_duration")
	local blast_dot_duration = self:GetSpecialValueFor("blast_dot_duration")

	hTarget:AddBuff(hCaster, BUFF_TYPE.STUN, blast_stun_duration)
	hTarget:AddNewModifier(hCaster, self, "modifier_skeleton_king_2_debuff", { duration = blast_dot_duration + GetStatusDebuffDuration(blast_stun_duration, hTarget, hCaster), stun_duration = GetStatusDebuffDuration(blast_stun_duration, hTarget, hCaster) })

	ApplyDamage({
		attacker = hCaster,
		victim = hTarget,
		ability = self,
		damage = blast_damage * hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack)*0.01,
		damage_type = self:GetAbilityDamageType(),
	})

	return true
end
---------------------------------------------------------------------
--Modifiers
if modifier_skeleton_king_2_debuff == nil then
	modifier_skeleton_king_2_debuff = class({}, nil, eom_modifier)
end
function modifier_skeleton_king_2_debuff:IsHidden()
	return false
end
function modifier_skeleton_king_2_debuff:IsDebuff()
	return true
end
function modifier_skeleton_king_2_debuff:IsPurgable()
	return true
end
function modifier_skeleton_king_2_debuff:IsPurgeException()
	return true
end
function modifier_skeleton_king_2_debuff:IsStunDebuff()
	return false
end
function modifier_skeleton_king_2_debuff:AllowIllusionDuplicate()
	return false
end
function modifier_skeleton_king_2_debuff:GetEffectName()
	return "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_wraithfireblast_debuff.vpcf"
end
function modifier_skeleton_king_2_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_skeleton_king_2_debuff:OnCreated(params)
	self.blast_dot_damage = self:GetAbilitySpecialValueFor("blast_dot_damage")
	if IsServer() then
		self:StartIntervalThink(params.stun_duration or 0)
	end
end
function modifier_skeleton_king_2_debuff:OnRefresh(params)
	self.blast_dot_damage = self:GetAbilitySpecialValueFor("blast_dot_damage")
	if IsServer() then
	end
end
function modifier_skeleton_king_2_debuff:OnDestroy()
	if IsServer() then
	end
end
function modifier_skeleton_king_2_debuff:OnIntervalThink()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		if not IsValid(hCaster) or not IsValid(hAbility) then
			self:Destroy()
			return
		end

		ApplyDamage({
			attacker = hCaster,
			victim = hTarget,
			ability = hAbility,
			damage = self.blast_dot_damage * hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack)*0.01,
			damage_type = hAbility:GetAbilityDamageType(),
		})

		self:StartIntervalThink(1)
	end
end
function modifier_skeleton_king_2_debuff:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK_START] = {nil, self:GetParent()},
	}
end
function modifier_skeleton_king_2_debuff:OnAttackStart(params)
	local hAbility = self:GetAbility()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	if params.target == hParent and (params.attacker == hCaster or params.attacker:GetSummoner() == hCaster) then
		params.attacker:AddNewModifier(hParent, self:GetAbility(), "modifier_skeleton_king_2_attack_speed", nil)
	end
end
---------------------------------------------------------------------
if modifier_skeleton_king_2_attack_speed == nil then
	modifier_skeleton_king_2_attack_speed = class({}, nil, eom_modifier)
end
function modifier_skeleton_king_2_attack_speed:IsHidden()
	return false
end
function modifier_skeleton_king_2_attack_speed:IsDebuff()
	return false
end
function modifier_skeleton_king_2_attack_speed:IsPurgable()
	return false
end
function modifier_skeleton_king_2_attack_speed:IsPurgeException()
	return false
end
function modifier_skeleton_king_2_attack_speed:IsStunDebuff()
	return false
end
function modifier_skeleton_king_2_attack_speed:OnCreated(params)
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")
	if IsServer() then
		self:StartIntervalThink(0)
		self:OnIntervalThink()
	end
end
function modifier_skeleton_king_2_attack_speed:OnRefresh(params)
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")
end
function modifier_skeleton_king_2_attack_speed:OnIntervalThink()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		if not hParent:IsAttacking() or not IsValid(hCaster) or not hCaster:HasModifier("modifier_skeleton_king_2_debuff") or hParent:GetAttackTarget() ~= hCaster then
			self:SetDuration(hParent:TimeUntilNextAttack(), true)
			self:StartIntervalThink(-1)
		end
	end
end
function modifier_skeleton_king_2_attack_speed:EDeclareFunctions()
	return {
		EMDF_ATTACKT_SPEED_BONUS,
	}
end
function modifier_skeleton_king_2_attack_speed:GetAttackSpeedBonus()
	return self.bonus_attack_speed
end
function modifier_skeleton_king_2_attack_speed:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_skeleton_king_2_attack_speed:OnTooltip()
	return self.bonus_attack_speed
end
---------------------------------------------------------------------
if modifier_skeleton_king_2_force_attack == nil then
	modifier_skeleton_king_2_force_attack = class({}, nil, eom_modifier)
end
function modifier_skeleton_king_2_force_attack:IsHidden()
	return true
end
function modifier_skeleton_king_2_force_attack:IsDebuff()
	return false
end
function modifier_skeleton_king_2_force_attack:IsPurgable()
	return false
end
function modifier_skeleton_king_2_force_attack:IsPurgeException()
	return false
end
function modifier_skeleton_king_2_force_attack:IsStunDebuff()
	return false
end
function modifier_skeleton_king_2_force_attack:AllowIllusionDuplicate()
	return false
end
function modifier_skeleton_king_2_force_attack:OnCreated(params)
	local hParent = self:GetParent()
	if IsServer() then
		self:StartIntervalThink(0.1)
		self.hTarget = EntIndexToHScript(params.target_ent_index or -1)
		if IsValid(self.hTarget) and self.hTarget:IsAlive() then
			self.hForceTarget = hParent:GetForceAttackTarget()
			hParent:SetForceAttackTarget(nil)

			ExecuteOrderFromTable({
				UnitIndex = hParent:entindex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
				TargetIndex = self.hTarget:entindex()
			})

			hParent:SetForceAttackTarget(self.hTarget)
		else
			self:Destroy()
		end
	end
end
function modifier_skeleton_king_2_force_attack:OnDestroy()
	if IsServer() then
		if IsValid(self.hForceTarget) and self.hForceTarget:IsAlive() then
			self:GetParent():SetForceAttackTarget(self.hForceTarget)
		else
			self:GetParent():SetForceAttackTarget(nil)
		end
	end
end
function modifier_skeleton_king_2_force_attack:OnIntervalThink()
	if IsServer() then
		if not IsValid(self.hTarget) or not self.hTarget:IsAlive() then
			self:Destroy()
			return
		end
	end
end
