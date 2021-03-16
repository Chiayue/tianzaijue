LinkLuaModifier("modifier_shadowshaman_1", "abilities/tower/shadowshaman/shadowshaman_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shadowshaman_1_debuff", "abilities/tower/shadowshaman/shadowshaman_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shadowshaman_1_swarm", "abilities/tower/shadowshaman/shadowshaman_1.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
--Abilities
if shadowshaman_1 == nil then
	shadowshaman_1 = class({})
end
function shadowshaman_1:GetIntrinsicModifierName()
	return "modifier_shadowshaman_1"
end
function shadowshaman_1:OnProjectileHit_ExtraData(hTarget, vLocation, table)
	if IsValid(hTarget) then
		local hSwarm = EntIndexToHScript(table.iSwarmIndex)
		if IsValid(hSwarm) then
			local hModifier = hSwarm:FindModifierByName("modifier_shadowshaman_1_swarm")
			if IsValid(hModifier) then
				hModifier.hTarget = hTarget
			end
		end
	end
	ParticleManager:DestroyParticle(table.iParticle, false)
end
------------------------------------------------------------------------------
--Modifiers
if modifier_shadowshaman_1 == nil then
	modifier_shadowshaman_1 = class({}, nil, eom_modifier)
end
function modifier_shadowshaman_1:IsHidden()
	return true
end
function modifier_shadowshaman_1:OnCreated(params)
	if IsServer() then
	end
end
function modifier_shadowshaman_1:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_shadowshaman_1:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_shadowshaman_1:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK_LANDED] = { self:GetParent() }
	}
end
function modifier_shadowshaman_1:OnAttackLanded(params)
	local hCaster = self:GetCaster()
	if hCaster ~= params.attacker then return end
	local hTarget = params.target
	hTarget:AddNewModifier(hCaster, self:GetAbility(), "modifier_shadowshaman_1_debuff", { duration = 10 })
end
---------------------------------------------------------------------
if modifier_shadowshaman_1_debuff == nil then
	modifier_shadowshaman_1_debuff = class({}, nil, BaseModifier)
end
function modifier_shadowshaman_1_debuff:GetEffectName()
	return 'particles/units/heroes/hero_weaver/weaver_swarm_debuff.vpcf'
end
function modifier_shadowshaman_1_debuff:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end
function modifier_shadowshaman_1_debuff:IsDebuff()
	return true
end
function modifier_shadowshaman_1_debuff:OnCreated(params)
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	if IsServer() then
		self.flDamage = self:GetAbility():GetAbilityDamage()
		-- 创建虫子
		local hSwarm = CreateUnitByName('npc_dota_weaver_swarm', hParent:GetAbsOrigin() + hParent:GetForwardVector() * 64, false, hCaster, hCaster, hCaster:GetTeamNumber())
		hSwarm:AddNewModifier(hCaster, self:GetAbility(), "modifier_shadowshaman_1_swarm", { duration = params.duration, target_entindex = hParent:entindex() })
		self:StartIntervalThink(1)
	end
end
function modifier_shadowshaman_1_debuff:OnRefresh(params)
	if IsServer() then
		self.flDamage = self:GetAbility():GetAbilityDamage()
	end
end
function modifier_shadowshaman_1_debuff:OnDestroy()
	if IsServer() then
	end
end
function modifier_shadowshaman_1_debuff:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	if not IsValid(hCaster)
	or not hCaster:IsAlive()
	or (UnitFilter(hCaster, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, self:GetParent():GetTeam()) ~= UF_SUCCESS)
	then
		self:Destroy()
		return
	end

	-- 敌人中蛊毒伤害
	local tDamageInfo = {
		attacker = hCaster,
		victim = hParent,
		ability = self:GetAbility(),
		damage = self.flDamage,
		damage_type = DAMAGE_TYPE_PHYSICAL
	}
	ApplyDamage(tDamageInfo)
end
---------------------------------------------------------------------
--- 虫子身上的buff
if modifier_shadowshaman_1_swarm == nil then
	modifier_shadowshaman_1_swarm = class({})
