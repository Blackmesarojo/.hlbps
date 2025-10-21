//Left mouse button logic
public HamF_Weapon_PrimaryAttack_Post(iEnt)
{
	static iPlayer;
	iPlayer = get_pdata_cbase(iEnt, m_pPlayer, CBASE_WEAPON);
	
	switch(g_team[iPlayer])
	{
		//Mutant LMB attack
		case MUTANTS:
		{
			set_pdata_float(iEnt, m_flNextPrimaryAttack, MUTANT_SLASH_TIME, CBASE_WEAPON);
			set_pdata_float(iEnt, m_flNextSecondaryAttack, MUTANT_SLASH_TIME + MUTANT_ATTACK_TIME, CBASE_WEAPON);
			set_pdata_float(iEnt, m_flTimeWeaponIdle, MUTANT_SLASH_TIME, CBASE_WEAPON);	
			
			emit_sound(iPlayer, NULL, SND_MUTANT_HIT[random_num(0, 1)], 1.0, ATTN_NORM, NULL, PITCH_NORM);			
		}

		//Ghostblade LMB attack
		case GHOSTBLADE:
		{
			//Play default sound state
			if(g_defence_finished[iPlayer])
			{
				//Default delay	between attacks
				KnightBladeSwitchTime[iPlayer] = get_gametime() + KNIGHT_SWORD_SLASH_TIME;	
		
				emit_sound(iPlayer, NULL, SND_GHOSTBLADE_HIT[random_num(0, 1)], 1.0, ATTN_NORM, NULL, PITCH_NORM);
			}

			//Ghostblade is using LMB
			if(g_blade_skill[iPlayer])
			{
				//Retreat, play skillcallback anim
				if(!g_defence_finished[iPlayer])
				{
					ExecuteHam(Ham_CS_Weapon_SendWeaponAnim, iEnt, GHOSTBLADE_DEFENCE_FINISH, NULL);
					
					//Released
					g_defence_finished[iPlayer] = true;
				
					set_pdata_float(iEnt, m_flNextPrimaryAttack, GHOSTBLADE_DEFENCE_SLASH_TIME, CBASE_WEAPON);
					set_pdata_float(iEnt, m_flNextSecondaryAttack, GHOSTBLADE_DEFENCE_STAB_TIME, CBASE_WEAPON);
					set_pdata_float(iEnt, m_flTimeWeaponIdle, GHOSTBLADE_DEFENCE_FINISH_TIME, CBASE_WEAPON);

					//Play animation fully
					KnightBladeSwitchTime[iPlayer] = get_gametime() + KNIGHT_SWORD_TRANSFORM_TIME;					
			
					return;
				}
			
				ExecuteHam(Ham_CS_Weapon_SendWeaponAnim, iEnt, GHOSTBLADE_COMBO_1A_ANIM, NULL);
				
				set_pdata_float(iEnt, m_flNextPrimaryAttack, GHOSTBLADE_COMBO_TIME, CBASE_WEAPON);
				set_pdata_float(iEnt, m_flNextSecondaryAttack, GHOSTBLADE_COMBO_TIME, CBASE_WEAPON);
				set_pdata_float(iEnt, m_flTimeWeaponIdle, GHOSTBLADE_COMBO_TIME, CBASE_WEAPON);
			
				return;				
			}
			
			//Randomize
			if(g_instant_damage[iPlayer])
				InstantKill(iPlayer, iEnt);
			
			//Default attack	
			else
			{
				//Ordinal LMB attack
				set_pdata_float(iEnt, m_flNextPrimaryAttack, GHOSTBLADE_SLASH_TIME, CBASE_WEAPON);
			
				//Set delay on next RMB
				set_pdata_float(iEnt, m_flNextSecondaryAttack, GHOSTBLADE_SLASH_TIME + GHOSTBLADE_ATTACK_TIME, CBASE_WEAPON);			
				set_pdata_float(iEnt, m_flTimeWeaponIdle, GHOSTBLADE_SLASH_TIME, CBASE_WEAPON);
			}

			return;	
		}

		//Terminator LMB attack
		case TERMINATOR:
		{
			set_pdata_float(iEnt, m_flNextPrimaryAttack, TERMINATOR_SLASH_TIME, CBASE_WEAPON);
			set_pdata_float(iEnt, m_flNextSecondaryAttack, TERMINATOR_SLASH_TIME + TERMINATOR_ATTACK_TIME, CBASE_WEAPON);
			set_pdata_float(iEnt, m_flTimeWeaponIdle, TERMINATOR_SLASH_TIME, CBASE_WEAPON);			
			
			emit_sound(iPlayer, NULL, SND_TERMINATOR_HIT[random_num(0, 1)], 1.0, ATTN_NORM, NULL, PITCH_NORM);			
		}
	}
}

