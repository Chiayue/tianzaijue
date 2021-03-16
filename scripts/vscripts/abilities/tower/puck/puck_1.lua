LinkLuaModifier("modifier_puck_1", "abilities/tower/puck/puck_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_puck_1_orb_fire", "abilities/tower/puck/puck_1.lua", LUA_MODIFIER_MOTION_NONE)


if puck_1 == nil then
	puck_1 = class({})
end
function puck_1:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("search_enemy_radius")
end
function puck_1:OnSpellStart()
	local hCaster = self:GetCaster()
end
function puck_1:GetIntrinsicModifierName()
	return "modifier_puck_1"
end
function puck_1:OnProjectileHit(hTarget, vLocation)
	if IsValid(hTarget) then
		local hCaster = self:GetCaster()
		if not IsValid(hCaster) or not hCaster:IsAlive() then
			return
		end

		EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_Puck.IIllusory_Orb_Damage", hCaster)

		local damage_target_current_mana_pct = self:GetSpecialValueFor("damage_target_current_mana_pct")
		local damage_maximum_caster_mana_pct = self:GetSpecialValueFor("damage_maximum_caster_mana_pct")

		local fTargetMana = hTarget:GetMana()
		local fCasterMaximumMana = hCaster:GetMaxMana() -- TODO:

		local fDamage = damage_target_current_mana_pct * fTargetMana * 0.01 + fCasterMaximumMana * damage_maximum_caster_mana_pct * 0.01
		local damage_table = {
			ability = self,
			attacker = hCaster,
			victim = hTarget,
			damage = fDamage,
			damage_type = DAMAGE_TYPE_MAGICAL
		}
		ApplyDamage(damage_table)

		-- 击中触发2技能回蓝
		local hAbility2 = hCaster:FindAbilityByName("puck_2")
		if IsValid(hAbility2) and hAbility2.OnAbility1Hit then
			hAbility2:OnAbility1Hit(hTarget)
		end
	end
end

---------------------------------------------------------------------
-- Modifiers
if modifier_puck_1 == nil then
	modifier_puck_1 = class({}, nil, eom_modifier)
end
function modifier_puck_1:OnCreated(params)
	self.roaming_seconds_per_rotation = self:GetAbilitySpecialValueFor("roaming_seconds_per_rotation")
	self.roaming_radius = self:GetAbilitySpecialValueFor("roaming_radius")
	self.search_enemy_radius = self:GetAbilitySpecialValueFor("search_enemy_radius")
	self.fire_cooldown = self:GetAbilitySpecialValueFor("fire_cooldown")
	self.orb_speed = self:GetAbilitySpecialValueFor("orb_speed")
	self.max_count = self:GetAbilitySpecialValueFor("max_count")

	self.hParent = self:GetParent()

	if IsServer() then
		self.tOrbs = {}
		self.tOrbPool = {}
		self.hOrbBox = CreateModifierThinker(self.hParent, nil, "modifier_dummy", {}, Vector(0, 0, 0), DOTA_TEAM_NOTEAM, false)
		self.hOrbBox:SetParent(self.hParent, '')
		self.hOrbBox:SetLocalOrigin(Vector(0, 0, 0))
		self.hOrbBox:GameTimer(0, function()
			self.hOrbBox:SetAngles(0, RemapVal(self:GetElapsedTime() % self.roaming_seconds_per_rotation, 0, self.roaming_seconds_per_rotation, 0, 360), 0)
			return 0
		end)

		self:GetAbility():GameTimer('UpdateAllOrbs', 0, function()
			if IsValid(self) then
				local hParent = self:GetParent()
				if hParent:IsAlive() and not hParent:PassivesDisabled() then
					self:UpdateOrbActiveState()
				end
				return self:GetAbility():GetCooldown(self:GetAbility():GetLevel() - 1)
			end
		end)

		self:StartIntervalThink(0.1)

	end
