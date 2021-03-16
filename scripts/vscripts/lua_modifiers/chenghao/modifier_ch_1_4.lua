
modifier_ch_1_4 = class({})

-----------------------------------------------------------------------------------------
function modifier_ch_1_4:GetTexture()
	return "item_treasure/杀猪刀"
end

function modifier_ch_1_4:IsHidden()
	return true
end
----------------------------------------

function modifier_ch_1_4:OnCreated( kv )
	
		self:OnRefresh()
	
end

----------------------------------------

function modifier_ch_1_4:OnRefresh()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		if self:GetParent():GetPrimaryAttribute()==0 then
			netTable["bfbtsqll"] = netTable["bfbtsqll"] + 4
		elseif self:GetParent():GetPrimaryAttribute()==1 then
			netTable["bfbtsqmj"] = netTable["bfbtsqmj"] + 4
		else
			netTable["bfbtsqzl"] = netTable["bfbtsqzl"] + 4	
		end
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end
function modifier_ch_1_4:OnDestroy()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		if self:GetParent():GetPrimaryAttribute()==0 then
			netTable["bfbtsqll"] = netTable["bfbtsqll"] - 4
		elseif self:GetParent():GetPrimaryAttribute()==1 then
			netTable["bfbtsqmj"] = netTable["bfbtsqmj"] - 4
		else
			netTable["bfbtsqzl"] = netTable["bfbtsqzl"] - 4	
		end
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end


function modifier_ch_1_4:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end