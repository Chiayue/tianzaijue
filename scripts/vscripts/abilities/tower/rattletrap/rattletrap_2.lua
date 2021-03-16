LinkLuaModifier("modifier_rattletrap_2", "abilities/tower/rattletrap/rattletrap_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rattletrap_2_motion", "abilities/tower/rattletrap/rattletrap_2.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
--Abilities
if rattletrap_2 == nil then
	rattletrap_2 = class({})
end
function rattletrap_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local iSpeed = self:GetSpecialValueFor("speed")
	local flDistance = CalculateDistance(hCaster, hTarget)
	hTarget:AddBuff(hCaster, BUFF_TYPE.STUN, self:GetSpecialValueFor("stun_duration"))
	hCaster:AddNewModifier(hCaster, self, "modifier_rattletrap_2_motion", { iEntIndex = hTarget:entindex(), duration = flDistance / iSpeed })
	-- 勾爪特效
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_hookshot.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(iSpeed * 2, 0, 0))
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(flDistance / iSpeed, 0, 0))
	ParticleManager:ReleaseParticleIndex(iParticleID)
end
function rattletrap_2:GetIntrinsicModifierName()
	return "modifier_rattletrap_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_rattletrap_2 == nil then
	modifier_rattletrap_2 = class({}, nil, ModifierHidden)
end
function modifier_rattletrap_2:OnCreated(params)
	self.distance = self:GetAbility():GetCastRange(self:GetParent():GetAbsOrigin(), nil)
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end
function modifier_rattletrap_2:OnIntervalThink()
	local hParent = self:GetParent()
	if hParent:IsAbilityReady(self:GetAbility()) then
		local iTeam = PlayerData:GetPlayerTeamID(GetPlayerID(hParent))
		local hDoor = Entities:FindByName(nil, iTeam .. '_Enemy_Path_A_2')
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hDoor:GetAbsOrigin(), 1000, self:GetAbility(), FIND_CLOSEST)
		if IsValid(tTargets[1]) then
			hParent:PassiveCast(self:GetAbility(), DOTA_UNIT_ORDER_CAST_TARGET, { hTarget = tTargets[1] })
		else
			local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.distance, self:GetAbility(), FIND_FARTHEST)
			if IsValid(tTargets[1]) then
				hParent:PassiveCast(self:GetAbility(), DOTA_UNIT_ORDER_CAST_TARGET, { hTarget = tTargets[1] })
			end
		end
	end
end
---------------------------------------------------------------------
if modifier_rattletrap_2_motion == nil then
	modifier_rattletrap_2_motion = class({}, nil, HorizontalModifier)
end
function modifier_rattletrap_2_motion:OnCreated(params)
	self.iSpeed = self:GetAbilitySpecialValueFor("speed")
	self.iWidth = self:GetAbilitySpecialValueFor("width")
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	if IsServer() then
		self.tTargets = {}	-- 记录被撞的单位
		if self:ApplyHorizontalMotionController() then
			local hParent = self:GetParent()
			self.hTarget = EntIndexToHScript(params.iEntIndex)
			local vDirection = CalculateDirection(self.hTarget, hParent)

			local flDistance = CalcDistanceBetweenEntityOBB(hParent, self.hTarget)
			self.vVelocity = vDirection:Normalized() * self.iSpeed

			self.vStartPosition = hParent:GetAbsOrigin()
			self.hTarget:EmitSound("Hero_Rattletrap.Hookshot.Retract")
			hParent:StartGesture(ACT_DOTA_RATTLETRAP_HOOKSHOT_LOOP)
			-- self:StartIntervalThink(0.1)
		else
			self:Destroy()
		end
	end
end
function modifier_rattletrap_2_motion:OnDestroy()
	local hParent = self:GetParent()
	if IsServer() then
		hParent:RemoveHorizontalMotionController(self)

		hParent:RemoveGesture(ACT_DOTA_RATTLETRAP_HOOKSHOT_LOOP)

		self.hTarget:StopSound("Hero_Rattletrap.Hookshot.Retract")
		self.hTarget:EmitSound("Hero_Rattletrap.Hookshot.Damage")
	end
end
function modifier_rattletrap_2_motion:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		if me ~= nil then
			local vStart = me:GetAbsOrigin()
			me:SetAbsOrigin(GetGroundPosition(me:GetAbsOrigin() + self.vVelocity * dt, me))
			local vEnd = me:GetAbsOrigin()
			local tTargets = FindUnitsInLineWithAbility(me, vStart, vEnd, self.iWidth, self:GetAbility())
			for _, hUnit in pairs(tTargets) do
				if TableFindKey(self.tTargets, hUnit) == nil then
					table.insert(self.tTargets, hUnit)
					hUnit:AddBuff(me, BUFF_TYPE.STUN, self.stun_duration)
					me:DealDamage(hUnit, self:GetAbility(), 0)
				end
			end
		end
	end
end
function modifier_rattletrap_2_motion:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_rattletrap_2_motion:CheckState()
	return {
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
end
-- function modifier_rattletrap_2_motion:OnIntervalThink()
-- 	self:GetParent():KnockBack(self:GetParent():GetAbsOrigin() + RandomVector(100), self:GetParent(), 100, 0, 0.15, false)
-- end