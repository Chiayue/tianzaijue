
modifier_bw_all_90 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_90:GetTexture()
	return "item_treasure/达贡之神力"
end

function modifier_bw_all_90:IsHidden()
	return true
end
--------------------------------------------------------------------------------
function modifier_bw_all_90:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 3 )
	end
end
function modifier_bw_all_90:OnRefresh()
	
end

--------------------------------------------------------------------------------




function modifier_bw_all_90:OnIntervalThink()
	if IsServer() then
		local caster=self:GetCaster()
		local point = caster:GetAbsOrigin()
		if caster ~= nil and caster:IsAlive() then
			local units = FindAlliesInRadiusExdd(caster,point,1200)
			local damage = caster:GetAverageTrueAttackDamage(caster) * math.ceil(caster:GetLevel()/2)
			if #units >= 1 then
				local unit = units[1]
				
				local point2 = unit:GetAbsOrigin()
				local particleID= ParticleManager:CreateParticle("particles/items4_fx/bull_whip.vpcf",PATTACH_POINT_FOLLOW,caster)
				ParticleManager:SetParticleControl(particleID,0,point)
				ParticleManager:SetParticleControl(particleID,1,point2)
				ParticleManager:ReleaseParticleIndex(particleID)
				TimerUtil.createTimerWithDelay(0.2,function()
					--sounds/items/bullwhip_enemy.vsnd 这个声音还是要触发
					local units = FindAlliesInRadiusExdd(caster,point2,450)
					local particleID2= ParticleManager:CreateParticle("particles/econ/items/storm_spirit/strom_spirit_ti8/storm_sprit_ti8_overload_discharge.vpcf",PATTACH_ABSORIGIN_FOLLOW,unit)
					ParticleManager:SetParticleControl(particleID2,0,point2)
					ParticleManager:ReleaseParticleIndex(particleID2)
					for k,unit in pairs(units) do
						ApplyDamageEx(caster,unit,nil,damage)
					end
				end)
				--ParticleManager:SetParticleControl(particleID,62,Vector(255,255,255))
			end		
		end
	end
end


function modifier_bw_all_90:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

