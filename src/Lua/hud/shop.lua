SRBZ.shophud = function(v, player)
	if SRBZ.game_ended then return end
	if not player.shop_anim then return end
	
	local animlength = 1*TICRATE + TICRATE/2
	
	local bg = { -- background
		start = 9,
		stop = 6
	}	
	local shop = { -- background
		start = 9,
		stop = 1
	}	
	local bl = { -- bang lower's y
		start = 168+40,
		stop = 168
	}
	local bu = { -- bang upper's y
		start = -40,
		stop = 0
	}

	
	local z_bu = v.cachePatch("Z_BANG_UPPER_GRAY")
	local z_bl = v.cachePatch("Z_BANG_LOWER_GRAY")
	local z_bg = v.cachePatch("Z_BG_GRAY")
	local item_bg_patch = v.cachePatch("BLACK160X100")
	local ruby_patch = v.cachePatch("Z_MINI_RUBY")
	local cursor_patch = v.cachePatch("SLCT1LVL")
	
	
	local scroll = (leveltime%128)
	
	bg.ese = bg.start-(FixedDiv(player.shop_anim*FU, animlength*FU/2)*9/FU)
	shop.ese = ease.inoutsine(FixedDiv(player.shop_anim*FU, animlength*FU),shop.start,shop.stop)
	bl.ese = ease.inoutsine(FixedDiv(player.shop_anim*FU, animlength*FU),bl.start*FU,bl.stop*FU)
	bu.ese = ease.inoutsine(FixedDiv(player.shop_anim*FU, animlength*FU),bu.start*FU,bu.stop*FU)
	
	local item_y = 75*FU

	
	if bg.ese > 5 then
		v.drawScaled(-500*FU,-500*FU, FU*1000, z_bg, bg.ese<<V_ALPHASHIFT)
	else
		v.drawScaled(-500*FU,-500*FU, FU*1000, z_bg, 5<<V_ALPHASHIFT)
	end
	
	for i=-5,5
		v.drawScaled((i*128*FU)+(scroll*FU),max(bl.ese,bl.stop*FU),FU,z_bl,V_SNAPTOBOTTOM)
	end
	for i=-5,5
		v.drawScaled((i*128*FU)-(scroll*FU),min(bu.ese,bu.stop*FU),FU,z_bu,V_SNAPTOTOP)
	end
	local trans
	if player.shop_anim ~= animlength then
		trans = shop.ese<<V_ALPHASHIFT
	end
	for i=0,2 do
		local item = SRBZ:SafeCopyItemFromID(i+1)
		local item_scale = item.iconscale or FU
		local item_x = (i*100*FU)+(120*FU)-((player["srbz_info"].shop_selection-1) * (100*FU)) -- (player["srbz_info"].shop_selection-1 * (120*FU))
		-- Background to the shop item.
		v.drawScaled(item_x,item_y,FU/2,item_bg_patch,trans)
		-- Ruby Icon
		v.drawScaled(item_x+(FU),item_y-(FU*13),FU,ruby_patch,trans)
		-- Ruby Price
		v.drawString(item_x+(16*FU),item_y-(9*FU),"\x85".."69420",trans, "fixed")
		-- Weapon Icon
		v.drawScaled(item_x,item_y+(9*FU),item_scale,v.cachePatch(item.icon),trans)
		-- Name
		v.drawString(item_x,item_y+(1*FU),item.displayname:upper(),trans, "thin-fixed")
		-- Delay
		v.drawString(item_x+(16*FU),item_y+(13*FU),"\x84".."DELAY: "..item.firerate,trans, "thin-fixed")
		-- Damage
		if item.damage then
			v.drawString(item_x,item_y+(25*FU),"\x85".."DAMAGE: "..item.damage,trans, "thin-fixed")
		end
		-- Knockback
		if item.knockback then
			v.drawString(item_x,item_y+(33*FU),"\x83".."KNOCKBACK: "..item.knockback/FU,trans, "thin-fixed")
		end
	end
	v.drawScaled(120*FU,item_y,FU/2,cursor_patch,trans)
end
