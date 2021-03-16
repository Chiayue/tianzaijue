LinkLuaModifier("modifier_sk_1", "abilities/boss/sk_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sk_1_stun", "abilities/boss/sk_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sk_1_impale", "abilities/boss/sk_1.lua", LUA_MODIFIER_MOTION_VERTICAL)
LinkLuaModifier("modifier_sk_1_end", "abilities/boss/sk_1.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
--Abilities
if sk_1 == nil then
	sk_1 = class({})
end
function sk_1:OnAbilityPhaseStart()
	self:GetCaster():AddBuff(self:GetCaster(), BUFF_TYPE.TENACITY, self:GetCastPoint())
	return true
end
function sk_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local vTarget = self:GetCursorPosition()
	local min_distance = 1000
	local flDistance = (vTarget - hCaster:GetAbsOrigin()):Length2D()
	self.vTarget = flDistance < min_distance and hCaster:GetAbsOrigin() + (vTarget - hCaster:GetAbsOrigin()):Normalized() * min_distance or vTarget

	local burrow_width = self:GetSpecialValueFor("burrow_width")
	local burrow_speed = self:GetSpecialValueFor("burrow_speed")

	hCaster:EmitSound('Ability.SandKing_BurrowStrike')
	local iPtclID = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement('particles/econ/items/sand_king/sandking_barren_crown/sandking_rubyspire_burrowstrike.vpcf', hCaster), PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iPtclID, 0, hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControl(iPtclID, 1, self.vTarget)
	ParticleManager:SetParticleFoWProperties(iPtclID, 0, 1, burrow_width)
	ParticleManager:ReleaseParticleIndex(iPtclID)
	
	local vDirection = (self.vTarget - hCaster:GetAbsOrigin()):Normalized()
	vDirection.z = 0
	if vDirection == Vector(0, 0, 0) then
		vDirection = hCaster:GetForwardVector()
	end
	local qAngle = VectorToAngles(vDirection)
	hCaster:SetLocalAngles(qAngle[1], qAngle[2], qAngle[3])

	local info = {
		Ability = self,
		Source = hCaster,
		vSpawnOrigin = hCaster:GetAbsOrigin(),
		vVelocity = (self.vTarget - hCaster:GetAbsOrigin()):Normalized() * burrow_speed,
		fDistance = (self.vTarget - hCaster:GetAbsOrigin()):Length2D(),
		fStartRadius = burrow_width,
		fEndRadius = burrow_width,
		iUnitTargetTeam = self:GetAbilityTargetTeam(),
		iUnitTargetType = self:GetAbilityTargetType(),
	}
	ProjectileManager:CreateLinearProjectile(info)
	hCaster:AddNewModifier(hCaster, self, 'modifier_sk_1_stun', {duration=math.max(0.53, info.fDistance/burrow_speed)})
	hCaster:AddEffects( EF_NODRAW )
end
function sk_1:IsHiddenWhenStolen()
	return false
end
function sk_1:OnProjectileHit(hTarget, vLocation)
	local hCaster = self:GetCaster()
	if not IsValid(hTarget) then
		hCaster:SetAbsOrigin(self.vTarget)
		FindClearSpaceForUnit(hCaster, hCaster:GetAbsOrigin(), true)
		
		self.vDir = hCaster:GetForwardVector()
		local kv = 
		{
			x = self.vDir.x,
			y = self.vDir.y,
			z = self.vDir.z,
		}
		hCaster:AddNewModifier(hCaster, self, 'modifier_sk_1_end', kv)
		hCaster:RemoveEffects( EF_NODRAW )
		
		return
	end
	if self:CastFilterResultTarget(hTarget) == UF_SUCCESS and not hTarget:TriggerSpellAbsorb(self) then
		local burrow_anim_time = self:GetSpecialValueFor("burrow_anim_time")
		local burrow_duration = self:GetSpecialValueFor('burrow_duration')

		hTarget:AddNewModifier(hCaster, self, 'modifier_stunned', {duration = burrow_duration * hTarget:GetStatusResistanceFactor()})
		hTarget:RemoveModifierByName('modifier_sk_1_impale')
		hTarget:AddNewModifier(hCaster, self, 'modifier_sk_1_impale', { duration = burrow_anim_time })
		self.vDir = hCaster:GetForwardVector()
		local kv = 
		{
			x = self.vDir.x,
			y = self.vDir.y,
			z = self.vDir.z,
		}
		hTarget:AddNewModifier(hCaster, self, 'modifier_sk_1_end', kv)
		hTarget:SetAbsOrigin(self.vTarget)
	end
end
function sk_1:GetIntrinsicModifierName()
	return "modifier_sk_1"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_sk_1 == nil then
	modifier_sk_1 = class({}, nil, BaseModifier)
end
function modifier_sk_1:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_sk_1:OnIntervalThink()
	if self:GetParent():IsAbilityReady(self:GetAbility()) then
		local radius = self:GetAbility():GetCastRange(self:GetCaster():GetAbsOrigin(), nil)
		local tTargets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, self:GetAbility():GetAbilityTargetTeam(), self:GetAbility():GetAbilityTargetType(), self:GetAbility():GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
		if IsValid(tTargets[1]) then
			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = self:GetAbility():entindex(),
				Position = tTargets[1]:GetAbsOrigin()
			})
		end
	end
