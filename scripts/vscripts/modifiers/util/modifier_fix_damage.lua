if modifier_fix_damage == nil then
	modifier_fix_damage = {
	}
	modifier_fix_damage = class({}, modifier_fix_damage)
end

local public = modifier_fix_damage

function public:IsHidden()
	return true
end
function public:IsDebuff()
	return false
end
function public:IsPurgable()
	return false
end
function public:IsPurgeException()
	return false
end
function public:AllowIllusionDuplicate()
	return false
end
function public:RemoveOnDeath()
	return false
end
function public:DestroyOnExpire()
	return false
end
function public:IsPermanent()
	return true
end
function public:OnCreated(params)
	AddModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self, nil, self:GetParent())
end
function public:OnDestroy()
	RemoveModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self, nil, self:GetParent())
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BASE_OVERRIDE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		-- MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	-- MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end
function public:GetModifierAttackSpeedBaseOverride(params)
	local fBonus = self:GetParent():GetVal(ATTRIBUTE_KIND.AttackSpeedBonusMaximum)
	return Clamp(1 + self:GetParent():GetIncreasedAttackSpeed(), 0.2, 5 + fBonus * 0.01)
end
function public:GetModifierTotalDamageOutgoing_Percentage(params)
	local percent = 100
	local bIsSpellCrit = bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_CRIT) == DOTA_DAMAGE_FLAG_CRIT

	if bIsSpellCrit then
		if percent > 0 then
			FireModifiersEvents(MODIFIER_EVENT_ON_DAMAGE_CRIT, {
				attacker = params.attacker,
				target = params.target,
				original_damage = params.original_damage,
				damage = params.original_damage * percent * 0.01,
				damage_type = params.damage_type,
				damage_flags = params.damage_flags,
				damage_category = params.damage_category,
				record = params.record,
			})
		end
	end

	return percent - 100
