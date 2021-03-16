LinkLuaModifier("modifier_luna_1", "abilities/tower/luna/luna_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_luna_1_debuff", "abilities/tower/luna/luna_1.lua", LUA_MODIFIER_MOTION_NONE)
if luna_1 == nil then
	luna_1 = class({})
end
function luna_1:Spawn()
	if IsServer() then
		if not luna_1.tTinkers then
			luna_1.tTinkers = {}
			EventManager:register(ET_BATTLE.ON_BATTLEING_END, function()
				for i = #luna_1.tTinkers, 1, -1 do
					local hTinker = luna_1.tTinkers[i]
					if IsValid(hTinker) then
						ParticleManager:DestroyParticle(hTinker.iPtclID, true)
						hTinker:ForceKill(false)
						hTinker:RemoveSelf()
						table.remove(luna_1.tTinkers)
					end
				end
			end, 'luna_1_thinker_del')
		end
		self.tTinkers = luna_1.tTinkers
	end
end
---发射一个攻击n次的月影环刃
function luna_1:Fire(hTarget, tAttackInfo, hAttackAbility, iCount)
	if IsValid(hTarget) and 0 < self:GetLevel() then
		local fDuration = self:GetSpecialValueFor('once_duration')
		hTarget:AddNewModifier(self:GetCaster(), self, 'modifier_luna_1_debuff', {
			duration = fDuration * iCount,
			count = iCount,
			attack_record = tAttackInfo.record,
			base_attack_entid = hAttackAbility:GetEntityIndex(),
		})
	end
end
function luna_1:_GetMoonThinker()
	local hTinker
	for i = #self.tTinkers, 1, -1 do
		hTinker = self.tTinkers[i]
		if IsValid(hTinker) then
			if not hTinker.bEnable then
				hTinker.bEnable = true
				break
			end
		else
			table.remove(self.tTinkers, i)
		end
		hTinker = nil
	end
	if not hTinker then
		hTinker = CreateModifierThinker(self:GetCaster(), nil, "modifier_dummy", {}, Vector(0, 0, 0), DOTA_TEAM_NOTEAM, false)
		table.insert(self.tTinkers, hTinker)
		hTinker.iPtclID = ParticleManager:CreateParticle("particles/units/heroes/luna/luna_2_moon.vpcf", PATTACH_CUSTOMORIGIN, hTinker)
		ParticleManager:SetParticleControlEnt(hTinker.iPtclID, 0, hTinker, PATTACH_POINT_FOLLOW, "attach_hitloc", hTinker:GetAbsOrigin(), false)
	end
	hTinker.bEnable = true
	hTinker:GameTimer('RemoveNoDraw', 0, function()
		if hTinker.bEnable then
			hTinker:RemoveNoDraw()
		end
	end)
	return hTinker
end
function luna_1:_SetMoonThinker(hTinker)
	if IsValid(hTinker) then
		hTinker.bEnable = nil
		hTinker:AddNoDraw()
		hTinker:SetParent(nil, '')
	end
end
function luna_1:GetIntrinsicModifierName()
	return "modifier_luna_1"
end

---------------------------------------------------------------------
--Modifiers
if modifier_luna_1 == nil then
	modifier_luna_1 = class({}, nil, eom_modifier)
end
function modifier_luna_1:IsHidden()
	return true
end
function modifier_luna_1:OnCreated(params)
	self.count = self:GetAbilitySpecialValueFor("count")
	self.range = self:GetAbilitySpecialValueFor("range")
	self.damage_add_per = self:GetAbilitySpecialValueFor("damage_add_per")
	if IsServer() then
		self.tJumpInfos = {}
	end
end
function modifier_luna_1:OnRefresh(params)
	self.count = self:GetAbilitySpecialValueFor("count")
	self.range = self:GetAbilitySpecialValueFor("range")
	self.damage_add_per = self:GetAbilitySpecialValueFor("damage_add_per")
end
function modifier_luna_1:EDeclareFunctions()
	return {
		EMDF_DO_ATTACK_BEHAVIOR,
		EMDF_EVENT_ON_ATTACK_HIT,
	}
