LinkLuaModifier("modifier_void_spirit_2", "abilities/tower/void_spirit/void_spirit_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_2_debuff", "abilities/tower/void_spirit/void_spirit_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities:普攻触发太虚直径
if void_spirit_2 == nil then
	void_spirit_2 = class({})
end
function void_spirit_2:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("distance")
end
function void_spirit_2:GetIntrinsicModifierName()
	return "modifier_void_spirit_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_void_spirit_2 == nil then
	modifier_void_spirit_2 = class({}, nil, eom_modifier)
end
function modifier_void_spirit_2:OnCreated(params)
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.width = self:GetAbilitySpecialValueFor("width")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.atk_factor = self:GetAbilitySpecialValueFor("atk_factor")
	if IsServer() then
		self.tRecords = {}
	end
end
function modifier_void_spirit_2:OnRefresh(params)
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.width = self:GetAbilitySpecialValueFor("width")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.atk_factor = self:GetAbilitySpecialValueFor("atk_factor")
	if IsServer() then
	end
end
function modifier_void_spirit_2:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_RECORD_CREATE,
		EMDF_EVENT_ON_ATTACK_RECORD_DESTROY,
		EMDF_DO_ATTACK_BEHAVIOR,
		[MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY] = { self:GetParent() },
	}
end
function modifier_void_spirit_2:OnCustomAttackRecordCreate(params)
	if self:GetParent():HasAttackCapability() and not self:GetParent():IsDisarmed() then
		table.insert(self.tRecords, params.record)
		-- self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2, (0.36 / self:GetParent():GetAttackAnimationPoint()) * 100)
	end
end
function modifier_void_spirit_2:OnCustomAttackRecordDestroy(params)
	if TableFindKey(self.tRecords, params.record) then
		-- self:GetParent():RemoveGesture(ACT_DOTA_CAST_ABILITY_2)
	end
end
function modifier_void_spirit_2:DoAttackBehavior(tAttackInfo, hAttackAbility)
	local hParent = self:GetParent()
	local hTarget = tAttackInfo.target
	local hAbility = self:GetAbility()
	if TableFindKey(self.tRecords, tAttackInfo.record) then
		local vPosition = hTarget:GetAbsOrigin()
		local vDirection = (vPosition - hParent:GetAbsOrigin()):Normalized()
		local vStart = hParent:GetAbsOrigin() + vDirection * self.width
		local vEnd = hParent:GetAbsOrigin() + vDirection * (self.distance - self.width)
		local tTargets = FindUnitsInLineWithAbility(hParent, vStart, vEnd, self.width, hAbility)

		-- 幻象的来源者
		local hSource = IsValid(hParent.hSource) and hParent.hSource or hParent

		for iDamageType, tDamageInfo in pairs(tAttackInfo.tDamageInfo) do
			-- 如果是近战
			if iDamageType == DAMAGE_TYPE_MAGICAL then
				tDamageInfo.damage = tDamageInfo.damage * self.atk_factor * 0.01
			end
		end
		for _, hUnit in ipairs(tTargets) do
			-- 命中
			EModifier:NotifyEvt(EMDF_EVENT_ON_ATTACK_HIT, hUnit, tAttackInfo)
			-- 伤害
			hAttackAbility:OnDamage(hUnit, tAttackInfo)
			-- 标记
			hUnit:AddNewModifier(hSource, hAbility, "modifier_void_spirit_2_debuff", { duration = self.duration })
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_impact.vpcf", PATTACH_ABSORIGIN, hUnit)
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/void_spirit/void_spirit_2.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControlForward(iParticleID, 0, vDirection)
		ParticleManager:SetParticleControl(iParticleID, 1, hParent:GetAbsOrigin() + vDirection * self.distance)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		-- sound
		hParent:EmitSound("Hero_VoidSpirit.AstralStep.Start")
	else
		return false
	end
end
function modifier_void_spirit_2:OnAttackRecordDestroy(params)
	local hCaster = self:GetCaster()
	if hCaster ~= params.attacker then return end
	params = GetAttackInfo(params.record, hCaster)
	if nil == params then return end
	DelAttackInfo(params.record)
end
function modifier_void_spirit_2:IsHidden()
	return true
end
---------------------------------------------------------------------
if modifier_void_spirit_2_debuff == nil then
	modifier_void_spirit_2_debuff = class({}, nil, eom_modifier)
end
function modifier_void_spirit_2_debuff:IsDebuff()
	return true
end
function modifier_void_spirit_2_debuff:OnCreated(params)
	self.sign_factor = self:GetAbilitySpecialValueFor("sign_factor")
	self.explode_sign_factor = self:GetAbilitySpecialValueFor("explode_sign_factor")
	if IsServer() then
		self.tData = {}

		table.insert(self.tData, {
			fDieTime = self:GetDieTime(),
			hAbility = self:GetAbility(),
		})
		self:IncrementStackCount()

		self:StartIntervalThink(0)
	end
end
function modifier_void_spirit_2_debuff:OnRefresh(params)
	self.sign_factor = self:GetAbilitySpecialValueFor("sign_factor")
	self.explode_sign_factor = self:GetAbilitySpecialValueFor("explode_sign_factor")
	if IsServer() then
		table.insert(self.tData, {
			fDieTime = self:GetDieTime(),
			hAbility = self:GetAbility(),
		})
		self:IncrementStackCount()
	end
end
function modifier_void_spirit_2_debuff:OnIntervalThink()
	if IsServer() then
		local hCaster = self:GetCaster()
		if not IsValid(hCaster) then
			self:Destroy()
			return
		end
		local hParent = self:GetParent()

		local fGameTime = GameRules:GetGameTime()
		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].fDieTime then
				self:DecrementStackCount()

				local hAbility = self.tData[i].hAbility

				if IsValid(hAbility) then
					hCaster:DealDamage(hParent, hAbility, hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) * self.sign_factor * 0.01)
				end

				local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_dmg_burst.vpcf", PATTACH_CUSTOMORIGIN, hParent)
				ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(iParticleID)

				table.remove(self.tData, i)
			end
		end
	end
end
function modifier_void_spirit_2_debuff:Explode()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hAbility = self:GetAbility()
		if not IsValid(hAbility) then
			hAbility = hCaster.FindAbilityByName("void_spirit_2")
		end
		if not IsValid(hCaster) or not IsValid(hAbility) then
			self:Destroy()
			return
		end
		local hParent = self:GetParent()

		local iStackCount = self:GetStackCount()
		local flDamage = iStackCount * hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) * self.explode_sign_factor * 0.01
		hCaster:DealDamage(hParent, hAbility, flDamage)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_dmg.vpcf", PATTACH_CUSTOMORIGIN, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(iParticleID)

		self:Destroy()
	end
end