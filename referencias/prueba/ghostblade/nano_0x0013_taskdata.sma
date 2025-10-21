/*Check for last player, if all turned to mutants and 1 soldier left the game
or mutant left the game*/
public Task_CheckConnected(TASK_CHECK_WIN)
{
	//Works after preparations
	if(g_round_status != ROUNDSTATUS_COUNT)	
		RoundCheck_CallbackWin_Soldiers();
		
	//If mutants < 1 and Terminators < 1
	if(g_round_status == ROUNDSTATUS_START || g_round_status == ROUNDSTATUS_GHOSTBLADE)	
		RoundCheck_CallbackWin_Mutants();
}

//Countdown start
public Task_CountDown(TASK_ROUNDSTART)
{
	#define COUNT_TIMER 1.0
	#define COUNT_VALUE 10

	new sound_count[64];
	
	if(!g_count_down)
	{
		remove_task(TASK_ROUNDSTART);
	
		g_round_status = ROUNDSTATUS_START;
		
		//Set random player turn into mutant
		Random_Mutant();
		
		for(new iPlayer = 1; iPlayer < MaxClients + 1; iPlayer ++)
		{
			//Transform thos who voted for being mutants if value was true				
			if(g_mutant_vote[iPlayer] == 1 && is_soldier(iPlayer))	
				Setup_Mutant(iPlayer);	
			
			if(is_soldier(iPlayer) || is_ghostblade(iPlayer))	
				PlaySound(iPlayer, SND_OUTBREAK);
			else
				PlaySound(iPlayer, SND_OUTBREAK_MUTANT);
			
			client_print(SEND_ALL, print_center, MSG_COUNTDOWN_FINISHED);			
		}
	
		#if defined DEBUG_INFO
	
			client_print(SEND_ALL, print_chat, "Event_RoundStart, Round status: %d", g_round_status);

		#endif
		
	}
	else
	{		
		if(g_count_down <= COUNT_VALUE)
		{
			format(sound_count, charsmax(sound_count), "%s", SND_COUNTDOWN[g_count_down - 1]);
			PlaySound(SEND_ALL, sound_count);
		}
		
		//Assault sound
		if(g_count_down == COUNT_VALUE)
			PlaySound(SEND_ALL, SND_ASSAULT);
		
		//Draw announcer messages
		client_print(SEND_ALL, print_center, MSG_COUNTDOWN, g_count_down);
		
		set_task(COUNT_TIMER, "Task_CountDown", TASK_ROUNDSTART);
	}
	
	g_count_down -= 1;	
}

//Play music
public Task_RoundSound(TASK_ROUNDSOUND)
{ 
	//Ambient duration (sound duration)
	#define AMBIENT_DURATION 36.0

	remove_task(TASK_ROUNDSOUND);	
	set_task(AMBIENT_DURATION, "Task_RoundSound", TASK_ROUNDSOUND);
	
	PlaySound(SEND_ALL, SND_BGM);	
}

//Soldier levelup data
public Task_MercenaryLevelUp(TASK_MERCENARY_LEVEL)
{
	#define MAX_TICK_COUNT 90
	#define LEVELUP_TICK_TIMER 1.0

	remove_task(TASK_MERCENARY_LEVEL);
	
	if(g_round_status == ROUNDSTATUS_END)
		return;
	
	//Count to hundred
	if(g_mercenary_level < MAX_TICK_COUNT)
	{
		g_mercenary_level += 1;
		
		switch(g_mercenary_level)
		{
			//Level 1
			case 30:
			{
				g_level_stage = 1;		
				LevelUp_Mercenaries(SND_MERCENARY_LEVEL1, LEVEL_ONE_BPAMMO, false);
				
				#if defined MSG_DATA
			
					//Draw levelup message
					DrawLevelUp_Message();
					
				#endif

				//print_center
				DrawSupply_Message();
			}
			
			//Level 2
			case 60:
			{
				g_level_stage = 2;
				LevelUp_Mercenaries(SND_MERCENARY_LEVEL2, LEVEL_TWO_BPAMMO, false);

				#if defined MSG_DATA
			
					//Draw levelup message
					DrawLevelUp_Message();
					
				#endif
				
				//print_center
				DrawSupply_Message();
				
				for(new pPlayer = 1; pPlayer < MaxClients + 1; pPlayer ++)
				{	
					if(is_soldier(pPlayer) || is_ghostblade(pPlayer))		
					{
						//If used debug
						remove_task(pPlayer + TASK_HEARBEAT_SENSOR);
						
						//Start ping
						set_task(HEARBREAT_TIME/2, "Task_Heartbeat_Sensor", pPlayer + TASK_HEARBEAT_SENSOR);					
					}
				}										
			}
			
			//Only announcer
			case 75: LevelUp_Mercenaries(SND_GHOSTBLADE_15SEC, NULL, false);

			//Max level	
			case 90:
			{
				g_round_status = ROUNDSTATUS_GHOSTBLADE;
				
				#if defined DEBUG_INFO	
		
					client_print(SEND_ALL, print_chat, "Round status: %d", g_round_status);
		
				#endif				
					
				LevelUp_Mercenaries(SND_GHOSTBLADE_APPEAR, NULL, true);
				
				for(new pPlayer = 1; pPlayer < MaxClients + 1; pPlayer ++)
				{	
					if(is_mutant(pPlayer) || is_terminator(pPlayer))		
						PlaySound(pPlayer, SND_GHOSTBLADE_APPEAR_NANO);
				}
				
				#if defined MSG_DATA
			
					//Draw levelup message
					DrawLevelUp_Message();
					
				#endif
				
				//For everyone
				client_print(SEND_ALL, print_center, MSG_GHOSTBLADE_APPEARED);
				
			}			
		}
		
		set_task(LEVELUP_TICK_TIMER, "Task_MercenaryLevelUp", TASK_MERCENARY_LEVEL);
	}

	#if defined DEBUG_INFO
	
		client_print(SEND_ALL, print_chat, "Mercenary Level timeout: %d", g_mercenary_level);
		
	#endif
	
}

