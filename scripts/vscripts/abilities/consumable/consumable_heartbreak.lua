LinkLuaModifier("modifier_consumable_heartbreak", "abilities/consumable/consumable_heartbreak.lua", LUA_MODIFIER_MOTION_NONE)
--心跳停止
--Abilities
if consumable_heartbreak == nil then
	consumable_heartbreak = class({})
end

function consumable_heartbreak:Precache(context)
	PrecacheResource("particle", "particles/econ/items/witch_doctor/wd_ti8_immortal_head/wd_ti8_immortal_maledict_aoe.vpcf", context)
	-- PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_keeper_of_the_light.vsndevts", context)
end
function consumable_heartbreak:Spawn()
	if IsServer() then
		self.tUnits = {}
	end
end

function consumable_heartbreak:CastFilterResult()

	if IsServer() then
		local hCaster = self:GetCaster()
		local iPlayerID = GetPlayerID(hCaster)

		if GSManager:getStateType() ~= GS_Battle then
			ErrorMessage(GetPlayerID(self:GetCaster()), 'dota_hud_error_use_when_battle')
			return UF_FAIL_CUSTOM
		end

		if Spawner:IsGoldRound() then
			ErrorMessage(GetPlayerID(self:GetCaster()), 'dota_hud_error_disabled_item')
			return UF_FAIL_CUSTOM
		end
	end

	return UF_SUCCESS
end
function consumable_heartbreak:GetCustomCastError()
	return " "
end
function consumable_heartbreak:GetAbilityTextureName()
	return C_DOTA_Ability_Lua.GetAbilityTextureName(self)
end

function consumable_heartbreak:OnSpellStart()
	local hCaster = self:GetCaster()
	local iPlayerID = GetPlayerID(hCaster)

	local hHero = PlayerData:GetHero(iPlayerID)

	EachUnits(iPlayerID, function(hUnit)
		if hUnit:IsAlive() and not hUnit:IsBoss() then
			if not hUnit:IsGoldWave() then
				local iParticleID = ParticleManager:CreateParticle("particles/econ/items/witch_doctor/wd_ti8_immortal_head/wd_ti8_immortal_maledict_aoe.vpcf", PATTACH_ABSORIGIN_FOLLOW, hUnit)
				ParticleManager:SetParticleControlEnt(iParticleID, 0, hUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", hUnit:GetAbsOrigin(), false)
				ParticleManager:SetParticleControl(iParticleID, 1, Vector(100, 0, 0))
				if not hUnit:IsElite() then
					hUnit:ModifyHealth(1, self, false, 0)
				else
					hUnit:ModifyHealth(hUnit:GetHealth() * 0.5, self, false, 0)
				end
			end
		end
	end, UnitType.AllEnemies)
end