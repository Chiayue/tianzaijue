LinkLuaModifier("modifier_base_attack", "abilities/base_attack.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
base_attack = class({}, { _base_attack = true })
function base_attack:Spawn()
	if IsServer() then
		local hCaster = self:GetCaster()
		hCaster._tBaseAttackDamageRecords = {}
		hCaster._tBaseAttackDamageRecordCheck = {
			tCheck = nil,
			tDamageRecords = nil,
		}
		self._GetKv = KeyValues.AbilitiesKv[self:GetAbilityName()]
	end
end
function base_attack:GetKv()
	return self._GetKv
end
function base_attack:GetAttackProjectile(params)
	if not self._GetAttackProjectile then
		if self:GetKv().precache then
			self._GetAttackProjectile = self:GetKv().precache.particle
		else
			self._GetAttackProjectile = self:GetCaster():GetRangedProjectileName()
		end
	end
	return self:GetCaster():GetVal(ATTRIBUTE_KIND.AttackProjectile, params) or self._GetAttackProjectile
end
function base_attack:GetAttackSound()
	if not self._GetAttackSound then
		self._GetAttackSound = self:GetKv().AttackSound
	end
	return self._GetAttackSound
end
function base_attack:GetAttackHitSound()
	if not self._GetAttackHitSound then
		self._GetAttackHitSound = self:GetKv().AttackHitSound
	end
	return self:GetCaster():GetVal(ATTRIBUTE_KIND.AttackHitSound) or self._GetAttackHitSound
end
function base_attack:GetAttackAnimation()
	if not self._GetAttackAnimation then
		local tKv = self:GetKv()
		if tKv.AbilityCastAnimation then
			self._GetAttackAnimation = _G[tKv.AbilityCastAnimation]
		end
	end
	local params = { bNeedStop = false }
	local typeAnimationOverride = self:GetCaster():GetVal(ATTRIBUTE_KIND.AttackAnimation, params)
	if not typeAnimationOverride then
		typeAnimationOverride = self._GetAttackAnimation
		params.bNeedStop = false
	end
	return typeAnimationOverride, params.bNeedStop
end
function base_attack:GetAttackAttachment(typeACT)
	if not self._GetAttackAttachment then
		self._GetAttackAttachment = { DOTA_PROJECTILE_ATTACHMENT_ATTACK_1 }
		local tKv = KeyValues.UnitsKv[self:GetCaster():GetUnitName()]
		if tKv.AttackAttachment then
			local tAttackAttachments = string.split(tKv.AttackAttachment, ' | ')
			self._GetAttackAttachment = {}
			for _, k in pairs(tAttackAttachments) do
				table.insert(self._GetAttackAttachment, _G[k])
			end
		end
	end
	if self:HasMultipleAttackAttachment() then
		if typeACT == ACT_DOTA_ATTACK2 then
			return self._GetAttackAttachment[2]
		end
	end
	return self._GetAttackAttachment[1]
end
function base_attack:HasMultipleAttackAttachment()
	if not self._HasMultipleAttackAttachment then
		self._HasMultipleAttackAttachment = false
		local tKv = KeyValues.UnitsKv[self:GetCaster():GetUnitName()]
		if tKv and tKv.AttackAttachment then
			local tAttackAttachments = string.split(tKv.AttackAttachment, ' | ')
			self._HasMultipleAttackAttachment = 0 < #tAttackAttachments
		end
	end
	return self._HasMultipleAttackAttachment
end
function base_attack:GetIntrinsicModifierName()
	return "modifier_base_attack"
end
---@param params AttackInfo
function base_attack:OnAttackRecord(params)
	local hCaster = self:GetCaster()
	if hCaster ~= params.attacker then return end
	local hTarget = params.target

	--记录攻击信息
	AddAttackInfo(params)
	self._record_last = params.record

	ATTACK_SYSTEM_DUMMY_MODIFIER:OnAttackRecord(params)
	EModifier:NotifyEvt(EMDF_EVENT_ON_ATTACK_RECORD_CREATE, params)

	--确定伤害，是否暴击等
	local damage_flags = DOTA_DAMAGE_FLAG_NONE
	if params.attacker:AttackFilter(params.record, ATTACK_STATE_NOT_CRIT) then
		damage_flags = damage_flags + DOTA_DAMAGE_FLAG_NO_SPELL_CRIT
	end
	if params.attacker:AttackFilter(params.record, ATTACK_STATE_NEVERMISS) then
		damage_flags = damage_flags + DOTA_DAMAGE_FLAG_NO_MISS
	end
	local tDamageInfo = self:GetDamageInfo({
		ability = self,
		attacker = hCaster,
		victim = hTarget,
		damage_flags = damage_flags,
	}, nil, params)
	if IsDamageCrit(tDamageInfo) then
		AttackFlagsAdd(params.record, ATTACK_STATE_CRIT)
	end

	--攻击行为
	local funcDoAtk, hBind = hCaster:GetVal(ATTRIBUTE_KIND.AttackBehavior)
	if funcDoAtk then
		params.tAttackBehavior = { funcDoAtk = funcDoAtk }
		if "table" == type(hBind) then
			params.tAttackBehavior.hBind = hBind
		end
	end

	params.tDamageInfo = tDamageInfo
	params.tDamageRecords = {}
end
function base_attack:OnAttack(params)
	local hCaster = self:GetCaster()
	if hCaster ~= params.attacker then return end
	params = GetAttackInfo(params.record, params.attacker)
	if nil == params then return end
	local hTarget = params.target

	if nil ~= self:GetAttackSound() then
		hCaster:EmitSound(self:GetAttackSound())
	end

	if params.tAttackBehavior and (not params.tAttackBehavior.hBind or IsValid(params.tAttackBehavior.hBind)) then
		--攻击行为修改
		local result
		if params.tAttackBehavior.hBind then
			result = params.tAttackBehavior.funcDoAtk(params.tAttackBehavior.hBind, params, self)
		else
			result = params.tAttackBehavior.funcDoAtk(params, self)
		end
		if type(result) == 'function' then
			params.tAttackBehavior.funcOnProjectileHit = result
			return
		elseif false == result then
			-- 忽略这次自定义攻击
			params.tAttackBehavior = nil
		else
			return
		end
	end

	--原生攻击行为
	if self:IsProjectileAttack(params) then
		--弹道攻击
		self:DoAttackBehavior(params)
	else
		--直接攻击
		if nil ~= self:GetAttackHitSound() then
			hTarget:EmitSound(self:GetAttackHitSound())
		end
	end
end
function base_attack:OnAttackLanded(params)
	local hCaster = self:GetCaster()
	if hCaster ~= params.attacker then return end
	params = GetAttackInfo(params.record, params.attacker)
	if nil == params then return end
	local hTarget = params.target

	if params.tAttackBehavior then
		--等待自定义攻击弹道结束
	else
		if self:IsProjectileAttack(params) then
			--等待自定义攻击弹道结束
		else
			--命中
			if EModifier:NotifyEvt(EMDF_EVENT_ON_ATTACK_HIT, hTarget, params) == true then
				return
			end
			--伤害
			self:OnDamage(hTarget, params)
		end
	end
end
function base_attack:OnAttackFail(params)
	local hCaster = self:GetCaster()
	if hCaster ~= params.attacker then return end
	params = GetAttackInfo(params.record, params.attacker)
	if nil == params then return end
	local hTarget = params.target

	--miss
	if not AttackFilter(params.record, ATTACK_STATE_NEVERMISS) then
		for typeDamage, tDamageData in pairs(params.tDamageInfo) do
			tDamageData.damage_flags = bit.bor(DOTA_DAMAGE_FLAG_MISS, tDamageData.damage_flags)
			tDamageData.damage = 0
		end
	end

	if params.tAttackBehavior then
		--等待自定义攻击弹道结束
	else
		if self:IsProjectileAttack(params) then
			--等待自定义攻击弹道结束
		else
			--命中
			EModifier:NotifyEvt(EMDF_EVENT_ON_ATTACK_HIT, hTarget, params)
		end
	end
end
function base_attack:OnAttackRecordDestroy(params)
	local hCaster = self:GetCaster()
	if hCaster ~= params.attacker then return end
	params = GetAttackInfo(params.record, params.attacker)
	if nil == params then return end

	if params.tAttackBehavior then
		--等待自定义攻击弹道结束
	else
		if self:IsProjectileAttack(params) then
			--等待自定义攻击弹道结束
		else
			DelAttackInfo(params.record)
		end
	end
end
function base_attack:OnAttackCancelled(params)
	-- 攻击被取消，删除上一次的攻击record
	DelAttackInfo(self._record_last)
end
--造成伤害
function base_attack:OnDamage(hTarget, params)
	local hCaster = self:GetCaster()
	hCaster._tBaseAttackDamageRecordCheck.tDamageRecords = params.tDamageRecords

	if params.tDamageInfo then
		for _, tData in pairs(params.tDamageInfo) do
			if 0 < tData.damage then
				tData.victim = hTarget

				hCaster._tBaseAttackDamageRecordCheck.tCheck = {
					original_damage	= tData.damage,
					damage_type	= tData.damage_type,
					target = hTarget,
					attack_record = params.record,
				}

				ApplyDamage(tData)
				hCaster._tBaseAttackDamageRecordCheck.tCheck = nil
			end
		end
	end
end

--进行弹道攻击
function base_attack:DoAttackBehavior(params)
	local hCaster = self:GetCaster()
	local hTarget = params.target

	local speed = self:GetSpecialValueFor("speed")
	if speed <= 0 then speed = hCaster:GetProjectileSpeed() end

	local info = {
		EffectName = self:GetAttackProjectile(params),
		Ability = self,
		iMoveSpeed = speed,
		Source = hCaster,
		Target = hTarget,
		iSourceAttachment = self:GetAttackAttachment(hCaster._typeACT),
		bDodgeable = true,
		bRebound = true, --支持弹道反弹
		ExtraData = {
			record = params.record
		}
	}

	ProjectileManager:CreateTrackingProjectile(info)
end
--弹道触碰回调
function base_attack:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	local params = GetAttackInfo(ExtraData.record, self:GetCaster())
	if not params then return end

	if params.tAttackBehavior and params.tAttackBehavior.funcOnProjectileHit then
		--攻击行为修改后的弹道命中回调
		if params.tAttackBehavior.hBind then
			return params.tAttackBehavior.funcOnProjectileHit(params.tAttackBehavior.hBind, hTarget, vLocation, ExtraData, self)
		else
			return params.tAttackBehavior.funcOnProjectileHit(hTarget, vLocation, ExtraData, self)
		end
	else
		if IsValid(hTarget) then
			--命中单位
			if nil ~= self:GetAttackHitSound() then
				hTarget:EmitSound(self:GetAttackHitSound())
			end
			self:OnDamage(hTarget, params)
		end
		--结束删除record
		DelAttackInfo(ExtraData.record)
	end
end
--弹道攻击结束
function base_attack:OnProjectileEnd(hTarget, vLocation, ExtraData)
	DelAttackInfo(ExtraData.record)
end
---@param tAttackInfo AttackInfo
function base_attack:IsProjectileAttack(tAttackInfo)
	if AttackFilter(tAttackInfo.record, ATTACK_STATE_NOT_USEPROJECTILE) then
		return false
	end
	local hCaster = self:GetCaster()
	if hCaster:IsRangedAttacker() and nil ~= self:GetAttackProjectile() then
		return true
	end
	return false
end

---------------------------------------------------------------------
--Modifiers
if modifier_base_attack == nil then
	modifier_base_attack = class({}, nil, eom_modifier)
end
function modifier_base_attack:constructor()
	if self.OnCreated ~= modifier_base_attack.OnCreated then
		eom_modifier.constructor(self)
		local _OnCreated = self.OnCreated
		self.OnCreated = function(...)
			modifier_base_attack.OnCreated(...)
			return _OnCreated(...)
		end
	else
		eom_modifier.constructor(self)
	end
end
function modifier_base_attack:OnCreated(params)
	if IsServer() then
		self.records = {}
		self.records_OnAtkCheck = {}
	end
end
function modifier_base_attack:IsHidden()
	return true
end
function modifier_base_attack:CheckState()
	return {
	-- [MODIFIER_STATE_CANNOT_MISS] = true,
	}
end
function modifier_base_attack:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS
	}
