LinkLuaModifier("modifier_faceless_void_3", "abilities/tower/faceless_void/faceless_void_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_faceless_void_3_motion", "abilities/tower/faceless_void/faceless_void_3.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
--Abilities
if faceless_void_3 == nil then
	faceless_void_3 = class({ iSearchBehavior = AI_SEARCH_BEHAVIOR_MOST_AOE_TARGET }, nil, ability_base_ai)
end
function faceless_void_3:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function faceless_void_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local hModifier = self:GetIntrinsicModifier()
	if not IsValid(hModifier) then
		return
	end
	for i, tData in ipairs(self:GetIntrinsicModifier().tData) do
		hCaster:Heal(tData.flDamage, self)
	end

	local vDirection = (vPosition - hCaster:GetAbsOrigin()):Normalized()
	local flDistance = (vPosition - hCaster:GetAbsOrigin()):Length2D()
	local speed = self:GetSpecialValueFor("speed")

	hCaster:AddNewModifier(hCaster, self, "modifier_faceless_void_3_motion", { position = vPosition, duration = flDistance / speed })
	hCaster:StartGesture(ACT_DOTA_CAST_ABILITY_1_END)
	-- particle
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_time_walk_preimage.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControl(iParticleID, 0, hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControl(iParticleID, 1, vPosition)
	-- ParticleManager:SetParticleControlEnt(iParticleID, 2, hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, hCaster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlForward(iParticleID, 2, vDirection:Normalized())
	ParticleManager:ReleaseParticleIndex(iParticleID)
	-- sound
	hCaster:EmitSound("Hero_FacelessVoid.TimeWalk")
end
function faceless_void_3:GetIntrinsicModifierName()
	return "modifier_faceless_void_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_faceless_void_3 == nil then
	modifier_faceless_void_3 = class({}, nil, eom_modifier)
end
function modifier_faceless_void_3:IsHidden()
	return true
end
function modifier_faceless_void_3:OnCreated(params)
	self.restore_time = self:GetAbilitySpecialValueFor("restore_time")
	if IsServer() then
		self.tData = {}
		-- self.flRadius = self:GetAbility():GetCastRange(self:GetParent():GetAbsOrigin(), nil)
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_faceless_void_3:OnRefresh(params)
	self.restore_time = self:GetAbilitySpecialValueFor("restore_time")
end
function modifier_faceless_void_3:OnIntervalThink()
	local flGameTime = GameRules:GetGameTime()
	for i = #self.tData, 1, -1 do
		if flGameTime > self.tData[i].flDieTime then
			table.remove(self.tData, i)
		end
	end
end
function modifier_faceless_void_3:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() }
	}
end
function modifier_faceless_void_3:OnTakeDamage(params)
	if params.unit == self:GetParent() then
		table.insert(self.tData, {
			flDieTime = GameRules:GetGameTime() + self.restore_time,
			flDamage = params.damage
		})
	end
end
---------------------------------------------------------------------
if modifier_faceless_void_3_motion == nil then
	modifier_faceless_void_3_motion = class({}, nil, HorizontalModifier)
end
function modifier_faceless_void_3_motion:GetStatusEffectName()
	return "particles/status_fx/status_effect_faceless_timewalk.vpcf"
end
function modifier_faceless_void_3_motion:StatusEffectPriority()
	return 10
end
function modifier_faceless_void_3_motion:GetEffectName()
	return "particles/units/heroes/hero_faceless_void/faceless_void_time_walk.vpcf"
end
function modifier_faceless_void_3_motion:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_faceless_void_3_motion:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self.vEndPosition = StringToVector(params.position)
		if not self.vEndPosition then
			self:Destroy()
			return
		end

		if self:ApplyHorizontalMotionController() then
			self.vStartPosition = self:GetParent():GetAbsOrigin()
		else
			self:Destroy()
		end
	end
end
function modifier_faceless_void_3_motion:OnDestroy(params)
	if IsServer() then
		local hParent = self:GetParent()
		self:GetParent():RemoveHorizontalMotionController(self)

		-- 技能1
		local hAbility = hParent:FindAbilityByName("faceless_void_1")
		if IsValid(hAbility) and hAbility:GetLevel() > 0 then
			local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
			for _, hUnit in pairs(tTargets) do
				hAbility:TimeLock(hUnit)
			end
		end
	end
end
function modifier_faceless_void_3_motion:UpdateHorizontalMotion(hParent, dt)
	if IsServer() then
		local fPercent = Clamp(self:GetDuration() == 0 and 0 or self:GetElapsedTime() / self:GetDuration(), 0, 1)
		local vLocation = VectorLerp(fPercent, self.vStartPosition, self.vEndPosition)
		if GridNav:CanFindPath(hParent:GetAbsOrigin(), vLocation) then
			hParent:SetAbsOrigin(vLocation)
		else
			self:Destroy()
		end
	end
end
function modifier_faceless_void_3_motion:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_faceless_void_3_motion:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
end