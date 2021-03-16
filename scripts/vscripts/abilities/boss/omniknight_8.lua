LinkLuaModifier("modifier_omniknight_8", "abilities/boss/omniknight_8.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_omniknight_8_buff", "abilities/boss/omniknight_8.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_omniknight_8_thinker", "abilities/boss/omniknight_8.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if omniknight_8 == nil then
	omniknight_8 = class({})
end
function omniknight_8:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_omniknight_8_buff", { duration = self:GetChannelTime() })
	hCaster:AddBuff(hCaster, BUFF_TYPE.TENACITY, self:GetChannelTime())
	-- 幻象施法
	if not hCaster:HasModifier("modifier_omniknight_7_illusion") then
		local hAbility = hCaster:FindAbilityByName("omniknight_7")
		for k, hUnit in pairs(hAbility.tSummonned) do
			if IsValid(hUnit) then
				ExecuteOrder(hUnit, DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, hUnit:FindAbilityByName("omniknight_8"))
			end
		end
	end
end
function omniknight_8:OnChannelFinish(bInterrupted)
	if bInterrupted then
		self:GetCaster():RemoveModifierByName("modifier_omniknight_8_buff")
		self:GetCaster():RemoveModifierByName(BUFF_TYPE.TENACITY)
	end
end
function omniknight_8:GetIntrinsicModifierName()
	return "modifier_omniknight_8"
end
---------------------------------------------------------------------
--Modifiers
if modifier_omniknight_8 == nil then
	modifier_omniknight_8 = class({}, nil, ModifierHidden)
end
function modifier_omniknight_8:OnCreated(params)
	self.trigger_pct = self:GetAbilitySpecialValueFor("trigger_pct")
	self.enemy_count = self:GetAbilitySpecialValueFor("enemy_count")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_omniknight_8:OnIntervalThink()
	local hParent = self:GetParent()
	if hParent:GetHealthPercent() <= self.trigger_pct and hParent:GetCurrentActiveAbility() ~= self:GetAbility() then
		ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, self:GetAbility())
	end
end
---------------------------------------------------------------------
if modifier_omniknight_8_buff == nil then
	modifier_omniknight_8_buff = class({}, nil, eom_modifier)
end
function modifier_omniknight_8_buff:IsHidden()
	return true
end
function modifier_omniknight_8_buff:OnCreated(params)
	self.delay = self:GetAbilitySpecialValueFor("delay")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.boom_count_min = self:GetAbilitySpecialValueFor("boom_count_min")
	self.boom_count_max = self:GetAbilitySpecialValueFor("boom_count_max")
	self.bonus_physical_armor = self:GetAbilitySpecialValueFor("bonus_physical_armor")
	self.bonus_magical_armor = self:GetAbilitySpecialValueFor("bonus_magical_armor")
	if IsServer() then
		self:OnIntervalThink()
		self:StartIntervalThink(self.interval)
	end
end
function modifier_omniknight_8_buff:OnIntervalThink()
	for i = 1, RandomInt(self.boom_count_min, self.boom_count_max) do
		-- local vPosition = self:GetParent():GetAbsOrigin() + RandomVector(RandomInt(0, self.radius))
		local vPosition = Entities:FindByNameLike(nil, BOSS_MAP_POINT_NAME):GetAbsOrigin() + RandomVector(RandomInt(0, self.radius))
		CreateModifierThinker(self:GetParent(), self:GetAbility(), "modifier_omniknight_8_thinker", { duration = self.delay }, vPosition, self:GetParent():GetTeamNumber(), false)
	end
end
function modifier_omniknight_8_buff:GetMagicalArmorBonus()
	return self.bonus_magical_armor
end
function modifier_omniknight_8_buff:GetPhysicalArmorBonus()
	return self.bonus_physical_armor
end
function modifier_omniknight_8_buff:EDeclareFunctions()
	return {
		[EMDF_MAGICAL_ARMOR_BONUS] = self.bonus_magical_armor,
		[EMDF_PHYSICAL_ARMOR_BONUS] = self.bonus_physical_armor,
	}
end
---------------------------------------------------------------------
if modifier_omniknight_8_thinker == nil then
	modifier_omniknight_8_thinker = class({}, nil, ModifierHidden)
end
function modifier_omniknight_8_thinker:OnCreated(params)
	self.damage_radius = self:GetAbilitySpecialValueFor("damage_radius")
	if IsServer() then
		self:GetParent():EmitSound("Hero_Pugna.NetherBlastPreCast")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/boss/omniknight/omniknight_8_pre.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.damage_radius, 1, self.damage_radius))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_omniknight_8_thinker:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.damage_radius, self:GetAbility())
		self:GetCaster():DealDamage(tTargets, self:GetAbility(), self:GetAbility():GetAbilityDamage())

		hParent:EmitSound("Hero_Pugna.NetherBlast")

		if IsValid(self:GetParent()) then
			self:GetParent():RemoveSelf()
		end
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/boss/omniknight/omniknight_8.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.damage_radius, self.damage_radius, self.damage_radius))
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end