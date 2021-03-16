LinkLuaModifier("modifier_pangolier_2", "abilities/tower/pangolier/pangolier_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_2_jump", "abilities/tower/pangolier/pangolier_2.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_pangolier_2_shield", "abilities/tower/pangolier/pangolier_2.lua", LUA_MODIFIER_MOTION_BOTH)
--Abilities
if pangolier_2 == nil then
	pangolier_2 = class({ iSearchBehavior = AI_SEARCH_BEHAVIOR_MOST_AOE_TARGET }, nil, ability_base_ai)
end
function pangolier_2:GetAOERadius()
	return self:GetSpecialValueFor("impact_radius")
end
function pangolier_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	hCaster:AddNewModifier(hCaster, self, "modifier_pangolier_2_jump", { duration = self:GetSpecialValueFor("jump_duration"), vPosition = vPosition })
	hCaster:EmitSound("Hero_Pangolier.TailThump.Cast")
end
function pangolier_2:GetIntrinsicModifierName()
	return "modifier_pangolier_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_pangolier_2 == nil then
	modifier_pangolier_2 = class({}, nil, ModifierHidden)
end
function modifier_pangolier_2:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_pangolier_2:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if hParent:IsAbilityReady(hAbility) then
		local flDistance = hAbility:GetCastRange(hParent:GetAbsOrigin(), nil)
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), flDistance, hAbility)
		if IsValid(tTargets[1]) then
			ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_POSITION, nil, hAbility, tTargets[1]:GetAbsOrigin())
		end
	end
end
---------------------------------------------------------------------
if modifier_pangolier_2_jump == nil then
	modifier_pangolier_2_jump = class({}, nil, BothModifier)
end
function modifier_pangolier_2_jump:OnCreated(params)
	if IsServer() then
		self.armor_elite_factor = self:GetAbilitySpecialValueFor("armor_elite_factor")
		self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_2)
		self.vPosition = StringToVector(params.vPosition)
		local vForward = (self.vPosition - self:GetParent():GetAbsOrigin()):Normalized()
		self.jump_height = self:GetAbilitySpecialValueFor("jump_height")
		self.jump_horizontal_distance = (self.vPosition - self:GetParent():GetAbsOrigin()):Length2D()
		self.vS = self:GetParent():GetAbsOrigin()
		self.fSpeed = self.jump_horizontal_distance / self:GetDuration()
		self.vV = vForward * self.fSpeed

		local angle = VectorToAngles(vForward)
		self:GetParent():SetLocalAngles(0, angle[2], 0)

		local a = math.sqrt(self.jump_height)
		self.funcGetJmepHeight = function(x)
			x = (x / self.jump_horizontal_distance) * a * 2 - a
			return -(x ^ 2) + self.jump_height
		end
		if not self:ApplyHorizontalMotionController() or not self:ApplyVerticalMotionController() then
			self:Destroy()
			return
		end

		self.impact_radius = self:GetAbilitySpecialValueFor("impact_radius")
		self.impact_stun_duration = self:GetAbilitySpecialValueFor("impact_stun_duration")
	end
end
function modifier_pangolier_2_jump:OnDestroy(params)
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)
		self:GetParent():RemoveVerticalMotionController(self)
	end
end
function modifier_pangolier_2_jump:JumpFinish()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local iUnitCount = 0
	local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.impact_radius, hAbility)
	for _, hUnit in pairs(tTargets) do
		hParent:DealDamage(hUnit, hAbility, 0)
		hUnit:AddBuff(hParent, BUFF_TYPE.STUN, self.impact_stun_duration)
		if hUnit:GetUnitLabel() then

		end
		if hParent:IsBoss() or
		hParent:IsAncient() or
		hParent:GetUnitLabel() == "elite" then
			iUnitCount = iUnitCount + self.armor_elite_factor
		else
			iUnitCount = iUnitCount + 1
		end
	end

	hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_pangolier_2_shield", { iUnitCount = iUnitCount, duration = hAbility:GetDuration() })

	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_pangolier/pangolier_tailthump_hero.vpcf", PATTACH_ABSORIGIN, hParent)
	self:AddParticle(iParticleID, false, false, -1, false, false)

	hParent:EmitSound("Hero_Pangolier.TailThump")
end
function modifier_pangolier_2_jump:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local vPos = self.vV * dt + self:GetParent():GetAbsOrigin()
		local fDis = (vPos - self.vS):Length2D()
		if fDis > self.jump_horizontal_distance then
			fDis = self.jump_horizontal_distance
		end
		vPos.z = self.vS.z + self.funcGetJmepHeight(fDis)
		me:SetAbsOrigin(vPos)

		if fDis == self.jump_horizontal_distance then
			--成功着陆
			self:JumpFinish()
			self:Destroy()
		end
	end
end
function modifier_pangolier_2_jump:UpdateVerticalMotion(me, dt)
	if IsServer() then
		self:UpdateHorizontalMotion(me, dt)
	end
end
function modifier_pangolier_2_jump:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_pangolier_2_jump:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_pangolier_2_jump:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end
---------------------------------------------------------------------
if modifier_pangolier_2_shield == nil then
	modifier_pangolier_2_shield = class({}, nil, ModifierPositiveBuff)
end
function modifier_pangolier_2_shield:OnCreated(params)
	self.armor_per_unit = self:GetAbilitySpecialValueFor("armor_per_unit")
	local hParent = self:GetParent()
	if IsServer() then
		self.flShieldHealth = params.iUnitCount * self.armor_per_unit
		self:SetStackCount(self.flShieldHealth)
		-- else
		-- particle
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControl(iParticleID, 3, Vector(math.min(params.iUnitCount, 5) * 10, 0, 0))
		ParticleManager:SetParticleControl(iParticleID, 8, Vector(math.min(params.iUnitCount, 5), 0, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_pangolier_2_shield:OnRefresh(params)
	self.armor_per_unit = self:GetAbilitySpecialValueFor("armor_per_unit")
	local hParent = self:GetParent()
	if IsServer() then
		self.flShieldHealth = params.iUnitCount * self.armor_per_unit * self:GetParent():GetVal(ATTRIBUTE_KIND.StatusHealth) * 0.01
	end
end
function modifier_pangolier_2_shield:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_pangolier_2_shield:OnTooltip()
	return self:GetStackCount()
end
function modifier_pangolier_2_shield:GetModifierTotal_ConstantBlock(params)
	if IsServer() and params.damage > 0 then
		local hParent = self:GetParent()
		local flBlock = self.flShieldHealth
		self.flShieldHealth = self.flShieldHealth - params.damage
		self:SetStackCount(self.flShieldHealth)
		if self.flShieldHealth < 0 then
			self:Destroy()
		end
		return self:GetStackCount()
	end
end