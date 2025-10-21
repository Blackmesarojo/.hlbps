/*ANIMATION SYSTEM*/

//Set animation module required
//Download: https://forums.alliedmods.net/showpost.php?p=2286051&postcount=7

//Use separate backward animation, because this models are without blending sequences
#define USE_ANIMATION_BREAKER

//Animations
enum _:PLAYER_ANIM
{
	PLAYER_IDLE = NULL,
	PLAYER_WALK,
	PLAYER_JUMP,
	PLAYER_SUPERJUMP,
	PLAYER_DIE,
	PLAYER_ATTACK1,
	PLAYER_ATTACK2,
	PLAYER_FLINCH,
	PLAYER_LARGE_FLINCH,
	PLAYER_RELOAD,
	PLAYER_HOLDBOMB
}
	
//Player activities
enum _: ACTIVITY
{
	ACT_RESET = NULL,
	ACT_IDLE,
	ACT_GUARD,
	ACT_WALK,
	ACT_RUN,
	ACT_FLY,
	ACT_SWIM,
	ACT_HOP,
	ACT_LEAP,
	ACT_FALL,
	ACT_LAND,
	ACT_STRAFE_LEFT,
	ACT_STRAFE_RIGHT,
	ACT_ROLL_LEFT,
	ACT_ROLL_RIGHT,
	ACT_TURN_LEFT,
	ACT_TURN_RIGHT,
	ACT_CROUCH,
	ACT_CROUCHIDLE,
	ACT_STAND,
	ACT_USE,
	ACT_SIGNAL1,
	ACT_SIGNAL2,
	ACT_SIGNAL3,
	ACT_TWITCH,
	ACT_COWER,
	ACT_SMALL_FLINCH,
	ACT_BIG_FLINCH,
	ACT_RANGE_ATTACK1,
	ACT_RANGE_ATTACK2,
	ACT_MELEE_ATTACK1,
	ACT_MELEE_ATTACK2,
	ACT_RELOAD,
	ACT_ARM,
	ACT_DISARM,
	ACT_EAT,
	ACT_DIESIMPLE,
	ACT_DIEBACKWARD,
	ACT_DIEFORWARD,
	ACT_DIEVIOLENT,
	ACT_BARNACLE_HIT,
	ACT_BARNACLE_PULL,
	ACT_BARNACLE_CHOMP,
	ACT_BARNACLE_CHEW,
	ACT_SLEEP,
	ACT_INSPECT_FLOOR,
	ACT_INSPECT_WALL,
	ACT_IDLE_ANGRY,
	ACT_WALK_HURT,
	ACT_RUN_HURT,
	ACT_HOVER,
	ACT_GLIDE,
	ACT_FLY_LEFT,
	ACT_FLY_RIGHT,
	ACT_DETECT_SCENT,
	ACT_SNIFF,
	ACT_BITE,
	ACT_THREAT_DISPLAY,
	ACT_FEAR_DISPLAY,
	ACT_EXCITED,
	ACT_SPECIAL_ATTACK1,
	ACT_SPECIAL_ATTACK2,
	ACT_COMBAT_IDLE,
	ACT_WALK_SCARED,
	ACT_RUN_SCARED,
	ACT_VICTORY_DANCE,
	ACT_DIE_HEADSHOT,
	ACT_DIE_CHESTSHOT,
	ACT_DIE_GUTSHOT,
	ACT_DIE_BACKSHOT,
	ACT_FLINCH_HEAD,
	ACT_FLINCH_CHEST,
	ACT_FLINCH_STOMACH,
	ACT_FLINCH_LEFTARM,
	ACT_FLINCH_RIGHTARM,
	ACT_FLINCH_LEFTLEG,
	ACT_FLINCH_RIGHTLEG,
	ACT_FLINCH,
	ACT_LARGE_FLINCH,
	ACT_HOLDBOMB,
	ACT_IDLE_FIDGET,
	ACT_IDLE_SCARED,
	ACT_IDLE_SCARED_FIDGET,
	ACT_FOLLOW_IDLE,
	ACT_FOLLOW_IDLE_FIDGET,
	ACT_FOLLOW_IDLE_SCARED,
	ACT_FOLLOW_IDLE_SCARED_FIDGET,
	ACT_CROUCH_IDLE,
	ACT_CROUCH_IDLE_FIDGET,
	ACT_CROUCH_IDLE_SCARED,
	ACT_CROUCH_IDLE_SCARED_FIDGET,
	ACT_CROUCH_WALK,
	ACT_CROUCH_WALK_SCARED,
	ACT_CROUCH_DIE,
	ACT_WALK_BACK,
	ACT_IDLE_SNEAKY,
	ACT_IDLE_SNEAKY_FIDGET,
	ACT_WALK_SNEAKY,
	ACT_WAVE,
	ACT_YES,
	ACT_NO
}
	
