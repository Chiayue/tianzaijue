
modifier_bw_1_12 = class({})

-----------------------------------------------------------------------------------------
function modifier_bw_1_12:GetTexture()
	return "item_treasure/杀猪刀"
end

function modifier_bw_1_12:IsHidden()
	return true
end
----------------------------------------

function modifier_bw_1_12:OnCreated( kv )
	
		self:OnRefresh()
	
end

----------------------------------------

function modifier_bw_1_12:OnRefresh()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["wlbjgl"] = netTable["wlbjgl"] +5
		netTable["wlbjsh"] = netTable["wlbjsh"] + 30
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end
function modifier_bw_1_12:OnDestroy()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["wlbjgl"] = netTable["wlbjgl"] -5
		netTable["wlbjsh"] = netTable["wlbjsh"] - 30
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end


function modifier_bw_1_12:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end