end
function modifier_shadowshaman_1_swarm:IsHidden()
	return true
end
function modifier_shadowshaman_1_swarm:OnCreated(params)
	self.health_loss = self:GetAbilitySpecialValueFor("health_loss")
	if IsServer() then
		self.hTarget = EntIndexToHScript(params.target_entindex)

		if not self:ApplyHorizontalMotionController() then
			self:Destroy()
			return
		end
	end

	self:StartIntervalThink(1)
end
-- 传染目标
function modifier_shadowshaman_1_swarm:ChangeTarget()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()

	if IsValid(hParent) and IsValid(hCaster) and hParent:IsAlive() then
		local iPlayerID = GetPlayerID(hCaster)
		local tEnemies = Spawner:GetPlayerMissing(iPlayerID)

		local hEnemy
		local vOrigin = hParent:GetAbsOrigin()
		for k, hUnit in pairs(tEnemies) do
			if IsValid(hUnit)
			and hUnit:IsAlive()
			and hUnit:IsPositionInRange(vOrigin, 600)
			and not hUnit:HasModifier("modifier_shadowshaman_1_debuff") then
				hEnemy = hUnit
				break
			end
		end

		if hEnemy then
			local iParticle = ParticleManager:CreateParticle("particles/econ/items/leshrac/leshrac_tormented_staff_retro/leshrac_base_attack_retro_tormented.vpcf", PATTACH_CUSTOMORIGIN, nil) -- 为nil才能在看不见caster的时候就看见弹道特效
			ParticleManager:SetParticleControlEnt(iParticle, 0, hParent, PATTACH_POINT_FOLLOW, "attach_attack1", hParent:GetAbsOrigin(), false)
			ParticleManager:SetParticleControlEnt(iParticle, 1, hEnemy, PATTACH_POINT_FOLLOW, "attach_hitloc", hEnemy:GetAbsOrigin(), false)
			ParticleManager:SetParticleControl(iParticle, 2, Vector(1200, 0, 0))

			local tInfo = {
				Ability = self:GetAbility(),
				Source = hParent,
				Target = hEnemy,
				iMoveSpeed = 1200,
				bDodgeable = false,
				bIsAttack = false,
				ExtraData = {
					iSwarmIndex = hParent:entindex(),
					iParticle = iParticle
				}
			}
			ProjectileManager:CreateTrackingProjectile(tInfo)
		end
	end
end
function modifier_shadowshaman_1_swarm:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)

		self:GetParent():Kill(self:GetAbility(), nil)
	end
end
function modifier_shadowshaman_1_swarm:OnIntervalThink()
	if IsServer() then
		if not IsValid(self.hTarget) then
			self:Destroy()
			return
		end

		local hParent = self:GetParent()
		hParent:ModifyHealth(hParent:GetHealth() - hParent:GetMaxHealth() * self.health_loss * 0.01, self:GetAbility(), true, 0)

		-- 蛊虫攻击敌人
		local tDamageInfo = {
			attacker = self:GetCaster(),
			victim = self.hTarget,
			ability = self:GetAbility(),
			damage = self.flDamage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT
		}
		ApplyDamage(tDamageInfo)

		if not self.hTarget:IsAlive() then
			self:ChangeTarget()
		end
	end
end
function modifier_shadowshaman_1_swarm:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		if not IsValid(self.hTarget)
		or not self.hTarget:IsAlive()
		or (UnitFilter(self.hTarget, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, self:GetParent():GetTeam()) ~= UF_SUCCESS)
		then
			return
		end
		me:SetAbsOrigin(self.hTarget:GetAbsOrigin() + self.hTarget:GetForwardVector() * 64)
		me:FaceTowards(self.hTarget:GetAbsOrigin())
	end
end
function modifier_shadowshaman_1_swarm:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_shadowshaman_1_swarm:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end
function modifier_shadowshaman_1_swarm:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end
function modifier_shadowshaman_1_swarm:GetModifierIncomingDamage_Percentage(tParams)
	return -100
end