//Player animation
public HamF_Weapon_PrimaryAttack(iEnt)
{	
	static iPlayer;
	iPlayer = get_pdata_cbase(iEnt, m_pPlayer, CBASE_WEAPON);
	
	switch(g_team[iPlayer])
	{		
		//Ghostblade animation
		case GHOSTBLADE:
		{
			//No attack if sword in transform state
			if(!g_defence_finished[iPlayer])
				return HAM_SUPERCEDE;	
		
			g_skill_animation_time[iPlayer] = get_gametime() + KNIGHT_ANIMATION_PLAYTIME;		
		}
		
		//Mutant animation
		case MUTANTS: g_skill_animation_time[iPlayer] = get_gametime() + MUTANT_ANIMATION_PLAYTIME;				
			
		//Terminator animation
		case TERMINATOR: g_skill_animation_time[iPlayer] = get_gametime() + TERMINATOR_ANIMATION_PLAYTIME;
	}		

	return HAM_IGNORED;	
}

//Right mouse button logic
public HamF_Weapon_SecondaryAttack_Post(iEnt)
{
	static iPlayer;
	iPlayer = get_pdata_cbase(iEnt, m_pPlayer, CBASE_WEAPON);	
	
	switch(g_team[iPlayer])
	{		
		//Mutant RMB attack
		case MUTANTS:
		{
			set_pdata_float(iEnt, m_flNextPrimaryAttack, MUTANT_STAB_TIME + MUTANT_ATTACK_TIME, CBASE_WEAPON);
			set_pdata_float(iEnt, m_flNextSecondaryAttack, MUTANT_STAB_TIME, CBASE_WEAPON);
			set_pdata_float(iEnt, m_flTimeWeaponIdle, MUTANT_STAB_TIME, CBASE_WEAPON);
			
			emit_sound(iPlayer, NULL, SND_MUTANT_HIT[2], 1.0, ATTN_NORM, NULL, PITCH_NORM);
		}
		
		//Ghostblade RMB attack
		case GHOSTBLADE:
		{		
			//Ghostblade defence block
			if(g_blade_skill[iPlayer])
			{			
				//Play transformation anim
				if(g_defence_finished[iPlayer])
				{
					ExecuteHam(Ham_CS_Weapon_SendWeaponAnim, iEnt, GHOSTBLADE_DEFENCE_START, NULL);
					
					//Started
					g_defence_finished[iPlayer] = false;
				}

				//Play holding anim	
				else
					ExecuteHam(Ham_CS_Weapon_SendWeaponAnim, iEnt, GHOSTBLADE_DEFENCE_ANIM, NULL);
				
				set_pdata_float(iEnt, m_flNextPrimaryAttack, GHOSTBLADE_DEFENCE_SLASH_TIME, CBASE_WEAPON);
				set_pdata_float(iEnt, m_flNextSecondaryAttack, GHOSTBLADE_DEFENCE_STAB_TIME, CBASE_WEAPON);
				set_pdata_float(iEnt, m_flTimeWeaponIdle, GHOSTBLADE_DEFENCE_FINISH_TIME, CBASE_WEAPON);

				//Play animation fully
				KnightBladeSwitchTime[iPlayer] = get_gametime() + KNIGHT_SWORD_TRANSFORM_TIME;

				//Sphere submodel
				set_pev(iPlayer, pev_body, 1);
				
				//SetRendering(iPlayer, kRenderFxGlowShell, 135, 145, 255, kRenderNormal, NULL);
			
				return;
			}
			
			//Play animation default
			KnightBladeSwitchTime[iPlayer] = get_gametime() + KNIGHT_SWORD_STAB_TIME;

			//Randomize
			if(g_instant_damage[iPlayer])
				InstantKill(iPlayer, iEnt);	
	
			//Default attack
			else
			{
				//Set delay on next LMB
				set_pdata_float(iEnt, m_flNextPrimaryAttack, GHOSTBLADE_STAB_TIME + GHOSTBLADE_ATTACK_TIME, CBASE_WEAPON);
				set_pdata_float(iEnt, m_flNextSecondaryAttack, GHOSTBLADE_STAB_TIME, CBASE_WEAPON);
				set_pdata_float(iEnt, m_flTimeWeaponIdle, GHOSTBLADE_STAB_TIME, CBASE_WEAPON);				
			}
			
			emit_sound(iPlayer, NULL, SND_GHOSTBLADE_HIT[2], 1.0, ATTN_NORM, NULL, PITCH_NORM);

			return;	
		}
		
		//Terminator RMB attack
		case TERMINATOR:
		{
			set_pdata_float(iEnt, m_flNextPrimaryAttack, TERMINATOR_STAB_TIME + TERMINATOR_ATTACK_TIME, CBASE_WEAPON);
			set_pdata_float(iEnt, m_flNextSecondaryAttack, TERMINATOR_STAB_TIME, CBASE_WEAPON);
			set_pdata_float(iEnt, m_flTimeWeaponIdle, TERMINATOR_STAB_TIME, CBASE_WEAPON);
			
			emit_sound(iPlayer, NULL, SND_TERMINATOR_HIT[2], 1.0, ATTN_NORM, NULL, PITCH_NORM);
		}	
	}
}

