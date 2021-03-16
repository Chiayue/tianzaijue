tysq1 = {
	"item_sq_1_1_1",
	"item_sq_1_2_1",
	"item_sq_1_3_1",
	"item_sq_1_4_1",
	"item_sq_1_5_1",
	"item_sq_1_6_1",
	"item_sq_1_7_1",
	"item_sq_1_8_1",
}


function tysqpd1( keys )
	local caster = keys.caster
	if not caster:IsRealHero() then
		return nil
	end
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local lv = ability:GetLevelSpecialValueFor("lv", level)
	local sx = ability:GetLevelSpecialValueFor("sx", level)

	local unitKey = tostring(EntityHelper.getEntityIndex(caster))
	if not caster.cas_table then
		caster.cas_table = {}
	end
	local netTable = caster.cas_table --服务端存储，避免使用getNetTable方法
	if caster.zzjt_time == nil then
		caster.zzjt_time = 0
	end
	caster.zzjt_time = caster.zzjt_time + lv
	netTable["zzjt_time"] = caster.zzjt_time
	if caster.ltyj_time == nil then
		caster.ltyj_time = 0
	end
	caster.ltyj_time = caster.ltyj_time + lv
	netTable["ltyj_time"] = caster.ltyj_time
	if caster.czss_time == nil then
		caster.czss_time = 0
	end
	caster.czss_time = caster.czss_time + lv
	netTable["czss_time"] = caster.czss_time

	netTable["bfbtsqsx"] = netTable["bfbtsqsx"] +sx

	SetNetTableValue("UnitAttributes",unitKey,netTable)

end

function tysqtx1( keys )
	local caster = keys.caster
	if not caster:IsRealHero() then
		return nil
	end
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local lv = ability:GetLevelSpecialValueFor("lv", level)
	local sx = ability:GetLevelSpecialValueFor("sx", level)

	local unitKey = tostring(EntityHelper.getEntityIndex(caster))
	if not caster.cas_table then
		caster.cas_table = {}
	end
	local netTable = caster.cas_table --服务端存储，避免使用getNetTable方法
	if caster.zzjt_time == nil then
		caster.zzjt_time = 0
	end
	caster.zzjt_time = caster.zzjt_time - lv
	netTable["zzjt_time"] = caster.zzjt_time
	if caster.ltyj_time == nil then
		caster.ltyj_time = 0
	end
	caster.ltyj_time = caster.ltyj_time - lv
	netTable["ltyj_time"] = caster.ltyj_time
	if caster.czss_time == nil then
		caster.czss_time = 0
	end
	caster.czss_time = caster.czss_time - lv
	netTable["czss_time"] = caster.czss_time

	netTable["bfbtsqsx"] = netTable["bfbtsqsx"] -sx

	SetNetTableValue("UnitAttributes",unitKey,netTable)

end

function tysqpd2( keys )
	local caster = keys.caster
	if not caster:IsRealHero() then
		return nil
	end
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local lv = ability:GetLevelSpecialValueFor("lv", level)
	local sx = ability:GetLevelSpecialValueFor("sx", level)
	local lv2 = ability:GetLevelSpecialValueFor("lv2", level)
	local unitKey = tostring(EntityHelper.getEntityIndex(caster))
	if not caster.cas_table then
		caster.cas_table = {}
	end
	local netTable = caster.cas_table --服务端存储，避免使用getNetTable方法
	if caster.swmc_damage == nil then
		caster.swmc_damage = 0
	end
	caster.swmc_damage = caster.swmc_damage + lv2
	netTable["swmc_damage"] = caster.swmc_damage
	if caster.swmc_heal == nil then
		caster.swmc_heal = 0
	end
	caster.swmc_heal = caster.swmc_heal + lv2
	netTable["swmc_heal"] = caster.swmc_heal
	if caster.tkjj_time == nil then
		caster.tkjj_time = 0
	end
	caster.tkjj_time = caster.tkjj_time + lv
	netTable["tkjj_time"] = caster.tkjj_time
	if caster.gjz_max == nil then
		caster.gjz_max = 0
	end
	caster.gjz_max = caster.gjz_max + lv
	netTable["gjz_max"] = caster.gjz_max

	netTable["bfbtsqsx"] = netTable["bfbtsqsx"] +sx

	SetNetTableValue("UnitAttributes",unitKey,netTable)

