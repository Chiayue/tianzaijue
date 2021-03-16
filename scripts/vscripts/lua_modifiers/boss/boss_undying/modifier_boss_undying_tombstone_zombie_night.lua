
modifier_boss_undying_tombstone_zombie_night = class({})
--------------------------------------------------------------------------------



function modifier_boss_undying_tombstone_zombie_night:IsDebuff()
	return false
end

function modifier_boss_undying_tombstone_zombie_night:GetTexture( params )
    return "modifier_boss_undying_tombstone_zombie_night"
end
function modifier_boss_undying_tombstone_zombie_night:IsHidden()
	return false
	-- body
end
function modifier_boss_undying_tombstone_zombie_night:OnCreated( kv )
    if  IsServer() then
        
    end
	
end




function modifier_boss_undying_tombstone_zombie_night:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end


	