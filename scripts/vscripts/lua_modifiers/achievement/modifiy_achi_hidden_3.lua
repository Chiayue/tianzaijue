modifiy_achi_hidden_3 = class({})

--------------------------------------------------------------------------------

function modifiy_achi_hidden_3:IsHidden()
	return true
end



function modifiy_achi_hidden_3:OnCreated( kv )
	
	if IsServer() then
		self.postion=self:GetParent():GetOrigin()
		self:StartIntervalThink( 0.5)	
	end
end

--------------------------------------------------------------------------------
function modifiy_achi_hidden_3:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH,
    }
    return funcs
end

function modifiy_achi_hidden_3:OnDeath( params )
	if IsServer() then
		if self:GetParent()==params.unit then
			self:GetParent():ModifyStrength(self:GetParent():GetLevel())
            self:GetParent():ModifyIntellect(self:GetParent():GetLevel())
            self:GetParent():ModifyAgility(self:GetParent():GetLevel())
		end
	end
end
function modifiy_achi_hidden_3:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
--------------------------------------------------------------------------------