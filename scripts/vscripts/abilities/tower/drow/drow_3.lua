LinkLuaModifier("modifier_drow_3", "abilities/tower/drow/drow_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_drow_3_buff", "abilities/tower/drow/drow_3.lua", LUA_MODIFIER_MOTION_NONE)

if drow_3 == nil then
	---@type CDOTABaseAbility
	drow_3 = class({})
end
function drow_3:GetIntrinsicModifierName()
	return 'modifier_drow_3'
end


---------------------------------------------------------------------
--Modifiers
if modifier_drow_3 == nil then
	modifier_drow_3 = class({}, nil, eom_modifier)
end
function modifier_drow_3:IsHidden()
	return false
end
function modifier_drow_3:OnCreated(params)
	if IsServer() then
		self.attack_count = self:GetAbilitySpecialValueFor('attack_count')
		self.duration = self:GetAbilitySpecialValueFor('duration')
	end
end
function modifier_drow_3:OnDestroy()
	if IsServer() then
		if self.iParticleID then
			ParticleManager:DestroyParticle(self.iParticleID, false)
			self.iParticleID = nil
		end
	end
end
function modifier_drow_3:OnIntervalThink()
	if self.iParticleID then
		ParticleManager:SetParticleControlForward(self.iParticleID, 5, self:GetParent():GetForwardVector())
		ParticleManager:SetParticleControl(self.iParticleID, 5, self:GetParent():GetAttachmentOrigin(self:GetParent():ScriptLookupAttachment("attach_hitloc")))
	end
end
function modifier_drow_3:EDeclareFunctions()
	return	{
		[MODIFIER_EVENT_ON_ATTACK] = { self:GetParent() }
	}
end
function modifier_drow_3:OnAttack(params)
	if not self:GetAbility():IsCooldownReady() then return end
	if self:GetParent():PassivesDisabled() then return end
	if params.attacker:IsIllusion() then return end


	if self:GetStackCount() < self.attack_count then
		if not params.attacker:AttackFilter(params.record, ATTACK_STATE_SKIPCOUNTING) then
			self:SetStackCount(self:GetStackCount() + 1)
		end
	end

	if self:GetStackCount() >= self.attack_count then
		self:SetStackCount(0)
		self:GetAbility():UseResources(true, true, true)

		--提升队友攻击暴击
		EachUnits(GetPlayerID(self:GetParent()), function(hFriend)
			hFriend:AddNewModifier(self:GetParent(), self:GetAbility(), 'modifier_drow_3_buff', { duration = self.duration })
		end, UnitType.AllFirends)

		--特效
		if self.iParticleID then
			ParticleManager:DestroyParticle(self.iParticleID, true)
		end
		self.iParticleID = ParticleManager:CreateParticle('particles/units/heroes/drow/drow_3_wings.vpcf', PATTACH_CENTER_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlForward(self.iParticleID, 5, self:GetParent():GetForwardVector())
		ParticleManager:SetParticleControl(self.iParticleID, 5, self:GetParent():GetAttachmentOrigin(self:GetParent():ScriptLookupAttachment("attach_hitloc")))
		self:StartIntervalThink(0)
		self:GetParent():GameTimer(self:GetName() .. self:GetParent():entindex(), self.duration, function()
			if IsValid(self) and self.iParticleID then
				ParticleManager:DestroyParticle(self.iParticleID, false)
				self.iParticleID = nil
				self:StartIntervalThink(-1)
			end
		end)
	end
end

--buff
if modifier_drow_3_buff == nil then
	modifier_drow_3_buff = class({}, nil, eom_modifier)
end
function modifier_drow_3_buff:IsHidden()
	return false
end
function modifier_drow_3_buff:OnCreated(params)
	self.attack_crit_change = self:GetAbilitySpecialValueFor('attack_crit_change')
	self.attack_crit_damge = self:GetAbilitySpecialValueFor('attack_crit_damge')
	self.max_count = self:GetAbilitySpecialValueFor('max_count') or 1
	if IsServer() then
		self:SetStackCount(1)
	else
		local iParticleID = ParticleManager:CreateParticle('particles/units/heroes/drow/drow_3_buffecon/items/windrunner/drow/drow_3_buffwindrun_cascade.vpcf', PATTACH_POINT_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_drow_3_buff:OnRefresh(params)
	self.attack_crit_change = self:GetAbilitySpecialValueFor('attack_crit_change')
	self.attack_crit_damge = self:GetAbilitySpecialValueFor('attack_crit_damge')
	self.max_count = self:GetAbilitySpecialValueFor('max_count')
	if IsServer() then
		if self.max_count > self:GetStackCount() then
			self:SetStackCount(self:GetStackCount() + 1)
		end
	end
end
function modifier_drow_3_buff:EDeclareFunctions()
	return	{
		EMDF_ATTACK_CRIT_BONUS
	}
end
function modifier_drow_3_buff:GetAttackCritBonus()
	return self.attack_crit_damge, self.attack_crit_change
end
function modifier_drow_3_buff:DeclareFunctions()
	return	{
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2,
	}
end
function modifier_drow_3_buff:OnTooltip()
	return self.attack_crit_damge
end
function modifier_drow_3_buff:OnTooltip2()
	return self.attack_crit_change
end