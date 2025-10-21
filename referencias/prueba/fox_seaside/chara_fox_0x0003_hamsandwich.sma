//Apply on post
public HamF_PlayerSpawn_Post(iPlayer)
{
	//Only once per spawn
	if(player_soldier(iPlayer))
		character_setup[iPlayer] = false;
	
	//Only if this character
	if(Is_Character_Fox(iPlayer))
		Change_Agent(iPlayer);		
}