//Set instant random kill
public InstantKill(iPlayer, iEnt)
{
	//Send animation
	ExecuteHam(Ham_CS_Weapon_SendWeaponAnim, iEnt, GHOSTBLADE_BTLBIGSHOT_1, NULL);
	set_pdata_float(iEnt, m_flNextPrimaryAttack, GHOSTBLADE_INSTANT_KILL_RECHARGE, CBASE_WEAPON);
			
	//Set delay on next RMB
	set_pdata_float(iEnt, m_flNextSecondaryAttack, GHOSTBLADE_INSTANT_KILL_RECHARGE + GHOSTBLADE_ATTACK_TIME, CBASE_WEAPON);			
	set_pdata_float(iEnt, m_flTimeWeaponIdle, GHOSTBLADE_INSTANT_KILL_RECHARGE, CBASE_WEAPON);

	//Reset status
	g_marked_to_death[iPlayer] = false;
	g_instant_damage[iPlayer] = false;
	
	//Set delay to make skill switch available again
	KnightBladeSwitchTime[iPlayer] = get_gametime() + GHOSTBLADE_INSTANT_KILL_RECHARGE;
	
	//Draw effect
	Player_ScreenFade(iPlayer);
}

//Player animation
public HamF_Weapon_SecondaryAttack(iEnt)
{
	static iPlayer;
	iPlayer = get_pdata_cbase(iEnt, m_pPlayer, CBASE_WEAPON);
	
	switch(g_team[iPlayer])
	{	
		//Ghostblade defence block
		case GHOSTBLADE:
		{			
			//Ghostblade defence block
			if(g_blade_skill[iPlayer])		
				return HAM_SUPERCEDE;	
			
			g_skill_animation_time[iPlayer] = get_gametime() + KNIGHT_ANIMATION_PLAYTIME;			
		}
		
		//Mutant animation
		case MUTANTS: g_combo_animation_time[iPlayer] = get_gametime() + MUTANT_ANIMATION_PLAYTIME;		
		
		//Terminator animation
		case TERMINATOR: g_combo_animation_time[iPlayer] = get_gametime() + TERMINATOR_ANIMATION_PLAYTIME;		
	}	

	return HAM_IGNORED;
}

//Class viewmodels
public HamF_ViewmodelDeploy_Post(iEnt)
{
	static iPlayer;
	iPlayer = get_pdata_cbase(iEnt, m_pPlayer, CBASE_WEAPON);
	
	switch(g_team[iPlayer])
	{
		//Set only once for soldiers
		case SOLDIERS:
		{
			if(g_soldier_deploy[iPlayer])
			{
				SetPlayerViewmodel(iPlayer, MDL_SOLDIER_KNIFE_V, MDL_SOLDIER_KNIFE_P);
				g_soldier_deploy[iPlayer] = false;
			}
		}	
	
		//Setup hand model for mutant
		case MUTANTS:
		{		
			switch(g_mutant_level[iPlayer])
			{		
				case 2, 3: SetPlayerViewmodel(iPlayer, MDL_MUTANT_EVO_HAND, "");
			
				default: SetPlayerViewmodel(iPlayer, MDL_MUTANT_HAND, "");	
			}
			
			SetupViewEntity(iPlayer, iEnt, DEFAULT_IDLE_TIME);

			//Non existent animation on model change?
			ForceAnim_KnifeExtention(iPlayer);	
		}

		//Setup hand model for ghostblade
		case GHOSTBLADE:
		{		
			SetPlayerViewmodel(iPlayer, MDL_GHOSTBLADE_HAND, "");
			SetupViewEntity(iPlayer, iEnt, DEFAULT_IDLE_TIME);
			
			ForceAnim_KnifeExtention(iPlayer);			
		}	
				
		//Setup hand model for terminator
		case TERMINATOR:
		{		
			SetPlayerViewmodel(iPlayer, MDL_TERMINATOR_HAND, "");
			SetupViewEntity(iPlayer, iEnt, DEFAULT_IDLE_TIME + DEFAULT_IDLE_TIME/2);
			
			ForceAnim_KnifeExtention(iPlayer);			
		}
	}	
}

