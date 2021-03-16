
modifier_yunshi = class({})

-----------------------------------------------------------------------------

function modifier_yunshi:OnCreated( kv )
    self.delay_time=self:GetAbility():GetSpecialValueFor("delay_time")
    self.enemy_radius=self:GetAbility():GetSpecialValueFor("enemy_radius")
    if IsServer() then
        if self:GetAbility():GetLevel()==0 then
            self:GetParent():RemoveModifierByName(self:GetName())
            return 
        end
        self:StartIntervalThink(1)
        self:OnIntervalThink()
	end
end
function modifier_yunshi:IsHidden()
    return true
end

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

function modifier_yunshi:OnIntervalThink()
    if IsServer() then
        local hCaster=self:GetCaster()
        if self:GetAbility():IsCooldownReady() and hCaster:IsAlive() then
            for i=1,RandomInt(5, 10) do --到时候根据场上的人数来确定
                local vPos = self:GetCaster():GetOrigin()+RandomVector(RandomInt(300,1500))
                 if RollPercent(20) then     --50%的概率，技能会对着人放，可能会对单人不太友好,到时候根据玩家数量设置概率吧
                    local units= FindAlliesInRadiusExdd(hCaster,hCaster:GetAbsOrigin(),2500)
                    local unit = nil
                    local i = 0
                    if units then
                        for k,v in pairs(units) do
                            if i == 0 then          
                                i = i +1
                                unit = v
                                vPos = unit:GetAbsOrigin()+Vector(RandomInt(-200,200),RandomInt(-200,200))
                            end              
                        end
                    end
                end
                local hThinker = CreateModifierThinker( hCaster, self:GetAbility(), "modifier_yunshi_thinker", { duration = self.delay_time }, vPos, hCaster:GetTeamNumber(), false )
                
            end
            self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(1))
        end
		
            
	end
end

-----------------------------------------------------------------------------