//Respawn mutants till Ghostblade appear
public Task_MutantRespawn(taskid)
{
	new iPlayer = taskid - TASK_MUTANT_RESPAWN;

	//Not happens normally
	if(pev_valid(iPlayer) != PDATA_SAFE || is_soldier(iPlayer)) 
		return;	

	ExecuteHamB(Ham_CS_RoundRespawn, iPlayer);
	
	//Died, give him the knife!
	Ham_Give_Weapon(iPlayer, "weapon_knife");

	//Set Player
	Setup_Mutant(iPlayer);
	
	//Protect
	SetProtection(iPlayer);
	
	//If mutant is respawned
	TurnOFF_Radio(iPlayer);	

	return;
}

//Set mutant blinking
public Task_SetBlink(taskid)
{
	#define BLINK_TIMER 0.1

	new iPlayer = taskid - TASK_BODY;
	
	remove_task(iPlayer + TASK_BODY);
	
	if(pev_valid(iPlayer) != PDATA_SAFE)		
		return;
	
	//Dead, set it back
	if(!is_user_alive(iPlayer))
	{
		set_pev(iPlayer, pev_skin, NULL);
		
		return;
	}		
	
	set_task(BLINK_TIMER, "Task_SetBlink", iPlayer + TASK_BODY);
	
	new iSkin;	
	iSkin = (pev(iPlayer, pev_skin) == NULL) ? 1 : NULL;

	//Flickering Effect by switching skins
	set_pev(iPlayer, pev_skin, iSkin);	
}

//Update team info
public Task_UpdateTeam(taskid)
{
	new iPlayer = taskid - TASK_TEAM;

	message_begin(MSG_ALL, g_msgTeamInfo);
	write_byte(iPlayer);
	write_string("TERRORIST");
	message_end();	
}

//Remove godmode
public Task_RemoveProtection(taskid)
{
	new iPlayer = taskid - TASK_PROTECTION;

	if(!is_user_connected(iPlayer))
		return;

	set_pev(iPlayer, pev_takedamage, DAMAGE_YES);
	
	//Maybe Boss setup manually
	if(is_soldier(iPlayer) || is_mutant(iPlayer))
		SetRendering(iPlayer);
}

//Automatic Win only at round end
public Task_SoldierWin(TASK_FORCEWIN)
{	
	remove_task(TASK_FORCEWIN);
	
	if(g_win_condition)
		return;

	#if defined MSG_DATA

		//Nano win
		MSG_GlobalHudMessage(100, 100, 100, -1.0, 0.20, MSG_SOLDIER_WIN);
		
	#endif	
	
	TerminateRound(RoundEndType_TeamExtermination, TeamWinning_Ct);
	PlaySound(SEND_ALL, SND_MERCENARY_WIN);
	
	#if defined DEBUG_INFO
			
		client_print(SEND_ALL, print_chat, "Round Terminated: Team Winning Soldiers");

	#endif
	
	g_win_condition = true;	
}

