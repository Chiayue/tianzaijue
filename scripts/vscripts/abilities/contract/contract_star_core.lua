LinkLuaModifier("modifier_contract_star_core", "abilities/contract/contract_star_core.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_contract_star_core_thinker", "abilities/contract/contract_star_core.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_contract_star_core_pull", "abilities/contract/contract_star_core.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if contract_star_core == nil then
	contract_star_core = class({})
end
function contract_star_core:GetIntrinsicModifierName()
	return "modifier_contract_star_core"
end
---------------------------------------------------------------------
--Modifiers
if modifier_contract_star_core == nil then
	modifier_contract_star_core = class({}, nil, eom_modifier)
end
function modifier_contract_star_core:IsHidden()
	return true
end
function modifier_contract_star_core:OnInBattle()
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_contract_star_core_thinker", nil)
	end
end
function modifier_contract_star_core:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE
	}
end
---------------------------------------------------------------------
--Modifiers
if modifier_contract_star_core_thinker == nil then
	modifier_contract_star_core_thinker = class({}, nil, eom_modifier)
end
function modifier_contract_star_core_thinker:IsHidden()
	return true
end
function modifier_contract_star_core_thinker:IsAura()
	return true
end
function modifier_contract_star_core_thinker:GetAuraRadius()
	return self.radius
end
function modifier_contract_star_core_thinker:GetModifierAura()
	return "modifier_contract_star_core_pull"
end
function modifier_contract_star_core_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end
function modifier_contract_star_core_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end
function modifier_contract_star_core_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_contract_star_core_thinker:GetAuraEntityReject(hEntity)
	if Commander:GetCommander(GetPlayerID(self:GetParent())) == hEntity then
		return true
	end
	return false
end
function modifier_contract_star_core_thinker:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		local hParent = self:GetParent()
		hParent:EmitSound("Hero_Enigma.Black_Hole")

		-- particle
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/enigma_blackhole.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)

		self:StartIntervalThink(1)
	end
end
function modifier_contract_star_core_thinker:OnRemoved()
	if IsServer() then
		StopSoundOn("Hero_Enigma.Black_Hole", self:GetParent())
		self:GetParent():EmitSound("Hero_Enigma.Black_Hole.Stop")
	end
end
function modifier_contract_star_core_thinker:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
		hParent:DealDamage(tTargets, self:GetAbility())
	end
end
function modifier_contract_star_core_thinker:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_contract_star_core_thinker:OnBattleEnd()
	self:Destroy()
end
---------------------------------------------------------------------
if modifier_contract_star_core_pull == nil then
	modifier_contract_star_core_pull = class({}, nil, ModifierHidden)
end
function modifier_contract_star_core_pull:OnCreated(params)
	local duration = self:GetAbilitySpecialValueFor("duration")
	self.animation_rate = 0.2
	self.pull_speed = self:GetAbilitySpecialValueFor("speed")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.tick_rate = 0.1
	self.pull_rotate_speed = 0.25
	if IsServer() then
		self:StartIntervalThink(0)
	end
end
function modifier_contract_star_core_pull:OnIntervalThink()
	if IsServer() then
		if self:GetAuraOwner() == nil then
			self:StartIntervalThink(-1)
			self:Destroy()
		end
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		-- hCaster:DealDamage(hParent, self:GetAbility())
		local dt = 0.03
		local vOrigin = self:GetCaster():GetAbsOrigin()
		local vLocation = hParent:GetAbsOrigin()
		-- 到达中心后不再移动
		if (vLocation - vOrigin):Length2D() <= self.pull_speed * dt then
			hParent:SetAbsOrigin(vOrigin)
		else
			local vDirection = (vOrigin - vLocation):Normalized()
			vDirection.z = 0
			local iDistance = self.pull_speed * dt
			local vPoint = vLocation + vDirection * iDistance

			local x = math.cos(self.pull_rotate_speed * dt) * (vPoint.x - vOrigin.x) - math.sin(self.pull_rotate_speed * dt) * (vPoint.y - vOrigin.y) + vOrigin.x
			local y = math.sin(self.pull_rotate_speed * dt) * (vPoint.x - vOrigin.x) + math.cos(self.pull_rotate_speed * dt) * (vPoint.y - vOrigin.y) + vOrigin.y

			hParent:SetAbsOrigin(Vector(x, y, vLocation.z))
		end
	end
end
function modifier_contract_star_core_pull:OnDestroy()
	if IsServer() then
		-- self:GetParent():RemoveHorizontalMotionController(self)
	end
end
function modifier_contract_star_core_pull:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local vOrigin = self:GetCaster():GetAbsOrigin()
		local vLocation = me:GetAbsOrigin()
		-- 到达中心后不再移动
		if (vLocation - vOrigin):Length2D() <= self.pull_speed * dt then
			me:SetAbsOrigin(vOrigin)
		else
			local vDirection = (vOrigin - vLocation):Normalized()
			vDirection.z = 0
			local iDistance = self.pull_speed * dt
			local vPoint = vLocation + vDirection * iDistance

			local x = math.cos(self.pull_rotate_speed * dt) * (vPoint.x - vOrigin.x) - math.sin(self.pull_rotate_speed * dt) * (vPoint.y - vOrigin.y) + vOrigin.x
			local y = math.sin(self.pull_rotate_speed * dt) * (vPoint.x - vOrigin.x) + math.cos(self.pull_rotate_speed * dt) * (vPoint.y - vOrigin.y) + vOrigin.y

			me:SetAbsOrigin(Vector(x, y, vLocation.z))
		end
	end
end
function modifier_contract_star_core_pull:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_contract_star_core_pull:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end