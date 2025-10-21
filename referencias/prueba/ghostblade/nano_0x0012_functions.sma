//Server setup
stock Setup_Multiplayer()
{	
	for(new i = NULL; i < sizeof Server_Commands; i ++)		
		server_cmd(Server_Commands[i]);
}

//Fix non existent animation on custom models.
stock ForceAnim_KnifeExtention(iPlayer)
{
	new iAnim;
	new iReference[64];

	//Is ducking?	
	if(pev(iPlayer, pev_flags) & FL_ONGROUND)
	{
		iAnim = ANIM_CROUCH_AIM_KNIFE;
		iReference = "crouch_aim_knife";
	}
	//Jump or stand	
	else
	{
		iAnim = ANIM_REF_AIM_KNIFE;
		iReference = "ref_aim_knife";
	}	
	
	//Set fake animation	
	PlaySequence(iPlayer, iAnim);
	
	//Set anim extention
	set_pdata_string(iPlayer, m_szAnimExtention * 4, iReference, -1, CBASE_PLAYER * CBASE_WEAPON);	
}	

//Set player model
stock set_player_model(iPlayer, const iModel[], iModelPath[128])
{
	if(pev_valid(iPlayer) != PDATA_SAFE)		
		return;

	copy(g_custom_player_model[iPlayer], charsmax(g_custom_player_model[]), iModel);
	
	static iCurrentModel[32];
	engfunc(EngFunc_InfoKeyValue, engfunc(EngFunc_GetInfoKeyBuffer, iPlayer), "model", iCurrentModel, charsmax(iCurrentModel));
	
	if(!equal(iCurrentModel, iModel))
	{
		engfunc(EngFunc_SetClientKeyValue, iPlayer, engfunc(EngFunc_GetInfoKeyBuffer, iPlayer), "model", g_custom_player_model[iPlayer]);	
	
		formatex(iModelPath, charsmax(iModelPath), "models/player/%s/%s.mdl", iModel, iModel);
	
		//Set modelindex
		set_pdata_int(iPlayer, m_modelIndexPlayer, engfunc(EngFunc_ModelIndex, iModelPath), CBASE_PLAYER);
	}	
}

//Reset player model
stock reset_player_model(iPlayer)
{
	if(pev_valid(iPlayer) != PDATA_SAFE)		
		return;

	copy(g_custom_player_model[iPlayer], charsmax(g_custom_player_model[]), "urban");
	engfunc(EngFunc_SetClientKeyValue, iPlayer, engfunc(EngFunc_GetInfoKeyBuffer, iPlayer), "model", g_custom_player_model[iPlayer]);
	
	//Reset to something default
	set_pdata_int(iPlayer, m_modelIndexPlayer, engfunc(EngFunc_ModelIndex, "models/player/urban/urban.mdl"), CBASE_PLAYER);
}

//Force deploy viewmodels
stock Execute_Ham_OnDeploy(iPlayer)
{
	if(pev_valid(iPlayer) != PDATA_SAFE || !is_user_alive(iPlayer))
		return;
	
	static iWeapon, iId;
	
	iWeapon = get_pdata_cbase(iPlayer, m_pActiveItem, CBASE_PLAYER);
	
	if(iWeapon != NULLENT)
	{
		iId = get_pdata_int(iWeapon, m_iId, CBASE_WEAPON);
		
		//Execute now
		if(iId > NULL)
			ExecuteHamB(Ham_Item_Deploy, iWeapon);
	}	
}

//While getting damage
stock Disable_PlayerKnockBack(iPlayer)
{
	#define VECTOR_SCALAR 0.0

	static Float: iVelocity[3];
	
	pev(iPlayer, pev_velocity, iVelocity);
		
	vector_sub(iVelocity, g_PlayerKnockback[iPlayer], iVelocity);
	vector_mul_scalar(iVelocity, VECTOR_SCALAR, iVelocity);
	vector_add(iVelocity, g_PlayerKnockback[iPlayer], iVelocity);
		
	set_pev(iPlayer, pev_velocity, iVelocity);
}

//Detect, if enemy is visible and let them hit us only from behind
//Ghostblade ability
stock bool: EnemyIsOnViewOfs(fovTarget, iPlayer) 
{
	new Float: iPlayerOrigin[3];
	pev(iPlayer, pev_origin, iPlayerOrigin);

	new Float: TargetOrigin[3];
	pev(fovTarget, pev_origin, TargetOrigin);

	new Float: iDirection[3];
	vector_sub(TargetOrigin, iPlayerOrigin, iDirection);
	vector_normalize(iDirection, iDirection);
	
	new Float: iPlayerAngles[3];
	pev(iPlayer, pev_angles, iPlayerAngles);

	new Float: ViewOfsDirection[3];
	angle_vector(iPlayerAngles, ANGLEVECTOR_FORWARD, ViewOfsDirection);
	vector_normalize(ViewOfsDirection, ViewOfsDirection);
	
	new Float: iDot = vector_dot(iDirection, ViewOfsDirection);

	if(iDot > NULL)
		return true;
	
	return false;	
}

stock Float: call_rsqrt(Float: x)
	return 1.0 / floatsqroot(x);

stock vector_sub(const Float: in1[], const Float: in2[], Float: out[])
{
	out[0] = in1[0] - in2[0];
	out[1] = in1[1] - in2[1];
	out[2] = in1[2] - in2[2];
}

