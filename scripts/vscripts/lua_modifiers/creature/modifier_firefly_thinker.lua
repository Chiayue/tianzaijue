modifier_firefly_thinker = class({})

-----------------------------------------------------------------------------

function modifier_firefly_thinker:OnCreated( kv )
	
	
	if IsServer() then
        self:StartIntervalThink(0.2)
	end
end
function modifier_firefly_thinker:IsHidden()
    return true
end

function modifier_firefly_thinker:OnIntervalThink()
    if IsServer() then
        hCaster=self:GetCaster()
        if hCaster==nil then
            return nil
        end
        local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
        for _,enemy in pairs( enemies ) do
            if enemy ~= nil and enemy:IsInvulnerable() == false then
                if not enemy:HasModifier("modifier_firefly_damage") then
                    enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_firefly_damage", {duration=1} )
                end
            end
        end
	end
end
-----------------------------------------------------------------------------

function modifier_firefly_thinker:OnDestroy()
	if IsServer() then
        
	end
end

-----------------------------------------------------------------------------

