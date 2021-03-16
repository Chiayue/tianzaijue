if nil == Courier then
	Courier = {
		---玩家信使当前使用
		tPlayersUse = {
		-- [iPlayerID]:{
		-- 	sCourierID,
		-- 	sCourierfxID,
		-- 	sTitleID,
		-- }
		}
	}
end
local public = Courier

function public:init(bReload)
	for i = 0, PlayerData:GetPlayerMaxCount() - 1 do
		NetEventData:BindDo('OnUpdateUsing', 'service', 'player_using_' .. i, self)
	end
	Request:Event("CourierSave", Dynamic_Wrap(self, "CourierSave"), self)
end

--UI************************************************************************************************************************
	do
	--设置模型
	function public:CourierSave(tData)
		local iPlayerID = tData.PlayerID
		local sCourierID = tData.sCourierID and tostring(tData.sCourierID) or nil
		local sCourierfxID = tData.sCourierfxID and tostring(tData.sCourierfxID) or nil
		local sTitleID = tData.sTitleID and tostring(tData.sTitleID) or nil

		if not self.tPlayersUse[iPlayerID] then
			return 'error'
		end

		-- Service:POST('player.add_item', {
		-- 	uid = GetAccountID(iPlayerID),
		-- 	sid = sTitleID,
		-- 	count = 1
		-- }, function(a, b)
		-- end)
		-- 有无修改
		local bHasChange = false
		local tUseData = NetEventData:GetTableValue('service', 'player_using_' .. iPlayerID) or {}

		-- 验证玩家是否拥有
		if sCourierID then
			local tOwnData = NetEventData:GetTableValue('service', 'player_courier_' .. iPlayerID)
			if not tOwnData or not tOwnData[sCourierID] or '1' ~= tostring(tOwnData[sCourierID]) then
				return 'error_not_have_courier'
			end

			if tUseData['courier'] and sCourierID ~= tostring(tUseData['courier']) then
				bHasChange = true
			end
		end
		if sCourierfxID then
			local tOwnData = NetEventData:GetTableValue('service', 'player_courierfx_' .. iPlayerID)
			if not tOwnData or not tOwnData[sCourierfxID] or '1' ~= tostring(tOwnData[sCourierfxID]) then
				return 'error_not_have_courierfx'
			end

			if tUseData['courierfx'] and sCourierfxID ~= tostring(tUseData['courierfx']) then
				bHasChange = true
			end
		end
		if sTitleID then
			local tOwnData = NetEventData:GetTableValue('service', 'player_title_' .. iPlayerID)
			if not tOwnData or not tOwnData[sTitleID] or '1' ~= tostring(tOwnData[sTitleID]) then
				return 'error_not_have_title'
			end

			if tUseData['title'] and sTitleID ~= tostring(tUseData['title']) then
				bHasChange = true
			end
		end

		if false == bHasChange then
			return 'error_not_change'
		end

		-- equip.set
		local data = Service:POSTSync('equip.set', {
			uid = GetAccountID(iPlayerID),
			['108'] = sCourierID,
			['109'] = sCourierfxID,
			['110'] = sTitleID,
		})
		return data
	end