stock vector_mul_scalar(const Float:vec[], Float:scalar, Float:out[])
{
	out[0] = vec[0] * scalar;
	out[1] = vec[1] * scalar;
	out[2] = vec[2] * scalar;
}

stock vector_add(const Float:in1[], const Float:in2[], Float:out[])
{
	out[0] = in1[0] + in2[0];
	out[1] = in1[1] + in2[1];
	out[2] = in1[2] + in2[2];
}

stock vector_normalize(const Float: vec[], Float: out[])
{
	new Float: invlen = call_rsqrt(vec[0]*vec[0] + vec[1]*vec[1] + vec[2]*vec[2]);
	out[0] = vec[0] * invlen;
	out[1] = vec[1] * invlen;
	out[2] = vec[2] * invlen;
}

stock Float: vector_dot(const Float: vec1[], const Float: vec2[])
	return vec1[0]*vec2[0] + vec1[1]*vec2[1] + vec1[2]*vec2[2];
	
stock Float: vector_len(const Float: vec[])
	return call_sqrt(vec[0]*vec[0] + vec[1]*vec[1] + vec[2]*vec[2]);

stock Float: call_sqrt(Float: x)
	return floatsqroot(x);	

//Force unstuck for soldiers at spawn
stock UnstuckPlayer(iPlayer, i_StartDistance, i_MaxAttempts)
{
	#define SKIP_IGNORE -1

	enum Coord_e 
	{ 
		Float: x, 
		Float: y, 
		Float: z 
	}

	#define GetPlayerHullSize ((pev(iPlayer, pev_flags) & FL_DUCKING) ? HULL_HEAD : HULL_HUMAN)	
	#define MAX_DISTANCE 1000
	
	//Not alive, ignore.
	if(!is_user_alive(iPlayer))  
		return SKIP_IGNORE;
        
	static Float: vf_OriginalOrigin[Coord_e], Float: vf_NewOrigin[Coord_e];
	static i_Attempts, i_Distance;
        
	//Get the current player's origin.
	pev(iPlayer, pev_origin, vf_OriginalOrigin);
        
	i_Distance = i_StartDistance;
        
	while(i_Distance < MAX_DISTANCE)
	{
		i_Attempts = i_MaxAttempts;
            
		while(i_Attempts --)
		{
			vf_NewOrigin[x] = random_float(vf_OriginalOrigin[x] - i_Distance, vf_OriginalOrigin[x] + i_Distance);
			vf_NewOrigin[y] = random_float(vf_OriginalOrigin[y] - i_Distance, vf_OriginalOrigin[y] + i_Distance);
			vf_NewOrigin[z] = random_float(vf_OriginalOrigin[z] - i_Distance, vf_OriginalOrigin[z] + i_Distance);
            
			engfunc(EngFunc_TraceHull, vf_NewOrigin, vf_NewOrigin, DONT_IGNORE_MONSTERS, GetPlayerHullSize, iPlayer, NULL);
            
			//Free space found.
			if(get_tr2(NULL, TR_InOpen) && !get_tr2(NULL, TR_AllSolid) && !get_tr2(NULL, TR_StartSolid))
			{
				//Set the new origin.
				engfunc(EngFunc_SetOrigin, iPlayer, vf_NewOrigin);
				
				return TRUE;
			}
		}
            
		i_Distance += i_StartDistance;
	}
        
	//Could not be found.
	return FALSE;
}

//CWeponBox
stock Get_CS_WeaponIndex(iWeaponBox)
{
	new iWeaponEntity, iThisWeapon;
	
	for(new i = NULL; i < sizeof m_rgpPlayerItems_CWeaponBox; i ++) 
	{ 
		if((iWeaponEntity = get_pdata_cbase(iWeaponBox, m_rgpPlayerItems_CWeaponBox[i], CBASE_WEAPON)) > NULL) 
			iThisWeapon = get_pdata_int(iWeaponEntity, m_iId, CBASE_WEAPON);
	}
	
	return iThisWeapon;
}

//Give Ammunition
stock Refill_Ammunition(iPlayer, iAmount, bool: Restore)
{
	//Safe condition
	if(pev_valid(iPlayer) != PDATA_SAFE || !is_user_alive(iPlayer))
		return;		
	
	//Slot 1 and Slot 2	
	for(new iSlot = 1; iSlot < 3; iSlot ++)
	{	
		new iWeapon;	
		iWeapon = get_pdata_cbase(iPlayer, m_rgpPlayerItems[iSlot], CBASE_PLAYER);

		while(iWeapon > NULL)
		{
			//Refill current ammo
			if(iAmount > NULL && !Restore)
			{
				//Get
				new GetAmmo;				
				GetAmmo = get_pdata_int(iPlayer, m_rgAmmo[get_pdata_int(iWeapon, m_iPrimaryAmmoType, CBASE_WEAPON)], CBASE_PLAYER);
		
				//Set
				set_pdata_int(iPlayer, m_rgAmmo[get_pdata_int(iWeapon, m_iPrimaryAmmoType, CBASE_WEAPON)], GetAmmo + iAmount, CBASE_PLAYER);
			}
			
			//Reset to starting amount
			if(Restore)
				set_pdata_int(iPlayer, m_rgAmmo[get_pdata_int(iWeapon, m_iPrimaryAmmoType, CBASE_WEAPON)], START_AMMUNITION, CBASE_PLAYER);	
			
			iWeapon = get_pdata_cbase(iWeapon, m_pNext, CBASE_WEAPON);
		}
	}
}