//Hitgroup
enum _:HITGROUP
{
	HITGROUP_GENERIC = NULL,
	HITGROUP_HEAD,
	HITGROUP_CHEST,
	HITGROUP_STOMACH,
	HITGROUP_LEFTARM,
	HITGROUP_RIGHTARM,
	HITGROUP_LEFTLEG,
	HITGROUP_RIGHTLEG,
	HITGROUP_SHIELD	
}
	
#define ANIMATION_IGNORED 0
#define ANIMATION_SUPERCEDE 1

//Model gait animations
#define ANIM_IDLE 1
#define ANIM_CROUCH_IDLE 2
#define ANIM_WALK 3
#define ANIM_RUN 4
#define ANIM_CROUCH_RUN 5
#define ANIM_JUMP 9

//Model death animation
#define ANIM_DEATH 101
#define ANIM_CROUCH_DEATH 110
	
#if defined USE_ANIMATION_BREAKER
	
	//Backward animation
	#define ANIM_BACKWARD_RUN 6
	#define ANIM_BACKWARD_WALK 7
	#define ANIM_BACKWARD_CROUCH_RUN 8
	
#endif	
	
//Model aim sequences
#define ANIM_REF_AIM_KNIFE 12
#define ANIM_CROUCH_AIM_KNIFE 10
	
//Model ref shoot sequences
#define ANIM_REF_SHOOT_KNIFE 13
#define ANIM_CROUCH_SHOOT_KNIFE 11
#define ANIM_REF_SHOOT_COMBO 14
#define ANIM_CROUCH_SHOOT_COMBO 15
	
//Hit mutants anim
#define ANIM_FLINCH 16
#define ANIM_HEAD_FLINCH 17

//Flinch animation timer
#define FLINCH_ANIMATION_PLAYTIME 0.2	

//Player velocity
#define AWP_SPEED 210.0
#define MINIMAL_SPEED 10.0
	
//Frame
#define DEFAULT_FRAME 0.0	
	
//Framerate
#define DEFAULT_FRAMERATE 1.0
	
//Is crouching
#define PLAYER_IN_DUCK(%1) pev(%1, pev_flags) & FL_DUCKING

#if defined USE_ANIMATION_BREAKER

	//Store players direction condition
	new bool: iDirection_MoveForward[MAXPLAYERS + 1];
	
#endif	
	
