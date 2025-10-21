//Class ability
public class_skill(iPlayer)
{
	//Safe condition
	if(pev_valid(iPlayer) != PDATA_SAFE || !is_user_alive(iPlayer))
		return;

	switch(g_team[iPlayer])
	{
		//Ghostblade normal/battle form
		case GHOSTBLADE:
		{
			static iEnt;
			iEnt = get_pdata_cbase(iPlayer, m_pActiveItem, CBASE_PLAYER);	
			
			//Holding button	
			if(pev(iPlayer, pev_button) & IN_ATTACK || pev(iPlayer, pev_button) & IN_ATTACK2)
				return;

			//Return, if not ready yet
			if(KnightBladeSwitchTime[iPlayer] > get_gametime())
				return;

			//Set
			g_blade_skill[iPlayer] = !g_blade_skill[iPlayer];		
		
			switch(g_blade_skill[iPlayer])
			{
				//Normal mode
				case false:
				{
					ExecuteHam(Ham_CS_Weapon_SendWeaponAnim, iEnt, GHOSTBLADE_SWORD_SWITCH_1A, NULL);
					PlaySound(iPlayer, SND_GHOSTBLADE_CHANGE02);

					//Normal speed
					set_pev(iPlayer, pev_maxspeed, GHOSTBLADE_SPEED);						
				}

				//Battle-form
				case true:
				{
					ExecuteHam(Ham_CS_Weapon_SendWeaponAnim, iEnt, GHOSTBLADE_SWORD_SWITCH_2B, NULL);
					PlaySound(iPlayer, SND_GHOSTBLADE_CHANGE01);

					//Battle-form speed
					set_pev(iPlayer, pev_maxspeed, GHOSTBLADE_BATTLE_SPEED);	
				}					
			}	
		
			#if defined DEBUG_INFO
			
				GetPlayerSpeed(iPlayer);
			
			#endif		
		
			//Set a pause between attack
			set_pdata_float(iEnt, m_flNextPrimaryAttack, GHOSTBLADE_SWORD_FINISH_TIME, CBASE_WEAPON);
			set_pdata_float(iEnt, m_flNextSecondaryAttack, GHOSTBLADE_SWORD_FINISH_TIME, CBASE_WEAPON);		
			set_pdata_float(iEnt, m_flTimeWeaponIdle, GHOSTBLADE_SWORD_FINISH_TIME, CBASE_WEAPON);
		
			//Set delay to make skill available again
			KnightBladeSwitchTime[iPlayer] = get_gametime() + KNIGHT_SWORD_SWITCH_TIME;
		}

		//Mutant speedup
		case MUTANTS:
		{
			#define MIN_LEVEL 1
		
			//If not upgraded or skill is on use
			if(g_mutant_skill[iPlayer] || g_mutant_level[iPlayer] < MIN_LEVEL)
			{
				#if defined DEBUG_INFO
		
					client_print(iPlayer, print_chat, "Not Available");
			
				#endif
	
				return;
			}	
		
			//Lock
			g_mutant_skill[iPlayer] = true;		
		
			//Play sound
			emit_sound(iPlayer, NULL, SND_MUTANT_SKILL, 1.0, ATTN_NORM, NULL, PITCH_NORM);
		
			//Set skill speed last
			set_pev(iPlayer, pev_maxspeed, MUTANT_SKILL_SPEED);

			//Set for 5 seconds
			remove_task(iPlayer + TASK_MUTANT_SKILL);
			set_task(MUTANT_SKILL_TIME, "Task_ResetMutantSkill", iPlayer + TASK_MUTANT_SKILL);

			#if defined DEBUG_INFO
			
				GetPlayerSpeed(iPlayer);
			
			#endif
		}
		
		case TERMINATOR:
		{
			#define TARGET_RADIUS 200.0
		
			if(g_terminator_skill[iPlayer])
				return;
				
			g_terminator_skill[iPlayer] = true;
			
			static iEnt;
			iEnt = get_pdata_cbase(iPlayer, m_pActiveItem, CBASE_PLAYER);

			//Play crying animation	
			ExecuteHam(Ham_CS_Weapon_SendWeaponAnim, iEnt, TERMINATOR_CRYING_ANIM, NULL);

			//Set a pause between attack
			set_pdata_float(iPlayer, m_flNextAttack, TERMINATOR_CRY_ANIM_TIME, CBASE_PLAYER);
			set_pdata_float(iEnt, m_flNextPrimaryAttack, TERMINATOR_CRY_ANIM_TIME, CBASE_WEAPON);
			set_pdata_float(iEnt, m_flNextSecondaryAttack, TERMINATOR_CRY_ANIM_TIME, CBASE_WEAPON);		
			set_pdata_float(iEnt, m_flTimeWeaponIdle, TERMINATOR_CRY_ANIM_TIME, CBASE_WEAPON);

			//Get position
			new Float: iOrigin[3];			
			pev(iPlayer, pev_origin, iOrigin);
				
			new pPlayer = NULLENT;
			
			//Drop their weapons
			while((pPlayer = engfunc(EngFunc_FindEntityInSphere, pPlayer, iOrigin, TARGET_RADIUS)) > NULL)
			{
				//Pass alive and soldiers only
				if(is_user_alive(pPlayer) && is_soldier(pPlayer))
				{
					static iEntityWeapon, iWeaponName[24];					
					iEntityWeapon = get_pdata_cbase(pPlayer, m_pActiveItem, CBASE_PLAYER);				
				
					//Get classname of the weapon they are holding
					pev(iEntityWeapon, pev_classname, iWeaponName, charsmax(iWeaponName));
					
					//Shouldn't be like that (or maybe client show message cannot be dropped?)
					new WeaponNames[][] = 
					{ 
						"weapon_knife", 
						"weapon_flashbang", 
						"weapon_hegrenade", 
						"weapon_smokegrenade" 
					}
					
					//Pass only for allowed classnames
					for(new iWeapon; iWeapon < sizeof WeaponNames; iWeapon ++)
					{
						//Send drop now
						if(!equal(iWeaponName, WeaponNames[iWeapon]))
							engclient_cmd(pPlayer, "drop", iWeaponName);
					}

					//For thos, who inside this area
					Player_ScreenShake(pPlayer);					
				}		
			}
			
			//For self
			Player_ScreenShake(iPlayer);			

			//Set invincible
			set_pev(iPlayer, pev_takedamage, DAMAGE_NO);
			
			//Sphere submodel
			set_pev(iPlayer, pev_body, 1);
			
			SetRendering(iPlayer, kRenderFxGlowShell, 135, 145, 255, kRenderNormal, NULL);
			
			emit_sound(iPlayer, NULL, SND_TERMINATOR_CRYING, 1.0, ATTN_NORM, NULL, PITCH_NORM);
			
			//Remove data
			new TASK_DATA[]= 
			{
				TASK_TERMINATOR_SKILL, 
				TASK_TERMINATOR_SKILL_RELOAD
			}

			for(new iData; iData < sizeof TASK_DATA; iData ++)		
				remove_task(iPlayer + TASK_DATA[iData]);

			set_task(TERMINATOR_SKILL_TIME, "Task_ResetTerminatorSkill", iPlayer + TASK_TERMINATOR_SKILL);	
			set_task(TERMINATOR_SKILL_RELOAD_TIME, "Task_TerminatorSkillReload", iPlayer + TASK_TERMINATOR_SKILL_RELOAD);			
		}
	}
}

//Vote and Terminator protection
public mutation_vote(iPlayer)
{
	//Safe condition
	if(!is_user_alive(iPlayer))
		return;

	//Allow to random vote for mutation
	if(is_soldier(iPlayer) || is_ghostblade(iPlayer))
	{		
		g_mutant_vote[iPlayer] = random_num(0, 1);
			
		#if defined DEBUG_INFO
		
			client_print(iPlayer, print_chat, "Player Mutation: %d", g_mutant_vote[iPlayer]);
			
		#endif
		
	}
}	