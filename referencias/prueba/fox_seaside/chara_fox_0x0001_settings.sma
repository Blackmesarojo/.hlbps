//Character model
#define MDL_FOX_SEASIDE "models/player/fox_seaside/fox_seaside.mdl"

//Knife
#define MDL_FOX_V_KNIFE "models/ghostblade/fox_seaside/v_knife.mdl"
#define MDL_FOX_P_KNIFE "models/ghostblade/fox_seaside/p_knife.mdl"

//Elite
#define MDL_FOX_V_ELITE "models/ghostblade/fox_seaside/v_elite.mdl"
#define MDL_FOX_P_ELITE "models/ghostblade/fox_seaside/p_elite.mdl"

//AK47
#define MDL_FOX_V_AK47 "models/ghostblade/fox_seaside/v_ak47.mdl"
#define MDL_FOX_P_AK47 "models/ghostblade/fox_seaside/p_ak47.mdl"

//MP5
#define MDL_FOX_V_MP5 "models/ghostblade/fox_seaside/v_mp5.mdl"
#define MDL_FOX_P_MP5 "models/ghostblade/fox_seaside/p_mp5.mdl"

//Hegrenade
#define MDL_FOX_V_HEGRENADE "models/ghostblade/fox_seaside/v_hegrenade.mdl"
#define MDL_FOX_P_HEGRENADE "models/ghostblade/fox_seaside/p_hegrenade.mdl"

//Smokegrenade
#define MDL_FOX_V_SMOKEGRENADE "models/ghostblade/fox_seaside/v_smokegrenade.mdl"
#define MDL_FOX_P_SMOKEGRENADE "models/ghostblade/fox_seaside/p_smokegrenade.mdl"

//Precache hegrenade sounds
#define HE_PREFIRE_SND "ghostblade/fox_seaside/weapon/grenade_prefire.wav"
#define HE_FIRE_SND "ghostblade/fox_seaside/weapon/grenade_fire.wav"
#define HE_SELECT_SND "ghostblade/fox_seaside/weapon/grenade_select.wav"

//Safe data
#define PDATA_SAFE 2
#define NULL 0
#define NULLENT -1

#define FALSE 0
#define TRUE 1

#define MAXPLAYERS 32

//Linux diff
#define CBASE_WEAPON 4
#define CBASE_PLAYER 5

//Offsets
stock m_iId = 43 //int
stock m_pPlayer = 41 //CBasePlayer *
stock m_pActiveItem = 373 //CBasePlayerItem *
stock m_flNextPrimaryAttack = 46 //float
stock m_flNextSecondaryAttack = 47 //float
stock m_flTimeWeaponIdle = 48 //float
stock m_fInReload = 54 //int

//Only for this character
new bool: set_character_fox[MAXPLAYERS + 1]
new bool: character_setup[MAXPLAYERS + 1]

public client_disconnected(iPlayer)
{
	character_setup[iPlayer] = false;
	set_character_fox[iPlayer] = false;
}