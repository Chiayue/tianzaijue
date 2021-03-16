LinkLuaModifier("modifier_warlockA_2", "abilities/tower/warlockA/warlockA_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if warlockA_2 == nil then
	warlockA_2 = class({})
end
function warlockA_2:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	-- local hTarget = self:GetCursorTarget()
	self.iParticleID = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_nevermore/nevermore_wings.vpcf", hCaster), PATTACH_ABSORIGIN_FOLLOW, hCaster)
	hCaster:EmitSound("Hero_Nevermore.RequiemOfSoulsCast")
	hCaster:AddNewModifier(hCaster, self, "modifier_phased", nil)

	return true
end

function warlockA_2:OnAbilityPhaseInterrupted()
	local hCaster = self:GetCaster()

	hCaster:StopSound("Hero_Nevermore.RequiemOfSoulsCast")
	hCaster:RemoveModifierByName("modifier_phased")

	if self.iParticleID ~= nil then
		ParticleManager:DestroyParticle(self.iParticleID, true)
		self.iParticleID = nil
	end
	return true
end

function warlockA_2:OnSpellStart()
	local hCaster = self:GetCaster()

	hCaster:RemoveModifierByName("modifier_phased")

	if self.iParticleID ~= nil then
		ParticleManager:ReleaseParticleIndex(self.iParticleID)
		self.iParticleID = nil
	end

	local vStartPosition = hCaster:GetAbsOrigin()

	local requiem_radius = self:GetSpecialValueFor("requiem_radius")
	local requiem_line_width_start = self:GetSpecialValueFor("requiem_line_width_start")
	local requiem_line_width_end = self:GetSpecialValueFor("requiem_line_width_end")
	local requiem_line_speed = self:GetSpecialValueFor("requiem_line_speed")
	local damage_pct = self:GetSpecialValueFor("damage_pct")

	local iSouls = 24

	local iParticleID = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_nevermore/nevermore_requiemofsouls.vpcf", hCaster), PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vStartPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(iSouls, 0, 0))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	local hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = "models/heroes/shadow_fiend/fx_shadow_fiend_arcana_hand.vmdl", origin = vStartPosition })
	hWearable:AddEffects(EF_NODRAW)
	hWearable:GameTimer(10, function()
		UTIL_Remove(hWearable)
	end)

	hCaster:EmitSound("Hero_Nevermore.RequiemOfSouls")

	local vDiretion = Vector(1, 0, 0)
	for i = 0, iSouls - 1, 1 do
		local vTempDiretion = Rotation2D(vDiretion, math.rad(i * 360 / iSouls))

		local iParticleID = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_nevermore/nevermore_requiemofsouls_line.vpcf", hCaster), PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hWearable, PATTACH_CUSTOMORIGIN, nil, vStartPosition, false)
		ParticleManager:SetParticleControl(iParticleID, 0, vStartPosition)
		ParticleManager:SetParticleControl(iParticleID, 1, vTempDiretion * requiem_line_speed)
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(0, requiem_radius / requiem_line_speed, 0))
		ParticleManager:ReleaseParticleIndex(iParticleID)

		local tInfo = {
			Ability = self,
			Source = hCaster,
			vSpawnOrigin = vStartPosition,
			vVelocity = vTempDiretion * requiem_line_speed,
			fDistance = requiem_radius,
			fStartRadius = requiem_line_width_start,
			fEndRadius = requiem_line_width_end,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			ExtraData = {
				damage = damage_pct * 0.01 * hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack),
			-- vStartPosition = toString(vStartPosition),
			}
		}
		ProjectileManager:CreateLinearProjectile(tInfo)
	end

end

function warlockA_2:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	local hCaster = self:GetCaster()
	if IsValid(hTarget) then
		EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_Nevermore.RequiemOfSouls.Damage", hCaster)

		ApplyDamage({
			ability = self,
			attacker = hCaster,
			victim = hTarget,
			damage = ExtraData.damage,
			damage_type = DAMAGE_TYPE_MAGICAL
		})
	end
	hCaster:StopSound("Hero_Nevermore.RequiemOfSouls.Damage")
end

function warlockA_2:GetIntrinsicModifierName()
	return "modifier_warlockA_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_warlockA_2 == nil then
	modifier_warlockA_2 = class({}, nil, eom_modifier)
end
function modifier_warlockA_2:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_warlockA_2:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_warlockA_2:OnDestroy()
	if IsServer() then
	end
end
function modifier_warlockA_2:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_warlockA_2:OnDeath(params)
	-- 有队友死亡时
	if params.unit:IsFriendly(self:GetParent()) and BuildSystem:IsBuilding(params.unit) then
		if GetPlayerID(params.unit) == GetPlayerID(self:GetParent()) then
			self.unit = params.unit
			self:IncrementStackCount()
		end
	end
end
function modifier_warlockA_2:OnIntervalThink()
	if self:GetParent():IsAbilityReady(self:GetAbility()) and self:GetStackCount() >= 1 then
		ExecuteOrder(self:GetParent(), DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, self:GetAbility())
		self:SetStackCount(0)
	end
end
function modifier_warlockA_2:OnBattleEnd()
	-- 每回合清零
	self:SetStackCount(0)
end