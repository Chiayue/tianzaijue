LinkLuaModifier("modifier_techies_1_burrow", "abilities/tower/techies/techies_1.lua", LUA_MODIFIER_MOTION_VERTICAL)
LinkLuaModifier("modifier_techies_1_buff", "abilities/tower/techies/techies_1.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_techies_1_mine", "abilities/tower/techies/techies_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_techies_1_thinker", "abilities/tower/techies/techies_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_techies_1_debuff", "abilities/tower/techies/techies_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if techies_1 == nil then
	techies_1 = class({}, nil, ability_base_ai)
end
function techies_1:GetAOERadius()
	return self:GetCastRange(vec3_invalid, nil)
end
function techies_1:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_techies_1_burrow", { duration = self:GetCastPoint() })
	return true
end
function techies_1:OnAbilityPhaseInterrupted()
	self:GetCaster():RemoveModifierByName("modifier_techies_1_burrow")
end
function techies_1:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_techies_1_buff", nil)
end
---------------------------------------------------------------------
--Modifiers
if modifier_techies_1_burrow == nil then
	modifier_techies_1_burrow = class({}, nil, VerticalModifier)
end
function modifier_techies_1_burrow:OnCreated(params)
	if IsServer() then
		if not self:ApplyVerticalMotionController() then
			self:Destroy()
		end
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/boss/sand_king/nyx_assassin_burrow.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_techies_1_burrow:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveVerticalMotionController(self)
	end
end
function modifier_techies_1_burrow:OnVerticalMotionInterrupted()
	self:Destroy()
end
function modifier_techies_1_burrow:UpdateVerticalMotion(me, dt)
	if self:GetElapsedTime() > 0.25 then
		me:SetAbsOrigin(me:GetAbsOrigin() - Vector(0, 0, 3))
	end
end
---------------------------------------------------------------------
if modifier_techies_1_buff == nil then
	modifier_techies_1_buff = class({}, nil, HorizontalModifier)
end
function modifier_techies_1_buff:IsHidden()
	return true
end
function modifier_techies_1_buff:OnCreated(params)
	self.mine_count = self:GetAbilitySpecialValueFor("mine_count")			-- 地雷数量
	self.delay = self:GetAbilitySpecialValueFor("delay")					-- 地雷爆炸延迟
	self.search_radius = self:GetAbilitySpecialValueFor("search_radius")	-- 搜寻敌人范围
	self.path_radius = self:GetAbilitySpecialValueFor("path_radius")
	if IsServer() then
		local hParent = self:GetParent()
		hParent:AddNoDraw()

		self.vStartPosition = hParent:GetAbsOrigin()

		self.tTargets = {}		-- 记录遇到的单位
		self.hTarget = nil		-- 记录当前目标
		self.iSpeed = 600		-- 移动速度

		self.iCount = 1			-- 标记是否准备好地雷
		self.flInterval = 0.2	-- 放地雷最低间隔

		self.tHitTargets = {}	-- 穿刺单位

		-- 创建地道马甲
		self.hThinker = CreateModifierThinker(hParent, self:GetAbility(), "modifier_techies_1_thinker", nil, hParent:GetAbsOrigin(), hParent:GetTeamNumber(), false)
		if not self:ApplyHorizontalMotionController() then
			self:Destroy()
		end
	else
		-- local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/techies/techies_1_ground.vpcf", PATTACH_CUSTOMORIGIN, nil)
		-- ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, hParent:GetAbsOrigin(), false)
		-- self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_techies_1_buff:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)
		self:GetParent():RemoveNoDraw()
		self:GetParent():RemoveModifierByName("modifier_channel")
		self:GetParent():StartGesture(ACT_DOTA_SPAWN)
		-- 通知地道马甲
		if self.hThinker then
			self.hThinker:FindModifierByName("modifier_techies_1_thinker"):ForceRefresh()
		end
	end
end
function modifier_techies_1_buff:OnIntervalThink()
	self.iCount = 1
	self.hThinker:FindModifierByName("modifier_techies_1_thinker"):OnFire()
	self:StartIntervalThink(-1)
	return
end
function modifier_techies_1_buff:OnHorizontalMotionInterrupted()
	self:Destroy()
end
function modifier_techies_1_buff:End()
	-- 找一个附近的位置出来
	self.bEnd = true
	self.iSpeed = self.iSpeed * 2
	self.vPosition = self.vStartPosition
	-- for i = 1, 4 do
	-- 	if not GridNav:CanFindPath(self:GetParent():GetAbsOrigin(), self.vPosition) then
	-- 		self.vPosition = RotatePosition(self:GetParent():GetAbsOrigin(), QAngle(0, 90, 0), self.vPosition)
	-- 	end
	-- end
