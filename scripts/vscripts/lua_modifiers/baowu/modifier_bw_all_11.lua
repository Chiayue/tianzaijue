
modifier_bw_all_11 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_11:GetTexture()
	return "item_treasure/愿赌服输"
end
--------------------------------------------------------------------------------
function modifier_bw_all_11:IsHidden()
	return true
end
function modifier_bw_all_11:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_all_11:OnRefresh()
	if IsServer() then
		--1攻击，2护甲，3力量，4敏捷，5智力，6最大生命值 的一项  （10-30%）	再随机增加，上面一个属性，增加 （20-50%）
		local cutrandomvalue=RandomInt(1, 6)
		local addrandomvalue=RandomInt(1, 6)
		local cut=RandomInt(-30,-10)
		local add=RandomInt(20,50)
		print("cutrandomvalue=="..cutrandomvalue)
		print("cut=="..cut)
		print("addrandomvalue=="..addrandomvalue)
		print("add=="..add)
		if cutrandomvalue==1 or addrandomvalue==1 then
			local endpersent=0
			if cutrandomvalue==1 then
				endpersent=endpersent+cut
			end
			if addrandomvalue==1 then
				endpersent=endpersent+add
			end
			local damage=self:GetParent():GetAverageTrueAttackDamage(self:GetParent())*endpersent/100
			print("damage=="..damage)
			self:GetParent():SetBaseDamageMin(self:GetParent():GetBaseDamageMin()+damage)
			self:GetParent():SetBaseDamageMax(self:GetParent():GetBaseDamageMin()+damage)
		end
		if cutrandomvalue==2 or addrandomvalue==2 then
			local endpersent=0
			if cutrandomvalue==2 then
				endpersent=endpersent+cut
			end
			if addrandomvalue==2 then
				endpersent=endpersent+add
			end
			local armor=self:GetParent():GetPhysicalArmorValue(false)*endpersent/100
			print("armor=="..armor)
			self:GetParent():SetPhysicalArmorBaseValue(self:GetParent():GetPhysicalArmorBaseValue()+armor)
		end
		if cutrandomvalue==3 or addrandomvalue==3 then
			local endpersent=0
			if cutrandomvalue==3 then
				endpersent=endpersent+cut
			end
			if addrandomvalue==3 then
				endpersent=endpersent+add
			end
			local Strength=self:GetParent():GetStrength()*endpersent/100
			print("Strength=="..Strength)
			self:GetParent():ModifyStrength(Strength)
			
		end
		if cutrandomvalue==4 or addrandomvalue==4 then
			local endpersent=0
			if cutrandomvalue==4 then
				endpersent=endpersent+cut
			end
			if addrandomvalue==4 then
				endpersent=endpersent+add
			end
			local Agility=self:GetParent():GetAgility()*endpersent/100
			print("Agility=="..Agility)
			self:GetParent():ModifyAgility(Agility)
		end
		if cutrandomvalue==5 or addrandomvalue==5 then
			local endpersent=0
			if cutrandomvalue==5 then
				endpersent=endpersent+cut
			end
			if addrandomvalue==5 then
				endpersent=endpersent+add
			end
			local Intellect=self:GetParent():GetIntellect()*endpersent/100
			print("Intellect=="..Intellect)
			self:GetParent():ModifyIntellect(Intellect)
		end
		if cutrandomvalue==6 or addrandomvalue==6 then
			local endpersent=0
			if cutrandomvalue==6 then
				endpersent=endpersent+cut
			end
			if addrandomvalue==6 then
				endpersent=endpersent+add
			end
			local Health=self:GetParent():GetMaxHealth()*endpersent/100
			print("Health=="..Health)
			self:GetParent():SetMaxHealth(self:GetParent():GetMaxHealth()+Health)
		end
		
	end
end


function modifier_bw_all_11:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end