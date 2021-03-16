LinkLuaModifier( "modifier_golemC_2", "abilities/tower/golemC/golemC_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_golemC_2_debuff", "abilities/tower/golemC/golemC_2.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if golemC_2 == nil then
	golemC_2 = class({})
end
function golemC_2:GetIntrinsicModifierName()
	return "modifier_golemC_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_golemC_2 == nil then
	modifier_golemC_2 = class({}, nil, BaseModifier)
end
function modifier_golemC_2:IsAura()
	return true
end
function modifier_golemC_2:GetAuraRadius()
	return -1
end
function modifier_golemC_2:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_golemC_2:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end
function modifier_golemC_2:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_golemC_2:GetModifierAura()
	return "modifier_golemC_2_debuff"
end
function modifier_golemC_2:GetAuraEntityReject(hEntity)
	if (hEntity:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() < self.radius or TableFindKey(self.tUnitInPath, hEntity) then
		return false
	end
	return true
end
function modifier_golemC_2:IsHidden()
	return true
end
function modifier_golemC_2:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.path_radius = self:GetAbilitySpecialValueFor("path_radius")
	if IsServer() then
		self.tUnitInPath = {}
		self.flDuration = self:GetAbility():GetDuration()
		self.tLocation = {{
			flDieTime = GameRules:GetGameTime() + self.flDuration,
			vLocation = self:GetParent():GetAbsOrigin()
		}}
		self:StartIntervalThink(1/15)
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/spectre/spectre_transversant_soul/spectre_ti7_crimson_spectral_dagger_path_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_golemC_2:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.path_radius = self:GetAbilitySpecialValueFor("path_radius")
	if IsServer() then
	end
end
function modifier_golemC_2:OnDestroy()
	if IsServer() then
	end
end
function modifier_golemC_2:OnIntervalThink()
	local hParent = self:GetParent()
	-- 记录新的坐标
	if self:GetParent():GetAbsOrigin() ~= self.tLocation[#self.tLocation] then
		table.insert(self.tLocation, {
			flDieTime = GameRules:GetGameTime() + self.flDuration,
			vLocation = self:GetParent():GetAbsOrigin()
		})
	end
	-- 清除过期坐标
	for i = #self.tLocation, 1, -1 do
		if GameRules:GetGameTime() > self.tLocation[i].flDieTime then
			table.remove(self.tLocation, i)
		end
	end
	local vCenter = Vector(0,0,0)
	for i = 1, #self.tLocation do
		vCenter.x = vCenter.x + self.tLocation[i].vLocation.x
		vCenter.y = vCenter.y + self.tLocation[i].vLocation.y
	end
	vCenter = Vector(vCenter.x / #self.tLocation, vCenter.y / #self.tLocation, 0, hParent:GetAbsOrigin().z)
	-- DebugDrawCircle(vCenter, Vector(0, 255, 255), 32, 64, true, 0.5)
	local flRadius = 0
	for i = 1, #self.tLocation do
		flRadius = math.max(flRadius, (self.tLocation[i].vLocation - vCenter):Length2D())
	end
	local tUnitInPath = {}
	local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), vCenter, nil, flRadius + self.path_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for i = #tTargets, 1, -1 do
		local hUnit = tTargets[i]
		for i = 1, #self.tLocation do
			if (hUnit:GetAbsOrigin() - self.tLocation[i].vLocation):Length2D() < self.path_radius then
				table.insert(tUnitInPath, hUnit)
			end
		end
	end
	self.tUnitInPath = tUnitInPath
end
---------------------------------------------------------------------
if modifier_golemC_2_debuff == nil then
	modifier_golemC_2_debuff = class({})
end
function modifier_golemC_2_debuff:IsDebuff()
	return true
end
function modifier_golemC_2_debuff:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_golemC_2_debuff:OnIntervalThink()
	if not IsValid(self:GetCaster()) or not IsValid(self:GetAbility()) then
		self:Destroy()
		return
	end
	local tDamageInfo = {
		attacker = self:GetCaster(),
		victim = self:GetParent(),
		ability = self:GetAbility(),
		damage = self:GetAbility():GetAbilityDamage(),
		damage_type = DAMAGE_TYPE_MAGICAL,
	}
	ApplyDamage(tDamageInfo)
end