end


function tysqtx2( keys )
	local caster = keys.caster
	if not caster:IsRealHero() then
		return nil
	end
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local lv = ability:GetLevelSpecialValueFor("lv", level)
	local sx = ability:GetLevelSpecialValueFor("sx", level)
	local lv2 = ability:GetLevelSpecialValueFor("lv2", level)
	local unitKey = tostring(EntityHelper.getEntityIndex(caster))
	if not caster.cas_table then
		caster.cas_table = {}
	end
	local netTable = caster.cas_table --服务端存储，避免使用getNetTable方法
	if caster.swmc_damage == nil then
		caster.swmc_damage = 0
	end
	caster.swmc_damage = caster.swmc_damage - lv2
	netTable["swmc_damage"] = caster.swmc_damage
	if caster.swmc_heal == nil then
		caster.swmc_heal = 0
	end
	caster.swmc_heal = caster.swmc_heal -lv2
	netTable["swmc_heal"] = caster.swmc_heal
	if caster.tkjj_time == nil then
		caster.tkjj_time = 0
	end
	caster.tkjj_time = caster.tkjj_time - lv
	netTable["tkjj_time"] = caster.tkjj_time
	if caster.gjz_max == nil then
		caster.gjz_max = 0
	end
	caster.gjz_max = caster.gjz_max - lv
	netTable["gjz_max"] = caster.gjz_max

	netTable["bfbtsqsx"] = netTable["bfbtsqsx"] -sx

	SetNetTableValue("UnitAttributes",unitKey,netTable)

end


function tysqpd3( keys )
	local caster = keys.caster
	if not caster:IsRealHero() then
		return nil
	end
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local lv = ability:GetLevelSpecialValueFor("lv", level)
	local sx = ability:GetLevelSpecialValueFor("sx", level)

	local unitKey = tostring(EntityHelper.getEntityIndex(caster))
	if not caster.cas_table then
		caster.cas_table = {}
	end
	local netTable = caster.cas_table --服务端存储，避免使用getNetTable方法
	if caster.ldj_time == nil then
		caster.ldj_time = 0
	end
	caster.ldj_time = caster.ldj_time + lv
	netTable["ldj_time"] = caster.ldj_time
	if caster.fx_time == nil then
		caster.fx_time = 0
	end
	caster.fx_time = caster.fx_time + lv
	netTable["fx_time"] = caster.fx_time
	if caster.dxcq_time == nil then
		caster.dxcq_time = 0
	end
	caster.dxcq_time = caster.dxcq_time + lv
	netTable["dxcq_time"] = caster.dxcq_time

	netTable["bfbtsqsx"] = netTable["bfbtsqsx"] +sx

	SetNetTableValue("UnitAttributes",unitKey,netTable)

end


function tysqtx3( keys )
	local caster = keys.caster
	if not caster:IsRealHero() then
		return nil
	end
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local lv = ability:GetLevelSpecialValueFor("lv", level)
	local sx = ability:GetLevelSpecialValueFor("sx", level)

	local unitKey = tostring(EntityHelper.getEntityIndex(caster))
	if not caster.cas_table then
		caster.cas_table = {}
	end
	local netTable = caster.cas_table --服务端存储，避免使用getNetTable方法
	if caster.ldj_time == nil then
		caster.ldj_time = 0
	end
	caster.ldj_time = caster.ldj_time - lv
	netTable["ldj_time"] = caster.ldj_time
	if caster.fx_time == nil then
		caster.fx_time = 0
	end
	caster.fx_time = caster.fx_time - lv
	netTable["fx_time"] = caster.fx_time
	if caster.dxcq_time == nil then
		caster.dxcq_time = 0
	end
	caster.dxcq_time = caster.dxcq_time - lv
	netTable["dxcq_time"] = caster.dxcq_time

	netTable["bfbtsqsx"] = netTable["bfbtsqsx"]-sx

	SetNetTableValue("UnitAttributes",unitKey,netTable)

end


