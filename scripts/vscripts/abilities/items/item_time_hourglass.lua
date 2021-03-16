LinkLuaModifier("modifier_item_time_hourglass_motion", "abilities/items/item_time_hourglass.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
---时间沙漏
if nil == item_time_hourglass then
	item_time_hourglass = class({}, nil, base_ability_attribute)
end
function item_time_hourglass:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_time_hourglass then
	modifier_item_time_hourglass = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_time_hourglass:IsHidden()
	return true
end
function modifier_item_time_hourglass:UpdateValues()
	self.back_time = self:GetAbilitySpecialValueFor('back_time')
	self.duration = self:GetAbilitySpecialValueFor('duration')
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
end
function modifier_item_time_hourglass:OnCreated(params)
	self:UpdateValues()
	if IsServer() then
		self.tRestoreData = {}
		self:UpdateRestoreData()
	end
end
function modifier_item_time_hourglass:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_time_hourglass:UpdateRestoreData()
	-- 更新回溯数据
	table.insert(self.tRestoreData, {
		flTime = GameRules:GetGameTime(),
		vPosition = self:GetParent():GetAbsOrigin(),
		flHealth = self:GetParent():GetHealth(),
		flMana = self:GetParent():GetMana()
	})
	for i = #self.tRestoreData, 1, -1 do
		if self.tRestoreData[i].flTime + self.back_time < GameRules:GetGameTime() then
			table.remove(self.tRestoreData, i)
		end
	end
end
function modifier_item_time_hourglass:OnIntervalThink()
	local hParent = self:GetParent()
	self:UpdateRestoreData()
end

function modifier_item_time_hourglass:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() },
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_item_time_hourglass:OnInBattle()
	self.tRestoreData = {
		{
			flTime = GameRules:GetGameTime(),
			vPosition = self:GetParent():GetAbsOrigin(),
			flHealth = self:GetParent():GetHealth(),
			flMana = self:GetParent():GetMana()
		}
	}
	self:StartIntervalThink(0.1)
end
function modifier_item_time_hourglass:OnBattleEnd()
	self:StartIntervalThink(-1)
end
function modifier_item_time_hourglass:OnTakeDamage(params)
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if hAbility:IsCooldownReady() and hParent:IsAlive() then
		hAbility:UseResources(false, false, true)
		local tRestoreData = self.tRestoreData[1]
		if tRestoreData.flHealth > hParent:GetHealth() then
			hParent:ModifyHealth(tRestoreData.flHealth, hAbility, false, 0)
		end
		if tRestoreData.flMana > hParent:GetMana() then
			hParent:GiveMana(tRestoreData.flMana - hParent:GetMana())
		end
		for i = 0, 3 do
			local hAbilityIterator = hParent:GetAbilityByIndex(i)
			if IsValid(hAbilityIterator) and hAbilityIterator:GetCooldownTimeRemaining() > 0 then
				local flCooldown = hAbilityIterator:GetCooldownTimeRemaining()
				hAbilityIterator:EndCooldown()
				if flCooldown - self.back_time > 0 then
					hAbilityIterator:StartCooldown(flCooldown - self.back_time)
				end
			end
		end
		hParent:AddNewModifier(hParent, hAbility, "modifier_item_time_hourglass_motion", { duration = 0.3, position = tRestoreData.vPosition })
	end
end
---------------------------------------------------------------------
if modifier_item_time_hourglass_motion == nil then
	modifier_item_time_hourglass_motion = class({}, nil, HorizontalModifier)
end
function modifier_item_time_hourglass_motion:GetStatusEffectName()
	return "particles/status_fx/status_effect_faceless_timewalk.vpcf"
end
function modifier_item_time_hourglass_motion:StatusEffectPriority()
	return 10
end
function modifier_item_time_hourglass_motion:GetEffectName()
	return "particles/econ/items/faceless_void/faceless_void_jewel_of_aeons/fv_time_walk_jewel.vpcf"
end
function modifier_item_time_hourglass_motion:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_item_time_hourglass_motion:OnCreated(params)
	self.cooldown_add = self:GetAbilitySpecialValueFor("cooldown_add")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
		self.vEndPosition = StringToVector(params.position)
		if not self.vEndPosition then
			self:Destroy()
			return
		end
		local vForward = (self.vEndPosition - self:GetParent():GetAbsOrigin()):Normalized()
		vForward.z = 0
		-- self:GetParent():SetForwardVector(vForward)
		if self:ApplyHorizontalMotionController() then
			self.vStartPosition = self:GetParent():GetAbsOrigin()
		else
			self:Destroy()
		end
	end
end
function modifier_item_time_hourglass_motion:OnDestroy(params)
	local hParent = self:GetParent()
	if IsServer() then
		hParent:RemoveHorizontalMotionController(self)
		hParent:Purge(false, true, false, true, true)
		-- 锁定附近敌人
		if self:GetAbility():GetLevel() >= self.unlock_level then
			local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
			for _, hUnit in pairs(tTargets) do
				hUnit:AddBuff(hParent, BUFF_TYPE.LOCK, self.duration)
				if not hUnit:IsBoss() then
					for i = 0, 10 do
						local hAbility = hUnit:GetAbilityByIndex(i)
						if IsValid(hAbility) and not hAbility:IsCooldownReady() then
							local flCooldown = hAbility:GetCooldownTimeRemaining() + self.cooldown_add
							hAbility:EndCooldown()
							hAbility:StartCooldown(flCooldown)
						end
					end
				end
			end
			hParent:EmitSound("Hero_FacelessVoid.TimeDilation.Cast.ti7")
		end
	else
		if self:GetAbility():GetLevel() >= self.unlock_level then
			local iParticleID = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_timedialate.vpcf", PATTACH_ABSORIGIN, hParent)
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, 0, 0))
			self:AddParticle(iParticleID, false, false, -1, false, false)
		end
	end
end
function modifier_item_time_hourglass_motion:UpdateHorizontalMotion(hParent, dt)
	if IsServer() then
		local fPercent = Clamp(self:GetDuration() == 0 and 0 or self:GetElapsedTime() / self:GetDuration(), 0, 1)
		hParent:SetAbsOrigin(VectorLerp(fPercent, self.vStartPosition, self.vEndPosition))
	end
end
function modifier_item_time_hourglass_motion:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_item_time_hourglass_motion:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
end



AbilityClassHook('item_time_hourglass', getfenv(1), 'abilities/items/item_time_hourglass.lua', { KeyValues.ItemsKv })