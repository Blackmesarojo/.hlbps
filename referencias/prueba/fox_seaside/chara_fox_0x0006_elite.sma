//Deploy
public HamF_EliteDeploy_Post(iEnt)
{
	static iPlayer;
	iPlayer = get_pdata_cbase(iEnt, m_pPlayer, CBASE_WEAPON);
	
	if(Is_Character_Fox(iPlayer))
		player_set_viewmodel(iPlayer, MDL_FOX_V_ELITE, MDL_FOX_P_ELITE);
}