function tysqpd4( keys )
	local caster = keys.caster
	if not caster:IsRealHero() then
		return nil
	end
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local lv = ability:GetLevelSpecialValueFor("lv", level)
	local sx = ability:GetLevelSpecialValueFor("sx", level)

	local unitKey = tostring(EntityHelper.getEntityIndex(caster))
	if not caster.cas_table then
		caster.cas_table = {}
	end
	local netTable = caster.cas_table --服务端存储，避免使用getNetTable方法
	if caster.ldj_max == nil then
		caster.ldj_max = 0
	end
	caster.ldj_max = caster.ldj_max + lv
	netTable["ldj_max"] = caster.ldj_max
	if caster.fx_max == nil then
		caster.fx_max = 0
	end
	caster.fx_max = caster.fx_max + lv
	netTable["fx_max"] = caster.fx_max
	if caster.dxcq_max == nil then
		caster.dxcq_max = 0
	end
	caster.dxcq_max = caster.dxcq_max + lv
	netTable["dxcq_max"] = caster.dxcq_max

	netTable["bfbtsqsx"] = netTable["bfbtsqsx"] +sx

	SetNetTableValue("UnitAttributes",unitKey,netTable)

end


function tysqtx4( keys )
	local caster = keys.caster
	if not caster:IsRealHero() then
		return nil
	end
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local lv = ability:GetLevelSpecialValueFor("lv", level)
	local sx = ability:GetLevelSpecialValueFor("sx", level)

	local unitKey = tostring(EntityHelper.getEntityIndex(caster))
	if not caster.cas_table then
		caster.cas_table = {}
	end
	local netTable = caster.cas_table --服务端存储，避免使用getNetTable方法
	if caster.ldj_max == nil then
		caster.ldj_max = 0
	end
	caster.ldj_max = caster.ldj_max - lv
	netTable["ldj_max"] = caster.ldj_max
	if caster.fx_max == nil then
		caster.fx_max = 0
	end
	caster.fx_max = caster.fx_max - lv
	netTable["fx_max"] = caster.fx_max
	if caster.dxcq_max == nil then
		caster.dxcq_max = 0
	end
	caster.dxcq_max = caster.dxcq_max - lv
	netTable["dxcq_max"] = caster.dxcq_max

	netTable["bfbtsqsx"] = netTable["bfbtsqsx"]-sx

	SetNetTableValue("UnitAttributes",unitKey,netTable)

end





function tysqpd5( keys )
	local caster = keys.caster
	if not caster:IsRealHero() then
		return nil
	end
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local lv = ability:GetLevelSpecialValueFor("lv", level)
	local sx = ability:GetLevelSpecialValueFor("sx", level)

	local unitKey = tostring(EntityHelper.getEntityIndex(caster))
	if not caster.cas_table then
		caster.cas_table = {}
	end
	local netTable = caster.cas_table --服务端存储，避免使用getNetTable方法
	if caster.jqz_time == nil then
		caster.jqz_time = 0
	end
	caster.jqz_time = caster.jqz_time + lv
	netTable["jqz_time"] = caster.jqz_time
	if caster.zdb_time == nil then
		caster.zdb_time = 0
	end
	caster.zdb_time = caster.zdb_time + lv
	netTable["zdb_time"] = caster.zdb_time
	if caster.lpz_time == nil then
		caster.lpz_time = 0
	end
	caster.lpz_time = caster.lpz_time + lv
	netTable["lpz_time"] = caster.lpz_time

	netTable["bfbtsqsx"] = netTable["bfbtsqsx"] +sx

	SetNetTableValue("UnitAttributes",unitKey,netTable)

end


function tysqtx5( keys )
	local caster = keys.caster
	if not caster:IsRealHero() then
		return nil
	end
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local lv = ability:GetLevelSpecialValueFor("lv", level)
	local sx = ability:GetLevelSpecialValueFor("sx", level)

	local unitKey = tostring(EntityHelper.getEntityIndex(caster))
	if not caster.cas_table then
		caster.cas_table = {}
	end
	local netTable = caster.cas_table --服务端存储，避免使用getNetTable方法
	if caster.jqz_time == nil then
		caster.jqz_time = 0
	end
	caster.jqz_time = caster.jqz_time - lv
	netTable["jqz_time"] = caster.jqz_time
	if caster.zdb_time == nil then
		caster.zdb_time = 0
	end
	caster.zdb_time = caster.zdb_time - lv
	netTable["zdb_time"] = caster.zdb_time
	if caster.lpz_time == nil then
		caster.lpz_time = 0
	end
	caster.lpz_time = caster.lpz_time - lv
	netTable["lpz_time"] = caster.lpz_time

	netTable["bfbtsqsx"] = netTable["bfbtsqsx"]-sx

	SetNetTableValue("UnitAttributes",unitKey,netTable)