//Idle animation for ghostblade viewmodel
public HamF_Weapon_WeaponIdle(iEnt)
{
	#define NULL_VALUE 0.0

	static iPlayer;
	iPlayer = get_pdata_cbase(iEnt, m_pPlayer, CBASE_WEAPON);

	//Set idle animation for sword
	if(is_ghostblade(iPlayer))
	{		
		new Float: flTimeWeaponIdle = get_pdata_float(iEnt, m_flTimeWeaponIdle, CBASE_WEAPON);
		
		if(flTimeWeaponIdle > NULL_VALUE)
			return HAM_IGNORED;		
		
		if(g_blade_skill[iPlayer])
		{		
			static iButton;
			iButton = pev(iPlayer, pev_button);
			
			//Set only if Defence is not activated
			if(!(iButton & IN_ATTACK2))
			{
				//Not defending anymore, play reverse animation
				if(!g_defence_finished[iPlayer])
				{
					if(flTimeWeaponIdle < NULL_VALUE)
					{
						ExecuteHam(Ham_CS_Weapon_SendWeaponAnim, iEnt, GHOSTBLADE_DEFENCE_FINISH, NULL);
					
						set_pdata_float(iEnt, m_flNextPrimaryAttack, GHOSTBLADE_SWORD_FINISH_TIME, CBASE_WEAPON);
						set_pdata_float(iEnt, m_flNextSecondaryAttack, GHOSTBLADE_SWORD_FINISH_TIME, CBASE_WEAPON);
						set_pdata_float(iEnt, m_flTimeWeaponIdle, GHOSTBLADE_SWORD_FINISH_TIME, CBASE_WEAPON);
						
						//Reset state trigger on next idle
						g_defence_finished[iPlayer] = true;

						//Normal submodel
						set_pev(iPlayer, pev_body, NULL);

						//Set glow fx
						//SetRendering(iPlayer, kRenderFxHologram, NULL, NULL, NULL, kRenderNormal, NULL);						
					}
				}
				
				//Play now idle animation
				else
				{					
					ExecuteHam(Ham_CS_Weapon_SendWeaponAnim, iEnt, GHOSTBLADE_SKILL_IDLE_ANIM, NULL);
				
					set_pdata_float(iEnt, m_flTimeWeaponIdle, GHOSTBLADE_SKILL_IDLE_TIME, CBASE_WEAPON);				
				}
			}
				
			return HAM_IGNORED;		
		}		
	}
	
	return HAM_IGNORED;
}

//Apply on post
public HamF_PlayerSpawn_Post(iPlayer)
{	
	if(is_soldier(iPlayer))
		Setup_Soldier(iPlayer);
}

//Move everyone to Soldiers
public HamF_PlayerSpawn(iPlayer)
{	
	if(is_soldier(iPlayer))
		set_pdata_int(iPlayer, m_iTeam, TEAM_CT, CBASE_PLAYER);		
	
	//Restart game, if second player connected
	if(g_player_amount >= PLAYERS_GAME_START && !g_game_lock)
	{
		//Call this only once	
		TerminateRound(RoundEndType_Draw);
		g_game_lock = true;
	}	
	
	return HAM_IGNORED;
}

//Modifications
public HamF_TakeDamage_Post(iVictim, Inflictor, iAttacker, Float: Damage, Damage_Type)
{
	#define VELOCITY_VALUE 1.0
	
	//Painshock for ghostblades or monsters
	if(is_user_alive(iVictim))
		set_pdata_float(iVictim, m_flVelocityModifier, VELOCITY_VALUE, CBASE_PLAYER);	
	
	if(pev_valid(iVictim) && pev_valid(iAttacker) == PDATA_SAFE)
	{
		if(get_pdata_int(iVictim, m_iTeam, CBASE_PLAYER) != get_pdata_int(iAttacker, m_iTeam, CBASE_PLAYER))
		{
			//Play flinch when hit for mutants
			if(is_mutant(iVictim))
				g_flinch_animation_time[iVictim] = get_gametime() + FLINCH_ANIMATION_PLAYTIME;
		
			//Turn off knockback for monsters
			if(is_mutant(iVictim) || is_terminator(iVictim))				
				Disable_PlayerKnockBack(iVictim);
		}		
	}	
}

