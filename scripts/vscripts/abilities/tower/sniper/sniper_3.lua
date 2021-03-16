LinkLuaModifier("modifier_sniper_3", "abilities/tower/sniper/sniper_3.lua", LUA_MODIFIER_MOTION_NONE)

if sniper_3 == nil then
	sniper_3 = class({})
end
function sniper_3:GetIntrinsicModifierName()
	return "modifier_sniper_3"
end
function sniper_3:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	local hCaster = self:GetCaster()
	if IsValid(hTarget) then
	else
		DelAttackInfo(ExtraData.record)
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sniper_3 == nil then
	modifier_sniper_3 = class({}, nil, eom_modifier)
end
function modifier_sniper_3:IsHidden()
	return true
end
function modifier_sniper_3:OnCreated(params)
	self.projectile_speed = self:GetAbilitySpecialValueFor("projectile_speed")
	self.critical_damage = self:GetAbilitySpecialValueFor("critical_damage")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.damage_reduce_pct = self:GetAbilitySpecialValueFor("damage_reduce_pct")
	self.jump_count = self:GetAbilitySpecialValueFor("jump_count")
	if IsServer() then
		self.tJumpInfos = {}
	end
end
function modifier_sniper_3:OnRefresh(params)
	self.projectile_speed = self:GetAbilitySpecialValueFor("projectile_speed")
	self.critical_damage = self:GetAbilitySpecialValueFor("critical_damage")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.damage_reduce_pct = self:GetAbilitySpecialValueFor("damage_reduce_pct")
	self.jump_count = self:GetAbilitySpecialValueFor("jump_count")
	if IsServer() then
	end
end
function modifier_sniper_3:OnDestroy()
	if IsServer() then
	end
end
function modifier_sniper_3:EDeclareFunctions()
	return {
		-- [MODIFIER_EVENT_ON_ATTACK_START] = { self:GetParent() },
		EMDF_EVENT_ON_ATTACK_RECORD_CREATE,
		[MODIFIER_EVENT_ON_ATTACK] = { self:GetParent() },
		EMDF_EVENT_ON_ATTACK_HIT,
		EMDF_EVENT_ON_ATTACK_RECORD_DESTROY,
		[MODIFIER_EVENT_ON_DEATH] = { self:GetParent() },
		EMDF_ATTACK_CRIT_BONUS,
	}
end
-- function modifier_sniper_3:OnAttackStart_AttackSystem(params, ExtarData)
-- 	self:OnAttackStart(params, ExtarData)
-- end
-- function modifier_sniper_3:OnAttackStart(params, ExtarData)
-- 	if params.target == nil or params.target:GetClassname() == "dota_item_drop" then return end
-- 	if params.attacker ~= self:GetParent() or params.attacker:IsIllusion() then return end
-- end
function modifier_sniper_3:OnCustomAttackRecordCreate(params)
	if params.target == nil or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker ~= self:GetParent() or params.attacker:IsIllusion() then return end

	if nil ~= self.iJumpOriginRecord then
		--攻击修改，弹射攻击具有最高优先级
		params.attacker:SetVal(ATTRIBUTE_KIND.AttackBehavior, self.DoAttackBehavior, self, ATTACK_PROJECTILE_LEVEL.ULTRA)

		self.tJumpInfos[params.record] = self.tJumpInfos[self.iJumpOriginRecord]
		table.insert(self.tJumpInfos[params.record].tJumpRecords, params)
		self.iJumpOriginRecord = nil
	else
		if self:GetAbility():IsCooldownReady() then
			--攻击修改
			params.attacker:SetVal(ATTRIBUTE_KIND.AttackBehavior, self.DoAttackBehavior, self, ATTACK_PROJECTILE_LEVEL.MEDIUM)

			self.tJumpInfos[params.record] = {
				iMainRecord = params,
				iJumpCount = self.jump_count,
				tJumpRecords = {}
			}
		end
	end

end
function modifier_sniper_3:DoAttackBehavior(params, hAttackAbility)
	local tProjectileInfo = {
		Target = params.target,
		Source = params.attacker,
		Ability = hAttackAbility,
		EffectName = "particles/units/heroes/hero_sniper/sniper_assassinate.vpcf",
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		iMoveSpeed = self.projectile_speed,
		bDodgeable = false,
		ExtraData = params
	}

	local tJumpInfo = self.tJumpInfos[params.record]
	if tJumpInfo.iMainRecord.record ~= params.record then
		--弹跳的子弹
		local tLast = tJumpInfo.iMainRecord
		local tCur
		for i = 1, #tJumpInfo.tJumpRecords do
			if tJumpInfo.tJumpRecords[i - 1] then
				tLast = tJumpInfo.tJumpRecords[i - 1]
			end
			tCur = tJumpInfo.tJumpRecords[i]
		end
		tProjectileInfo.Source = tLast.target
		self:GetAbility():UseResources(false, false, true)

	end

	ProjectileManager:CreateTrackingProjectile(tProjectileInfo)

	params.attacker:EmitSound("Hero_Sniper.Projection")

	--解除攻击修改
	params.attacker:SetVal(ATTRIBUTE_KIND.AttackBehavior, nil, self)
	params.attacker:SetVal(ATTRIBUTE_KIND.PhysicalCrit, nil, self)
end

function modifier_sniper_3:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	local tJumpInfo = self.tJumpInfos[tAttackInfo.record]
	if nil == tJumpInfo then return end

	local iJumpCount = 0
	if tJumpInfo.iMainRecord.record ~= tAttackInfo.record then
		iJumpCount = #tJumpInfo.tJumpRecords
	end

	--弹射递减伤害
	local fReduce = (100 - self.damage_reduce_pct) * 0.01
	fReduce = fReduce ^ iJumpCount
	for _, tDamageInfo in pairs(tAttackInfo.tDamageInfo) do
		tDamageInfo.damage = tDamageInfo.damage * fReduce
	end

	--继续弹射
	if 0 < tJumpInfo.iJumpCount then
		local tTargets = FindUnitsInRadius(tAttackInfo.attacker:GetTeamNumber(), hTarget:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if IsValid(tTargets[1]) then
			tJumpInfo.iJumpCount = tJumpInfo.iJumpCount - 1
			self.iJumpOriginRecord = tAttackInfo.record
			local iAttackState = ATTACK_STATE_NOT_USECASTATTACKORB + ATTACK_STATE_NOT_PROCESSPROCS + ATTACK_STATE_SKIPCOOLDOWN + ATTACK_STATE_IGNOREINVIS + ATTACK_STATE_NO_CLEAVE + ATTACK_STATE_NO_EXTENDATTACK + ATTACK_STATE_SKIPCOUNTING
			tAttackInfo.attacker:Attack(tTargets[1], iAttackState, {
				iMainAtkRecord = tAttackInfo.record
			})
		end
	end
end

function modifier_sniper_3:OnDeath(params)
	local tAttackInfo = GetAttackInfoByDamageRecord(params.record, self:GetParent())
	if not tAttackInfo then return end

	local tJumpInfo = self.tJumpInfos[tAttackInfo.record]
	if nil == tJumpInfo then return end

	tJumpInfo.iJumpCount = tJumpInfo.iJumpCount + 1
end

function modifier_sniper_3:OnCustomAttackRecordDestroy(params)
	if self:GetParent() == params.attacker then
		self.tJumpInfos[params.record] = nil
	end
end

function modifier_sniper_3:GetAttackCritBonus(params)
	local tJumpInfo = self.tJumpInfos[params.record]
	if nil == tJumpInfo then return end
	return	self.critical_damage, 100
end