//Deploy
public HamF_SmokeGrenadeDeploy_Post(iEnt)
{
	static iPlayer;
	iPlayer = get_pdata_cbase(iEnt, m_pPlayer, CBASE_WEAPON);
	
	if(Is_Character_Fox(iPlayer))
		player_set_viewmodel(iPlayer, MDL_FOX_V_SMOKEGRENADE, MDL_FOX_P_SMOKEGRENADE);
}