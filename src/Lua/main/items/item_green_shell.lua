SRBZ:CreateItem("Green Shell",  {
	object = MT_SHELL,
	icon = "SHELLIND",
	firerate = 20,
	fuse = 5*TICRATE,
	color = SKINCOLOR_GREEN,
	knockback = 15*FU,
	damage = 12,
	onspawn = function(pmo, mo)
		mo.scale = $*2
	end,
	onhit = function(pmo, hit, shell)
		shell.fuse = 1
	end,
	price = 340,
})

addHook("MobjCollide", function(thing, tmthing)
	if gametype ~= GT_SRBZ then return end
	if thing.type == tmthing.type then
		return false
	end
end, MT_SHELL)