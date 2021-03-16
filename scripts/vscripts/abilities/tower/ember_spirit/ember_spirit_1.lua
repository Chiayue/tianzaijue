LinkLuaModifier("modifier_ember_spirit_1_buff", "abilities/tower/ember_spirit/ember_spirit_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_1_marker", "abilities/tower/ember_spirit/ember_spirit_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_1_disarmed", "abilities/tower/ember_spirit/ember_spirit_1.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if ember_spirit_1 == nil then
	ember_spirit_1 = class({ iBehavior = DOTA_ABILITY_BEHAVIOR_POINT, iSearchBehavior = AI_SEARCH_BEHAVIOR_MOST_AOE_TARGET }, nil, ability_base_ai)
end
function ember_spirit_1:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function ember_spirit_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_cast.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, radius, radius))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	hCaster:AddNewModifier(hCaster, self, "modifier_ember_spirit_1_buff", { vPosition = vPosition })

	hCaster:EmitSound("Hero_EmberSpirit.SleightOfFist.Cast")
end
---------------------------------------------------------------------
-- Modifiers
if modifier_ember_spirit_1_buff == nil then
	modifier_ember_spirit_1_buff = class({}, nil, eom_modifier)
end
function modifier_ember_spirit_1_buff:IsHidden()
	return true
end
function modifier_ember_spirit_1_buff:OnCreated(params)
	self.cur_phy_atk = self:GetParent():GetVal(ATTRIBUTE_KIND.PhysicalAttack)
	local hCaster = self:GetCaster()
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	self.attack_interval = self:GetAbilitySpecialValueFor("attack_interval")
	if IsServer() then
		local vPosition = StringToVector(params.vPosition)
		local hParent = self:GetParent()

		self.vStartPosition = hParent:GetAbsOrigin()
		self.tTargets = FindUnitsInRadiusWithAbility(hParent, vPosition, self.radius, self:GetAbility())

		if #self.tTargets > 0 then
			self:GetAbility():SetActivated(false)
			hParent:AddNoDraw()
			hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_ember_spirit_1_disarmed", nil)
			hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_no_health_bar", nil)

			self.iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_caster.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(self.iParticleID, 0, self.vStartPosition)
			ParticleManager:SetParticleControlEnt(self.iParticleID, 1, hParent, PATTACH_CUSTOMORIGIN_FOLLOW, nil, self.vStartPosition, true)
			ParticleManager:SetParticleControlForward(self.iParticleID, 1, hParent:GetForwardVector())
			self:AddParticle(self.iParticleID, false, false, -1, false, false)

			for _, hUnit in pairs(self.tTargets) do
				hUnit:AddNewModifier(hParent, self:GetAbility(), "modifier_ember_spirit_1_marker", nil)
			end

			-- self:OnIntervalThink()
			self:StartIntervalThink(self.attack_interval)

		else
			self:Destroy()
		end
	end
end
function modifier_ember_spirit_1_buff:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	self.attack_interval = self:GetAbilitySpecialValueFor("attack_interval")
end
function modifier_ember_spirit_1_buff:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()

		local particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(particleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControl(particleID, 1, self.vStartPosition)
		ParticleManager:ReleaseParticleIndex(particleID)

		FindClearSpaceForUnit(hParent, self.vStartPosition, true)

		self:GetAbility():SetActivated(true)
		hParent:RemoveNoDraw()
		hParent:RemoveModifierByName("modifier_ember_spirit_1_disarmed")
		hParent:RemoveModifierByName("modifier_no_health_bar")

		for i = #self.tTargets, 1, -1 do
			local _target = self.tTargets[i]
			if IsValid(_target) then
				_target:RemoveModifierByName("modifier_ember_spirit_1_marker")
			end
			table.remove(self.tTargets, i)
		end
	end
end
function modifier_ember_spirit_1_buff:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local vCasterPosition = hParent:GetAbsOrigin()

		local hTarget

		for i = #self.tTargets, 1, -1 do
			local _target = self.tTargets[i]
			table.remove(self.tTargets, i)
			if IsValid(_target) then
				_target:RemoveModifierByName("modifier_ember_spirit_1_marker")
				if UnitFilter(_target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, hParent:GetTeamNumber()) == UF_SUCCESS then
					hTarget = _target
					break
				end
			end
		end

		if hTarget == nil then
			self:Destroy()
			return
		end

		local vTargetPosition = hTarget:GetAbsOrigin()
		local vDirection = vTargetPosition - self.vStartPosition
		vDirection.z = 0

		local vPosition = vTargetPosition - vDirection:Normalized() * 50

		FindClearSpaceForUnit(hParent, vPosition, true)

		local particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(particleID, 0, vCasterPosition)
		ParticleManager:SetParticleControl(particleID, 1, vTargetPosition)
		ParticleManager:ReleaseParticleIndex(particleID)

		local particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_tgt.vpcf", PATTACH_CUSTOMORIGIN, hTarget)
		ParticleManager:SetParticleControlEnt(particleID, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particleID)

		hParent:RemoveModifierByName("modifier_ember_spirit_1_disarmed")
		if not hParent:HasModifier("modifier_ember_spirit_1_disarmed") then
			hParent:Attack(hTarget, ATTACK_STATE_SKIPCOOLDOWN + ATTACK_STATE_NOT_USEPROJECTILE)
			local hAbility_3 = hParent:FindAbilityByName("ember_spirit_3")
			if IsValid(hAbility_3) and hAbility_3:GetLevel() > 0 then
				hAbility_3:CreateRemnant(self.vStartPosition, vPosition + RandomVector(128))
			end
		end
		hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_ember_spirit_1_disarmed", nil)

		EmitSoundOnLocationWithCaster(vTargetPosition, "Hero_EmberSpirit.SleightOfFist.Damage", hParent)
	end
end
function modifier_ember_spirit_1_buff:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
	}
end
function modifier_ember_spirit_1_buff:EDeclareFunctions()
	return {
		[EMDF_PHYSICAL_ATTACK_BONUS] = self:GetPhysicalAttackBonus()
	}
end
function modifier_ember_spirit_1_buff:GetPhysicalAttackBonus()
	return self.cur_phy_atk * self.bonus_damage * 0.01
end
---------------------------------------------------------------------
if modifier_ember_spirit_1_marker == nil then
	modifier_ember_spirit_1_marker = class({}, nil, ModifierHidden)
end
function modifier_ember_spirit_1_marker:OnCreated(params)
	if IsClient() then
		local particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_targetted_marker.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		self:AddParticle(particleID, false, false, -1, false, false)
	end
end
---------------------------------------------------------------------
if modifier_ember_spirit_1_disarmed == nil then
	modifier_ember_spirit_1_disarmed = class({}, nil, ModifierHidden)
end
function modifier_ember_spirit_1_disarmed:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true
	}
end