//Give a weapon
stock Ham_Give_Weapon(iPlayer, const iWeapon[])
{
	#define ITEM_CHARMAX 7

	if(!equal(iWeapon, "weapon_", ITEM_CHARMAX))
		return FALSE;	
 
	new iWeaponEnt = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, iWeapon));

	if(!pev_valid(iWeaponEnt))	
		return FALSE;

	set_pev(iWeaponEnt, pev_spawnflags, SF_NORESPAWN);

	dllfunc(DLLFunc_Spawn, iWeaponEnt);
     
	if(!ExecuteHamB(Ham_AddPlayerItem, iPlayer, iWeaponEnt))
	{
		if(pev_valid(iWeaponEnt))
			set_pev(iWeaponEnt, pev_flags, pev(iWeaponEnt, pev_flags) | FL_KILLME);
        	
		return FALSE;
	}
 
	ExecuteHamB(Ham_Item_AttachToPlayer, iWeaponEnt, iPlayer);

	return TRUE;	
}

//Strip slots
stock Strip_Slot(iPlayer, iSlot)
{
	//Safe condition
	if(pev_valid(iPlayer) != PDATA_SAFE || !is_user_alive(iPlayer))
		return;		
		
	new iWeaponEnt;	
	iWeaponEnt = get_pdata_cbase(iPlayer, m_rgpPlayerItems[iSlot], CBASE_PLAYER);
	
	while(iWeaponEnt > NULL)
	{
		set_pev(iPlayer, pev_weapons, pev(iPlayer, pev_weapons) &~ (1 << get_pdata_int(iWeaponEnt, m_iId, CBASE_WEAPON)));

		ExecuteHamB(Ham_Weapon_RetireWeapon, iWeaponEnt);

		new pNext_iWeaponEnt = get_pdata_cbase(iWeaponEnt, m_pNext, CBASE_WEAPON);
		
		if(ExecuteHamB(Ham_RemovePlayerItem, iPlayer, iWeaponEnt))
			ExecuteHamB(Ham_Item_Kill, iWeaponEnt);	
		
		iWeaponEnt = pNext_iWeaponEnt;
	}
	
	set_pdata_cbase(iPlayer, m_rgpPlayerItems[iSlot], -1, CBASE_PLAYER);
}

#define DRAW_MSG_TIME 5.5
#define DRAW_MSG_DIFFERENCE 0.5

//Custom text
stock MSG_GlobalHudMessage(Red, Green, Blue, Float: iX, Float: iY, const iInput[])
{
	//Let it go away if already drawn
	if(g_global_msg)	
		return;
	
	//Lock
	g_global_msg = true;
	
	//Set
	set_dhudmessage(Red, Green, Blue, iX, iY, NULL, 0.5, DRAW_MSG_TIME - DRAW_MSG_DIFFERENCE, 0.5, 0.5);
	show_dhudmessage(SEND_ALL, iInput);	

	//Delay to prevent coloring messup and messages one on another
	set_task(DRAW_MSG_TIME, "Task_ResetGlobalTextMSG", TASK_GLOBAL_TEXT_MSG);	
}

//Draw hud messages, channel 4
stock MSG_HudMessage(iPlayer, Red, Green, Blue, Float: iX, Float: iY, const iBigInput[], const iSmallInput[], bool: iBigFont, bool: iSmallFont)
{
	if(g_hud_text_timeout[iPlayer])	
		return;
		
	new Float: FONT_OFFSET;

	//Both rendered
	if(iBigFont && iSmallFont)
		FONT_OFFSET = 0.03;
	else
		FONT_OFFSET = 0.0;
	
	g_hud_text_timeout[iPlayer] = true;
	
	#if defined DEBUG_INFO
	
		client_print(iPlayer, print_chat, "Hud message called");
		
	#endif
	
	//Level Up
	if(iBigFont)
	{
		set_dhudmessage(Red, Green, Blue, iX, iY - FONT_OFFSET, NULL, 0.5, DRAW_MSG_TIME - DRAW_MSG_DIFFERENCE, 0.5, 0.5);
		show_dhudmessage(iPlayer, iBigInput);	
	}

	//Other	
	if(iSmallFont)
	{
		set_hudmessage(Red, Green, Blue, iX, iY, NULL, 0.5, DRAW_MSG_TIME - DRAW_MSG_DIFFERENCE, 0.5, 0.5, 4);
		show_hudmessage(iPlayer, iSmallInput);
	}	

	set_task(DRAW_MSG_TIME, "Task_ResetTextMSG", iPlayer + TASK_TEXT_MSG);	
}	

//All soldiers turned into mutants or died
stock RoundCheck_CallbackWin_Mutants()
{
	if(g_win_condition)
		return;
	
	if(!Get_iTeamPlayer(SOLDIERS, true) && !Get_iTeamPlayer(GHOSTBLADE, true))
	{
		#if defined MSG_DATA

			//Nano win
			MSG_GlobalHudMessage(100, 100, 100, -1.0, 0.20, MSG_MUTANT_WIN);
		
		#endif
		
		TerminateRound(RoundEndType_TeamExtermination, TeamWinning_Terrorist);
		PlaySound(SEND_ALL, SND_NANO_WIN);

		#if defined DEBUG_INFO
			
			client_print(SEND_ALL, print_chat, "Round Terminated: Team Winning Mutants");

		#endif
		
		g_win_condition = true;		
	}	
}