end
function modifier_base_attack:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK_CANCELLED] = { self:GetParent() },
		[MODIFIER_EVENT_ON_ATTACK_RECORD] = { self:GetParent() },
		[MODIFIER_EVENT_ON_ATTACK_START] = { self:GetParent() },
		[MODIFIER_EVENT_ON_ATTACK] = { self:GetParent() },
		[MODIFIER_EVENT_ON_ATTACK_LANDED] = { self:GetParent() },
		[MODIFIER_EVENT_ON_ATTACK_FAIL] = { self:GetParent() },
		[MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY] = { self:GetParent() },
		-- 增加远程单位攻击大碰撞单位的攻击范围
		EMDF_ATTACK_RANGE_BONUS
	}
end
function modifier_base_attack:GetAttackRangeBonus(params)
	if IsServer() then
		local hParent = self:GetParent()
		if hParent:IsRangedAttacker() and
		hParent.hAttackTarget ~= nil and
		IsValid(hParent.hAttackTarget) and
		hParent.hAttackTarget:IsAlive() and
		not hParent.hAttackTarget:IsAttackImmune() and
		not hParent.hAttackTarget:IsInvulnerable()
		then
			return hParent.hAttackTarget:GetHullRadius()
		end
	end
end
function modifier_base_attack:GetModifierCastRangeBonus(params)
	return self:GetAttackRangeBonus(params)