//Module Callback
public OnSetAnimation(iPlayer, iAnimation)
{
	new PLAYER_ANIMATION, iWeapon, iId, iMovetype_Condition;
	new Float: iVelocity[3];
		
	PLAYER_ANIMATION = iAnimation;		
		
	//Skip for soldiers
	if(is_soldier(iPlayer))
		return ANIMATION_IGNORED;
		
	//Deadstate	
	#define PLAYER_DEAD pev(iPlayer, pev_health) < 1
		
	/*Died, let's play die scene. By default it starts from sequence 101.
	Changing to another sequence requires same gaitsequence num call, so let it play over default.*/
	if(PLAYER_DEAD)
	{
		#define MUTANT_DEATH_ANIM_SPEED 250.0
		#define BOSS_DEATH_ANIM_SPEED 100.0
		
		//TODO activities callback for external check
		set_pdata_int(iPlayer, m_Activity, ACT_DIESIMPLE, CBASE_PLAYER);	//Current monster activity
		set_pdata_int(iPlayer, m_IdealActivity, ACT_DIESIMPLE, CBASE_PLAYER);	//Next monster activity
	
		//Was in duck?
		if(PLAYER_IN_DUCK(iPlayer))
			PlaySequence(iPlayer, ANIM_CROUCH_DEATH);
		
		//Normal death	
		else	
			PlaySequence(iPlayer, ANIM_DEATH);

		//Death animation framerate	
		switch(g_team[iPlayer])
		{
			case MUTANTS: set_pdata_float(iPlayer, m_flFrameRate, MUTANT_DEATH_ANIM_SPEED, CBASE_ANIMATION);
			case GHOSTBLADE, TERMINATOR: set_pdata_float(iPlayer, m_flFrameRate, BOSS_DEATH_ANIM_SPEED, CBASE_ANIMATION);
		}	
		
		//Stop looping
		set_pdata_int(iPlayer, m_fSequenceLoops, FALSE, CBASE_ANIMATION);		
		
		return ANIMATION_SUPERCEDE;
	}		
		
	//Player weapon	
	iWeapon = get_pdata_cbase(iPlayer, m_pActiveItem, CBASE_PLAYER);
		
	if(iWeapon != NULLENT)
	{
		iId = get_pdata_int(iWeapon, m_iId, CBASE_WEAPON);
		
		//Pass only for knife
		if(iId != CSW_KNIFE)
			return ANIMATION_IGNORED;
	}		

	//Get player velocity
	pev(iPlayer, pev_velocity, iVelocity);
		
	//Skip	
	iVelocity[2] = 0.0;			
		
	//Movement
	#define PLAYER_SPEED vector_len(iVelocity)
	#define PLAYER_ONGROUND pev(iPlayer, pev_flags) & FL_ONGROUND
	
	//ANIMATION BREAKER. Check only player Keyboard
	#if defined USE_ANIMATION_BREAKER
	
		//Condition
		#define PLAYER_MOVE_FORWARD (iDirection_MoveForward[iPlayer] == true)
		#define GET_FORWARD_BUTTON pev(iPlayer, pev_button) & IN_FORWARD
	
		//Player input
		Get_PlayerKeyboard(iPlayer);
		
	#endif	

	//Crouch condition
	#define CONDITION_CROUCH PLAYER_SPEED < MINIMAL_SPEED
	#define CONDITION_CROUCH_RUN PLAYER_SPEED > MINIMAL_SPEED
		
	//Ref standing condition
	#define CONDITION_REF_IDLE PLAYER_SPEED < MINIMAL_SPEED && PLAYER_ONGROUND
	#define CONDITION_REF_WALK PLAYER_SPEED < AWP_SPEED && PLAYER_SPEED > MINIMAL_SPEED
	#define CONDITION_REF_RUN PLAYER_SPEED > AWP_SPEED	
		
	//Get player movetype condition
	iMovetype_Condition = pev(iPlayer, pev_movetype) == MOVETYPE_FLY;
	
	/*------------------------------------------------------------
	
	There is no swim animation for mutant/ghostblade/terminator.
	For water swim you can use check in PLAYER_IDLE, PLAYER_WALK
	for pev_waterlevel.	
	
	------------------------------------------------------------*/

	//Ducking				
	if(PLAYER_IN_DUCK(iPlayer))
	{
		switch(PLAYER_ANIMATION)
		{
			//PLAYER_ANIMATION returns both or nothing
			case PLAYER_IDLE, PLAYER_WALK:
			{
				set_pdata_int(iPlayer, m_Activity, ACT_WALK, CBASE_PLAYER);
				set_pdata_int(iPlayer, m_IdealActivity, ACT_WALK, CBASE_PLAYER);			
			
				//Crouch idle	
				if(CONDITION_CROUCH)					
					OnSetModuleAnimation(iPlayer, ANIM_CROUCH_IDLE);		
					
				//Crouchrun		
				if(CONDITION_CROUCH_RUN)
				{		
				
					#if defined USE_ANIMATION_BREAKER
					
						//Shots fired, flinch triggered
						if(FlinchAnimationStart(iPlayer))
						{
							//Player is moving in forward?
							if(GET_FORWARD_BUTTON)
								OnSetModuleAnimation(iPlayer, ANIM_CROUCH_RUN);
								
							/*If not, play backrun animation (knockback) while flinch is playing.
							Make cool backward movement effect*/ 		
							else
								OnSetModuleAnimation(iPlayer, ANIM_BACKWARD_CROUCH_RUN);
						}

						//Normal condition
						else
						{
							if(PLAYER_MOVE_FORWARD)
								OnSetModuleAnimation(iPlayer, ANIM_CROUCH_RUN);	
							else
								OnSetModuleAnimation(iPlayer, ANIM_BACKWARD_CROUCH_RUN);								
						}	
					
					//Default, no custom animation is used	
					#else

						OnSetModuleAnimation(iPlayer, ANIM_CROUCH_RUN);
							
					#endif
						
				}	
			}
		}	
	}

	//Setup standing animations	
	else
	{
		switch(PLAYER_ANIMATION)
		{
			case PLAYER_IDLE, PLAYER_WALK:
			{
				set_pdata_int(iPlayer, m_Activity, ACT_WALK, CBASE_PLAYER);
				set_pdata_int(iPlayer, m_IdealActivity, ACT_WALK, CBASE_PLAYER);			
			
				//Condition idle
				if(CONDITION_REF_IDLE)				
					OnSetModuleAnimation(iPlayer, ANIM_IDLE);	
						
				//Condition walk	
				if(CONDITION_REF_WALK)
				{
				
					#if defined USE_ANIMATION_BREAKER
				
						if(FlinchAnimationStart(iPlayer))
						{
							if(GET_FORWARD_BUTTON)
								OnSetModuleAnimation(iPlayer, ANIM_WALK);	
							else
								OnSetModuleAnimation(iPlayer, ANIM_BACKWARD_WALK);
						}
						else
						{
							if(PLAYER_MOVE_FORWARD)
								OnSetModuleAnimation(iPlayer, ANIM_WALK);								
							else
								OnSetModuleAnimation(iPlayer, ANIM_BACKWARD_WALK);
						}		
							
					#else

						OnSetModuleAnimation(iPlayer, ANIM_WALK);
						
					#endif
					
				}	

				//Condition run
				if(CONDITION_REF_RUN)
				{
				
					#if defined USE_ANIMATION_BREAKER
				
						if(FlinchAnimationStart(iPlayer))
						{
							if(GET_FORWARD_BUTTON)
								OnSetModuleAnimation(iPlayer, ANIM_RUN);
							else
								OnSetModuleAnimation(iPlayer, ANIM_BACKWARD_RUN);
						}
						else
						{							
							if(PLAYER_MOVE_FORWARD)
								OnSetModuleAnimation(iPlayer, ANIM_RUN);
							else
								OnSetModuleAnimation(iPlayer, ANIM_BACKWARD_RUN);
						}		
							
					#else

						OnSetModuleAnimation(iPlayer, ANIM_RUN);
						
					#endif						
				}		
			}
				
			//Condition jump
			case PLAYER_JUMP:
			{
				set_pdata_int(iPlayer, m_Activity, ACT_HOP, CBASE_PLAYER);
				set_pdata_int(iPlayer, m_IdealActivity, ACT_HOP, CBASE_PLAYER);
			
				OnSetModuleAnimation(iPlayer, ANIM_JUMP);
			}	
				
			//Animate noncrouch jump attack separately, because we skipping it on main callback				
			case PLAYER_ATTACK1, PLAYER_ATTACK2:
			{
				if(!(PLAYER_ONGROUND))
					NonGroundAttackAnimation(iPlayer);				
			}			
		}	
	}
	
	/*------------------------------------------------------------
	
	There is no climbing animation in Counter-Strike. Default 
	walk/crouch animations keeps looping while climbing up.
	It stops looping if player is not moving, so just let's force 
	always idle anim, to pass this weird thing.	
	
	------------------------------------------------------------*/	
		
	//Conveyor or ladder trigger
	if(iMovetype_Condition)
	{
		//Break animation
		if(PLAYER_IN_DUCK(iPlayer))		
			OnSetModuleAnimation(iPlayer, ANIM_CROUCH_IDLE);	
		else		
			OnSetModuleAnimation(iPlayer, ANIM_IDLE);	
	}
			
	/*client_print(iPlayer, print_chat, "Animation: %d", PLAYER_ANIMATION);
	client_print(iPlayer, print_chat, "GaitSequence: %d", pev(iPlayer, pev_gaitsequence));
	client_print(iPlayer, print_chat, "Sequence: %d", pev(iPlayer, pev_sequence));*/
			
	return ANIMATION_SUPERCEDE;
}
	