//All mutants and terminators killed
stock RoundCheck_CallbackWin_Soldiers()
{
	if(g_win_condition)
		return;	
	
	if(!Get_iTeamPlayer(MUTANTS, true) && !Get_iTeamPlayer(TERMINATOR, true))	
	{	
		#if defined MSG_DATA

			//Soldier win
			MSG_GlobalHudMessage(100, 100, 100, -1.0, 0.20, MSG_SOLDIER_WIN);				
		
		#endif	
	
		TerminateRound(RoundEndType_TeamExtermination, TeamWinning_Ct);
		PlaySound(SEND_ALL, SND_MERCENARY_WIN);
	
		#if defined DEBUG_INFO
			
			client_print(SEND_ALL, print_chat, "Round Terminated: Team Winning Soldiers");

		#endif
		
		g_win_condition = true;		
	}	
}

//Turn off at spawn
stock TurnOFF_Radio(iPlayer)
	set_pdata_int(iPlayer, m_iRadioMessages, NULL, CBASE_PLAYER);

//Draw player speed
stock GetPlayerSpeed(iPlayer)
{
	new Float: iSpeed;
	pev(iPlayer, pev_maxspeed, iSpeed);
		
	client_print(iPlayer, print_chat, "Player Speed: %d", floatround(iSpeed, floatround_round));	
}

//If mutated or respawned
stock RemoveSkillData(iPlayer)
{
	//Remove speedup, if set
	remove_task(iPlayer + TASK_MUTANT_SKILL);
	
	//Set default body
	remove_task(iPlayer + TASK_BODY);

	g_damage_set[iPlayer] = false;
	g_blade_skill[iPlayer] = false;
	g_mutant_skill[iPlayer] = false;
	g_terminator_skill[iPlayer] = false;
	g_hit_count[iPlayer] = NULL;
}	

//RenderFx
stock SetRendering(iEntity, iFx = kRenderFxNone, r = 255, g = 255, b = 255, iRender = kRenderNormal, iAmount = 16)
{
	static Float: iColor[3];
	iColor[0] = float(r);
	iColor[1] = float(g);
	iColor[2] = float(b);

	set_pev(iEntity, pev_renderfx, iFx);
	set_pev(iEntity, pev_rendercolor, iColor);
	set_pev(iEntity, pev_rendermode, iRender);
	set_pev(iEntity, pev_renderamt, float(iAmount));
}

//Get teammates (Mod specific)
stock Get_iTeamPlayer(iTeam, bool: iAlive = false)
{
	new iNum;
	
	for(new iPlayer = 1; iPlayer < MaxClients + 1; iPlayer ++)
	{		
		if((g_team[iPlayer] == iTeam || iTeam == ALL) && (is_user_alive(iPlayer) || !iAlive) && is_user_connected(iPlayer))	
			iNum += 1;
	}	
	
	return iNum;
}

//Play client sounds
stock PlaySound(iPlayer, const iSound[])
{
	if(equal(iSound[strlen(iSound) - 4], ".mp3"))
	{
		client_cmd(iPlayer, "mp3 stop");
		client_cmd(iPlayer, "mp3 play sound/%s", iSound);
	}
	else
		client_cmd(iPlayer, "spk ^"sound/%s^"", iSound);
}

//Module noroundend required
//Author: jim_yang
//https://forums.alliedmods.net/showthread.php?t=95705
stock FreezeRound(iValue)
	server_cmd("sv_noroundend %d", iValue);
	
//Class viewmodel
stock SetPlayerViewmodel(iPlayer, const iModelViewmodel[], const iModelWeaponmodel[])
{
	if(is_user_alive(iPlayer))
	{	
		set_pev(iPlayer, pev_viewmodel2, iModelViewmodel);
		set_pev(iPlayer, pev_weaponmodel2, iModelWeaponmodel);
	}
}

//Levelup
stock LevelUp_Mercenaries(const iSound[], iBPAmmoAmount, bool: TransformGhostblade)
{
	for(new iPlayer = 1; iPlayer < MaxClients + 1; iPlayer ++)
	{
		if(is_soldier(iPlayer))
		{
			//No against spectators
			if(is_user_alive(iPlayer))
				PlaySound(iPlayer, iSound);
				
			if(TransformGhostblade)
				Setup_Ghostblade(iPlayer);
			
			if(iBPAmmoAmount > NULL)
				Refill_Ammunition(iPlayer, iBPAmmoAmount, false);				
		}		
	}
}

//LevelUp message for soldiers/ghostblades
stock DrawLevelUp_Message()
{
	for(new iPlayer = 1; iPlayer < MaxClients + 1; iPlayer ++)
	{
		//Only for alive
		//Note 1	
		if(is_soldier(iPlayer) && is_user_alive(iPlayer))		
			MSG_HudMessage(iPlayer, 150, 100, NULL, -1.0, 0.30, MSG_LEVELUP, MSG_ATTENTION, true, true);
				
	}	
}

