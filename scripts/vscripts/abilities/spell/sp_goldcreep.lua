LinkLuaModifier("modifier_sp_goldcreep_buff", "abilities/spell/sp_goldcreep.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_goldchallenge_buff", "abilities/spell/sp_goldcreep.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--金币挑战怪
if sp_goldcreep == nil then
	sp_goldcreep = class({}, nil, sp_base)
end
function sp_goldcreep:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_sp_goldcreep_buff", nil)
end
---------------------------------------------------------------------
if modifier_sp_goldcreep_buff == nil then
	modifier_sp_goldcreep_buff = class({}, nil, eom_modifier)
end
function modifier_sp_goldcreep_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_sp_goldcreep_buff:OnBattleEnd()
	if Spawner:IsBossRound() or Spawner:IsGoldRound() then return end
	self:Destroy()
end
function modifier_sp_goldcreep_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		[EMDF_EVENT_CUSTOM] = { ET_ENEMY.ON_SPAWNED, "OnEnemySpawned" }
	}
end
function modifier_sp_goldcreep_buff:OnEnemySpawned(tData)
	local hUnit = tData.hUnit
	if Spawner:IsBossRound() or Spawner:IsGoldRound() then return end
	if not hUnit:HasModifier("modifier_enemy_ai") then return end
	if GetPlayerID(tData.hUnit) ~= GetPlayerID(self:GetParent()) then return end
	hUnit:AddNewModifier(self:GetParent(), nil, "modifier_goldchallenge_buff", nil)
end
---------------------------------------------------------------------
if modifier_goldchallenge_buff == nil then
	modifier_goldchallenge_buff = class({}, nil, eom_modifier)
end
function modifier_goldchallenge_buff:GetTexture()
	return 'buyback'
end
function modifier_goldchallenge_buff:AddCustomTransmitterData()
	return self.tData
end
function modifier_goldchallenge_buff:HandleCustomTransmitterData(tData)
	self.tData = tData
end
function modifier_goldchallenge_buff:OnCreated(params)
	self:SetHasCustomTransmitterData(true)
	local hParent = self:GetParent()

	self:OnRefresh(params)

	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/spell/sp_goldcreep/sp_goldcreep_creep_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 3, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 5, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_goldchallenge_buff:OnRefresh(params)
	local hParent = self:GetParent()
	self.model_scale = self:GetKVSpecialValueFor('sp_goldcreep', "model_scale")
	self.health_pct = self:GetKVSpecialValueFor('sp_goldcreep', "health_pct")
	self.attack_pct = self:GetKVSpecialValueFor('sp_goldcreep', "attack_pct")
	self.chance = self:GetKVSpecialValueFor('sp_goldcreep', "chance")
	self.gold_earn_factor = self:GetKVSpecialValueFor('sp_goldcreep', "gold_earn_factor")
	self.round_factor = self:GetKVSpecialValueFor('sp_goldcreep', "round_factor")
	self.base_gold = self:GetKVSpecialValueFor('sp_goldcreep', "base_gold")

	if IsServer() then
		local iMaxGold = hParent:GetMaximumGoldBounty()
		self.gold = self.base_gold + self.round_factor * Spawner:GetRound() + iMaxGold * self.gold_earn_factor * (self:GetStackCount() + 1)
		self.gold = math.max(0, self.gold)
		self.tData = {
			gold = self.gold
		}
		self:IncrementStackCount()
	end
end
function modifier_goldchallenge_buff:EDeclareFunctions()
	return {
		EMDF_STATUS_HEALTH_BONUS_PERCENTAGE,
		EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_MODEL_SCALE,
		[MODIFIER_EVENT_ON_DEATH] = {nil, self:GetParent() },
	}
end
function modifier_goldchallenge_buff:GetModifierModelScale()
	return (self.model_scale - 1) * 100 * self:GetStackCount()
end
function modifier_goldchallenge_buff:OnDeath(params)
	local hParent = self:GetParent()
	if params.unit ~= hParent then return end
	if params.attacker == hParent then return end
	if IsServer() then
		local vDrop = hParent:GetAbsOrigin()
		PlayerData:DropGold(GetPlayerID(hParent), vDrop, self.gold)
		if RollPercentage(self.chance) then
			PlayerData:DropGoldChest(GetPlayerID(hParent), vDrop, vDrop, 1)
		end
	end
end
-- 属性修改
function modifier_goldchallenge_buff:GetStatusHealthBonusPercentage()
	return self.health_pct * self:GetStackCount()
end
function modifier_goldchallenge_buff:GetMagicalAttackBonusPercentage()
	return self.attack_pct * self:GetStackCount()
end
function modifier_goldchallenge_buff:GetPhysicalAttackBonusPercentage()
	return self.attack_pct * self:GetStackCount()
end

function modifier_goldchallenge_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2,
	}
end
function modifier_goldchallenge_buff:OnTooltip()
	local hParent = self:GetParent()
	self._iTooltip = ((self._iTooltip or -1) + 1) % 4
	if 0 == self._iTooltip then
		return self.tData and self.tData.gold or 0
	elseif 1 == self._iTooltip then
		return self:GetStatusHealthBonusPercentage()
	elseif 2 == self._iTooltip then
		return self:GetPhysicalAttackBonusPercentage()
	elseif 3 == self._iTooltip then
		return self:GetMagicalAttackBonusPercentage()
	end
	return 0
end
function modifier_goldchallenge_buff:OnTooltip2()
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