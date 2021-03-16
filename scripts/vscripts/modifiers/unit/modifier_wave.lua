if modifier_wave == nil then
	modifier_wave = class({}, nil, eom_modifier)
end

local public = modifier_wave

function public:IsHidden()
	return true
end
function public:IsDebuff()
	return false
end
function public:IsPurgable()
	return false
end
function public:IsPurgeException()
	return false
end
function public:AllowIllusionDuplicate()
	return false
end
function public:GetPriority()
	return -1
end
-- function public:GetEffectName()
-- 	return "maps/reef_assets/particles/reef_effects_creep.vpcf"
-- end
-- function public:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end
function public:OnCreated(params)
	local hParent = self:GetParent()
	if IsServer() then
		-- if hParent:HasFlyMovementCapability() then
		-- 	self:SetStackCount(1)
		-- 	hParent:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
		-- end
		self:CheckAllDeath()
		self.RageStartTime = Spawner.fRoundStartTime + Spawner:GetRoundData().RageStartTime
		if GameRules:GetGameTime() < self.RageStartTime then
			self:StartIntervalThink(self.RageStartTime - GameRules:GetGameTime())
		else
			self:OnIntervalThink()
			local flTime = GameRules:GetGameTime() - self.RageStartTime
			local iStack = math.floor(flTime / Spawner:GetRoundData().RageCycleTime)
			self:IncrementStackCount(iStack)
			self:StartIntervalThink(flTime - (iStack + 1) * Spawner:GetRoundData().RageCycleTime)
		end
		self.iParticleID = nil

	end
end
function public:OnIntervalThink()
	if self:GetStackCount() == 0 then
		self:IncrementStackCount()
	else
		self:SetStackCount(self:GetStackCount() * 2)
	end
	if self.iParticleID ~= nil then
		ParticleManager:DestroyParticle(self.iParticleID, false)
	end
	if Spawner:IsBossRound() then
		self.iParticleID = ParticleManager:CreateParticle("particles/units/enemy/wave_rage_boss.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.iParticleID, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
		-- self:AddParticle(self.iParticleID, false, false, -1, false, false)
	else
		self.iParticleID = ParticleManager:CreateParticle("particles/units/enemy/wave_rage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.iParticleID, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
		-- self:AddParticle(self.iParticleID, false, false, -1, false, false)
	end
	self:StartIntervalThink(Spawner:GetRoundData().RageCycleTime)
end
function public:OnDestroy()
	if IsServer() then
		Spawner:ClearEnemyOne(self:GetParent())
		if self.iParticleID ~= nil then
			ParticleManager:DestroyParticle(self.iParticleID, false)
		end
	end
end
function public:CheckState()
	return {
	-- [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end
function public:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_VISUAL_Z_DELTA,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end
function public:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE,
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() },
		[MODIFIER_EVENT_ON_DEATH] = {nil, self:GetParent() },
		[EMDF_EVENT_CUSTOM] = {
			{ ET_PLAYER.ON_TOWER_DEATH, self.CheckAllDeath },
			{ ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned },
		}
	}
end
function public:GetPhysicalAttackBonusPercentage()
	return 100 * self:GetStackCount()
end
function public:GetMagicalAttackBonusPercentage()
	return 100 * self:GetStackCount()
end
function public:OnTakeDamage(params)
	if params.unit ~= self:GetParent() then return end

	-- 计算杀怪金币修改
	if not params.unit:IsAlive() then
		local fRate = PlayerData:GetPlayerKillGoldPercentage(GetPlayerID(params.attacker), params) * 0.01
		local iGoldMin = math.floor(params.unit:GetMinimumGoldBounty() * fRate)
		params.unit:SetMinimumGoldBounty(iGoldMin)
		local iGoldMax = math.floor(params.unit:GetMaximumGoldBounty() * fRate)
		params.unit:SetMaximumGoldBounty(iGoldMax)
	end
end
-- function public:GetVisualZDelta(params)
-- 	if self:GetStackCount() == 1 then
-- 		return 128
-- 	end
-- 	return 0
-- end
function public:OnDeath(params)
	if params.unit == self:GetParent() then
		local iPlayerID = params.unit.Spawner_spawnerPlayerID
		if self:GetParent() then
			---@class EventData_EnemyDeath
			local tEventData = {
				PlayerID = iPlayerID,
				entindex_killed = params.unit:entindex(),
				entindex_attacker = params.attacker and params.attacker:entindex() or nil,
			}
			EventManager:fireEvent(ET_ENEMY.ON_DEATH, tEventData)
		end
	end
end
function public:OnTowerSpawned(tEvent)
	self:GetParent():RemoveModifierByName("modifier_movespeed_alldeath")
end
function public:CheckAllDeath()
	local iPlayerID = self:GetParent().Spawner_spawnerPlayerID
	local bAllDeath = true
	BuildSystem:EachBuilding(iPlayerID, function(hBuilding)
		if not hBuilding:IsDeath() then
			bAllDeath = false
		end
	end)

	--该玩家防御塔全部死亡
	if bAllDeath then
		self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_movespeed_alldeath", nil)
	else
		self:GetParent():RemoveModifierByName("modifier_movespeed_alldeath")
	end
end