//Ammo and attack draw
stock DrawSupply_Message()
{
	for(new iPlayer = 1; iPlayer < MaxClients + 1; iPlayer ++)
	{
		//Alive	
		if(is_soldier(iPlayer) && is_user_alive(iPlayer))
		{			
			//print_chat
			static MSG_LVL[128];
			new Float: ATTACK_AMOUNT, BPAMMO_NUM;
						
			switch(g_level_stage)
			{
				case 1:
				{
					ATTACK_AMOUNT = LEVEL_ONE_DAMAGE;
					BPAMMO_NUM = LEVEL_ONE_BPAMMO;
					MSG_LVL = MSG_LEVEL;
				}
				
				case 2:
				{	
					ATTACK_AMOUNT = LEVEL_MAX_DAMAGE;
					BPAMMO_NUM = LEVEL_TWO_BPAMMO;
					MSG_LVL = MSG_LEVEL2;
				}	
			}	

			client_print(iPlayer, print_center, MSG_LVL, BPAMMO_NUM, floatround(ATTACK_AMOUNT * 100.0, floatround_round));
		}				
	}	
}

//Set protection
stock SetProtection(iPlayer)
{
	/*if(g_player_amount < PLAYERS_GAME_START)
		return;*/

	set_pev(iPlayer, pev_takedamage, DAMAGE_NO);

	SetRendering(iPlayer, kRenderFxNone, NULL, NULL, NULL, kRenderTransAdd, 150);
	
	new Float: iTIMER;
	
	//Round start delay
	if(is_soldier(iPlayer))
		iTIMER = SOLDIER_PROTECTION_DELAY;
	
	//Mutant respawn time
	else
		iTIMER = MUTANT_PROTECTION_DELAY;
	
	remove_task(iPlayer + TASK_PROTECTION);
	set_task(iTIMER, "Task_RemoveProtection", iPlayer + TASK_PROTECTION);
}

//Prevent radar from disappearing
stock Update_Attribute(iPlayer)
{
	message_begin(MSG_BROADCAST, g_msgScoreAttrib);
	write_byte(iPlayer); //id
	write_byte(NULL); //attrib
	message_end();
}

//Draw kill messages
stock Update_DeathMessage(iAttacker, iVictim)
{
	message_begin(MSG_BROADCAST, g_msgDeathMsg);
	write_byte(iAttacker);
	write_byte(iVictim);
	write_byte(NULL);
	write_string("knife");
	message_end();
}

//Update team score
stock Update_TeamScores(team_score, const iTeam[])
{	
	message_begin(MSG_ALL, g_msgTeamScore);
	write_string(iTeam);
	write_short(team_score);
	message_end();
}

//Update player frags or deaths
stock Update_PlayerScoreboard(iPlayer, iAmount, bool: iDeath)
{
	new iScoreType;
	
	//Called to set death amount
	if(iDeath)
	{
		iScoreType = NULL;
		
		new iCurrentAmount;
		iCurrentAmount = get_pdata_int(iPlayer, m_iDeaths, CBASE_PLAYER);
		
		set_pdata_int(iPlayer, m_iDeaths, iCurrentAmount + iAmount, CBASE_PLAYER);
	}
	
	//Set frag amount
	else
		iScoreType = iAmount;
		
	//Scoretype null is always Death amount, any other value is Frags
	ExecuteHam(Ham_AddPoints, iPlayer, iScoreType, true);
}

//Get player name
stock GetPlayerName(iPlayer) 
{    
	new pName[32];    
	engfunc(EngFunc_InfoKeyValue, engfunc(EngFunc_GetInfoKeyBuffer, iPlayer), "name", pName, charsmax(pName));
	
	return pName;
}

//SupplyBox
stock Drop_SupplyBox()
{
	#define SUPPLY_TO_SPAWN 1

	//Stop if all spawns are busy or round end triggered
	if(g_round_status == ROUNDSTATUS_END || g_maximum_spawns < SUPPLY_TO_SPAWN) 
		return;

	new iEnt; 
	iEnt = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"));
	
	set_pev(iEnt, pev_classname, SUPPLYBOX_CLASSNAME);
	
	engfunc(EngFunc_SetModel, iEnt, MDL_SUPPLYBOX);
	engfunc(EngFunc_SetSize, iEnt, Float: { -2.0, -2.0, -2.0 }, Float: { 5.0, 5.0, 5.0 });
	set_pev(iEnt, pev_solid, SOLID_TRIGGER);
	set_pev(iEnt, pev_movetype, MOVETYPE_TOSS);
	
	//Push
	engfunc(EngFunc_SetOrigin, iEnt, g_supply_spawns[g_maximum_spawns --]);
}

//Open config
stock Cache_Supplybox_Spawns()
{
	new cfgdir[32], mapname[32], filepath[100], linedata[64];
	
	get_localinfo("amxx_configsdir", cfgdir, charsmax(cfgdir));	
	get_mapname(mapname, charsmax(mapname));
	
	formatex(filepath, charsmax(filepath), SUPPLYBOX_CONFIG_DIR, cfgdir, mapname);
	
	//Spawn exists
	if(file_exists(filepath))
	{
		new spawndata[10][6], file = fopen(filepath, "rt");
		
		while(file && !feof(file))
		{
			fgets(file, linedata, charsmax(linedata));
			
			if(!linedata[0] || Str_Count(linedata, ' ') < 2) 
				continue;
				
			parse(linedata, spawndata[0], 5, spawndata[1], 5, spawndata[2], 5, spawndata[3], 5, 
			spawndata[4], 5, spawndata[5], 5, spawndata[6], 5, spawndata[7], 5, spawndata[8], 5, spawndata[9], 5);
			
			g_supply_spawns[g_spawn_origin][0] = floatstr(spawndata[0]);
			g_supply_spawns[g_spawn_origin][1] = floatstr(spawndata[1]);
			g_supply_spawns[g_spawn_origin][2] = floatstr(spawndata[2]);
			
			CollectSpawnOrigin();
			
			if(g_spawn_origin >= sizeof g_supply_spawns) 
				break;
		}
		
		if(file) 
			fclose(file);
	}
	
	//Not found
	else
	{
		SupplyBox_Spawns_Entity("info_player_start");
		SupplyBox_Spawns_Entity("info_player_deathmatch");
	}
}

