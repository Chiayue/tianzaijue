
modifier_bw_3_7 = class({})

--------------------------------------------------------------------------------

function modifier_bw_3_7:GetTexture()
	return "item_treasure/神妙明灯"
end
--------------------------------------------------------------------------------
function modifier_bw_3_7:IsHidden()
	return true
end
function modifier_bw_3_7:OnCreated( kv )
	if IsServer() then
		self.startcoold=false
		self:StartIntervalThink( 1 )
	end
	self:OnRefresh()
end


function modifier_bw_3_7:OnRefresh()
	
end

function modifier_bw_3_7:OnIntervalThink()
	if IsServer() then
		if self.startcoold then
			self.startcoold=false
			self:StartIntervalThink( 1)
		else
			if self:GetParent():IsAlive() and self:GetParent():GetHealthPercent()<=30 then
				self:GetParent():Purge( false, true, false, true, true )
				self:GetParent():Heal(self:GetParent():GetMaxHealth()*0.6,self)
				local nFXIndex = ParticleManager:CreateParticle( "particles/items5_fx/essence_ring.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
				ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
				self:StartIntervalThink(10)
				self.startcoold=true
				TimerUtil.createTimerWithDelay(3,function ()
					ParticleManager:DestroyParticle(nFXIndex,true)      
				end)
			end
		end
		
	end
end
function modifier_bw_3_7:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end