//Damage setup
public HamF_TakeDamage(iVictim, Inflictor, iAttacker, Float: Damage, Damage_Type)
{
	#define HAMSANDWICH_PARAM 4

	//Allow only at specific round status
	if(g_round_status != ROUNDSTATUS_START && g_round_status != ROUNDSTATUS_GHOSTBLADE) 
		return HAM_SUPERCEDE;
		
	//Not apply against self
	if(iVictim == iAttacker) 
		return HAM_SUPERCEDE;

	//Throwed he right after transforming into mutant before explosion (no damage against CT's)
	if(pev_valid(iVictim) && pev_valid(iAttacker) == PDATA_SAFE)
	{	
		if(get_pdata_int(iVictim, m_iTeam, CBASE_PLAYER) == TEAM_CT && Damage_Type == DMG_GRENADE)
			return HAM_SUPERCEDE;			
	}		

	//Damage given from specific events
	switch(Damage_Type)
	{
		//No fall damage
		case DMG_FALL: return HAM_SUPERCEDE;
		
		//Grenades shouldn't kill with 1 hit
		case DMG_GRENADE:
		{
			Damage = Damage + (Damage * random_num(5, 10));
			
			SetHamParamFloat(HAMSANDWICH_PARAM, Damage);
		}	
		//case DMG_GRENADE: return HAM_IGNORED;
	}	

	//Safe
	if(!is_user_connected(iVictim) || !is_user_connected(iAttacker)) 
		return HAM_IGNORED;
		
	//Get knockback info
	if(is_mutant(iVictim) || is_terminator(iVictim))
		pev(iVictim, pev_velocity, g_PlayerKnockback[iVictim]);		
	
	//Count our victims
	switch(g_team[iVictim])
	{		
		case SOLDIERS:
		{
			switch(g_team[iAttacker])
			{
				//Mutant/Terminator hits Soldier
				case MUTANTS, TERMINATOR:
				{
					//Transform to mutant!
					Mutant_HitSoldier(iAttacker, iVictim);
			
					return HAM_SUPERCEDE;
				}
			}		
		}

		//Victim is Ghostblade
		case GHOSTBLADE:
		{
			//Getting hit	
			static iButton;
			iButton = pev(iVictim, pev_button);
			
			//Ghostblade uses his Defence skill and can be hit only from behind
			if(g_blade_skill[iVictim] && (iButton & IN_ATTACK2) && EnemyIsOnViewOfs(iAttacker, iVictim))
			{
				//Safe condition
				if(pev_valid(iVictim) != PDATA_SAFE || !is_user_alive(iVictim))
					return HAM_IGNORED;
	
				static iWeapon, iId;
	
				iWeapon = get_pdata_cbase(iVictim, m_pActiveItem, CBASE_PLAYER);
				
				if(iWeapon != NULLENT)
				{
					iId = get_pdata_int(iWeapon, m_iId, CBASE_WEAPON);

					//Wait for animation trigger
					if(iId == CSW_KNIFE && !g_defence_finished[iVictim])
					{		
						ExecuteHam(Ham_CS_Weapon_SendWeaponAnim, iWeapon, GHOSTBLADE_DEFENCE_HIT_ANIM, NULL);
				
						//Set delay
						set_pdata_float(iWeapon, m_flNextPrimaryAttack, GHOSTBLADE_DEFENCE_SLASH_TIME, CBASE_WEAPON);
						set_pdata_float(iWeapon, m_flNextSecondaryAttack, GHOSTBLADE_DEFENCE_STAB_TIME, CBASE_WEAPON);
						set_pdata_float(iWeapon, m_flTimeWeaponIdle, GHOSTBLADE_DEFENCE_HIT_TIME, CBASE_WEAPON);
					}
				}	
			
				emit_sound(iVictim, NULL, SND_GHOSTBLADE_DEFENCE, 1.0, ATTN_NORM, NULL, PITCH_NORM);
				
				return HAM_SUPERCEDE;
			}
		
			//Hit is passed, now count Attackers	
			else
			{
				switch(g_team[iAttacker])
				{
					//Terminator hit
					case TERMINATOR:
					{
						Damage = Damage + (Damage * TERMINATOR_DAMAGE);
						SetHamParamFloat(HAMSANDWICH_PARAM, Damage)
				
						#if defined DEBUG_INFO

							client_print(iAttacker, print_chat, "Terminator Damage: %d", floatround(Damage, floatround_round));

						#endif
					}

					//Mutant hit
					case MUTANTS:
					{
						//Mutate, if not mutated yet
						if(g_hit_count[iAttacker] > MUTANT_HIT_TRANSFORM - 1)
						{	
							Mutation_LevelUp(iAttacker);
							g_hit_count[iAttacker] = NULL;
						}	
				
						//Damage, depended on mutant level
						switch(g_mutant_level[iAttacker])
						{
							//Peace of cake...
							case 1: Damage = Damage + (Damage * LEVEL_ONE_NANO_DAMAGE);				
							case 2, 3: Damage = Damage + (Damage * LEVEL_MAX_NANO_DAMAGE);
							
							default: Damage = Damage + (Damage * LEVEL_ONE_NANO_DAMAGE)/2;	
						}				
			
						SetHamParamFloat(HAMSANDWICH_PARAM, Damage);
				
						#if defined DEBUG_INFO

							client_print(iAttacker, print_chat, "Mutant Damage: %d", floatround(Damage, floatround_round));

						#endif

						//Count attacks and reset to evolve
						g_hit_count[iAttacker] += 1;
					}	
				}

				//UI_SPECIALKILL2
				if(Damage >= MUTANT_MAX_HITSOUND)
					PlaySound(iAttacker, SND_DAMAGE);	
			}	
		}
		
		//Victims is mutants and terminators
		case MUTANTS, TERMINATOR:
		{		
			//Start blink
			new Float: iHealth, Float: iMaxHealth;
			pev(iVictim, pev_health, iHealth);
			pev(iVictim, pev_max_health, iMaxHealth);
			
			if(iHealth < iMaxHealth / 1.5)
			{
				#define TIMER_BODY 0.1
			
				if(!g_damage_set[iVictim])
				{	
					remove_task(iVictim + TASK_BODY);
					set_task(TIMER_BODY, "Task_SetBlink", iVictim + TASK_BODY);
					
					g_damage_set[iVictim] = true;
				}
			}		
			
			//Attackers
			switch(g_team[iAttacker])
			{
				//Soldier attacks mutant/terminator
				case SOLDIERS:
				{
					switch(g_level_stage)
					{
						case 1: Damage = Damage + (Damage * LEVEL_ONE_DAMAGE);				
						case 2: Damage = Damage + (Damage * LEVEL_MAX_DAMAGE);
						
						default: Damage = Damage + (Damage * LEVEL_ONE_DAMAGE)/2;
					}	

					SetHamParamFloat(HAMSANDWICH_PARAM, Damage);		

					#if defined DEBUG_INFO

						client_print(iAttacker, print_chat, "Soldier Damage: %d", floatround(Damage, floatround_round));

					#endif
					
				}

				//Ghostblade attacks mutant/terminator
				case GHOSTBLADE:
				{
					#define FATAL_BLOW 32786 
				
					//Check, is not in skill ready stance
					if(!g_blade_skill[iAttacker])
					{
						new iRandom;
						iRandom = random_num(0, 1);
					
						//Try to randomize hit
						switch(iRandom)
						{
							case 0: g_marked_to_death[iAttacker] = true;
							case 1: g_marked_to_death[iAttacker] = false;
						}
					
						//Only try to kill victim instantly at half of hp - 1
						if((iHealth < iMaxHealth / 2) && g_marked_to_death[iAttacker])
							g_instant_damage[iAttacker] = true;
							
						//Apply	
						if(g_instant_damage[iAttacker])
							Damage = Damage + (Damage * GHOSTBLADE_DAMAGE * FATAL_BLOW);
						else	
							Damage = Damage + (Damage * GHOSTBLADE_DAMAGE);							
					}
					
					//Default stance
					else
						Damage = Damage + (Damage * GHOSTBLADE_DAMAGE);
				
					SetHamParamFloat(HAMSANDWICH_PARAM, Damage);						
		
					//UI_SPECIALKILL2
					if(Damage >= GHOSTBLADE_MAX_HITSOUND)
						PlaySound(iAttacker, SND_DAMAGE);		

					#if defined DEBUG_INFO

						client_print(iAttacker, print_chat, "Ghostblade Damage: %d", floatround(Damage, floatround_round));

					#endif

				}
			}				
		}	
	}
	
	return HAM_IGNORED;
}