end
function modifier_sk_1:IsHidden()
	return true
end
---------------------------------------------------------------------
if modifier_sk_1_stun == nil then
	modifier_sk_1_stun = class({})
end
function modifier_sk_1_stun:IsHidden()
	return true
end
function modifier_sk_1_stun:IsPurgable()
	return false
end
function modifier_sk_1_stun:IsStunDebuff()
	return true
end
function modifier_sk_1_stun:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end
---------------------------------------------------------------------
if modifier_sk_1_impale == nil then
	modifier_sk_1_impale = class({})
end
function modifier_sk_1_impale:IsHidden()
	return false
end
function modifier_sk_1_impale:IsPurgable()
	return false
end
function modifier_sk_1_impale:IsPurgeException()
	return true
end
function modifier_sk_1_impale:IsStunDebuff()
	return true
end
function modifier_sk_1_impale:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end
function modifier_sk_1_impale:OnCreated(params)
	self.epicenter_radius = self:GetAbilitySpecialValueFor('epicenter_radius')
	self.epicenter_damage = self:GetAbilitySpecialValueFor('epicenter_damage')
	if IsServer() then
		if not self:ApplyVerticalMotionController() then
			self:Destroy()
			return
		end
		self.vS = self:GetParent():GetAbsOrigin()
		self.vDirection = self:GetParent():GetUpVector()
		local iDis = 350
		self.fGravity = 2 * iDis / ((self:GetDuration() / 2) * (self:GetDuration() / 2))
		self.vVelocity = self.fGravity * (self:GetDuration() / 2)

		--
		self.damage = self:GetAbility():GetAbilityDamage()
		self.type_damage = self:GetAbility():GetAbilityDamageType()
	end
end
function modifier_sk_1_impale:OnDestroy()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		if not IsValid(hCaster) and not IsValid(hParent) then
			return
		end
		hParent:RemoveVerticalMotionController(self)
		local damage_table = {
			ability = self:GetAbility(),
			attacker = hCaster,
			victim = hParent,
			damage = self.damage,
			damage_type = self.type_damage
		}
		ApplyDamage(damage_table)

		--IMBA:落地地震
		damage_table.damage = self.epicenter_damage
		local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.epicenter_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_CLOSEST, false)
		for _, hTarget in pairs(tTargets) do
			damage_table.victim = hTarget
			ApplyDamage(damage_table)
		end
		local iPtclID = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_CUSTOMORIGIN, nil)
		-- ParticleManager:SetParticleControlEnt(iPtclID, 0, hParent, PATTACH_ROOTBONE_FOLLOW, "attach_hitloc", GetGroundPosition(hParent:GetAbsOrigin(), nil), true)
		ParticleManager:SetParticleControl(iPtclID, 0, GetGroundPosition(hParent:GetAbsOrigin(), nil))
		ParticleManager:SetParticleControl(iPtclID, 1, Vector(self.epicenter_radius, self.epicenter_radius, self.epicenter_radius))
		ParticleManager:ReleaseParticleIndex(iPtclID)
	end
