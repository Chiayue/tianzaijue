
modifier_bw_all_2 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_2:GetTexture()
	return "item_treasure/皇者之路"
end
--------------------------------------------------------------------------------
function modifier_bw_all_2:IsHidden()
	return true
end
function modifier_bw_all_2:OnCreated( kv )
	if IsServer() then
		local num=0
		for i=0,self:GetParent():GetModifierCount() do
			local ModifierName=self:GetParent():GetModifierNameByIndex(i)
			if lua_string_split(ModifierName, "_")[2]=="bw" and ModifierName~=self:GetName() then
				
				if self:GetParent():FindModifierByName(ModifierName):GetAbility() then
					num=num+self:GetParent():FindModifierByName(ModifierName):GetAbility():GetLevel()
					self:GetParent():RemoveAbility(self:GetParent():FindModifierByName(ModifierName):GetAbility():GetAbilityName())
				end
				if self:GetParent():FindModifierByName(ModifierName) then  --如果是技能，则modifier已经被删除了
					if self:GetParent():FindModifierByName(ModifierName):GetStackCount()>1 then
						num=num+self:GetParent():FindModifierByName(ModifierName):GetStackCount()
					else
						num=num+1
					end
				end
				self:GetParent():RemoveModifierByName(ModifierName)
			end
			
		end
		self:SetStackCount(1)
		if num>0 then
			if num > 18 then
				num=18
			end
			self:GetParent():SetBaseIntellect(self:GetParent():GetBaseIntellect()*math.pow(1.2,num))
			self:GetParent():SetBaseStrength(self:GetParent():GetBaseStrength()*math.pow(1.2,num))
			self:GetParent():SetBaseAgility(self:GetParent():GetBaseAgility()*math.pow(1.2,num))
			self:SetStackCount(num)
		end
		
		self:GetParent():CalculateStatBonus(true) --刷新属性，避免卡属性
	end
end


function modifier_bw_all_2:OnRefresh()
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)
		self:GetParent():SetBaseIntellect(self:GetParent():GetBaseIntellect()*math.pow(1.2,1))
		self:GetParent():SetBaseStrength(self:GetParent():GetBaseStrength()*math.pow(1.2,1))
		self:GetParent():SetBaseAgility(self:GetParent():GetBaseAgility()*math.pow(1.2,1))
		
		self:GetParent():CalculateStatBonus(true) --刷新属性，避免卡属性
	end
	
end


function modifier_bw_all_2:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end