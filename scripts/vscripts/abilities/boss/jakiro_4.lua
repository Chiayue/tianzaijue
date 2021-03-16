LinkLuaModifier("modifier_jakiro_4", "abilities/boss/jakiro_4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jakiro_4_blocker", "abilities/boss/jakiro_4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jakiro_4_debuff", "abilities/boss/jakiro_4.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if jakiro_4 == nil then
	jakiro_4 = class({})
end
function jakiro_4:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	hCaster:AddBuff(hCaster, BUFF_TYPE.TENACITY, self:GetCastPoint())
	-- 所有冰蛋也施放
	local vPosition = self:GetCursorPosition()
	if hCaster.GetActiveEgg then
		local tEgg = hCaster:GetActiveEgg()
		for _, hEgg in pairs(tEgg) do
			ExecuteOrder(hEgg, DOTA_UNIT_ORDER_CAST_POSITION, nil, hEgg:FindAbilityByName(self:GetAbilityName()), vPosition)
		end
	end
	return true
end
function jakiro_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local vCasterLoc = hCaster:GetAbsOrigin()
	local vPosition = self:GetCursorPosition()
	local width = self:GetSpecialValueFor("width")
	local distance = self:GetSpecialValueFor("distance")
	local flDuration = self:GetDuration()
	local vDirection = (vPosition - vCasterLoc):Normalized()
	local vStart = vCasterLoc + vDirection * width
	vPosition = vCasterLoc + vDirection * distance
	-- 冰冻
	local tTargets = FindUnitsInLineWithAbility(hCaster, vStart, vPosition, width, self)
	for _, hUnit in pairs(tTargets) do
		hUnit:AddNewModifier(hCaster, self, "modifier_jakiro_4_debuff", { duration = flDuration })
	end
	-- 创建阻挡（7/14取消阻挡）
	-- local number_of_blocker = Round(distance / width, 1)
	-- for i = 1, number_of_blocker do
	-- 	local vBlockerLoc = GetGroundPosition(vStart + vDirection * i * width, hCaster)
	-- 	local hBlocker = CreateModifierThinker(hCaster, self, "modifier_jakiro_4_blocker", { duration = flDuration }, vBlockerLoc, hCaster:GetTeamNumber(), true)
	-- 	hBlocker:SetHullRadius(width / 2)
	-- end
	-- 冰封路径特效
	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/jakiro/jakiro_ti7_immortal_head/jakiro_ti7_immortal_head_ice_path_b.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vStart)
	ParticleManager:SetParticleControl(iParticleID, 1, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(flDuration, 0, 0))
	ParticleManager:SetParticleControl(iParticleID, 9, vStart)
	ParticleManager:ReleaseParticleIndex(iParticleID)
end
function jakiro_4:GetIntrinsicModifierName()
	return "modifier_jakiro_4"
end
---------------------------------------------------------------------
--Modifiers
if modifier_jakiro_4 == nil then
	modifier_jakiro_4 = class({}, nil, ModifierHidden)
end
function modifier_jakiro_4:OnCreated(params)
	self.distance = self:GetAbilitySpecialValueFor("distance")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_jakiro_4:OnIntervalThink()
	local hParent = self:GetParent()
	if hParent:IsAbilityReady(self:GetAbility()) and hParent.GetState and hParent:GetState() == "ice" then
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.distance, self:GetAbility())
		if IsValid(tTargets[1]) then
			ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_POSITION, nil, self:GetAbility(), tTargets[1]:GetAbsOrigin())
		end
	end
end
---------------------------------------------------------------------
if modifier_jakiro_4_blocker == nil then
	modifier_jakiro_4_blocker = class({}, nil, ModifierHidden)
end
function modifier_jakiro_4_blocker:OnDestroy()
	if IsServer() then
		if IsValid(self:GetParent()) then
			self:GetParent():RemoveSelf()
		end
	end
end
function modifier_jakiro_4_blocker:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1 / 30)
	end
end
function modifier_jakiro_4_blocker:OnIntervalThink()
	if IsServer() then
		ResolveNPCPositions(self:GetParent():GetAbsOrigin(), self:GetParent():GetHullRadius())
		self:StartIntervalThink(-1)
	end
end
---------------------------------------------------------------------
if modifier_jakiro_4_debuff == nil then
	modifier_jakiro_4_debuff = class({}, nil, ModifierDebuff)
end
function modifier_jakiro_4_debuff:OnCreated(params)
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_icepath_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_jakiro_4_debuff:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end