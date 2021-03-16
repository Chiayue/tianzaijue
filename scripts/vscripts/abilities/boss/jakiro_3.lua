LinkLuaModifier("modifier_jakiro_3", "abilities/boss/jakiro_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jakiro_3_ice", "abilities/boss/jakiro_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jakiro_3_fire", "abilities/boss/jakiro_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if jakiro_3 == nil then
	jakiro_3 = class({})
end
function jakiro_3:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	hCaster:AddBuff(hCaster, BUFF_TYPE.TENACITY, self:GetCastPoint())
	return true
end
function jakiro_3:OnSpellStart()
	self:GetCaster():AddActivityModifier("corkscrew_gesture")
	self:GetCaster():StartGesture(ACT_DOTA_TAUNT)
	-- return true
end
function jakiro_3:OnChannelFinish(bInterrupted)
	local hCaster = self:GetCaster()
	hCaster:RemoveActivityModifier("corkscrew_gesture")
	if bInterrupted then
		return
	end
	-- 抗性
	hCaster:AddBuff(hCaster, BUFF_TYPE.TENACITY, self:GetChannelTime())


	-- 下蛋
	local hAbility = hCaster:FindAbilityByName("jakiro_2")
	if IsValid(hAbility) then
		local hEgg = hAbility:SpawnEgg(hCaster:GetState() == "fire" and "ice" or "fire", hCaster:GetAbsOrigin() + Vector(RandomInt(-600, 600), RandomInt(-600, 600), 0))
		-- FindClearSpaceForUnit(hEgg, hCaster:GetAbsOrigin(), true)
	end

	if hCaster:HasModifier("modifier_jakiro_3_ice") then
		hCaster:RemoveModifierByName("modifier_jakiro_3_ice")
		hCaster:AddNewModifier(hCaster, self, "modifier_jakiro_3_fire", nil)
	elseif hCaster:HasModifier("modifier_jakiro_3_fire") then
		hCaster:RemoveModifierByName("modifier_jakiro_3_fire")
		hCaster:AddNewModifier(hCaster, self, "modifier_jakiro_3_ice", nil)
	else
		hCaster:AddNewModifier(hCaster, self, "modifier_jakiro_3_ice", nil)
	end
	-- 刷新三四技能cd
	self:GetCaster():FindAbilityByName("jakiro_4"):EndCooldown()
	self:GetCaster():FindAbilityByName("jakiro_5"):EndCooldown()
	-- 增加双攻
	self:GetIntrinsicModifier():IncrementStackCount()
end
function jakiro_3:GetIntrinsicModifierName()
	return "modifier_jakiro_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_jakiro_3 == nil then
	modifier_jakiro_3 = class({}, nil, eom_modifier)
end
function modifier_jakiro_3:IsHidden()
	return true
end
function modifier_jakiro_3:OnCreated(params)
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.toggle_attack_pct = self:GetAbilitySpecialValueFor("toggle_attack_pct")
	self.toggle_armor = self:GetAbilitySpecialValueFor("toggle_armor")
	if IsServer() then
		local hParent = self:GetParent()
		-- 初始冰形态
		hParent:GameTimer(0.1, function()
			-- ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, self:GetAbility())
			hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_jakiro_3_ice", nil)
		end)

		-- 20秒内没有单位死亡切换形态
		self:StartIntervalThink(self.interval)
	end
end
function modifier_jakiro_3:OnRefresh(params)
	self.interval = self:GetAbilitySpecialValueFor("interval")
	if IsServer() then
	end
end
function modifier_jakiro_3:OnIntervalThink()
	local hParent = self:GetParent()
	if GSManager:getStateType() == GS_Battle and hParent:GetCurrentActiveAbility() == nil then
		hParent:Purge(false, true, false, true, true)
		ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, self:GetAbility())
		self:StartIntervalThink(self.interval)
	else
		self:StartIntervalThink(1)
	end
end
function modifier_jakiro_3:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH,
		EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_MAGICAL_ARMOR_BONUS,
		EMDF_PHYSICAL_ARMOR_BONUS
	}
end
function modifier_jakiro_3:OnDeath(params)
	-- 有单位死亡则重新计时
	if not params.unit:IsFriendly(self:GetParent()) then
		self:StartIntervalThink(self.interval)
	end
end
function modifier_jakiro_3:GetMagicalAttackBonusPercentage()
	return self:GetStackCount() * self.toggle_attack_pct
end
function modifier_jakiro_3:GetPhysicalAttackBonusPercentage()
	return self:GetStackCount() * self.toggle_attack_pct
end
function modifier_jakiro_3:GetMagicalArmorBonus()
	return self:GetStackCount() * self.toggle_armor
end
function modifier_jakiro_3:GetPhysicalArmorBonus()
	return self:GetStackCount() * self.toggle_armor
end
---------------------------------------------------------------------
if modifier_jakiro_3_ice == nil then
	modifier_jakiro_3_ice = class({}, nil, eom_modifier)
