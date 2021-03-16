
modifier_bw_all_70 = class({})

-----------------------------------------------------------------------------------------
function modifier_bw_all_70:GetTexture()
	return "item_treasure/智慧石"
end

function modifier_bw_all_70:IsHidden()
	return true
end
----------------------------------------

function modifier_bw_all_70:OnCreated( kv )
	
		self:OnRefresh()
	
end

----------------------------------------

function modifier_bw_all_70:OnRefresh()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["zhwsh"] = netTable["zhwsh"] +200
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end
function modifier_bw_all_70:OnDestroy()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["zhwsh"] = netTable["zhwsh"] -200
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end


function modifier_bw_all_70:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end