modifier_boss_pudge_rot_creatwenyi_lua_thinker = class({})

-----------------------------------------------------------------------------

function modifier_boss_pudge_rot_creatwenyi_lua_thinker:OnCreated( kv )
	
	
	if IsServer() then
        self:StartIntervalThink(0.2)
	end
end
function modifier_boss_pudge_rot_creatwenyi_lua_thinker:IsHidden()
    return true
end

function modifier_boss_pudge_rot_creatwenyi_lua_thinker:OnIntervalThink()
    if IsServer() then
        hCaster=self:GetCaster()
        if hCaster==nil then
            return nil
        end
        local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), 350, DOTA_UNIT_TARGET_TEAM_BOTH , DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
        for _,enemy in pairs( enemies ) do
            if enemy ~= nil and enemy:IsInvulnerable() == false then
                if not enemy:HasModifier("modifier_boss_pudge_rot_creatwenyi_damage") then
                    enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_boss_pudge_rot_creatwenyi_damage", {duration=1} )
                end
            end
        end
	end
end
-----------------------------------------------------------------------------

function modifier_boss_pudge_rot_creatwenyi_lua_thinker:OnDestroy()
	if IsServer() then
        
	end
end

-----------------------------------------------------------------------------