end
function modifier_jakiro_3_ice:OnCreated(params)
	self.physical_armor = self:GetAbilitySpecialValueFor("physical_armor")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	local hParent = self:GetParent()
	if IsServer() then
		self.hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = "models/items/jakiro/jakiro_ti7_immortal_head/jakiro_ti7_immortal_head_ice.vmdl", origin = hParent:GetAbsOrigin() })
		self.hWearable:FollowEntity(hParent, true)
		hParent.GetState = function(hParent)
			return "ice"
		end
		-- 激活冰蛋
		local tEgg = hParent:GetEgg()
		for i, hEgg in ipairs(tEgg) do
			if hEgg:HasModifier("modifier_jakiro_2_ice") then
				hEgg:Active()
			end
		end
		-- 不激活火蛋
		local tEgg = hParent:GetEgg()
		for i, hEgg in ipairs(tEgg) do
			if hEgg:HasModifier("modifier_jakiro_2_fire") then
				hEgg:UnActive()
			end
		end
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/jakiro/jakiro_ti7_immortal_head/jakiro_ti7_immortal_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.hWearable)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, self.hWearable, PATTACH_POINT_FOLLOW, "attach_head", self.hWearable:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 2, self.hWearable, PATTACH_POINT_FOLLOW, "attach_head", self.hWearable:GetAbsOrigin(), false)
		ParticleManager:SetParticleControl(iParticleID, 3, Vector(1, 1, 1))
		ParticleManager:SetParticleControlEnt(iParticleID, 4, self.hWearable, PATTACH_POINT_FOLLOW, "attach_head", self.hWearable:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	else
	end
end
function modifier_jakiro_3_ice:IsHidden()
	return true
end
function modifier_jakiro_3_ice:OnDestroy()
	if IsServer() then
		UTIL_Remove(self.hWearable)
	end
end
function modifier_jakiro_3_ice:EDeclareFunctions()
	return {
		[EMDF_ATTACKT_SPEED_BONUS] = self.attackspeed,
		[EMDF_PHYSICAL_ARMOR_BONUS] = self.physical_armor,
	}
end
function modifier_jakiro_3_ice:GetAttackSpeedBonus()
	return self.attackspeed
end
function modifier_jakiro_3_ice:GetPhysicalArmorBonus()
	return self.physical_armor
end
---------------------------------------------------------------------
if modifier_jakiro_3_fire == nil then
	modifier_jakiro_3_fire = class({}, nil, eom_modifier)
end
function modifier_jakiro_3_fire:OnCreated(params)
	self.magical_armor = self:GetAbilitySpecialValueFor("magical_armor")
	self.regen = self:GetAbilitySpecialValueFor("regen")
	local hParent = self:GetParent()
	if IsServer() then
		self.hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = "models/items/jakiro/jakiro_ti8_immortal_left_head/jakiro_ti8_immortal_left_head.vmdl", origin = hParent:GetAbsOrigin() })
		self.hWearable:FollowEntity(hParent, true)
		hParent.GetState = function(hParent)
			return "fire"
		end
		-- 激活火蛋
		local tEgg = hParent:GetEgg()
		for i, hEgg in ipairs(tEgg) do
			if hEgg:HasModifier("modifier_jakiro_2_fire") then
				hEgg:Active()
			end
		end
		-- 不激活冰蛋
		local tEgg = hParent:GetEgg()
		for i, hEgg in ipairs(tEgg) do
			if hEgg:HasModifier("modifier_jakiro_2_ice") then
				hEgg:UnActive()
			end
		end
		-- 头部特效
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/jakiro/jakiro_ti8_immortal_head/jakiro_ti8_head_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.hWearable)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, self.hWearable, PATTACH_POINT_FOLLOW, "attach_horn_l", self.hWearable:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 2, self.hWearable, PATTACH_POINT_FOLLOW, "attach_horn_r", self.hWearable:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 3, self.hWearable, PATTACH_POINT_FOLLOW, "attach_head", self.hWearable:GetAbsOrigin(), false)
		ParticleManager:SetParticleControl(iParticleID, 10, Vector(0, 0, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	else
		-- 液态火特效
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_fire_ready.vpcf", PATTACH_ABSORIGIN, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_attack2", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_jakiro_3_fire:OnDestroy()
	if IsServer() then
		UTIL_Remove(self.hWearable)
	end
end
function modifier_jakiro_3_fire:IsHidden()
	return true
end
function modifier_jakiro_3_fire:EDeclareFunctions()
	return {
		[EMDF_MAGICAL_ARMOR_BONUS] = self.magical_armor
	}
end
function modifier_jakiro_3_fire:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}
end
function modifier_jakiro_3_fire:GetModifierProjectileName()
	return "particles/units/heroes/hero_jakiro/jakiro_base_attack_fire.vpcf"
end
function modifier_jakiro_3_fire:GetMagicalArmorBonus()
	return self.magical_armor
end
function modifier_jakiro_3_fire:GetModifierConstantHealthRegen()
	return self.regen
end
function modifier_jakiro_3_fire:GetActivityTranslationModifiers()
	return "liquid_fire"
end