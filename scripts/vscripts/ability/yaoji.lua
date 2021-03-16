---使用药剂
--@param #number playerID 玩家ID
--@param #number type 药剂种类  类似001 002 003 004
--@param #number level 药剂的级别 现在默认是1
function UseDrug(playerID,type,level)
	if not playerID then
		return nil 
	end
	local modifier = "modifier_yj_".._.."level".._.."type"
	for _, PlayerID in pairs(Stage.playeronline) do
		local hero = PlayerUtil.GetHero(PlayerID)
		--还是不先加特效了
		StartSoundEvent("Hero_OgreMagi.Bloodlust.Cast",hero)
		hero:AddNewModifier(hero,nil,modifier,{duration=30})
	end


end