//Mod name
#define GAME_NAME "Mutation Knight"

//Mod language example
//#define RUSSIAN_LANGUAGE

#if defined RUSSIAN_LANGUAGE

	//Sound path
	#define SOUND_PATH "ghostblade_ru/"
	
	//Announcer data
	#define MSG_COUNTDOWN "Мутация началась! %d сек."
	#define MSG_COUNTDOWN_FINISHED "Мутация началась!"
	#define MSG_ARMORED_XENO_APPEARED "Бронированный Хищник выходит на поле боя!"
	#define MSG_GHOSTBLADE_APPEARED "Появился Невидимый клинок"
	#define MSG_MUTANT_APPEAR "Вы превратились в мутанта"
	#define MSG_MUTANT_LEVELUP "%d уровень! Получены дополнительные ОЗ и особое умение"
	#define MSG_MUTANT_LEVELUP_NEXT "Вы достигли %d уровня и получаете дополнительные ОЗ"
	#define MSG_LEVEL "Дополнительные боеприпасы +%d и урон увеличен на +%d%"
	#define MSG_LEVEL2 "Активирован датчик сердцебиения: боеприпасы +%d и урон +%d%"
	#define MSG_SUPPLYBOX "Ящик с припасами доставлен"
	#define MSG_NANO_ARMOR "Защита от мутации уничтожена"
	#define MSG_NANO_SHIELD "Вы подняли щит"
	#define MSG_REFILL_AMMO "Получены дополнительные боеприпасы"
	#define MSG_STUN_GRENADE "Получена оглушающая граната"
	#define MSG_RESTRICTED "Данный предмет невозможно купить"
	#define MSG_BLOCKED "Данная команда заблокирована."

	//Hud announcer data
	#define MSG_MUTANT_KEY "Кнопка [ВЫБОР КОМАНДЫ] увеличивает ^nшанс превращения в мутанта."
	#define MSG_LEVELUP "НОВЫЙ УРОВЕНЬ"
	#define MSG_MUTANT_WIN "ПОБЕДИЛИ МУТАНТЫ"
	#define MSG_SOLDIER_WIN "ПОБЕДИЛИ СОЛДАТЫ"
	#define MSG_STANCE_KEY "Теперь можно ^nиспользовать дополнительное умение."
	#define MSG_ATTENTION "ВНИМАНИЕ ПРЕДУПРЕЖДЕНИЕ"	

#else

	//Sound Path
	#define SOUND_PATH "ghostblade/"
	
	//Announcer data
	#define MSG_COUNTDOWN "Mutation outbreak! %d seconds"
	#define MSG_COUNTDOWN_FINISHED "Mutation outbreak!"
	#define MSG_ARMORED_XENO_APPEARED "Armored Xeno has appeared!"
	#define MSG_GHOSTBLADE_APPEARED "Ghost Blade has appeared!"
	#define MSG_MUTANT_APPEAR "You have turned into a Mutant!"
	#define MSG_MUTANT_LEVELUP "Level %d! HP increased and unique skill enabled."
	#define MSG_MUTANT_LEVELUP_NEXT "Level %d! HP has increased."
	#define MSG_LEVEL "Additional Ammo +%d and Attack Power +%d%"
	#define MSG_LEVEL2 "Heartbeat sensor activated: Ammo +%d and Attack Power +%d%"
	#define MSG_SUPPLYBOX "Supply box has been deployed!"
	#define MSG_NANO_ARMOR "Nano Armor is removed"
	#define MSG_NANO_SHIELD "Picked up Nano Armor"
	#define MSG_REFILL_AMMO "Additional Backpack Ammo"
	#define MSG_STUN_GRENADE "Picked up Stun Grenade"
	#define MSG_RESTRICTED "This selection is not available for purchase"
	#define MSG_BLOCKED "This command is not available."

	//Hud announcer data
	#define MSG_MUTANT_KEY "Press the [TEAM] key to increase your chance to start as a Mutant."
	#define MSG_LEVELUP "LEVEL UP"
	#define MSG_MUTANT_WIN "MUTANTS WIN"
	#define MSG_SOLDIER_WIN "SOLDIERS WIN"
	#define MSG_STANCE_KEY "You can now use the stance change skill."
	#define MSG_ATTENTION "ATTENTION ALERT"	
	
#endif

//Comment, if you uploading files to client with a different way
#define PRECACHE_RESOURCE

//Show debug messages
//#define DEBUG_INFO

//Show hud announcer messages
#define MSG_DATA