//Default player spawns
stock SupplyBox_Spawns_Entity(const classname[])
{
	new iEnt = NULLENT;
	
	while((iEnt = engfunc(EngFunc_FindEntityByString, iEnt, "classname", classname)) != NULL)
	{
		//Get origin
		new Float: OriginF[3];
		
		pev(iEnt, pev_origin, OriginF);
		
		g_supply_spawns[g_spawn_origin][0] = OriginF[0];
		g_supply_spawns[g_spawn_origin][1] = OriginF[1];
		g_supply_spawns[g_spawn_origin][2] = OriginF[2];
		
		CollectSpawnOrigin();
		
		if(g_spawn_origin >= sizeof g_supply_spawns) 
			break;
	}
}

//Spawn count
stock CollectSpawnOrigin()
	g_spawn_origin ++;

//Calc char
stock Str_Count(const str[], searchchar)
{
	new count, i, len = strlen(str);
	
	for(i = NULL; i <= len; i ++)
	{
		if(str[i] == searchchar)
			count ++;
	}
	
	return count;
}

//Remove by Entname
stock RemoveEntity(const EntName[])
{
	new iEnt = NULLENT;
	
	while((iEnt = engfunc(EngFunc_FindEntityByString, iEnt, "classname", EntName)))
	{
		set_pev(iEnt, pev_effects, EF_NODRAW);
		set_pev(iEnt, pev_flags, pev(iEnt, pev_flags) | FL_KILLME);
	}
}

//Set cvar values
stock Setup_World_Brightness()
{
	//Force sky lighting
	set_cvar_num("sv_skycolor_r", 200);
	set_cvar_num("sv_skycolor_g", 200);
	set_cvar_num("sv_skycolor_b", 200);

	//Force skyvec position
	set_cvar_num("sv_skyvec_x", NULL);
	set_cvar_num("sv_skyvec_y", NULL);
	set_cvar_num("sv_skyvec_z", NULL);
}

//Reset to defaults
stock Reset_Model(iPlayer)
{
	set_pev(iPlayer, pev_skin, NULL);
	set_pev(iPlayer, pev_body, NULL);
}

//On Deploy
stock SetupViewEntity(iPlayer, iEnt, Float: iTime)
{
	#define DEPLOY_ANIM_NUM 3

	set_pdata_float(iPlayer, m_flNextAttack, iTime, CBASE_PLAYER);
	set_pdata_float(iEnt, m_flNextPrimaryAttack, iTime, CBASE_WEAPON);
	set_pdata_float(iEnt, m_flNextSecondaryAttack, iTime, CBASE_WEAPON);			
	set_pdata_float(iEnt, m_flTimeWeaponIdle, iTime, CBASE_WEAPON);
	
	//Deploy animation may skip
	ExecuteHam(Ham_CS_Weapon_SendWeaponAnim, iEnt, DEPLOY_ANIM_NUM, NULL);
}

#define CS_ARMOR_HELMET 1
#define ARMOR_VALUE 100.0

//Supply AI
stock Bot_RandomWeapon(iPlayer)
{
	#define BOT_AMMO 150

	if(is_user_bot(iPlayer) && is_soldier(iPlayer))
	{
		new iRandom, iRandomGrenade, iWeapon[24];
		
		iRandom = random_num(1, 7);
		
		switch(iRandom)
		{
			case 1: iWeapon = "weapon_m4a1"
			case 2: iWeapon = "weapon_famas"
			case 3: iWeapon = "weapon_ak47"
			case 4: iWeapon = "weapon_g3sg1"
			case 5: iWeapon = "weapon_sg552"
			case 6: iWeapon = "weapon_sg550"
			case 7: iWeapon = "weapon_m249"
		}
		
		//Give primary weapon
		Ham_Give_Weapon(iPlayer, iWeapon);
		
		//Give eagle
		Ham_Give_Weapon(iPlayer, "weapon_deagle");
		
		//Give Stungrenade or just Hegrenade
		iRandomGrenade = random_num(1, 2);
		
		switch(iRandomGrenade)
		{
			case 1: 
			{
				g_stun_grenade_received[iPlayer] = true;
			
				Ham_Give_Weapon(iPlayer, "weapon_smokegrenade");
			}
			
			case 2: Ham_Give_Weapon(iPlayer, "weapon_hegrenade");
		}

		//Set armor type and refill
		set_pdata_int(iPlayer, m_iKevlar, CS_ARMOR_HELMET, CBASE_PLAYER);
		set_pev(iPlayer, pev_armorvalue, ARMOR_VALUE);
			
		//Emit pickup if this is his second spawn
		if(!g_player_first_spawn[iPlayer])
			emit_sound(iPlayer, NULL, "items/ammopickup2.wav", 1.0, ATTN_NORM, NULL, PITCH_NORM);		
		
		Refill_Ammunition(iPlayer, BOT_AMMO, false);
	}
}