//Gameplay stats
public HamF_Killed_Post(iVictim, iKiller, Gib)
{
	//Safe
	if(!is_user_connected(iVictim) || !is_user_connected(iKiller)) 
		return;
		
	switch(g_team[iKiller])
	{
		//Set scores for soldiers and ghostblades
		case SOLDIERS, GHOSTBLADE: Update_TeamScores(g_mercenary_score += 2, "CT");
		
		//Smashed by armored terminator or mutant
		default: Update_TeamScores(g_mutant_score += 2, "TERRORIST");
	}
	
	switch(g_round_status)
	{
		//Respawn mutants till Ghostblade appear
		case ROUNDSTATUS_START:
		{
			#define RESPAWN_TIMER 1.0
		
			if(is_mutant(iVictim))
			{
				remove_task(iVictim + TASK_MUTANT_RESPAWN);	
				set_task(RESPAWN_TIMER, "Task_MutantRespawn", iVictim + TASK_MUTANT_RESPAWN);
			}
			
			#if defined DEBUG_INFO
			
				//Not happens normally (debug only)
				if(is_ghostblade(iVictim))
					RoundCheck_CallbackWin_Mutants();
			#endif				
		}

		//Win conditions after Ghostblade transform
		case ROUNDSTATUS_GHOSTBLADE:
		{
			//Specific condition
			if(iVictim != iKiller)
			{
				RoundCheck_CallbackWin_Mutants();	
				RoundCheck_CallbackWin_Soldiers();
				
				//Killed
				if(is_mutant(iVictim) || is_terminator(iVictim))
					PlaySound(iKiller, SND_NANO_REMOVED);

				//Try to levelup by killing Knight
				if(is_ghostblade(iVictim) && is_mutant(iKiller))
				{
					Mutation_LevelUp(iKiller);

					#if defined DEBUG_INFO

						client_print(SEND_ALL, print_chat, "Player %s leveled up to: %d", GetPlayerName(iKiller), g_mutant_level[iKiller]);

					#endif

				}		
			}		
		}
	}
	
	#if defined DEBUG_INFO
	
		client_print(SEND_ALL, print_chat, "HamF_Killed_Post: %s died", GetPlayerName(iVictim));
		
	#endif
	
	/*Terminator dead, move it to mutant team and respawn if
	round status is not Ghostblade*/
	if(is_terminator(iVictim))
	{
		//Set level to 3
		g_mutant_level[iVictim] = 3;
		g_team[iVictim] = MUTANTS;
		
		Remove_EntityByOwner(iVictim, XENO_CLASSNAME);
	}	
	
	//Killed Ghostblade
	if(is_ghostblade(iVictim))
	{
		set_pev(iVictim, pev_body, NULL);
		Remove_EntityByOwner(iVictim, KNIGHT_CLASSNAME);
	}
	
	//Remove hearbeat task
	remove_task(iVictim + TASK_HEARBEAT_SENSOR);

	//Clear attributes, because it's dead
	g_transform_gear[iVictim] = false;

	//Bonuses
	Update_PlayerScoreboard(iKiller, 1, false);	
}

