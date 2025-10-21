//Mutant protection delay
#define MUTANT_PROTECTION_DELAY 10.0

//Mutant health
#define MUTANT_START_HEALTH 1500.0
#define MUTANT_LEVEL2_HEALTH 1750.0
#define MUTANT_LEVEL3_HEALTH 2000.0
#define MUTANT_LEVEL4_HEALTH 2250.0

//Mutant damage
#define LEVEL_ONE_NANO_DAMAGE 2.5
#define LEVEL_MAX_NANO_DAMAGE 3.5

//Mutant sound effect after amount of damage
#define MUTANT_MAX_HITSOUND 100.0

//Mutant default speed
#define MUTANT_SPEED 250.0

//Skill speed
#define MUTANT_SKILL_SPEED 300.0

//Skill time
#define MUTANT_SKILL_TIME 5.0

//How many mutations before transforming to Terminator
#define MUTANT_TARGET_EVOLVE 4

//How many hits to Ghostblade before transform to next form
#define MUTANT_HIT_TRANSFORM 5

//Mutant attack animtime - sequence frames/FPS
#define MUTANT_ANIMATION_PLAYTIME 0.52

//Mutant weapon animations, + 0.3 to animation playtime
#define MUTANT_SLASH_TIME 0.55
#define MUTANT_STAB_TIME 1.0
#define MUTANT_ATTACK_TIME 0.1

//Setup mutant/Or Respawn
public Setup_Mutant(iPlayer)
{
	#define UPDATE_TEAM_TIMER 0.1

	if(!is_user_alive(iPlayer))
		return;
	
	//First mutant or turned into by hit (not respawned)	
	if(g_team[iPlayer] != MUTANTS)
	{
		PlaySound(SEND_ALL, SND_MUTANT_APPEAR[random_num(0, 1)]);
			
		client_print(iPlayer, print_center, MSG_MUTANT_APPEAR);
	}	
	
	g_team[iPlayer] = MUTANTS;
	g_transform_gear[iPlayer] = true;
	
	//Reset inventory
	RemoveSkillData(iPlayer);

	//Move to TR
	set_pdata_int(iPlayer, m_iTeam, TEAM_TERRORIST, CBASE_PLAYER);
	
	//For multiple mutations attrib requires delay
	remove_task(iPlayer + TASK_TEAM);	
	set_task(UPDATE_TEAM_TIMER, "Task_UpdateTeam", iPlayer + TASK_TEAM);
	
	new Float: iHealth;
	
	//Set health
	switch(g_mutant_level[iPlayer])
	{
		case 1: iHealth = MUTANT_LEVEL2_HEALTH;			
		case 2, 3: iHealth = MUTANT_LEVEL3_HEALTH;
			
		default: iHealth = MUTANT_START_HEALTH;	
	}	
	
	set_pev(iPlayer, pev_health, iHealth);
	set_pev(iPlayer, pev_max_health, iHealth);
	
	//Remove armor
	Remove_Armor(iPlayer);

	//Remove inventory
	Strip_Weapon(iPlayer);
	
	//Deploy
	Execute_Ham_OnDeploy(iPlayer);	
	
	//Set default skin
	Reset_Model(iPlayer);	
	
	//Set model
	switch(g_mutant_level[iPlayer])
	{		
		case 2, 3: set_player_model(iPlayer, "mutant_evolution", MDL_MUTANT_EVOLUTION);
			
		default: set_player_model(iPlayer, "mutant", MDL_MUTANT);
	}

	//Remove rendering effects
	SetRendering(iPlayer);	

	//Set default speed last
	set_pev(iPlayer, pev_maxspeed, MUTANT_SPEED);
	
	//Was in buyzone?
	Remove_BuySignal(iPlayer);
	
	//Monster
	Hide_Money(iPlayer, true);

	//If everyone turned into mutants and player amount above 1
	if(g_player_amount >= PLAYERS_GAME_START && g_round_status == ROUNDSTATUS_START)		
		RoundCheck_CallbackWin_Mutants();

	//Set Bot use skill
	if(is_user_bot(iPlayer))
	{
		#define BOT_SKILL_TIMER random_float(10.0, 20.0)
	
		remove_task(iPlayer + TASK_BOT_SKILL);
		set_task(BOT_SKILL_TIMER, "Task_BotUseSkill", iPlayer + TASK_BOT_SKILL);
	}		
}

//Select random player
public Random_Mutant()
{	
	new pPlayers, iPlayer;
	
	//5 soldiers vs 1 mutant
	pPlayers = (Get_iTeamPlayer(SOLDIERS, true)) / 5 + 1;
	
	if(!pPlayers) 
		pPlayers = 1;

	while(pPlayers)
	{
		//Pick random player
		iPlayer = random_num(1, Get_iTeamPlayer(ALL));
		
		if(is_user_alive(iPlayer) && is_soldier(iPlayer))
		{
			//Transform
			Setup_Mutant(iPlayer);
			
			pPlayers --;
		}
		
		if(Get_iTeamPlayer(SOLDIERS) <= 1) 
			break;
	}
}

