boss_pudge_bot_bome_lua = class({})
LinkLuaModifier( "modifier_boss_pudge_bot_bome_lua","lua_modifiers/boss/boss_pudge/modifier_boss_pudge_bot_bome_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_pudge_bot_bome_lua_effect","lua_modifiers/boss/boss_pudge/modifier_boss_pudge_bot_bome_lua_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function boss_pudge_bot_bome_lua:OnSpellStart()
        local hCaster = self:GetCaster()
        local range=self:GetCastRange(hCaster:GetOrigin(),hCaster)
        self.bot_health = self:GetSpecialValueFor( "bot_health" )
        self.bot_time = self:GetSpecialValueFor( "bot_time" )
        
         local num  = 2+ 2*Stage.playernum
         
		for i=1,num do
            local  temp=CreateUnitByName("npc_boss_pudge_bot", hCaster:GetOrigin()+RandomVector(RandomInt(100,1200)), true, nil, nil, 3)
            --temp:SetControllableByPlayer(hCaster:GetPlayerID(), true)
            temp:SetBaseMaxHealth(hCaster:GetHealth()*self.bot_health)
            temp:SetHealth(hCaster:GetHealth()*self.bot_health)
            temp:SetMaxHealth(hCaster:GetHealth()*self.bot_health)
            temp:SetBaseDamageMax(self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()))
            temp:SetBaseDamageMin(self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()))
            temp:SetBaseMagicalResistanceValue(self:GetCaster():GetMagicalArmorValue())
            temp:SetPhysicalArmorBaseValue(self:GetCaster():GetPhysicalArmorBaseValue())
            
            
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
            temp:AddNewModifier(hCaster, self, "modifier_kill", {duration=self.bot_time})
            temp:AddNewModifier(hCaster, self, "modifier_boss_pudge_bot_bome_lua", {})
        end
end

--------------------------------------------------------------------------------