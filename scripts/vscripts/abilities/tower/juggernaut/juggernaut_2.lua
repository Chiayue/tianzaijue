LinkLuaModifier("modifier_juggernaut_2", "abilities/tower/juggernaut/juggernaut_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_juggernaut_2_slash", "abilities/tower/juggernaut/juggernaut_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if juggernaut_2 == nil then
	juggernaut_2 = class({})
end
function juggernaut_2:Action()
	local unlock_count = self:GetSpecialValueFor("unlock_count")
	local hModifier = self:GetIntrinsicModifier()
	if hModifier:GetStackCount() < unlock_count then
		hModifier:IncrementStackCount()
	end
end
function juggernaut_2:Slash()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_juggernaut_2_slash", nil)
	self:GetIntrinsicModifier():SetStackCount(0)
end
function juggernaut_2:GetIntrinsicModifierName()
	return "modifier_juggernaut_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_juggernaut_2 == nil then
	modifier_juggernaut_2 = class({}, nil, eom_modifier)
end
---------------------------------------------------------------------
if modifier_juggernaut_2_slash == nil then
	modifier_juggernaut_2_slash = class({}, nil, eom_modifier)
end
function modifier_juggernaut_2_slash:OnCreated(params)
	self.slash_count = self:GetAbilitySpecialValueFor("slash_count")
	if IsServer() then
		self.vStart = self:GetParent():GetAbsOrigin()
		self:StartIntervalThink(0.15)
	end
end
function modifier_juggernaut_2_slash:OnIntervalThink()
	local hParent = self:GetParent()
	local vPosition = self.vStart + RandomVector(600)
	local tTargets = FindUnitsInRadiusWithAbility(hParent, self.vStart, 400, self:GetAbility())
	if IsValid(tTargets[1]) then
		local vDir = (tTargets[1]:GetAbsOrigin() - hParent:GetAbsOrigin()):Normalized()
		vPosition = hParent:GetAbsOrigin() + vDir * 600
		vPosition = RotatePosition(hParent:GetAbsOrigin(), QAngle(0, RandomInt(-30, 30), 0), vPosition)
		vDir.z = 0
		hParent:SetForwardVector(vDir)

		local hAbility = hParent:FindAbilityByName("juggernaut_1")
		hAbility:Slash(vPosition)
		self.slash_count = self.slash_count - 1
		if self.slash_count <= 0 then
			self:StartIntervalThink(-1)
			self:Destroy()
			return
		end
	else
		self:StartIntervalThink(-1)
		self:Destroy()
		return
	end
end
function modifier_juggernaut_2_slash:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_juggernaut_2_slash:GetOverrideAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_4
end
function modifier_juggernaut_2_slash:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
	}
end
function modifier_juggernaut_2_slash:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_juggernaut_2_slash:OnBattleEnd()
	-- 处理动作
	self:GetParent():FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
end
function modifier_juggernaut_2_slash:OnTooltip()
	return self.slash_count
end