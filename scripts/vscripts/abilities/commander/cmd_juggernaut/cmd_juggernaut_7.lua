LinkLuaModifier("modifier_cmd_juggernaut_7", "abilities/commander/cmd_juggernaut/cmd_juggernaut_7.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_juggernaut_7_buff", "abilities/commander/cmd_juggernaut/cmd_juggernaut_7.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_juggernaut_7 == nil then
	cmd_juggernaut_7 = class({})
end
function cmd_juggernaut_7:GetIntrinsicModifierName()
	return "modifier_cmd_juggernaut_7"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_juggernaut_7 == nil then
	modifier_cmd_juggernaut_7 = class({}, nil, eom_modifier)
end
function modifier_cmd_juggernaut_7:IsHidden()
	return true
end
function modifier_cmd_juggernaut_7:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
	end
	self:UpdateValues()
end
function modifier_cmd_juggernaut_7:OnRefresh(params)
	self:UpdateValues()
end
function modifier_cmd_juggernaut_7:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_cmd_juggernaut_7:IsHidden()
	return true
end
function modifier_cmd_juggernaut_7:UpdateValues()
	if IsServer() then
		self:OnIntervalThink()
	end
end
function modifier_cmd_juggernaut_7:OnIntervalThink()
	if IsServer() and not self:GetParent():IsIllusion() then
		if IsValid(self:GetAbility())
		and self:GetAbility():GetLevel() > 0 then
			local hCaster = self:GetCaster()
			local iPlayerID = self:GetPlayerID()
			EachUnits(iPlayerID, function(hUnit)
				self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_cmd_juggernaut_7_buff", nil)
			end, UnitType.Building)
			-- local hCommander = Commander:GetCommander(iPlayerID)
			-- self.tModifiers[hCommander:entindex()] = hCommander:AddNewModifier(hCaster, self:GetAbility(), "modifier_cmd_juggernaut_7_buff", nil)
		end
	end
end
function modifier_cmd_juggernaut_7:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned },
	}
end
function modifier_cmd_juggernaut_7:OnInBattle()
	self:OnIntervalThink()
end
function modifier_cmd_juggernaut_7:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	if iPlayerID == self:GetPlayerID()
	and IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0 then
		self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_cmd_juggernaut_7_buff", nil)
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_juggernaut_7_buff == nil then
	modifier_cmd_juggernaut_7_buff = class({}, nil, eom_modifier)
end
function modifier_cmd_juggernaut_7_buff:OnCreated(params)
	self.count = self:GetAbilitySpecialValueFor('count')
	self.cd = self:GetAbilitySpecialValueFor('cd')
	if IsServer() then
		self:SetStackCount(self.count)
		self.iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_refraction.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.iParticleID, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "", self:GetParent():GetAbsOrigin(), false)
		self:AddParticle(self.iParticleID, false, false, -1, false, false)
	end
end
function modifier_cmd_juggernaut_7_buff:OnRefresh(params)
	self.count = self:GetAbilitySpecialValueFor('count')
	self.cd = self:GetAbilitySpecialValueFor('cd')
	if IsServer() then
	end
end
function modifier_cmd_juggernaut_7_buff:OnIntervalThink()
	if IsServer() then
		if self:GetParent():GetHealthPercent() == 100 then
			self.iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_refraction.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControlEnt(self.iParticleID, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "", self:GetParent():GetAbsOrigin(), false)
			self:AddParticle(self.iParticleID, false, false, -1, false, false)
			self:SetStackCount(self.count)
			self:StartIntervalThink(-1)
		else
			self:StartIntervalThink(1)
		end
	end
end
function modifier_cmd_juggernaut_7_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE,
	}
end
function modifier_cmd_juggernaut_7_buff:GetModifierAvoidDamage(params)
	if IsServer() then
		if self:GetStackCount() > 0 and params.damage > 0 then
			self:DecrementStackCount()
			if self:GetStackCount() == 0 then
				ParticleManager:DestroyParticle(self.iParticleID, false)
				self:StartIntervalThink(self.cd)
			end
			return 1
		end
	end
end
function modifier_cmd_juggernaut_7_buff:IsHidden()
	return true
end