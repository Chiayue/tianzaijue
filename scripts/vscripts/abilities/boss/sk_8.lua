LinkLuaModifier("modifier_sk_8", "abilities/boss/sk_8.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sk_8_buff", "abilities/boss/sk_8.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sk_8 == nil then
	sk_8 = class({})
end
function sk_8:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_sk_8_buff", { duration = self:GetChannelTime() })
	hCaster:AddBuff(hCaster, BUFF_TYPE.TENACITY, self:GetChannelTime())
end
function sk_8:OnChannelFinish(bInterrupted)
	if bInterrupted then
		self:GetCaster():RemoveModifierByName("modifier_sk_8_buff")
		self:GetCaster():RemoveModifierByName(BUFF_TYPE.TENACITY)
	end
end
function sk_8:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	local hCaster = self:GetCaster()
	if hTarget == nil then
		ParticleManager:DestroyParticle(ExtraData.iParticleID, false)
	else
		hCaster:DealDamage(hTarget, self, self:GetAbilityDamage())
		-- 击退
		local vDirection = Vector(ExtraData.vDirX, ExtraData.vDirY, 0)
		local knockback_duration = self:GetSpecialValueFor("knockback_duration")
		local knockback_distance = self:GetSpecialValueFor("knockback_distance")
		hCaster:KnockBack(vLocation, hTarget, knockback_distance, 0, knockback_duration, true)
	end
end
function sk_8:GetIntrinsicModifierName()
	return "modifier_sk_8"
end
---------------------------------------------------------------------
--Modifiers
if modifier_sk_8 == nil then
	modifier_sk_8 = class({}, nil, ModifierHidden)
end
function modifier_sk_8:OnCreated(params)
	self.trigger_time = self:GetAbilitySpecialValueFor("trigger_time")
	self.enemy_count = self:GetAbilitySpecialValueFor("enemy_count")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_sk_8:OnIntervalThink()
	local hParent = self:GetParent()
	local iPlayerLevel = 0
	DotaTD:EachPlayer(function(_, iPlayerID)
		iPlayerLevel = iPlayerLevel + PlayerData:GetPlayerLevel(iPlayerID) - self.enemy_count
	end)
	local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), -1, self:GetAbility())
	if self:GetElapsedTime() > self.trigger_time and -- 60秒后激活
	hParent:IsAbilityReady(self:GetAbility()) and
	#tTargets >= iPlayerLevel * PlayerData:GetAlivePlayerCount() then	-- 当前单位大于等于（玩家人口-1） * 玩家人数
		ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, self:GetAbility())
	end
end
function modifier_sk_8:IsHidden()
	return true
end
---------------------------------------------------------------------
if modifier_sk_8_buff == nil then
	modifier_sk_8_buff = class({}, nil, ModifierHidden)
end
function modifier_sk_8_buff:OnCreated(params)
	self.delay = self:GetAbilitySpecialValueFor("delay")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.speed = self:GetAbilitySpecialValueFor("speed")
	self.width = self:GetAbilitySpecialValueFor("width")
	self.count = self:GetAbilitySpecialValueFor("count")
	if IsServer() then
		self:StartIntervalThink(self.interval)
		self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_4)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/boss/sand_king/dungeon_sand_king_channel.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_sk_8_buff:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveGesture(ACT_DOTA_CAST_ABILITY_4)
	end
end
function modifier_sk_8_buff:OnIntervalThink()
	local hParent = self:GetParent()
	for i = 1, self.count do
		local vDirection = RandomVector(1)
		local iParticleID = ParticleManager:CreateParticle("particles/units/boss/sand_king/sand_king_projectile.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, vDirection * self.speed)
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(1, 2, 0))
		local info = {
			Ability = self:GetAbility(),
			Source = hParent,
			vSpawnOrigin = hParent:GetAbsOrigin(),
			vVelocity = vDirection * self.speed,
			fDistance = self.radius,
			fStartRadius = self.width,
			fEndRadius = self.width,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			ExtraData = {
				iParticleID = iParticleID,
				vDirX = vDirection.x,
				vDirY = vDirection.y,
			}
		}
		ProjectileManager:CreateLinearProjectile(info)
	end
end