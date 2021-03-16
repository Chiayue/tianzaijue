
modifier_cw_3_11 = class({})

-----------------------------------------------------------------------------------------
function modifier_cw_3_11:GetTexture()
	return "item_treasure/杀猪刀"
end

function modifier_cw_3_11:IsHidden()
	return true
end
----------------------------------------

function modifier_cw_3_11:OnCreated( kv )
	
		self:OnRefresh()
	
end

----------------------------------------

function modifier_cw_3_11:OnRefresh()
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return nil
		end
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["grjndj"] = netTable["grjndj"] + 2
		netTable["jqjc"] = netTable["jqjc"] + 12
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end
function modifier_cw_3_11:OnDestroy()
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return nil
		end
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["grjndj"] = netTable["grjndj"] - 2
		netTable["jqjc"] = netTable["jqjc"] - 12
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end


function modifier_cw_3_11:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end