end
function modifier_base_attack:GetModifierProjectileName(params)
	return ' '
end
function modifier_base_attack:GetModifierDamageOutgoing_Percentage(params)
	if params.attacker ~= self:GetParent() or params.target == nil or params.target:GetClassname() == "dota_item_drop" then
		return
	end
	if TableFindKey(self.records, params.record) ~= nil then
		return -1000
	end
end
function modifier_base_attack:GetModifierTotalDamageOutgoing_Percentage(params)
	if params.attacker ~= self:GetParent()
	or params.inflictor ~= self:GetAbility()
	then return end

	--匹配并记录攻击伤害信息
	local tCheck = params.attacker._tBaseAttackDamageRecordCheck.tCheck
	if not tCheck then return end

	if tCheck.target:GetEntityIndex() == params.target:GetEntityIndex() then
		if	tCheck.damage_type == params.damage_type then
			if	1 >= math.abs(tCheck.original_damage - params.original_damage) then
				params.attack_record = tCheck.attack_record
				params.attacker._tBaseAttackDamageRecordCheck.tDamageRecords[params.record] = params
				params.attacker._tBaseAttackDamageRecords[params.record] = params
				return
			end
			print('check damage record info error 3 : ' .. tCheck.original_damage .. " " .. params.original_damage)
		end
		print('check damage record info error 2 : ' .. tCheck.damage_type .. " " .. params.damage_type)
	end
	print('check damage record info error 1 : ' .. params.attacker:GetUnitName() .. ' ' .. tCheck.target:GetUnitName() .. " " .. params.target:GetUnitName() .. tCheck.target:GetEntityIndex() .. " " .. params.target:GetEntityIndex())