end


function tysqpd6( keys )
	local caster = keys.caster
	if not caster:IsRealHero() then
		return nil
	end
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local lv = ability:GetLevelSpecialValueFor("lv", level)
	local sx = ability:GetLevelSpecialValueFor("sx", level)

	local unitKey = tostring(EntityHelper.getEntityIndex(caster))
	if not caster.cas_table then
		caster.cas_table = {}
	end
	local netTable = caster.cas_table --服务端存储，避免使用getNetTable方法
	if caster.jqz_max == nil then
		caster.jqz_max = 0
	end
	caster.jqz_max = caster.jqz_max + lv
	netTable["jqz_max"] = caster.jqz_max
	if caster.zdb_max == nil then
		caster.zdb_max = 0
	end
	caster.zdb_max = caster.zdb_max + lv
	netTable["zdb_max"] = caster.zdb_max
	if caster.lpz_max == nil then
		caster.lpz_max = 0
	end
	caster.lpz_max = caster.lpz_max + lv
	netTable["lpz_max"] = caster.lpz_max

	netTable["bfbtsqsx"] = netTable["bfbtsqsx"] +sx

	SetNetTableValue("UnitAttributes",unitKey,netTable)

end


function tysqtx6( keys )
	local caster = keys.caster
	if not caster:IsRealHero() then
		return nil
	end
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local lv = ability:GetLevelSpecialValueFor("lv", level)
	local sx = ability:GetLevelSpecialValueFor("sx", level)

	local unitKey = tostring(EntityHelper.getEntityIndex(caster))
	if not caster.cas_table then
		caster.cas_table = {}
	end
	local netTable = caster.cas_table --服务端存储，避免使用getNetTable方法
	if caster.jqz_max == nil then
		caster.jqz_max = 0
	end
	caster.jqz_max = caster.jqz_max - lv
	netTable["jqz_max"] = caster.jqz_max
	if caster.zdb_max == nil then
		caster.zdb_max = 0
	end
	caster.zdb_max = caster.zdb_max - lv
	netTable["zdb_max"] = caster.zdb_max
	if caster.lpz_max == nil then
		caster.lpz_max = 0
	end
	caster.lpz_max = caster.lpz_max - lv
	netTable["lpz_max"] = caster.lpz_max

	netTable["bfbtsqsx"] = netTable["bfbtsqsx"]-sx

	SetNetTableValue("UnitAttributes",unitKey,netTable)

end



function tysqpd7( keys )
	local caster = keys.caster
	if not caster:IsRealHero() then
		return nil
	end
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local lv = ability:GetLevelSpecialValueFor("lv", level)
	local sx = ability:GetLevelSpecialValueFor("sx", level)

	local unitKey = tostring(EntityHelper.getEntityIndex(caster))
	if not caster.cas_table then
		caster.cas_table = {}
	end
	local netTable = caster.cas_table --服务端存储，避免使用getNetTable方法
	if caster.lzfs_time == nil then
		caster.lzfs_time = 0
	end
	caster.lzfs_time = caster.lzfs_time + lv
	netTable["lzfs_time"] = caster.lzfs_time

	if caster.blgj_time == nil then
		caster.blgj_time = 0
	end
	caster.blgj_time = caster.blgj_time + lv
	netTable["blgj_time"] = caster.blgj_time

	if caster.bsbp_time == nil then
		caster.bsbp_time = 0
	end
	caster.bsbp_time = caster.bsbp_time + lv
	netTable["bsbp_time"] = caster.bsbp_time

	if caster.zkfs_time == nil then
		caster.zkfs_time = 0
	end
	caster.zkfs_time = caster.zkfs_time + lv
	netTable["zkfs_time"] = caster.zkfs_time

	netTable["bfbtsqsx"] = netTable["bfbtsqsx"] +sx

	SetNetTableValue("UnitAttributes",unitKey,netTable)

end