end
function modifier_sk_1_impale:UpdateVerticalMotion(me, dt)
	if IsServer() then
		local vPos = me:GetAbsOrigin() + Vector(0, 0, self.vVelocity * dt)
		-- local fDis = (vPos - self.vS):Length2D()
		-- if fDis > self.radius then
		--	 vPos = self.vDirection * self.radius + self.vS
		-- end
		if GridNav:CanFindPath(me:GetAbsOrigin(), vPos) then
			me:SetAbsOrigin(vPos)
		end
		self.vVelocity = self.vVelocity - self.fGravity * dt
	end
end
function modifier_sk_1_impale:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_sk_1_impale:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end
function modifier_sk_1_impale:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end
function modifier_sk_1_impale:GetOverrideAnimation(params)
	return ACT_DOTA_FLAIL
end
---------------------------------------------------------------------
if modifier_sk_1_end == nil then
	modifier_sk_1_end = class({})
end
function modifier_sk_1_end:IsPurgable()
	return false
end
function modifier_sk_1_end:IsHidden()
	return true
end
function modifier_sk_1_end:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end
function modifier_sk_1_end:OnCreated( kv )
	self.burrow_anim_time = self:GetAbilitySpecialValueFor('burrow_anim_time')
	self.radius = self:GetAbilitySpecialValueFor('radius')
	self.burrow_duration = self:GetAbilitySpecialValueFor('burrow_duration')
	if IsServer() then
		self.vDir = Vector( kv["x"], kv["y"], kv["z"] )

		local flHealthPct = self:GetParent():GetHealthPercent() / 100
		self.speed = 1000

		self.delay = self.burrow_anim_time
		self.damage = 0
		self.stun_duration = self.burrow_duration
		self.knockback_distance = 0
		self.knockback_height = 0

		self.bExitGround = false

		self:StartIntervalThink( 0.1 )
		

		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
			return
		end
	end
end
function modifier_sk_1_end:OnIntervalThink()
	if IsServer() then
		if self.bExitGround == false then
			EmitSoundOn( "SandKingBoss.BurrowStrike", self:GetParent() )
			self.bExitGround = true
			self:StartIntervalThink( self.delay - 0.1 )
		else
			if self:GetParent() == self:GetCaster() then
				local tTargets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_CLOSEST, false)
				for _, hTarget in pairs(tTargets) do
					hTarget:AddNewModifier(self:GetParent(), self:GetAbility(), 'modifier_stunned', { duration = 2 * hTarget:GetStatusResistanceFactor() })
					local damage_table = {
						ability = self:GetAbility(),
						attacker = self:GetParent(),
						victim = hTarget,
						damage = 300,
						damage_type = DAMAGE_TYPE_MAGICAL
					}
					ApplyDamage(damage_table)
				end
				local nFXCastIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_physical.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
				ParticleManager:SetParticleControl( nFXCastIndex, 1, Vector( self.radius, self.radius, self.radius ) )
				ParticleManager:ReleaseParticleIndex( nFXCastIndex )
				EmitSoundOn( "Burrower.Explosion", self:GetCaster() )
			end
			self:Destroy()
		end	
	end
end
function modifier_sk_1_end:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		local vNewLocation = self:GetParent():GetOrigin() + self.vDir * ( self.speed / 2 ) * dt
		if GridNav:CanFindPath(self:GetParent():GetAbsOrigin(), vNewLocation) then
			me:SetAbsOrigin(vNewLocation)
		end
		me:SetOrigin( vNewLocation )
	end
end
function modifier_sk_1_end:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_sk_1_end:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController( self )
	end
end
function modifier_sk_1_end:CheckState()
	if IsServer() then
		local state =
		{
			[MODIFIER_STATE_INVISIBLE] = self.bExitGround ~= true,
			[MODIFIER_STATE_STUNNED] = true,
		}
		return state
	end
end
function modifier_sk_1_end:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}
	return funcs
end
function modifier_sk_1_end:GetModifierDisableTurning( params )
	return 1
end
function modifier_sk_1_end:GetOverrideAnimation( params )
	return ACT_DOTA_SAND_KING_BURROW_OUT
end
function modifier_sk_1_end:GetOverrideAnimationRate( params )
	return 0.5 
end
function modifier_sk_1_end:GetActivityTranslationModifiers( params )
	return "sandking_rubyspire_burrowstrike"
end
