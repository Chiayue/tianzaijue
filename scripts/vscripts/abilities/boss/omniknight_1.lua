LinkLuaModifier("modifier_omniknight_1", "abilities/boss/omniknight_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_omniknight_1_link", "abilities/boss/omniknight_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if omniknight_1 == nil then
	omniknight_1 = class({})
end
function omniknight_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	hTarget:AddNewModifier(hCaster, self, "modifier_omniknight_1_link", { duration = self:GetDuration() })
	hTarget:EmitSound("Hero_Wisp.Tether.Target")
end
function omniknight_1:GetIntrinsicModifierName()
	return "modifier_omniknight_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_omniknight_1 == nil then
	modifier_omniknight_1 = class({}, nil, BaseModifier)
end
function modifier_omniknight_1:IsHidden()
	return true
end
function modifier_omniknight_1:OnCreated(params)
	self.cast_range = self:GetAbilitySpecialValueFor("cast_range")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_omniknight_1:OnIntervalThink()
	local hParent = self:GetParent()
	if hParent:IsAbilityReady(self:GetAbility()) then
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.cast_range, self:GetAbility())
		-- table.sort(tTargets, function(a, b) return a:GetHealth() < b:GetHealth() end)
		local hTarget = tTargets[RandomInt(1, #tTargets)]
		if IsValid(hTarget) then
			ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_TARGET, hTarget, self:GetAbility())
		end
	end
end
---------------------------------------------------------------------
if modifier_omniknight_1_link == nil then
	modifier_omniknight_1_link = class({}, nil, eom_modifier)
end
function modifier_omniknight_1_link:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_omniknight_1_link:OnCreated(params)
	self.magical_deepen = self:GetAbilitySpecialValueFor("magical_deepen")
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	if IsServer() then
		ExecuteOrder(hCaster, DOTA_UNIT_ORDER_ATTACK_TARGET, hParent)
		self:GetAbility().hLinkTarget = hParent
		hCaster:EmitSound("Hero_Wisp.Tether")
	else
		-- particle
		local iParticleID = ParticleManager:CreateParticle("particles/units/boss/omniknight/omniknight_1.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/boss/omniknight/omniknight_1_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_omniknight_1_link:OnRefresh(params)
	self.magical_deepen = self:GetAbilitySpecialValueFor("magical_deepen")
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	if IsServer() then
		local hParent = self:GetParent()
	end
end
function modifier_omniknight_1_link:OnDestroy(params)
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	if IsServer() then
		local hAbility = self:GetAbility()

		if hParent:IsAlive() and IsValid(hCaster) and not hCaster:IsChanneling() then
			-- hCaster:AddBuff(hCaster, BUFF_TYPE.STUN, self.stun_duration)
			hCaster:AddNewModifier(hCaster, hAbility, "modifier_stunned", { duration = self.stun_duration })
		else
			if IsValid(hAbility) then
				hAbility:EndCooldown()
				hAbility:GetIntrinsicModifier():OnIntervalThink()
			end
		end

		if IsValid(hAbility) then
			hAbility.hLinkTarget = nil
		end
		if IsValid(hCaster) then
			hCaster:StopSound("Hero_Wisp.Tether")
		end
		-- 死亡爆炸
		if not hParent:IsAlive() then
			local tTargets = FindUnitsInRadiusWithAbility(hCaster, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
			hCaster:DealDamage(tTargets, self:GetAbility())
			local iParticleID = ParticleManager:CreateParticle("particles/units/boss/omniknight/omniknight_8.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, self.radius, self.radius))
			self:AddParticle(iParticleID, false, false, -1, false, false)
		end
	end
end
function modifier_omniknight_1_link:EDeclareFunctions()
	return {
		[EMDF_MAGICAL_INCOMING_PERCENTAGE] = self.magical_deepen
	}
end
function modifier_omniknight_1_link:GetMagicalIncomingPercentage()
	return self.magical_deepen
end