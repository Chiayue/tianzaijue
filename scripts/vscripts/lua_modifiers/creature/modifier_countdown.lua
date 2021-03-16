
modifier_countdown = class({})

--------------------------------------------------------------------------------

function modifier_countdown:GetTexture()
	return "item_treasure/守护指环"
end



function modifier_countdown:IsHidden()
	return true
end
--------------------------------------------------------------------------------


function modifier_countdown:OnCreated(keys )
	if IsServer() then
		self:StartIntervalThink( 1 )
		self.duration = keys.duration
		local caster = self:GetCaster()
		local timerCP1_x = math.floor(self.duration / 10)
		local timerCP1_y = self.duration % 10
		self.pfx = ParticleManager:CreateParticle( "particles/units/countdown.vpcf", PATTACH_OVERHEAD_FOLLOW, caster )
		ParticleManager:SetParticleControl(self.pfx, 1, Vector( timerCP1_x, timerCP1_y, 0 ) )
	
	end
	
end

function modifier_countdown:OnIntervalThink()
	if IsServer() then
		self.duration  = self.duration  -1
		local timerCP1_x = math.floor(self.duration / 10)
		local timerCP1_y = self.duration % 10
		ParticleManager:SetParticleControl( self.pfx, 1, Vector( timerCP1_x, timerCP1_y, 0 ) )
	end
end
function modifier_countdown:OnDestroy( kv )
	if IsServer() then
		if self.pfx then
			ParticleManager:DestroyParticle(self.pfx, true)
		end
		
		
	end
end


-----------------------------------------------------------------------

	