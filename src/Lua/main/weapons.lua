freeslot(
	"MT_INSTABURST",
	"S_INSTABURST",
	"S_INSTABURST1A",
	"S_INSTABURST1B",
	"S_INSTABURST2A",
	"S_INSTABURST2B",
	"S_INSTABURST3A",
	"S_INSTABURST3B",
	"S_INSTABURST4A",
	"S_INSTABURST4B",
	"S_INSTABURST5A",
	"S_INSTABURST5B",
	"S_INSTABURST6A",
	"S_INSTABURST6B",
	"SPR_ZMSH",
	"SFX_ZISH1"
)

freeslot("MT_PROPWOOD","S_PROP1","S_PROP1_BREAK","SPR_WPRP")

mobjinfo[MT_PROPWOOD] = {
    sprite = SPR_WPRP,
	spawnstate = S_PROP1,
	painstate = S_PROP1,
	painsound = sfx_dmpain,
	deathstate = S_PROP1_BREAK,
	deathsound = sfx_wbreak,
	spawnhealth = 50,
	speed = 0,
	radius = 96*FRACUNIT,
	height = 138*FRACUNIT,
	flags = MF_SHOOTABLE|MF_SOLID,
}
mobjinfo[MT_PROPWOOD].npc_name = "Wood Fence"
mobjinfo[MT_PROPWOOD].npc_spawnhealth = {5,15}

states[S_PROP1] = {
	nextstate = S_PROP1,
	sprite = SPR_WPRP,
	frame = FF_FULLBRIGHT,
	tics = 2
}

states[S_PROP1_BREAK] = {
	nextstate = S_NULL,
	sprite = SPR_WPRP,
	action = A_Scream,
	frame = B,
	tics = 2
}

addHook("MobjCollide", function(mo,pmo)
	if pmo.skin ~= "zzombie"
		P_SetObjectMomZ(mo,mo.scale*0)
		return false
	else
		P_SetObjectMomZ(mo,mo.scale*-128)
	end
end, MT_PROPWOOD)

mobjinfo[MT_INSTABURST] = {
	doomednum = -1,
	spawnhealth = 1,
	spawnstate = S_INSTABURST,
	radius = 72*FRACUNIT,
	height = 16*FRACUNIT,
	flags = MF_NOGRAVITY|MF_NOBLOCKMAP
}

states[S_INSTABURST] = {SPR_NULL, 0, 1, A_CapeChase, 0, 0, S_INSTABURST1A}
states[S_INSTABURST1A] = {SPR_ZMSH, 0|FF_FULLBRIGHT, 1, A_CapeChase, 0, 0, S_INSTABURST1B}
states[S_INSTABURST1B] = {SPR_NULL, 0, 1, A_CapeChase, 0, 0, S_INSTABURST2A}
states[S_INSTABURST2A] = {SPR_ZMSH, 1|FF_FULLBRIGHT, 1, A_CapeChase, 0, 0, S_INSTABURST2B}
states[S_INSTABURST2B] = {SPR_NULL, 0, 1, A_CapeChase, 0, 0, S_INSTABURST3A}
states[S_INSTABURST3A] = {SPR_ZMSH, 2|FF_FULLBRIGHT, 1, A_CapeChase, 0, 0, S_INSTABURST3B}
states[S_INSTABURST3B] = {SPR_NULL, 0, 1, A_CapeChase, 0, 0, S_INSTABURST4A}
states[S_INSTABURST4A] = {SPR_ZMSH, 3|FF_FULLBRIGHT, 1, A_CapeChase, 0, 0, S_INSTABURST4B}
states[S_INSTABURST4B] = {SPR_NULL, 0, 1, A_CapeChase, 0, 0, S_INSTABURST5A}
states[S_INSTABURST5A] = {SPR_ZMSH, 4|FF_FULLBRIGHT, 1, A_CapeChase, 0, 0, S_INSTABURST5B}
states[S_INSTABURST5B] = {SPR_NULL, 0, 1, A_CapeChase, 0, 0, S_INSTABURST6A}
states[S_INSTABURST6A] = {SPR_ZMSH, 5|FF_FULLBRIGHT, 1, A_CapeChase, 0, 0, S_INSTABURST6B}
states[S_INSTABURST6B] = {SPR_NULL, 0, 1, A_CapeChase, 0, 0, S_NULL}

SRBZ:CreateItem("Red Ring",  {
	object = MT_REDRING,
	icon = "RINGIND",
	firerate = 19,
	color = SKINCOLOR_RED,
	knockback = 45*FRACUNIT,
	damage = 17,
})

SRBZ:CreateItem("Automatic Ring",  {
	object = MT_THROWNAUTOMATIC,
	icon = "AUTOIND",
	firerate = 5,
	color = SKINCOLOR_GREEN,
	damage = 5,
	knockback = 30*FRACUNIT,
	flags2 = MF2_AUTOMATIC,
})

SRBZ:CreateItem("Apple", {
	icon = "APPLEIND",
	firerate = 35,
	sound = sfx_eatapl,
	limited = true,
	count = 1,
	ontrigger = function(player)
		if player.mo.health == player.mo.maxhealth then
			return true
		end
		SRBZ:ChangeHealth(player.mo, 5)
	end
})

SRBZ:CreateItem("I want summa that", {
	icon = "SUMMAIND",
	iconscale = FU/2,
	firerate = 70,
	sound = sfx_oyahx,	
})

SRBZ:CreateItem("Insta Burst", {
	icon = "ZMISHIND",
	firerate = 42,
	sound = sfx_zish1,
	damage = 25,
	ontrigger = function(player)
		local brange = 256*FU
		local range = 160*FU
		local instaburst = P_SpawnMobjFromMobj(player.mo, 0, 0, 0, MT_INSTABURST)
		instaburst.target = player.mo
		instaburst.spritexscale = $*2
		instaburst.spriteyscale = $*2
		instaburst.scale = $*3/2
		instaburst.forcedamage = SRBZ:FetchInventorySlot(player).damage
		
		searchBlockmap("objects", function(refmobj,foundmobj)
			if not L_ZCollide(foundmobj,instaburst) then 
				return false
			end
			
			if (foundmobj.valid and ((foundmobj.flags & (MF_SHOOTABLE)) or foundmobj.player)) and R_PointToDist2(foundmobj.x,foundmobj.y, instaburst.x, instaburst.y) < range then
				P_DamageMobj(foundmobj, instaburst, instaburst.target)
			end
		end, 
		instaburst, 
		instaburst.x-brange,instaburst.x+brange,
		instaburst.y-brange,instaburst.y+brange)
	end
})
SRBZ:CreateItem("W's mirror", {
	icon = "MIRRORIND",
	firerate = TICRATE*5,
	sound = sfx_oyahx,
})
SRBZ:CreateItem("Tails' fence", {
	icon = "FENCEIND",
	firerate = TICRATE*8,
	sound = sfx_oyahx,
	ontrigger = function(player)
		local wood = P_SpawnMobj(player.mo.x+FixedMul(128*FRACUNIT, cos(player.mo.angle)),
					             player.mo.y+FixedMul(128*FRACUNIT, sin(player.mo.angle)), 
								 player.mo.z, MT_PROPWOOD)
		wood.angle = player.mo.angle+ANGLE_90
		S_StartSound(player.mo, sfx_jshard)
		wood.renderflags = $|RF_PAPERSPRITE
		wood.target = player.mo
	end
})