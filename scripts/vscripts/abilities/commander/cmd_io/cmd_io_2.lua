LinkLuaModifier("modifier_cmd_io_2", "abilities/commander/cmd_io/cmd_io_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_io_2_spirit", "abilities/commander/cmd_io/cmd_io_2.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
--Abilities
if cmd_io_2 == nil then
	cmd_io_2 = class({})
end
function cmd_io_2:GetIntrinsicModifierName()
	return "modifier_cmd_io_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_io_2 == nil then
	modifier_cmd_io_2 = class({}, nil, eom_modifier)
end
function modifier_cmd_io_2:IsHidden()
	return true
end
function modifier_cmd_io_2:OnCreated(params)
	self.count = self:GetAbilitySpecialValueFor("count")
	self.period = self:GetAbilitySpecialValueFor("period")
	self.explode_radius = self:GetAbilitySpecialValueFor("explode_radius")
	self.pct = self:GetAbilitySpecialValueFor("pct")
	self.bonus_pct = self:GetAbilitySpecialValueFor("bonus_pct")
	self.bonus_distance = self:GetAbilitySpecialValueFor("bonus_distance")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
		-- self:OnIntervalThink()
	end
end
function modifier_cmd_io_2:OnRefresh(params)
	self.count = self:GetAbilitySpecialValueFor("count")
	self.period = self:GetAbilitySpecialValueFor("period")
	self.explode_radius = self:GetAbilitySpecialValueFor("explode_radius")
	self.pct = self:GetAbilitySpecialValueFor("pct")
	self.bonus_pct = self:GetAbilitySpecialValueFor("bonus_pct")
	self.bonus_distance = self:GetAbilitySpecialValueFor("bonus_distance")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
	end
end
function modifier_cmd_io_2:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_cmd_io_2:OnInBattle()
	self:StartIntervalThink(0.1)
	-- if not Spawner:IsBossRound() then
	-- self:OnIntervalThink()
	-- end
end
function modifier_cmd_io_2:OnBattleEnd()
	self:StartIntervalThink(-1)
	if self:GetParent() ~= self:GetCaster() then
		self:Destroy()
	end
end
function modifier_cmd_io_2:OnIntervalThink()
	local hParent = self:GetParent()
	local vStart = hParent:GetAbsOrigin()
	local vPosition = vStart + RandomVector(100)
	for i = 1, self.count do
		local hUnit = CreateUnitByName("npc_dota_dummy", RotatePosition(vStart, QAngle(0, (360 / self.count) * i, 0), vPosition), false, hParent, hParent, hParent:GetTeamNumber())
		hUnit:AddNewModifier(hParent, self:GetAbility(), "modifier_cmd_io_2_spirit", { duration = self.duration })
	end
	hParent:EmitSound("Hero_Wisp.Spirits.Cast")
	self:StartIntervalThink(self.period)
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_io_2_spirit == nil then
	modifier_cmd_io_2_spirit = class({}, nil, HorizontalModifier)
end
function modifier_cmd_io_2_spirit:OnCreated(params)
	self.explode_radius = self:GetAbilitySpecialValueFor("explode_radius")
	self.pct = self:GetAbilitySpecialValueFor("pct")
	self.bonus_pct = self:GetAbilitySpecialValueFor("bonus_pct")
	self.bonus_distance = self:GetAbilitySpecialValueFor("bonus_distance")
	if IsServer() then
		self.flAngle = VectorToAngles((self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized())[2]	-- 记录角度
		self.flSpeed = 200	-- 角速度
		self.flRadius = 100	-- 环绕半径
		self.flSpeedExpansion = 300	-- 扩张速度
		if not self:ApplyHorizontalMotionController() then
			self:Destroy()
		end
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian_.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_cmd_io_2_spirit:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_cmd_io_2_spirit:OnDestroy(params)
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()

		hParent:RemoveHorizontalMotionController(self)

		if IsValid(hCaster) and IsValid(hAbility) then
			local flDistance = CalculateDistance(hCaster, hParent)
			local tTargets = FindUnitsInRadiusWithAbility(hCaster, hParent:GetAbsOrigin(), self.explode_radius, hAbility)
			local flDamage = (self.pct + self.bonus_pct * (flDistance / self.bonus_distance)) * (hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) + hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack)) * 0.01
			hCaster:DealDamage(tTargets, hAbility, flDamage)
			hParent:EmitSound("Hero_Wisp.Spirits.Target")
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian_explosion.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end

		if IsValid(hParent) then
			hParent:RemoveSelf()
		end
	end
end
function modifier_cmd_io_2_spirit:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local hCaster = self:GetCaster()
		me:SetAbsOrigin(hCaster:GetAbsOrigin() + AnglesToVector(QAngle(0, self.flAngle, 0)) * self.flRadius)
		self.flAngle = self.flAngle + self.flSpeed * dt
		self.flRadius = self.flRadius + self.flSpeedExpansion * dt
		self:FindEnemy()
	end
end
function modifier_cmd_io_2_spirit:FindEnemy()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	EachUnits(GetPlayerID(hCaster), function(hUnit)
		local flDistance = CalculateDistance(hUnit, hParent)
		if flDistance < 200 then
			self:Destroy()
			return true
		end
	end, UnitType.AllEnemies)
end
function modifier_cmd_io_2_spirit:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_cmd_io_2_spirit:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true
	}
end