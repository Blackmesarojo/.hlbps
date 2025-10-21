#define ITEM_SLOT_1 1
#define ITEM_SLOT_2 2

//Next respawn	
public Change_Agent(iPlayer)
{
	#define BP_CHARA_AMOUNT 60

	if(!is_user_alive(iPlayer))
		return;
		
	if(Not_Soldier(iPlayer))
		return;	
		
	//Set model
	player_set_model(iPlayer, "fox_seaside", MDL_FOX_SEASIDE);
	
	//Remove backpack items
	player_weaponstrip(iPlayer);
	
	//Randomly give AK
	new iRandom;	
	iRandom = random_num(1, 5);
		
	//Give a weapon
	player_give_weapon(iPlayer, "weapon_knife");
	player_give_weapon(iPlayer, "weapon_elite");
	
	switch(iRandom)
	{
		case 1: player_give_weapon(iPlayer, "weapon_ak47");
		default: player_give_weapon(iPlayer, "weapon_mp5navy");
	}	

	player_give_weapon(iPlayer, "weapon_hegrenade");	

	//Bpammo	
	player_give_bpammo(iPlayer, BP_CHARA_AMOUNT, false);
	
	//Give armor
	player_give_vesthelmet(iPlayer);

	//Update
	player_force_deploy(iPlayer);
	
	//Cannot buy
	player_no_buyzone(iPlayer);
	
	//Hide Money
	player_hide_money(iPlayer, true);
}

//Reset Agent
public Reset_Agent(iPlayer)
{
	if(!is_user_alive(iPlayer))
		return;	

	if(Not_Soldier(iPlayer))
		return;		

	//Reset player model	
	player_reset_model(iPlayer);
	
	//Remove backpack items
	player_weaponstrip(iPlayer);
	
	//Give a weapon
	player_give_weapon(iPlayer, "weapon_knife");
	player_give_weapon(iPlayer, "weapon_deagle");

	//Bpammo	
	player_give_bpammo(iPlayer, NULL, true);
	
	//Remove armor
	player_remove_armor(iPlayer);
	
	//Update
	player_force_deploy(iPlayer);
	
	//Unhide Money
	player_hide_money(iPlayer, false);	
}

//Ready to set
public Setup_Character(iPlayer)
{
	if(character_setup[iPlayer])
	{
		client_print(iPlayer, print_chat, "Agent switch available only once per round.");
		return;
	}

	//Lock bool to spawn as this character
	set_character_fox[iPlayer] = !set_character_fox[iPlayer];

	//Set if not this character
	if(set_character_fox[iPlayer])
		Change_Agent(iPlayer);	
	else
		Reset_Agent(iPlayer);
		
	character_setup[iPlayer] = true;	
}

//Play weapon animation
public Play_WeaponAnimation(iPlayer)
{
	#define NULL_VALUE 0.0
	#define IDLE_TIME 1.0
	#define KNIFE_DEPLOY_ANIMATION 3
	#define ELITE_DEPLOY_ANIMATION 15
	#define HE_DEPLOY_ANIMATION 3
	#define SMOKE_DEPLOY_ANIMATION 3
	#define AK47_DEPLOY_ANIMATION 2
	#define MP5_DEPLOY_ANIMATION 2

	if(!is_user_alive(iPlayer))
		return;

	//Monsters and Soldiers
	if(Not_Soldier(iPlayer) || !Is_Character_Fox(iPlayer))
		return;		
	
	static iEnt, iId, iButton, iInReload;
	iEnt = get_pdata_cbase(iPlayer, m_pActiveItem, CBASE_PLAYER);
	
	//Holding button?
	iButton = pev(iPlayer, pev_button);
	
	//In reload?
	iInReload = get_pdata_int(iEnt, m_fInReload, CBASE_WEAPON);
	
	//Grab that values
	new Float: flNextPrimaryAttack = get_pdata_float(iEnt, m_flNextPrimaryAttack, CBASE_WEAPON);
	new Float: flNextSecondaryAttack = get_pdata_float(iEnt, m_flNextSecondaryAttack, CBASE_WEAPON);
	
	//And stop sending if player is reloading or firing/holding.
	if(flNextPrimaryAttack > NULL_VALUE || flNextSecondaryAttack > NULL_VALUE || iInReload || iButton & IN_ATTACK || iButton & IN_ATTACK2)
		return;

	//Set pause	
	set_pdata_float(iEnt, m_flTimeWeaponIdle, IDLE_TIME, CBASE_WEAPON);
	
	new iAnimation;
	
	//Get a weapon 
	iId = get_pdata_int(iEnt, m_iId, CBASE_WEAPON);
	
	//Deploy animations
	switch(iId)
	{
		case CSW_KNIFE:
		{	
			iAnimation = KNIFE_DEPLOY_ANIMATION; 
			
			//Playsound
			playsound_callback(iPlayer, "weapons/knife_deploy1.wav");
		}
		
		case CSW_ELITE: iAnimation = ELITE_DEPLOY_ANIMATION;
		case CSW_AK47: iAnimation = AK47_DEPLOY_ANIMATION;
		case CSW_MP5NAVY: iAnimation = MP5_DEPLOY_ANIMATION;
		case CSW_HEGRENADE: iAnimation = HE_DEPLOY_ANIMATION;
		case CSW_SMOKEGRENADE: iAnimation = SMOKE_DEPLOY_ANIMATION;
	}
	
	//Send
	ExecuteHam(Ham_CS_Weapon_SendWeaponAnim, iEnt, iAnimation, NULL);
}

//Return this character
public bool: Is_Character_Fox(iPlayer)
{
	if(set_character_fox[iPlayer] && player_soldier(iPlayer))
		return true;
		
	return false;	
}

//Return Mutant/Terminator or Knight
public bool: Not_Soldier(iPlayer)
{
	if(player_mutant(iPlayer) || player_terminator(iPlayer) || player_ghostblade(iPlayer))
		return true;
		
	return false;	
}