//To prevent from playing default weapon animations
public Forward_UpdateClientData_Post(iPlayer, SendWeapons, CD_Handle)
{
	#define CD_FL_NEXTATTACK 0.001

	if(!is_user_alive(iPlayer))
		return FMRES_IGNORED;
	
	//Only for Ghostblade
	if(is_ghostblade(iPlayer))
	{	
		if(g_blade_skill[iPlayer])
		{
			set_cd(CD_Handle, CD_flNextAttack, get_gametime() + CD_FL_NEXTATTACK);
			
			return FMRES_HANDLED;
		}	
	}
	
	return FMRES_IGNORED;
}

//Objects remover
public Forward_Spawn(iEntity)
{
	if(!pev_valid(iEntity)) 
		return FMRES_IGNORED;
	
	new classname[32];
	pev(iEntity, pev_classname, classname, charsmax(classname));
	
	for(new i = NULL; i < sizeof Removable_Objects; i ++)
	{		
		if(equal(classname, Removable_Objects[i]))
		{
			engfunc(EngFunc_RemoveEntity, iEntity);
			
			return FMRES_SUPERCEDE;
		}
	}
	
	return FMRES_IGNORED;
}

//Prevent engine from setting custom model to default
public Forward_SetClientKeyValue(iPlayer, const Infobuffer[], const Key[], const Value[])
{
	if(equal(Key, "model") && !equal(Infobuffer, g_custom_player_model[iPlayer]))	
		return FMRES_SUPERCEDE;
	
	return FMRES_IGNORED;	
}

//Prevent players from changing model through console
public Forward_ClientUserInfoChanged(iPlayer)
{
	static iCurrentModel[32];
	engfunc(EngFunc_InfoKeyValue, engfunc(EngFunc_GetInfoKeyBuffer, iPlayer), "model", iCurrentModel, charsmax(iCurrentModel));
	
	if(!equal(iCurrentModel, g_custom_player_model[iPlayer]))
		engfunc(EngFunc_SetClientKeyValue, iPlayer, engfunc(EngFunc_GetInfoKeyBuffer, iPlayer), "model", g_custom_player_model[iPlayer]);
		
	return FMRES_IGNORED;	
}

//Block/emit sounds
public Forward_EmitSound(iEntity, Channel, const Sample[], Float:Volume, Float:Attn, Flags, Pitch)
{
	//Smokegrenade explode
	if(Sample[8] == 's' && Sample[9] == 'g' && Sample[11] == 'e' && Sample[12] == 'x')
	{
		new iOwner = pev(iEntity, pev_owner);
		
		//Check if this is exists or not
		new StunGrenade = engfunc(EngFunc_FindEntityByString, iEntity, "classname", SPHERE_CLASSNAME);

		//Can be used now, if stun grenade from this player is not exist in the world
		if(pev(iEntity, pev_owner) == iOwner && g_stun_grenade_received[iOwner] && !(pev(StunGrenade, pev_owner) == iOwner))
		{
			//Push entity
			Create_StunGrenade(iEntity, iOwner);
			
			return FMRES_SUPERCEDE;
		}
		
		return FMRES_IGNORED;
	}

	//Check now only player entities
	new iPlayer = iEntity;

	if(!is_user_connected(iPlayer))
		return FMRES_IGNORED;	

	//Block all sounds for mutants/ghostblades/terminators
	if(is_mutant(iPlayer) || is_ghostblade(iPlayer) || is_terminator(iPlayer))
		return FMRES_SUPERCEDE;	
	
	//Ignore bhit
	if(Sample[7] == 'b' && Sample[8] == 'h' && Sample[9] == 'i' && Sample[10] == 't')
		return FMRES_SUPERCEDE;

	//Ignore headshot	
	if(Sample[7] == 'h' && Sample[8] == 'e' && Sample[9] == 'a' && Sample[10] == 'd')
		return FMRES_SUPERCEDE;
		
	//His first spawn right after connection (Connected as alive)	
	if(g_player_first_spawn[iPlayer])
	{
		//Knife deploy sound
		if(Sample[8] == 'k' && Sample[9] == 'n' && Sample[14] == 'd' && Sample[15] == 'e')
			return FMRES_SUPERCEDE;
	}	
	
	return FMRES_IGNORED;
}

//Client commands
public Forward_ClientCommand(iPlayer)
{
	static szCommand[24];
	read_argv(NULL, szCommand, charsmax(szCommand));
	
	//Client update
	if(!strcmp(szCommand, "fullupdate"))
	{
		client_print(iPlayer, print_chat, MSG_BLOCKED);
		return FMRES_SUPERCEDE;
	}		

	//Block sgren/flash/shield from buying
	if(!strcmp(szCommand, "flash") || !strcmp(szCommand, "sgren") || !strcmp(szCommand, "shield") || !strcmp(szCommand, "nvgs"))
	{
		client_print(iPlayer, print_center, MSG_RESTRICTED);
		
		return FMRES_SUPERCEDE;
	}
	
	//Class ability
	if(!strcmp(szCommand, "drop"))
	{
		//Pass soldiers
		switch(g_team[iPlayer])
		{
			case MUTANTS, TERMINATOR, GHOSTBLADE:
			{
				class_skill(iPlayer);
				
				return FMRES_SUPERCEDE;
			}
		}
	}		
		
	//Vote, team selection
	if(!strcmp(szCommand, "chooseteam") || !strcmp(szCommand, "jointeam") || !strcmp(szCommand, "joinclass"))
	{
		//Mutation voting
		if(g_round_status == ROUNDSTATUS_COUNT)
			//Allow vote only at round count
			mutation_vote(iPlayer);	

		return FMRES_SUPERCEDE;			
	}			

	return FMRES_IGNORED;
}	

//No console kill
public Forward_ClientKill(iPlayer)
	return FMRES_SUPERCEDE;
	
//Forward Game Description
public Forward_GameDescription()
{
	//Return the mod name
	forward_return(FMV_STRING, GAME_NAME)
	
	return FMRES_SUPERCEDE;
}