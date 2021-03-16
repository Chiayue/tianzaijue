if modifier_activity_modifiers == nil then
	modifier_activity_modifiers = class({})
end

local public = modifier_activity_modifiers

function public:IsHidden()
	return true
end
function public:IsDebuff()
	return false
end
function public:IsPurgable()
	return false
end
function public:IsPurgeException()
	return false
end
function public:AllowIllusionDuplicate()
	return false
end
function public:RemoveOnDeath()
	return false
end
function public:DestroyOnExpire()
	return false
end
function public:OnCreated(params)
	self.AttackSpeedActivityModifiers = KeyValues.UnitsKv[self:GetParent():GetUnitName()].AttackSpeedActivityModifiers
	self.AttackRangeActivityModifiers = KeyValues.UnitsKv[self:GetParent():GetUnitName()].AttackRangeActivityModifiers
	self.MovementSpeedActivityModifiers = KeyValues.UnitsKv[self:GetParent():GetUnitName()].MovementSpeedActivityModifiers

	if IsServer() then
		-- self:StartIntervalThink(0)
	end
	self.AttackSpeedActivityModifier = ""
	self.AttackRangeActivityModifier = ""
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_START, self, self:GetParent())
end
function public:OnRefresh(params)
	if IsServer() then
	end
end
function public:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_START, self, self:GetParent())
end
function public:OnAttackStart(params)
	if params.attacker == self:GetParent() then
		if self.AttackSpeedActivityModifiers ~= nil then
			if self.AttackSpeedActivityModifier ~= nil then
				AssetModifiers:RemoveActivityModifier(self:GetParent(), self.AttackSpeedActivityModifier)
			end
			local ActivityTranslationModifiers = ""
			local flAttackSpeed = self:GetParent():GetAttackSpeed() * 100
			local flMaxSpeed = -1
			for key, speed in pairs(self.AttackSpeedActivityModifiers) do
				if flAttackSpeed > speed and speed > flMaxSpeed then
					ActivityTranslationModifiers = key
					flMaxSpeed = speed
				end
			end
			AssetModifiers:AddActivityModifier(self:GetParent(), ActivityTranslationModifiers)
			self.AttackSpeedActivityModifier = ActivityTranslationModifiers
		end
		if self.AttackRangeActivityModifiers ~= nil then
			if self.AttackRangeActivityModifier ~= nil then
				AssetModifiers:RemoveActivityModifier(self:GetParent(), self.AttackRangeActivityModifier)
			end
			local ActivityTranslationModifiers = ""
			local flAttackRange = self:GetParent():Script_GetAttackRange()
			local flMaxRange = -1
			for key, range in pairs(self.AttackRangeActivityModifiers) do
				if flAttackRange > range and range > flMaxRange then
					ActivityTranslationModifiers = key
					flAttackRange = range
				end
			end
			AssetModifiers:AddActivityModifier(self:GetParent(), ActivityTranslationModifiers)
			self.AttackRangeActivityModifier = ActivityTranslationModifiers
		end
	end
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
end
function public:GetActivityTranslationModifiers(params)
	if self.MovementSpeedActivityModifiers ~= nil then
		local ActivityTranslationModifiers = ""
		local flMoveSpeed = self:GetParent():GetMoveSpeedModifier(self:GetParent():GetBaseMoveSpeed(), false)
		local flMaxSpeed = -1
		for key, speed in pairs(self.MovementSpeedActivityModifiers) do
			if flMoveSpeed > speed and speed > flMaxSpeed then
				ActivityTranslationModifiers = key
				flMaxSpeed = speed
			end
		end
		return ActivityTranslationModifiers
	end
end