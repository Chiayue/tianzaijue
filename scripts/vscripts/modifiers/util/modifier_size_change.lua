if modifier_size_change == nil then
	modifier_size_change = class({})
end
function modifier_size_change:IsHidden()
	return true
end
function modifier_size_change:IsDebuff()
	return false
end
function modifier_size_change:IsPurgable()
	return false
end
function modifier_size_change:IsPurgeException()
	return false
end
function modifier_size_change:AllowIllusionDuplicate()
	return false
end
function modifier_size_change:DestroyOnExpire()
	return false
end
function modifier_size_change:OnCreated(table)
	if IsServer() then
		self.fSize = table.size
		local fps = 10
		local iDuration = self:GetDuration()
		self.fV = (self.fSize - self:GetParent():GetModelScale()) / (fps / iDuration)
		-- self:SetStackCount(100)
		self:StartIntervalThink(1 / fps)
	end
end
function modifier_size_change:OnDestroy()
	if IsServer() then
	end
end
function modifier_size_change:OnIntervalThink()
	if IsServer() then
		-- self:SetStackCount(self:GetStackCount() + self.fV * 100)
		self:GetParent():SetModelScale(self:GetParent():GetModelScale() - self.fV)
	end
end
-- function modifier_size_change:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_MODEL_SCALE,
-- 	}
-- end
-- function modifier_size_change:GetModifierModelScale()
-- 	return self:GetStackCount() * 0.01
-- end