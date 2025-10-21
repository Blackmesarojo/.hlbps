//Terminator health
#define TERMINATOR_HEALTH 7000.0

//Terminator damage
#define TERMINATOR_DAMAGE 10.0

//Terminator speed
#define TERMINATOR_SPEED 250.0

//Terminator skill time
#define TERMINATOR_SKILL_TIME 10.0

//Skill reloading time
#define TERMINATOR_SKILL_RELOAD_TIME 20.0

//Terminator attack animtime - sequence frames/FPS
#define TERMINATOR_ANIMATION_PLAYTIME 0.72

//Terminator weapon animations, + 0.3 to animation playtime
#define TERMINATOR_SLASH_TIME 0.75
#define TERMINATOR_STAB_TIME 1.0
#define TERMINATOR_ATTACK_TIME 0.1
#define TERMINATOR_CRY_ANIM_TIME 2.5

//Crying animation
#define TERMINATOR_CRYING_ANIM 9

public Setup_Terminator(iPlayer)
{
	if(!is_user_alive(iPlayer))
		return;
	
	g_team[iPlayer] = TERMINATOR;
	
	//Reset inventory
	RemoveSkillData(iPlayer);
	
	//Set health
	set_pev(iPlayer, pev_health, TERMINATOR_HEALTH);
	set_pev(iPlayer, pev_max_health, TERMINATOR_HEALTH);
	
	//Switch to arms
	Execute_Ham_OnDeploy(iPlayer);
	
	//Reset skin
	Reset_Model(iPlayer);	
	
	//Set model
	set_player_model(iPlayer, "armored_terminator", MDL_TERMINATOR);

	//Remove rendering effects
	SetRendering(iPlayer);	
	
	//Play appearing sound
	PlaySound(iPlayer, SND_TERMINATOR_SELECT);
	
	//For everyone
	client_print(SEND_ALL, print_center, MSG_ARMORED_XENO_APPEARED);	

	//Set default speed last
	set_pev(iPlayer, pev_maxspeed, TERMINATOR_SPEED);
	
	//Create Xeno name
	Create_SpriteEffect(iPlayer, SPR_XENO_NAME, XENO_CLASSNAME, 5.0, 0.25);

	//Was in buyzone?
	Remove_BuySignal(iPlayer);	
}