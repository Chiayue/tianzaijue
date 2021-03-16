
modifier_yxtfjn_zimao = class({})

--------------------------------------------------------------------------------

function modifier_yxtfjn_zimao:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_yxtfjn_zimao:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_yxtfjn_zimao:OnCreated( kv )
   -- self.costmana=self:GetAbility():GetSpecialValueFor("costmana")
    --self.costdis=self:GetAbility():GetSpecialValueFor("costdis")
    --self.speed=self:GetAbility():GetSpecialValueFor("speed")
	if IsServer() then
		
		
	end
end

--------------------------------------------------------------------------------

function modifier_yxtfjn_zimao:DeclareFunctions()
	local funcs = 
	{
		
		MODIFIER_EVENT_ON_ORDER ,
	}
	return funcs
end



--------------------------------------------------------------------------------

function modifier_yxtfjn_zimao:OnDestroy()
	if IsServer() then
		
	end
end
function modifier_yxtfjn_zimao:OnOrder(params)
	if IsServer() then
		if params.unit ~= self:GetParent() then
			return
		end
		local hOrderedUnit = params.unit 
		local hTargetUnit = params.target
		local nOrderType = params.order_type
		if nOrderType ~= DOTA_UNIT_ORDER_MOVE_TO_POSITION then
			return
		end
        if self:GetAbility():GetAutoCastState() then
            if GridNav:CanFindPath( params.new_pos, self:GetParent():GetOrigin() ) then
               if self:GetAbility():GetManaCost(self:GetAbility():GetLevel())<=self:GetParent():GetMana() then
                self:GetAbility():SetNewPlace(params.new_pos)
                self:GetParent():SpendMana(self:GetAbility():GetManaCost(self:GetAbility():GetLevel()), self:GetAbility())
               end
               

            end
            
        
        end
        
	end
	return
end
