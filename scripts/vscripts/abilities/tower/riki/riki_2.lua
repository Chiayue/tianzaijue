LinkLuaModifier("modifier_riki_2_buff", "abilities/tower/riki/riki_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if riki_2 == nil then
	riki_2 = class({ iSearchBehavior = AI_SEARCH_BEHAVIOR_MOST_AOE_TARGET }, nil, ability_base_ai)
end
function riki_2:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function riki_2:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:SetAbsOrigin(self:GetCursorPosition())
	hCaster:AddNewModifier(hCaster, self, "modifier_riki_2_buff", { duration = self:GetDuration(), vPosition = self:GetCursorPosition() })
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_tricks_cast.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, hCaster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Hero_Riki.TricksOfTheTrade")
end
---------------------------------------------------------------------
--Modifiers
if modifier_riki_2_buff == nil then
	modifier_riki_2_buff = class({}, nil, eom_modifier)
end
function modifier_riki_2_buff:IsHidden()
	return true
end
function modifier_riki_2_buff:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.attack_count = self:GetAbilitySpecialValueFor("attack_count")
	local hParent = self:GetParent()
	if IsServer() then
		if self.attack_count > 1 then
			self:StartIntervalThink(self:GetDuration() / (self.attack_count - 1))
		end
		self:OnIntervalThink()
		hParent:AddNoDraw()
		self.vPosition = StringToVector(params.vPosition)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_tricks.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, 1, 1))
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(self:GetDuration(), 0, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	else
	end
end
function modifier_riki_2_buff:OnIntervalThink()
	local hParent = self:GetParent()
	local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
	for _, hUnit in pairs(tTargets) do
		hParent:GameTimer(RandomFloat(0, 0.2), function()
			if IsValid(hUnit) then
				hParent:Attack(hUnit, ATTACK_STATE_SKIPCOOLDOWN + ATTACK_STATE_NOT_USEPROJECTILE)
			end
		end)
	end

end
function modifier_riki_2_buff:OnDestroy()
	local hParent = self:GetParent()
	if IsServer() then
		hParent:RemoveNoDraw()
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
		table.sort(tTargets, function(a, b)
			return a:GetHealth() < b:GetHealth()
		end)
		if GSManager:getStateType() == GS_Battle then
			if IsValid(tTargets[1]) then
				FindClearSpaceForUnit(hParent, tTargets[1]:GetAbsOrigin() - tTargets[1]:GetForwardVector() * 100, true)
			else
				FindClearSpaceForUnit(hParent, self.vPosition, true)
			end
		end
	end
end
function modifier_riki_2_buff:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
end