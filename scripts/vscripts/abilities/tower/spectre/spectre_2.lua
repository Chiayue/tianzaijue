LinkLuaModifier("modifier_spectre_2", "abilities/tower/spectre/spectre_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spectre_2_debuff", "abilities/tower/spectre/spectre_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if spectre_2 == nil then
	spectre_2 = class({})
end
function spectre_2:Spawn()
	self.iInitAngle = RandomInt(0, 360)	-- 随机一个死神初始角度
	self.iCount = 0
end
function spectre_2:GetNextAngle()
	local iAngle = self.iInitAngle + self.iCount * 120
	self.iCount = self.iCount + 1
	if self.iCount >= 3 then
		self.iInitAngle = RandomInt(0, 360)
		self.iCount = 0
	end
	return iAngle
end
function spectre_2:OnSpellStart(hTarget, iCount)
	local hCaster = self:GetCaster()
	hTarget:AddBuff(hCaster, BUFF_TYPE.LOCK, self:GetDuration())
	-- if not hTarget:IsBoss() then
	-- end
	for i = 1, iCount do
		hTarget:AddNewModifier(hCaster, self, "modifier_spectre_2_debuff", { duration = self:GetDuration() })
	end
	-- hCaster:EmitSound("Hero_Necrolyte.ReapersScythe.Cast")
	hTarget:EmitSound("Hero_Necrolyte.ReapersScythe.Target")
end
function spectre_2:GetIntrinsicModifierName()
	return "modifier_spectre_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_spectre_2 == nil then
	modifier_spectre_2 = class({}, nil, eom_modifier)
end
function modifier_spectre_2:IsHidden()
	return self:GetStackCount() == 0
end
function modifier_spectre_2:OnCreated(params)
	self.attack_pct = self:GetAbilitySpecialValueFor("attack_pct")
	if IsServer() then
	end
end
function modifier_spectre_2:OnRefresh(params)
	self.attack_pct = self:GetAbilitySpecialValueFor("attack_pct")
end
function modifier_spectre_2:AddStackCount()
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_spectre_2:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_spectre_2:GetPhysicalAttackBonus()
	return self:GetStackCount() * self.attack_pct
end
function modifier_spectre_2:OnBattleEnd()
	return self:SetStackCount(0)
end
function modifier_spectre_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_spectre_2:OnTooltip()
	return self:GetStackCount() * self.attack_pct
end
---------------------------------------------------------------------
if modifier_spectre_2_debuff == nil then
	modifier_spectre_2_debuff = class({}, nil, ModifierHidden)
end
function modifier_spectre_2_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_spectre_2_debuff:OnCreated(params)
	self.regen_pct = self:GetAbilitySpecialValueFor("regen_pct")
	if IsServer() then
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/spectre/spectre_2.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, hParent:GetAbsOrigin())
		local iAngle = self:GetAbility():GetNextAngle()
		ParticleManager:SetParticleControlForward(iParticleID, 0, Rotation2D(Vector(0, 1, 0), math.rad(iAngle)))
		ParticleManager:SetParticleControlForward(iParticleID, 1, Rotation2D(Vector(0, 1, 0), math.rad(iAngle)))
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/spectre/spectre_2_lock.vpcf", PATTACH_CUSTOMORIGIN, hParent)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		-- ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_spectre_2_debuff:OnDestroy()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	if IsServer() then
		if hParent:IsAlive() and IsValid(hCaster) then
			hCaster:DealDamage(hParent, self:GetAbility())
		end
		local flAmount = math.floor(hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self.regen_pct * 0.01)
		hCaster:Heal(flAmount, self:GetAbility())
		hCaster:FindModifierByName("modifier_spectre_2"):AddStackCount()
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/spectre/spectre_2_b.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, hParent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(iParticleID)
		-- self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/spectre/spectre_2_f.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(300, 300, 300))
		ParticleManager:ReleaseParticleIndex(iParticleID)
		-- self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end