end
function modifier_luna_1:DoAttackBehavior(tAttackInfo, hAttackAbility)
	local tProjectileInfo = {
		Target = tAttackInfo.target,
		Source = tAttackInfo.attacker,
		Ability = hAttackAbility,
		EffectName = hAttackAbility:GetAttackProjectile(),
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		iMoveSpeed = self:GetParent():GetProjectileSpeed(),
		bDodgeable = false,
		ExtraData = {
			record = tAttackInfo.record,
			iMoveSpeed = self:GetParent():GetProjectileSpeed(),
		}
	}
	ProjectileManager:CreateTrackingProjectile(tProjectileInfo)

	self.tJumpInfos[tAttackInfo.record] = {
		iCount = 0,
		tDamageAdd = {},
	}

	return self.OnProjectileHit
end
function modifier_luna_1:OnProjectileHit(hTarget, vLocation, ExtraData, hAttackAbility)
	local tAttackInfo = GetAttackInfo(ExtraData.record, hAttackAbility:GetCaster())

	if nil == hTarget then
	else
		--命中单位
		if nil ~= hAttackAbility:GetAttackHitSound() then
			hTarget:EmitSound(hAttackAbility:GetAttackHitSound())
		end

		--伤害
		hAttackAbility:OnDamage(hTarget, tAttackInfo)

		local tJumpInfo = self.tJumpInfos[tAttackInfo.record]
		if self.count > tJumpInfo.iCount then
			--继续弹射
			local tTargets = FindUnitsInRadius(tAttackInfo.attacker:GetTeamNumber(), hTarget:GetAbsOrigin(), nil, self.range,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)
			remove(tTargets, hTarget)

			if 0 < #tTargets then
				local tResult = FindAll(tTargets, function(hUnit) return hUnit:IsRangedAttacker() end)
				if 0 < #tResult then
					--远程优先
					tTargets = {}
					for _, v in pairs(tResult) do
						table.insert(tTargets, v.value)
					end
				end

				local hTarget2 = tTargets[RandomInt(1, #tTargets)]
				tJumpInfo.iCount = tJumpInfo.iCount + 1
				local tProjectileInfo = {
					Target = hTarget2,
					Source = hTarget,
					Ability = hAttackAbility,
					EffectName = hAttackAbility:GetAttackProjectile(),
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
					iMoveSpeed = ExtraData.iMoveSpeed,
					bDodgeable = false,
					ExtraData = {
						record = tAttackInfo.record,
						iMoveSpeed = ExtraData.iMoveSpeed,
					}
				}
				ProjectileManager:CreateTrackingProjectile(tProjectileInfo)
				return
			else
				---没有其他目标，以二技能的环形月刃继续攻击伤害最后的目标
				if hTarget:IsAlive() and IsValid(tAttackInfo.attacker) and IsValid(self) and IsValid(self:GetAbility()) then
					self:GetAbility():Fire(hTarget, tAttackInfo, hAttackAbility, self.count - tJumpInfo.iCount)
					self.tJumpInfos[tAttackInfo.record] = nil
					return
				end
			end
		end
	end

	DelAttackInfo(tAttackInfo.record)
	self.tJumpInfos[tAttackInfo.record] = nil
end
function modifier_luna_1:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	-- if IsAttackMiss(tAttackInfo) then return end
	--
	local tJumpInfo = self.tJumpInfos[tAttackInfo.record]
	if nil == tJumpInfo then return end

	--弹射递增伤害
	for typeDamage, tDamageInfo in pairs(tAttackInfo.tDamageInfo) do
		if tJumpInfo.tDamageAdd[typeDamage] then
			tDamageInfo.damage = tDamageInfo.damage - tJumpInfo.tDamageAdd[typeDamage]
		end
		tJumpInfo.tDamageAdd[typeDamage] = tDamageInfo.damage * tJumpInfo.iCount * self.damage_add_per * 0.01
		tDamageInfo.damage = tDamageInfo.damage + tJumpInfo.tDamageAdd[typeDamage]
	end
end
--Modifiers
if modifier_luna_1_debuff == nil then
	modifier_luna_1_debuff = class({}, nil, eom_modifier)
end
function modifier_luna_1_debuff:IsHidden()
	return true
end
function modifier_luna_1_debuff:OnCreated(params)
	if IsServer() then
		self.iCount = params.count
		self.fOnceDuration = self:GetAbilitySpecialValueFor('once_duration')
		self.tAttackInfo = GetAttackInfo(params.attack_record, self:GetCaster())
		self.hAttackAbility = EntIndexToHScript(params.base_attack_entid)

		local hParent = self:GetParent()
		local hAblt = self:GetAbility()

		self.hTinker = hAblt:_GetMoonThinker()
		local hTinker = self.hTinker
		hTinker:SetParent(hParent, '')


		local vPos = RandomVector(hParent:GetModelRadius() / 2 / hParent:GetModelScale() * 1.5)
		vPos.z = (128 + RandomFloat(-hParent:GetModelRadius() / 2, hParent:GetModelRadius() / 2)) / hParent:GetModelScale()
		-- local vPosHit = hParent:GetAttachmentOrigin(DOTA_PROJECTILE_ATTACHMENT_HITLOCATION)
		-- vPos.z = vPosHit.z / hParent:GetModelScale()
		hTinker:SetLocalOrigin(vPos)
		hTinker.vVertical = CalculateVerticalVector(hTinker:GetLocalOrigin())
		hTinker.iRotationDir = 1

		-- 第一次伤害间隔
		self.fDamageInterval = GameRules:GetGameTime() + self.fOnceDuration * 0.5

		self:OnIntervalThink()
		self:StartIntervalThink(0)
	end
end
function modifier_luna_1_debuff:OnDestroy()
	if IsServer() then
		local hAblt = self:GetAbility()
		if IsValid(hAblt) and IsValid(self:GetCaster()) then
			hAblt:_SetMoonThinker(self.hTinker)
		end

		---删除攻击record
		DelAttackInfo(self.tAttackInfo.record)
	end
end
function modifier_luna_1_debuff:OnIntervalThink()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()

	local hTinker = self.hTinker
	local vPos = hTinker:GetLocalOrigin()
	local z = vPos.z
	vPos.z = 0

	local fAgeSpeed = (180 / (30 * self.fOnceDuration))
	vPos = RotatePosition(Vector(0, 0, 0), QAngle(0, fAgeSpeed * hTinker.iRotationDir, 0), vPos)
	vPos.z = z
	hTinker:SetLocalOrigin(vPos)

	-- DebugDrawLine(v1, v2, 255, 255, 255, true, 1)
	-- 伤害
	if self.fDamageInterval <= GameRules:GetGameTime() then
		if IsValid(hCaster) and IsValid(self.hAttackAbility) then

			local iParticle = ParticleManager:CreateParticle("particles/units/heroes/luna/luna_2_damage.vpcf", PATTACH_CUSTOMORIGIN, nil)
			local vPosPtcl = hParent:GetAbsOrigin()
			vPosPtcl.z = hTinker:GetAbsOrigin().z
			ParticleManager:SetParticleControl(iParticle, 0, vPosPtcl)
			self.iDamagePtclDir = (self.iDamagePtclDir or -1) * -1
			ParticleManager:SetParticleControlOrientation(iParticle, 0, Vector(0, 0, -1), Vector(0, 1 * self.iDamagePtclDir, 0), Vector(-1 * self.iDamagePtclDir, 0, 0))
			ParticleManager:SetParticleControl(iParticle, 1, Vector(hParent:GetModelRadius(), 0, 0))
			ParticleManager:ReleaseParticleIndex(iParticle)

			-- hParent:EmitSound("Hero_Riki.Backstab")
			if nil ~= self.hAttackAbility:GetAttackHitSound() then
				hParent:EmitSound(self.hAttackAbility:GetAttackHitSound())
			end

			--攻击
			EModifier:NotifyEvt(EMDF_EVENT_ON_ATTACK_HIT, hParent, self.tAttackInfo)
			self.hAttackAbility:OnDamage(hParent, self.tAttackInfo)

			-- 下次伤害间隔
			self.fDamageInterval = GameRules:GetGameTime() + self.fOnceDuration
		end
	end
end
function modifier_luna_1_debuff:EDeclareFunctions()
	return {
	}
end
function modifier_luna_1_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end