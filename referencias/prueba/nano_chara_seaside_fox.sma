#include <amxmodx>
#include <fakemeta>
#include <hamsandwich>

#define PLUGIN "Character Fox Seaside"
#define VERSION "1.0"
#define AUTHOR "1xAero"

#include "ghostblade/ghostblade.inc"
#include "fox_seaside/chara_fox_0x0001_settings.sma"
#include "fox_seaside/chara_fox_0x0002_precache.sma"
#include "fox_seaside/chara_fox_0x0003_hamsandwich.sma"
#include "fox_seaside/chara_fox_0x0004_functions.sma"
#include "fox_seaside/chara_fox_0x0005_knife.sma"
#include "fox_seaside/chara_fox_0x0006_elite.sma"
#include "fox_seaside/chara_fox_0x0007_ak47.sma"
#include "fox_seaside/chara_fox_0x0008_mp5.sma"
#include "fox_seaside/chara_fox_0x0009_hegrenade.sma"
#include "fox_seaside/chara_fox_0x0010_smokegrenade.sma"
#include "fox_seaside/chara_fox_0x0011_natives.sma"

public plugin_init()
{
	//Externally called
	if(use_special_character())
	{
		register_plugin(PLUGIN, VERSION, AUTHOR);
	
		//Setup model
		RegisterHam(Ham_Spawn, "player", "HamF_PlayerSpawn_Post", TRUE);
	
		//Knife
		RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_knife", "HamF_WeaponKnife_PrimaryAttack_Post", TRUE);	
		RegisterHam(Ham_Weapon_SecondaryAttack, "weapon_knife", "HamF_WeaponKnife_SecondaryAttack_Post", TRUE);	
		RegisterHam(Ham_Item_Deploy, "weapon_knife", "HamF_KnifeDeploy_Post", TRUE);
	
		//Elite	
		RegisterHam(Ham_Item_Deploy, "weapon_elite", "HamF_EliteDeploy_Post", TRUE);
		
		//AK47
		RegisterHam(Ham_Item_Deploy, "weapon_ak47", "HamF_AK47Deploy_Post", TRUE);

		//MP5
		RegisterHam(Ham_Item_Deploy, "weapon_mp5navy", "HamF_MP5Deploy_Post", TRUE);		

		//Hegrenade
		RegisterHam(Ham_Item_Deploy, "weapon_hegrenade", "HamF_HeGrenadeDeploy_Post", TRUE);

		//Smokegrenade/Stun Grenade
		RegisterHam(Ham_Item_Deploy, "weapon_smokegrenade", "HamF_SmokeGrenadeDeploy_Post", TRUE);		
		
		//Agent
		register_clcmd("say fox", "Setup_Character");
		register_clcmd("radio1", "Play_WeaponAnimation");	
	}
}