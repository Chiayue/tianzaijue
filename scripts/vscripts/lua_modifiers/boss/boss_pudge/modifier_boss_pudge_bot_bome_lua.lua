
modifier_boss_pudge_bot_bome_lua = class({})


function modifier_boss_pudge_bot_bome_lua:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end
function modifier_boss_pudge_bot_bome_lua:OnDeath( params )	--
    if IsServer() then
    
        if self:GetParent()==params.unit and params.unit==params.attacker then
            local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_techies/techies_blast_off.vpcf", PATTACH_CUSTOMORIGIN, nil )
            ParticleManager:SetParticleControl( nFXIndex, 0,self:GetParent():GetOrigin() )
            ParticleManager:ReleaseParticleIndex(nFXIndex)
            EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_Techies.Suicide.Arcana", self:GetParent() )
			local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 1000,
					DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
					DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
			for _,enemy in pairs(enemies) do
				if enemy~=self:GetCaster() then
					enemy:Heal(enemy:GetMaxHealth(), enemy)
					enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_boss_pudge_bot_bome_lua_effect", {})
				end
				
			end
            
        end
    end
end

--------------------------------------------------------------------------------

function modifier_boss_pudge_bot_bome_lua:IsDebuff()
	return false
end

function modifier_boss_pudge_bot_bome_lua:GetTexture( params )
    return "modifier_boss_pudge_bot_bome_lua"
end
function modifier_boss_pudge_bot_bome_lua:IsHidden()
	return false
	-- body
end
function modifier_boss_pudge_bot_bome_lua:OnCreated( kv )
    if  IsServer() then
    end
	
end

function modifier_boss_pudge_bot_bome_lua:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end


	