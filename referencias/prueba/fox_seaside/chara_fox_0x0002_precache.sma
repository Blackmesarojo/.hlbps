//Precache
public plugin_precache()
{
	//Precache model
	engfunc(EngFunc_PrecacheModel, MDL_FOX_SEASIDE);
	
	//Knife
	engfunc(EngFunc_PrecacheModel, MDL_FOX_V_KNIFE);
	engfunc(EngFunc_PrecacheModel, MDL_FOX_P_KNIFE);
	
	//Elite
	engfunc(EngFunc_PrecacheModel, MDL_FOX_V_ELITE);
	engfunc(EngFunc_PrecacheModel, MDL_FOX_P_ELITE);
	
	//AK47
	engfunc(EngFunc_PrecacheModel, MDL_FOX_V_AK47);
	engfunc(EngFunc_PrecacheModel, MDL_FOX_P_AK47);	
	
	//MP5
	engfunc(EngFunc_PrecacheModel, MDL_FOX_V_MP5);
	engfunc(EngFunc_PrecacheModel, MDL_FOX_P_MP5);		

	//Hegrenade
	engfunc(EngFunc_PrecacheModel, MDL_FOX_V_HEGRENADE);
	engfunc(EngFunc_PrecacheModel, MDL_FOX_P_HEGRENADE);
	
	//Smokegrenade
	engfunc(EngFunc_PrecacheModel, MDL_FOX_V_SMOKEGRENADE);
	engfunc(EngFunc_PrecacheModel, MDL_FOX_P_SMOKEGRENADE);		

	//Hegrenade sounds
	engfunc(EngFunc_PrecacheSound, HE_PREFIRE_SND);
	engfunc(EngFunc_PrecacheSound, HE_FIRE_SND);
	engfunc(EngFunc_PrecacheSound, HE_SELECT_SND);	
}