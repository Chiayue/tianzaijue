LinkLuaModifier("modifier_jakiro_7", "abilities/boss/jakiro_7.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jakiro_7_damage", "abilities/boss/jakiro_7.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jakiro_7_thinker", "abilities/boss/jakiro_7.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_jakiro_7_particle_ice", "abilities/boss/jakiro_7.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jakiro_7_particle_fire", "abilities/boss/jakiro_7.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if jakiro_7 == nil then
	jakiro_7 = class({})
end
function jakiro_7:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	hCaster:AddActivityModifier("jakiro_roar")
	hCaster:AddBuff(hCaster, BUFF_TYPE.TENACITY, self:GetCastPoint() + self:GetChannelTime())

	-- 蛋放激光
	if hCaster.GetActiveEgg then
		local tEgg = hCaster:GetActiveEgg()
		for _, hEgg in pairs(tEgg) do
			ExecuteOrder(hEgg, DOTA_UNIT_ORDER_CAST_POSITION, nil, hEgg:FindAbilityByName("jakiro_7"), hCaster:GetAbsOrigin())
		end
	end
	return true
end
function jakiro_7:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:RemoveActivityModifier("jakiro_roar")
	local distance = self:GetSpecialValueFor("distance")
	self.tParticleID = {}
	-- 主身施放
	if hCaster.GetActiveEgg then
		-- 冰激光
		local hThinkerIce = CreateUnitByName("npc_dota_dummy", hCaster:GetAbsOrigin(), false, hCaster, hCaster, hCaster:GetTeamNumber())
		hThinkerIce:AddNewModifier(hCaster, self, "modifier_jakiro_7_thinker", { duration = self:GetChannelTime(), iIndex = 1 })
		hThinkerIce:AddNewModifier(hCaster, self, "modifier_jakiro_7_particle_ice", { duration = self:GetChannelTime() })
		-- 火激光
		local hThinkerFire = CreateUnitByName("npc_dota_dummy", hCaster:GetAbsOrigin(), false, hCaster, hCaster, hCaster:GetTeamNumber())
		hThinkerFire:AddNewModifier(hCaster, self, "modifier_jakiro_7_thinker", { duration = self:GetChannelTime(), iIndex = 2 })
		hThinkerFire:AddNewModifier(hCaster, self, "modifier_jakiro_7_particle_fire", { duration = self:GetChannelTime() })
	else	-- 蛋施放
		local vDir = hCaster:GetForwardVector()
		local vStart = hCaster:GetAttachmentOrigin(hCaster:ScriptLookupAttachment("attach_hitloc"))
		local vEnd = vStart + vDir * distance
		if hCaster:HasModifier("modifier_jakiro_2_ice") then	-- 冰蛋喷冰激光
			hCaster:AddNewModifier(hCaster, self, "modifier_jakiro_7_particle_ice", { duration = self:GetChannelTime() })
			local iParticleID = ParticleManager:CreateParticle("particles/units/boss/jakiro/jakiro_7_ice.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
			ParticleManager:SetParticleControl(iParticleID, 1, vEnd)
			ParticleManager:SetParticleControlEnt(iParticleID, 9, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
			ParticleManager:SetParticleControl(iParticleID, 4, Vector(distance, 0, 0))
			table.insert(self.tParticleID, iParticleID)
		else	-- 火蛋喷火激光
			hCaster:AddNewModifier(hCaster, self, "modifier_jakiro_7_particle_fire", { duration = self:GetChannelTime() })
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_sunray.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
			ParticleManager:SetParticleControl(iParticleID, 1, vEnd)
			ParticleManager:SetParticleControlEnt(iParticleID, 9, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
			ParticleManager:SetParticleControl(iParticleID, 4, Vector(distance, 0, 0))
			table.insert(self.tParticleID, iParticleID)
		end
	end
	-- sound
	hCaster:EmitSound("Hero_Phoenix.SunRay.Cast")
	hCaster:EmitSound("Hero_Phoenix.SunRay.Loop")
end
function jakiro_7:OnChannelThink(flInterval)
	local hCaster = self:GetCaster()
	local flDamage = self:GetAbilityDamage() * flInterval
	local distance = self:GetSpecialValueFor("distance")
	local width = self:GetSpecialValueFor("width")
	if hCaster.GetActiveEgg then
		-- for i = 1, 2 do
		-- 	local yaw = hCaster:GetAttachmentAngles(hCaster:ScriptLookupAttachment( "attach_attack"..i )).y
		-- 	local vDir = Rotation2D(Vector(1,0,0), math.rad(yaw))
		-- 	local vStart = hCaster:GetAttachmentOrigin(hCaster:ScriptLookupAttachment( "attach_attack"..i ))
		-- 	local vEnd = vStart + vDir * distance
		-- 	local tTargets = FindUnitsInLine(hCaster:GetTeamNumber(), vStart, vEnd, nil, width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE)
		-- 	hCaster:DealDamage(tTargets, self, flDamage)
		-- 	ParticleManager:SetParticleControl(self.tParticleID[i], 1, vEnd)
		-- end
	else
		-- 蛋造成伤害
		for i = 1, 2 do
			local vDir = hCaster:GetForwardVector()
			local vStart = hCaster:GetAttachmentOrigin(hCaster:ScriptLookupAttachment("attach_hitloc"))
			local vEnd = vStart + vDir * distance
			local tTargets = FindUnitsInLine(hCaster:GetTeamNumber(), vStart, vEnd, nil, width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE)
			local tUnit = FindUnitsInRadius(hCaster:GetTeamNumber(), vStart, nil, width * 2, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			tTargets = concat(tTargets, tUnit)
			tTargets = removeRepeat(tTargets)
			for _, hUnit in pairs(tTargets) do
				if not hUnit:HasModifier("modifier_jakiro_7_damage") then
					hUnit:AddNewModifier(hCaster, self, "modifier_jakiro_7_damage", {duration = 1})
				end
			end
			-- hCaster:DealDamage(tTargets, self, flDamage)
			-- ParticleManager:SetParticleControl(self.tParticleID[i], 1, vEnd)
		end
	end
end
function jakiro_7:OnChannelFinish(bInterrupted)
	local hCaster = self:GetCaster()
	for i = 1, #self.tParticleID do
		ParticleManager:DestroyParticle(self.tParticleID[i], false)
		ParticleManager:ReleaseParticleIndex(self.tParticleID[i])
	end
	hCaster:StopSound("Hero_Phoenix.SunRay.Loop")
end
function jakiro_7:GetIntrinsicModifierName()
	return "modifier_jakiro_7"
end
---------------------------------------------------------------------
--Modifiers
if modifier_jakiro_7 == nil then
	modifier_jakiro_7 = class({}, nil, ModifierHidden)
end
function modifier_jakiro_7:OnCreated(params)
	self.trigger_pct = self:GetAbilitySpecialValueFor("trigger_pct")
	self.distance = self:GetAbilitySpecialValueFor("distance")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_jakiro_7:OnIntervalThink()
	local hParent = self:GetParent()
	if hParent:IsAbilityReady(self:GetAbility()) and hParent:GetHealthPercent() <= self.trigger_pct then
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.distance, self:GetAbility())
		if IsValid(tTargets[1]) then
			-- hParent:Purge(false, true, false, true, true)
			ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_POSITION, nil, self:GetAbility(), tTargets[1]:GetAbsOrigin())
		end
	end
end
---------------------------------------------------------------------
if modifier_jakiro_7_thinker == nil then
	modifier_jakiro_7_thinker = class({}, nil, BothModifier)
end
function modifier_jakiro_7_thinker:OnCreated(params)
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.width = self:GetAbilitySpecialValueFor("width")
	if IsServer() then
		self.iIndex = params.iIndex
		if not self:ApplyHorizontalMotionController() or not self:ApplyVerticalMotionController() then
			self:Destroy()
			return
		end
	end
end
function modifier_jakiro_7_thinker:OnDestroy()
	if IsServer() then
		if IsValid(self:GetParent()) then
			self:GetParent():RemoveSelf()
			self:GetParent():RemoveHorizontalMotionController(self)
			self:GetParent():RemoveVerticalMotionController(self)
		end
	end
end
function modifier_jakiro_7_thinker:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local hCaster = self:GetCaster()
		if not hCaster:IsChanneling() then
			self:Destroy()
			return
		end
		local yaw = hCaster:GetAttachmentAngles(hCaster:ScriptLookupAttachment("attach_attack" .. self.iIndex)).y
		local vDir = Rotation2D(Vector(1, 0, 0), math.rad(yaw))
		local vStart = hCaster:GetAttachmentOrigin(hCaster:ScriptLookupAttachment("attach_attack" .. self.iIndex))
		local vEnd = vStart + vDir * self.distance
		me:SetAbsOrigin(vEnd)
		-- 造成伤害
		-- local flDamage = self:GetAbility():GetAbilityDamage() * dt
		local tTargets = FindUnitsInLine(hCaster:GetTeamNumber(), vStart, vEnd, nil, self.width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE)
		for _, hUnit in pairs(tTargets) do
			if not hUnit:HasModifier("modifier_jakiro_7_damage") then
				hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_jakiro_7_damage", {duration = 1})
			end
		end
		-- hCaster:DealDamage(tTargets, self:GetAbility(), flDamage)
	end
end
function modifier_jakiro_7_thinker:UpdateVerticalMotion(me, dt)
	local vPosition = me:GetAbsOrigin()
	vPosition.z = GetGroundHeight(vPosition, me) + 300
	me:SetAbsOrigin(vPosition)
end
function modifier_jakiro_7_thinker:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_jakiro_7_thinker:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_jakiro_7_thinker:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true
	}
end
---------------------------------------------------------------------
if modifier_jakiro_7_particle_ice == nil then
	modifier_jakiro_7_particle_ice = class({}, nil, ParticleModifier)
end
function modifier_jakiro_7_particle_ice:OnCreated(params)
	if IsServer() then
	else
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/boss/jakiro/jakiro_7_ice.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 9, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetAbsOrigin(), false)
		ParticleManager:SetParticleControl(iParticleID, 4, Vector(self:GetAbilitySpecialValueFor("distance"), 0, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
---------------------------------------------------------------------
if modifier_jakiro_7_particle_fire == nil then
	modifier_jakiro_7_particle_fire = class({}, nil, ParticleModifier)
end
function modifier_jakiro_7_particle_fire:OnCreated(params)
	if IsServer() then
	else
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_sunray.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack2", hCaster:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 9, hCaster, PATTACH_POINT_FOLLOW, "attach_attack2", hCaster:GetAbsOrigin(), false)
		ParticleManager:SetParticleControl(iParticleID, 4, Vector(self:GetAbilitySpecialValueFor("distance"), 0, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
---------------------------------------------------------------------
if modifier_jakiro_7_damage == nil then
	modifier_jakiro_7_damage = class({}, nil, ModifierHidden)
end
function modifier_jakiro_7_damage:OnCreated(params)
	self.interval = self:GetAbilitySpecialValueFor("interval")
	if IsServer() then
		self:StartIntervalThink(self.interval)
	end
end
function modifier_jakiro_7_damage:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if IsServer() then
		if IsValid(hCaster) and IsValid(hAbility) then
			hCaster:DealDamage(hParent, hAbility, hAbility:GetAbilityDamage())
		end
	end
end