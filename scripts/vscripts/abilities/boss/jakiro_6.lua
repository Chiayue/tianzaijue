LinkLuaModifier("modifier_jakiro_6", "abilities/boss/jakiro_6.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_jakiro_6_up", "abilities/boss/jakiro_6.lua", LUA_MODIFIER_MOTION_VERTICAL)
LinkLuaModifier("modifier_jakiro_6_respawn", "abilities/boss/jakiro_6.lua", LUA_MODIFIER_MOTION_VERTICAL)
--Abilities
if jakiro_6 == nil then
	jakiro_6 = class({})
end
function jakiro_6:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()

	self:GetCaster():AddActivityModifier("corkscrew_gesture")
	self:GetCaster():StartGesture(ACT_DOTA_TAUNT)
	-- hCaster:AddBuff(hCaster, BUFF_TYPE.TENACITY, self:GetCastPoint())
	-- hCaster:AddNewModifier(hCaster, self, "modifier_jakiro_6_up", {duration = self:GetCastPoint()})
	return true
end
function jakiro_6:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:RemoveActivityModifier("corkscrew_gesture")
	-- 激活蛋
	local tEgg = hCaster:GetEgg()
	for i, hEgg in ipairs(tEgg) do
		hEgg:Active()
		ExecuteOrder(hEgg, DOTA_UNIT_ORDER_CAST_POSITION, nil, hEgg:GetAbilityByIndex(1), hCaster:GetAbsOrigin())
	end
	-- hCaster:AddNewModifier(hCaster, self, "modifier_jakiro_6_respawn", {duration = 1.3})
end
function jakiro_6:GetIntrinsicModifierName()
	return "modifier_jakiro_6"
end
---------------------------------------------------------------------
--Modifiers
if modifier_jakiro_6 == nil then
	modifier_jakiro_6 = class({}, nil, ModifierHidden)
end
function modifier_jakiro_6:OnCreated(params)
	self.trigger_pct = self:GetAbilitySpecialValueFor("trigger_pct")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_jakiro_6:OnIntervalThink()
	local hParent = self:GetParent()
	if hParent:IsAbilityReady(self:GetAbility()) and hParent:GetHealthPercent() <= self.trigger_pct then
		hParent:Purge(false, true, false, true, true)
		ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, self:GetAbility())
	end
end
---------------------------------------------------------------------
if modifier_jakiro_6_up == nil then
	modifier_jakiro_6_up = class({}, nil, VerticalModifier)
end
function modifier_jakiro_6_up:OnCreated(params)
	if IsServer() then
		self.vVelocity = 800
		if not self:ApplyVerticalMotionController() then
			self:Destroy()
			return
		end
	end
end
function modifier_jakiro_6_up:UpdateVerticalMotion(me, dt)
	if IsServer() then
		local vPos = me:GetAbsOrigin() + Vector(0, 0, self.vVelocity * dt)
		me:SetAbsOrigin(vPos)
	end
end
function modifier_jakiro_6_up:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_jakiro_6_up:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveVerticalMotionController(self)
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_jakiro_6_respawn", { duration = 1.3 })
		-- 此处进入cd
		self:GetAbility():UseResources(false, false, true)
	end
end
function modifier_jakiro_6_up:CheckState()
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
if modifier_jakiro_6_respawn == nil then
	modifier_jakiro_6_respawn = class({}, nil, VerticalModifier)
end
function modifier_jakiro_6_respawn:OnCreated(params)
	if IsServer() then

		self:GetParent():SetAbsOrigin(Entities:FindByNameLike(nil, BOSS_MAP_POINT_NAME):GetAbsOrigin() + Vector(RandomInt(-1000, 1000), RandomInt(-1000, 1000), 1040))
		self.vVelocity = -800
		if not self:ApplyVerticalMotionController() then
			self:Destroy()
			return
		end
	end
end
function modifier_jakiro_6_respawn:UpdateVerticalMotion(me, dt)
	if IsServer() then
		local vPos = me:GetAbsOrigin() + Vector(0, 0, self.vVelocity * dt)
		me:SetAbsOrigin(vPos)
	end
end
function modifier_jakiro_6_respawn:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_jakiro_6_respawn:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveVerticalMotionController(self)
		local hParent = self:GetParent()
		-- 激活蛋
		local tEgg = hParent:GetEgg()
		for i, hEgg in ipairs(tEgg) do
			hEgg:Active()
			ExecuteOrder(hEgg, DOTA_UNIT_ORDER_CAST_POSITION, nil, hEgg:GetAbilityByIndex(1), hParent:GetAbsOrigin())
		end
	end
end
function modifier_jakiro_6_respawn:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	-- [MODIFIER_STATE_STUNNED] = true,
	}
end