//Mutant skill
public Task_ResetMutantSkill(taskid)
{
	new iPlayer = taskid - TASK_MUTANT_SKILL;
	
	if(!is_user_alive(iPlayer))
		return;
	
	//Set skill speed if is not killed during usage
	if(is_mutant(iPlayer))
		set_pev(iPlayer, pev_maxspeed, MUTANT_SPEED);

	#if defined DEBUG_INFO
			
		GetPlayerSpeed(iPlayer);
			
	#endif	
	
	g_mutant_skill[iPlayer] = false;	
}

//Terminator skill
public Task_ResetTerminatorSkill(taskid)
{
	new iPlayer = taskid - TASK_TERMINATOR_SKILL;
	
	if(!is_user_alive(iPlayer))
		return;
	
	//Reset
	if(is_terminator(iPlayer))
	{
		set_pev(iPlayer, pev_takedamage, DAMAGE_YES);
		
		set_pev(iPlayer, pev_body, NULL);
		
		SetRendering(iPlayer);
	}	
}

//Terminator skill delay
public Task_TerminatorSkillReload(taskid)
{
	new iPlayer = taskid - TASK_TERMINATOR_SKILL_RELOAD;
	
	g_terminator_skill[iPlayer] = false;
}

//Global channel
//To prevent messages sending one after another (bad coloring effect)
public Task_ResetGlobalTextMSG(TASK_GLOBAL_TEXT_MSG)	
	g_global_msg = false;

//Player index channel
public Task_ResetTextMSG(taskid)
{
	new iPlayer = taskid - TASK_TEXT_MSG;
	
	g_hud_text_timeout[iPlayer] = false;
}

//Spawn supplybox
public Task_SupplyBox(TASK_SUPPLYBOX)
{
	#define SUPPLY_RELOAD_TIMER 25.0
	#define MIN_SPAWN 1

	remove_task(TASK_SUPPLYBOX);
	
	set_task(SUPPLY_RELOAD_TIMER, "Task_SupplyBox", TASK_SUPPLYBOX);
	
	if(g_round_status == ROUNDSTATUS_END || g_maximum_spawns < MIN_SPAWN)
		return;
	
	//Push
	for(new iSupplyAmount = 1; iSupplyAmount < 4; iSupplyAmount ++)
		Drop_SupplyBox();

	//Draw message
	if(g_round_status != ROUNDSTATUS_COUNT)
		client_print(SEND_ALL, print_center, MSG_SUPPLYBOX);

	//Drop sound
	for(new pPlayer = 1; pPlayer < MaxClients + 1; pPlayer ++)
	{
		if(is_soldier(pPlayer) || is_ghostblade(pPlayer))		
			PlaySound(pPlayer, SND_SUPPLYBOX_SOLDIERS);
		else
			PlaySound(pPlayer, SND_SUPPLYBOX_MUTANTS);
	}
	
	//Play helicopter sound
	PlaySound(SEND_ALL, SND_HELICOPTER);	
}

//Emulate join without random selection
public Spawn_Player(taskid)
{
	new iPlayer = taskid - TASK_SPAWN_PLAYER;
	
	//Allow once
	if(g_player_joined[iPlayer])
		return;
		
	#define CLIENT_SETTEAM "jointeam"
	#define CLIENT_SETCLASS "joinclass"	
	#define RANDOM_TEAM "5"
	#define RANDOM_CLASS "5"
 	
	//Pick random team
	engclient_cmd(iPlayer, CLIENT_SETTEAM, RANDOM_TEAM);
	
	//Pick random class	
	engclient_cmd(iPlayer, CLIENT_SETCLASS, RANDOM_CLASS);
	
	//Lock it
	g_player_joined[iPlayer] = true;
}

//Hearbeat sensor
public Task_Heartbeat_Sensor(taskid)
{
	new iPlayer = taskid - TASK_HEARBEAT_SENSOR;
	
	//Turned into mutant
	if(is_mutant(iPlayer) || is_terminator(iPlayer))
	{
		remove_task(iPlayer + TASK_HEARBEAT_SENSOR);
		
		return;
	}
	
	//Cycle through alive enemies
	for(new iTarget = 1; iTarget < MaxClients + 1; iTarget ++)
	{
		if(is_mutant(iTarget) || is_terminator(iTarget))
		{
			if(is_user_alive(iTarget))
			{
				new Float: iPlayerOrigin[3];		
				pev(iTarget, pev_origin, iPlayerOrigin);
		
				message_begin(MSG_ONE_UNRELIABLE, g_msgHostagePos, _, iPlayer);
				write_byte(iPlayer);
				write_byte(iTarget);
				write_coord_f(iPlayerOrigin[0]);
				write_coord_f(iPlayerOrigin[1]);
				write_coord_f(iPlayerOrigin[2]);
				message_end();

				message_begin(MSG_ONE_UNRELIABLE, g_msgHostageK, _, iPlayer);
				write_byte(iTarget);
				message_end();
			}
		}	
	}
	
	//Sound
	PlaySound(iPlayer, SND_HEARTBEAT);

	set_task(HEARBREAT_TIME, "Task_Heartbeat_Sensor", iPlayer + TASK_HEARBEAT_SENSOR);
}

