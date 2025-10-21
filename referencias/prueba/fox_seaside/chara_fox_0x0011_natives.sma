//External data
public plugin_natives()
{
	register_native("player_fox_seaside", "player_fox_seaside", TRUE);
	register_native("player_reset_agent", "player_reset_agent", TRUE);
}

//Return soldier
public player_fox_seaside(iPlayer)
	return Is_Character_Fox(iPlayer);

//Reset agent	
public player_reset_agent(iPlayer)
	set_character_fox[iPlayer] = false;	