end
--事件监听************************************************************************************************************************
	do
	--更新玩家使用数据
	function public:OnUpdateUsing(sTable, sKey, val)
		local tS = string.split(sKey, '_')
		local iPlayerID = tonumber(tS[#tS])
		self.tPlayersUse[iPlayerID] = {
			sCourierID = tostring(val['courier']),
			sCourierfxID = tostring(val['courierfx']),
			sTitleID = tostring(val['title']),
		}

		self:UpdatePlayerUsing(iPlayerID)
	end
end
--Global************************************************************************************************************************
	do
	---获取信使数据用ID
	function GetCourierKVByID(sCourierID)
		sCourierID = tostring(sCourierID)
		for sCourierName, tKV in pairs(KeyValues.CourierKv) do
			if tostring(tKV.ID) == sCourierID then
				return tKV, sCourierName
			end
		end
	end
end
--Global************************************************************************************************************************
function public:UpdateNetTabel()
end

---信使单位初始化
function public:InitPlayerUnit(iPlayerID, hUnit)
	--信使技能
	hUnit:SetAbilityPoints(0)
	for i = hUnit:GetAbilityCount() - 1, 0, -1 do
		local hAbility = hUnit:GetAbilityByIndex(i)
		if hAbility then
			hAbility:UpgradeAbility(true)
		end
	end
	-- 不延时将导致崩溃
	hUnit:GameTimer(1, function()
		self:UpdatePlayerUsing(iPlayerID)
	end)
end

---更新玩家使用信使，特效，称号
function public:UpdatePlayerUsing(iPlayerID)
	local hHero = PlayerData:GetHero(iPlayerID)
	if not hHero then return end
	local tUseData = self.tPlayersUse[iPlayerID]
	if not tUseData then return end

	if tUseData.sCourierID then
		if GSManager:getStateType() <= GS_Ready then
			self:Unit2Courier(hHero, tUseData.sCourierID)
		end
	end
	-- if tUseData.sCourierfxID then
	-- 	self:Unit2Courier(hHero, tUseData.sCourierfxID)
	-- end
	-- if tUseData.sTitleID then
	-- 	self:Unit2Courier(hHero, tUseData.sTitleID)
	-- end
	self:UpdateNetTabel()
end

---单位信使模型
function public:Unit2Courier(hUnit, sGoodsID)
	local tKV = GetCourierKVByID(sGoodsID)
	if not tKV then return end

	if tKV.Model then
		hUnit:SetModel(tKV.Model)
		hUnit:SetOriginalModel(tKV.Model)
	end
	hUnit:SetModelScale(tKV.ModelScale or 1)
	hUnit:SetSkin(tKV.Skin or 0)
	--
	hUnit._tCourierParticles = hUnit._tCourierParticles or {}
	for _, iParticleID in pairs(hUnit._tCourierParticles) do
		ParticleManager:DestroyParticle(iParticleID, true)
	end
	if hUnit.hAmbientModifier then
		hUnit.hAmbientModifier:Destroy()
	end

	if tKV.EffectName then
		local iParticleID = ParticleManager:CreateParticle(tKV.EffectName, PATTACH_POINT_FOLLOW, hUnit)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", hUnit:GetAbsOrigin(), true)
		table.insert(hUnit._tCourierParticles, iParticleID)
	end

	if tKV.AmbientModifier then
		hUnit.hAmbientModifier = hUnit:AddNewModifier(hUnit, nil, "modifier_courier_nian", nil)
	end

	if hUnit._CourierAbility then
		if hUnit._CourierAbility:GetIntrinsicModifierName() then
			hUnit:RemoveModifierByName(hUnit._CourierAbility:GetIntrinsicModifierName())
		end
		hUnit:RemoveAbilityByHandle(hUnit._CourierAbility)
	end
	if tKV.Ability then
		hUnit._CourierAbility = hUnit:AddAbility(tKV.Ability)
		hUnit._CourierAbility:SetLevel(1)
	end
end

---玩家装备特效
function public:UseGoodsEffect(iPlayerID, sGoodsID, _hUnit)
	--卸下原来所有特效
	for sGoodsID2, v in pairs(tGoodsInUse) do
		self:DestroyGoodsEffect(iPlayerID, sGoodsID2)
	end

	-- 装备
	local tUseInfo = {
		-- 记录该物品创建出的特效id
		tParticleIDs = {}
	}
	tGoodsInUse[sGoodsID] =	tUseInfo

	for id, tParticleInfo in pairs(tKV) do
		if tonumber(id) and type(tParticleInfo) == 'table' then
			local iParticleID = self:CreateParticle(hHero, tParticleInfo)
			if iParticleID then
				table.insert(tUseInfo.tParticleIDs, iParticleID)
			end
		end
	end

	self:UpdateNetTabel()

	return true
end
---卸下玩家所有特效物品
function public:DestroyAllGoodsEffect(iPlayerID)
	local tGoodsInUse = self.tPlayerGoodsInUse[iPlayerID][GoodsType.effect]
	if tGoodsInUse then
		for _, tUseInfo in pairs(tGoodsInUse) do
			for _, iParticleID in pairs(tUseInfo.tParticleIDs) do
				ParticleManager:DestroyParticle(iParticleID, false)
			end
		end
		tGoodsInUse = {}
		self:UpdateNetTabel()
	end
end
---卸下玩家某特效物品
function public:DestroyGoodsEffect(iPlayerID, sGoodsID)
	local tGoodsInUse = self.tPlayerGoodsInUse[iPlayerID][GoodsType.effect]
	if tGoodsInUse then
		local tUseInfo = tGoodsInUse[sGoodsID]
		if tUseInfo then
			for _, iParticleID in pairs(tUseInfo.tParticleIDs) do
				ParticleManager:DestroyParticle(iParticleID, false)
			end
			tGoodsInUse[sGoodsID] = nil
			self:UpdateNetTabel()
		end
	end
end
function public:CreateParticle(hUnit, tParticleInfo)
	if not tParticleInfo.EffectName then return end

	local sEffectName = tParticleInfo.EffectName

	local iAttachType
	if tParticleInfo.EffectAttachType then
		iAttachType = _G[tParticleInfo.EffectAttachType]
	end
	if not iAttachType then
		iAttachType = _G['PATTACH_POINT_FOLLOW']
	end

	local iParticleID = ParticleManager:CreateParticle(sEffectName, iAttachType, hUnit)

	--设置控制点
	if tParticleInfo.ParticleControl then
		for id, tControlInfo in pairs(tParticleInfo.ParticleControl) do

			--坐标
			local vPos = hUnit:GetAbsOrigin()
			if tControlInfo.Point then
				local tS = string.split(tControlInfo.Point, ' ')
				if 3 == #tS then
					vPos = Vector(tonumber(tS[1]), tonumber(tS[2]), tonumber(tS[3]))
				end
			end

			if tControlInfo.Attach then
				--实体绑定
				local iAttachType = tControlInfo.AttachType
				if tControlInfo.AttachType then
					iAttachType = _G[tControlInfo.AttachType]
				end
				if not iAttachType then
					iAttachType = _G['PATTACH_POINT_FOLLOW']
				end
				ParticleManager:SetParticleControlEnt(iParticleID, tonumber(id), hUnit, iAttachType, tControlInfo.Attach, vPos, true)
			else
				--坐标绑定
				ParticleManager:SetParticleControl(iParticleID, tonumber(id), vPos)
			end

		end
	end

	return iParticleID
end



return public