//Play animation
public OnSetModuleAnimation(iPlayer, iGaitSequence)
{
	new iReference, iShootReference, iAimReference, iFlinchRef;
		
	//Check, if already set.	
	iReference = pev(iPlayer, pev_sequence);			
	
	//Flinch animation
	if(FlinchAnimationStart(iPlayer))
	{
		//Get Hitgroup	
		switch(get_pdata_int(iPlayer, m_LastHitGroup, CBASE_PLAYER))
		{
			case HITGROUP_HEAD, HITGROUP_CHEST: iFlinchRef = ANIM_HEAD_FLINCH;
			default: iFlinchRef = ANIM_FLINCH;
		}

		//Is not playing
		if(iReference != iFlinchRef)
			PlaySequence(iPlayer, iFlinchRef);			
				
		set_pdata_int(iPlayer, m_fSequenceLoops, FALSE, CBASE_ANIMATION);
	}
		
	//On ground attacks/crouchjumping
	if(AttackAnimationStart(iPlayer) && !FlinchAnimationStart(iPlayer))
	{
		//Is it ducking?
		if(PLAYER_IN_DUCK(iPlayer))
		{
			//Mutant/Terminator/Ghostblade ref anim
			if(g_skill_animation_time[iPlayer] > get_gametime())	
				iShootReference = ANIM_CROUCH_SHOOT_KNIFE;	
					
			//Mutant and Terminator combo	
			else
				iShootReference = ANIM_CROUCH_SHOOT_COMBO;
		}

		//Standing	
		else
		{
			//Mutant/Terminator/Ghostblade ref anim
			if(g_skill_animation_time[iPlayer] > get_gametime())
				iShootReference = ANIM_REF_SHOOT_KNIFE;	
					
			//Mutant and Terminator combo	
			else
				iShootReference = ANIM_REF_SHOOT_COMBO;
		}		
			
		//Is not playing
		if(iReference != iShootReference)
			PlaySequence(iPlayer, iShootReference);

		set_pdata_int(iPlayer, m_fSequenceLoops, FALSE, CBASE_ANIMATION);
	}			

	//Aim reference hold	
	else
	{
		//Play flinch before fully if set
		if(!FlinchAnimationStart(iPlayer))
		{
			if(PLAYER_IN_DUCK(iPlayer))
				iAimReference = ANIM_CROUCH_AIM_KNIFE;
			else
				iAimReference = ANIM_REF_AIM_KNIFE;
			
			//Play full animation
			if(iReference != iAimReference)		
				PlaySequence(iPlayer, iAimReference);

			//Loop idle animation
			set_pdata_int(iPlayer, m_fSequenceLoops, TRUE, CBASE_ANIMATION);
		}	
	}
	
	//Setup gait animation
	set_pev(iPlayer, pev_gaitsequence, iGaitSequence);		
}	
	