//Supply soldiers
stock Soldier_Supply(iPlayer)
{
	#define ARMOR_PIECE 0.0
	#define SUPPLY_AMMO 30

	new iRandom;
	
	iRandom = random_num(1, 3);
	
	switch(iRandom)
	{	
		//Nano Armor
		case 1: 
		{
			new Float: iArmorvalue;
		
			pev(iPlayer, pev_armorvalue, iArmorvalue);

			//Check, if already wearing armor, just give ammo and return
			if(iArmorvalue > ARMOR_PIECE)
			{
				Refill_Ammunition(iPlayer, SUPPLY_AMMO, false);
			
				client_print(iPlayer, print_center, MSG_REFILL_AMMO);
				
				return;
			}	
		
			//Vesthelmet
			Give_Armor(iPlayer);

			client_print(iPlayer, print_center, MSG_NANO_SHIELD);	
		}
		
		//Ammo
		case 2:
		{
			Refill_Ammunition(iPlayer, SUPPLY_AMMO, false);
			
			client_print(iPlayer, print_center, MSG_REFILL_AMMO);
		}
		
		//Stun grenade
		case 3:
		{	
			//If not set and allow only one per player!
			if(!g_stun_grenade_received[iPlayer])
			{
				g_stun_grenade_received[iPlayer] = true;
			
				Ham_Give_Weapon(iPlayer, "weapon_smokegrenade");
				
				client_print(iPlayer, print_center, MSG_STUN_GRENADE);
			}
			
			//Just fill ammo
			else
			{
				Refill_Ammunition(iPlayer, SUPPLY_AMMO, false);
				
				client_print(iPlayer, print_center, MSG_REFILL_AMMO);			
			}	
		}	
	}
}

//Send Armor Message
stock Player_ArmorType(iPlayer, iType)
{
	message_begin(MSG_ONE, g_msgArmorType, _, iPlayer);
	write_byte(iType);
	message_end();
}

//Send Screenshake effect
stock Player_ScreenShake(iPlayer)
{
	message_begin(MSG_ONE, g_msgScreenShake, _, iPlayer);
	write_short((1<<12) * 4);
	write_short((1<<12) * 5);
	write_short((1<<12) * 10);
	message_end();
}

//Red screen
stock Player_ScreenFade(iPlayer)
{
	message_begin(MSG_ONE, g_msgScreenFade, _, iPlayer);
	write_short(100 * 100);
	write_short(NULL);
	write_short(NULL);
	write_byte(255);
	write_byte(NULL);
	write_byte(NULL);
	write_byte(200);
	message_end();	
}

//Create sprite effects
stock Create_SpriteEffect(iPlayer, iModel[128], const iClassname[], Float: Framerate, Float: SpriteSize)
{
	new iOrigin[3];
	pev(iPlayer, pev_origin, iOrigin);
    
	//Create entity at player aiment
	new iEntity = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "env_sprite"));	
	engfunc(EngFunc_SetOrigin, iEntity, iOrigin);
    
	//Set sprite on entity
	engfunc(EngFunc_SetModel, iEntity, iModel);
	set_pev(iEntity, pev_classname, iClassname);

	//Setup sprite
	set_pev(iEntity, pev_rendermode, kRenderTransAdd);
	set_pev(iEntity, pev_renderamt, 200.0);
	set_pev(iEntity, pev_solid, SOLID_NOT);
	set_pev(iEntity, pev_aiment, iPlayer);
	set_pev(iEntity, pev_scale, SpriteSize);
	set_pev(iEntity, pev_framerate, Framerate);
	set_pev(iEntity, pev_spawnflags, SF_SPRITE_STARTON);
	set_pev(iEntity, pev_owner, iPlayer);
	
	//Push
	dllfunc(DLLFunc_Spawn, iEntity);
}

//Stun grenade
stock Create_StunGrenade(iEntity, iOwner)
{
	#define HIDE_COORD 5000.0
	#define STUNGRENADE_TIMER 0.1
	
	//Reset player tick count
	g_stungrenade_tick[iOwner] = NULL;
		
	new Float: iHidePosition[3], Float: iPosition[3];
			
	//Remember original Sgrenade touch position
	pev(iEntity, pev_origin, iPosition);
			
	//Setup Sgrenade move position
	iHidePosition[0] = HIDE_COORD;
	iHidePosition[1] = HIDE_COORD;
	iHidePosition[2] = HIDE_COORD;
						
	//Move it outside of map bound, because of smokepuff and destroy
	set_pev(iEntity, pev_origin, iHidePosition);
	set_pev(iEntity, pev_effects, EF_NODRAW);
	set_pev(iEntity, pev_flags, pev(iEntity, pev_flags) | FL_KILLME);
			
	//Create now our effect on sg touch position.
	new iSphereEntity = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"));	
	engfunc(EngFunc_SetOrigin, iSphereEntity, iPosition);
    
	//Set model on entity
	engfunc(EngFunc_SetModel, iSphereEntity, MDL_SPHERE);
	set_pev(iSphereEntity, pev_classname, SPHERE_CLASSNAME);

	//Setup
	set_pev(iSphereEntity, pev_rendermode, kRenderTransAdd);
	set_pev(iSphereEntity, pev_solid, SOLID_NOT);
	set_pev(iSphereEntity, pev_renderamt, 255.0);
	set_pev(iSphereEntity, pev_scale, 1.0);
	set_pev(iSphereEntity, pev_framerate, 1.0);
	set_pev(iSphereEntity, pev_owner, iOwner);
	
	//Push
	dllfunc(DLLFunc_Spawn, iSphereEntity);	

	//Explode sound
	emit_sound(iSphereEntity, NULL, SND_STUN_EXPLODE, 1.0, ATTN_NORM, NULL, PITCH_NORM);	
						
	new Float: iParamData[3]; 
	
	iParamData[0] = iPosition[0];
	iParamData[1] = iPosition[1];
	iParamData[2] = iPosition[2];
			
	remove_task(iOwner + TASK_STUNGRENADE);
	set_task(STUNGRENADE_TIMER, "Task_StunGrenade", iOwner + TASK_STUNGRENADE, iParamData, sizeof(iParamData));

	#if defined DEBUG_INFO
		
		client_print(iOwner, print_chat, "StunGrenade Exploded");

	#endif
}

