//External data
public plugin_natives()
{
	register_native("player_soldier", "player_soldier", TRUE);
	register_native("player_mutant", "player_mutant", TRUE);
	register_native("player_ghostblade", "player_ghostblade", TRUE);
	register_native("player_terminator", "player_terminator", TRUE);
	register_native("player_set_model", "player_set_model", TRUE);
	register_native("player_reset_model", "player_reset_model", TRUE);
	register_native("player_give_weapon", "player_give_weapon", TRUE);
	register_native("player_strip_slot", "player_strip_slot", TRUE);
	register_native("player_force_deploy", "player_force_deploy", TRUE);
	register_native("player_give_bpammo", "player_give_bpammo", TRUE);
	register_native("player_set_viewmodel", "player_set_viewmodel", TRUE);
	register_native("player_no_buyzone", "player_no_buyzone", TRUE);
	register_native("player_weaponstrip", "player_weaponstrip", TRUE);
	register_native("playsound_callback", "playsound_callback", TRUE);
	register_native("player_give_vesthelmet", "player_give_vesthelmet", TRUE);
	register_native("player_remove_armor", "player_remove_armor", TRUE);
	register_native("player_hide_money", "player_hide_money", TRUE);
	register_native("use_special_character", "use_special_character", TRUE);
	register_native("language_english", "language_english", TRUE);
}

//Return soldier
public player_soldier(iPlayer)
	return is_soldier(iPlayer);
	
//Return mutant	
public player_mutant(iPlayer)
	return is_mutant(iPlayer);

//Return Ghostblade	
public player_ghostblade(iPlayer)
	return is_ghostblade(iPlayer);

//Return Terminator	
public player_terminator(iPlayer)
	return is_terminator(iPlayer);	

//Set player model	
public player_set_model(iPlayer, const iModel[], iModelPath[128])
{
	#define MODEL_NAME 2
	#define MODEL_PATH 3

	//Convert external data
	param_convert(MODEL_NAME);
	param_convert(MODEL_PATH);
	
	set_player_model(iPlayer, iModel, iModelPath);
}

//Reset model
public player_reset_model(iPlayer)
	reset_player_model(iPlayer);
	
//Give named weapon	
public player_give_weapon(iPlayer, const iWeapon[])
{
	#define MODEL_CLASSNAME 2

	//Convert external data
	param_convert(MODEL_CLASSNAME);
	
	Ham_Give_Weapon(iPlayer, iWeapon);
}

//Set player model	
public player_strip_slot(iPlayer, iSlot)	
	Strip_Slot(iPlayer, iSlot);	

//Force update viewmodels	
public player_force_deploy(iPlayer)
	Execute_Ham_OnDeploy(iPlayer);

//Give Bpammo	
public player_give_bpammo(iPlayer, iAmount, bool: Restore)
	Refill_Ammunition(iPlayer, iAmount, Restore);

//Set player viewmodel
public player_set_viewmodel(iPlayer, const iModelViewmodel[], const iModelWeaponmodel[])
{
	#define MODEL_VIEWMODEL 2
	#define MODEL_WEAPONMODEL 3

	//Convert external data
	param_convert(MODEL_VIEWMODEL);
	param_convert(MODEL_WEAPONMODEL);

	SetPlayerViewmodel(iPlayer, iModelViewmodel, iModelWeaponmodel);
}

//Set no buy
public player_no_buyzone(iPlayer)
	Remove_BuySignal(iPlayer);

//Take everything
public player_weaponstrip(iPlayer)
	Remove_PlayerArmoury(iPlayer);

//Playsound	
public playsound_callback(iPlayer, const iSound[])
{
	#define SOUND_CACHE 2

	//Convert external data
	param_convert(SOUND_CACHE);

	PlaySound(iPlayer, iSound);
}	

//Armor data
public player_give_vesthelmet(iPlayer)
	Give_Armor(iPlayer);

//Remove armor	
public player_remove_armor(iPlayer)
	Remove_Armor(iPlayer);

//Hide Money	
public player_hide_money(iPlayer, bool: HideMoney)
	Hide_Money(iPlayer, HideMoney);
	
//Check, if usage is active and send info	
public bool: use_special_character()
{

	#if defined USE_SPECIAL_CHARACTER
	
		return true;
		
	#else

		return false;
		
	#endif
	
}	

//Return is english	
public bool: language_english()
{
	#if defined RUSSIAN_LANGUAGE
	
		return false;
		
	#else

		return true;
		
	#endif
}	