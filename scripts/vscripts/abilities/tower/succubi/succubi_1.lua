LinkLuaModifier("modifier_succubi_1_shadow_strike", "abilities/tower/succubi/succubi_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_succubi_1_shadow_strike_thinker", "abilities/tower/succubi/succubi_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_succubi_1_shadow_strike_debuff", "abilities/tower/succubi/succubi_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if succubi_1 == nil then
	succubi_1 = class({}, nil, ability_base_ai)
end
function succubi_1:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function succubi_1:OnSpellStart()

	local hCaster = self:GetCaster()
	local vPos = hCaster:GetAbsOrigin()
	local strike_count = self:GetSpecialValueFor("strike_count")
	local strike_damage_pct = self:GetSpecialValueFor("strike_damage_pct")
	local strike_dmg_persecond = self:GetSpecialValueFor("strike_dmg_persecond")
	local strike_interval = self:GetSpecialValueFor("strike_interval")
	local duration = strike_interval * strike_count

	hCaster:AddNewModifier(hCaster, self, "modifier_succubi_1_shadow_strike", { duration = duration })

end

---------------------------------------------------------------------
--自身毒镖buff
if modifier_succubi_1_shadow_strike == nil then
	modifier_succubi_1_shadow_strike = class({}, nil, eom_modifier)
end

function modifier_succubi_1_shadow_strike:OnCreated(params)
	local strike_interval = self:GetAbilitySpecialValueFor("strike_interval")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self:StartIntervalThink(strike_interval)
	end
end

function modifier_succubi_1_shadow_strike:OnRefresh(params)
	local strike_interval = self:GetAbilitySpecialValueFor("strike_interval")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end


function modifier_succubi_1_shadow_strike:OnDestroy()
	if IsServer() then
	end
end

function modifier_succubi_1_shadow_strike:OnIntervalThink()
	local hAbility = self:GetAbility()
	local hParent = self:GetParent()
	if IsServer() then
		local vPosition = hParent:GetAbsOrigin()
		local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), vPosition, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		local hTarget = tTargets[RandomInt(1, #tTargets)]
		if IsValid(hTarget) then

			local vStart = hParent:GetAttachmentOrigin(hParent:ScriptLookupAttachment("attach_attack1"))
			CreateModifierThinker(hParent, hAbility, "modifier_succubi_1_shadow_strike_thinker", { target_index = hTarget:entindex() }, vStart, hTarget:GetTeamNumber(), false)

			hParent:EmitSound("Hero_QueenOfPain.ShadowStrike.Target.TI8")
		end
	end
end

function modifier_succubi_1_shadow_strike:IsHidden()
	return true
end

---------------------------------------------------------------------
--thinker
if modifier_succubi_1_shadow_strike_thinker == nil then
	modifier_succubi_1_shadow_strike_thinker = class({}, nil, eom_modifier)
end

function modifier_succubi_1_shadow_strike_thinker:OnCreated(params)
	-- self.missile_damage = self:GetAbilitySpecialValueFor("missile_damage")
	self.missile_speed = 1500
	self.strike_damage_pct = self:GetAbilitySpecialValueFor("strike_damage_pct")

	-- self.min_missile_travel_time = self:GetAbilitySpecialValueFor("min_missile_travel_time")
	if IsServer() then
		self.hTarget = EntIndexToHScript(params.target_index)
		if not IsValid(self.hTarget) then
			self:Destroy()
			return
		end
		-- 马甲本身
		local hParent = self:GetParent()

		-- 女王
		local hCaster = self:GetCaster()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/succubi/succubi_1_shadow_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 3, hParent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)

		self:AddParticle(iParticleID, false, false, -1, false, false)

		self.vStartPosition = hParent:GetAbsOrigin()
		self.vTargetPosition = self.hTarget:GetAttachmentOrigin(self.hTarget:ScriptLookupAttachment("attach_hitloc"))
		local vDirection = self.vTargetPosition - self.vStartPosition
		self.vOffset = self.vStartPosition + 1 * vDirection:Length2D() * RotatePosition(Vector(0, 0, 0), QAngle(RandomFloat(-180, 0), RandomFloat(1, 0) * 180, 0), Vector(1, 0, 0))
		-- DebugDrawCircle(self.vOffset, Vector(0, 255, 0), 255, 32, true, 1)
		self.fStartTime = GameRules:GetGameTime()


		self:StartIntervalThink(0)

		-- hParent:SetAbsOrigin(self.hTarget:GetAbsOrigin())
	end
end

function modifier_succubi_1_shadow_strike_thinker:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local fTime = GameRules:GetGameTime() - self.fStartTime

		if IsValid(self.hTarget) and self.hTarget:IsAlive() then
			self.vTargetPosition = CalcClosestPointOnEntityOBB(self.hTarget, self.vStartPosition)
			self.vTargetPosition.z = self.hTarget:GetAttachmentOrigin(self.hTarget:ScriptLookupAttachment("attach_hitloc")).z
		end

		local vDirection = self.vTargetPosition - self.vStartPosition
		local fProgress = Clamp((self.missile_speed * fTime) / vDirection:Length2D(), 0, 1)
		local vStart = hParent:GetAbsOrigin()
		local vEnd = Bessel(fProgress, self.vStartPosition, self.vOffset, self.vTargetPosition)

		hParent:SetAbsOrigin(vEnd)
		hParent:SetForwardVector((vEnd - vStart):Normalized())
		if fProgress >= 1 then
			self:Destroy()
		end
	end
end

function modifier_succubi_1_shadow_strike_thinker:OnDestroy()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hAbility = self:GetAbility()
		local hParent = self:GetParent()
		UTIL_Remove(self:GetParent())

		if IsValid(self.hTarget) then
			if IsValid(hAbility) and IsValid(hCaster) then
				if UnitFilter(self.hTarget, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, hCaster:GetTeamNumber()) == UF_SUCCESS then
					ApplyDamage({
						ability = hAbility,
						victim = self.hTarget,
						attacker = hCaster,
						damage = self.strike_damage_pct * hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) * 0.01,
						damage_type = hAbility:GetAbilityDamageType()
					})
					-- SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, self:GetParent(), fDamage, self:GetCaster())
					-- self.hTarget:AddNewModifier(hCaster, hAbility, "modifier_succubi_1_shadow_strike_debuff", {})
					self.hTarget:AddBuff(hCaster, BUFF_TYPE.POISON)
				end
			end
		end
	end
