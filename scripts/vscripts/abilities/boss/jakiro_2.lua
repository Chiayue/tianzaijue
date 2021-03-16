LinkLuaModifier("modifier_jakiro_2", "abilities/boss/jakiro_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jakiro_2_ice", "abilities/boss/jakiro_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jakiro_2_fire", "abilities/boss/jakiro_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jakiro_2_ice_status_effect", "abilities/boss/jakiro_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jakiro_2_stone_status_effect", "abilities/boss/jakiro_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jakiro_2_up", "abilities/boss/jakiro_2.lua", LUA_MODIFIER_MOTION_VERTICAL)
LinkLuaModifier("modifier_jakiro_2_respawn", "abilities/boss/jakiro_2.lua", LUA_MODIFIER_MOTION_VERTICAL)
--Abilities
if jakiro_2 == nil then
	jakiro_2 = class({})
end
function jakiro_2:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	hCaster:AddBuff(hCaster, BUFF_TYPE.TENACITY, self:GetCastPoint())
	hCaster:AddNewModifier(hCaster, self, "modifier_jakiro_2_up", { duration = self:GetCastPoint() })
	self:UseResources(false, false, true)
	return true
end
function jakiro_2:SpawnEgg(sType, vPosition)
	local hCaster = self:GetCaster()
	local boss_health_pct = self:GetSpecialValueFor("boss_health_pct")
	local sName = "dragon_egg_fire"
	local sModifierName = "modifier_jakiro_2_fire"
	local sAbilityName = "jakiro_5"
	if sType == "ice" then
		sName = "dragon_egg_ice"
		sModifierName = "modifier_jakiro_2_ice"
		sAbilityName = "jakiro_4"
	end
	local hEgg = CreateUnitByName(sName, vPosition, false, hCaster, hCaster, hCaster:GetTeamNumber())
	hEgg:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
	Attributes:Register(hEgg)
	hEgg:AddNewModifier(hCaster, self, sModifierName, nil)
	hEgg:AddAbility(sAbilityName):SetLevel(1)
	hEgg:AddAbility("jakiro_7"):SetLevel(1)
	hEgg:SetBaseMaxHealth(hCaster:GetMaxHealth() * boss_health_pct * 0.01)
	hEgg:SetMaxHealth(hEgg:GetBaseMaxHealth())
	hEgg:SetHealth(hEgg:GetBaseMaxHealth())
	-- 添加到玩家怪物列表
	Spawner:AddMissing(nil, hEgg)
	hCaster:SpawnEgg(hEgg)
	return hEgg
end
function jakiro_2:Active()
	local hCaster = self:GetCaster()
	local vCasterLoc = hCaster:GetAbsOrigin()
	local iPlayerCount = PlayerData:GetPlayerCount(true)
	local tPosition = {
		vCasterLoc + Rotation2D(Vector(1, 0, 0), math.rad(45)) * 1000,
		vCasterLoc + Rotation2D(Vector(1, 0, 0), math.rad(135)) * 1000,
		vCasterLoc + Rotation2D(Vector(1, 0, 0), math.rad(225)) * 1000,
		vCasterLoc + Rotation2D(Vector(1, 0, 0), math.rad(315)) * 1000
	}
	local tType = { "ice", "fire", "ice", "fire" }
	if iPlayerCount <= 2 then
		table.remove(tPosition, 4)
		table.remove(tPosition, 2)
		table.remove(tType, 4)
		table.remove(tType, 3)
	end
	for i, vPosition in ipairs(tPosition) do
		self:SpawnEgg(tType[i], vPosition)
	end
end
function jakiro_2:GetIntrinsicModifierName()
	return "modifier_jakiro_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_jakiro_2 == nil then
	modifier_jakiro_2 = class({}, nil, eom_modifier)
