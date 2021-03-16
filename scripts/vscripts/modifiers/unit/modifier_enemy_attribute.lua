if modifier_enemy_attribute == nil then
	modifier_enemy_attribute = class({}, nil, eom_modifier)
end

local public = modifier_enemy_attribute

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
function public:GetPriority()
	return -1
end
function public:OnCreated(params)
	self:SetHasCustomTransmitterData(true)
	local hParent = self:GetParent()
	if IsServer() then
		-- 怪物属性修改
		if nil == self.tAttribute then
			self.tAttribute = {}
			for k, v in pairs(ENEMY_ATTRIBUTE_MODIFIER(hParent)) do
				if not self.tAttribute[k] then
					self.tAttribute[k] = v
				else
					self.tAttribute[k] = v + self.tAttribute[k]
				end
			end
			self:ForceRefresh()
		end
		-- 怪物技能修改
		if not self:GetParent():IsBoss() then
			local behability = (DIFFICULTY_INFO[GameMode:GetDifficulty()].creep_skills)
			if behability == false then
				local icount = self:GetParent():GetAbilityCount()
				for i = 0, icount - 1 do
					local hAbility = self:GetParent():GetAbilityByIndex(i)
					if IsValid(hAbility) then
						local sName = hAbility:GetName()
						if string.find(sName, 'enemy_') then
							self:GetParent():RemoveAbilityByHandle(hAbility)
						end
					end
				end
			end
		end
	end
end
function public:AddCustomTransmitterData()
	return self.tAttribute
end
function public:HandleCustomTransmitterData(tData)
	self.tAttribute = tData
end
function public:EDeclareFunctions()
	local tFuncs = {
	}
	if self.tAttribute then
		for k, v in pairs(self.tAttribute) do
			tFuncs[k] = v
		end
	end
	return tFuncs
end