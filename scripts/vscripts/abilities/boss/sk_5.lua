LinkLuaModifier("modifier_sk_5", "abilities/boss/sk_5.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sk_5_swipe", "abilities/boss/sk_5.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if sk_5 == nil then
	sk_5 = class({})
end
function sk_5:GetCastAnimation()
	return RollPercentage(50) and ACT_DOTA_CAST_ABILITY_5 or ACT_DOTA_CAST_ABILITY_6
end
function sk_5:OnAbilityPhaseStart()
	if IsServer() then
		-- self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_5)
		self.animation_time = self:GetSpecialValueFor("animation_time")
		self.initial_delay = self:GetSpecialValueFor("initial_delay")

		local kv = {}
		kv["duration"] = self.animation_time
		kv["initial_delay"] = self.initial_delay
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sk_5_swipe", kv)
		self.hModifier = self:GetCaster():AddBuff(self:GetCaster(), BUFF_TYPE.TENACITY)
	end
	return true
end
function sk_5:OnAbilityPhaseInterrupted()
	if IsServer() then
		if self.hModifier then
			self.hModifier:Destroy()
			self:GetCaster():RemoveModifierByName("modifier_sk_5_swipe")
		end
	end
end
function sk_5:GetIntrinsicModifierName()
	return "modifier_sk_5"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_sk_5 == nil then
	modifier_sk_5 = class({}, nil, BaseModifier)
end
function modifier_sk_5:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_sk_5:OnIntervalThink()
	local hParent = self:GetParent()
	if self:GetParent():IsAbilityReady(self:GetAbility()) and not hParent:IsRooted() then
		local vDirection = hParent:GetForwardVector()
		local vRight = hParent:GetRightVector()
		local vLeft = -vRight
		local flQuadrantDistance = 200
		local vBackRightQuadrant = hParent:GetAbsOrigin() + ((-vDirection + vRight) * flQuadrantDistance)
		local vBackLeftQuadrant = hParent:GetAbsOrigin() + ((-vDirection + vLeft) * flQuadrantDistance)
		local backRightEnemies = FindUnitsInRadius(hParent:GetTeamNumber(), vBackRightQuadrant, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
		local backLeftEnemies = FindUnitsInRadius(hParent:GetTeamNumber(), vBackLeftQuadrant, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
		local bEnemiesBehind = true
		if #backRightEnemies == 0 and #backLeftEnemies == 0 then
			bEnemiesBehind = false
		end
		if bEnemiesBehind == true then
			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self:GetAbility():entindex(),
			})
		end
	end
end
function modifier_sk_5:IsHidden()
	return true
end
---------------------------------------------------------------------
if modifier_sk_5_swipe == nil then
	modifier_sk_5_swipe = class({}, nil, BaseModifier)
end
function modifier_sk_5_swipe:IsPurgable()
	return false
end
function modifier_sk_5_swipe:OnCreated(kv)
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter_tell.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
		ParticleManager:SetParticleControlEnt(self.nPreviewFX, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_tail", self:GetCaster():GetOrigin(), true)
		self:AddParticle(self.nPreviewFX, false, false, -1, false, false)

		self.damage_radius = self:GetAbility():GetSpecialValueFor("damage_radius")
		self.damage = self:GetAbility():GetSpecialValueFor("damage") * self:GetCaster():GetAverageTrueAttackDamage(nil)
		self.stun_duration = self:GetAbility():GetSpecialValueFor("stun_duration")
		self.knockback_distance = self:GetAbility():GetSpecialValueFor("knockback_distance")
		self.knockback_height = self:GetAbility():GetSpecialValueFor("knockback_height")
		self.damage = self:GetAbility():GetSpecialValueFor("damage")
		self.slow_duration = self:GetAbility():GetSpecialValueFor("slow_duration")


		self.hHitTargets = {}

		self:StartIntervalThink(kv["initial_delay"])
	end
end
function modifier_sk_5_swipe:OnDestroy()
	if IsValid(self:GetAbility().hModifier) then
		self:GetAbility().hModifier:Destroy()
	end
end
function modifier_sk_5_swipe:OnIntervalThink()
	if IsServer() then
		local tail1 = self:GetParent():ScriptLookupAttachment("attach_tail")
		local tail2 = self:GetParent():ScriptLookupAttachment("attach_tail2")
		local tail3 = self:GetParent():ScriptLookupAttachment("attach_tail3")
		local tail4 = self:GetParent():ScriptLookupAttachment("attach_tail4")
		local vLocation1 = self:GetParent():GetAttachmentOrigin(tail1)
		local vLocation2 = self:GetParent():GetAttachmentOrigin(tail2)
		local vLocation3 = self:GetParent():GetAttachmentOrigin(tail3)
		local vLocation4 = self:GetParent():GetAttachmentOrigin(tail4)
		local Locations = {}
		table.insert(Locations, vLocation1)
		table.insert(Locations, vLocation2)
		table.insert(Locations, vLocation3)
		table.insert(Locations, vLocation4)

		self:StartIntervalThink(0.01)
		for _, vPos in pairs(Locations) do
			--DebugDrawCircle( vPos, Vector( 0, 255, 0 ), 255, self.damage_radius, false, 1.0 )
			local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), vPos, self:GetParent(), self.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
			for _, enemy in pairs(enemies) do
				if enemy ~= nil and enemy:IsInvulnerable() == false and self:HasHitTarget(enemy) == false then
					self:AddHitTarget(enemy)

					local damageInfo =					{
						victim = enemy,
						attacker = self:GetParent(),
						damage = self.damage,
						damage_type = DAMAGE_TYPE_PHYSICAL,
						ability = self,
					}

					ApplyDamage(damageInfo)

					self:GetCaster():KnockBack(self:GetParent():GetAbsOrigin(), enemy, self.knockback_distance, self.knockback_height, self.stun_duration, true)
					-- enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_polar_furbolg_ursa_warrior_thunder_clap", { duration = self.slow_duration } )
					EmitSoundOn("DOTA_Item.Maim", enemy)
				end
			end
		end
	end
end
function modifier_sk_5_swipe:DeclareFunctions()
	local funcs =	{
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}
	return funcs
end
function modifier_sk_5_swipe:GetModifierDisableTurning(params)
	return 1
end
function modifier_sk_5_swipe:HasHitTarget(hTarget)
	for _, target in pairs(self.hHitTargets) do
		if target == hTarget then
			return true
		end
	end

	return false
end
function modifier_sk_5_swipe:AddHitTarget(hTarget)
	table.insert(self.hHitTargets, hTarget)
end