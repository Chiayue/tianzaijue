if modifier_enemy_gold_ai == nil then
	modifier_enemy_gold_ai = class({}, nil, eom_modifier)
end

local public = modifier_enemy_gold_ai

function public:IsHidden()
	return true
end
function public:OnCreated(params)
	local hParent = self:GetParent()

	if IsServer() then
		local iPlayerID = GetPlayerID(hParent)

		self.tGolds = {}
		--结束时间
		local fDuration = ENEMY_GOOD_DURATION + GetGoldRoundDurationBonus(iPlayerID)
		self.fTimeEnd = GameRules:GetGameTime() + fDuration
		hParent:AddNewModifier(hParent, nil, 'modifier_duration', { duration = fDuration + ENEMY_GOOD_DEATH_DURATION, stack_count = ENEMY_GOOD_DEATH_DURATION })

		hParent:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
		hParent:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)

		--攻击玩家防御塔
		self.hTarget = Commander:GetCommander(iPlayerID) or Commander:GetTower(iPlayerID)
		hParent:SetForceAttackTarget(self.hTarget)

		self:StartIntervalThink(0)
	else
	end
	-- AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function public:OnDestroy()
	if IsServer() then
	end
	if self.nPtclIDGold then
		ParticleManager:DestroyParticle(self.nPtclIDGold, false)
	end
	-- RemoveModifierEvents(MODIFIER_EVENT_ON_ORDER, self, self:GetParent())
end
function public:OnIntervalThink()
end
function public:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true
	}
end
function public:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_EVENT_ON_STATE_CHANGED,
	}
end
function public:GetModifierMoveSpeed_Absolute()
	return 500
end
function public:OnStateChanged(params)
	if params.unit == self:GetParent() then
		if self:GetParent():IsStunned() and self.nPtclIDTP then
			--TP被打断
			ParticleManager:DestroyParticle(self.nPtclIDTP, true)
			self.nPtclIDTP = nil
			self:StartIntervalThink(0)
		end
	end
end
function public:EDeclareFunctions()
	return {
		[EMDF_STATUS_RESISTANCE_PERCENTAGE] = 100,
		EMDF_EVENT_ON_ATTACK_HIT,
	}
end
function public:GetStatusResistancePercentage()
	return 100
end
function public:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end

	local hParent = self:GetParent()
	local iPlayerID = GetPlayerID(hParent)

	--偷钱
	-- local iGold = -math.ceil(PlayerData:GetGold(iPlayerID) * 0.01 * 1)
	-- PlayerData:ModifyGold(iPlayerID, iGold)
	-- table.insert(self.tGolds, iGold)
	--
	-- local iParticleID = ParticleManager:CreateParticle("particles/units/gold/take_gold.vpcf", PATTACH_CUSTOMORIGIN, nil)
	-- ParticleManager:SetParticleControl(iParticleID, 0, hTarget:GetAbsOrigin())
	-- ParticleManager:SetParticleControlEnt(iParticleID, 0, hTarget, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
	-- ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), true)
	-- ParticleManager:ReleaseParticleIndex(iParticleID)
	-- local iParticleID = ParticleManager:CreateParticle('particles/units/heroes/hero_bounty_hunter/bounty_hunter_jinda_slow.vpcf', PATTACH_ABSORIGIN_FOLLOW, hTarget)
	-- ParticleManager:SetParticleControlEnt(iParticleID, 2, hParent, PATTACH_CUSTOMORIGIN_FOLLOW, nil, hParent:GetAbsOrigin(), true)
	-- ParticleManager:ReleaseParticleIndex(iParticleID)
	-- self:IncrementStackCount()