end
function public:GetModifierIncomingDamage_Percentage(params)
	local percent = 100
	local hAttacker = params.attacker
	local hParent = self:GetParent()
	local bIsSpellCrit = bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_CRIT) == DOTA_DAMAGE_FLAG_CRIT
	local bIsMiss = bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_MISS) == DOTA_DAMAGE_FLAG_MISS

	if not IsValid(hAttacker) or not IsValid(hParent) then
		return 0
	end

	--无视护甲
	--伤害抵挡数值修正
	local IgnoreArmorPct = hAttacker:GetVal(ATTRIBUTE_KIND.IgnoreArmor, params)
	local fArmorPercent = GetDamageBlockPercent(hParent, params.damage_type, IgnoreArmorPct)
	local fDamage = params.original_damage * (1 - fArmorPercent)

	--伤害打出和承受百分比修正
	if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT) ~= DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT then
		local fDamageRate = 1
		if params.damage_type == DAMAGE_TYPE_PHYSICAL then
			fDamageRate = fDamageRate * hAttacker:GetVal(ATTRIBUTE_KIND.PhysicalOutgoingPercentage, params) * 0.01
			fDamageRate = fDamageRate * hParent:GetVal(ATTRIBUTE_KIND.PhysicalIncomingPercentage, params) * 0.01
		elseif params.damage_type == DAMAGE_TYPE_MAGICAL then
			fDamageRate = fDamageRate * hAttacker:GetVal(ATTRIBUTE_KIND.MagicalOutgoingPercentage, params) * 0.01
			fDamageRate = fDamageRate * hParent:GetVal(ATTRIBUTE_KIND.MagicalIncomingPercentage, params) * 0.01
		elseif params.damage_type == DAMAGE_TYPE_PURE then
			fDamageRate = fDamageRate * hAttacker:GetVal(ATTRIBUTE_KIND.PureOutgoingPercentage, params) * 0.01
			fDamageRate = fDamageRate * hParent:GetVal(ATTRIBUTE_KIND.PureIncomingPercentage, params) * 0.01
		end
		--全伤害加成
		fDamageRate = fDamageRate * hAttacker:GetVal(ATTRIBUTE_KIND.OutgoingPercentage, params) * 0.01
		fDamageRate = fDamageRate * hParent:GetVal(ATTRIBUTE_KIND.IncomingPercentage, params) * 0.01
		fDamage = fDamage * fDamageRate
	end

	--闪避特效
	if bIsMiss then
		if 0 == fDamage then
			local vColor = self:GetDamageColor(params.damage_type)
			local iParticleID = ParticleManager:CreateParticle("particles/msg_fx/msg_miss.vpcf", PATTACH_OVERHEAD_FOLLOW, params.target)
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(5, 0, 0))
			ParticleManager:SetParticleControl(iParticleID, 2, Vector(3, 1, 0))
			ParticleManager:SetParticleControl(iParticleID, 3, vColor)
			ParticleManager:SetParticleShouldCheckFoW(iParticleID, false)
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end
	end

	--防御塔伤害特效
	if bIsSpellCrit
	and (BuildSystem:IsBuilding(params.attacker)
	or BuildSystem:IsBuilding(params.attacker:GetSummoner())
	or IsCommanderTower(params.attacker)
	or params.attacker:IsControllableByAnyPlayer())
	and not _G['NOSHOWDAMAGEPTCL']
	then
		local iNumber = math.floor(fDamage)
		local sNumber = tostring(iNumber)
		local fDuration = 3
		local vColor = self:GetDamageColor(params.damage_type)

		if 0 < fDamage then
			local iParticleID
			if bIsSpellCrit then
				iParticleID = ParticleManager:CreateParticle("particles/msg_fx/msg_crit.vpcf", PATTACH_OVERHEAD_FOLLOW, params.target)
				ParticleManager:SetParticleControl(iParticleID, 1, Vector(0, iNumber, 4))
				ParticleManager:SetParticleControl(iParticleID, 2, Vector(fDuration, #sNumber + 1, 0))
			else
				iParticleID = ParticleManager:CreateParticle("particles/msg_fx/msg_heal.vpcf", PATTACH_OVERHEAD_FOLLOW, params.target)
				ParticleManager:SetParticleControl(iParticleID, 1, Vector(0, iNumber, 0))
				ParticleManager:SetParticleControl(iParticleID, 2, Vector(fDuration, #sNumber, 0))
			end
			ParticleManager:SetParticleControl(iParticleID, 3, vColor)
			ParticleManager:SetParticleShouldCheckFoW(iParticleID, false)
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end
	end

	percent = percent * (fDamage / params.damage)
	return percent - 100
end
function public:GetModifierIncomingSpellDamageConstant(params)
end
function public:OnTakeDamage(params)
	if params.unit ~= self:GetParent() then return end

	--计算吸血
	if 0 < params.damage
	and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_NO_HEAL) ~= DOTA_DAMAGE_FLAG_NO_HEAL
	and IsValid(params.attacker) and params.attacker.GetVal
	then
		local fHealPercent = params.attacker:GetVal(ATTRIBUTE_KIND.DamageHeal, params)
		if DAMAGE_TYPE_MAGICAL == params.damage_type then
			fHealPercent = fHealPercent + params.attacker:GetVal(ATTRIBUTE_KIND.MagicalHeal, params)
		elseif DAMAGE_TYPE_PHYSICAL == params.damage_type then
			fHealPercent = fHealPercent + params.attacker:GetVal(ATTRIBUTE_KIND.PhysicalHeal, params)
		elseif DAMAGE_TYPE_PURE == params.damage_type then
			fHealPercent = fHealPercent + params.attacker:GetVal(ATTRIBUTE_KIND.PureHeal, params)
		end

		--攻击吸血
		if GetAttackInfoByDamageRecord(params.record, params.attacker) then
			fHealPercent = fHealPercent + params.attacker:GetVal(ATTRIBUTE_KIND.AttackHeal, params)
		end

		if 0 < fHealPercent then
			local fHeal = fHealPercent * 0.01 * params.damage
			params.attacker:Heal(fHeal, params.attacker)
			if DAMAGE_TYPE_PHYSICAL == params.damage_type then
				local iParticleID = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_OVERHEAD_FOLLOW, params.attacker)
				ParticleManager:ReleaseParticleIndex(iParticleID)
			else
				local iParticleID = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_OVERHEAD_FOLLOW, params.attacker)
				ParticleManager:ReleaseParticleIndex(iParticleID)
			end
		end
	end

	--计算吸蓝
	if 0 < params.damage
	then
		local function ManaRegen(typeOutgoing, typeIncoming)
			if IsValid(params.attacker) and params.attacker.GetVal then
				local fPercent = params.attacker:GetVal(typeOutgoing) + params.attacker:GetVal(ATTRIBUTE_KIND.OutgoingManaRegen, params)
				local fManaRegen = fPercent * 0.01 * params.damage
				params.attacker:GiveMana(fManaRegen)
			end
			if params.unit.GetVal then
				local fPercent = params.unit:GetVal(typeIncoming) + params.unit:GetVal(ATTRIBUTE_KIND.IncomingManaRegen, params)
				local fManaRegen = fPercent * params.damage / params.unit:GetMaxHealth() * 100
				params.unit:GiveMana(fManaRegen)
			end
		end

		if DAMAGE_TYPE_MAGICAL == params.damage_type then
			ManaRegen(ATTRIBUTE_KIND.MagicalOutgoingManaRegen, ATTRIBUTE_KIND.MagicalIncomingManaRegen)
		elseif DAMAGE_TYPE_PHYSICAL == params.damage_type then
			ManaRegen(ATTRIBUTE_KIND.PhysicalOutgoingManaRegen, ATTRIBUTE_KIND.PhysicalIncomingManaRegen)
		elseif DAMAGE_TYPE_PURE == params.damage_type then
			ManaRegen(ATTRIBUTE_KIND.PureOutgoingManaRegen, ATTRIBUTE_KIND.PureIncomingManaRegen)
		end
	end
end
function public:GetDamageColor(typeDamage)
	local vColor = Vector(255, 255, 255)
	if DAMAGE_TYPE_MAGICAL == typeDamage then
		vColor = Vector(0, 191, 255)
	elseif DAMAGE_TYPE_PHYSICAL == typeDamage then
		vColor = Vector(219, 87, 75)
	elseif DAMAGE_TYPE_PURE == typeDamage then
		vColor = Vector(215, 187, 62)
	end
	return vColor
end