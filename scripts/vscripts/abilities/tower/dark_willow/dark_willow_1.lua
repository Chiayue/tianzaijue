LinkLuaModifier("modifier_dark_willow_1_buff", "abilities/tower/dark_willow/dark_willow_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dark_willow_1_debuff", "abilities/tower/dark_willow/dark_willow_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dark_willow_1_idle", "abilities/tower/dark_willow/dark_willow_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dark_willow_1_motion", "abilities/tower/dark_willow/dark_willow_1.lua", LUA_MODIFIER_MOTION_BOTH)
--Abilities
if dark_willow_1 == nil then
	-- dark_willow_1 = class({iSearchBehavior = AI_SEARCH_BEHAVIOR_MOST_AOE_TARGET}, nil, ability_base_ai)
	dark_willow_1 = class({}, nil, ability_base_ai)
end
function dark_willow_1:Spawn()
	self.flDamageRecord = 0
end
function dark_willow_1:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function dark_willow_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local curse_count = self:GetSpecialValueFor("curse_count")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, self:GetSpecialValueFor("radius"), self)
	for _, hUnit in pairs(tTargets) do
		if curse_count > 0 then
			curse_count = curse_count - 1
			hUnit:AddNewModifier(hCaster, self, "modifier_dark_willow_1_debuff", { duration = self:GetSpecialValueFor("curse_duration") })
		end
	end
	hCaster:AddNewModifier(hCaster, self, "modifier_dark_willow_1_buff", { duration = self:GetSpecialValueFor("curse_duration") })
	hCaster:EmitSound("Hero_DarkWillow.Ley.Cast")
end
function dark_willow_1:OnProjectileHit(vLocation)
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vLocation, radius, self)
	for _, hTarget in pairs(tTargets) do
		ApplyDamage({
			victim = hTarget,
			attacker = hCaster,
			ability = self,
			damage = self.flDamageRecord,
			damage_type = self:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_DARK_WILLOW + DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT,
		})
	end
	self.flDamageRecord = 0
	-- 特效
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vLocation)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, 2, radius * 2))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	-- 声音
	EmitSoundOnLocationWithCaster(vLocation, "Hero_DarkWillow.Fear.Target", hCaster)
end
---------------------------------------------------------------------
--Modifiers
if modifier_dark_willow_1_buff == nil then
	modifier_dark_willow_1_buff = class({}, nil, eom_modifier)
end
function modifier_dark_willow_1_buff:OnCreated(params)
	self.energy_translate = self:GetAbilitySpecialValueFor("energy_translate")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self:StartIntervalThink(1)
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/dark_willow/dark_willow_ti8_immortal_head/dw_ti8_immortal_cursed_crown_start.vpcf", PATTACH_OVERHEAD_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_dark_willow_1_buff:OnIntervalThink()
	self:GetParent():EmitSound("Hero_DarkWillow.Ley.Count")
end
function modifier_dark_willow_1_buff:OnDestroy()
	if IsServer() then
		if GSManager:getStateType() ~= GS_Battle then
			return
		end
		local hParent = self:GetParent()
		local flCastPoint = 0.8
		-- 施法抬手
		local OnAbilityPhaseStart = function(hAbility)
			local hCaster = hAbility:GetCaster()
			local vPosition = hAbility:GetCursorPosition()
			-- 创建精灵单位
			self.hSpirit = CreateUnitByName("npc_dota_dark_willow_creature", hCaster:GetAbsOrigin() + Vector(0, 0, 200), false, hCaster, hCaster, hCaster:GetTeamNumber())
			self.hSpirit:SetForwardVector((vPosition - hCaster:GetAbsOrigin():Normalized()))
			self.hSpirit:AddNewModifier(hCaster, hAbility, "modifier_dark_willow_1_idle", nil)
			-- 创建特效
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_marker.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, 2, self.radius * 2))
			-- 音效
			hCaster:EmitSound("Hero_DarkWillow.Fear.Cast")
			return true
		end
		-- 施法打断
		local OnAbilityPhaseInterrupted = function(hAbility)
			local hCaster = hAbility:GetCaster()
			self.hSpirit:RemoveModifierByName("modifier_dark_willow_1_idle")
			self.hSpirit:RemoveSelf()
			hCaster:StopSound("Hero_DarkWillow.Fear.Cast")
		end
		-- 施法
		local OnSpellStart = function(hAbility)
			local hCaster = hAbility:GetCaster()
			local vPosition = hAbility:GetCursorPosition()
			self.hSpirit:AddNewModifier(hCaster, hAbility, "modifier_dark_willow_1_motion", { vPosition = vPosition })
		end
		local vPosition = GetAOEMostTargetsPosition(hParent:GetAbsOrigin(), self:GetAbility():GetCastRange(vec3_invalid, nil), hParent:GetTeamNumber(), self.radius, self:GetAbility():GetAbilityTargetTeam(), self:GetAbility():GetAbilityTargetType(), self:GetAbility():GetAbilityTargetFlags(), FIND_ANY_ORDER)
		-- local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self:GetAbility():GetCastRange(vec3_invalid, nil), self:GetAbility())
		-- if IsValid(tTargets[1]) then
		-- 	vPosition = tTargets[1]:GetAbsOrigin()
		-- end
		local tExtraData = {
			vPosition = vPosition,
			flCastPoint = flCastPoint,
			iCastAnimation = ACT_DOTA_CAST_ABILITY_5,
			bIgnoreBackswing = false,
			OnAbilityPhaseStart = OnAbilityPhaseStart,
			OnAbilityPhaseInterrupted = OnAbilityPhaseInterrupted,
			bUseCooldown = false
		}
		hParent:AddBuff(hParent, BUFF_TYPE.TENACITY, flCastPoint)
		hParent:PassiveCast(self:GetAbility(), DOTA_UNIT_ORDER_CAST_POSITION, tExtraData, OnSpellStart)
	end
