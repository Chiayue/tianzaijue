LinkLuaModifier("modifier_sp_crystalcreep_buff", "abilities/spell/sp_crystalcreep.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_crystalcreep_buff", "abilities/spell/sp_crystalcreep.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--魂晶
if sp_crystalcreep == nil then
	sp_crystalcreep = class({}, nil, sp_base)
end
function sp_crystalcreep:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_sp_crystalcreep_buff", nil)
end
---------------------------------------------------------------------
if modifier_sp_crystalcreep_buff == nil then
	modifier_sp_crystalcreep_buff = class({}, nil, eom_modifier)
end
function modifier_sp_crystalcreep_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_sp_crystalcreep_buff:OnBattleEnd()
	if Spawner:IsBossRound() or Spawner:IsGoldRound() then return end
	self:Destroy()
end
function modifier_sp_crystalcreep_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		[EMDF_EVENT_CUSTOM] = { ET_ENEMY.ON_SPAWNED, "OnEnemySpawned" }
	}
end
function modifier_sp_crystalcreep_buff:OnEnemySpawned(tData)
	local hUnit = tData.hUnit
	if Spawner:IsBossRound() or Spawner:IsGoldRound() then return end
	if not hUnit:HasModifier("modifier_enemy_ai") then return end
	if GetPlayerID(tData.hUnit) ~= GetPlayerID(self:GetParent()) then return end
	hUnit:AddNewModifier(self:GetParent(), nil, "modifier_crystalcreep_buff", nil)
end
---------------------------------------------------------------------
if modifier_crystalcreep_buff == nil then
	modifier_crystalcreep_buff = class({}, nil, eom_modifier)
end
function modifier_crystalcreep_buff:GetTexture()
	return 'item_tome_of_knowledge'
end
function modifier_crystalcreep_buff:AddCustomTransmitterData()
	return self.tData
end
function modifier_crystalcreep_buff:HandleCustomTransmitterData(tData)
	self.tData = tData
end
function modifier_crystalcreep_buff:OnCreated(params)
	self:SetHasCustomTransmitterData(true)
	local hParent = self:GetParent()

	self:OnRefresh(params)

	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/spell/sp_crystalcreep/sp_crystalcreep_creep_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 3, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 5, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_crystalcreep_buff:OnRefresh(params)
	self.round_factor = self:GetKVSpecialValueFor("sp_crystalcreep", "round_factor")
	self.model_scale = self:GetKVSpecialValueFor("sp_crystalcreep", "model_scale")
	self.health_pct = self:GetKVSpecialValueFor("sp_crystalcreep", "health_pct")
	self.attack_pct = self:GetKVSpecialValueFor("sp_crystalcreep", "attack_pct")
	self.cyr_earn = self:GetKVSpecialValueFor("sp_crystalcreep", "cyr_earn")
	self.base_crys = self:GetKVSpecialValueFor("sp_crystalcreep", "base_crys")
	if IsServer() then
		self.crystal = self.base_crys + self.round_factor * Spawner:GetRound() * (self:GetStackCount() + 1)
		self.crystal = math.max(0, self.crystal)
		self.tData = {
			crystal = self.crystal
		}
		self:IncrementStackCount()
	end
end
function modifier_crystalcreep_buff:EDeclareFunctions()
	return {
		EMDF_STATUS_HEALTH_BONUS_PERCENTAGE,
		EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_MODEL_SCALE,
		[MODIFIER_EVENT_ON_DEATH] = {nil, self:GetParent() },
	}
end
function modifier_crystalcreep_buff:GetModifierModelScale()
	return (self.model_scale - 1) * 100 * self:GetStackCount()
end
function modifier_crystalcreep_buff:OnDeath(params)
	if params.unit == self:GetParent() and params.attacker ~= self:GetParent() then
		PlayerData:DropCrystal(GetPlayerID(params.unit), params.unit:GetAbsOrigin(), self.crystal)
	end
end
-- 属性修改
function modifier_crystalcreep_buff:GetStatusHealthBonusPercentage()
	return self.health_pct * self:GetStackCount()
end
function modifier_crystalcreep_buff:GetMagicalAttackBonusPercentage()
	return self.attack_pct * self:GetStackCount()
end
function modifier_crystalcreep_buff:GetPhysicalAttackBonusPercentage()
	return self.attack_pct * self:GetStackCount()
end

function modifier_crystalcreep_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2,
	}
end
function modifier_crystalcreep_buff:OnTooltip()
	local hParent = self:GetParent()
	self._iTooltip = ((self._iTooltip or -1) + 1) % 4
	if 0 == self._iTooltip then
		return self.tData and self.tData.crystal or 0
	elseif 1 == self._iTooltip then
		return self:GetStatusHealthBonusPercentage()
	elseif 2 == self._iTooltip then
		return self:GetPhysicalAttackBonusPercentage()
	elseif 3 == self._iTooltip then
		return self:GetMagicalAttackBonusPercentage()
	end
	return 0
end
function modifier_crystalcreep_buff:OnTooltip2()
	local hParent = self:GetParent()
	self._iTooltip2 = ((self._iTooltip2 or -1) + 1) % 3
	if 0 == self._iTooltip2 then
		return hParent:GetValByKey(ATTRIBUTE_KIND.StatusHealth, self)
	elseif 1 == self._iTooltip2 then
		return hParent:GetValByKey(ATTRIBUTE_KIND.PhysicalAttack, self)
	elseif 2 == self._iTooltip2 then
		return hParent:GetValByKey(ATTRIBUTE_KIND.MagicalAttack, self)
	end
	return 0
end