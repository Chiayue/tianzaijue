LinkLuaModifier("modifier_shredderB_2", "abilities/tower/shredderB/shredderB_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shredderB_2_buff", "abilities/tower/shredderB/shredderB_2.lua", LUA_MODIFIER_MOTION_NONE)
if shredderB_2 == nil then
	shredderB_2 = class({})
end
function shredderB_2:GetIntrinsicModifierName()
	return "modifier_shredderB_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_shredderB_2 == nil then
	modifier_shredderB_2 = class({}, nil, BaseModifier)
end
function modifier_shredderB_2:OnCreated(params)
	self.damage_reduce = self:GetAbilitySpecialValueFor("damage_reduce")
	self.threshold = self:GetAbilitySpecialValueFor("threshold")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
		self:StartIntervalThink(1)
		self:OnIntervalThink()
	end
end
function modifier_shredderB_2:OnRefresh(params)
	self.damage_reduce = self:GetAbilitySpecialValueFor("damage_reduce")
	self.threshold = self:GetAbilitySpecialValueFor("threshold")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
	end
end
function modifier_shredderB_2:OnIntervalThink()
	self.flHealthThreshold = self:GetParent():GetVal(ATTRIBUTE_KIND.StatusHealth) * self.threshold * 0.01
end
function modifier_shredderB_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
	-- MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	}
end
function modifier_shredderB_2:GetModifierPhysical_ConstantBlock(params)
	return self.damage_reduce
end
function modifier_shredderB_2:GetModifierTotal_ConstantBlock(params)
	if IsServer() then
		local hParent = params.target
		if hParent == self:GetParent() and params.damage > 0 then
			-- 每秒伤害没达到上限
			if params.damage <= self.flHealthThreshold then
				-- 格挡固定物理伤害
				if params.damage_type == DAMAGE_TYPE_PHYSICAL then
					self.flHealthThreshold = self.flHealthThreshold - math.max(0, params.damage - self.damage_reduce)
					return self.damage_reduce
				end
				self.flHealthThreshold = self.flHealthThreshold - params.damage
			else
				local block = params.damage - self.flHealthThreshold
				self.flHealthThreshold = 0
				hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_shredderB_2_buff", { duration = self.duration })
				return block
			end
			-- return params.damage - self.threshold * hParent:GetMaxHealth() * 0.01
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_shredderB_2_buff == nil then
	modifier_shredderB_2_buff = class({}, nil, BaseModifier)
end
function modifier_shredderB_2_buff:OnCreated(params)
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.width = self:GetAbilitySpecialValueFor("width")
	self.ignite_duration = self:GetAbilitySpecialValueFor("ignite_duration")
	self.ignite_count = self:GetAbilitySpecialValueFor("ignite_count")
	self.damage_tick = self:GetAbilitySpecialValueFor("damage_tick")
	if IsServer() then
		self:StartIntervalThink(self.damage_tick)
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_shredder/shredder_flame_thrower.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 3, hParent, PATTACH_ABSORIGIN_FOLLOW, "", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_shredderB_2_buff:OnIntervalThink()
	local hParent = self:GetParent()
	local vStart = hParent:GetAbsOrigin()
	local vEnd = vStart + hParent:GetForwardVector() * self.distance
	local tTargets = FindUnitsInLineWithAbility(hParent, vStart, vEnd, self.width, self:GetAbility())
	for _, hUnit in ipairs(tTargets) do
		hParent:DealDamage(hUnit, self:GetAbility())
		hUnit:AddBuff(hParent, BUFF_TYPE.IGNITE, self.ignite_duration, true, { iCount = self.ignite_count })
	end
end