end
function modifier_jakiro_2:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		-- 记录龙蛋
		self.tEgg = {}
		hParent.SpawnEgg = function(hParent, hEgg)
			table.insert(self.tEgg, hEgg)
		end
		hParent.RemoveEgg = function(hParent, hEgg)
			ArrayRemove(self.tEgg, hEgg)
			if #self.tEgg == 0 then
				-- 蛋被击杀则重新种蛋
				-- hParent:Purge(false, true, false, true, true)
				-- ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, self:GetAbility())
				-- 持续发布指令直到种蛋成功
				self:OnIntervalThink()
				self:StartIntervalThink(1)
			end
		end
		hParent.GetActiveEgg = function(hParent)
			local tEgg = {}
			for i, hEgg in ipairs(self.tEgg) do
				if hEgg:IsActive() == true then
					table.insert(tEgg, hEgg)
				end
			end
			return tEgg
		end
		hParent.GetEgg = function(hParent)
			return self.tEgg
		end
		-- 战斗开始种蛋
		if GSManager:getStateType() == GS_Battle then
			hParent:GameTimer(FrameTime(), function()
				self:GetAbility():Active()
				-- ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, self:GetAbility())
			end)
		end
	end
end
function modifier_jakiro_2:OnRefresh(params)
	if IsServer() then
		local hParent = self:GetParent()
	end
end
function modifier_jakiro_2:IsHidden()
	return true
end
function modifier_jakiro_2:OnIntervalThink()
	local hParent = self:GetParent()
	if #self.tEgg == 0 then
		if self:GetParent():IsAlive() and hParent:IsAbilityReady(self:GetAbility()) then
			ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, self:GetAbility())
		end
	else
		self:StartIntervalThink(-1)
		return
	end
end
function modifier_jakiro_2:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH
	}
end
function modifier_jakiro_2:OnDeath(params)
	if params.unit == self:GetParent() then
		local hParent = self:GetParent()
		local tEgg = hParent:GetEgg()
		for i = #tEgg, 1, -1 do
			tEgg[i]:Active()
			tEgg[i]:ForceKill(false)
		end
	end
end
---------------------------------------------------------------------
if modifier_jakiro_2_ice == nil then
	modifier_jakiro_2_ice = class({}, nil, eom_modifier)
end
function modifier_jakiro_2_ice:IsHidden()
	return true
end
function modifier_jakiro_2_ice:IsDebuff()
	return false
end
function modifier_jakiro_2_ice:IsPurgable()
	return false
end
function modifier_jakiro_2_ice:IsPurgeException()
	return false
end
function modifier_jakiro_2_ice:IsStunDebuff()
	return false
end
function modifier_jakiro_2_ice:IsHexDebuff()
	return false
end
function modifier_jakiro_2_ice:AllowIllusionDuplicate()
	return false
end
function modifier_jakiro_2_ice:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		self.bActive = false
		hParent.Active = function(hParent)
			self.bActive = true
			self:Active()
		end
		hParent.UnActive = function(hParent)
			self.bActive = false
			self:UnActive()
		end
		hParent.IsActive = function(hParent)
			return self.bActive
		end
		-- 判断双头龙属性自动激活蛋
		if self:GetCaster().GetState and self:GetCaster():GetState() == "ice" then
			hParent:Active()
		else
			hParent:UnActive()
		end
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_jakiro_2_ice:OnDestroy()
	if IsServer() then
		self:GetCaster():RemoveEgg(self:GetParent())
		self:GetParent():AddNoDraw()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_death.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 1, self:GetParent():GetAbsOrigin())
	end
