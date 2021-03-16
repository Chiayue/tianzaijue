LinkLuaModifier("modifier_contract_monster_commander", "abilities/contract/contract_monster_commander.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_contract_monster_commander_buff", "abilities/contract/contract_monster_commander.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--[[	contract_monster_commander 巨兽领袖
	description 214
]]
if contract_monster_commander == nil then
	contract_monster_commander = class({})
end
function contract_monster_commander:GetIntrinsicModifierName()
	return "modifier_contract_monster_commander"
end
---------------------------------------------------------------------
--Modifiers
if modifier_contract_monster_commander == nil then
	modifier_contract_monster_commander = class({}, nil, eom_modifier)
end
function modifier_contract_monster_commander:IsHidden()
	return true
end
function modifier_contract_monster_commander:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.hp_lost = self:GetAbilitySpecialValueFor("hp_lost")
	self.attack_radius = self:GetAbilitySpecialValueFor("attack_radius")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
		self.attack_count = 0
		self:StartIntervalThink(1)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/enemy/aura_durable.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_contract_monster_commander:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.hp_lost = self:GetAbilitySpecialValueFor("hp_lost")
	self.attack_radius = self:GetAbilitySpecialValueFor("attack_radius")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
	end
end
function modifier_contract_monster_commander:OnIntervalThink()
	local hParent = self:GetParent()
	local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
	self:SetStackCount(#tTargets)
	local tFriends = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, hUnit in ipairs(tFriends) do
		hUnit:AddNewModifier(hParent, self:GetAbility(), "modifier_contract_monster_commander_buff", { duration = 1, iStackCount = #tTargets })
	end
end
function modifier_contract_monster_commander:EDeclareFunctions()
	return {
		[EMDF_EVENT_CUSTOM] = { ET_ENEMY.ON_DEATH, self.OnDeath },
		EMDF_DO_ATTACK_BEHAVIOR
	}
end
function modifier_contract_monster_commander:DoAttackBehavior(tAttackInfo, hAttackAbility)
	local hParent = self:GetParent()
	local hTarget = tAttackInfo.target

	if self.attack_count > 0 then
		self.attack_count = self.attack_count - 1
		-- 范围伤害
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hTarget:GetAbsOrigin(), self.attack_radius, self:GetAbility())
		for _, hUnit in ipairs(tTargets) do
			--命中
			EModifier:NotifyEvt(EMDF_EVENT_ON_ATTACK_HIT, hUnit, tAttackInfo)
			--伤害
			hAttackAbility:OnDamage(hUnit, tAttackInfo)
			hUnit:AddBuff(hParent, BUFF_TYPE.STUN, self.duration)
		end
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_aftershock_v2.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hTarget:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.attack_radius, self.attack_radius, self.attack_radius))
		ParticleManager:ReleaseParticleIndex(iParticleID)
	else
		--命中
		EModifier:NotifyEvt(EMDF_EVENT_ON_ATTACK_HIT, hTarget, tAttackInfo)
		--伤害
		hAttackAbility:OnDamage(hTarget, tAttackInfo)
	end
end
function modifier_contract_monster_commander:OnDeath(params)
	if params.PlayerID == GetPlayerID(self:GetParent()) then
		self:GetParent():ModifyHealth(self:GetParent():GetHealth() - self:GetParent():GetVal(ATTRIBUTE_KIND.StatusHealth) * self.hp_lost * 0.01, self:GetAbility(), false, 0)
		self.attack_count = self.attack_count + 1
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_contract_monster_commander_buff == nil then
	modifier_contract_monster_commander_buff = class({}, nil, eom_modifier)
end
function modifier_contract_monster_commander_buff:OnCreated(params)
	self.bonus_stats = self:GetAbilitySpecialValueFor("bonus_stats")
	if IsServer() then
		self:SetStackCount(params.iStackCount)
	end
end
function modifier_contract_monster_commander_buff:OnRefresh(params)
	self.bonus_stats = self:GetAbilitySpecialValueFor("bonus_stats")
	if IsServer() then
		self:SetStackCount(params.iStackCount)
	end
end
function modifier_contract_monster_commander_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_contract_monster_commander_buff:EDeclareFunctions()
	return {
		[EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE] = self.bonus_stats * self:GetStackCount(),
		[EMDF_STATUS_HEALTH_BONUS_PERCENTAGE] = self.bonus_stats * self:GetStackCount(),
		[EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE] = self.bonus_stats * self:GetStackCount(),
		[EMDF_MAGICAL_ARMOR_BONUS_PERCENTAGE] = self.bonus_stats * self:GetStackCount(),
		[EMDF_PHYSICAL_ARMOR_BONUS_PERCENTAGE] = self.bonus_stats * self:GetStackCount(),
		[EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE] = self.bonus_stats * self:GetStackCount(),
		[EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE] = self.bonus_stats * self:GetStackCount(),
	}
end