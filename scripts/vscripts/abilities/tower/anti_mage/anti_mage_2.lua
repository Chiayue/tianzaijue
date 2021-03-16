LinkLuaModifier("modifier_anti_mage_2", "abilities/tower/anti_mage/anti_mage_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_anti_mage_2_particle_thinker", "abilities/tower/anti_mage/anti_mage_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_anti_mage_2_break", "abilities/tower/anti_mage/anti_mage_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_anti_mage_2_particle_damage", "abilities/tower/anti_mage/anti_mage_2.lua", LUA_MODIFIER_MOTION_NONE)

if anti_mage_2 == nil then
	local tInitData = {
		iBehavior = DOTA_ABILITY_BEHAVIOR_POINT
	}
	anti_mage_2 = class(tInitData, nil, ability_base_ai)
end
-- function anti_mage_2:GetManaCost(iLevel)
-- 	if not self.tManaCost then
-- 		self.tManaCost = string.split(KeyValues.AbilitiesKv[self:GetAbilityName()].AbilityManaCost, ' ')
-- 	end
-- 	local iManaCost = self.tManaCost[1] or 1
-- 	for i = #self.tManaCost, 1, -1 do
-- 		if self:GetLevel() >= i then
-- 			iManaCost = self.tManaCost[i]
-- 			break
-- 		end
-- 	end
-- 	return math.max(self:GetCaster():GetMana(), iManaCost)
-- end
-- function anti_mage_2:OnAbilityPhaseStart()
-- 	self.iManaCostCur = self:GetManaCost(self:GetLevel())
-- 	return true
-- end
function anti_mage_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor('radius')
	local stun_duration = self:GetSpecialValueFor('stun_duration')
	local mana_rate_armor = self:GetSpecialValueFor('mana_rate_armor')
	local mana_rate_damage = self:GetSpecialValueFor('mana_rate_damage')
	local vPosition = self:GetCursorPosition()
	local curMaxMana = hCaster:GetVal(ATTRIBUTE_KIND.StatusMana)

	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), vPosition, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
	for _, hTarget in pairs(tTargets) do
		--闪烁眩晕敌人
		if 0 < stun_duration then
			hTarget:AddBuff(hCaster, BUFF_TYPE.STUN, stun_duration)
		end

		---@type DamageData
		local tDamageData = {
			victim = hTarget,
			attacker = hCaster,
			ability = self,
			damage = mana_rate_damage * curMaxMana,
			damage_type = self:GetAbilityDamageType(),
		}
		ApplyDamage(tDamageData)
	end

	-- hCaster:AddNewModifier(hCaster, self, 'modifier_anti_mage_2_particle_damage', { duration = LOCAL_PARTICLE_MODIFIER_DURATION })
	-- EmitSoundOn("Hero_Antimage.ManaVoid", hCaster)

	EmitSoundOnLocationWithCaster(hCaster:GetAbsOrigin(), "Hero_Antimage.Blink_out", hCaster)
	CreateModifierThinker(hCaster, self, "modifier_anti_mage_2_particle_thinker", { duration = LOCAL_PARTICLE_MODIFIER_DURATION }, hCaster:GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)

	ProjectileManager:ProjectileDodge(hCaster)
	FindClearSpaceForUnit(hCaster, vPosition, true)

	--添加护盾
	local iHP = mana_rate_armor * curMaxMana
	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), vPosition, nil, radius,
	DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
	DOTA_UNIT_TARGET_FLAG_NONE,
	FIND_ANY_ORDER, false)
	for _, hTarget in pairs(tTargets) do
		hTarget:AddNewModifier(hCaster, self, 'modifier_anti_mage_2_break', { iHP = iHP })
	end

	-- hCaster:GiveMana(curMaxMana)
end

---------------------------------------------------------------------
--Modifiers
if modifier_anti_mage_2 == nil then
	modifier_anti_mage_2 = class({}, nil, BaseModifier)
end
function modifier_anti_mage_2:IsHidden()
	return true