//Fix Team/Scoreboard for connected players
public Task_FixScoreboard(taskid)
{
	new iPlayer = taskid - TASK_REGISTER_PLAYER;
	
	//Call this only for player, who connected at the middle of the round
	/*if(is_user_alive(iPlayer))
		return;*/	
	
	if(pev_valid(iPlayer) != PDATA_SAFE)
		return;
		
	//Not spawned already	
	if(get_pdata_int(iPlayer, m_iTeam, CBASE_PLAYER) != TEAM_CT)
	{
		set_pdata_int(iPlayer, m_iTeam, TEAM_CT, CBASE_PLAYER);
		
		//Update attribute
		message_begin(MSG_ALL, g_msgTeamInfo);
		write_byte(iPlayer);
		write_string("CT");
		message_end();
	
		#if defined DEBUG_INFO
			
			new iTeam, iTempChar[32];
		
			iTeam = get_pdata_int(iPlayer, m_iTeam, CBASE_PLAYER);
		
			switch(iTeam)
			{
				case 1: iTempChar = "TEAM MUTANTS";
				case 2: iTempChar = "TEAM SOLDIERS";
			}
		
			client_print(SEND_ALL, print_chat, "Connected %s to: %s", GetPlayerName(iPlayer), iTempChar);

		#endif

	}	
}

//Bot skill
public Task_BotUseSkill(taskid)
{
	#define SKILL_REUSE_TIMER random_float(20.0, 30.0)

	new iPlayer = taskid - TASK_BOT_SKILL;
	
	if(is_user_alive(iPlayer))
		class_skill(iPlayer);
	
	remove_task(iPlayer + TASK_BOT_SKILL);
	set_task(SKILL_REUSE_TIMER, "Task_BotUseSkill", iPlayer + TASK_BOT_SKILL);
}

//Mutant effect
public Remove_MutationEffect(iPlayer)
	Remove_EntityByOwner(iPlayer, MUTATION_CLASSNAME);

//Stungrenade	
public Task_StunGrenade(Float: iParamData[], taskid)
{
	#define STUNGRENADE_REPEAT_TIMER 0.1
	#define STUNGRENADE_TICK_TIMER 100
	#define STUNGRENADE_TICK 1
	#define STUNGRENADE_RADIUS 300.0
	#define STUN_VELOCITY 0.0

	new iOwner = taskid - TASK_STUNGRENADE;
	
	//Count to 10 seconds
	g_stungrenade_tick[iOwner] += STUNGRENADE_TICK;
	
	//Remove now
	if(g_stungrenade_tick[iOwner] > STUNGRENADE_TICK_TIMER)
	{
		remove_task(iOwner + TASK_STUNGRENADE);
		
		Remove_EntityByOwner(iOwner, SPHERE_CLASSNAME);
		
		//Can pick up next now
		g_stun_grenade_received[iOwner] = false;
		
		return;
	}
	
	//Convert data
	new Float: iPosition[3];
	iPosition[0] = iParamData[0];
	iPosition[1] = iParamData[1];
	iPosition[2] = iParamData[2];
	
	new pPlayer = NULLENT;
			
	//Slow down them
	while((pPlayer = engfunc(EngFunc_FindEntityInSphere, pPlayer, iPosition, STUNGRENADE_RADIUS)) > NULL)
	{
		if(is_user_alive(pPlayer))
		{
			set_pev(pPlayer, pev_velocity, STUN_VELOCITY);
			
			//Play sound fully
			g_stungrenade_sound[pPlayer] += STUNGRENADE_TICK;
			
			if(g_stungrenade_sound[pPlayer] > STUNGRENADE_TICK_TIMER / 5)
			{				
				emit_sound(pPlayer, NULL, SND_STUN_SOUND, 1.0, ATTN_NORM, NULL, PITCH_NORM);
				
				g_stungrenade_sound[pPlayer] = NULL;	
			}			
		}				
	}
		
	//Repeat
	set_task(STUNGRENADE_REPEAT_TIMER, "Task_StunGrenade", iOwner + TASK_STUNGRENADE, iPosition, sizeof(iPosition));	
}	