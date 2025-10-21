//All resources
public plugin_precache()
{
	//Remove objects
	register_forward(FM_Spawn, "Forward_Spawn", FALSE);
	
	//Only if was being mutated or transformed into Ghostblade
	g_player_weaponstrip = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "player_weaponstrip"));
	dllfunc(DLLFunc_Spawn, g_player_weaponstrip);
	
	//No default knife/Glock or USP
	g_player_equip = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "game_player_equip"));
	dllfunc(DLLFunc_Spawn, g_player_equip);
	
	#if defined WORLD_FOG
	
		//Create the fog globally, spawn it and change Key Values.
		g_world_fog = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "env_fog"));
		dllfunc(DLLFunc_Spawn, g_world_fog);
		Set_Kvd(g_world_fog, "density", "0.0002", "env_fog");
		Set_Kvd(g_world_fog, "rendercolor", "0 148 255", "env_fog");

	#endif
	
	//Server specific commands
	Setup_Multiplayer();
	
	//Mutant skill
	engfunc(EngFunc_PrecacheSound, SND_MUTANT_SKILL);
	
	//Terminator skill
	engfunc(EngFunc_PrecacheSound, SND_TERMINATOR_CRYING);	
	
	//This sounds can be uploaded to client and used without precaching
	#if defined PRECACHE_RESOURCE
	
		//Sound ambient
		engfunc(EngFunc_PrecacheSound, SND_BGM);
	
		//Commander sounds
		engfunc(EngFunc_PrecacheSound, SND_ASSAULT);
		engfunc(EngFunc_PrecacheSound, SND_OUTBREAK);
		engfunc(EngFunc_PrecacheSound, SND_OUTBREAK_MUTANT);	
		engfunc(EngFunc_PrecacheSound, SND_NANO_REMOVED);
		engfunc(EngFunc_PrecacheSound, SND_NANO_WIN);
		engfunc(EngFunc_PrecacheSound, SND_MERCENARY_WIN);	
		engfunc(EngFunc_PrecacheSound, SND_MERCENARY_LEVEL1);
		engfunc(EngFunc_PrecacheSound, SND_MERCENARY_LEVEL2);
		engfunc(EngFunc_PrecacheSound, SND_MUTANT_LEVEL1);
		engfunc(EngFunc_PrecacheSound, SND_MUTANT_LEVEL2);
		engfunc(EngFunc_PrecacheSound, SND_DAMAGE);	
		engfunc(EngFunc_PrecacheSound, SND_HEARTBEAT);		
		engfunc(EngFunc_PrecacheSound, SND_GHOSTBLADE_15SEC);
		engfunc(EngFunc_PrecacheSound, SND_GHOSTBLADE_APPEAR);
		engfunc(EngFunc_PrecacheSound, SND_GHOSTBLADE_APPEAR_NANO);
	
		//Ghostblade class sounds
		engfunc(EngFunc_PrecacheSound, SND_GHOSTBLADE_SELECT);
		engfunc(EngFunc_PrecacheSound, SND_GHOSTBLADE_DEFENCE);
		engfunc(EngFunc_PrecacheSound, SND_GHOSTBLADE_CHANGE01);
		engfunc(EngFunc_PrecacheSound, SND_GHOSTBLADE_CHANGE02);
	
		//Terminator class sounds
		engfunc(EngFunc_PrecacheSound, SND_TERMINATOR_APPEAR);
		engfunc(EngFunc_PrecacheSound, SND_TERMINATOR_APPEAR_NANO);	
		engfunc(EngFunc_PrecacheSound, SND_TERMINATOR_SELECT);
		
		//Supplybox sounds
		engfunc(EngFunc_PrecacheSound, SND_HELICOPTER);
		engfunc(EngFunc_PrecacheSound, SND_SUPPLYBOX_SOLDIERS);	
		engfunc(EngFunc_PrecacheSound, SND_SUPPLYBOX_MUTANTS);
		engfunc(EngFunc_PrecacheSound, SND_SUPPLYBOX_PICKUP);
		
		//Countdown sounds
		for(new i = NULL; i < sizeof SND_COUNTDOWN; i ++)
			engfunc(EngFunc_PrecacheSound, SND_COUNTDOWN[i]);		
	
	#endif

	//Mutant attack hit
	for(new i = NULL; i < sizeof SND_MUTANT_HIT; i ++)	
		engfunc(EngFunc_PrecacheSound, SND_MUTANT_HIT[i]);

	//Ghostblade sword sounds
	for(new i = NULL; i < sizeof SND_GHOSTBLADE_HIT; i ++)		
		engfunc(EngFunc_PrecacheSound, SND_GHOSTBLADE_HIT[i]);
	
	//Armored terminator hit sounds
	for(new i = NULL; i < sizeof SND_TERMINATOR_HIT; i ++)		
		engfunc(EngFunc_PrecacheSound, SND_TERMINATOR_HIT[i]);	

	//Mutant appear sounds
	for(new i = NULL; i < sizeof SND_MUTANT_APPEAR; i ++)		
		engfunc(EngFunc_PrecacheSound, SND_MUTANT_APPEAR[i]);
		
	//Stun grenade sounds	
	engfunc(EngFunc_PrecacheSound, SND_STUN_EXPLODE);
	engfunc(EngFunc_PrecacheSound, SND_STUN_SOUND);
	
	//Viewmodels
	engfunc(EngFunc_PrecacheModel, MDL_MUTANT_HAND);
	engfunc(EngFunc_PrecacheModel, MDL_MUTANT_EVO_HAND);
	engfunc(EngFunc_PrecacheModel, MDL_GHOSTBLADE_HAND);
	engfunc(EngFunc_PrecacheModel, MDL_TERMINATOR_HAND);
	
	//Player models
	engfunc(EngFunc_PrecacheModel, MDL_MUTANT);
	engfunc(EngFunc_PrecacheModel, MDL_MUTANT_EVOLUTION);	
	engfunc(EngFunc_PrecacheModel, MDL_GHOSTBLADE);
	engfunc(EngFunc_PrecacheModel, MDL_TERMINATOR);

	//SupplyBox
	engfunc(EngFunc_PrecacheModel, MDL_SUPPLYBOX);
	
	//Sphere
	engfunc(EngFunc_PrecacheModel, MDL_SPHERE);		
	
	//Mutation effect
	engfunc(EngFunc_PrecacheModel, SPR_MUTANT_HIT);
	
	//Knight name
	engfunc(EngFunc_PrecacheModel, SPR_KNIGHT_NAME);
	
	//Xeno name
	engfunc(EngFunc_PrecacheModel, SPR_XENO_NAME);
}