end
function modifier_jakiro_2_ice:Active()
	local hParent = self:GetParent()
	-- 移除石化状态特效
	if self.iStoneParticleID ~= nil then
		self.iStoneParticleID:Destroy()
		self.iStoneParticleID = nil
	end
	-- 添加激活特效
	if self.iParticleID == nil then
		self.iParticleID = ParticleManager:CreateParticle("particles/units/boss/jakiro/ice_egg_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControl(self.iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(self.iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		self:AddParticle(self.iParticleID, false, false, -1, false, false)
	end
	-- 添加激活状态特效
	if self.iStatusParticleID == nil then
		self.iStatusParticleID = hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_jakiro_2_ice_status_effect", nil)
	end
end
function modifier_jakiro_2_ice:UnActive()
	local hParent = self:GetParent()
	-- 移除激活特效
	if self.iParticleID ~= nil then
		ParticleManager:DestroyParticle(self.iParticleID, true)
		ParticleManager:ReleaseParticleIndex(self.iParticleID)
		self.iParticleID = nil
	end
	-- 移除激活状态特效
	if self.iStatusParticleID ~= nil then
		self.iStatusParticleID:Destroy()
		self.iStatusParticleID = nil
	end
	-- 添加石化状态特效
	if self.iStoneParticleID == nil then
		self.iStoneParticleID = hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_jakiro_2_stone_status_effect", nil)
	end
end
function modifier_jakiro_2_ice:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end
function modifier_jakiro_2_ice:GetOverrideAnimation()
	return ACT_DOTA_CAPTURE
end
function modifier_jakiro_2_ice:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_jakiro_2_ice:OnBattleEnd()
	self:GetParent():ForceKill(false)
	-- self:Destroy()
end
function modifier_jakiro_2_ice:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = self.bActive == false,
		[MODIFIER_STATE_INVULNERABLE] = self.bActive == false,
		-- [MODIFIER_STATE_FROZEN] = self.bActive == false,
		[MODIFIER_STATE_STUNNED] = self.bActive == false,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	-- [MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}
end
---------------------------------------------------------------------
if modifier_jakiro_2_fire == nil then
	modifier_jakiro_2_fire = class({}, nil, eom_modifier)
end
function modifier_jakiro_2_fire:IsHidden()
	return true
end
function modifier_jakiro_2_fire:IsDebuff()
	return false
end
function modifier_jakiro_2_fire:IsPurgable()
	return false
end
function modifier_jakiro_2_fire:IsPurgeException()
	return false
end
function modifier_jakiro_2_fire:IsStunDebuff()
	return false
end
function modifier_jakiro_2_fire:IsHexDebuff()
	return false
end
function modifier_jakiro_2_fire:AllowIllusionDuplicate()
	return false
end
function modifier_jakiro_2_fire:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		self.bActive = false
		hParent.Active = function(hParent)
			self.bActive = true
			self:Active()
		end
		hParent.UnActive = function(hParent)
			self.bActive = false
			self:UnActive()
		end
		hParent.IsActive = function(hParent)
			return self.bActive
		end
		-- 判断双头龙属性自动激活蛋
		if self:GetCaster().GetState and self:GetCaster():GetState() == "fire" then
			hParent:Active()
		else
			hParent:UnActive()
		end
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/boss/jakiro/fire_egg_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_jakiro_2_fire:OnDestroy()
	if IsServer() then
		self:GetCaster():RemoveEgg(self:GetParent())
		self:GetParent():AddNoDraw()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_death.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 1, self:GetParent():GetAbsOrigin())
	end