//Mutants and Terminators blood color
#define GREEN_BLOOD_COLOR

//Change skybox
#define WORLD_SKYBOX

//Set world light
#define WORLD_LIGHTNING

//Enable fog
#define WORLD_FOG

//For DLC characters, comment this for classic mode
#define USE_SPECIAL_CHARACTER

#if defined USE_SPECIAL_CHARACTER

	//External data
	native player_fox_seaside(iPlayer);
	native player_reset_agent(iPlayer);
	
#endif	

//Offsets
stock m_iMenu = 205 //int
stock m_LastHitGroup = 75 //int
stock m_fSequenceLoops = 40 //BOOL
stock m_Activity = 73 //Activity
stock m_IdealActivity = 74 //Activity
stock m_flFrameRate = 36 //float
stock m_flGroundSpeed = 37 //float
stock m_flLastEventCheck = 38 //float
stock m_flLastFired = 220 //float
stock m_fSequenceFinished = 39 //BOOL
stock m_signals = 235 //CUnifiedSignals
stock m_iRadioMessages = 192 //int
stock m_iClip = 51 //int
stock m_iId = 43 //int
stock m_iKevlar = 112 //int
stock m_iTeam = 114 //int
stock m_pPlayer = 41 //CBasePlayer *
stock m_flVelocityModifier = 108 //float
stock m_modelIndexPlayer = 491 //int
stock m_szAnimExtention = 492 //char [32]
stock m_iDeaths = 444 //int
stock m_pNext = 42 //CBasePlayerItem *
stock m_flNextAttack = 83 //float
stock m_flNextPrimaryAttack = 46 //float
stock m_flNextSecondaryAttack = 47 //float
stock m_flTimeWeaponIdle = 48 //float
stock m_pActiveItem = 373 //CBasePlayerItem *
stock m_iPrimaryAmmoType = 49 //int
stock m_rgpPlayerItems[6] = { 367, 368, 369, 370, 371, 372 } //CBasePlayerItem *
stock m_rgAmmo[] = { 376, 377, 378, 379, 380, 381, 382, 383, 384, 385, 386, 387, 388, 389, 390, 391, 392, 393, 394, 395, 396, 397, 398, 399, 400, 401, 402, 403, 404, 405, 406, 407 } //int
stock m_rgpPlayerItems_CWeaponBox[] = { 34, 35, 36, 37, 38, 39 } //CBasePlayerItem/CWeaponBox *

//Reset value
#define NULL 0

//Debug
#define SEND_ALL 0

//Condition
#define TRUE 1
#define FALSE 0

//Invalid entity
#define NULLENT -1

//Linux diff
#define CBASE_ANIMATION 4
#define CBASE_WEAPON 4
#define CBASE_PLAYER 5

//Class
#define is_soldier(%1) g_team[%1] == SOLDIERS
#define is_mutant(%1) g_team[%1] == MUTANTS
#define is_ghostblade(%1) g_team[%1] == GHOSTBLADE
#define is_terminator(%1) g_team[%1] == TERMINATOR

//Safe condition
#define PDATA_SAFE 2

//Count player slots
#define MAXPLAYERS 32

//Other definitions
#define MENU_ITEM 10
#define PLAYERS_GAME_START 2

//Player models
#define MDL_MUTANT "models/player/mutant/mutant.mdl"
#define MDL_MUTANT_EVOLUTION "models/player/mutant_evolution/mutant_evolution.mdl"
#define MDL_GHOSTBLADE "models/player/ghostblade/ghostblade.mdl"
#define MDL_TERMINATOR "models/player/armored_terminator/armored_terminator.mdl"

//Default viewmodel
#define MDL_SOLDIER_KNIFE_V "models/v_knife.mdl"
#define MDL_SOLDIER_KNIFE_P "models/p_knife.mdl"

//Mutant viewmodel
#define MDL_MUTANT_HAND "models/ghostblade/v_mutant_hand.mdl"
#define MDL_MUTANT_EVO_HAND "models/ghostblade/v_mutant_evolution.mdl"

//Ghostblade viewmodel
#define MDL_GHOSTBLADE_HAND "models/ghostblade/v_ghostblade_hand.mdl"

//Armored terminator viewmodel
#define MDL_TERMINATOR_HAND "models/ghostblade/v_terminator_hand.mdl"

//Supplybox model
#define MDL_SUPPLYBOX "models/ghostblade/supplybox.mdl"

