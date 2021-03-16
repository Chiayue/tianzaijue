modifier_pudge_meat_hook_lua = class({})
--------------------------------------------------------------------------------

function modifier_pudge_meat_hook_lua:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_pudge_meat_hook_lua:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_pudge_meat_hook_lua:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_pudge_meat_hook_lua:OnCreated( kv )
	if IsServer() then
		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_pudge_meat_hook_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_pudge_meat_hook_lua:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------

function modifier_pudge_meat_hook_lua:CheckState()
	if IsServer() then
		if self:GetCaster() ~= nil and self:GetParent() ~= nil then
			if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() and ( not self:GetParent():IsMagicImmune() ) then
				local state = {
				[MODIFIER_STATE_STUNNED] = true,
				}

				return state
			end
		end
	end

	local state = {}

	return state
end

--------------------------------------------------------------------------------

function modifier_pudge_meat_hook_lua:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		for k,v in pairs(self:GetAbility().Projectile) do
			if self:GetParent()== v.hVictim then
				v.hVictim:SetOrigin( v.vProjectileLocation )
				local vToCaster = v.vStartPosition - self:GetCaster():GetOrigin()
				local flDist = vToCaster:Length2D()
				if v.bChainAttached == false and flDist > 128.0 then 
					v.bChainAttached = true  
					ParticleManager:SetParticleControlEnt( v.nChainParticleFXIndex, 0, self:GetCaster(), PATTACH_CUSTOMORIGIN, "attach_hitloc", self:GetCaster():GetOrigin(), true )
					ParticleManager:SetParticleControl( v.nChainParticleFXIndex, 0, v.vStartPosition + self:GetAbility().vHookOffset )
				end                   
			end
		end 
		
	end
end

--------------------------------------------------------------------------------
function modifier_pudge_meat_hook_lua:OnHorizontalMotionInterrupted()
	if IsServer() then
		for k,v in pairs(self:GetAbility().Projectile) do
			if self:GetParent()== v.hVictim then
				ParticleManager:SetParticleControlEnt( v.nChainParticleFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_weapon_chain_rt", self:GetCaster():GetAbsOrigin() + self:GetAbility().vHookOffset, true )
				self:Destroy()
			end
		end
	end
end