//Remove entity by owner
stock Remove_EntityByOwner(iPlayer, const iClassname[])
{
	new iEntity = NULLENT;

	while((iEntity = engfunc(EngFunc_FindEntityByString, iEntity, "classname", iClassname)))
	{
		if(pev(iEntity, pev_owner) == iPlayer)
		{
			set_pev(iEntity, pev_effects, EF_NODRAW);
			set_pev(iEntity, pev_flags, pev(iEntity, pev_flags) | FL_KILLME);
		}
	}
}

//Not allowed to buy
stock bool: is_restricted_character(iPlayer, bool: CountBot)
{	
	if(is_mutant(iPlayer) || is_terminator(iPlayer))
		return true;
	
	//Bots	
	if(CountBot)
	{
		if(is_user_bot(iPlayer))
			return true;
	}	
		
	#if defined USE_SPECIAL_CHARACTER	
		
		if(is_ghostblade(iPlayer) || player_fox_seaside(iPlayer))
			return true;
			
	#else

		if(is_ghostblade(iPlayer))
			return true;

	#endif			
		
	return false;	
}

//Remove this after transform
stock Remove_BuySignal(iPlayer)
{
	//Send
	set_pdata_int(iPlayer, m_signals, get_pdata_int(iPlayer, m_signals) & ~(1 << 0));
	
	//Remove icon, if exists
	message_begin(MSG_ONE, g_msgStatusIcon, _, iPlayer);
	write_byte(NULL);
	write_string("buyzone");
	write_byte(NULL);
	write_byte(NULL);
	write_byte(NULL);
	message_end();	
}

//Remove inventory
stock Strip_Weapon(iPlayer)
{
	for(new iSlots = 1; iSlots < 6; iSlots ++)
	{
		//Dunno't strip knife
		if(iSlots != 3)		
			Strip_Slot(iPlayer, iSlots);
	}
}

//Remove everything, include bpammo
stock Remove_PlayerArmoury(iPlayer)
	dllfunc(DLLFunc_Use, g_player_weaponstrip, iPlayer);

//Give vesthelm	
stock Give_Armor(iPlayer)
{
	//Set armor type and refill
	set_pdata_int(iPlayer, m_iKevlar, CS_ARMOR_HELMET, CBASE_PLAYER);
	set_pev(iPlayer, pev_armorvalue, ARMOR_VALUE);			
		
	//Emit pickup
	if(!g_player_first_spawn[iPlayer])
		emit_sound(iPlayer, NULL, "items/ammopickup2.wav", 1.0, ATTN_NORM, NULL, PITCH_NORM);
			
	//Send message to client
	Player_ArmorType(iPlayer, CS_ARMOR_HELMET);
}

//Remove given armor
stock Remove_Armor(iPlayer)
{
	#define ARMOR_POINTS 0.0

	//Remove armor
	set_pdata_int(iPlayer, m_iKevlar, NULL, CBASE_PLAYER);	
	set_pev(iPlayer, pev_armorvalue, ARMOR_POINTS);
}

//Hide money
stock Hide_Money(iPlayer, bool: HideMoney)
{
	new iValue;
		
	message_begin(MSG_ONE, g_msgMoney, _, iPlayer);
	
	if(HideMoney)
		iValue = HIDEHUD_MONEY | HIDEHUD_FLASHLIGHT;
	else
		iValue = NULL;
		
	write_byte(iValue);
	message_end();
	
	//Observer Crosshair bug?
	Fix_Crosshair(iPlayer);
}

//Fix observer crosshair
stock Fix_Crosshair(iPlayer)
{
    message_begin(MSG_ONE, g_msgCrosshair, _, iPlayer);
    write_byte(NULL);
    message_end();
}

//Check against disconnected
stock Remove_MonsterEntity(iPlayer)
{
	//Remove Knight effect
	if(is_ghostblade(iPlayer))
		Remove_EntityByOwner(iPlayer, KNIGHT_CLASSNAME);
		
	//If was set right before disconnection	
	if(is_mutant(iPlayer))
		Remove_EntityByOwner(iPlayer, MUTATION_CLASSNAME);

	//Remove Xeno name
	if(is_terminator(iPlayer))
		Remove_EntityByOwner(iPlayer, XENO_CLASSNAME);
}

#if defined WORLD_FOG

	//World kv
	stock Set_Kvd(iEntity, const key[], const value[], const classname[])
	{
		set_kvd(NULL, KV_ClassName, classname);
		set_kvd(NULL, KV_KeyName, key);
		set_kvd(NULL, KV_Value, value);
		set_kvd(NULL, KV_fHandled, NULL);

		dllfunc(DLLFunc_KeyValue, iEntity, NULL);
	}

#endif	