
modifier_ch_4_13 = class({})

--------------------------------------------------------------------------------

function modifier_ch_4_13:GetTexture()
	return "item_treasure/力量护腕"
end

function modifier_ch_4_13:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_ch_4_13:OnCreated( kv )
	self:OnRefresh()
end
--------------------------------------------------------------------------------

function modifier_ch_4_13:OnRefresh()
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/ch/ch_lkhgfdsa_3.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( self.nFXIndex, 0, self:GetParent():GetOrigin() )
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["tmz"] = netTable["tmz"] + 20
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end
function modifier_ch_4_13:OnDestroy()
	if IsServer() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, true)
		end
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["tmz"] = netTable["tmz"] - 20
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end

function modifier_ch_4_13:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

