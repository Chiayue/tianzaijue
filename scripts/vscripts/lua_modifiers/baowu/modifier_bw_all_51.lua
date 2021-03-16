
modifier_bw_all_51 = class({})

-----------------------------------------------------------------------------------------
function modifier_bw_all_51:GetTexture()
	return "item_treasure/智慧石"
end

function modifier_bw_all_51:IsHidden()
	return true
end
----------------------------------------

function modifier_bw_all_51:OnCreated( kv )
	
		self:OnRefresh()
	
end

----------------------------------------

function modifier_bw_all_51:OnRefresh()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["jqjc"] = netTable["jqjc"] +100
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end
function modifier_bw_all_51:OnDestroy()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["jqjc"] = netTable["jqjc"] -100
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end


function modifier_bw_all_51:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end