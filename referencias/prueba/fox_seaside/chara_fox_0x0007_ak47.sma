//Deploy
public HamF_AK47Deploy_Post(iEnt)
{
	static iPlayer;
	iPlayer = get_pdata_cbase(iEnt, m_pPlayer, CBASE_WEAPON);
	
	if(Is_Character_Fox(iPlayer))
		player_set_viewmodel(iPlayer, MDL_FOX_V_AK47, MDL_FOX_P_AK47);
}