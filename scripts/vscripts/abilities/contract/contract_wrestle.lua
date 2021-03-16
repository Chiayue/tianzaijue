LinkLuaModifier("modifier_contract_wrestle", "abilities/contract/contract_wrestle.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_contract_wrestle_buff", "abilities/contract/contract_wrestle.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if contract_wrestle == nil then
	contract_wrestle = class({})
end
function contract_wrestle:GetIntrinsicModifierName()
	return "modifier_contract_wrestle"
end
---------------------------------------------------------------------
--Modifiers
if modifier_contract_wrestle == nil then
	modifier_contract_wrestle = class({}, nil, eom_modifier)
end
function modifier_contract_wrestle:IsHidden()
	return true
end
function modifier_contract_wrestle:OnCreated(params)
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
	end
end
function modifier_contract_wrestle:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_contract_wrestle:OnDestroy()
	if IsServer() then
	end
end
function modifier_contract_wrestle:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE
	}
end
function modifier_contract_wrestle:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}
end
function modifier_contract_wrestle:OnInBattle()
	if IsServer() then
		local hParent = self:GetParent()
		local hEntPoint = Spawner.tTeamMapPoints[PlayerData:GetPlayerTeamID(GetPlayerID(hParent))]
		local vCenter = hEntPoint:GetAbsOrigin() + Vector(0, 600, 0)
		local tTargets = {}
		EachUnits(GetPlayerID(hParent), function(hUnit)
			if hUnit:IsAlive() then
				hUnit:AddBuff(hParent, BUFF_TYPE.STUN, self.duration)
				table.insert(tTargets, hUnit)
			end
		end, UnitType.Building)
		table.sort(tTargets, function(a, b)
			return a:GetVal(ATTRIBUTE_KIND.PhysicalAttack) > b:GetVal(ATTRIBUTE_KIND.PhysicalAttack)
		end)
		if IsValid(tTargets[1]) then
			hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_contract_wrestle_buff", { iEntIndex = tTargets[1]:entindex() })
			-- 击飞
			hParent:KnockBack(hParent:GetAbsOrigin() + (hParent:GetAbsOrigin() - vCenter):Normalized(), hParent, (hParent:GetAbsOrigin() - vCenter):Length2D(), 300, 0.5, true, 0.5, true)
			hParent:KnockBack(tTargets[1]:GetAbsOrigin() + (tTargets[1]:GetAbsOrigin() - vCenter):Normalized(), tTargets[1], (tTargets[1]:GetAbsOrigin() - vCenter):Length2D(), 300, 0.5, true, 0.5, true)
			tTargets[1]:RemoveModifierByName("modifier_stun")
		end
	end
end
function modifier_contract_wrestle:GetActivityTranslationModifiers()
	return "attack_long_range"
end
---------------------------------------------------------------------
if modifier_contract_wrestle_buff == nil then
	modifier_contract_wrestle_buff = class({}, nil, eom_modifier)
end
function modifier_contract_wrestle_buff:IsHidden()
	return true
end
function modifier_contract_wrestle_buff:OnCreated(params)
	if IsServer() then
		self.hParent = self:GetParent()
		self.hTarget = EntIndexToHScript(params.iEntIndex)
		-- 强制攻击
		self.hParent:SetForceAttackTarget(self.hTarget)
		self.hTarget:SetForceAttackTarget(self.hParent)
		-- 特效
		local hEntPoint = Spawner.tTeamMapPoints[PlayerData:GetPlayerTeamID(GetPlayerID(self:GetParent()))]
		local vCenter = hEntPoint:GetAbsOrigin() + Vector(0, 600, 0)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_mars/mars_arena_of_blood.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, vCenter)
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(450, 0, 0))
		ParticleManager:SetParticleControl(iParticleID, 2, vCenter)
		ParticleManager:SetParticleControl(iParticleID, 3, vCenter)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_contract_wrestle_buff:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_contract_wrestle_buff:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH
	}
end
function modifier_contract_wrestle_buff:OnDeath(params)
	if params.unit == self.hTarget or params.unit == self.hParent then
		-- 强制攻击
		self.hParent:SetForceAttackTarget(nil)
		self.hTarget:SetForceAttackTarget(nil)
		self:Destroy()
	end
end