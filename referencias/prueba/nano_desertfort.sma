#include <amxmodx>
#include <fakemeta>

#define PLUGIN "Map: Desertfort"
#define VERSION "1.0"
#define AUTHOR "1xAero"

#define NULL 0

new const iMapResources[][] =
{
	"models/nanofort/BrokenStone.mdl",
	"models/nanofort/Desert.mdl",
	"models/nanofort/Falcustom_Shield.mdl",
	"models/nanofort/Grass.mdl",
	"models/nanofort/Rappel_grow.mdl",
	"models/nanofort/Satellite.mdl",
	"models/nanofort/Stone_Light.mdl",
	"models/nanofort/Stone_Shadow.mdl",
}

public plugin_init()
	register_plugin(PLUGIN, VERSION, AUTHOR);
	
public plugin_precache()
{
	for(new i = NULL; i < sizeof iMapResources; i ++)	
		engfunc(EngFunc_PrecacheModel, iMapResources[i]);
		
	precache_generic("maps/nano_desertfort.bsp");	
}	
	