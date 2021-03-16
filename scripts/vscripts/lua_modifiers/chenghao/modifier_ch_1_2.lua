
modifier_ch_1_2 = class({})

-----------------------------------------------------------------------------------------
function modifier_ch_1_2:GetTexture()
	return "item_treasure/杀猪刀"
end

function modifier_ch_1_2:IsHidden()
	return true
end
----------------------------------------

function modifier_ch_1_2:OnCreated( kv )
	
		self:OnRefresh()
	
end

----------------------------------------

function modifier_ch_1_2:OnRefresh()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["bfbtsqsx"] = netTable["bfbtsqsx"] + 2
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end
function modifier_ch_1_2:OnDestroy()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["bfbtsqsx"] = netTable["bfbtsqsx"] - 2
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end


function modifier_ch_1_2:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end