end
function modifier_puck_1:OnDestroy()
	self:StartIntervalThink(-1)
	if self.tOrbPool then
		for k, hOrb in pairs(self.tOrbPool) do
			if hOrb.iParticle ~= nil then
				ParticleManager:DestroyParticle(hOrb.iParticle, true)
			end
			if IsValid(self.tOrbPool) then
				hOrb:ForceKill(false)
				UTIL_Remove(hOrb)
			end
		end
	end
	if IsValid(self.hOrbBox) then
		self.hOrbBox:ForceKill(false)
		UTIL_Remove(self.hOrbBox)
		self.hOrbBox = nil
	end
end
function modifier_puck_1:OnIntervalThink()
	local hParent = self:GetParent()

	if hParent:PassivesDisabled() then return end
	if not hParent:IsAlive() then return end

	if self.iFire then
		if self:SearchEnemy() then
			self.iFire = self.iFire - 1
			if 0 < self.iFire then
				self:StartIntervalThink(self.fire_cooldown)
			else
				self.iFire = nil
				self:StartIntervalThink(0.1)
			end
		else
			self:StartIntervalThink(0.1)
		end
	else
		if self.max_count <= self:GetStackCount() then
			self.iFire = self:GetStackCount()
		end
	end
end

function modifier_puck_1:OnAbilityFullyCast(params)
	local hCaster = params.unit
	local hAbility = params.ability
	if not IsValid(hAbility)
	or hAbility:IsItem()
	then
		return
	end

	if self.search_enemy_radius >= (hCaster:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() then
		-- 范围内单位施法施法时获得一个法球
		self:CreateObr()
	end
end

---创建一个球体
function modifier_puck_1:CreateObr()
	if self.max_count <= #self.tOrbs then
		return
	end

	local hOrb = FIND(self.tOrbPool, function(v)
		return not v.bShow
	end).value
	if not hOrb then
		hOrb = CreateModifierThinker(self.hParent, nil, "modifier_dummy", {}, Vector(0, 0, 0), DOTA_TEAM_NOTEAM, false)
		table.insert(self.tOrbPool, hOrb)
		hOrb:SetParent(self.hOrbBox, '')
		hOrb.iParticle = ParticleManager:CreateParticle("particles/units/heroes/puck/puck_1illusory_orb_1_main.vpcf", PATTACH_ABSORIGIN_FOLLOW, hOrb)
		ParticleManager:SetParticleControlEnt(hOrb.iParticle, 3, hOrb, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hOrb:GetAbsOrigin(), false)
	end
	hOrb:RemoveNoDraw()
	hOrb.bShow = true

	table.insert(self.tOrbs, hOrb)
	self:SetStackCount(#self.tOrbs)
	self:UpdateObrsPos()
end
---更新球体位置
function modifier_puck_1:UpdateObrsPos()
	local fAge = 360 / #self.tOrbs

	local vPosLoc
	if 1 == #self.tOrbs then
		vPosLoc = (self:GetParent():GetForwardVector() * -self.roaming_radius)
	else
		vPosLoc = self.tOrbs[1]:GetLocalOrigin()
	end
	vPosLoc.z = 0

	for i = 1, #self.tOrbs do
		local v = RotatePosition(Vector(0, 0, 0), QAngle(0, (fAge * (i - 1)), 0), vPosLoc)
		v.z = 128
		self.tOrbs[i]:SetLocalOrigin(v)
	end
end

-- server
-- 刷新：当CD转好时 激活全部法球
function modifier_puck_1:UpdateOrbActiveState()
	local hParent = self:GetParent()
	if IsValid(hParent) and hParent:GetHealth() > 0 then
		self:CreateObr()
		local hAbility = self:GetAbility()
		if IsValid(hAbility) then
			hAbility:StartCooldown(hAbility:GetCooldown(hAbility:GetLevel() - 1))
		end
	else
		self:SearchEnemy()
	end
end
--查找敌人
function modifier_puck_1:SearchEnemy()
	local hAbility = self:GetAbility()
	local hParent = self:GetParent()

	if IsValid(hParent)
	and IsValid(hAbility)
	and self:GetStackCount() > 0 then
		local tEnemies = FindUnitsInRadius(
		hParent:GetTeamNumber(),
		hParent:GetAbsOrigin(),
		nil,
		self.search_enemy_radius,
		hAbility:GetAbilityTargetTeam(),
		hAbility:GetAbilityTargetType(),
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)

		local fMaxMana = -1
		local hTarget = nil
		for k, hEnemy in pairs(tEnemies) do
			local fMana = hEnemy:GetMana()
			if fMana > fMaxMana then
				fMaxMana = fMana
				hTarget = hEnemy
			end
		end

		if IsValid(hTarget) then
			self:FireOrb(hTarget)
			return true
		end
	end
end
--发射球体
function modifier_puck_1:FireOrb(hTarget)
	local hOrb = self.tOrbs[#self.tOrbs]

	local hOrbThinker = CreateModifierThinker(hTarget, self:GetAbility(), "modifier_puck_1_orb_fire", { duration = 2 }, hOrb:GetAbsOrigin(), hTarget:GetTeamNumber(), false)
	hOrbThinker:EmitSound("Hero_Puck.Illusory_Orb")

	-- 消耗一个球体
	hOrb:AddNoDraw()
	hOrb.bShow = false
	table.remove(self.tOrbs, #self.tOrbs)
	self:SetStackCount(#self.tOrbs)
end

function modifier_puck_1:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}

end

-- 发射球体的运动
if modifier_puck_1_orb_fire == nil then
	modifier_puck_1_orb_fire = class({}, nil, BaseModifier)
end
function modifier_puck_1_orb_fire:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		self.hTarget = self:GetCaster()
		self.speed = self:GetAbilitySpecialValueFor("orb_speed")
		local iParticleID = ParticleManager:CreateParticle('particles/units/heroes/puck/puck_illusory_orb_1_tracking1_tracking.vpcf', PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 3, hParent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)

		self.vStartPosition = hParent:GetAbsOrigin()
		self.vTargetPosition = self.hTarget:GetAttachmentOrigin(self.hTarget:ScriptLookupAttachment("attach_hitloc"))
		local vDirection = self.vTargetPosition - self.vStartPosition
		self.vOffset = self.vStartPosition + 2 * vDirection:Length2D() * RotatePosition(Vector(0, 0, 0), QAngle(RandomFloat(-180, 0), RandomFloat(1, 0) * 360, 0), Vector(1, 0, 0))
		self:StartIntervalThink(0)
	end
end

function modifier_puck_1_orb_fire:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local fTime = self:GetElapsedTime()

		if IsValid(self.hTarget) and self.hTarget:IsAlive() then
			-- self.vTargetPosition = CalcClosestPointOnEntityOBB(self.hTarget, self.vStartPosition)
			self.vTargetPosition = self.hTarget:GetAbsOrigin()
			self.vTargetPosition.z = self.hTarget:GetAttachmentOrigin(self.hTarget:ScriptLookupAttachment("attach_hitloc")).z
		end

		local vDirection = self.vTargetPosition - self.vStartPosition

		local fProgress = Clamp(math.max((self.speed * fTime) / vDirection:Length2D(), fTime / self:GetDuration()), 0, 1)

		local vStart = hParent:GetAbsOrigin()
		local vEnd = Bessel(fProgress, self.vStartPosition, self.vOffset, self.vTargetPosition)

		-- DebugDrawLine(vStart, vEnd, 255, 255, 0, true, 1)
		hParent:SetAbsOrigin(vEnd)
		-- hParent:SetForwardVector((vEnd - vStart):Normalized())
		if fProgress >= 1 then
			self:Destroy()
		end
	end
end

function modifier_puck_1_orb_fire:OnDestroy()
	if IsServer() then
		local hAbility = self:GetAbility()
		local hParent = self:GetParent()

		if IsValid(self.hTarget) then
			if IsValid(hAbility) then
				hAbility:OnProjectileHit(self.hTarget, hParent:GetAbsOrigin())
			end
		end

		hParent:StopSound("Hero_Puck.Illusory_Orb")
		hParent:ForceKill(false)
		UTIL_Remove(hParent)
	end
end