end
function public:OnStackCountChanged(iStackCount)
	local hParent = self:GetParent()
	if IsServer() then
		--5次开始传送
		if 5 == self:GetStackCount() then
			hParent:SetForceAttackTarget(nil)
			hParent:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
			self:TP()
		end
	else
		if self.nPtclIDGold then
			ParticleManager:DestroyParticle(self.nPtclIDGold, true)
		end
		self.nPtclIDGold = ParticleManager:CreateParticle("particles/units/gold/take_gold_on_haed.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.nPtclIDGold, 1, Vector(self:GetStackCount(), 0, 0))
		for i = 1, 5 do
			ParticleManager:SetParticleControl(self.nPtclIDGold, 8 + i, Vector(i <= self:GetStackCount() and 1 or 0, 0, 0))
		end
	end
end
function public:TP()
	local hParent = self:GetParent()

	self.iTPEndTime = GameRules:GetGameTime() + ENEMY_GOOD_TP_DURATION
	local vColor = Vector(255, 255, 255) / 255

	self.nPtclIDTP = ParticleManager:CreateParticle("particles/items2_fx/teleport_start.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(self.nPtclIDTP, 0, hParent:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.nPtclIDTP, 2, vColor)
	self:AddParticle(self.nPtclIDTP, false, false, -1, false, false)

	-- hParent:EmitSound("Portal.Loop_Disappear")
	hParent:Stop()
end
function public:OnIntervalThink()
	local hParent = self:GetParent()

	--时间结束
	if self.fTimeEnd <= GameRules:GetGameTime() then
		if hParent:HasModifier('modifier_ghost_enemy') then
			self:GetParent():ForceKill(true)
		else
			--石化，3秒后死亡
			hParent:AddNewModifier(hParent, nil, 'modifier_ghost_enemy', {})
			self:StartIntervalThink(ENEMY_GOOD_DEATH_DURATION)

			-- local iTime = math.min(0.25, ENEMY_GOOD_DEATH_DURATION / self:GetStackCount())
			-- local iGoldCount = self:GetStackCount()
			-- hParent:GameTimer(0, function()
			-- 	local iGold = self.tGolds[iGoldCount]
			-- 	if iGold then
			-- 		local iPlayerID = GetPlayerID(hParent)
			-- 		local hHero = PlayerData:GetHero(iPlayerID)
			-- 		if IsValid(hHero) then
			-- 			local iParticleID = ParticleManager:CreateParticle("particles/units/gold/take_gold.vpcf", PATTACH_CUSTOMORIGIN, nil)
			-- 			ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
			-- 			ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), true)
			-- 			ParticleManager:SetParticleControlEnt(iParticleID, 1, hHero, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", hHero:GetAbsOrigin(), true)
			-- 			ParticleManager:ReleaseParticleIndex(iParticleID)
			-- 		end
			-- 		PlayerData:ModifyGold(iPlayerID, -iGold)
			-- 	end
			-- 	iGoldCount = iGoldCount - 1
			-- 	if 1 <= iGoldCount then
			-- 		return iTime
			-- 	end
			-- end)
		end
	else
		if self.nPtclIDTP then

			--TP中
			if self.iTPEndTime <= GameRules:GetGameTime() then
				--TP完成
				-- hParent:StopSound("Portal.Loop_Disappear")
				EmitSoundOnLocationWithCaster(hParent:GetAbsOrigin(), "Portal.Hero_Disappear", hParent)

				--宝箱怪逃脱，相当于进入传送门
				EventManager:fireEvent(ET_ENEMY.ON_ENTER_DOOR, {
					entindex = hParent:entindex()
				})

				-- local iGoldLost = 0
				-- for _, iGold in pairs(self.tGolds) do
				-- 	iGoldLost = iGoldLost + math.abs(iGold)
				-- end
				-- PlayerData:SetPlayerGoldRoundLost(self:GetParent().Spawner_spawnerPlayerID, Spawner:GetRound(), iGoldLost)
				self:GetParent():AddNoDraw()
				self:GetParent():ForceKill(true)
			end
		elseif self:GetStackCount() >= 5 then
			--没在TP，未被控制就TP
			if not (self:GetParent():IsStunned()) then
				self:TP()
			end
		end
	end
end