function tysqtx7( keys )
	local caster = keys.caster
	if not caster:IsRealHero() then
		return nil
	end
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local lv = ability:GetLevelSpecialValueFor("lv", level)
	local sx = ability:GetLevelSpecialValueFor("sx", level)

	local unitKey = tostring(EntityHelper.getEntityIndex(caster))
	if not caster.cas_table then
		caster.cas_table = {}
	end
	local netTable = caster.cas_table --服务端存储，避免使用getNetTable方法
	if caster.lzfs_time == nil then
		caster.lzfs_time = 0
	end
	caster.lzfs_time = caster.lzfs_time - lv
	netTable["lzfs_time"] = caster.lzfs_time

	if caster.blgj_time == nil then
		caster.blgj_time = 0
	end
	caster.blgj_time = caster.blgj_time - lv
	netTable["blgj_time"] = caster.blgj_time

	if caster.bsbp_time == nil then
		caster.bsbp_time = 0
	end
	caster.bsbp_time = caster.bsbp_time - lv
	netTable["bsbp_time"] = caster.bsbp_time

	if caster.zkfs_time == nil then
		caster.zkfs_time = 0
	end
	caster.zkfs_time = caster.zkfs_time - lv
	netTable["zkfs_time"] = caster.zkfs_time

	netTable["bfbtsqsx"] = netTable["bfbtsqsx"] - sx

	SetNetTableValue("UnitAttributes",unitKey,netTable)

end


function tysqpd8( keys )
	local caster = keys.caster
	if not caster:IsRealHero() then
		return nil
	end
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local lv = ability:GetLevelSpecialValueFor("lv", level)
	local sx = ability:GetLevelSpecialValueFor("sx", level)

	local unitKey = tostring(EntityHelper.getEntityIndex(caster))
	if not caster.cas_table then
		caster.cas_table = {}
	end
	local netTable = caster.cas_table --服务端存储，避免使用getNetTable方法
	if caster.lxdf_time == nil then
		caster.lxdf_time = 0
	end
	caster.lxdf_time = caster.lxdf_time + lv
	netTable["lxdf_time"] = caster.lxdf_time

	if caster.hdyj_time == nil then
		caster.hdyj_time = 0
	end
	caster.hdyj_time = caster.hdyj_time + lv
	netTable["hdyj_time"] = caster.hdyj_time

	if caster.hpq_time == nil then
		caster.hpq_time = 0
	end
	caster.hpq_time = caster.hpq_time + lv
	netTable["hpq_time"] = caster.hpq_time

	if caster.hyqj_time == nil then
		caster.hyqj_time = 0
	end
	caster.hyqj_time = caster.hyqj_time + lv
	netTable["hyqj_time"] = caster.hyqj_time

	if caster.lypj_time == nil then
		caster.lypj_time = 0
	end
	caster.lypj_time = caster.lypj_time + lv
	netTable["lypj_time"] = caster.lypj_time

	netTable["bfbtsqsx"] = netTable["bfbtsqsx"] +sx

	SetNetTableValue("UnitAttributes",unitKey,netTable)

end


function tysqtx8( keys )
	local caster = keys.caster
	if not caster:IsRealHero() then
		return nil
	end
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local lv = ability:GetLevelSpecialValueFor("lv", level)
	local sx = ability:GetLevelSpecialValueFor("sx", level)

	local unitKey = tostring(EntityHelper.getEntityIndex(caster))
	if not caster.cas_table then
		caster.cas_table = {}
	end
	local netTable = caster.cas_table --服务端存储，避免使用getNetTable方法
	if caster.lxdf_time == nil then
		caster.lxdf_time = 0
	end
	caster.lxdf_time = caster.lxdf_time - lv
	netTable["lxdf_time"] = caster.lxdf_time

	if caster.hdyj_time == nil then
		caster.hdyj_time = 0
	end
	caster.hdyj_time = caster.hdyj_time - lv
	netTable["hdyj_time"] = caster.hdyj_time

	if caster.hpq_time == nil then
		caster.hpq_time = 0
	end
	caster.hpq_time = caster.hpq_time - lv
	netTable["hpq_time"] = caster.hpq_time

	if caster.hyqj_time == nil then
		caster.hyqj_time = 0
	end
	caster.hyqj_time = caster.hyqj_time - lv
	netTable["hyqj_time"] = caster.hyqj_time

	if caster.lypj_time == nil then
		caster.lypj_time = 0
	end
	caster.lypj_time = caster.lypj_time - lv
	netTable["lypj_time"] = caster.lypj_time

	netTable["bfbtsqsx"] = netTable["bfbtsqsx"] -sx

	SetNetTableValue("UnitAttributes",unitKey,netTable)

end