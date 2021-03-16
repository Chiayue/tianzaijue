LinkLuaModifier( "modifier_jakiro_5", "abilities/boss/jakiro_5.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if jakiro_5 == nil then
	jakiro_5 = class({})
end
function jakiro_5:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	hCaster:AddBuff(hCaster, BUFF_TYPE.TENACITY, self:GetCastPoint())
	-- 所有火蛋也施放
	local vPosition = self:GetCursorPosition()
	if hCaster.GetActiveEgg then
		local tEgg = hCaster:GetActiveEgg()
		for _, hEgg in pairs(tEgg) do
			ExecuteOrder(hEgg, DOTA_UNIT_ORDER_CAST_POSITION, nil, hEgg:FindAbilityByName(self:GetAbilityName()), vPosition)
		end
	end
	return true
end
function jakiro_5:OnSpellStart()
	local hCaster = self:GetCaster()
	local vCasterLoc = hCaster:GetAbsOrigin()
	local vPosition = self:GetCursorPosition()
	local width = self:GetSpecialValueFor("width")
	local distance = self:GetSpecialValueFor("distance")
	local flDamage = self:GetAbilityDamage()
	local flDuration = self:GetDuration()
	local vDirection = (vPosition - vCasterLoc):Normalized()
	local vStart = vCasterLoc + vDirection * width
	vPosition = vCasterLoc + vDirection * distance

	hCaster:GameTimer(1, function ()
		if flDuration > 0 then
			flDuration = flDuration - 1
			local tTargets = FindUnitsInLineWithAbility(hCaster, vStart, vPosition, width, self)
			hCaster:DealDamage(tTargets, self, flDamage)
		end
		return 1
	end)
	-- 火焰特效
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_macropyre.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vStart)
	ParticleManager:SetParticleControl(iParticleID, 1, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(flDuration, 0, 0))
	ParticleManager:ReleaseParticleIndex(iParticleID)
end
function jakiro_5:GetIntrinsicModifierName()
	return "modifier_jakiro_5"
end
---------------------------------------------------------------------
--Modifiers
if modifier_jakiro_5 == nil then
	modifier_jakiro_5 = class({}, nil, ModifierHidden)
end
function modifier_jakiro_5:OnCreated(params)
	self.distance = self:GetAbilitySpecialValueFor("distance")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_jakiro_5:OnIntervalThink()
	local hParent = self:GetParent()
	if hParent:IsAbilityReady(self:GetAbility()) and hParent.GetState and hParent:GetState() == "fire" then
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.distance, self:GetAbility())
		if IsValid(tTargets[1]) then
			ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_POSITION, nil, self:GetAbility(), tTargets[1]:GetAbsOrigin())
		end
	end
end