end

---------------------------------------------------------------------
--毒镖debuff
if modifier_succubi_1_shadow_strike_debuff == nil then
	modifier_succubi_1_shadow_strike_debuff = class({}, nil, eom_modifier)
end

function modifier_succubi_1_shadow_strike_debuff:OnCreated(params)
	self.strike_dmg_persecond = self:GetAbilitySpecialValueFor("strike_dmg_persecond")

	if IsServer() then
		self.fMagicalDamage = self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalAttack)
		self:SetStackCount(1)
		self:StartIntervalThink(1)
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/queen_of_pain/qop_ti8_immortal/queen_ti8_golden_shadow_strike_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 2, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end

function modifier_succubi_1_shadow_strike_debuff:OnRefresh(params)
	self.strike_dmg_persecond = self:GetAbilitySpecialValueFor("strike_dmg_persecond")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_succubi_1_shadow_strike_debuff:OnIntervalThink()
	if self:GetParent():IsAlive() then
		local fDamage = self:GetStackCount() * self.strike_dmg_persecond * self.fMagicalDamage * 0.01
		if IsValid(self:GetCaster()) and IsValid(self:GetAbility()) then
			ApplyDamage({
				ability = self:GetAbility(),
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = fDamage,
				damage_type = self:GetAbility():GetAbilityDamageType()
			})
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, self:GetParent(), fDamage, self:GetCaster())
		end
	end
end

function modifier_succubi_1_shadow_strike_debuff:IsDebuff()
	return true
end