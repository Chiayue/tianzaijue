boss_pudge_tiny_bot_lua = class({})


--------------------------------------------------------------------------------

function boss_pudge_tiny_bot_lua:OnSpellStart()
        local hCaster = self:GetCaster()
        local range=self:GetCastRange(hCaster:GetOrigin(),hCaster)
        self.bot_damage = self:GetSpecialValueFor( "bot_damage" )
        local num  = 1+ math.ceil(Stage.playernum/2)
        if num <1 then
        	num = 1
        end
        if num > 5 then
            num = 5
        end
		for i=1,num do
            local  temp=CreateUnitByName("npc_boss_pudge_tiny", hCaster:GetOrigin()+RandomVector(RandomInt(300,500)), true, nil, nil, hCaster:GetTeamNumber())
            --temp:SetControllableByPlayer(hCaster:GetPlayerID(), true)
            
            
            
            
            temp:SetBaseDamageMax(self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())*self.bot_damage)
            temp:SetBaseDamageMin(self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())*self.bot_damage)

            local vLocation = self:GetCaster():GetOrigin()
			local kv =
			{
				center_x = vLocation.x,
				center_y = vLocation.y,
				center_z = vLocation.z,
				should_stun = false, 
				duration = 1,
				knockback_duration = 1,
				knockback_distance = RandomInt(300,1500),
				knockback_height = 375,
			}

			temp:AddNewModifier( hCaster, self, "modifier_knockback", kv )
			temp:AddNewModifier(unit, nil, "modifier_kill", { duration = 20 })
        end
end

--------------------------------------------------------------------------------