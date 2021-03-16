LinkLuaModifier("modifier_cmd_juggernaut_6", "abilities/commander/cmd_juggernaut/cmd_juggernaut_6.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_juggernaut_6_buff", "abilities/commander/cmd_juggernaut/cmd_juggernaut_6.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_juggernaut_6 == nil then
	cmd_juggernaut_6 = class({})
end
function cmd_juggernaut_6:Prechace(context)
	PrecacheResource("particle", "particles/econ/items/juggernaut/armor_of_the_favorite/juggernaut_armor_of_the_favorite_crit.vpcf", context)
	PrecacheResource("particle", "particles/units/commander/cmd_juggernaut/cmd_juggernaut_6_proj.vpcf", context)
end
function cmd_juggernaut_6:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/juggernaut/armor_of_the_favorite/juggernaut_armor_of_the_favorite_crit.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	table.insert(hCaster:FindModifierByName("modifier_cmd_juggernaut_6").tKillList, hTarget)
	local info = {
		EffectName = "particles/units/commander/cmd_juggernaut/cmd_juggernaut_6_proj.vpcf",
		Ability = self,
		iMoveSpeed = 3000,
		Source = hCaster,
		Target = hTarget,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		vSourceLoc = hCaster:GetAbsOrigin(),
		bDodgeable = false,
	}
	ProjectileManager:CreateTrackingProjectile(info)
end
function cmd_juggernaut_6:OnProjectileHit(hTarget, vLocation)
	if hTarget ~= nil then
		hTarget:Kill(self, self:GetCaster())
	end
	return "modifier_cmd_juggernaut_6"
end
function cmd_juggernaut_6:GetIntrinsicModifierName()
	return "modifier_cmd_juggernaut_6"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_juggernaut_6 == nil then
	modifier_cmd_juggernaut_6 = class({}, nil, eom_modifier)
end
function modifier_cmd_juggernaut_6:IsHidden()
	return true
end
function modifier_cmd_juggernaut_6:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
		self.tKillList = {}	-- 待击杀名单
		self:StartIntervalThink(1)
	end
	self:UpdateValues()
end
function modifier_cmd_juggernaut_6:OnRefresh(params)
	self:UpdateValues()
end
function modifier_cmd_juggernaut_6:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_cmd_juggernaut_6:OnIntervalThink()
	if #self.tKillList > 0 then
		for i = #self.tKillList, 1, -1 do

		end
	end
end
function modifier_cmd_juggernaut_6:IsHidden()
	return true
end
function modifier_cmd_juggernaut_6:UpdateValues()
	if IsServer() then
		self:Action()
	end
end
function modifier_cmd_juggernaut_6:Action()
	if IsServer() and not self:GetParent():IsIllusion() then
		if IsValid(self:GetAbility())
		and self:GetAbility():GetLevel() > 0 then
			local hCaster = self:GetCaster()
			local iPlayerID = self:GetPlayerID()
			EachUnits(iPlayerID, function(hUnit)
				if not hUnit:IsRangedAttacker() then
					self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_cmd_juggernaut_6_buff", nil)
				end
			end, UnitType.Building)
			local hCommander = Commander:GetCommander(iPlayerID)
			self.tModifiers[hCommander:entindex()] = hCommander:AddNewModifier(hCaster, self:GetAbility(), "modifier_cmd_juggernaut_6_buff", nil)
		end
	end
end
function modifier_cmd_juggernaut_6:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned },
	}
end
function modifier_cmd_juggernaut_6:OnInBattle()
	self:Action()
end
function modifier_cmd_juggernaut_6:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	if iPlayerID == self:GetPlayerID()
	and IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0
	and not hUnit:IsRangedAttacker() then
		self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_cmd_juggernaut_6_buff", nil)
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_juggernaut_6_buff == nil then
	modifier_cmd_juggernaut_6_buff = class({}, nil, eom_modifier)
end
function modifier_cmd_juggernaut_6_buff:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor('chance')
	self.hp_pct = self:GetAbilitySpecialValueFor('hp_pct')
	if IsServer() then
	end
end
function modifier_cmd_juggernaut_6_buff:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor('chance')
	self.hp_pct = self:GetAbilitySpecialValueFor('hp_pct')
	if IsServer() then
	end
end
function modifier_cmd_juggernaut_6_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_cmd_juggernaut_6_buff:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK_LANDED] = { self:GetParent(), nil },

	}
end
function modifier_cmd_juggernaut_6_buff:DeclareFunctions()
	return	{
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2
	}
end
function modifier_cmd_juggernaut_6_buff:OnTooltip()
	return self.chance
end
function modifier_cmd_juggernaut_6_buff:OnTooltip2()
	return self.hp_pct
end
function modifier_cmd_juggernaut_6_buff:OnAttackLanded(params)
	if not IsValid(params.target) or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() and RollPercentage(self.chance) and params.target:GetHealthPercent() <= self.hp_pct then
		if params.target:IsBoss() or
		params.target:IsAncient() or
		params.target:IsGoldWave() or
		params.target:GetUnitLabel() == "elite" or
		Spawner:IsMobsRound() then
		else
			-- local iParticleID = ParticleManager:CreateParticle("particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_culling_blade_kill_b.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)
			-- ParticleManager:SetParticleControlEnt(iParticleID, 4, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), true)
			-- ParticleManager:SetParticleControlForward(iParticleID, 3, -params.attacker:GetForwardVector())
			-- ParticleManager:ReleaseParticleIndex(iParticleID)
			-- params.target:Kill(self:GetAbility(), params.attacker)
			local hCaster = self:GetCaster()
			hCaster:AddActivityModifier("favor")
			hCaster:StartGesture(ACT_DOTA_ATTACK_EVENT)
			hCaster:RemoveActivityModifier("favor")
			hCaster:PassiveCast(self:GetAbility(), DOTA_UNIT_ORDER_CAST_TARGET, {
				flCastPoint = 0.3,
				iCastAnimation = ACT_DOTA_ATTACK_EVENT,
				sActivityModifier = "favor",
				hTarget = params.target,
			})
		end
	end
end