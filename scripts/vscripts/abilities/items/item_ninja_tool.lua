LinkLuaModifier("modifier_item_ninja_tool", "abilities/items/item_ninja_tool.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_ninja_tool_thinker", "abilities/items/item_ninja_tool.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_ninja_tool == nil then
	item_ninja_tool = class({}, nil, base_ability_attribute)
end
function item_ninja_tool:CreateShuriken()
	local hCaster = self:GetCaster()
	local dagger_count = self:GetSpecialValueFor("dagger_count")
	local flDistance = self:GetSpecialValueFor("distance")
	for i = 1, dagger_count do
		local vDirection = AnglesToVector(QAngle(0, i * 360 / dagger_count, 0)):Normalized()
		local info = {
			Ability = self,
			Source = hCaster,
			EffectName = "particles/items/item_ninja_tool/ninja_tool.vpcf",
			vSpawnOrigin = hCaster:GetAbsOrigin(),
			vVelocity = vDirection * flDistance * 2,
			fDistance = flDistance,
			fStartRadius = 125,
			fEndRadius = 125,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		}
		ProjectileManager:CreateLinearProjectile(info)
	end
end
function item_ninja_tool:OnProjectileHit(hTarget, vLocation)
	if hTarget then
		local hCaster = self:GetCaster()
		hCaster:DealDamage(hTarget, self, self:GetAbilityDamage())
	end
	return true
end
function item_ninja_tool:GetIntrinsicModifierName()
	return "modifier_item_ninja_tool"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_ninja_tool == nil then
	modifier_item_ninja_tool = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_ninja_tool:OnCreated(params)
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then
	end
end
function modifier_item_ninja_tool:OnRefresh(params)
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then
	end
end
function modifier_item_ninja_tool:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_ninja_tool:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE
	}
end
function modifier_item_ninja_tool:GetModifierAvoidDamage(params)
	local hParent = self:GetParent()
	local vStart = hParent:GetAbsOrigin()
	if self:GetAbility():IsCooldownReady() then
		self:GetAbility():UseResources(false, false, true)
		-- 创建傀儡
		local hUnit = CreateUnitByName("npc_dota_dummy", vStart, false, hParent, hParent, hParent:GetTeamNumber())
		hUnit:AddNewModifier(hParent, self:GetAbility(), "modifier_item_ninja_tool_thinker", { duration = self.duration })
		-- 解锁效果
		if self:GetAbility():GetLevel() >= self.unlock_level then
			self:GetAbility():CreateShuriken()
		end
		-- 传送到周围
		local vPosition = vStart + RandomVector(self.distance)
		for i = 1, 4 do
			if GridNav:CanFindPath(vStart, vPosition) == false then
				vPosition = RotatePosition(vStart, QAngle(0, 90, 0), vPosition)
			end
		end
		-- while GridNav:CanFindPath(vStart, vPosition) == false do
		-- 	vPosition = vStart + RandomVector(self.distance)
		-- end
		FindClearSpaceForUnit(hParent, vPosition, false)
		-- 清除buff
		hParent:Purge(false, true, false, true, true)
		-- 特效
		local iParticleID = ParticleManager:CreateParticle("particles/items/item_ninja_tool/ninja_tool_start.vpcf", PATTACH_ABSORIGIN, hParent)
		ParticleManager:SetParticleControl(iParticleID, 0, vStart)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_ti7/antimage_blink_ti7_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		return 1
	end
end
---------------------------------------------------------------------
if modifier_item_ninja_tool_thinker == nil then
	modifier_item_ninja_tool_thinker = class({}, nil, BaseModifier)
end
function modifier_item_ninja_tool_thinker:OnDestroy()
	if IsServer() then
		if IsValid(self:GetParent()) then
			self:GetParent():RemoveSelf()
		end
	end
end
function modifier_item_ninja_tool_thinker:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE,
	-- MODIFIER_PROPERTY_MODEL_CHANGE
	}
end
function modifier_item_ninja_tool_thinker:GetModifierModelChange()
	return "models/items/antimage/ti7_antimage_immortal/antimage_immortal_remnant_fx.vmdl"
end
function modifier_item_ninja_tool_thinker:GetModifierAvoidDamage()
	return 1
end
function modifier_item_ninja_tool_thinker:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end