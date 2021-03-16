LinkLuaModifier("modifier_contract_neutral_angle", "abilities/contract/contract_neutral_angle.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_contract_neutral_angle_buff", "abilities/contract/contract_neutral_angle.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if contract_neutral_angle == nil then
	contract_neutral_angle = class({})
end
function contract_neutral_angle:Precache(context)
	PrecacheResource("particle", "particles/units/enemy/contract_neutral_angle.vpcf", context)
end
function contract_neutral_angle:Spawn()
	self.tUnit = {}
end
function contract_neutral_angle:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	local iParticleID = ParticleManager:CreateParticle("particles/units/enemy/contract_neutral_angle.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:AddBuff(self:GetCaster(), BUFF_TYPE.TENACITY, self:GetChannelTime())
	return true
end
function contract_neutral_angle:OnChannelFinish(bInterrupted)
	local hCaster = self:GetCaster()
	hCaster:FadeGesture(ACT_DOTA_TELEPORT)
	hCaster:StartGesture(ACT_DOTA_TELEPORT_END)
	if bInterrupted == false then
		local vStart = hCaster:GetAbsOrigin()
		local radius = self:GetSpecialValueFor("radius")
		local count = self:GetSpecialValueFor("count")
		local hp_pct = self:GetSpecialValueFor("hp_pct")
		for i = #self.tUnit, 1, -1 do
			if count > 0 then
				count = count - 1
				local v = self.tUnit[i]
				if (vStart - v.vPosition):Length2D() < radius then
					-- 复活
					local hUnit = Spawner:CreateWave(v.sUnitName, v.vPosition, v.vDirection, GetPlayerID(hCaster))
					hUnit:ModifyHealth(hUnit:GetVal(ATTRIBUTE_KIND.StatusHealth) * hp_pct * 0.01, self, false, 0)
					hUnit:AddNewModifier(hCaster, self, "modifier_contract_neutral_angle_buff", nil)
					self:GetIntrinsicModifier():IncrementStackCount()
				end
				table.remove(self.tUnit, i)
			end
		end
		EachUnits(GetPlayerID(hCaster), function(hUnit)
			if not hUnit:IsAlive() and hUnit:IsConsideredHero() and CalculateDistance(hCaster, hUnit) then
				hUnit:GetBuilding():RespawnBuildingUnit()
				hUnit:AddNewModifier(hCaster, self, "modifier_contract_neutral_angle_buff", nil)
				hUnit:ModifyHealth(hUnit:GetVal(ATTRIBUTE_KIND.StatusHealth) * hp_pct * 0.01, self, false, 0)
				self:GetIntrinsicModifier():IncrementStackCount()
			end
		end, UnitType.Building)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_guardian_angel_ally.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		hCaster:EmitSound("Hero_Omniknight.GuardianAngel.Cast")
		self.tUnit = {}
	end
end
function contract_neutral_angle:GetIntrinsicModifierName()
	return "modifier_contract_neutral_angle"
end
---------------------------------------------------------------------
--Modifiers
if modifier_contract_neutral_angle == nil then
	modifier_contract_neutral_angle = class({}, nil, eom_modifier)
end
function modifier_contract_neutral_angle:OnCreated(params)
	self.threshold = self:GetAbilitySpecialValueFor("threshold")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.atkspd_bonus = self:GetAbilitySpecialValueFor("atkspd_bonus")
	if IsServer() then
		self:StartIntervalThink(self.threshold)
	end
end
function modifier_contract_neutral_angle:OnRefresh(params)
	self.threshold = self:GetAbilitySpecialValueFor("threshold")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.atkspd_bonus = self:GetAbilitySpecialValueFor("atkspd_bonus")
	if IsServer() then
	end
end
function modifier_contract_neutral_angle:OnIntervalThink()
	ExecuteOrder(self:GetParent(), DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, self:GetAbility())
end
function modifier_contract_neutral_angle:EDeclareFunctions()
	return {
		[EMDF_EVENT_CUSTOM] = { ET_ENEMY.ON_DEATH, self.OnDeath },
		EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE
	}
end
function modifier_contract_neutral_angle:GetAttackSpeedPercentage()
	return self:GetStackCount() * self.atkspd_bonus
end
function modifier_contract_neutral_angle:OnDeath(params)
	if params.PlayerID == GetPlayerID(self:GetParent()) then
		local hUnit = EntIndexToHScript(params.entindex_killed)
		table.insert(self:GetAbility().tUnit, {
			vPosition = hUnit:GetAbsOrigin(),
			sUnitName = hUnit:GetUnitName(),
			vDirection = hUnit:GetForwardVector()
		})
	end
end
---------------------------------------------------------------------
if modifier_contract_neutral_angle_buff == nil then
	modifier_contract_neutral_angle_buff = class({}, nil, eom_modifier)
end
function modifier_contract_neutral_angle_buff:OnCreated(params)
	self.attack_bonus = self:GetAbilitySpecialValueFor("attack_bonus")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_guardian_angel_ally.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_contract_neutral_angle_buff:EDeclareFunctions()
	return {
		[EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE] = self.attack_bonus,
		[EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE] = self.attack_bonus,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_contract_neutral_angle_buff:OnBattleEnd()
	self:Destroy()
end