#define CALLBACK_PLAYER 1

//Move to mutants
public Debug_Mutant(iPlayer)
{
	#define SET_MUTANT_LEVEL_3 3
	
	if(is_mutant(iPlayer))
		return;	
		
	//Knight?	
	IsPlayerAura(iPlayer);
	
	//Xeno
	IsXeno(iPlayer);	

	Respawn_PlayerDebug(iPlayer);
	
	g_mutant_level[iPlayer] = SET_MUTANT_LEVEL_3;
	g_transform_gear[iPlayer] = true;

	//If everyone turned into mutants and players amount above 1
	if(g_player_amount > CALLBACK_PLAYER)
		RoundCheck_CallbackWin_Mutants();	
		
	Setup_Mutant(iPlayer);
	
	remove_task(iPlayer + TASK_HEARBEAT_SENSOR);
}

//Move to terminator
public Debug_Terminator(iPlayer)
{
	#define NO_ARMOR 0.0
	#define SET_MUTANT_LEVEL_4 4
	
	if(is_terminator(iPlayer))
		return;	
		
	//Knight?	
	IsPlayerAura(iPlayer);		
	
	Respawn_PlayerDebug(iPlayer);
	
	g_mutant_level[iPlayer] = SET_MUTANT_LEVEL_4;
	g_transform_gear[iPlayer] = true;

	//Move to TR	
	set_pdata_int(iPlayer, m_iTeam, TEAM_TERRORIST);
	Update_TeamInfo(iPlayer, "TERRORIST");	
	
	//Remove armor
	set_pdata_int(iPlayer, m_iKevlar, NULL);	
	set_pev(iPlayer, pev_armorvalue, NO_ARMOR);

	//Remove inventory
	for(new iSlots = 1; iSlots < 6; iSlots ++)
	{
		//Dunno't strip knife
		if(iSlots != 3)		
			Strip_Slot(iPlayer, iSlots);
	}

	//If everyone turned into mutants and players amount above 1
	if(g_player_amount > CALLBACK_PLAYER)
		RoundCheck_CallbackWin_Mutants();	
		
	Setup_Terminator(iPlayer);
	
	//Was in buyzone?
	Remove_BuySignal(iPlayer);
	
	//Monster
	Hide_Money(iPlayer, true);	
	
	remove_task(iPlayer + TASK_HEARBEAT_SENSOR);
}

//Move to Ghostblade
public Debug_Ghostblade(iPlayer)
{
	if(is_ghostblade(iPlayer))
		return;
		
	//Xeno
	IsXeno(iPlayer);	

	Respawn_PlayerDebug(iPlayer);
	
	//Move to CT	
	set_pdata_int(iPlayer, m_iTeam, TEAM_CT);
	Update_TeamInfo(iPlayer, "CT");	

	client_print(SEND_ALL, print_center, MSG_GHOSTBLADE_APPEARED);		
	
	Setup_Ghostblade(iPlayer);
	
	remove_task(iPlayer + TASK_HEARBEAT_SENSOR);
	set_task(HEARBREAT_TIME, "Task_Heartbeat_Sensor", iPlayer + TASK_HEARBEAT_SENSOR);
}

//Move to Soldiers
public Debug_Soldier(iPlayer)
{
	if(is_soldier(iPlayer))
		return;
		
	//Knight?	
	IsPlayerAura(iPlayer);

	//Xeno
	IsXeno(iPlayer);

	Respawn_PlayerDebug(iPlayer);		
	
	//Set team	
	g_team[iPlayer] = SOLDIERS;	
	
	//Test	
	g_mutant_level[iPlayer] = NULL;	
	RemoveSkillData(iPlayer);
	
	//Move to CT	
	set_pdata_int(iPlayer, m_iTeam, TEAM_CT);
	Update_TeamInfo(iPlayer, "CT");	
	
	Setup_Soldier(iPlayer);
	
	#if defined USE_SPECIAL_CHARACTER
	
		//If this player is custom character
		if(player_fox_seaside(iPlayer))
		{		
			Ham_Give_Weapon(iPlayer, "weapon_knife");
			
			if(!is_user_bot(iPlayer))
			{
				Ham_Give_Weapon(iPlayer, "weapon_deagle");
			
				//Not a monster
				Hide_Money(iPlayer, false);

				//Start with small amount of bullets
				Refill_Ammunition(iPlayer, NULL, true);				
			}
			
			//Reset agent status
			player_reset_agent(iPlayer);
		}		

	#endif		
	
	remove_task(iPlayer + TASK_HEARBEAT_SENSOR);
}

//Send team info
public Update_TeamInfo(iPlayer, const iTeam[])
{
	//Update attribute
	message_begin(MSG_ALL, g_msgTeamInfo);
	write_byte(iPlayer);
	write_string(iTeam);
	message_end();	
}

//Respawn
public Respawn_PlayerDebug(iPlayer)
{
	if(!is_user_alive(iPlayer))
	{	
		ExecuteHamB(Ham_CS_RoundRespawn, iPlayer);
		
		TurnOFF_Radio(iPlayer);
	}
}

//Remove effect if set
public IsPlayerAura(iPlayer)
{
	if(is_ghostblade(iPlayer))
		Remove_EntityByOwner(iPlayer, KNIGHT_CLASSNAME);
}

//Remove name if set
public IsXeno(iPlayer)
{
	if(is_terminator(iPlayer))
		Remove_EntityByOwner(iPlayer, XENO_CLASSNAME);
}