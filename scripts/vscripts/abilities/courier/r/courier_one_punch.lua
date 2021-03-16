LinkLuaModifier("modifier_courier_one_punch", "abilities/courier/r/courier_one_punch.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_courier_one_punch_buff", "abilities/courier/r/courier_one_punch.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if courier_one_punch == nil then
	courier_one_punch = class({})
end
function courier_one_punch:GetIntrinsicModifierName()
	return "modifier_courier_one_punch"
end
---------------------------------------------------------------------
--Modifiers
if modifier_courier_one_punch == nil then
	modifier_courier_one_punch = class({}, nil, eom_modifier)
end
function modifier_courier_one_punch:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
	end
	self:UpdateValues()
end
function modifier_courier_one_punch:OnRefresh(params)
	self:UpdateValues()
end
function modifier_courier_one_punch:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_courier_one_punch:IsHidden()
	return true
end
function modifier_courier_one_punch:UpdateValues()
	if IsServer() then
		self:OnIntervalThink()
	end
end
function modifier_courier_one_punch:OnIntervalThink()
	if IsServer() then
		if IsValid(self:GetAbility())
		and self:GetAbility():GetLevel() > 0 then
			local hCaster = self:GetCaster()
			local iPlayerID = self:GetPlayerID()
			EachUnits(iPlayerID, function(hUnit)
				self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_courier_one_punch_buff", nil)
			end, UnitType.Building)
		end
	end
end
function modifier_courier_one_punch:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned },
	}
end
function modifier_courier_one_punch:OnInBattle()
	self:OnIntervalThink()
end
function modifier_courier_one_punch:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	if iPlayerID == self:GetPlayerID()
	and IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0 then
		self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_courier_one_punch_buff", nil)
	end
end

---------------------------------------------------------------------
--Modifiers
if modifier_courier_one_punch_buff == nil then
	modifier_courier_one_punch_buff = class({}, nil, eom_modifier)
end
function modifier_courier_one_punch_buff:IsHidden()
	return true
end
function modifier_courier_one_punch_buff:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor('chance')
end
function modifier_courier_one_punch_buff:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor('chance')
end
function modifier_courier_one_punch_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
	}
end
function modifier_courier_one_punch_buff:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	if RollPercentage(self.chance) and
	not hTarget:IsBoss() and
	not hTarget:IsAncient() and
	not hTarget:IsGoldWave() and
	not (hTarget:GetUnitLabel() == "elite") and
	not Spawner:IsMobsRound() then
		hTarget:Kill(self:GetAbility(), tAttackInfo.attacker)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_attack_normal_punch.vpcf", PATTACH_ABSORIGIN, tAttackInfo.attacker)
		-- ParticleManager:SetParticleControl(iParticleID, 0, hTarget:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 2, tAttackInfo.attacker:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(iParticleID)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_punch_glove_attack.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, tAttackInfo.attacker)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		-- hTarget:AddBuff(tAttackInfo.attacker, BUFF_TYPE.STUN, self:GetAbility():GetDuration())
		tAttackInfo.attacker:EmitSound("Hero_Dark_Seer.NormalPunch.Lv3")
	end
end