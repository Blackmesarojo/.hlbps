//Setting main rules
public Event_HLTV()
{
	//Enable default win condition
	FreezeRound(FALSE);
	
	//Global settings
	ResetRoundStatus();
	
	for(new pPlayer = 1; pPlayer < MaxClients + 1; pPlayer ++)
		//Stop sounds, reset team and skills
		ResetInventory(pPlayer);

	#if defined DEBUG_INFO
	
		client_print(SEND_ALL, print_chat, "Event_HLTV, Round status: %d", g_round_status);

	#endif
	
}

//Hide Money for specific characters
public Event_ResetHUD(iPlayer)
{
	//Return against first player connection
	if(!is_user_alive(iPlayer) || g_player_first_spawn[iPlayer])
		return PLUGIN_HANDLED;
		
	//Monster
	if(is_restricted_character(iPlayer, false))
		Hide_Money(iPlayer, true);

	return PLUGIN_CONTINUE;		
}

//Setup taskdata
public LogEvent_RoundStart()
{
	//Countdown
	#define COUNT_DOWN_START 20

	//Task timer
	#define SOUND_TIMER 0.1
	#define SUPPLY_TIMER 5.0
	#define LEVELUP_TIMER 10.0
	#define COUNT_TIMER 1.0
	
	//Remove data
	new TASK_DATA[] = 
	{
		TASK_FORCEWIN, 
		TASK_ROUNDSOUND, 
		TASK_SUPPLYBOX, 
		TASK_MERCENARY_LEVEL,	
		TASK_ROUNDSTART
	}

	for(new iData = NULL; iData < sizeof TASK_DATA; iData ++)		
		remove_task(TASK_DATA[iData]);	
	
	//Get roundtime
	new Float: ROUND_TIMER;
	ROUND_TIMER = get_cvar_float("mp_roundtime") * 60.0;	
		
	g_count_down = COUNT_DOWN_START;
	
	if(Get_iTeamPlayer(ALL, true) >= PLAYERS_GAME_START)
	{
		//Disable default win condition
		FreezeRound(TRUE);
		
		#if defined MSG_DATA
		
			//DrawGlobalMSG
			Draw_MutantHintCallback();
			
		#endif	
		
		g_round_status = ROUNDSTATUS_COUNT;

		//Force win, if timer is out
		set_task(ROUND_TIMER, "Task_SoldierWin", TASK_FORCEWIN);

		//Ambient replay	
		set_task(SOUND_TIMER, "Task_RoundSound", TASK_ROUNDSOUND);
		
		//Drop supplybox
		set_task(SUPPLY_TIMER, "Task_SupplyBox", TASK_SUPPLYBOX);		

		//Soldier levelup timer with a bit delay
		set_task(LEVELUP_TIMER, "Task_MercenaryLevelUp", TASK_MERCENARY_LEVEL);

		//CountDown
		set_task(COUNT_TIMER, "Task_CountDown", TASK_ROUNDSTART);	
	}
	
	#if defined DEBUG_INFO	
		
		client_print(SEND_ALL, print_chat, "LogEvent_RoundStart, Round status: %d", g_round_status);
		
	#endif
	
}

//Round Ended
public LogEvent_RoundEnd()
{
	remove_task(TASK_FORCEWIN);
	
	g_round_status = ROUNDSTATUS_END;
	
	#if defined DEBUG_INFO
	
		client_print(SEND_ALL, print_chat, "LogEvent_RoundEnd, Round status: %d", g_round_status);
		
	#endif	
}

//Unlock round end and reset vars
public ResetRoundStatus()
{
	//Remove Ents
	new const ENTITY_DATA[][] = 
	{
		"supplybox_nano", 
		"monster_knight", 
		"mutation_effect",
		"xeno_mutant",
		"stun_grenade"
	}

	for(new iEntData = NULL; iEntData < sizeof ENTITY_DATA; iEntData ++)		
		RemoveEntity(ENTITY_DATA[iEntData]);	
	
	g_round_status = ROUNDSTATUS_FREEZE;
	g_win_condition = false;	
	g_mercenary_level = NULL;
	g_level_stage = NULL;
	g_maximum_spawns = g_spawn_origin;
}

//Remove all items
public ResetInventory(iPlayer)
{
	client_cmd(iPlayer, "mp3 stop");
	
	g_team[iPlayer] = SOLDIERS;
	g_blade_skill[iPlayer] = false;
	g_mutant_skill[iPlayer] = false;
	g_terminator_skill[iPlayer] = false;
	
	//Fullupdate callback after restart is happened
	g_hud_text_timeout[iPlayer] = false;
	
	g_mutant_level[iPlayer] = NULL;
	g_hit_count[iPlayer] = NULL;
	g_mutant_vote[iPlayer] = NULL;
	
	//Reset grenade
	g_stun_grenade_received[iPlayer] = false;
	
	//Remove Player data
	new PLAYER_DATA[] = 
	{
		TASK_TEAM, 
		TASK_HEARBEAT_SENSOR, 
		TASK_BOT_SKILL, 
		TASK_STUNGRENADE	
	}

	for(new iPlayerData = NULL; iPlayerData < sizeof PLAYER_DATA; iPlayerData ++)		
		remove_task(iPlayer + PLAYER_DATA[iPlayerData]);		
}

//Draw button hint
public Draw_MutantHintCallback()
{
	//Draw by index (custom function MSG_HudMessage)
	for(new iPlayer = 1; iPlayer < MaxClients + 1; iPlayer ++)
	{
		if(is_soldier(iPlayer))
			MSG_HudMessage(iPlayer, 150, 100, 0, -1.0, 0.40, MSG_MUTANT_KEY, MSG_MUTANT_KEY, false, true);
	}	
}

//Block old style menu items
public MenuSelect(iPlayer)
{
	if(is_user_alive(iPlayer) && get_pdata_int(iPlayer, m_iMenu) == MENU_ITEM)
	{
		client_print(iPlayer, print_center, MSG_RESTRICTED);
		
		#if defined DEBUG_INFO
	
			client_print(iPlayer, print_chat, "Menu_Item: %d", get_pdata_int(iPlayer, m_iMenu));
		
		#endif		
	
		return PLUGIN_HANDLED;
	}

	return PLUGIN_CONTINUE;	
}