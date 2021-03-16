LinkLuaModifier("modifier_rattletrap_1", "abilities/tower/rattletrap/rattletrap_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rattletrap_1_buff", "abilities/tower/rattletrap/rattletrap_1.lua", LUA_MODIFIER_MOTION_NONE)

if rattletrap_1 == nil then
	rattletrap_1 = class({})
end
function rattletrap_1:GetIntrinsicModifierName()
	return "modifier_rattletrap_1"
end
function rattletrap_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hModifier = hCaster:FindModifierByName("modifier_rattletrap_1")
	hCaster:AddNewModifier(hCaster, self, "modifier_rattletrap_1_buff", {duration = self:GetDuration(), stack = hModifier:GetStackCount()})
	hModifier:SetStackCount(0)
	-- 技能3
	local hAbility = hCaster:FindAbilityByName("rattletrap_3")
	if IsValid(hAbility) and hAbility:GetLevel() > 0 then
		hCaster:FindModifierByName("modifier_rattletrap_3"):Refresh()
	end
end

---------------------------------------------------------------------
--Modifiers
if modifier_rattletrap_1 == nil then
	modifier_rattletrap_1 = class({}, nil, BaseModifier)
end
function modifier_rattletrap_1:IsHidden()
	if self:GetParent():HasModifier("modifier_rattletrap_1_buff") or self:GetStackCount() == 0 then
		return true
	end
	return false
end
function modifier_rattletrap_1:OnCreated(params)
	self.max_stack = self:GetAbilitySpecialValueFor("max_stack")
	if IsServer() then
		self:StartIntervalThink(0)
	end
	AddModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self)
end
function modifier_rattletrap_1:OnIntervalThink()
	if self:GetParent():IsAbilityReady(self:GetAbility()) then
		ExecuteOrder(self:GetParent(), DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, self:GetAbility())
	end
end
function modifier_rattletrap_1:OnRefresh(params)
	self.max_stack = self:GetAbilitySpecialValueFor("max_stack")
	if IsServer() then
	end
end
function modifier_rattletrap_1:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self)
end
function modifier_rattletrap_1:OnTakeDamage(params)
	local hParent = params.unit
	if hParent == self:GetParent() and self:GetStackCount() < self.max_stack then
		self:IncrementStackCount()
	end
end
---------------------------------------------------------------------
if modifier_rattletrap_1_buff == nil then
	modifier_rattletrap_1_buff = class({}, nil, BaseModifier)
end
function modifier_rattletrap_1_buff:OnCreated(params)
	self.regen_pct = self:GetAbilitySpecialValueFor("regen_pct")
	if IsServer() then
		self:SetStackCount(params.stack)
		self:GetParent():EmitSound("Hero_Rattletrap.Battery_Assault")
	end
	if IsClient() then
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/items5_fx/repair_kit_ancient_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_OVERHEAD_FOLLOW, nil, hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_OVERHEAD_FOLLOW, nil, hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 2, hParent, PATTACH_OVERHEAD_FOLLOW, nil, hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, true)
		
		-- iParticleID = ParticleManager:CreateParticle("particles/items5_fx/repair_kit_regen.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		-- ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_ABSORIGIN, nil, hParent:GetAbsOrigin(), false)
		-- ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_ABSORIGIN, nil, hParent:GetAbsOrigin(), false)
		-- ParticleManager:SetParticleControlEnt(iParticleID, 2, hParent, PATTACH_ABSORIGIN, nil, hParent:GetAbsOrigin(), false)
		-- self:AddParticle(iParticleID, false, false, -1, false, true)
		iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/clock_overclock_buff.vpcf", PATTACH_CENTER_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, true)
	end
end
function modifier_rattletrap_1_buff:OnRefresh(params)
	self.regen_pct = self:GetAbilitySpecialValueFor("regen_pct")
end
function modifier_rattletrap_1_buff:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Hero_Rattletrap.Battery_Assault")
	end
end
function modifier_rattletrap_1_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
end
function modifier_rattletrap_1_buff:GetModifierHealthRegenPercentage()
	return self.regen_pct * self:GetStackCount()
end