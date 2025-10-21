#define MSG_ARG_1 1
#define MSG_ARG_2 2
#define MSG_ARG_4 4

//Prevent mutants, Ghostblades and Armored Terminators from buying
public Message_StatusIcon(MsgId, MsgDest, iPlayer)
{
	#define MAX_CHAR 7

	if(is_user_alive(iPlayer))
	{
		//Ignore Bot from buying items, Mutants, Ghostblades, Terminators, Special characters
		if(is_restricted_character(iPlayer, true))
		{	
			static szIcon[8];
			get_msg_arg_string(MSG_ARG_2, szIcon, MAX_CHAR);
 
			if(equal(szIcon, "buyzone") && get_msg_arg_int(MSG_ARG_1))
			{
				set_pdata_int(iPlayer, m_signals, get_pdata_int(iPlayer, m_signals) & ~(1 << 0));
			
				return PLUGIN_HANDLED;
			}
		}	
	}
	
	return PLUGIN_CONTINUE;
}

//Reset round if restart or on game commencing
public Message_TextMsg()
{
	static textmsg[22];
	get_msg_arg_string(MSG_ARG_2, textmsg, charsmax(textmsg));
	
	if(equal(textmsg, "#Game_will_restart_in"))
	{
		//Force settings again, if changed
		Setup_Multiplayer();	
	
		g_mutant_score = NULL;
		g_mercenary_score = NULL;
		
		return PLUGIN_HANDLED;
	}
	
	//Should never happen
	else if(equal(textmsg, "#Game_Commencing"))
	{
		Setup_Multiplayer();
	
		return PLUGIN_HANDLED;
	}		
	
	else if(equal(textmsg, "#Hostages_Not_Rescued") || equal(textmsg, "#Round_Draw"))
		return PLUGIN_HANDLED;
		
	else if(equal(textmsg, "#Terrorists_Win") || equal(textmsg, "#CTs_Win"))
		return PLUGIN_HANDLED;		
		
	return PLUGIN_CONTINUE;
}

//Block audio messages
public Message_SendAudio()
	return PLUGIN_HANDLED;

//Scores
public Message_TeamScore()
{
	static szTeam[3];
	get_msg_arg_string(MSG_ARG_1, szTeam, charsmax(szTeam));
	
	switch(szTeam[0])
	{
		case 'T': set_msg_arg_int(MSG_ARG_2, ARG_SHORT, g_mutant_score);
		case 'C': set_msg_arg_int(MSG_ARG_2, ARG_SHORT, g_mercenary_score);
	}
}

//Hit head/neck stream
public Message_BloodStream() 
{
	static g_msgArg; 
	g_msgArg = get_msg_arg_int(MSG_ARG_1);

	if(g_msgArg == TE_BLOODSTREAM)
		return PLUGIN_HANDLED;

	return PLUGIN_CONTINUE;
}

//VGUI
public Message_VGUIMenu(MsgId, MsgDest, iPlayer)
{
	#define TEAM_VGUI_MENU 2
	#define TERRORIST_MENU 26
	#define CT_MENU 27

	switch(get_msg_arg_int(MSG_ARG_1))
	{
		//Block VGUI Team/Class selection
		case TEAM_VGUI_MENU, TERRORIST_MENU, CT_MENU: return PLUGIN_HANDLED;
		default: return PLUGIN_CONTINUE;
	}	

	return PLUGIN_CONTINUE;
}

//Text Menu
public Message_ShowMenu(MsgId, MsgDest, iPlayer)
{	
	//Collect tags
	static HeaderTags[]= 
	{
		"#Team_Select", 
		"#Terrorist_Select", 
		"#CT_Select",
		"#RadioA",
		"#RadioB",
		"#RadioC"	
	}
		
	//Block Old Style Header (Team Menu, Terrorist, CT)	
	for(new iHeader; iHeader < sizeof HeaderTags; iHeader ++)
	{
		static Header_Menu[sizeof HeaderTags];
		get_msg_arg_string(MSG_ARG_4, Header_Menu, sizeof HeaderTags - 1);	
	
		if(equal(Header_Menu, HeaderTags[iHeader]))
			return PLUGIN_HANDLED;
	}		

	return PLUGIN_CONTINUE;
}

//Block MOTD and set manual spawn
public Message_MOTD(MsgId, MsgDest, iPlayer)
{
	#define SPAWN_DELAY 0.1
	#define REGISTER_USER_TIMER 0.1

	//Automatically spawn/join
	if(!is_user_bot(iPlayer))
	{		
		remove_task(iPlayer + TASK_SPAWN_PLAYER);
		set_task(SPAWN_DELAY, "Spawn_Player", iPlayer + TASK_SPAWN_PLAYER);
	}
	
	//Register connected player
	remove_task(iPlayer + TASK_REGISTER_PLAYER);
	set_task(REGISTER_USER_TIMER, "Task_FixScoreboard", iPlayer + TASK_REGISTER_PLAYER);	
	
	return PLUGIN_HANDLED;
}

//Hide money for specific characters
public Message_Money(MsgId, MsgDest, iPlayer)
{
	if(!is_user_bot(iPlayer) && is_restricted_character(iPlayer, false))
	{
		static g_msgArg; 
		g_msgArg = get_msg_arg_int(MSG_ARG_1);		
	
		set_msg_arg_int(MSG_ARG_1, ARG_BYTE, g_msgArg | HIDEHUD_MONEY);
	}
}