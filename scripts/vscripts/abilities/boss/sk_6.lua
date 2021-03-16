LinkLuaModifier("modifier_sk_6", "abilities/boss/sk_6.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sk_6_move", "abilities/boss/sk_6.lua", LUA_MODIFIER_MOTION_HORIZONTAL)

--Abilities
if sk_6 == nil then
	sk_6 = class({})
end
function sk_6:OnSpellStart()
	local tDir = { "left", "right", "back" }
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sk_6_move", { duration = self:GetSpecialValueFor("duration"), vDir = tDir[RandomInt(1, 3)] })
end
function sk_6:GetIntrinsicModifierName()
	return "modifier_sk_6"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_sk_6 == nil then
	modifier_sk_6 = class({}, nil, BaseModifier)
end
function modifier_sk_6:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_sk_6:OnIntervalThink()
	local hParent = self:GetParent()
	if self:GetParent():IsAbilityReady(self:GetAbility()) and not hParent:IsRooted() then
		ExecuteOrderFromTable({
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self:GetAbility():entindex(),
		})
	end
end
function modifier_sk_6:IsHidden()
	return true
end
---------------------------------------------------------------------
if modifier_sk_6_move == nil then
	modifier_sk_6_move = class({}, nil, HorizontalModifier)
end
function modifier_sk_6_move:IsPurgable()
	return false
end
function modifier_sk_6_move:OnCreated(kv)
	if IsServer() then

		self.speed = self:GetAbility():GetSpecialValueFor("speed")
		self.vDir = kv.vDir
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
			return
		end
	end
end
function modifier_sk_6_move:GetPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM
end
function modifier_sk_6_move:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)
		self:GetParent():Interrupt()
	end
end
function modifier_sk_6_move:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		self.vMoveDir = nil
		if self.vDir == "left" then
			self.vMoveDir = -self:GetParent():GetRightVector()
		end
		if self.vDir == "right" then
			self.vMoveDir = self:GetParent():GetRightVector()
		end
		if self.vDir == "back" then
			self.vMoveDir = -self:GetParent():GetForwardVector()
		end
		local vNewPos = self:GetParent():GetOrigin() + (self.vMoveDir * self.speed * dt)
		if not GridNav:CanFindPath(self:GetParent():GetOrigin(), vNewPos) then
			self:Destroy()
			return
		end
		me:SetOrigin(vNewPos)
	end
end
function modifier_sk_6_move:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_sk_6_move:DeclareFunctions()
	local funcs =	 {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	}
	return funcs
end
function modifier_sk_6_move:GetActivityTranslationModifiers(params)
	if self.vDir == "left" then
		return "left"
	end
	if self.vDir == "right" then
		return "right"
	end
	if self.vDir == "back" then
		return "backward"
	end
	return ""
end
function modifier_sk_6_move:GetModifierTurnRate_Percentage(params)
	return -90
end