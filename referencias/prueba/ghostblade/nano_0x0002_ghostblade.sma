//Ghostblade health
#define GHOSTBLADE_HEALTH 3000.0

//Ghostblade damage
#define GHOSTBLADE_DAMAGE 7.0

//Ghostblade sound effect after amount of damage
#define GHOSTBLADE_MAX_HITSOUND 150.0

//Ghostblade default speed
#define GHOSTBLADE_SPEED 250.0

//Ghostblade sword Battle-form speed
#define GHOSTBLADE_BATTLE_SPEED 70.0

//Switch between sword form
new Float: KnightBladeSwitchTime[MAXPLAYERS + 1];

//Ghostblade attack animtime - sequence frames/FPS
#define KNIGHT_ANIMATION_PLAYTIME 0.72

//Ghostblade sword form switch time
#define KNIGHT_SWORD_SWITCH_TIME 0.5
#define KNIGHT_SWORD_TRANSFORM_TIME 1.5
#define KNIGHT_SWORD_STAB_TIME 1.0
#define KNIGHT_SWORD_SLASH_TIME 0.75

//Ghostblade sword animations
#define GHOSTBLADE_COMBO_1A_ANIM 11
#define GHOSTBLADE_DEFENCE_START 12
#define GHOSTBLADE_DEFENCE_FINISH 24
#define GHOSTBLADE_DEFENCE_ANIM 13
#define GHOSTBLADE_DEFENCE_HIT_ANIM 14
#define GHOSTBLADE_SKILL_IDLE_ANIM 10
#define GHOSTBLADE_SWORD_SWITCH_1A 16
#define GHOSTBLADE_SWORD_SWITCH_2B 9
#define GHOSTBLADE_BTLBIGSHOT_1 18

//Ghostblade action delay
#define GHOSTBLADE_SLASH_TIME 0.75
#define GHOSTBLADE_STAB_TIME 1.5
#define GHOSTBLADE_ATTACK_TIME 0.1
#define GHOSTBLADE_COMBO_TIME 1.0
#define GHOSTBLADE_DEFENCE_SLASH_TIME 1.0
#define GHOSTBLADE_DEFENCE_STAB_TIME 1.0
#define GHOSTBLADE_DEFENCE_HIT_TIME 0.1
#define GHOSTBLADE_DEFENCE_FINISH_TIME 0.5
#define GHOSTBLADE_SKILL_IDLE_TIME 5.0
#define GHOSTBLADE_SWORD_FINISH_TIME 1.0
#define GHOSTBLADE_INSTANT_KILL_RECHARGE 3.0

public Setup_Ghostblade(iPlayer)
{
	#define KNIGHT_MODEL_TIMER 0.25

	if(!is_user_alive(iPlayer))
		return;	
	
	//Setup attributes
	g_team[iPlayer] = GHOSTBLADE;
	g_transform_gear[iPlayer] = true;
	g_defence_finished[iPlayer] = true;
	
	//Reset inventory
	RemoveSkillData(iPlayer);
	
	//Set health
	set_pev(iPlayer, pev_health, GHOSTBLADE_HEALTH);
	set_pev(iPlayer, pev_max_health, GHOSTBLADE_HEALTH);
	
	//Remove armor
	Remove_Armor(iPlayer);

	//Remove inventory
	Strip_Weapon(iPlayer);

	//Switch to arms
	Execute_Ham_OnDeploy(iPlayer);
			
	//Reset skin, if was transfered manually by admin
	Reset_Model(iPlayer);	

	//TODO fix Knight sword joints	
	set_player_model(iPlayer, "ghostblade", MDL_GHOSTBLADE);	

	//Set glow fx
	SetRendering(iPlayer, kRenderFxHologram, NULL, NULL, NULL, kRenderNormal, NULL);

	//Play appearing sound
	PlaySound(iPlayer, SND_GHOSTBLADE_SELECT);
	
	//Set default speed last
	set_pev(iPlayer, pev_maxspeed, GHOSTBLADE_SPEED);

	#if defined MSG_DATA

		//E button hint
		MSG_HudMessage(iPlayer, 150, 100, 0, -1.0, 0.40, MSG_STANCE_KEY, MSG_STANCE_KEY, false, true);	
		
	#endif
	
	//Create Knight aura
	Create_SpriteEffect(iPlayer, SPR_KNIGHT_NAME, KNIGHT_CLASSNAME, 5.0, 0.25);
	
	//Was in buyzone?
	Remove_BuySignal(iPlayer);
	
	//Monster
	Hide_Money(iPlayer, true);	
}	