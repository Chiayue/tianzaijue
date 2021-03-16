LinkLuaModifier("modifier_pangolier_1", "abilities/tower/pangolier/pangolier_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_1_attack", "abilities/tower/pangolier/pangolier_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if pangolier_1 == nil then
	pangolier_1 = class({})
end
function pangolier_1:Precache(context)
	PrecacheResource("particle", "particles/units/heroes/hero_pangolier/pangolier_swashbuckler.vpcf", context)
end
function pangolier_1:GetIntrinsicModifierName()
	return "modifier_pangolier_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_pangolier_1 == nil then
	modifier_pangolier_1 = class({}, nil, eom_modifier)
end
function modifier_pangolier_1:IsHidden()
	return true
end
function modifier_pangolier_1:OnCreated(table)
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.swashbuckle_count = self:GetAbilitySpecialValueFor("swashbuckle_count")
end
function modifier_pangolier_1:OnRefresh(table)
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.swashbuckle_count = self:GetAbilitySpecialValueFor("swashbuckle_count")
end
function modifier_pangolier_1:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_RECORD_CREATE,
	-- [MODIFIER_EVENT_ON_ATTACK_re] = { self:GetParent() },
	}
end

function modifier_pangolier_1:OnCustomAttackRecordCreate(params)
	if params.target == nil or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker ~= self:GetParent() then return end
	local hParent = self:GetParent()
	if self:GetAbility():IsCooldownReady() then
		if AttackFilter(params.record, ATTACK_STATE_NO_EXTENDATTACK) then
			return
		end
		hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_pangolier_1_attack", {
			target_entid = params.target:GetEntityIndex(),
			duration = self.interval * self.swashbuckle_count,
		})
		self:GetAbility():UseResources(false, false, true)
	end
end

---------------------------------------------------------------------
--Modifiers
if modifier_pangolier_1_attack == nil then
	modifier_pangolier_1_attack = class({}, nil, eom_modifier)
end
function modifier_pangolier_1_attack:IsHidden()
	return false
end
function modifier_pangolier_1_attack:OnCreated(params)
	if IsServer() then
		self:OnRefresh(params)

		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_pangolier/pangolier_swashbuckler.vpcf", PATTACH_ABSORIGIN, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, 'attach_hitloc', hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControl(iParticleID, 1, self.vForward)
		ParticleManager:SetParticleControlEnt(iParticleID, 3, hParent, PATTACH_POINT_FOLLOW, 'attach_hitloc', hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_pangolier_1_attack:OnRefresh(params)
	self.width = self:GetAbilitySpecialValueFor("width")
	self.range = self:GetAbilitySpecialValueFor("range")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.crit_mult = self:GetAbilitySpecialValueFor("crit_mult")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.swashbuckle_count = self:GetAbilitySpecialValueFor("swashbuckle_count")
	if IsServer() then
		local hParent = self:GetParent()
		self.hTarget = EntIndexToHScript(params.target_entid)
		self.vForward = (self.hTarget:GetAbsOrigin() - hParent:GetAbsOrigin()):Normalized()
		self:SetStackCount(0)
		self:StartIntervalThink(self.interval)
		self:OnIntervalThink()
		hParent:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1_END, 1)
	end
end
function modifier_pangolier_1_attack:OnDestroy()
	if IsServer() then
		self:GetParent():FadeGesture(ACT_DOTA_CAST_ABILITY_1_END)
	end
end
function modifier_pangolier_1_attack:EDeclareFunctions()
	return {
		EMDF_ATTACK_CRIT_BONUS,
	-- EMDF_DO_ATTACK_BEHAVIOR,
	-- [MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY] = { self:GetParent() },
	}
end
function modifier_pangolier_1_attack:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}
end
function modifier_pangolier_1_attack:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true
	}
end
function modifier_pangolier_1_attack:GetModifierDisableTurning()
	return 1
end
function modifier_pangolier_1_attack:GetAttackCritBonus()
	return self.crit_mult, self.chance
end
function modifier_pangolier_1_attack:OnIntervalThink()
	local hParent = self:GetParent()
	local hTarget = self.hTarget

	-- 攻击范围内的敌人
	local vForward = self.vForward
	local vStart = hParent:GetAbsOrigin() + vForward * self.width
	local vEnd = hParent:GetAbsOrigin() + vForward * self.range
	local tTargets = FindUnitsInLineWithAbility(hParent, vStart, vEnd, self.width, self:GetAbility())
	for _, hUnit in pairs(tTargets) do
		Attack(hParent, hUnit, ATTACK_STATE_SKIPCOOLDOWN + ATTACK_STATE_NOT_USEPROJECTILE + ATTACK_STATE_NO_EXTENDATTACK + ATTACK_STATE_SKIPCOUNTING)
	end

	hParent:EmitSound("Hero_Pangolier.Swashbuckle.Attack")
	hParent:EmitSound("Hero_Pangolier.Swashbuckle.Damage")

	if self:GetStackCount() + 1 >= self.swashbuckle_count then
		self:Destroy()
		return
	end
	self:IncrementStackCount()
end