//Sphere model
#define MDL_SPHERE "models/ghostblade/sphere.mdl"

//Mutation sprite
#define SPR_MUTANT_HIT "sprites/ghostblade/mutant_appear.spr"

//Knight name
#define SPR_KNIGHT_NAME "sprites/ghostblade/knight_effect.spr"

//Xeno name
#define SPR_XENO_NAME "sprites/ghostblade/xeno_mutant.spr"

//BG Music
#define SND_BGM "ghostblade/ambient/NanoAmbiSound.mp3"

//Outbreak sounds
#define SND_ASSAULT SOUND_PATH + "soldiers/Sol_CountDown.wav"
#define SND_OUTBREAK SOUND_PATH + "soldiers/Sol_CountDownFin.wav"
#define SND_OUTBREAK_MUTANT SOUND_PATH + "mutants/Nano_CountDownFin.wav"
#define SND_NANO_REMOVED SOUND_PATH + "soldiers/Sol_KillNano.wav"

//Win sounds
#define SND_NANO_WIN SOUND_PATH + "mutants/Nano_Win.wav"
#define SND_MERCENARY_WIN SOUND_PATH + "soldiers/Sol_Win.wav"

//Soldiers levelup sounds
#define SND_MERCENARY_LEVEL1 SOUND_PATH + "soldiers/Sol_Upgrade2.wav"
#define SND_MERCENARY_LEVEL2 SOUND_PATH + "soldiers/Sol_Upgrade3.wav"

//Mutant levelup sounds
#define SND_MUTANT_LEVEL1 SOUND_PATH + "mutants/Nano_Upgrade2.wav"
#define SND_MUTANT_LEVEL2 SOUND_PATH + "mutants/Nano_Upgrade3.wav"

//Mutant skill sound
#define SND_MUTANT_SKILL "ghostblade/mutants/Nano2_SpeedUP_Scream.wav"

//Max damage sound
#define SND_DAMAGE "ghostblade/UI_SPECIALKILL2.wav"

//Heartbeat
#define SND_HEARTBEAT "ghostblade/All_HeartBeat.wav"

//Ghostblade appeared sounds
#define SND_GHOSTBLADE_15SEC SOUND_PATH + "soldiers/Sol_Ghost15Sec.wav"
#define SND_GHOSTBLADE_APPEAR SOUND_PATH + "soldiers/Sol_Ghost.wav"
#define SND_GHOSTBLADE_APPEAR_NANO SOUND_PATH + "mutants/Nano_GhostNotice.wav"

//Ghostblade sounds
#define SND_GHOSTBLADE_SELECT "ghostblade/knight/GhostBlade_Select.wav"
#define SND_GHOSTBLADE_DEFENCE "ghostblade/knight/GhostBladeDefense_DefenseSuccess.wav"
#define SND_GHOSTBLADE_CHANGE01 "ghostblade/knight/GhostBlade_change01.wav"
#define SND_GHOSTBLADE_CHANGE02 "ghostblade/knight/GhostBlade_change02.wav"

//Armored terminator appear sounds
#define SND_TERMINATOR_APPEAR SOUND_PATH + "soldiers/Sol_ArmedFinishNotice.wav"
#define SND_TERMINATOR_APPEAR_NANO SOUND_PATH + "mutants/Nano_ArmedFinish.wav"
#define SND_TERMINATOR_SELECT "ghostblade/terminator/FinalArmed_Select.wav"
#define SND_TERMINATOR_CRYING "ghostblade/terminator/FinalArmed_Crying.wav"

//Supplybox sounds
#define SND_HELICOPTER "ghostblade/mutants/Nano2_Supply_Helicopter.wav"
#define SND_SUPPLYBOX_SOLDIERS SOUND_PATH + "soldiers/Sol_ItemBoxDrop.wav"
#define SND_SUPPLYBOX_MUTANTS SOUND_PATH + "mutants/Nano_ItemBoxDrop.wav"
#define SND_SUPPLYBOX_PICKUP "ghostblade/All_GetBox.wav"

//Stun grenade sound
#define SND_STUN_EXPLODE "ghostblade/Item_StunGrenadeExpoled.wav"
#define SND_STUN_SOUND "ghostblade/Item_StunGrenade.wav"

//Mutant hit sounds
new const SND_MUTANT_HIT[][] = 
{
	"ghostblade/mutants/K_SHOOT_NANOKNIFE_1.wav", 
	"ghostblade/mutants/K_SHOOT_NANOKNIFE_2.wav", 
	"ghostblade/mutants/K_SHOOT_NANOKNIFE_3.wav"
}

