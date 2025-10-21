#include <amxmodx>
#include <hamsandwich>

#include "ghostblade/ghostblade.inc"

#define PLUGIN "Game Rewards"
#define VERSION "1.0"
#define AUTHOR "1xAero"

#define MAXPLAYERS 32
#define TASK_TEXT_MSG 1280

#define FALSE 0
#define NULL 0

new bool: g_hud_text_timeout[MAXPLAYERS + 1]
new Float: g_damage[MAXPLAYERS + 1]
new MSG_HIT[128], MSG_DAMAGE[128]

public plugin_init()
{
	//English
	if(language_english())
	{
		MSG_HIT = "ENEMY HIT"
		MSG_DAMAGE = "FIVE HUNDRED DAMAGE"	
	}
	//Russian
	else
	{
		MSG_HIT = "МУТАНТ ПОЛУЧИЛ"
		MSG_DAMAGE = "ПЯТЬСОТ ЕДИНИЦ УРОНА"		
	}

	register_plugin(PLUGIN, VERSION, AUTHOR);
	
	//Register damage and bots
	RegisterHam(Ham_TakeDamage, "player", "HamF_TakeDamage", FALSE, true);
	
	register_event("HLTV", "Event_HLTV", "a", "1=0", "2=0");	
}	

//Damage setup
public HamF_TakeDamage(iVictim, Inflictor, iAttacker, Float: Damage, Damage_Type)
{
	#define MAX_DAMAGE 500.0
	#define DIFFERENCE 1.0
	#define RESET_DAMAGE 0.0

	if(!is_user_connected(iVictim) || !is_user_connected(iAttacker)) 
		return HAM_IGNORED;
		
	//Not apply against self
	if(iVictim == iAttacker) 
		return HAM_IGNORED;
	
	//Only for Survivors	
	if(iAttacker != player_soldier(iAttacker) && iAttacker != player_ghostblade(iAttacker))
		return HAM_IGNORED;
		
	g_damage[iAttacker] += Damage;

	if(g_damage[iAttacker] > MAX_DAMAGE - DIFFERENCE)
	{
		MSG_HudMessage(iAttacker, 150, 100, NULL, -1.0, 0.9, MSG_HIT, MSG_DAMAGE);
		g_damage[iAttacker] = RESET_DAMAGE;
	}

	return HAM_IGNORED;	
}

//Setting main rules
public Event_HLTV()
{
	for(new pPlayer = 1; pPlayer < MaxClients + 1; pPlayer ++)
		g_hud_text_timeout[pPlayer] = false;
}

stock MSG_HudMessage(iPlayer, Red, Green, Blue, Float: iX, Float: iY, const iInputBigFont[], const iInputSmallFont[])
{
	#define DRAW_MSG_TIME 5.5
	#define DRAW_MSG_DIFFERENCE 0.5
	#define OFFSET 0.03	
	
	if(g_hud_text_timeout[iPlayer])	
		return;
	
	g_hud_text_timeout[iPlayer] = true;

	set_dhudmessage(Red, Green, Blue, iX, iY - OFFSET, NULL, 0.5, DRAW_MSG_TIME - 0.5, 0.5, 0.5);
	show_dhudmessage(iPlayer, iInputBigFont);	
	
	set_hudmessage(100, 100, 100, iX, iY, NULL, 0.5, DRAW_MSG_TIME - DRAW_MSG_DIFFERENCE, 0.5, 0.5, 2);
	show_hudmessage(iPlayer, iInputSmallFont);

	set_task(DRAW_MSG_TIME, "Task_ResetTextMSG", iPlayer + TASK_TEXT_MSG);	
}

//Player index channel
public Task_ResetTextMSG(taskid)
{
	new iPlayer = taskid - TASK_TEXT_MSG;
	
	g_hud_text_timeout[iPlayer] = false;
}	