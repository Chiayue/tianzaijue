LinkLuaModifier("modifier_cmd_centaur_2", "abilities/commander/cmd_centaur/cmd_centaur_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_centaur_2_buff", "abilities/commander/cmd_centaur/cmd_centaur_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_centaur_2 == nil then
	cmd_centaur_2 = class({})
end
function cmd_centaur_2:GetIntrinsicModifierName()
	return "modifier_cmd_centaur_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_centaur_2 == nil then
	modifier_cmd_centaur_2 = class({}, nil, eom_modifier)
end
function modifier_cmd_centaur_2:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
	end
	self:UpdateValues()
end
function modifier_cmd_centaur_2:OnRefresh(params)
	self:UpdateValues()
end
function modifier_cmd_centaur_2:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_cmd_centaur_2:IsHidden()
	return true
end
function modifier_cmd_centaur_2:UpdateValues()
	if IsServer() then
		self:OnIntervalThink()
	end
end
function modifier_cmd_centaur_2:OnIntervalThink()
	if IsServer() and not self:GetParent():IsIllusion() then
		if IsValid(self:GetAbility())
		and self:GetAbility():GetLevel() > 0 then
			local hCaster = self:GetCaster()
			-- local iPlayerID = self:GetPlayerID()
			DotaTD:EachPlayer(function(_, iPlayerID)
				EachUnits(iPlayerID, function(hUnit)
					self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_cmd_centaur_2_buff", nil)
				end, UnitType.Building)
			end, UnitType.Building)
			-- TODO:指挥官无效
			-- local hCommander = Commander:GetCommander(iPlayerID)
			-- self.tModifiers[hCommander:entindex()] = hCommander:AddNewModifier(hCaster, self:GetAbility(), "modifier_cmd_centaur_2_buff", nil)
		end
	end
end
function modifier_cmd_centaur_2:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned },
		[EMDF_EVENT_CUSTOM] = { ET_GAME.ON_SUMMONED, self.OnSummoned },
	}
end
function modifier_cmd_centaur_2:OnInBattle()
	print("bigciba", "OnInBattle")
	self:OnIntervalThink()
end
function modifier_cmd_centaur_2:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	if IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0 then
		self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_cmd_centaur_2_buff", nil)
	end
end
function modifier_cmd_centaur_2:OnSummoned(tEvent)
	local hUnit = tEvent.target

	if IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0 then
		self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_cmd_centaur_2_buff", nil)
	end
end

---------------------------------------------------------------------
--Modifiers
if modifier_cmd_centaur_2_buff == nil then
	modifier_cmd_centaur_2_buff = class({}, nil, eom_modifier)
end
function modifier_cmd_centaur_2_buff:OnCreated(params)
	self.max_hp_pct = self:GetAbilitySpecialValueFor('max_hp_pct')
	if IsServer() then
	end
end
function modifier_cmd_centaur_2_buff:OnRefresh(params)
	if self:GetAbilitySpecialValueFor('max_hp_pct') > self.max_hp_pct then
		self.max_hp_pct = self:GetAbilitySpecialValueFor('max_hp_pct')
	end
	if IsServer() then
	end
end
function modifier_cmd_centaur_2_buff:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() },
	}
end
function modifier_cmd_centaur_2_buff:OnTakeDamage(params)
	if params.unit ~= self:GetParent() then
		return
	end
	if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION and params.unit ~= params.attacker then
		local hParent = self:GetParent()
		local flDamage = self:GetCaster():GetMaxHealth() * self.max_hp_pct * 0.01
		hParent:DealDamage(params.attacker, self:GetAbility(), flDamage, nil, params.damage_flags + DOTA_DAMAGE_FLAG_REFLECTION)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_return.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, params.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", params.attacker:GetAbsOrigin(), false)
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end