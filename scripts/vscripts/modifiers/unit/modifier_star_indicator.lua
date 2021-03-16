if modifier_star_indicator == nil then
	modifier_star_indicator = class({}, nil, eom_modifier)
end

local public = modifier_star_indicator

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
function public:GetTexture()
	return "modifier_star_indicator"
end
function public:OnCreated(params)
	local hParent = self:GetParent()
	self.tKV = KeyValues.UnitsKv[hParent:GetUnitName()] or {}
	self:OnRefresh(params)
end
function public:OnRefresh(params)
	local hParent = self:GetParent()
	if IsServer() then
		local iStar = hParent:GetLevel()
		self:SetStackCount(iStar)
	end
	self:LevelUpAttribute(self:GetStackCount())
	self:SetLevelParticle()
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
	local val = self.tKV[sKey] and tonumber(self.tKV[sKey]) or 0
	local val2 = val

	-- 1星时取默认属性
	if sKey2 ~= 1 then
		for i = tonumber(sKey2), 2, -1 do
			if self.tKV[sKey .. i] then
				val2 = tonumber(self.tKV[sKey .. i])
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
function public:SetLevelParticle()
	local hParent = self:GetParent()
	local iStar = self:GetStackCount()
	if IsServer() then
	else
		local sPtclName
		if 4 == iStar then
			sPtclName = 'particles/tui/level4.vpcf'
		elseif 5 == iStar then
			sPtclName = 'particles/tui/level5.vpcf'
		end
		if self.iPtclID then
			ParticleManager:DestroyParticle(self.iPtclID, true)
			self.iPtclID = nil
		end
		if sPtclName then
			self.iPtclID = ParticleManager:CreateParticle(sPtclName, PATTACH_POINT_FOLLOW, hParent)
			ParticleManager:SetParticleControlEnt(self.iPtclID, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, "", hParent:GetAbsOrigin(), true)
			-- ParticleManager:SetParticleControl(self.iPtclID, 1, GetGroundPosition(hParent:GetAbsOrigin()))
			-- ParticleManager:SetParticleControl(self.iPtclID, 0, GetGroundPosition(hParent:GetAbsOrigin()))
		end
		-- ParticleManager:SetParticleControl(iParticleID, 0, hUnit:GetAbsOrigin())
		-- ParticleManager:SetParticleControlEnt(iParticleID, 1, hHero, PATTACH_POINT_FOLLOW, "attach_hitloc", hHero:GetAbsOrigin(), true)
		-- ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
function public:GetModifierModelScale()
	local hParent = self:GetParent()
	local iStar = self:GetStackCount()
	if nil ~= self.tKV['ModelScale' .. iStar] then
		return (self.tKV['ModelScale' .. iStar] / self.tKV['ModelScale']) * 100 - 100
	end
	return 0
end
function public:EDeclareFunctions()
	return {
		EMDF_MODEL_SCALE,
	}
end