end
function modifier_base_attack:OnAttackCancelled(params)
	if params.target == nil or params.target:GetClassname() == "dota_item_drop" then
		return
	end
	if params.attacker == self:GetParent() then
		self:GetAbility():OnAttackCancelled(params)

		-- 取消攻击动作
		if self:GetAbility():HasMultipleAttackAttachment() then
			if params.attacker._typeACT then
				params.attacker:FadeGesture(params.attacker._typeACT)
			end
		end
	end
end
function modifier_base_attack:OnAttackStart(params)
	if params.target == nil or params.target:GetClassname() == "dota_item_drop" then
		return
	end
	if params.attacker == self:GetParent() then
		if self:GetAbility():HasMultipleAttackAttachment() then
			---不同动作弹道起始点控制
			if params.attacker._typeACT then
				params.attacker:FadeGesture(params.attacker._typeACT)
			end
			local fRate = params.attacker:GetVal(ATTRIBUTE_KIND.AttackAnimationRate) or params.attacker:GetAttackSpeed()
			-- params.attacker._typeACT = ACT_DOTA_ATTACK == params.attacker._typeACT and ACT_DOTA_ATTACK2 or ACT_DOTA_ATTACK
			params.attacker._typeACT = RandomInt(1, 2) == 1 and ACT_DOTA_ATTACK or ACT_DOTA_ATTACK2
			params.attacker:StartGestureWithPlaybackRate(params.attacker._typeACT, fRate)
		end
	end
