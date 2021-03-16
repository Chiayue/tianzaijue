
modifier_bw_3_9 = class({})
LinkLuaModifier( "modifier_bw_3_9_debuff", "lua_modifiers/baowu/modifier_bw_3_9_debuff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function modifier_bw_3_9:GetTexture()
	return "item_treasure/浩劫巨锤"
end
--------------------------------------------------------------------------------
function modifier_bw_3_9:IsHidden()
	return true
end
function modifier_bw_3_9:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_3_9:OnRefresh()
	
end


function modifier_bw_3_9:DeclareFunctions()
	local funcs = 
	{
		
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_bw_3_9:OnAttackLanded( params )

	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.attacker then
			local hTarget = params.target
			if hTarget ~= nil  and RollPercentage(2) then
				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_huskar/huskar_inner_fire.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
				ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
				local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
				for _,enemy in pairs( enemies ) do
					if enemy ~= nil and enemy:IsInvulnerable() == false then
						local vLocation=self:GetParent():GetAbsOrigin()
						local kv_knockback =
						{
							center_x = vLocation.x,
							center_y = vLocation.y,
							center_z = vLocation.z,
							should_stun = true, 
							duration = 0.4,
							knockback_duration = 0.4,
							knockback_distance = 300,
							knockback_height = 0,
						}
						if enemy.isboss ~= 1 then
							enemy:AddNewModifier( self:GetParent(), nil, "modifier_knockback", kv_knockback )
							enemy:AddNewModifier( self:GetParent(), nil, "modifier_bw_3_9_debuff", {duration=3} )
						end
						local damageInfo =
						{
							victim = enemy,
							attacker = self:GetParent(),
							damage = self:GetParent():GetStrength()*30,
							damage_type = DAMAGE_TYPE_PHYSICAL,
							ability = nil,
						}
						ApplyDamage( damageInfo )
					end
				end
				
			end
		end
	end

	return 0.0

end
function modifier_bw_3_9:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end