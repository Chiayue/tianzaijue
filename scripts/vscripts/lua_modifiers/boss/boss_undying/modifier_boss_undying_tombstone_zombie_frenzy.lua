
modifier_boss_undying_tombstone_zombie_frenzy = class({})
--------------------------------------------------------------------------------


function modifier_boss_undying_tombstone_zombie_frenzy:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

function modifier_boss_undying_tombstone_zombie_frenzy:IsDebuff()
	return false
end

function modifier_boss_undying_tombstone_zombie_frenzy:GetTexture( params )
    return "modifier_boss_undying_tombstone_zombie_frenzy"
end
function modifier_boss_undying_tombstone_zombie_frenzy:IsHidden()
	return false
	-- body
end
function modifier_boss_undying_tombstone_zombie_frenzy:OnCreated( kv )
    if  IsServer() then
        
    end
	
end




-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

function modifier_boss_undying_tombstone_zombie_frenzy:OnDeath( params )
    if IsServer() then
        
        local hCaster=self:GetCaster()
        local point=params.unit:GetOrigin()
		if hCaster:GetHealthPercent()<50 and RollPercentage(90) and  params.unit ~= nil and  (hCaster:GetOrigin()-point):Length2D()<2000 then
			local tempunit=CreateUnitByName("npc_boss_undying_zombie", point, true, nil, nil, hCaster:GetTeam() )
            FindClearSpaceForUnit(sxxx,point,true)
            tempunit:SetBaseDamageMax(hCaster:GetBaseDamageMax())
            tempunit:SetBaseDamageMin(hCaster:GetBaseDamageMin())
            tempunit:SetPhysicalArmorBaseValue(hCaster:GetPhysicalArmorValue(false ))
            tempunit:SetBaseMagicalResistanceValue(hCaster:GetMagicalArmorValue()*100)
            tempunit:SetMaxHealth(hCaster:GetMaxHealth()*0.05)
            tempunit:SetHealth(hCaster:GetMaxHealth()*0.05)
		end
	end
end

function modifier_boss_undying_tombstone_zombie_frenzy:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end


	