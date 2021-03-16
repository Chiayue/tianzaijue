if modifier_enemy_gold == nil then
	modifier_enemy_gold = class({})
end

local public = modifier_enemy_gold

function public:IsHidden()
	return false
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
function public:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end
function public:GetTexture()
	return "alchemist_goblins_greed"
end
function public:GetStatusEffectName()
	return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_gold.vpcf"
end
function public:StatusEffectPriority()
	return 99
end
function public:OnCreated(params)
	self.fMoveSpeed = self:GetParent():GetBaseMoveSpeed()
	if IsServer() then
		local hParent = self:GetParent()
	end
	AddModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self, nil, self:GetParent())
end
function public:OnDestroy()
	RemoveModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self, nil, self:GetParent())
end
function public:OnIntervalThink()
	if IsServer() then
	end
end
function public:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_DISARMED] = false,
	}
end
function public:DeclareFunctions()
	return {
		-- MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
		MODIFIER_PROPERTY_MODEL_SCALE,
	}
end
function public:GetModifierModelScale(params)
	local iScale = self:GetStackCount() * 1.01
	iScale = math.min(500, math.max(iScale, 1))
	return iScale
end
function public:GetMinHealth(params)
	return 1
end
function public:GetModifierMoveSpeed_AbsoluteMin(params)
	return self.fMoveSpeed
end
function public:OnTakeDamage(params)
	if params.unit == self:GetParent() then
		local hParent = self:GetParent()

		hParent.iDamageSum = (hParent.iDamageSum or 0) + params.damage

		if hParent:GetHealth() < params.damage then
			--死一条命
			hParent.iDeath = (hParent.iDeath or 0) + 1
			self:SetStackCount(hParent.iDeath)

			if 50 >= hParent.iDeath then
				-- 50条命以内血量增加
				local iMaxHealth = hParent:GetValConst(ATTRIBUTE_KIND.StatusHealth) * (1 + ENEMY_GOLD_DEATH_ADD_HP_RATE)
				hParent:SetVal(ATTRIBUTE_KIND.StatusHealth, iMaxHealth, ATTRIBUTE_KEY.BASE)
			end

			local iMaxCur = hParent:GetVal(ATTRIBUTE_KIND.StatusHealth)

			hParent:ModifyHealth(iMaxCur, nil, false, 0)

			local duration = 1
			hParent:AddNewModifier(hParent, nil, "modifier_wave_gold_stiffness", { duration = duration })

			if not _G.NOHASDROP then
				--掉魂晶
				local vPos = hParent:GetAbsOrigin()
				local iCrystal, iCrystalEntityCount = GET_GOLD_ENEMY_CRYSTAL(hParent.iDeath)
				hParent.iCrystal = (hParent.iCrystal or 0) + iCrystal
				for i = iCrystalEntityCount, 1, -1 do
					GameTimer(i * 0.1, function()
						PlayerData:DropCrystal(GetPlayerID(hParent), vPos, iCrystal / iCrystalEntityCount)
					end)
				end

				--掉金币
				local vPos = hParent:GetAbsOrigin()
				local iGold, iGoldEntityCount = GET_GOLD_ENEMY_GOLD(hParent.iDeath)
				iGold = RandomInt(0.9 * iGold, 1.1 * iGold) * GetGoldRoundGoldBonusPercentage(GetPlayerID(hParent)) * 0.01
				hParent.iGold = (hParent.iGold or 0) + iGold
				for i = iGoldEntityCount, 1, -1 do
					GameTimer(i * 0.1, function()
						PlayerData:DropGold(GetPlayerID(hParent), vPos, iGold / iGoldEntityCount)
					end)
				end
			end
		end
	end
end