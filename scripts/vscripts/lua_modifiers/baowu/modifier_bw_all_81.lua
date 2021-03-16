
modifier_bw_all_81 = class({})

-----------------------------------------------------------------------------------------
function modifier_bw_all_81:GetTexture()
	return "item_treasure/智慧石"
end

function modifier_bw_all_81:IsHidden()
	return true
end
----------------------------------------

function modifier_bw_all_81:OnCreated( kv )
	
		self:OnRefresh()
	
end

----------------------------------------

function modifier_bw_all_81:OnRefresh()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["sds"] = netTable["sds"] +20000
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end


function modifier_bw_all_81:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end