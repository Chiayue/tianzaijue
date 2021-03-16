LinkLuaModifier("modifier_consumable_hero_help", "abilities/consumable/consumable_hero_help.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_consumable_hero_help_buff", "abilities/consumable/consumable_hero_help.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if consumable_hero_help == nil then
	consumable_hero_help = class({})
end

function consumable_hero_help:Spawn()
	if IsServer() then
		self.tUnits = {}
	end
end

function consumable_hero_help:CastFilterResult()

	if IsServer() then
		local hCaster = self:GetCaster()
		local iPlayerID = GetPlayerID(hCaster)
		if GSManager:getStateType() ~= GS_Battle then
			ErrorMessage(GetPlayerID(self:GetCaster()), 'dota_hud_error_use_when_battle')
			return UF_FAIL_CUSTOM
		end
		local beRespawn = false
		DotaTD:EachPlayer(function(_, iPlayerID)
			if not PlayerData:IsPlayerDeath(iPlayerID) then
				EachUnits(iPlayerID, function(hUnit)
					if hUnit:IsConsideredHero() and not hUnit:IsAlive() then
						beRespawn = true
					end
				end, UnitType.Building)
			end
		end)

		if beRespawn == true then
			return UF_SUCCESS
		else
			ErrorMessage(GetPlayerID(self:GetCaster()), 'dota_hud_error_no_units_die')
			return UF_FAIL_CUSTOM
		end
	end
end
-- function consumable_hero_help:GetAbilityTextureName()
-- 	return C_DOTA_Ability_Lua.GetAbilityTextureName(self)
-- end
-- function consumable_hero_help:GetIntrinsicModifierName()
-- 	return "modifier_consumable_hero_help"
-- end
function consumable_hero_help:OnSpellStart()
	local hCaster = self:GetCaster()
	local iPlayerID = GetPlayerID(hCaster)

	local hHero = PlayerData:GetHero(iPlayerID)
	DotaTD:EachPlayer(function(_, iPlayerID)
		if not PlayerData:IsPlayerDeath(iPlayerID) then
			EachUnits(iPlayerID, function(hUnit)
				if hUnit:IsConsideredHero() and not hUnit:IsAlive() then
					local iParticleID = ParticleManager:CreateParticle("particles/items_fx/aegis_respawn_timer.vpcf", PATTACH_ABSORIGIN, hUnit)
					ParticleManager:SetParticleControlEnt(iParticleID, 0, hUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", hUnit:GetAbsOrigin(), false)
					ParticleManager:ReleaseParticleIndex(iParticleID)
					hUnit:GetBuilding():RespawnBuildingUnit()
					if IsValid(hUnit) then
						hUnit:AddNewModifier(hUnit, self, 'modifier_consumable_hero_help', { duration = self:GetSpecialValueFor('duration') })
					end

				end
			end, UnitType.Building)
		end
	end)
	-- 发送全屏播报
	local tParams = {
		player_id = GetPlayerID(hCaster),
		sConsumable = self:GetEntityIndex(),
		message = "#Consumable_Use",
	}
	CustomGameEventManager:Send_ServerToAllClients("notification_consumable_use", tParams)


end

-- ---------------------------------------------------------------------
-- --Modifiers
if modifier_consumable_hero_help == nil then
	modifier_consumable_hero_help = class({}, nil, eom_modifier)
end
function modifier_consumable_hero_help:OnCreated(params)
	self.incoming_reduce = self:GetAbilitySpecialValueFor('incoming_reduce')
	if IsServer() then
	end
end
function modifier_consumable_hero_help:OnRefresh(params)
	self.incoming_reduce = self:GetAbilitySpecialValueFor('incoming_reduce')
	if IsServer() then
	end
end
function modifier_consumable_hero_help:OnDestroy()
	if IsServer() then
	end
end
function modifier_consumable_hero_help:EDeclareFunctions()
	return {
		[EMDF_INCOMING_PERCENTAGE] = -self.incoming_reduce
	}
end
function modifier_consumable_hero_help:GetIncomingPercentage()
	return -self.incoming_reduce
end