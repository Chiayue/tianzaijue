if modifier_commander_birthplace == nil then
	modifier_commander_birthplace = class({}, nil, BaseModifier)
end

local public = modifier_commander_birthplace

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
	return true
end
function public:RemoveOnDeath()
	return true
end
function public:DestroyOnExpire()
	return false
end
function public:IsPermanent()
	return true
end
function public:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function public:OnCreated(params)
	local hParent = self:GetParent()
	self.tUpgrade = KeyValues.UnitsKv[hParent:GetUnitName()]
	if IsServer() then
		self:SetStackCount(hParent:GetLevel())
	end
	self:LevelUpAttribute(self:GetStackCount())
end
function public:OnRefresh(params)
	local hParent = self:GetParent()
	if IsServer() then
		self:SetStackCount(hParent:GetLevel())
	end
	self:LevelUpAttribute(self:GetStackCount())
end
function public:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = false,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = not Spawner:IsGoldRound(),
		[MODIFIER_STATE_INVULNERABLE] = true,
	-- [MODIFIER_STATE_OUT_OF_GAME] = true,
	--
	-- [MODIFIER_STATE_INVULNERABLE] = true,
	}
end
function public:OnStackCountChanged(iOldStackCount)
	local hParent = self:GetParent()
	local iNewStackCount = self:GetStackCount()
	if iOldStackCount ~= iNewStackCount then
	end
end
function public:LevelUpAttribute(iNewStackCount)
	local hParent = self:GetParent()

	--攻击
	self:SetSatrLevelAttribute('PhysicalAttack', iNewStackCount, ATTRIBUTE_KIND.PhysicalAttack)
	self:SetSatrLevelAttribute('MagicalAttack', iNewStackCount, ATTRIBUTE_KIND.MagicalAttack)

	--护甲
	self:SetSatrLevelAttribute('PhysicalArmor', iNewStackCount, ATTRIBUTE_KIND.PhysicalArmor)
	self:SetSatrLevelAttribute('MagicalArmor', iNewStackCount, ATTRIBUTE_KIND.MagicalArmor)

	--生命
	self:SetSatrLevelAttribute('StatusHealth', iNewStackCount, ATTRIBUTE_KIND.StatusHealth)
end
function public:SetSatrLevelAttribute(sKey, sKey2, typeAttribute)
	local val = self.tUpgrade[sKey] and tonumber(self.tUpgrade[sKey]) or 0
	local val2 = val

	-- 1星时取默认属性
	if sKey2 ~= 1 then
		for i = tonumber(sKey2), 2, -1 do
			if self.tUpgrade[sKey .. i] then
				val2 = tonumber(self.tUpgrade[sKey .. i])
				break
			end
		end
	end

	val = val2 - val

	local val_old = self:GetParent():GetDataVal(typeAttribute, ATTRIBUTE_KEY.STAR_LEVEL)
	if val ~= val_old then
		self:GetParent():SetVal(typeAttribute, val, ATTRIBUTE_KEY.STAR_LEVEL)
	end
end