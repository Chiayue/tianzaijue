
if modifier_jyg_18 == nil then
    modifier_jyg_18 = class({})
end

function modifier_jyg_18:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_START,
    }
    return funcs
end


function modifier_jyg_18:OnAttackFail(params)
    if IsServer() then
        if self:GetCaster()==params.attacker then
            self.bIsWalrusPunch=false
        end
    end
end
function modifier_jyg_18:OnAttackStart(params)
    if IsServer() then
        if self:GetCaster()==params.attacker then
			self.bIsWalrusPunch=false
			if RollPercentage(self.persent) then
				self.bIsWalrusPunch=true
			else
				self.bIsWalrusPunch=false
			end
        end
    end
end
function modifier_jyg_18:OnAttackLanded(params)
    if IsServer() then
        if self:GetCaster()==params.attacker then
			self.bIsWalrusPunch=false
            
        end
    end

end
function modifier_jyg_18:CheckState()
	local state = {}

	if IsServer() then
		state =
		{
			[MODIFIER_STATE_CANNOT_MISS] = self.bIsWalrusPunch,
		}
	end

	return state
end


function modifier_jyg_18:OnCreated( kv )
    if IsServer() then
		self.persent=self:GetAbility():GetSpecialValueFor("persent") 
		
        self.bIsWalrusPunch=false
    end
end
function modifier_jyg_18:IsHidden()
    return false
end


function modifier_jyg_18:GetTexture( params )
    return "modifier_jyg_18"
end