end
function modifier_base_attack:OnAttackRecord(params)
	if params.target == nil or params.target:GetClassname() == "dota_item_drop" then
		return
	end

	if params.attacker == self:GetParent() then
		table.insert(self.records, params.record)
		self.records_OnAtkCheck[params.record] = true

		--自定义攻击
		self:GetAbility():OnAttackRecord(params)

		local fRate = params.attacker:GetVal(ATTRIBUTE_KIND.AttackAnimationRate) or params.attacker:GetAttackSpeed()
		local animation, bNeedStop = self:GetAbility():GetAttackAnimation()
		if animation then
			self.animation = animation
			self.animation_need_stop = bNeedStop
			self.animation_record = DecodeAttackRecord(params.record)

			params.attacker:StartGestureWithPlaybackRate(self.animation, fRate)
		elseif IsAttackCrit(params.record) then
			params.attacker:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK_EVENT, fRate)
		else
			-- ACT_DOTA_ATTACK
			-- ACT_DOTA_ATTACK2
			-- params.attacker:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, fRate)
		end
	end
end
function modifier_base_attack:OnAttack(params)
	if params.target == nil or params.target:GetClassname() == "dota_item_drop" then
		return
	end
	if params.attacker == self:GetParent() then
		if TableFindKey(self.records, params.record) ~= nil then
			self.records_OnAtkCheck[params.record] = nil

			if self.animation and self.animation_need_stop and params.record == self.animation_record then
				params.attacker:FadeGesture(self.animation)
				self.animation = nil
			end

			self:GetAbility():UseResources(true, true, true)
			--自定义攻击
			self:GetAbility():OnAttack(params)
		end
	end
end
function modifier_base_attack:OnAttackLanded(params)
	if params.target == nil or params.target:GetClassname() == "dota_item_drop" then
		return
	end
	if params.attacker == self:GetParent() then
		if TableFindKey(self.records, params.record) ~= nil then
			--自定义攻击
			self:GetAbility():OnAttackLanded(params)
		end
	end
end
function modifier_base_attack:OnAttackFail(params)
	if params.target == nil or params.target:GetClassname() == "dota_item_drop" then
		return
	end
	if params.attacker == self:GetParent() then
		if TableFindKey(self.records, params.record) ~= nil then
			--自定义攻击
			self:GetAbility():OnAttackFail(params)
		end
	end
end
function modifier_base_attack:OnAttackRecordDestroy(params)
	if params.target == nil or params.target:GetClassname() == "dota_item_drop" then
		return
	end
	if params.attacker == self:GetParent() then
		if TableFindKey(self.records, params.record) ~= nil then
			ArrayRemove(self.records, params.record)

			if self.records_OnAtkCheck[params.record] then
				--攻击被中断（未进入过OnAttack）
				self.records_OnAtkCheck[params.record] = nil
				if self.animation and params.record == self.animation_record then
					params.attacker:FadeGesture(self.animation)
					self.animation = nil
				end
			end

			--自定义攻击
			self:GetAbility():OnAttackRecordDestroy(params)
		end
	end
end

local env = getfenv(1)
if env ~= _G then
	local public = base_attack
	local metatable = getmetatable(env)
	local globals = _G
	local Kv = globals.KeyValues.AbilitiesKv
	local strfind = string.find
	local ExtendInstance = ExtendInstance

	metatable.__index = function(t, key)
		if key == "ExtendInstance" then
			return ExtendInstance
		end
		-- if strfind(key, "base_attack_") ~= nil then
		if Kv[key] and Kv[key].ScriptFile and strfind(Kv[key].ScriptFile, "base_attack") ~= nil then
			return public
		end
		return globals[key]
	end
end