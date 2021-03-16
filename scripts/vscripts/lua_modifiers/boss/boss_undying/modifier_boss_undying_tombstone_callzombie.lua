
modifier_boss_undying_tombstone_callzombie = class({})
--------------------------------------------------------------------------------

function modifier_boss_undying_tombstone_callzombie:IsDebuff()
	return false
end

function modifier_boss_undying_tombstone_callzombie:GetTexture( params )
    return "modifier_boss_undying_tombstone_callzombie"
end
function modifier_boss_undying_tombstone_callzombie:IsHidden()
	return false
	-- body
end
function modifier_boss_undying_tombstone_callzombie:OnCreated( kv )
    if  IsServer() then
        self:StartIntervalThink(1)
    end
	
end




-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

function modifier_boss_undying_tombstone_callzombie:OnIntervalThink()
    if IsServer() then
        local hCaster=self:GetCaster()
        
        if self:GetAbility():IsCooldownReady() and hCaster:IsAlive() then
            local owner=hCaster:GetOwnerEntity()
            local enemies = FindUnitsInRadius(
                hCaster:GetTeamNumber(),
                hCaster:GetOrigin(),
                nil,
                1200,
                2,
                1,
                0,
                0,
                false
            )
            for i=1,#enemies do
                local point = enemies[i]:GetOrigin()
                local tempunit=CreateUnitByName("npc_boss_undying_zombie", point, true, nil, nil, hCaster:GetTeam() )
                FindClearSpaceForUnit(sxxx,point,true)
                tempunit:AddNewModifier(hCaster, self, "modifier_kill", {duration=30})
                tempunit:SetBaseDamageMax(owner:GetBaseDamageMax())
                tempunit:SetBaseDamageMin(owner:GetBaseDamageMin())
                tempunit:SetPhysicalArmorBaseValue(owner:GetPhysicalArmorValue(false ))
                tempunit:SetBaseMagicalResistanceValue(owner:GetMagicalArmorValue()*100)
                tempunit:SetMaxHealth(owner:GetMaxHealth()*0.05)
                tempunit:SetHealth(owner:GetMaxHealth()*0.05)
            end
            self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(1))
        end
            
    end
end

function modifier_boss_undying_tombstone_callzombie:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end


	