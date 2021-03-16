LinkLuaModifier("modifier_shredderB_3", "abilities/tower/shredderB/shredderB_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shredderB_3_motion", "abilities/tower/shredderB/shredderB_3.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_shredderB_3_thinker", "abilities/tower/shredderB/shredderB_3.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
if shredderB_3 == nil then
	shredderB_3 = class({})
end
function shredderB_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local iSpeed = self:GetSpecialValueFor("speed")

	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/shredder/timber_controlled_burn/timber_controlled_burn_timberchain.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(iSpeed, 0, 0))
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(3, 0, 0))
	ParticleManager:SetParticleControlEnt(iParticleID, 4, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false)

	local info = {
		EffectName = "",
		Ability = self,
		iMoveSpeed = iSpeed,
		Source = hSource,
		Target = hTarget,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		vSourceLoc = hCaster:GetAbsOrigin(),
		ExtraData = {
			iParticleID = iParticleID
		}
	}
	ProjectileManager:CreateTrackingProjectile(info)
	-- sound
	hCaster:EmitSound("Hero_Shredder.TimberChain.Cast")
end
function shredderB_3:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	local hCaster = self:GetCaster()
	if hTarget == nil or not IsValid(hTarget) then
		ParticleManager:DestroyParticle(ExtraData.iParticleID, false)
		return
	end
	hTarget:EmitSound("Hero_Shredder.TimberChain.Impact")
	if hTarget:IsBoss() or
	hTarget:IsAncient() or
	hTarget:IsGoldWave() or
	hTarget:GetUnitLabel() == "elite"
	then
		hCaster:AddNewModifier(hTarget, self, "modifier_shredderB_3_motion", { iParticleID = ExtraData.iParticleID })
	else
		hTarget:AddNewModifier(hCaster, self, "modifier_shredderB_3_motion", { iParticleID = ExtraData.iParticleID })
	end
end
function shredderB_3:GetIntrinsicModifierName()
	return "modifier_shredderB_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_shredderB_3 == nil then
	modifier_shredderB_3 = class({}, nil, ModifierHidden)
end
function modifier_shredderB_3:OnCreated(params)
	self.distance = self:GetAbility():GetCastRange(self:GetParent():GetAbsOrigin(), nil)
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end
function modifier_shredderB_3:OnIntervalThink()
	local hParent = self:GetParent()
	if hParent:IsAbilityReady(self:GetAbility()) then
		local iTeam = PlayerData:GetPlayerTeamID(GetPlayerID(hParent))
		local hDoor = Entities:FindByName(nil, iTeam .. '_Enemy_Path_A_2')
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hDoor:GetAbsOrigin(), 1000, self:GetAbility(), FIND_CLOSEST)
		if IsValid(tTargets[1]) then
			ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_TARGET, tTargets[1], self:GetAbility())
			-- hParent:PassiveCast(self:GetAbility(), DOTA_UNIT_ORDER_CAST_TARGET, { hTarget = tTargets[1] })
		else
			local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.distance, self:GetAbility(), FIND_FARTHEST)
			if IsValid(tTargets[1]) then
				ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_TARGET, tTargets[1], self:GetAbility())
				-- hParent:PassiveCast(self:GetAbility(), DOTA_UNIT_ORDER_CAST_TARGET, { hTarget = tTargets[1] })
			end
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_shredderB_3_motion == nil then
	modifier_shredderB_3_motion = class({}, nil, HorizontalModifier)
end
function modifier_shredderB_3_motion:OnCreated(params)
	self.iSpeed = self:GetAbilitySpecialValueFor("speed")
	self.iWidth = self:GetAbilitySpecialValueFor("width")
	if IsServer() then
		self.tTargets = {}	-- 记录被撞的单位
		self.iParticleID = params.iParticleID
		-- 燃烧路径起始点
		self.vStart = self:GetParent():GetAbsOrigin()
		if self:ApplyHorizontalMotionController() then
		else
			self:Destroy()
		end
	else
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/shredder/timber_controlled_burn/timber_controlled_burn_timberchain_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 3, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_shredderB_3_motion:OnDestroy()
	local hParent = self:GetParent()
	if IsServer() then
		hParent:RemoveHorizontalMotionController(self)
		ParticleManager:DestroyParticle(self.iParticleID, false)
		-- 燃烧路径
		CreateModifierThinker(hParent, self:GetAbility(), "modifier_shredderB_3_thinker", { duration = self:GetAbility():GetDuration() }, self.vStart, self:GetCaster():GetTeamNumber(), false)
	end
end
function modifier_shredderB_3_motion:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local hCaster = self:GetAbility():GetCaster()
		local hParent = self:GetParent()
		local hTarget = self:GetCaster()
		local vDirection = CalculateDirection(hTarget, hParent)
		local vVelocity = vDirection * self.iSpeed
		local vStart = me:GetAbsOrigin()
		me:SetAbsOrigin(GetGroundPosition(me:GetAbsOrigin() + vVelocity * dt, me))
		local vEnd = me:GetAbsOrigin()

		local tTargets = FindUnitsInLineWithAbility(hCaster, vStart, vEnd, self.iWidth, self:GetAbility())
		for _, hUnit in pairs(tTargets) do
			if TableFindKey(self.tTargets, hUnit) == nil then
				table.insert(self.tTargets, hUnit)
				hCaster:DealDamage(hUnit, self:GetAbility(), 0)
				hCaster:EmitSound("Hero_Shredder.TimberChain.Damage")
			end
		end
		-- 结束
		if CalculateDistance(hParent, hTarget) <= self.iWidth then
			self:Destroy()
		end
	end
end
function modifier_shredderB_3_motion:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_shredderB_3_motion:CheckState()
	return {
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
end
---------------------------------------------------------------------
if modifier_shredderB_3_thinker == nil then
	modifier_shredderB_3_thinker = class({}, nil, ParticleModifierThinker)
end
function modifier_shredderB_3_thinker:OnCreated(params)
	self.iWidth = self:GetAbilitySpecialValueFor("width")
	self.iCount = self:GetAbilitySpecialValueFor("ignite_count")
	self.ignite_duration = self:GetAbilitySpecialValueFor("ignite_duration")
	if IsServer() then
		self.vStart = self:GetParent():GetAbsOrigin()
		self.vEnd = self:GetCaster():GetAbsOrigin()
		self:StartIntervalThink(0.2)
	end
end
function modifier_shredderB_3_thinker:OnIntervalThink()
	if IsValid(self:GetAbility()) then
		local hCaster = self:GetAbility():GetCaster()
		local tTargets = FindUnitsInLineWithAbility(hCaster, self.vStart, self.vEnd, self.iWidth, self:GetAbility())
		for _, hUnit in pairs(tTargets) do
			hUnit:AddBuff(hCaster, BUFF_TYPE.IGNITE, self.ignite_duration, true, { iCount = self.iCount / 5 })
		end
	end
end