//Ghostblade hit sounds
new const SND_GHOSTBLADE_HIT[][] = 
{
	"ghostblade/knight/GhostBlade_Attack_1.wav", 
	"ghostblade/knight/GhostBlade_Attack_2.wav", 
	"ghostblade/knight/GhostBlade_Attack_3.wav"
}

//Terminator hit sounds
new const SND_TERMINATOR_HIT[][] = 
{
	"ghostblade/terminator/FinalArmed_Attack_1.wav", 
	"ghostblade/terminator/FinalArmed_Attack_2.wav", 
	"ghostblade/terminator/FinalArmed_Attack_3.wav"
}

//Mutation sounds
new const SND_MUTANT_APPEAR[][] = 
{
	"ghostblade/mutants/NanoAppearSnd.wav", 
	"ghostblade/mutants/NanoAppearSnd2.wav"
}

//Countdown sounds
new const SND_COUNTDOWN[][] = 
{
	SOUND_PATH + "countdown/Ghost_Count_1.wav", 
	SOUND_PATH + "countdown/Ghost_Count_2.wav", 
	SOUND_PATH + "countdown/Ghost_Count_3.wav", 
	SOUND_PATH + "countdown/Ghost_Count_4.wav", 
	SOUND_PATH + "countdown/Ghost_Count_5.wav", 
	SOUND_PATH + "countdown/Ghost_Count_6.wav", 
	SOUND_PATH + "countdown/Ghost_Count_7.wav", 
	SOUND_PATH + "countdown/Ghost_Count_8.wav",
	SOUND_PATH + "countdown/Ghost_Count_9.wav", 
	SOUND_PATH + "countdown/Ghost_Count_10.wav"
}

//Map entity removables
new const Removable_Objects[][] = 
{
    "func_bomb_target",
    "info_bomb_target",
    "hostage_entity",
    "monster_scientist",
    "func_hostage_rescue",
    "info_hostage_rescue",
    "info_vip_start",
    "func_vip_safetyzone",
    "func_escapezone"
}

/*Server configuration. Gameplay is bound to this values,
don't change anything, if you are not sure*/
new const Server_Commands[][] = 
{
	"mp_autoteambalance 0", 
	"mp_limitteams 0", 
	"mp_roundtime 2.65", 
	"mp_freezetime 0", 
	"mp_friendlyfire 1", 
	"allow_spectators 0",
	"mp_flashlight 0",
	
	//Skybox
	#if defined WORLD_SKYBOX
	
		"sv_skyname alien1",
		
	#endif
	
	//Bot configuration
	"bot_chatter off"
}

//Restriction
new const Armoury_Data[][] = 
{
	"armoury_entity", 
	"weaponbox"
}

//Restriction
new const Restricted_Command[][] = 
{
	"menuselect 3", 
	"menuselect 5",
	"menuselect 6",
	"menuselect 8"
}

//Reset maxspeed
new Ham: Ham_Player_ResetMaxSpeed = Ham_Item_PreFrame	

//Supplybox
new g_spawn_origin, g_maximum_spawns
new Float: g_supply_spawns[128][3]
new const SUPPLYBOX_CONFIG_DIR[] = "%s/nano/supplybox/%s.cfg"
new SUPPLYBOX_CLASSNAME[] = "supplybox_nano"

//Sphere classname
new SPHERE_CLASSNAME[] = "stun_grenade"

//Mutation effect
new MUTATION_CLASSNAME[] = "mutation_effect"

//Knight effect
new KNIGHT_CLASSNAME[] = "monster_knight"

//Xeno mutant name
new XENO_CLASSNAME[] = "xeno_mutant"

//Client class setup
new bool: g_damage_set[MAXPLAYERS + 1]
new bool: g_transform_gear[MAXPLAYERS + 1]
new bool: g_soldier_deploy[MAXPLAYERS + 1]
new bool: g_player_joined[MAXPLAYERS + 1]
new bool: g_blade_skill[MAXPLAYERS + 1]
new bool: g_defence_finished[MAXPLAYERS + 1]
new bool: g_marked_to_death[MAXPLAYERS + 1]
new bool: g_instant_damage[MAXPLAYERS + 1]
new bool: g_mutant_skill[MAXPLAYERS + 1]
new bool: g_terminator_skill[MAXPLAYERS + 1]
new bool: g_hud_text_timeout[MAXPLAYERS + 1]
new bool: g_stun_grenade_received[MAXPLAYERS + 1]
new bool: g_player_first_spawn[MAXPLAYERS + 1]
new g_custom_player_model[MAXPLAYERS + 1][32]
new g_team[MAXPLAYERS + 1]
new g_mutant_vote[MAXPLAYERS + 1]
new g_mutant_level[MAXPLAYERS + 1]
new g_hit_count[MAXPLAYERS + 1]
new g_stungrenade_tick[MAXPLAYERS + 1]
new g_stungrenade_sound[MAXPLAYERS + 1]
new Float: g_PlayerKnockback[MAXPLAYERS + 1][3]

