
modifier_cw_1_202 = class({})

-----------------------------------------------------------------------------------------
function modifier_cw_1_202:GetTexture()
	return "item_treasure/杀猪刀"
end

function modifier_cw_1_202:IsHidden()
	return true
end
----------------------------------------

function modifier_cw_1_202:OnCreated( kv )
	
		self:OnRefresh()
	
end

----------------------------------------

function modifier_cw_1_202:OnRefresh()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["sgzjjb"] = netTable["sgzjjb"] + 15
		netTable["jqjc"] = netTable["jqjc"] + 10
		netTable["jyjc"] = netTable["jyjc"] + 10
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end
function modifier_cw_1_202:OnDestroy()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["sgzjjb"] = netTable["sgzjjb"] - 15
		netTable["jqjc"] = netTable["jqjc"] - 10
		netTable["jyjc"] = netTable["jyjc"] - 10
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end


function modifier_cw_1_202:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end