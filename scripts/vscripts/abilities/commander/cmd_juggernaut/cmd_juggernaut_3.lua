LinkLuaModifier("modifier_cmd_juggernaut_3", "abilities/commander/cmd_juggernaut/cmd_juggernaut_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_juggernaut_3_buff", "abilities/commander/cmd_juggernaut/cmd_juggernaut_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_juggernaut_3 == nil then
	cmd_juggernaut_3 = class({})
end
function cmd_juggernaut_3:Prechace(context)
	PrecacheResource("particle", "particles/units/commander/cmd_juggernaut/cmd_juggernaut_3.vpcf", context)
end
function cmd_juggernaut_3:GetIntrinsicModifierName()
	return "modifier_cmd_juggernaut_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_juggernaut_3 == nil then
	modifier_cmd_juggernaut_3 = class({}, nil, eom_modifier)
end
function modifier_cmd_juggernaut_3:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/commander/cmd_juggernaut/cmd_juggernaut_3.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
	self:UpdateValues()
end
function modifier_cmd_juggernaut_3:OnRefresh(params)
	self:UpdateValues()
end
function modifier_cmd_juggernaut_3:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_cmd_juggernaut_3:IsHidden()
	return true
end
function modifier_cmd_juggernaut_3:UpdateValues()
	self.attack_bonus_pct = self:GetAbilitySpecialValueFor('attack_bonus_pct')
	if IsServer() then
		self:Action()
	end
end
function modifier_cmd_juggernaut_3:Action()
	if IsServer() and not self:GetParent():IsIllusion() then
		if IsValid(self:GetAbility())
		and self:GetAbility():GetLevel() > 0 then
			local hCaster = self:GetCaster()
			local iPlayerID = self:GetPlayerID()
			EachUnits(iPlayerID, function(hUnit)
				self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_cmd_juggernaut_3_buff", nil)
			end, UnitType.Building)
			-- TODO:指挥官无效
			-- local hCommander = Commander:GetCommander(iPlayerID)
			-- self.tModifiers[hCommander:entindex()] = hCommander:AddNewModifier(hCaster, self:GetAbility(), "modifier_cmd_juggernaut_3_buff", nil)
		end
	end
end
function modifier_cmd_juggernaut_3:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned },
	}
end
function modifier_cmd_juggernaut_3:OnInBattle()
	self:Action()
end
function modifier_cmd_juggernaut_3:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	if iPlayerID == self:GetPlayerID()
	and IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0 then
		self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_cmd_juggernaut_3_buff", nil)
	end
end

---------------------------------------------------------------------
--Modifiers
if modifier_cmd_juggernaut_3_buff == nil then
	modifier_cmd_juggernaut_3_buff = class({}, nil, eom_modifier)
end
function modifier_cmd_juggernaut_3_buff:OnCreated(params)
	self.health_recover = self:GetAbilitySpecialValueFor('health_recover')
	self.mana_recover = self:GetAbilitySpecialValueFor('mana_recover')
	if IsServer() then
	end
end
function modifier_cmd_juggernaut_3_buff:OnRefresh(params)
	self.health_recover = self:GetAbilitySpecialValueFor('health_recover')
	self.mana_recover = self:GetAbilitySpecialValueFor('mana_recover')
	if IsServer() then
	end
end
function modifier_cmd_juggernaut_3_buff:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_DEATH] = { self:GetParent() },
	}
end
function modifier_cmd_juggernaut_3_buff:OnDeath(params)
	local hParent = self:GetParent()
	if hParent == params.attacker then
		hParent:Heal(self.health_recover, self:GetAbility())
		hParent:GiveMana(self.mana_recover)
	end
end