LinkLuaModifier("modifier_sven_1_motion", "abilities/tower/sven/sven_1.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

--Abilities
if sven_1 == nil then
	sven_1 = class({iBehavior = DOTA_ABILITY_BEHAVIOR_UNIT_TARGET, iOrderType = FIND_CLOSEST}, nil, ability_base_ai)
end
function sven_1:GetAOERadius()
	return self:GetSpecialValueFor("bolt_aoe")
end
function sven_1:OnAbilityPhaseStart()
	self.iPreParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_spell_storm_bolt_lightning.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
	ParticleManager:SetParticleControlEnt(self.iPreParticleID, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_sword", self:GetCaster():GetAbsOrigin(), true)
	return true
end
function sven_1:OnAbilityPhaseInterrupted()
	if self.iPreParticleID ~= nil then
		ParticleManager:DestroyParticle(self.iPreParticleID, true)
		self.iPreParticleID = nil
	end
end
function sven_1:OnSpellStart()
	if self.iPreParticleID ~= nil then
		ParticleManager:DestroyParticle(self.iPreParticleID, false)
		self.iPreParticleID = nil
	end

	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	local bolt_speed = self:GetSpecialValueFor("bolt_speed")

	local info =
	{
		Ability = self,
		EffectName = "particles/units/heroes/hero_sven/sven_spell_storm_bolt.vpcf",
		vSourceLoc = hCaster:GetAttachmentOrigin(hCaster:ScriptLookupAttachment("attach_attack2")),
		iMoveSpeed = bolt_speed,
		Target = hTarget,
		Source = hCaster,
		ExtraData = {
		}
	}
	ProjectileManager:CreateTrackingProjectile(info)

	hCaster:EmitSound("Hero_Sven.StormBolt")

	self.vLocation = hCaster:GetAttachmentOrigin(hCaster:ScriptLookupAttachment("attach_attack2"))
	hCaster:AddNewModifier(hCaster, self, "modifier_sven_1_motion", nil)
end
function sven_1:OnProjectileThink_ExtraData(vLocation, ExtraData)
	self.vLocation = vLocation
end
function sven_1:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	local hCaster = self:GetCaster()

	hCaster:RemoveModifierByName("modifier_sven_1_motion")

	if hTarget ~= nil and hTarget:TriggerSpellAbsorb(self) then
		return true
	end

	local bolt_aoe = self:GetSpecialValueFor("bolt_aoe")
	local bolt_stun_duration = self:GetSpecialValueFor("bolt_stun_duration")

	EmitSoundOnLocationWithCaster(vLocation, "Hero_Sven.StormBoltImpact", hCaster)

	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vLocation, bolt_aoe, self)
	for n, hTarget in pairs(tTargets) do
		hCaster:DealDamage(hTarget, self, 0)
		hTarget:AddBuff(hCaster, BUFF_TYPE.STUN, bolt_stun_duration)
		-- hCaster:Attack(hTarget, ATTACK_STATE_SKIPCOOLDOWN + ATTACK_STATE_NOT_USEPROJECTILE)
	end

	return true
end
---------------------------------------------------------------------
--Modifiers
if modifier_sven_1_motion == nil then
	modifier_sven_1_motion = class({}, nil, HorizontalModifier)
end
function modifier_sven_1_motion:GetEffectName()
	return "particles/items_fx/force_staff.vpcf"
end
function modifier_sven_1_motion:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_sven_1_motion:OnCreated(params)
	if IsServer() then
		if not self:ApplyHorizontalMotionController() then
			self:Destroy()
		else
			self:GetParent():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
		end
	end
end
function modifier_sven_1_motion:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
		self:GetParent():RemoveHorizontalMotionController(self)
	end
end
function modifier_sven_1_motion:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local ability = self:GetAbility()
		if not IsValid(ability) then
			self:Destroy()
			return
		end
		me:SetAbsOrigin(ability.vLocation)
	end
end
function modifier_sven_1_motion:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_sven_1_motion:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end