modifier_boss_invoker_call_lua = class({})
--------------------------------------------------------------------------------
function modifier_boss_invoker_call_lua:IsDebuff()
	return false
end


function modifier_boss_invoker_call_lua:GetTexture( params )
    return "modifier_boss_invoker_call_lua"
end
function modifier_boss_invoker_call_lua:OnCreated( kv )
	if IsServer() then
		local cd = self:GetAbility():GetCooldown(1) -GameRules:GetCustomGameDifficulty()*0.25
       self:StartIntervalThink( cd )
      
    end
	
end
function modifier_boss_invoker_call_lua:OnIntervalThink()
	if IsServer() then
		if self:GetParent():IsAlive()  then
			local num =   math.ceil(Stage.playernum /2  + GetGameDifficulty() /8)
			if num < 2 then
				num = 2
			end
			if num > 4 then
				num = 4
			end
			if #Stage.kezhw>12 then
				num=0
			end
			for k,v in pairs(self:GetAbility().monster_one) do
	        	for j=1,num,1 do
					local unit= CreateUnitByName(v, self:GetParent():GetOrigin()+RandomVector(400), true, self:GetParent(), self:GetParent(), self:GetParent():GetTeamNumber() )	
					local hp = self:GetParent():GetMaxHealth()	--设置怪物的动态血量	
					local maxhp = hp * 0.3  --怪物7倍血量
					unit:SetBaseMaxHealth(maxhp)

					local armor = self:GetParent():GetPhysicalArmorBaseValue()	--设置怪物的动态护甲
					local maxarmor = armor * 0.5
					unit:SetPhysicalArmorBaseValue(maxarmor)

					local mk = self:GetParent():GetBaseMagicalResistanceValue()
					local maxmk = mk*0.5
					unit:SetBaseMagicalResistanceValue(maxmk)

					local attack = self:GetParent():GetBaseDamageMax()
				
					local maxattack = attack * 0.4
					unit:SetBaseDamageMin(maxattack)
					unit:SetBaseDamageMax(maxattack)
					table.insert(Stage.kezhw,unit:GetEntityIndex())
					--同步往服务器发怪物目前的数量
					unit.kaer = 1
					local  nowchs = #Stage.kezhw
					for _, PlayerID in pairs(Stage.playeronline) do
						nowchs = nowchs + Stage.chs["chs"..PlayerID+1]
					end
					CustomGameEventManager:Send_ServerToAllClients("tzj_topbar_update_monster_count",{now=nowchs,max=Stage.maxchs})
				end
			end
			
		end
		
	end
end

function modifier_boss_invoker_call_lua:OnDestroy(  )
    if IsServer() then
        --ParticleManager:DestroyParticle( self.nPreviewFX, false )
    end
end

function modifier_boss_invoker_call_lua:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

