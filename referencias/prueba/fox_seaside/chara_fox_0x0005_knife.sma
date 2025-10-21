//LMB
public HamF_WeaponKnife_PrimaryAttack_Post(iEnt)
{
	#define KNIFE_LMB_ATTACK 0.6
	#define KNIFE_LMB_SECONDARY 0.65
	#define KNIFE_LMB_IDLE 0.6

	static iPlayer;
	iPlayer = get_pdata_cbase(iEnt, m_pPlayer, CBASE_WEAPON);
	
	if(Is_Character_Fox(iPlayer))
	{
		set_pdata_float(iEnt, m_flNextPrimaryAttack, KNIFE_LMB_ATTACK, CBASE_WEAPON);
		set_pdata_float(iEnt, m_flNextSecondaryAttack, KNIFE_LMB_SECONDARY, CBASE_WEAPON);
		set_pdata_float(iEnt, m_flTimeWeaponIdle, KNIFE_LMB_IDLE, CBASE_WEAPON);
	}	
}

//RMB
public HamF_WeaponKnife_SecondaryAttack_Post(iEnt)
{
	#define KNIFE_RMB_ATTACK 1.6
	#define KNIFE_RMB_SECONDARY 1.6
	#define KNIFE_RMB_IDLE 1.6

	static iPlayer;
	iPlayer = get_pdata_cbase(iEnt, m_pPlayer, CBASE_WEAPON);
	
	if(Is_Character_Fox(iPlayer))
	{
		set_pdata_float(iEnt, m_flNextPrimaryAttack, KNIFE_RMB_ATTACK, CBASE_WEAPON);
		set_pdata_float(iEnt, m_flNextSecondaryAttack, KNIFE_RMB_SECONDARY, CBASE_WEAPON);
		set_pdata_float(iEnt, m_flTimeWeaponIdle, KNIFE_RMB_IDLE, CBASE_WEAPON);		
	}	
}

//Deploy
public HamF_KnifeDeploy_Post(iEnt)
{
	static iPlayer;
	iPlayer = get_pdata_cbase(iEnt, m_pPlayer, CBASE_WEAPON);
	
	if(Is_Character_Fox(iPlayer))
		player_set_viewmodel(iPlayer, MDL_FOX_V_KNIFE, MDL_FOX_P_KNIFE);
}