end
---------------------------------------------------------------------
if modifier_dark_willow_1_debuff == nil then
	modifier_dark_willow_1_debuff = class({}, nil, eom_modifier)
end
function modifier_dark_willow_1_debuff:OnCreated(params)
	self.energy_translate = self:GetAbilitySpecialValueFor("energy_translate")
	if IsServer() then
	else
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/dark_willow/dark_willow_ti8_immortal_head/dw_crimson_ti8_immortal_cursed_crown_cast.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_willow/dark_willow_leyconduit_start.vpcf", PATTACH_OVERHEAD_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_dark_willow_1_debuff:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() }
	}
end
function modifier_dark_willow_1_debuff:OnTakeDamage(params)
	if IsValid(self:GetAbility()) and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_DARK_WILLOW) ~= DOTA_DAMAGE_FLAG_DARK_WILLOW then
		self:GetAbility().flDamageRecord = self:GetAbility().flDamageRecord + params.damage * self.energy_translate
	end
end
function modifier_dark_willow_1_debuff:IsDebuff()
	return true
end
---------------------------------------------------------------------
if modifier_dark_willow_1_idle == nil then
	modifier_dark_willow_1_idle = class({}, nil, ModifierHidden)
end
function modifier_dark_willow_1_idle:OnCreated(params)
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	if IsServer() then
		hParent:SetAbsOrigin(hParent:GetAbsOrigin() + Vector(0, 0, 300))
		hParent:SetForwardVector(hCaster:GetForwardVector())
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_channel.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_dark_willow_1_idle:CheckState()
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
if modifier_dark_willow_1_motion == nil then
	modifier_dark_willow_1_motion = class({}, nil, BothModifier)
end
function modifier_dark_willow_1_motion:UpData()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		if IsValid(hCaster) then
			self.vPosition = hCaster:GetAttachmentOrigin(hCaster:ScriptLookupAttachment("attach_whisp"))
			-- DebugDrawSphere(self.vPosition, Vector(0,255,0), 255, 4, false, 1)
			self.vDir = (self.vPosition - hParent:GetAbsOrigin()):Normalized()
			self.vVelocity = self.vDir * self.flSpeed			-- 速度向量
			local angle = VectorToAngles(self.vDir)
			hParent:SetLocalAngles(0, angle[2], 0)
		end
	end
end
function modifier_dark_willow_1_motion:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		local vCasterLoc = hParent:GetAbsOrigin()
		self.bReturn = false								-- 回归状态
		self.vPosition = StringToVector(params.vPosition)	-- 目标位置
		self.flSpeed = 1800									-- 速度
		self.vDir = (self.vPosition - vCasterLoc):Normalized()
		self.vVelocity = self.vDir * self.flSpeed			-- 速度向量
		local angle = VectorToAngles(self.vDir)
		hParent:SetLocalAngles(0, angle[2], 0)
		if not self:ApplyHorizontalMotionController() or not self:ApplyVerticalMotionController() then
			self:Destroy()
			return
		end
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_willow/dark_willow_willowisp_ambient.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_dark_willow_1_motion:OnDestroy(params)
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)
		self:GetParent():RemoveVerticalMotionController(self)
		if IsValid(self:GetParent()) then
			self:GetParent():RemoveSelf()
		end
	end
end
function modifier_dark_willow_1_motion:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		if self.bReturn == false then
			local vNext = me:GetAbsOrigin() + self.vVelocity * dt
			me:SetAbsOrigin(me:GetAbsOrigin() + self.vVelocity * dt)
			-- 到达目标点后回归
			if (vNext - self.vPosition):Length2D() < self.flSpeed * dt then
				self:GetAbility():OnProjectileHit(self.vPosition)
				-- 回归速度变化
				me:StartGesture(ACT_DOTA_CAST_ABILITY_5)
				self.bReturn = true
				self.flSpeed = 600
				self:UpData()
			end
		else	-- 回归运动
			local vNext = me:GetAbsOrigin() + self.vVelocity * dt
			me:SetAbsOrigin(me:GetAbsOrigin() + self.vVelocity * dt)
			self:UpData()
			-- 回归结束
			if (vNext - self.vPosition):Length2D() < self.flSpeed * dt then
				self:Destroy()
				if self:GetCaster():HasModifier("modifier_dark_willow_2") then
					self:GetCaster():FindAbilityByName("dark_willow_2"):OnSpellStart()
				end
			end
		end
	end
end
function modifier_dark_willow_1_motion:UpdateVerticalMotion(me, dt)
	if IsServer() then
		self:UpdateHorizontalMotion(me, dt)
	end
end
function modifier_dark_willow_1_motion:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_dark_willow_1_motion:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end