//Set for both factions
public HamF_BloodColor(iPlayer)
{
	if(!is_user_connected(iPlayer))
		return HAM_IGNORED;
		
	//Specific round condition	
	if(g_round_status == ROUNDSTATUS_END) 
	{
		SetHamReturnInteger(-1);
		
		return HAM_SUPERCEDE;
	}		
		
	switch(g_team[iPlayer])
	{
		
		#if defined GREEN_BLOOD_COLOR
		
			case MUTANTS, TERMINATOR: SetHamReturnInteger(BLOOD_COLOR_GREEN);
			
		#else
			
			case MUTANTS, TERMINATOR: SetHamReturnInteger(BLOOD_COLOR_RED);
			
		#endif
				
		case GHOSTBLADE:
		{
			static iButton;
			iButton = pev(iPlayer, pev_button);
			
			//Is defending
			if(g_blade_skill[iPlayer] && (iButton & IN_ATTACK2))
				SetHamReturnInteger(-1);
					
			//Blood now	
			else
				SetHamReturnInteger(BLOOD_COLOR_RED);			
		}		
			
		//Soldiers
		default: SetHamReturnInteger(-1);
	}
		
	return HAM_SUPERCEDE;
}

//No trace against friends
public HamF_TraceAttack(iVictim, iAttacker, Float: Damage, Float: vecDir[3], iPtr, Damage_Type)
{
	//Safe
	if(!is_user_connected(iVictim) || !is_user_connected(iAttacker)) 
		return HAM_IGNORED;
		
	//Block teamattack
	if(pev_valid(iVictim) && pev_valid(iAttacker) == PDATA_SAFE)
	{
		if(get_pdata_int(iVictim, m_iTeam, CBASE_PLAYER) == get_pdata_int(iAttacker, m_iTeam, CBASE_PLAYER))
			return HAM_SUPERCEDE;			
	}		

	return HAM_IGNORED;
}

