LinkLuaModifier("modifier_contract_death_wing", "abilities/contract/contract_death_wing.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_contract_death_wing_thinker", "abilities/contract/contract_death_wing.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if contract_death_wing == nil then
	contract_death_wing = class({})
end
function contract_death_wing:GetIntrinsicModifierName()
	return "modifier_contract_death_wing"
end
---------------------------------------------------------------------
--Modifiers
if modifier_contract_death_wing == nil then
	modifier_contract_death_wing = class({}, nil, eom_modifier)
end
function modifier_contract_death_wing:IsHidden()
	return true
end
function modifier_contract_death_wing:OnCreated(params)
	self.death_count = self:GetAbilitySpecialValueFor("death_count")
	self.count = self:GetAbilitySpecialValueFor("count")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.bonus_count = self:GetAbilitySpecialValueFor("bonus_count")
	if IsServer() then
		local hParent = self:GetParent()
		hParent:GameTimer(0, function()
			self:GetParent():SetMaterialGroup('3')
			self:GetParent():StartGesture(ACT_DOTA_CONSTANT_LAYER)
		end)
		self:StartIntervalThink(self.interval)
	end
end
function modifier_contract_death_wing:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_contract_death_wing:OnIntervalThink()
	local hParent = self:GetParent()
	if hParent:IsAlive() then
		-- 砸陨石
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.distance, self:GetAbility(), FIND_FARTHEST)
		ArrayRemove(tTargets, Commander:GetCommander(GetPlayerID(hParent)))
		if IsValid(tTargets[1]) then
			for i = 1, self.count do
				CreateModifierThinker(hParent, self:GetAbility(), "modifier_contract_death_wing_thinker", { duration = 1.3 }, tTargets[1]:GetAbsOrigin() + RandomVector(RandomInt(0, 150)), hParent:GetTeamNumber(), false)
			end
		end
	end
end
function modifier_contract_death_wing:EDeclareFunctions()
	return {
		[EMDF_EVENT_CUSTOM] = { ET_ENEMY.ON_DEATH, self.OnDeath }
	}
end
function modifier_contract_death_wing:OnDeath(params)
	local hParent = self:GetParent()
	if params.PlayerID == GetPlayerID(hParent) then
		self:IncrementStackCount()
		if self:GetStackCount() >= self.death_count then
			-- 砸陨石
			local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.distance, self:GetAbility(), FIND_FARTHEST)
			ArrayRemove(tTargets, Commander:GetCommander(params.PlayerID))
			if IsValid(tTargets[1]) then
				for i = 1, self.bonus_count do
					CreateModifierThinker(hParent, self:GetAbility(), "modifier_contract_death_wing_thinker", { duration = 1.3 }, tTargets[1]:GetAbsOrigin() + RandomVector(RandomInt(0, 150)), hParent:GetTeamNumber(), false)
				end
			end
			self:SetStackCount(0)
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_contract_death_wing_thinker == nil then
	modifier_contract_death_wing_thinker = class({}, nil, ModifierHidden)
end
function modifier_contract_death_wing_thinker:OnCreated()
	local hParent = self:GetParent()

	self.radius = self:GetAbilitySpecialValueFor("radius")

	if IsServer() then
		hParent:EmitSound("Hero_Invoker.ChaosMeteor.Loop")

		self.vPosition = hParent:GetAbsOrigin()
		self.iTeamNumber = hParent:GetTeamNumber()
		local vStart = self.vPosition + Vector(0, 0, 1600)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetCaster():GetAbsOrigin() + Vector(0, 0, 1600))
		ParticleManager:SetParticleControl(iParticleID, 1, vStart + (self.vPosition - vStart):Length() * (1.3 / self:GetDuration()) * (self.vPosition - vStart):Normalized())
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(self:GetDuration(), 0, 0))
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
function modifier_contract_death_wing_thinker:OnDestroy()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	if IsServer() then
		hParent:StopSound("Hero_Invoker.ChaosMeteor.Loop")
		hParent:EmitSound("Hero_Invoker.ChaosMeteor.Impact")
		-- ScreenShake(hParent:GetAbsOrigin(), 20, 12, 0.5, 6000, 0, true)
		hParent:RemoveAllModifiers(0, false, true, true)
		hParent:RemoveSelf()

		if not IsValid(hCaster) or not IsValid(hAbility) then
			return
		end

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self.vPosition)
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, self.radius, self.radius))
		ParticleManager:ReleaseParticleIndex(iParticleID)

		local tTargets = FindUnitsInRadius(self.iTeamNumber, self.vPosition, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		hCaster:DealDamage(tTargets, hAbility)
	end
end
function modifier_contract_death_wing_thinker:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] = true,
		[MODIFIER_STATE_NO_TEAM_SELECT] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}
end