end
function modifier_jakiro_2_fire:Active()
	local hParent = self:GetParent()
	-- 移除石化状态特效
	if self.iStoneParticleID ~= nil then
		self.iStoneParticleID:Destroy()
		self.iStoneParticleID = nil
	end
	-- 添加激活特效
	if self.iParticleID == nil then
		self.iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControl(self.iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(self.iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControl(self.iParticleID, 2, Vector(300, 300, 300))
		ParticleManager:SetParticleControl(self.iParticleID, 3, Vector(300, 300, 300))
		self:AddParticle(self.iParticleID, false, false, -1, false, false)
	end
end
function modifier_jakiro_2_fire:UnActive()
	local hParent = self:GetParent()
	-- 移除激活特效
	if self.iParticleID ~= nil then
		ParticleManager:DestroyParticle(self.iParticleID, true)
		ParticleManager:ReleaseParticleIndex(self.iParticleID)
		self.iParticleID = nil
	end
	-- 添加石化状态特效
	if self.iStoneParticleID == nil then
		self.iStoneParticleID = hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_jakiro_2_stone_status_effect", nil)
	end
end
function modifier_jakiro_2_fire:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end
function modifier_jakiro_2_fire:GetOverrideAnimation()
	return ACT_DOTA_CAPTURE
end
function modifier_jakiro_2_fire:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_jakiro_2_fire:OnBattleEnd()
	self:GetParent():ForceKill(false)
	-- self:Destroy()
end
function modifier_jakiro_2_fire:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = self.bActive == false,
		[MODIFIER_STATE_INVULNERABLE] = self.bActive == false,
		-- [MODIFIER_STATE_FROZEN] = self.bActive == false,
		[MODIFIER_STATE_STUNNED] = self.bActive == false,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	-- [MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}
end
---------------------------------------------------------------------
if modifier_jakiro_2_ice_status_effect == nil then
	modifier_jakiro_2_ice_status_effect = class({}, nil, ModifierHidden)
end
function modifier_jakiro_2_ice_status_effect:OnCreated(params)
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_frosty_dire.vpcf", PATTACH_INVALID, self:GetParent())
		self:AddParticle(iParticleID, false, true, 100, false, false)
	end
end
---------------------------------------------------------------------
if modifier_jakiro_2_stone_status_effect == nil then
	modifier_jakiro_2_stone_status_effect = class({}, nil, ModifierHidden)
end
function modifier_jakiro_2_stone_status_effect:OnCreated(params)
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/status_effect_medusa_stone_gaze.vpcf", PATTACH_INVALID, self:GetParent())
		self:AddParticle(iParticleID, false, true, 100, false, false)
	end
end
---------------------------------------------------------------------
if modifier_jakiro_2_up == nil then
	modifier_jakiro_2_up = class({}, nil, VerticalModifier)
end
function modifier_jakiro_2_up:OnCreated(params)
	if IsServer() then
		self.vVelocity = 800
		if not self:ApplyVerticalMotionController() then
			self:Destroy()
			return
		end
	end
end
function modifier_jakiro_2_up:UpdateVerticalMotion(me, dt)
	if IsServer() then
		local vPos = me:GetAbsOrigin() + Vector(0, 0, self.vVelocity * dt)
		me:SetAbsOrigin(vPos)
	end
end
function modifier_jakiro_2_up:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_jakiro_2_up:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveVerticalMotionController(self)
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_jakiro_2_respawn", { duration = 1.3 })
	end
end
function modifier_jakiro_2_up:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	-- [MODIFIER_STATE_STUNNED] = true,
	}
end
---------------------------------------------------------------------
if modifier_jakiro_2_respawn == nil then
	modifier_jakiro_2_respawn = class({}, nil, VerticalModifier)
end
function modifier_jakiro_2_respawn:OnCreated(params)
	if IsServer() then
		self:GetParent():SetAbsOrigin(Entities:FindByNameLike(nil, BOSS_MAP_POINT_NAME):GetAbsOrigin() + Vector(0, 0, 1040))
		self.vVelocity = -800
		if not self:ApplyVerticalMotionController() then
			self:Destroy()
			return
		end
	end
end
function modifier_jakiro_2_respawn:UpdateVerticalMotion(me, dt)
	if IsServer() then
		local vPos = me:GetAbsOrigin() + Vector(0, 0, self.vVelocity * dt)
		me:SetAbsOrigin(vPos)
	end
end
function modifier_jakiro_2_respawn:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_jakiro_2_respawn:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveVerticalMotionController(self)
		local hParent = self:GetParent()
		-- 种蛋
		self:GetAbility():Active()
	end
end
function modifier_jakiro_2_respawn:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	-- [MODIFIER_STATE_STUNNED] = true,
	}
end