//Overall variables
new g_player_weaponstrip, g_player_equip, g_mutant_score, g_mercenary_score, g_player_amount, g_game_lock, g_count_down, g_round_status
new g_msgTeamScore, g_mercenary_level, g_level_stage, g_msgTextMsg, g_msgDeathMsg, g_msgScoreAttrib, g_msgTeamInfo, g_msgSendAudio
new g_msgArmorType, g_msgStatusIcon, g_msgVGUIMenu, g_msgShowMenu, g_msgMOTD, g_msgHostagePos, g_msgHostageK, g_global_msg, g_win_condition
new g_msgScreenShake, g_msgScreenFade, g_msgMoney, g_msgCrosshair

//Fog
#if defined WORLD_FOG

	new g_world_fog
	
#endif	

//Skill/flinch animation timer
new Float: g_skill_animation_time[MAXPLAYERS + 1] 
new Float: g_combo_animation_time[MAXPLAYERS + 1]
new Float: g_flinch_animation_time[MAXPLAYERS + 1]

//Gameplay task data
enum _: TASK_MANAGER (+= 100)
{
	TASK_ROUNDSTART = 4000,
	TASK_TEAM,
	TASK_FORCEWIN,
	TASK_CHECK_WIN,
	TASK_ROUNDSOUND,
	TASK_SPAWN_PLAYER,
	TASK_MUTANT_RESPAWN,
	TASK_MERCENARY_LEVEL,
	TASK_PROTECTION,
	TASK_MUTANT_SKILL,
	TASK_TERMINATOR_SKILL,
	TASK_TERMINATOR_SKILL_RELOAD,
	TASK_BOT_SKILL,
	TASK_REGISTER_PLAYER,
	TASK_HEARBEAT_SENSOR,
	TASK_SUPPLYBOX,
	TASK_STUNGRENADE,
	TASK_GLOBAL_TEXT_MSG,
	TASK_TEXT_MSG,
	TASK_BODY
}

//Class
enum _:USER_INFO_CLASS
{
	SOLDIERS = NULL,
	MUTANTS,
	GHOSTBLADE,
	TERMINATOR,
	ALL
}

//Round status
enum _:ROUND_STATUS
{
	ROUNDSTATUS_FREEZE = NULL,
	ROUNDSTATUS_COUNT,
	ROUNDSTATUS_START,
	ROUNDSTATUS_GHOSTBLADE,
	ROUNDSTATUS_END
}
	
//Teams
enum _:USER_INFO_TEAM
{
	TEAM_UNASSIGNED = NULL,
	TEAM_TERRORIST,
	TEAM_CT,
	TEAM_SPECTATOR
}

//Count connected
public client_putinserver(iPlayer)
{
	//Count all connecting people
	g_player_amount += 1;
	
	//Let it pass
	g_player_joined[iPlayer] = false;
	
	//Force soldiers team (maybe connected after mutation start?)
	g_team[iPlayer] = SOLDIERS;
	
	//is_user_alive still true at first connection
	g_player_first_spawn[iPlayer] = true;
}

//Store online
public client_disconnected(iPlayer)
{
	#define WIN_TIMER 1.0

	//Users disconnected
	g_player_amount -= 1;
	
	//Unlock var if noone is online
	if(g_player_amount < PLAYERS_GAME_START)
		g_game_lock = false;
	
	//Maybe last mutant or soldier will try to escape
	remove_task(TASK_CHECK_WIN);
	set_task(WIN_TIMER, "Task_CheckConnected", TASK_CHECK_WIN);
	
	#if defined DEBUG_INFO
	
		client_print(SEND_ALL, print_chat, "Left: %s, Round status: %d, Players: %d", GetPlayerName(iPlayer), g_round_status, g_player_amount);

	#endif
	
	//Player effects
	Remove_MonsterEntity(iPlayer);	
}