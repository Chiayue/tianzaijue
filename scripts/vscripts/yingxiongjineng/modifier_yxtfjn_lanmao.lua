
modifier_yxtfjn_lanmao = class({})

--------------------------------------------------------------------------------

function modifier_yxtfjn_lanmao:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_yxtfjn_lanmao:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_yxtfjn_lanmao:OnCreated( kv )
    self.costmana=self:GetAbility():GetSpecialValueFor("costmana")
    self.costdis=self:GetAbility():GetSpecialValueFor("costdis")
    self.speed=self:GetAbility():GetSpecialValueFor("speed")
    self.i=self:GetAbility():GetSpecialValueFor("i")
	if IsServer() then
		
		self.enemy={}
		
		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
			return
		end
		self.particleID = ParticleManager:CreateParticle("particles/econ/items/storm_spirit/storm_spirit_orchid_hat/stormspirit_orchid_ball_lightning.vpcf",PATTACH_ABSORIGIN_FOLLOW,self:GetParent())--火女火焰灰烬特效
		ParticleManager:SetParticleControl(self.particleID,0,self:GetParent():GetOrigin())
		ParticleManager:SetParticleControlEnt( self.particleID, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		EmitSoundOn( "Hero_StormSpirit.Orchid_BallLightning", self:GetParent() )

		EmitSoundOn("Hero_StormSpirit.BallLightning.Loop", self:GetParent())
	end
end

--------------------------------------------------------------------------------

function modifier_yxtfjn_lanmao:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_yxtfjn_lanmao:CheckState()
	local state = 
	{
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
	}
	return state
end

--------------------------------------------------------------------------------

function modifier_yxtfjn_lanmao:OnDestroy()
	if IsServer() then
		if self.particleID ~= nil then
			ParticleManager:DestroyParticle(self.particleID , true)
		end
		StopSoundOn("Hero_StormSpirit.BallLightning.Loop", self:GetParent())
		self:GetParent():RemoveHorizontalMotionController( self )
	end
end

--------------------------------------------------------------------------------

function modifier_yxtfjn_lanmao:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		local vLocation = nil
		local caster = self:GetParent()
		if caster ~= nil and caster:IsAlive() then
			local fDist = (caster:GetOrigin() - self:GetAbility().StartPos ):Length2D()/100
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 400,
                    DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
			local target
			local damage = (2+fDist*fDist*self.i)*caster:GetIntellect()
			for _,enemy in pairs(enemies) do
				local hasenemy=true
				for k,v in pairs(self.enemy) do
					if v==enemy:GetEntityIndex() then
						hasenemy=false
					end
				end
				if hasenemy then
					table.insert(self.enemy,enemy:GetEntityIndex())
					ApplyDamageMf(caster,enemy,self:GetAbility(),damage)	
				end
			end
            if caster:GetMana()<self.costmana then
            	if not caster:HasModifier("modifier_yxtfjn_lanmao_buff") then
					caster:AddNewModifier( caster, nil, "modifier_yxtfjn_lanmao_buff", {duration = 10} )
					caster:SetModifierStackCount( "modifier_yxtfjn_lanmao_buff",caster, math.ceil(fDist*8) )
				end
                self:Destroy()
            end
            vLocation = caster:GetOrigin()+self:GetAbility().vDirection*self.speed
            
            local temp =( vLocation - self:GetAbility().StartPos ):Length2D()
            local cc=caster:SpendMana(math.ceil(self.speed/self.costdis*self.costmana),self:GetAbility()) 
            if not GridNav:CanFindPath( vLocation, caster:GetOrigin() ) then
            	if not caster:HasModifier("modifier_yxtfjn_lanmao_buff") then
					caster:AddNewModifier( caster, nil, "modifier_yxtfjn_lanmao_buff", {duration = 10} )
					caster:SetModifierStackCount( "modifier_yxtfjn_lanmao_buff",caster, math.ceil(fDist*8) )
				end
                self:Destroy()
            end
            local endDist = (caster:GetOrigin() - self:GetAbility().EndPos ):Length2D()
            if  endDist<100 then
          		if not caster:HasModifier("modifier_yxtfjn_lanmao_buff") then
					caster:AddNewModifier( caster, nil, "modifier_yxtfjn_lanmao_buff", {duration = 10} )
					caster:SetModifierStackCount( "modifier_yxtfjn_lanmao_buff",caster, math.ceil(fDist*8) )
				end
                self:Destroy()
            end
            
			me:SetOrigin( vLocation )
		end
		
	end
end


--------------------------------------------------------------------------------

function modifier_yxtfjn_lanmao:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_yxtfjn_lanmao:GetOverrideAnimation( params )
	return ACT_DOTA_OVERRIDE_ABILITY_4
end

--------------------------------------------------------------------------------

function modifier_yxtfjn_lanmao:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetCaster() then
			self:Destroy()
		end
	end

	return 0
end