/*Attack animation not on ground. While falling down, anim returns pev_sequence always
running, so just let's force new animation over and stop it from looping back*/
public NonGroundAttackAnimation(iPlayer)
{			
	//Playtime start
	if(AttackAnimationStart(iPlayer))
	{
		//Attack animation
		if(g_skill_animation_time[iPlayer] > get_gametime())
			PlaySequence(iPlayer, ANIM_REF_SHOOT_KNIFE);	
						
		//Attack combo	
		else
			PlaySequence(iPlayer, ANIM_REF_SHOOT_COMBO);
					
		//Stop looping while falling down
		set_pdata_int(iPlayer, m_fSequenceLoops, FALSE, CBASE_ANIMATION);					
	}	
}

//Attack animation trigger	
public bool: AttackAnimationStart(iPlayer)
{
	if(g_skill_animation_time[iPlayer] > get_gametime() || g_combo_animation_time[iPlayer] > get_gametime())
		return true;
			
	return false;	
}
	
//Flinch animation trigger	
public bool: FlinchAnimationStart(iPlayer)
{
	if(g_flinch_animation_time[iPlayer] > get_gametime())
		return true;
			
	return false;	
}

//Setup sequence and reset animation state
public PlaySequence(iPlayer, iReference)
{	
	new Float: flGameTime, Float: flFrameRate, Float: flGroundSpeed;
		
	flGameTime = get_gametime();
        
	//Get attack/aim animations info
	if(AttackAnimationStart(iPlayer))
		lookup_sequence(iPlayer, "ref_shoot_knife", flFrameRate, _, flGroundSpeed);
	else
		lookup_sequence(iPlayer, "ref_aim_knife", flFrameRate, _, flGroundSpeed);

	set_pev(iPlayer, pev_frame, DEFAULT_FRAME);
	set_pev(iPlayer, pev_framerate, DEFAULT_FRAMERATE);
	set_pev(iPlayer, pev_animtime, flGameTime);
	set_pev(iPlayer, pev_sequence, iReference);	
		
	set_pdata_int(iPlayer, m_fSequenceFinished, NULL, CBASE_ANIMATION);	
	set_pdata_float(iPlayer, m_flFrameRate, flFrameRate, CBASE_ANIMATION);
	set_pdata_float(iPlayer, m_flGroundSpeed, flGroundSpeed, CBASE_ANIMATION);
	set_pdata_float(iPlayer, m_flLastEventCheck, flGameTime, CBASE_ANIMATION);
		
	set_pdata_float(iPlayer, m_flLastFired, flGameTime, CBASE_PLAYER);
}

