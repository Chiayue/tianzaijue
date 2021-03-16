LinkLuaModifier("modifier_oracle_1_buff", "abilities/tower/oracle/oracle_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if oracle_1 == nil then
	oracle_1 = class({ iSearchBehavior = AI_SEARCH_BEHAVIOR_MOST_AOE_TARGET }, nil, ability_base_ai)
end
function oracle_1:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function oracle_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	hTarget:AddNewModifier(hCaster, self, "modifier_oracle_1_buff", { duration = self:GetDuration() })
	hCaster:EmitSound("Hero_Oracle.FatesEdict.Cast")
	hTarget:EmitSound("Hero_Oracle.FatesEdict")
end
function oracle_1:GetIntrinsicModifierName()
	return "modifier_oracle_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_oracle_1_buff == nil then
	modifier_oracle_1_buff = class({}, nil, eom_modifier)
end
function modifier_oracle_1_buff:IsDebuff()
	return true
end
function modifier_oracle_1_buff:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.damage_factor = self:GetAbilitySpecialValueFor("damage_factor")
	self.magical_factor = self:GetAbilitySpecialValueFor("magical_factor")
	self.magical_attack_pct = self:GetAbilitySpecialValueFor("magical_attack_pct")
	self.fInterval = self:GetAbilitySpecialValueFor("fInterval")
	if IsServer() then
		self.tDamageInfo = {}
		self:StartIntervalThink(self.fInterval)
	else
		-- 特效
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fatesedict.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_oracle_1_buff:OnIntervalThink()
	local hParent = self:GetParent()
	if IsValid(hParent) then
		local flDamage = self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalAttack) * 0.01 * self.magical_attack_pct * self.fInterval
		self:GetCaster():DealDamage(hParent, self:GetAbility(), flDamage)
	end
end
function modifier_oracle_1_buff:OnDestroy()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()

		local vPosition = hParent:GetAbsOrigin()

		hParent:GameTimer(0, function()
			if not IsValid(hAbility) or not IsValid(hCaster) then
				return
			end

			local fBaseDamage = hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) * self.magical_factor * 0.01

			local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, self.radius, hAbility)
			for _, tDamageInfo in ipairs(self.tDamageInfo) do
				tDamageInfo.damage = tDamageInfo.damage / #tTargets
			end
			for k, hUnit in pairs(tTargets) do
				for _, tDamageInfo in ipairs(self.tDamageInfo) do
					tDamageInfo.victim = hUnit
					ApplyDamage(tDamageInfo)
				end
				hCaster:DealDamage(hUnit, hAbility, fBaseDamage)
			end
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fortune_aoe.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, GetGroundPosition(vPosition, nil))
			ParticleManager:SetParticleControl(iParticleID, 2, Vector(self.radius, self.radius, self.radius))
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end)
	end
end
function modifier_oracle_1_buff:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent()},
		[EMDF_INCOMING_PERCENTAGE] = -90,
	}
end
function modifier_oracle_1_buff:GetIncomingPercentage(params)
	return -90
end
function modifier_oracle_1_buff:OnTakeDamage(params)
	if IsServer() then
		if params.unit == self:GetParent() then
			if params.original_damage > 0 then
				table.insert(self.tDamageInfo, {
					attacker = params.attacker,
					victim = params.unit,
					ability = params.inflictor or nil,
					damage = params.original_damage * self.damage_factor * 0.01,
					damage_type = params.damage_type,
					damage_flags = params.damage_flags + DOTA_DAMAGE_FLAG_HPLOSS
				})
			end
		end
	end
end