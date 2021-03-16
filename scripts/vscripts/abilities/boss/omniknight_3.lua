LinkLuaModifier( "modifier_omniknight_3", "abilities/boss/omniknight_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_omniknight_3_motion", "abilities/boss/omniknight_3.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
--Abilities
if omniknight_3 == nil then
	omniknight_3 = class({})
end
function omniknight_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local vDirection = (vPosition - hCaster:GetAbsOrigin()):Normalized()
	local flDistance = self:GetSpecialValueFor("distance")
	vPosition = hCaster:GetAbsOrigin() + vDirection * flDistance
	local speed = self:GetSpecialValueFor('speed')
	local duration = (vPosition - hCaster:GetAbsOrigin()):Length2D() / speed
	hCaster:AddNewModifier(hCaster, self, "modifier_omniknight_3_motion", { duration = duration, vPosition = vPosition })
	-- 刷新二技能
	hCaster:FindAbilityByName("omniknight_2"):EndCooldown()
end
function omniknight_3:GetIntrinsicModifierName()
	return "modifier_omniknight_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_omniknight_3 == nil then
	modifier_omniknight_3 = class({}, nil, BaseModifier)
end
function modifier_omniknight_3:IsHidden()
	return true
end
function modifier_omniknight_3:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_omniknight_3:OnIntervalThink()
	local hParent = self:GetParent()
	if hParent:IsAbilityReady(self:GetAbility()) then
		local hAbility = hParent:FindAbilityByName("omniknight_1")
		if IsValid(hAbility) and IsValid(hAbility.hLinkTarget) then
			ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_POSITION, nil, self:GetAbility(), hAbility.hLinkTarget:GetAbsOrigin())
		else
			local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self:GetAbility():GetCastRange(hParent:GetAbsOrigin(), nil), self:GetAbility())
			table.sort(tTargets, function (a,b) return a:GetHealth() < b:GetHealth() end)
			if IsValid(tTargets[1]) then
				ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_POSITION, nil, self:GetAbility(), tTargets[1]:GetAbsOrigin())
			end
		end
	end
end
---------------------------------------------------------------------
if modifier_omniknight_3_motion == nil then
	modifier_omniknight_3_motion = class({})
end
function modifier_omniknight_3_motion:IsHidden()
	return true
end
function modifier_omniknight_3_motion:GetEffectName()
	return 'particles/units/heroes/hero_storm_spirit/hero_storm_spirit_cookie_receive.vpcf'
end
function modifier_omniknight_3_motion:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_omniknight_3_motion:GetPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST
end
function modifier_omniknight_3_motion:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		self.vPosition = StringToVector(params.vPosition)
		self.vDir = (self.vPosition - self:GetParent():GetAbsOrigin()):Normalized()
		self.speed = self:GetAbilitySpecialValueFor('speed')
		self.chance = self:GetAbilitySpecialValueFor('chance')
		self.radius = self:GetAbilitySpecialValueFor('damage_radius')
		self.base_damage = self:GetAbilitySpecialValueFor('base_damage')
		self.damage_distance_factor = self:GetAbilitySpecialValueFor('damage_distance_factor')
		-- 连接的单位
		self.hLinkTarget = nil
		local hAbility = hParent:FindAbilityByName("omniknight_1")
		if IsValid(hAbility) and IsValid(hAbility.hLinkTarget) then
			self.hLinkTarget = hAbility.hLinkTarget
		end

		self.tTargets = {}
		local iParticleID = ParticleManager:CreateParticle("particles/units/boss/omniknight/omniknight_3.vpcf", PATTACH_CUSTOMORIGIN, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_CUSTOMORIGIN_FOLLOW, nil, hParent:GetAbsOrigin(), true)
		hParent:EmitSound("Hero_StormSpirit.BallLightning")
		hParent:EmitSound("Hero_StormSpirit.BallLightning.Loop")
		self:AddParticle(iParticleID, false, false, -1, false, false)
		if not self:ApplyHorizontalMotionController() then
			self:Destroy()
			return
		end
		
		-- 消耗全部魔法
		-- hParent:SpendMana(hParent:GetMana(), self:GetAbility())
	end
end
function modifier_omniknight_3_motion:OnDestroy(params)
	if IsServer() then
		local hParent = self:GetParent()
		hParent:RemoveHorizontalMotionController(self)
		hParent:StopSound("Hero_StormSpirit.BallLightning.Loop")
		FindClearSpaceForUnit(hParent, hParent:GetAbsOrigin(), true)
	end
end
function modifier_omniknight_3_motion:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local vNext = me:GetAbsOrigin() + self.vDir * self.speed * dt
		-- 撞墙停止
		if not GridNav:CanFindPath(me:GetAbsOrigin(), vNext) then
			self:Destroy()
		end

		me:SetAbsOrigin(me:GetAbsOrigin() + self.vDir * self.speed * dt)
		local tTargets = FindUnitsInRadius(me:GetTeamNumber(), me:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, hUnit in pairs(tTargets) do
			if TableFindKey(self.tTargets, hUnit) == nil then
				local tDamage = {
					ability = self:GetAbility(),
					attacker = me,
					victim = hUnit,
					damage = self.base_damage + self.damage_distance_factor * (me:GetAbsOrigin() - self.vPosition):Length2D(),
					damage_type = DAMAGE_TYPE_MAGICAL
				}
				ApplyDamage(tDamage)
				-- 击杀连接的单位回满蓝
				-- if IsValid(self.hLinkTarget) then
				-- 	me:GiveMana(me:GetMaxMana())
				-- end
				table.insert(self.tTargets, hUnit)
			end
		end
	end
end
function modifier_omniknight_3_motion:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_omniknight_3_motion:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end
function modifier_omniknight_3_motion:GetOverrideAnimation(params)
	return ACT_DOTA_OVERRIDE_ABILITY_4
end
function modifier_omniknight_3_motion:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
end