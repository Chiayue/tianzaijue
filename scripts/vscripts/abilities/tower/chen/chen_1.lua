LinkLuaModifier("modifier_chen_1_buff", "abilities/tower/chen/chen_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if chen_1 == nil then
	chen_1 = class({ iOrderType = FIND_CLOSEST }, nil, ability_base_ai)
end
function chen_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local health_pct = self:GetSpecialValueFor("health_pct")
	if hTarget:IsBoss() or
	hTarget:IsAncient() or
	hTarget:IsGoldWave() or
	hTarget:GetUnitLabel() == "elite" or
	Spawner:IsMobsRound() then
		hCaster:DealDamage(hTarget, self)
		hTarget:EmitSound("Hero_Chen.HolyPersuasionCast")
	else
		hCaster:DealDamage(hTarget, self, hTarget:GetHealthDeficit())
		if not hTarget:IsAlive() then
			Spawner:Charm(hCaster, hTarget, self)
			hTarget:SetBaseMaxHealth(hCaster:GetMaxHealth() * health_pct * 0.01)
			hTarget:SetMaxHealth(hTarget:GetBaseMaxHealth())
			hTarget:SetHealth(hTarget:GetBaseMaxHealth())
			hTarget:AddNewModifier(hCaster, self, "modifier_chen_1_buff", nil)

			local tCharm = self:GetCharm()
			table.insert(tCharm, hTarget)
			-- 删除最早召唤单位
			if #tCharm > self:GetSpecialValueFor("max_count") then
				if IsValid(tCharm[1]) then
					tCharm[1]:ForceKill(false)
				else
					ArrayRemove(self.tCharm, tCharm[1])
				end
			end
			hTarget:EmitSound("Hero_Chen.HolyPersuasionEnemy")
		end
		hTarget:EmitSound("Hero_Chen.HolyPersuasionCast")
	end
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_holy_persuasion.vpcf", PATTACH_ABSORIGIN, hTarget)
	ParticleManager:SetParticleControl(iParticleID, 1, hTarget:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(iParticleID)
end
function chen_1:GetCharm()
	local tCharm
	local hCaster = self:GetCaster()
	if hCaster.GetBuilding then
		local hBuilding = hCaster:GetBuilding()
		if hBuilding then
			tCharm = hBuilding.tCharm
			if not tCharm then
				tCharm = {}
				hBuilding.tCharm = tCharm
			end
		end
	end

	if not tCharm then
		tCharm = self.tCharm
		if tCharm == nil then
			tCharm = {}
			self.tCharm = tCharm
		end
	end

	return tCharm
end
---------------------------------------------------------------------
--Modifiers
if modifier_chen_1_buff == nil then
	modifier_chen_1_buff = class({}, nil, eom_modifier)
end
function modifier_chen_1_buff:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
		self:SetStackCount(self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalAttack))
	end
end
function modifier_chen_1_buff:OnIntervalThink()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	if GSManager:getStateType() ~= GS_Battle and CalculateDistance(hParent, hCaster) > 200 then
		hParent:Stop()
		FindClearSpaceForUnit(hParent, hCaster:GetAbsOrigin() + RandomVector(150), true)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_divine_favor.vpcf", PATTACH_ABSORIGIN, hParent)
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
	if not IsValid(hCaster) or not hCaster:IsAlive() then
		hParent:ForceKill(false)
		return
	end
	if hParent:GetAttackTarget() == nil and hCaster:GetAttackTarget() ~= nil then
		ExecuteOrder(hParent, DOTA_UNIT_ORDER_ATTACK_TARGET, hCaster:GetAttackTarget())
	end
	if hCaster:IsIdle() and not hParent:IsIdle() then
		hParent:Stop()
	end
	if hCaster:IsMoving() and hParent:IsIdle() then
		ExecuteOrder(hParent, DOTA_UNIT_ORDER_ATTACK_MOVE, nil, nil, hCaster:GetAbsOrigin() + hCaster:GetForwardVector() * 600)
	end
end
function modifier_chen_1_buff:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH,
		EMDF_MAGICAL_ATTACK_BONUS
	}
end
function modifier_chen_1_buff:GetMagicalAttackBonus()
	return self:GetStackCount()
end
function modifier_chen_1_buff:OnDeath(params)
	if IsServer() then
		local hParent = self:GetParent()
		if params.unit == hParent and IsValid(self:GetCaster()) then
			local tCharm = self:GetAbility():GetCharm()
			if tCharm then
				ArrayRemove(tCharm, hParent)
			end
		end
	end
end