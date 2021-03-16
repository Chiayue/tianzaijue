LinkLuaModifier("modifier_vengeful_2", "abilities/tower/vengeful/vengeful_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_vengeful_2_wall", "abilities/tower/vengeful/vengeful_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_vengeful_2_wall_debuff", "abilities/tower/vengeful/vengeful_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if vengeful_2 == nil then
	vengeful_2 = class({}, nil, ability_base_ai)
end
function vengeful_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()

	local width = self:GetSpecialValueFor('width')
	local vDir = (vPosition - hCaster:GetAbsOrigin()):Normalized()
	local vLeft = vPosition + RotatePosition(Vector(0, 0, 0), QAngle(0, -90, 0), vDir) * width / 2
	local vRight = vPosition + RotatePosition(Vector(0, 0, 0), QAngle(0, 90, 0), vDir) * width / 2
	CreateModifierThinker(hCaster, self, "modifier_vengeful_2_wall", { duration = self:GetDuration(), vEnd_x = vRight.x, vEnd_y = vRight.y }, vLeft, hCaster:GetTeamNumber(), false)
	hCaster:AddNewModifier(hCaster, self, "modifier_vengeful_2_short_hop", { duration = jump_duration, distance = (vPosition - hCaster:GetAbsOrigin()):Length2D() })
end
function vengeful_2:GetIntrinsicModifierName()
	return "modifier_vengeful_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_vengeful_2 == nil then
	modifier_vengeful_2 = class({}, nil, BaseModifier)
end
function modifier_vengeful_2:OnCreated(params)
	self.jump_horizontal_distance = self:GetAbilitySpecialValueFor('jump_horizontal_distance')
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_vengeful_2:OnIntervalThink()
	if self:GetParent():IsAbilityReady(self:GetAbility()) then
		local tTargets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if IsValid(tTargets[1]) then
			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = self:GetAbility():entindex(),
				Position = tTargets[1]:GetAbsOrigin()
			})
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_vengeful_2_wall == nil then
	modifier_vengeful_2_wall = class({}, nil, ParticleModifierThinker)
end
function modifier_vengeful_2_wall:OnCreated(params)
	self.duration = self:GetAbilitySpecialValueFor('duration')
	if IsServer() then
		self.vStart = self:GetParent():GetAbsOrigin()
		self.vEnd = Vector(params.vEnd_x, params.vEnd_y, self:GetParent():GetAbsOrigin().z)
		self:StartIntervalThink(0)
		local iNormal = self.vEnd.x < self.vStart.x and 1 or -1
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/vengeful_2.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 0, self.vStart)
		ParticleManager:SetParticleControl(iParticleID, 1, self.vEnd)
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(200, iNormal, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_vengeful_2_wall:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	if not IsValid(hCaster) or not IsValid(self:GetAbility()) then
		self:Destroy()
		return
	end
	local tTargets = FindUnitsInLine(hCaster:GetTeamNumber(), self.vStart, self.vEnd, nil, 50, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE)
	for _, hUnit in pairs(tTargets) do
		hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_vengeful_2_wall_debuff", { duration = self.duration })
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_vengeful_2_wall_debuff == nil then
	modifier_vengeful_2_wall_debuff = class({}, nil, eom_modifier)
end
function modifier_vengeful_2_wall_debuff:IsDebuff()
	return true
end
function modifier_vengeful_2_wall_debuff:OnCreated(params)
	self.movespeed_reduce = self:GetAbilitySpecialValueFor('movespeed_reduce')
	self.armor_reduce = self:GetAbilitySpecialValueFor('armor_reduce')
	if IsServer() then
	end
end
function modifier_vengeful_2_wall_debuff:OnDestroy()
	if IsServer() then
	end
end
function modifier_vengeful_2_wall_debuff:EDeclareFunctions()
	return {
		[EMDF_PHYSICAL_ARMOR_BONUS] = -self.armor_reduce,
		[EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE] = -self.movespeed_reduce,
	}
end
function modifier_vengeful_2_wall_debuff:GetPhysicalArmorBonus()
	return -self.armor_reduce
end
function modifier_vengeful_2_wall_debuff:GetMoveSpeedBonusPercentage()
	return -self.movespeed_reduce
end