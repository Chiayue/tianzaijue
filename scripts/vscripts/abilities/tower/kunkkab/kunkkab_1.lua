LinkLuaModifier("modifier_kunkkaB_1_debuff", "abilities/tower/kunkkaB/kunkkaB_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if kunkkaB_1 == nil then
	kunkkaB_1 = class({
		iBehavior = DOTA_ABILITY_BEHAVIOR_UNIT_TARGET,
		tExtraData = { sActivityModifier = { "Espada_pistola", "tidebringer" } },
		bIgnoreBackswing = false,
	}, nil, ability_base_ai)
end
function kunkkaB_1:GetCastRange(vLocation, hTarget)
	return self:GetCaster():Script_GetAttackRange() + 200
end
function kunkkaB_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local start_width = self:GetSpecialValueFor("start_width")
	local end_width = self:GetSpecialValueFor("end_width")
	local distance = self:GetSpecialValueFor("distance")
	-- 主目标
	hTarget:AddNewModifier(hCaster, self, "modifier_kunkkaB_1_debuff", { duration = self:GetDuration() })
	hCaster:DealDamage(hTarget, self)
	-- 特效
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/kunkkab/kunkkab_1.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/kunkka/kunkka_weapon_gunsword/kunkka_shot_gun.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_tidebringer_2", hCaster:GetAbsOrigin(), false)
	ParticleManager:ReleaseParticleIndex(iParticleID)

	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/kunkka/kunkka_weapon_gunsword/kunkka_spell_tidebringer_gun.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	hCaster:EmitSound("Hero_Kunkka.InverseBayonet")

	-- 分裂目标
	local n = 0
	DoCleaveAction(hCaster, hTarget, start_width, end_width, distance, function(hUnit)
		if IsValid(hUnit) then
			n = n + 1
			ParticleManager:SetParticleControl(iParticleID, n + 1, hUnit:GetAbsOrigin())
			-- ParticleManager:SetParticleControlEnt(iParticleID, n + 1, hUnit, PATTACH_ABSORIGIN_FOLLOW, nil, hUnit:GetAbsOrigin(), true)
			hUnit:AddNewModifier(hCaster, self, "modifier_kunkkaB_1_debuff", { duration = self:GetDuration() })
			hCaster:DealDamage(hUnit, self)
		end
	end)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(2, 17, n))
	ParticleManager:ReleaseParticleIndex(iParticleID)
end
---------------------------------------------------------------------
--Modifiers
if modifier_kunkkaB_1_debuff == nil then
	modifier_kunkkaB_1_debuff = class({}, nil, eom_modifier)
end
function modifier_kunkkaB_1_debuff:IsDebuff()
	return true
end
function modifier_kunkkaB_1_debuff:OnCreated(params)
	self.armor_reduce = self:GetAbilitySpecialValueFor('armor_reduce')
	self.speed_reduce = self:GetAbilitySpecialValueFor('speed_reduce')
	if IsServer() then
	end
end
function modifier_kunkkaB_1_debuff:OnRefresh(params)
	self.armor_reduce = self:GetAbilitySpecialValueFor('armor_reduce')
	self.speed_reduce = self:GetAbilitySpecialValueFor('speed_reduce')
	if IsServer() then
	end
end
function modifier_kunkkaB_1_debuff:EDeclareFunctions()
	return {
		[EMDF_PHYSICAL_ARMOR_BONUS] = -self.armor_reduce,
		[EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE] = -self.speed_reduce,
		[EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE] = -self.speed_reduce,
	}
end
function modifier_kunkkaB_1_debuff:GetPhysicalArmorBonus()
	return -self.armor_reduce
end
function modifier_kunkkaB_1_debuff:GetMoveSpeedBonusPercentage()
	return -self.speed_reduce
end
function modifier_kunkkaB_1_debuff:GetAttackSpeedPercentage()
	return -self.speed_reduce
end