end
function modifier_anti_mage_2:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_anti_mage_2:OnIntervalThink()
	local hParent = self:GetParent()
	local hAblt = self:GetAbility()
	if not hParent:IsAbilityReady(hAblt) then return end

	--随机一个敌人
	local tTargets = Spawner:FindMissingInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), -1, hAblt:GetAbilityTargetTeam(), hAblt:GetAbilityTargetType(), hAblt:GetAbilityTargetFlags(), FIND_ANY_ORDER, GetPlayerID(hParent), true)
	local hTarget = tTargets[RandomInt(1, #tTargets)]
	if IsValid(hTarget) then
		ExecuteOrderFromTable({
			UnitIndex = hParent:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			AbilityIndex = hAblt:entindex(),
			Position = hTarget:GetAbsOrigin()
		})
	end
end

--
if modifier_anti_mage_2_particle_thinker == nil then
	modifier_anti_mage_2_particle_thinker = class({}, nil, ParticleModifierThinker)
end
function modifier_anti_mage_2_particle_thinker:IsHidden()
	return true
end
function modifier_anti_mage_2_particle_thinker:OnCreated(params)
	if IsServer() then
	else
		LocalPlayerAbilityParticle(self:GetAbility(), function()
			-- caster是敌法现在的位置，parent是敌法原来的位置
			local vDirection = (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()
			local iParticleID = ParticleManager:CreateParticle('particles/units/heroes/hero_antimage/antimage_blink_start.vpcf', PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlForward(iParticleID, 0, vDirection)
			ParticleManager:SetParticleControlEnt(iParticleID, 1, self:GetParent(), PATTACH_CUSTOMORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end, PARTICLE_DETAIL_LEVEL_MEDIUM)
	end
end

--护盾
if modifier_anti_mage_2_break == nil then
	modifier_anti_mage_2_break = class({}, nil, eom_modifier)
end
function modifier_anti_mage_2_break:IsHidden()
	return false
end
function modifier_anti_mage_2_break:OnCreated(params)
	if IsServer() then
		self:SetStackCount(-params.iHP)
	else
		LocalPlayerAbilityParticle(self:GetAbility(), function()
			-- local fModelRadius = self:GetParent():GetModelRadius()
			local fModelRadius = self:GetParent():GetModelRadius() / 2
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_counter.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
			ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(fModelRadius, fModelRadius, fModelRadius))
			self:AddParticle(iParticleID, false, false, -1, false, false)
			return iParticleID
		end, PARTICLE_DETAIL_LEVEL_ULTRA)
	end
end
function modifier_anti_mage_2_break:OnRefresh(params)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() - params.iHP)
	end
end
function modifier_anti_mage_2_break:OnDestroy()
	if IsServer() then
		self:GetParent():EmitSound("Hero_Antimage.Counterspell.Absorb")
	else
		LocalPlayerAbilityParticle(self:GetAbility(), function()
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
			ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end, PARTICLE_DETAIL_LEVEL_ULTRA)
	end
end
function modifier_anti_mage_2_break:OnStackCountChanged(iStackCount)
	-- if IsServer() then
	-- 	EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_Antimage.Counterspell.Target", self:GetParent())
	-- 	if 0 == self:GetStackCount() then self:OnDestroy() return end
	-- else
	-- 	if self:GetStackCount() > iStackCount then
	-- 		LocalPlayerAbilityParticle(self:GetAbility(), function()
	-- 			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
	-- 			ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	-- 			ParticleManager:ReleaseParticleIndex(iParticleID)
	-- 		end, PARTICLE_DETAIL_LEVEL_ULTRA)
	-- 	end
	-- end
end
function modifier_anti_mage_2_break:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_anti_mage_2_break:GetModifierTotal_ConstantBlock(params)
	if params.damage ~= params.damage then return end
	if - self:GetStackCount() <= params.damage then
		self:Destroy()
		return -self:GetStackCount()
	end
	self:SetStackCount(self:GetStackCount() + math.ceil(params.damage))
	return params.damage
end
function modifier_anti_mage_2_break:OnTooltip()
	return -self:GetStackCount()
end



--法力虚空特效
if modifier_anti_mage_2_particle_damage == nil then
	modifier_anti_mage_2_particle_damage = class({}, nil, ParticleModifier)
end
function modifier_anti_mage_2_particle_damage:OnCreated(params)
	if IsServer() then
	else
		local radius = self:GetAbilitySpecialValueFor("radius")
		LocalPlayerAbilityParticle(self:GetAbility(), function()
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_manavoid.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, 0, 0))
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end, PARTICLE_DETAIL_LEVEL_ULTRA)
	end
end