//Mutating others
public Mutant_HitSoldier(iAttacker, iVictim)
{
	#define DEPLETED_ARMOR 0.0
	#define MUTATION_REMOVE_DELAY 1.25

	//Nano armor, let mutant hit us and remove armor
	if(get_pdata_int(iVictim, m_iKevlar, CBASE_PLAYER) > DEPLETED_ARMOR)
	{
		set_pdata_int(iVictim, m_iKevlar, NULL, CBASE_PLAYER);
		set_pev(iVictim, pev_armorvalue, DEPLETED_ARMOR);
		
		//Send a message for them
		client_print(iVictim, print_center, MSG_NANO_ARMOR);
		client_print(iAttacker, print_center, MSG_NANO_ARMOR);
		
		//Send sound effect
		PlaySound(iVictim, SND_DAMAGE);
		PlaySound(iAttacker, SND_DAMAGE);
		
		//Protect from mutation once
		return;
	}	

	//Calc mutation
	Mutation_LevelUp(iAttacker);
	
	//Send death message and fix radar
	Update_DeathMessage(iAttacker, iVictim);
	Update_Attribute(iVictim);
	
	//Give bonuses
	Update_TeamScores(g_mutant_score += 2, "TERRORIST");
	
	//Give frags
	Update_PlayerScoreboard(iAttacker, 2, false);
	
	//Give deaths
	Update_PlayerScoreboard(iVictim, 1, true);

	//Turn target into mutant
	Setup_Mutant(iVictim);

	//Create mutation aura
	Create_SpriteEffect(iVictim, SPR_MUTANT_HIT, MUTATION_CLASSNAME, 10.0, 0.4);

	//Delay to remove effect
	set_task(MUTATION_REMOVE_DELAY, "Remove_MutationEffect", iVictim);	
}

//Mutant levelup
public Mutation_LevelUp(iPlayer)
{
	if(g_round_status == ROUNDSTATUS_END)
		return;

	if(!is_user_alive(iPlayer) || is_terminator(iPlayer))
		return;
	
	//Three mutation required to max upgrade
	if(g_mutant_level[iPlayer] < MUTANT_TARGET_EVOLVE)
	{	
		g_mutant_level[iPlayer] += 1;
		
		//Reset blink attribute
		g_damage_set[iPlayer] = false;
			
		//Levelup and remove blinking
		remove_task(iPlayer + TASK_BODY);
		Reset_Model(iPlayer);

		#if defined MSG_DATA

			//Draw levelup message
			MSG_HudMessage(iPlayer, 150, 100, NULL, -1.0, 0.30, MSG_LEVELUP, MSG_ATTENTION, true, true);

		#endif

		switch(g_mutant_level[iPlayer])
		{
			//Default + 1 + skill
			case 1: 
			{
				PlaySound(iPlayer, SND_MUTANT_LEVEL1);		
			
				//Set health
				set_pev(iPlayer, pev_health, MUTANT_LEVEL2_HEALTH);
				set_pev(iPlayer, pev_max_health, MUTANT_LEVEL2_HEALTH);
				
				//Draw message
				client_print(iPlayer, print_center, MSG_MUTANT_LEVELUP, g_mutant_level[iPlayer]);
			}
		
			//Level 2
			case 2: 
			{
				//Just change health and model
				PlaySound(iPlayer, SND_MUTANT_LEVEL2);			
			
				//Set health
				set_pev(iPlayer, pev_health, MUTANT_LEVEL3_HEALTH);
				set_pev(iPlayer, pev_max_health, MUTANT_LEVEL3_HEALTH);
			
				//Set model
				set_player_model(iPlayer, "mutant_evolution", MDL_MUTANT_EVOLUTION);					
								
				//Deploy arms
				Execute_Ham_OnDeploy(iPlayer);
				
				//Draw message
				client_print(iPlayer, print_center, MSG_MUTANT_LEVELUP_NEXT, g_mutant_level[iPlayer]);	
			}
			
			case 3:
			{
				//Playsound
				PlaySound(iPlayer, SND_MUTANT_LEVEL2);
				
				//Set health
				set_pev(iPlayer, pev_health, MUTANT_LEVEL4_HEALTH);
				set_pev(iPlayer, pev_max_health, MUTANT_LEVEL4_HEALTH);				
				
				//Show MSG
				client_print(iPlayer, print_center, MSG_MUTANT_LEVELUP_NEXT, g_mutant_level[iPlayer]);
			}	
		
			//Terminator
			case 4: 
			{
				for(new pPlayer = 1; pPlayer < MaxClients + 1; pPlayer ++)
				{	
					if(is_soldier(pPlayer) || is_ghostblade(pPlayer))		
						PlaySound(pPlayer, SND_TERMINATOR_APPEAR);
				
					else
						PlaySound(pPlayer, SND_TERMINATOR_APPEAR_NANO);
				}
				
				//Setup class
				Setup_Terminator(iPlayer);
			}		
		}
	}	
}