end
function modifier_techies_1_buff:UpdateHorizontalMotion(me, dt)
	-- 结束状态
	if self.bEnd then
		local vStart = me:GetAbsOrigin()
		local vDirection = (self.vPosition - me:GetAbsOrigin()):Normalized()
		local vEnd = me:GetAbsOrigin() + vDirection * self.iSpeed * dt
		me:SetAbsOrigin(vEnd)

		-- 掘地穿刺
		local techies_3 = me:FindAbilityByName("techies_3")
		if IsValid(techies_3) and techies_3:GetLevel() > 0 then
			local tTargets = FindUnitsInLineWithAbility(me, vStart, vEnd, self.path_radius, self:GetAbility())
			for _, hTarget in pairs(tTargets) do
				if TableFindKey(self.tHitTargets, hTarget) == nil then
					techies_3:Trigger(hTarget)
				end
			end
			self.tHitTargets = tTargets
		end

		if (self.vPosition - me:GetAbsOrigin()):Length2D() < 50 then
			self:Destroy()
		end
		return
	end
	if self.hTarget == nil or not IsValid(self.hTarget) or not self.hTarget:IsAlive() then
		local tTargets = FindUnitsInRadiusWithAbility(me, me:GetAbsOrigin(), self.search_radius, self:GetAbility(), FIND_CLOSEST)
		-- 没有单位就停止
		if #tTargets == 0 then
			self:End()
		end
		-- 移除遇到过的单位
		for _, hUnit in pairs(self.tTargets) do
			ArrayRemove(tTargets, hUnit)
		end
		if IsValid(tTargets[1]) then
			-- 选择最近的单位
			self.hTarget = tTargets[1]
		else
			-- 剩余炸弹则清空遇到过的单位，可以重复炸同个单位
			if self.mine_count > 0 then
				self.tTargets = {}
			else
				self:End()
			end
		end
	else
		local vStart = me:GetAbsOrigin()
		local vDirection = CalculateDirection(self.hTarget, me)
		local vEnd = me:GetAbsOrigin() + vDirection * self.iSpeed * dt
		me:SetAbsOrigin(vEnd)

		-- 掘地穿刺
		local techies_3 = me:FindAbilityByName("techies_3")
		if IsValid(techies_3) and techies_3:GetLevel() > 0 then
			local tTargets = FindUnitsInLineWithAbility(me, vStart, vEnd, self.path_radius, self:GetAbility())
			for _, hTarget in pairs(tTargets) do
				if TableFindKey(self.tHitTargets, hTarget) == nil then
					techies_3:Trigger(hTarget)
				end
			end
			self.tHitTargets = tTargets
		end

		if CalculateDistance(self.hTarget, me) < 10 and self.iCount >= 1 then
			-- 埋雷音效
			me:EmitSound("Hero_Techies.LandMine.Plant")
			-- 地雷单位
			CreateModifierThinker(me, self:GetAbility(), "modifier_techies_1_mine", { duration = self.delay }, me:GetAbsOrigin(), me:GetTeamNumber(), false)
			-- 埋雷间隔
			self.iCount = 0
			self:StartIntervalThink(self.flInterval)
			-- 记录单位
			table.insert(self.tTargets, self.hTarget)
			self.hTarget = nil
			-- 计算地雷数量
			self.mine_count = self.mine_count - 1
			if self.mine_count <= 0 then
				self:End()
			end
		end
	end
end
function modifier_techies_1_buff:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
end
---------------------------------------------------------------------
if modifier_techies_1_mine == nil then
	modifier_techies_1_mine = class({}, nil, ParticleModifierThinker)
end
function modifier_techies_1_mine:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_land_mine_move_idle.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_techies_1_mine:OnDestroy()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if IsServer() then
		if IsValid(hCaster) and IsValid(hAbility) then
			local tTargets = FindUnitsInRadiusWithAbility(hCaster, hParent:GetAbsOrigin(), self.radius, hAbility)
			hCaster:DealDamage(tTargets, hAbility, 0)
		end
		hParent:EmitSound("Hero_Techies.LandMine.Detonate")
		if IsValid(hParent) then
			hParent:RemoveSelf()
		end
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
---------------------------------------------------------------------
if modifier_techies_1_thinker == nil then
	modifier_techies_1_thinker = class({}, nil, ParticleModifierThinker)
end
function modifier_techies_1_thinker:IsAura()
	return true
end
function modifier_techies_1_thinker:GetAuraRadius()
	return -1
end
function modifier_techies_1_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_techies_1_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end
function modifier_techies_1_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_techies_1_thinker:GetModifierAura()
	return "modifier_techies_1_debuff"
end
function modifier_techies_1_thinker:GetAuraEntityReject(hEntity)
	if TableFindKey(self.tUnitInPath, hEntity) then
		return false
	end
	return true
end
function modifier_techies_1_thinker:IsHidden()
	return true
