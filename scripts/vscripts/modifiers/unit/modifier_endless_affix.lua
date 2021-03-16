if modifier_endless_affix == nil then
	modifier_endless_affix = class({}, nil, eom_modifier)
end

local public = modifier_endless_affix

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
	return true
end
function public:DestroyOnExpire()
	return false
end
function public:IsPermanent()
	return true
end
function public:OnCreated(params)
	local hParent = self:GetParent()
	if IsServer() then
		local tData = NetEventData:GetTableValue('service', 'info_endless_affix')
		if tData then
			for sName, _ in pairs(KeyValues.AffixKv) do
				local sid = tonumber(KeyValues.AffixKv[sName].UniqueID)
				if sid == tData.affix then
					local sModifier = 'modifier_' .. sName
					if tData['tag'] then
						hParent:AddNewModifier(hParent, nil, sModifier, { tag1 = tData['tag'][1] or '', tag2 = tData['tag'][2] or '' })
						-- if sid == 5010012 then
						-- 	print('HuoShao', tData['tag'][1], tData['tag'][2])
						-- else
						-- 	hParent:AddNewModifier(hParent, nil, sModifier, {})
						-- end
					end
				end
			end
		end
	end
end
function public:OnRemoved()
	if IsServer() then
	end
end
function public:OnDestroy()
	if IsServer() then
		-- RemoveModifierEvents(MODIFIER_EVENT_ON_DEATH, self, nil, self:GetParent())
	end
end
function public:OnIntervalThink()
end
function public:CheckState()
	return {
	-- [MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end
-- function public:OnDeath(params)
-- 	if params.unit == self:GetParent() then
-- 		self:GetAbility():DamagePlayer()
-- 	end
-- end