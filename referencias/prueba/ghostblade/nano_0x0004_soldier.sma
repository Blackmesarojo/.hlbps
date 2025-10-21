//Protection time
#define SOLDIER_PROTECTION_DELAY 20.0

//Soldier start health
#define SOLDIER_START_HEALTH 100.0

//Soldiers damage
#define LEVEL_ONE_DAMAGE 0.5
#define LEVEL_MAX_DAMAGE 1.0

//Soldiers supply
#define START_AMMUNITION 30
#define LEVEL_ONE_BPAMMO 30
#define LEVEL_TWO_BPAMMO 60

//Weapon idle time
#define DEFAULT_IDLE_TIME 1.0

//Hearbeat sensor interval
#define HEARBREAT_TIME 3.0

//Setup soldier
public Setup_Soldier(iPlayer)
{
	if(!is_user_alive(iPlayer))
		return;
	
	//Reset inventory
	RemoveSkillData(iPlayer);	
	
	//Set health
	set_pev(iPlayer, pev_health, SOLDIER_START_HEALTH);
	set_pev(iPlayer, pev_max_health, SOLDIER_START_HEALTH);
	
	//Set default skin
	Reset_Model(iPlayer);

	//Set all to Urban
	reset_player_model(iPlayer);	
	
	//Remove rendering effects
	SetRendering(iPlayer);
	
	//Only if this one was mutated before and not spawned as Soldier
	if(g_transform_gear[iPlayer])
	{		
		//Clear attributes
		g_transform_gear[iPlayer] = false;
		g_soldier_deploy[iPlayer] = true;
	}		
	
	//Ammo and everything else
	Remove_PlayerArmoury(iPlayer);
	
	#if defined USE_SPECIAL_CHARACTER
	
		//No need that for special chara
		if(!player_fox_seaside(iPlayer))
		{		
			Ham_Give_Weapon(iPlayer, "weapon_knife");
			
			if(!is_user_bot(iPlayer))
			{
				Ham_Give_Weapon(iPlayer, "weapon_deagle");
			
				//Not a monster
				Hide_Money(iPlayer, false);			
			}
		}		
			
	#else
		
		Ham_Give_Weapon(iPlayer, "weapon_knife");
		
		//For bots and for special character no need
		if(!is_user_bot(iPlayer))
			Ham_Give_Weapon(iPlayer, "weapon_deagle");

		//Not a monster
		Hide_Money(iPlayer, false);			

	#endif
	
	//Start with small amount of bullets
	Refill_Ammunition(iPlayer, NULL, true);
	
	//Protect from being killed at spawn
	SetProtection(iPlayer);
	
	//If players spawned at the same spawn point, move them to different nearby origin
	UnstuckPlayer(iPlayer, 32, 128);
	
	//Radio and radio icon
	TurnOFF_Radio(iPlayer);
	
	//Reset speed
	ExecuteHamB(Ham_Player_ResetMaxSpeed, iPlayer);
	
	//Give them guns
	Bot_RandomWeapon(iPlayer);
	
	//Next spawn flag this player
	g_player_first_spawn[iPlayer] = false;
	
	#if defined DEBUG_INFO
	
		client_print(SEND_ALL, print_chat, "Player first spawn: %d, User: %s", g_player_first_spawn[iPlayer], GetPlayerName(iPlayer));

	#endif
	
}