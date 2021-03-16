boss_pudge_tiny_bot_lua = class({})


--------------------------------------------------------------------------------

function boss_pudge_tiny_bot_lua:OnSpellStart()
        local hCaster = self:GetCaster()
        local range=self:GetCastRange(hCaster:GetOrigin(),hCaster)
        self.bot_health = self:GetSpecialValueFor( "bot_health" )
        self.bot_damage = self:GetSpecialValueFor( "bot_damage" )
        self.bot_armor = self:GetSpecialValueFor( "bot_armor" )
        self.bot_magicarmor = self:GetSpecialValueFor( "bot_magicarmor" )
        local enemies = FindUnitsInRadius(
            hCaster:GetTeamNumber(),
            hCaster:GetOrigin(),
            nil,
            range,
            2,
            1,
            0,
            0,
            false
        )
		for i=1,#enemies do
            local  temp=CreateUnitByName("npc_boss_pudge_tiny", hCaster:GetOrigin(), true, nil, nil, hCaster:GetTeamNumber())
            --temp:SetControllableByPlayer(hCaster:GetPlayerID(), true)
            
            temp:SetBaseMaxHealth(hCaster:GetHealth()*self.bot_health)
            temp:SetHealth(hCaster:GetHealth()*self.bot_health)
            temp:SetMaxHealth(hCaster:GetHealth()*self.bot_health)
            
            
            temp:SetBaseDamageMax(self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())*self.bot_damage)
            temp:SetBaseDamageMin(self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())*self.bot_damage)
            temp:SetBaseMagicalResistanceValue(self:GetCaster():GetMagicalArmorValue()*self.bot_magicarmor)
            temp:SetPhysicalArmorBaseValue(self:GetCaster():GetPhysicalArmorBaseValue()*self.bot_armor)
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
			
        end
end

--------------------------------------------------------------------------------