//No armoury for mutations
public HamF_TouchWeaponBox(iWeaponBox, iPlayer)
{
	if(!is_user_connected(iPlayer)) 
		return HAM_IGNORED;
	
	//Prevent mutants/ghostblades/armored terminators from picking up armory
	if(is_mutant(iPlayer) || is_ghostblade(iPlayer) || is_terminator(iPlayer))
		return HAM_SUPERCEDE;

	#if defined USE_SPECIAL_CHARACTER
	
		//Can't pickup not allowed weapons
		if(player_fox_seaside(iPlayer) || is_soldier(iPlayer))
		{
			//Get a touch classname
			static iClassname[22];	
			pev(iWeaponBox, pev_classname, iClassname, charsmax(iClassname));

			//Is a weapon entity?
			if(equal(iClassname, "weaponbox"))
			{			
				new iCWBox_Entity;
			
				//Get CSW_ index
				iCWBox_Entity = Get_CS_WeaponIndex(iWeaponBox);
			
				//Allow to pickup only class weapons
				if(player_fox_seaside(iPlayer))
				{
					#define RESTRICTED_ARMOURY (iCWBox_Entity != CSW_ELITE && iCWBox_Entity != CSW_AK47 && iCWBox_Entity != CSW_MP5NAVY && iCWBox_Entity != CSW_KNIFE)
				
					if(RESTRICTED_ARMOURY)
						return HAM_SUPERCEDE;
				}
			
				//Soldier can't pickup shieldgun/smoke/flash
				else
				{
					if(iCWBox_Entity == CSW_SHIELDGUN && iCWBox_Entity == CSW_FLASHBANG && iCWBox_Entity == CSW_SMOKEGRENADE)
						return HAM_SUPERCEDE;
				}	

				#if defined DEBUG_INFO
					
					//Print CSW_ id's
					client_print(iPlayer, print_chat, "HamF_TouchWeaponBox: %d", iCWBox_Entity);
					
				#endif				
			}
		}
		
	#else

		//Can't pickup not allowed weapons
		if(is_soldier(iPlayer))
		{
			//Get a touch classname
			static iClassname[22];	
			pev(iWeaponBox, pev_classname, iClassname, charsmax(iClassname));

			//Is a weapon entity?
			if(equal(iClassname, "weaponbox"))
			{			
				new iCWBox_Entity;
			
				//Get CSW_ index
				iCWBox_Entity = Get_CS_WeaponIndex(iWeaponBox);
			
				//Soldier can't pickup shieldgun/smoke/flash
				if(iCWBox_Entity == CSW_SHIELDGUN && iCWBox_Entity == CSW_FLASHBANG && iCWBox_Entity == CSW_SMOKEGRENADE)
					return HAM_SUPERCEDE;	

				#if defined DEBUG_INFO
					
					//Print CSW_ id's
					client_print(iPlayer, print_chat, "HamF_TouchWeaponBox: %d", iCWBox_Entity);
					
				#endif				
			}
		}

	#endif
	
	return HAM_IGNORED;
}

//Supplybox pickup
public HamF_TouchSupplyBox(iSupplybox, iPlayer)
{
	if(!is_user_connected(iPlayer))
		return HAM_IGNORED;
		
	//Allow collect after mutant appear
	if(g_round_status != ROUNDSTATUS_START && g_round_status != ROUNDSTATUS_GHOSTBLADE)
		return HAM_IGNORED;		
	
	//Ignore boss and soldiers	
	if(is_ghostblade(iPlayer) || is_terminator(iPlayer))
		return HAM_IGNORED;
	
	static iClassname[32];
	pev(iSupplybox, pev_classname, iClassname, charsmax(iClassname));

	//Not a supplybox
	if(!equal(iClassname, "supplybox_nano"))
		return HAM_IGNORED;
	
	//Levelup mutants
	if(is_mutant(iPlayer))
		Mutation_LevelUp(iPlayer);
	
	//Soldier pickup	
	if(is_soldier(iPlayer))		
		Soldier_Supply(iPlayer);	
	
	engfunc(EngFunc_RemoveEntity, iSupplybox);
	
	//Sound
	emit_sound(iPlayer, NULL, SND_SUPPLYBOX_PICKUP, 1.0, ATTN_NORM, NULL, PITCH_NORM);
	
	return HAM_SUPERCEDE;
}