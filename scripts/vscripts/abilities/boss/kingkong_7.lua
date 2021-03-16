LinkLuaModifier( "modifier_kingkong_7", "abilities/boss/kingkong_7.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_kingkong_7_buff", "abilities/boss/kingkong_7.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_kingkong_7_thinker", "abilities/boss/kingkong_7.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if kingkong_7 == nil then
	kingkong_7 = class({})
end
function kingkong_7:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_kingkong_7_buff", {duration = self:GetChannelTime()})
	hCaster:AddBuff(hCaster, BUFF_TYPE.TENACITY, self:GetChannelTime())
	self.tTargets = hCaster:FindAbilityByName("kingkong_3"):Summon()
end
function kingkong_7:OnChannelThink(flInterval)
	if self.tTargets then
		local bEnd = true
		for k, hUnit in pairs(self.tTargets) do
			if IsValid(hUnit) and hUnit:IsAlive() then
				bEnd = false
			end
		end
		if bEnd then
			self:GetCaster():InterruptChannel()
			self:GetCaster():Stop()
		end
	end
end
function kingkong_7:OnChannelFinish(bInterrupted)
	if bInterrupted then
		self:GetCaster():RemoveModifierByName("modifier_kingkong_7_buff")
		self:GetCaster():RemoveModifierByName(BUFF_TYPE.TENACITY)
	end
end
function kingkong_7:GetIntrinsicModifierName()
	return "modifier_kingkong_7"
end
---------------------------------------------------------------------
--Modifiers
if modifier_kingkong_7 == nil then
	modifier_kingkong_7 = class({}, nil, ModifierHidden)
end
function modifier_kingkong_7:OnCreated(params)
	-- self.trigger_time = self:GetAbilitySpecialValueFor("trigger_time")
	self.trigger_pct = self:GetAbilitySpecialValueFor("trigger_pct")
	self.enemy_count = self:GetAbilitySpecialValueFor("enemy_count")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_kingkong_7:OnIntervalThink()
	local hParent = self:GetParent()
	-- local iPlayerLevel = 0
	-- DotaTD:EachPlayer(function(_, iPlayerID)
	-- 	iPlayerLevel = iPlayerLevel + PlayerData:GetPlayerLevel(iPlayerID) - self.enemy_count
	-- end)
	-- local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), -1, self:GetAbility())
	-- if self:GetElapsedTime() > self.trigger_time and -- 60秒后激活
	-- hParent:IsAbilityReady(self:GetAbility()) and
	-- #tTargets >= iPlayerLevel * PlayerData:GetAlivePlayerCount() then	-- 当前单位大于等于（玩家人口-1） * 玩家人数
	-- 	ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, self:GetAbility())
	-- end
	if self:GetAbility():IsCooldownReady() and self:GetParent():GetHealthPercent() <= self.trigger_pct then
		ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, self:GetAbility())
	end
end
---------------------------------------------------------------------
if modifier_kingkong_7_buff == nil then
	modifier_kingkong_7_buff = class({}, nil, ModifierHidden)
end
function modifier_kingkong_7_buff:OnCreated(params)
	self.delay = self:GetAbilitySpecialValueFor("delay")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.stone_min = self:GetAbilitySpecialValueFor("stone_min")
	self.stone_max = self:GetAbilitySpecialValueFor("stone_max")
	if IsServer() then
		self:OnIntervalThink()
		self:StartIntervalThink(self.interval)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/boss/kingkong/kingkong_7_bubble.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		-- ParticleManager:SetParticleControlEnt(iParticleID, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "", self:GetParent():GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_kingkong_7_buff:OnIntervalThink()
	for i = 1, RandomInt(self.stone_min, self.stone_max) do
		local vPosition = Entities:FindByNameLike(nil, BOSS_MAP_POINT_NAME):GetAbsOrigin() + RandomVector(RandomInt(0, self.radius))
		CreateModifierThinker(self:GetParent(), self:GetAbility(), "modifier_kingkong_7_thinker", {duration = self.delay}, vPosition, self:GetParent():GetTeamNumber(), false)
	end
end
function modifier_kingkong_7_buff:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
	}
end
---------------------------------------------------------------------
if modifier_kingkong_7_thinker == nil then
	modifier_kingkong_7_thinker = class({}, nil, ModifierHidden)
end
function modifier_kingkong_7_thinker:OnCreated(params)
	self.damage_radius = self:GetAbilitySpecialValueFor("damage_radius")
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	self.delay = self:GetAbilitySpecialValueFor("delay")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/boss/kingkong/kingkong_1.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin() + Vector(300, 0, 2000))
		ParticleManager:SetParticleControl(iParticleID, 1, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(2000 / self.delay, 0, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/boss/damage_circle.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.damage_radius, self.delay, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_kingkong_7_thinker:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.damage_radius, self:GetAbility())
		self:GetCaster():DealDamage(tTargets, self:GetAbility(), self:GetAbility():GetAbilityDamage())
		for _, hUnit in pairs(tTargets) do
			hUnit:AddBuff(hParent, BUFF_TYPE.STUN, self.stun_duration)
		end
		
		hParent:EmitSound("n_creep_Thunderlizard_Big.Stomp")

		if IsValid(self:GetParent()) then
			self:GetParent():RemoveSelf()
		end
	else
		-- 落地特效
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/brewmaster/brewmaster_offhand_elixir/brewmaster_thunder_clap_elixir.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.damage_radius, self.damage_radius, self.damage_radius))
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end