end
function modifier_techies_1_thinker:OnCreated(params)
	self.path_radius = self:GetAbilitySpecialValueFor("path_radius")
	if IsServer() then
		self.tUnitInPath = {}			-- 记录在路径上的单位
		self.vCenter = Vector(0, 0, 0)	-- 记录中心位置
		self.flRadius = 0				-- 记录半径
		self.tLocation = {				-- 记录路径点
			self:GetCaster():GetAbsOrigin()
		}
		self.bEnd = false				-- 工程师是否停止挖地道
		self:StartIntervalThink(1 / 15)
		-- 路径特效
		self.iParticleID = ParticleManager:CreateParticle("particles/units/heroes/techies/techies_1_ground.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(self.iParticleID, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), false)
		self:AddParticle(self.iParticleID, false, false, -1, false, false)
		if self:GetCaster():HasModifier("modifier_techies_2") then
			self.bFire = false	-- 是否点燃
			-- 火焰特效
			self.iParticleFireID = ParticleManager:CreateParticle("particles/units/heroes/techies/techies_2.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(self.iParticleFireID, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), false)
			ParticleManager:SetParticleControlEnt(self.iParticleFireID, 3, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), false)
			ParticleManager:SetParticleControl(self.iParticleFireID, 11, Vector(0, 0, 0))
			self:AddParticle(self.iParticleFireID, false, false, -1, false, false)
		end

	end
end
function modifier_techies_1_thinker:OnRemoved()
	if IsServer() then
		ParticleManager:SetParticleControl(self.iParticleID, 3, Vector(0, 0, -30))
	end
end
function modifier_techies_1_thinker:OnFire()
	if self.bFire == false then
		self.bFire = true
		ParticleManager:SetParticleControl(self.iParticleFireID, 11, Vector(200, 0, 0))
	end
end
function modifier_techies_1_thinker:OnRefresh(params)
	if IsServer() then
		self.bEnd = true
		ParticleManager:SetParticleControl(self.iParticleID, 1, Vector(1, 0, 0))	-- 停止产生路径特效
		self:SetDuration(self:GetAbility():GetDuration(), true)
	end
end
function modifier_techies_1_thinker:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	if not IsValid(hCaster) then
		self:Destroy()
	end
	-- 记录新的坐标
	if self.bEnd == false and hCaster:GetAbsOrigin() ~= self.tLocation[#self.tLocation] then
		table.insert(self.tLocation, hCaster:GetAbsOrigin())
		self.vCenter = Vector(0, 0, 0)
		for i = 1, #self.tLocation do
			self.vCenter.x = self.vCenter.x + self.tLocation[i].x
			self.vCenter.y = self.vCenter.y + self.tLocation[i].y
		end
		self.vCenter = Vector(self.vCenter.x / #self.tLocation, self.vCenter.y / #self.tLocation, 0, hCaster:GetAbsOrigin().z)
		self.flRadius = 0
		for i = 1, #self.tLocation do
			self.flRadius = math.max(self.flRadius, (self.tLocation[i] - self.vCenter):Length2D())
		end
	end
	-- DebugDrawCircle(self.vCenter, Vector(0, 255, 255), 32, self.flRadius, true, 1 / 15)
	-- 更新路径中的单位
	local tUnitInPath = {}
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, self.vCenter, self.flRadius + self.path_radius, self:GetAbility())
	if tTargets ~= nil then
		for i = #tTargets, 1, -1 do
			local hUnit = tTargets[i]
			if hUnit then
				for i = 1, #self.tLocation do
					if (hUnit:GetAbsOrigin() - self.tLocation[i]):Length2D() < self.path_radius then
						table.insert(tUnitInPath, hUnit)
					end
				end
			end
		end
		self.tUnitInPath = tUnitInPath
	end
end
---------------------------------------------------------------------
if modifier_techies_1_debuff == nil then
	modifier_techies_1_debuff = class({}, nil, eom_modifier)
end
function modifier_techies_1_debuff:IsDebuff()
	return true
end
function modifier_techies_1_debuff:OnCreated(params)
	self.movespeed_reduce = self:GetAbilitySpecialValueFor("movespeed_reduce")
	if IsServer() then
		if self:GetAbility():GetCaster():HasModifier("modifier_techies_2") then
			self:StartIntervalThink(0.2)
		end
	end
end
function modifier_techies_1_debuff:OnIntervalThink()
	if self:GetAbility():GetCaster():FindAbilityByName("techies_2") then
		self:GetAbility():GetCaster():FindAbilityByName("techies_2"):OnSpellStart(self:GetParent())
	end
end
function modifier_techies_1_debuff:EDeclareFunctions()
	return {
		[EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE] = -self.movespeed_reduce
	}
end
function modifier_techies_1_debuff:GetMoveSpeedBonusPercentage()
	return -self.movespeed_reduce
end
function modifier_techies_1_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_VISUAL_Z_DELTA
	}
end
function modifier_techies_1_debuff:GetVisualZDelta()
	if self:GetElapsedTime() <= 0.25 then
		return RemapValClamped(self:GetElapsedTime(), 0, 0.25, 0, -50)
	end
	return -50
end