addHook("PlayerSpawn", function(p)
	if gametype!=GT_SRBZ return end
	
	if (SRBZ.round_active and SRBZ.PlayerCount() > 1) then p.zteam = 2
	else p.zteam = 1 end
	
	if p.zteam == 2 then R_SetPlayerSkin(p, "zzombie") end
end)