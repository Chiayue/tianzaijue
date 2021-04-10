
modifier_gh_1_202 = class({})

--------------------------------------------------------------------------------

function modifier_gh_1_202:GetTexture()
	return "item_treasure/刃甲"
end
--------------------------------------------------------------------------------

function modifier_gh_1_202:IsHidden()
	return true
end

function modifier_gh_1_202:OnCreated( kv )
	self:OnRefresh()
end
function modifier_gh_1_202:OnDestroy( kv )
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["wlct"] = netTable["wlct"] - 5
		netTable["mfct"] = netTable["mfct"] - 5
		SetNetTableValue("UnitAttributes",unitKey,netTable)
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, true)
		end
	end
end

function modifier_gh_1_202:OnRefresh()
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/guanghuan_1_202.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( self.nFXIndex, 0, self:GetParent():GetOrigin() )
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["wlct"] = netTable["wlct"] + 5
		netTable["mfct"] = netTable["mfct"] + 5
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end

function modifier_gh_1_202:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end