#if defined USE_ANIMATION_BREAKER

	public Get_PlayerKeyboard(iPlayer)
	{
		//Get button
		#define PL_BUTTON pev(iPlayer, pev_button)
		
		#define BUTTON_MOVE_IN_FORWARD PL_BUTTON & IN_FORWARD
		#define BUTTON_MOVE_IN_BACK PL_BUTTON & IN_BACK
		#define BUTTON_MOVE_IN_SIDE (PL_BUTTON & IN_MOVELEFT || PL_BUTTON & IN_MOVERIGHT)
		
		//This models are not rotating (instant angle turn without blending) and moveleft/moveright is always forward
		#define FORWARD_MOVEMENT (BUTTON_MOVE_IN_FORWARD && !(BUTTON_MOVE_IN_SIDE || BUTTON_MOVE_IN_BACK))
		#define FORWARD_SIDE_MOVEMENT (BUTTON_MOVE_IN_FORWARD && BUTTON_MOVE_IN_SIDE && !(BUTTON_MOVE_IN_BACK))
		#define SIDE_MOVEMENT (BUTTON_MOVE_IN_SIDE && !(BUTTON_MOVE_IN_FORWARD || BUTTON_MOVE_IN_BACK))
		#define BACKWARD_SIDE_MOVEMENT (BUTTON_MOVE_IN_BACK && BUTTON_MOVE_IN_SIDE && !(BUTTON_MOVE_IN_FORWARD))
		#define BACKWARD_MOVEMENT (BUTTON_MOVE_IN_BACK && !(BUTTON_MOVE_IN_SIDE || BUTTON_MOVE_IN_FORWARD))

		#define MOVETYPE_FORWARD (FORWARD_MOVEMENT || SIDE_MOVEMENT || FORWARD_SIDE_MOVEMENT)
		#define MOVETYPE_BACKWARD (BACKWARD_MOVEMENT || BACKWARD_SIDE_MOVEMENT) 	
		
		//Forward/Moveleft/Moveright condition
		if(MOVETYPE_FORWARD)		
			iDirection_MoveForward[iPlayer] = true;	
			
		//Backward/Moveleft/Moveright condition
		if(MOVETYPE_BACKWARD)
			iDirection_MoveForward[iPlayer] = false;	
		
		//client_print(iPlayer, print_chat, "iDirection_MoveForward: %d", iDirection_MoveForward[iPlayer]);
	}

#endif