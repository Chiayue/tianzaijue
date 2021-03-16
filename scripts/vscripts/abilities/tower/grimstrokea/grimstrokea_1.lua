LinkLuaModifier("modifier_grimstrokeA_1", "abilities/tower/grimstrokeA/grimstrokeA_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if grimstrokeA_1 == nil then
	grimstrokeA_1 = class({})
end
function grimstrokeA_1:Precache(context)
	PrecacheResource("particle", "particles/units/heroes/hero_grimstroke/grimstroke_darkartistry_proj.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_grimstroke/grimstroke_cast2_ground.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_grimstroke/grimstroke_cast_generic.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_grimstroke/grimstroke_darkartistry_dmg.vpcf", context)
end
function grimstrokeA_1:GetIntrinsicModifierName()
	return "modifier_grimstrokeA_1"
end

---------------------------------------------------------------------
--Modifiers
if modifier_grimstrokeA_1 == nil then
	modifier_grimstrokeA_1 = class({}, nil, eom_modifier)
end
function modifier_grimstrokeA_1:IsHidden()
	return true
end
function modifier_grimstrokeA_1:EDeclareFunctions()
	return {
		EMDF_ATTACKT_ANIMATION,
		EMDF_EVENT_ON_ATTACK_RECORD_CREATE,
		EMDF_DO_ATTACK_BEHAVIOR,
		EMDF_EVENT_ON_ATTACK_HIT,
		EMDF_EVENT_ON_ATTACK_RECORD_DESTROY,
	}
end
function modifier_grimstrokeA_1:GetAttackAnimation()
	return ACT_DOTA_CAST_ABILITY_3
end
function modifier_grimstrokeA_1:OnCustomAttackRecordCreate(tAttackInfo)
	if tAttackInfo.target == nil or tAttackInfo.target:GetClassname() == "dota_item_drop" then return end
	if tAttackInfo.attacker ~= self:GetParent() then return end

	local hCaster = self:GetParent()
	self.iPreParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_cast2_ground.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(self.iPreParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_brush_end", hCaster:GetAbsOrigin(), true)
end
function modifier_grimstrokeA_1:OnCustomAttackRecordDestroy(tAttackInfo)
	if tAttackInfo.target == nil or tAttackInfo.target:GetClassname() == "dota_item_drop" then return end
	if tAttackInfo.attacker ~= self:GetParent() then return end

	if self.iPreParticleID then
		ParticleManager:DestroyParticle(self.iPreParticleID, true)
		self.iPreParticleID = nil
	end
end
function modifier_grimstrokeA_1:DoAttackBehavior(tAttackInfo, hAttackAbility)
	local hCaster = self:GetParent()
	local hTarget = tAttackInfo.target

	-- 处理基础伤害
	local magical2magical = self:GetAbilitySpecialValueFor("magical2magical")
	local damage_deepen = self:GetAbilitySpecialValueFor("damage_deepen")
	for iDamageType, tDamageInfo in pairs(tAttackInfo.tDamageInfo) do
		if tDamageInfo.damage > 0 then
			if DAMAGE_TYPE_MAGICAL == tDamageInfo.damage_type then
				tDamageInfo.damage = tDamageInfo.damage * magical2magical * 0.01
			end
			tDamageInfo.damage_grimstrokeA_1 = tDamageInfo.damage * damage_deepen * 0.01
		end
	end


	-- 帅逼特效
	local width = self:GetAbilitySpecialValueFor("width")
	local vDirection = (hTarget:GetAbsOrigin() - hCaster:GetAbsOrigin()):Normalized()
	local vStartPosition = hCaster:GetAbsOrigin()
	vStartPosition = vStartPosition + vDirection * width
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_cast_generic.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	local tHash = CreateHashtable()
	self:CreateDarkArtistry(vStartPosition, vDirection, tAttackInfo, tHash, hAttackAbility)

	return self.OnProjectileHit_ExtraData
end
function modifier_grimstrokeA_1:CreateDarkArtistry(vStart, vDirection, params, tHash, hAttackAbility, bExtra)
	local hCaster = self:GetParent()
	local speed = self:GetAbilitySpecialValueFor("speed")
	local distance = hCaster:Script_GetAttackRange()
	local width = self:GetAbilitySpecialValueFor("width")

	-- 笔特效
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_darkartistry_proj.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_CUSTOMORIGIN, nil, hCaster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(iParticleID, 0, vStart)
	ParticleManager:SetParticleControl(iParticleID, 1, vDirection:Normalized() * speed)
	ParticleManager:SetParticleControl(iParticleID, 5, vStart + vDirection:Normalized() * distance)

	local tInfo = {
		EffectName = "",
		Ability = hAttackAbility,
		Source = hCaster,
		vSpawnOrigin = vStart,
		vVelocity = vDirection * speed,
		fDistance = distance,
		fStartRadius = width,
		fEndRadius = width,
		iUnitTargetTeam = self:GetAbility():GetAbilityTargetTeam(),
		iUnitTargetType = self:GetAbility():GetAbilityTargetType(),
		iUnitTargetFlags = self:GetAbility():GetAbilityTargetFlags(),
		ExtraData = {
			record = params.record,
			iParticleID = iParticleID,
			iHashIndex = GetHashtableIndex(tHash),
			bExtra = bExtra and 1 or 0
		}
	}
	local iProjectileID = ProjectileManager:CreateLinearProjectile(tInfo)
	table.insert(tHash, iProjectileID)
end
function modifier_grimstrokeA_1:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData, hAttackAbility)
	local hCaster = self:GetParent()
	local tHash = GetHashtableByIndex(ExtraData.iHashIndex)
	if hTarget then
		vLocation = hTarget:GetAbsOrigin()

		if nil ~= hAttackAbility:GetAttackHitSound() then
			EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_Grimstroke.DarkArtistry.Damage", hCaster)
		end
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_darkartistry_dmg.vpcf", PATTACH_ABSORIGIN, hTarget)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		local tAttackInfo = GetAttackInfo(ExtraData.record, hCaster)
		if tAttackInfo.iDamageCount == nil then
			tAttackInfo.iDamageCount = 0
		end
		tAttackInfo.iDamageCount = tAttackInfo.iDamageCount + 1
		hAttackAbility:OnDamage(hTarget, tAttackInfo)
		if ExtraData.bExtra == 0 then
			if hTarget:HasModifier("modifier_grimstrokeA_2_chain") then
				local hModifier = hTarget:FindModifierByName("modifier_grimstrokeA_2_chain")
				if IsValid(hModifier.hTarget) then
					self:CreateDarkArtistry(hModifier.hTarget:GetAbsOrigin(), RandomVector(1), tAttackInfo, tHash, hAttackAbility, true)
				end
			end
			if hTarget:HasModifier("modifier_grimstrokeA_2_chain_link") then
				local hModifier = hTarget:FindModifierByName("modifier_grimstrokeA_2_chain_link")
				if IsValid(hModifier:GetCaster()) then
					self:CreateDarkArtistry(hModifier:GetCaster():GetAbsOrigin(), RandomVector(1), tAttackInfo, tHash, hAttackAbility, true)
				end
			end
		end
	else
		table.remove(tHash, 1)
		if #tHash == 0 then
			DelAttackInfo(ExtraData.record)
		end
		ParticleManager:DestroyParticle(ExtraData.iParticleID, false)
		ParticleManager:ReleaseParticleIndex(ExtraData.iParticleID)
	end
end
function modifier_grimstrokeA_1:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end

	local iDamageCount = tAttackInfo.iDamageCount or 0
	if 0 >= iDamageCount then
		return
	end

	for iDamageType, tDamageInfo in pairs(tAttackInfo.tDamageInfo) do
		if tDamageInfo.damage > 0 then
			-- 每次击中增伤
			tDamageInfo.damage = tDamageInfo.damage + (tDamageInfo.damage_grimstrokeA_1 or 0)
		end
	end
end