#include <amxmodx> 
#include <fakemeta>
#include <fakemeta_util>
#include <hamsandwich> 
#include <engine>
#include <xs>

#if AMXX_VERSION_NUM < 183
#define MAX_PLAYERS    			32 
#define client_disconnected 		client_disconnect
#endif

#define OFFSET_ARMOR_TYPE    		112
#define HEADSHOT_ANIM			104
#define OFFSET_SILENCER_FIREMODE    	74
#define OFFSET_WEAPONTYPE           	43
#define MIN_THICKNESS			192
#define FAMAS_BURSTMODE                 16
#define HIT_SHIELD			8
#define GLOCK_BURSTMODE                 2  
#define KEVLAR				1
#define HELMET				2
#define DEFAULT_DISTANCE		16000

#define M4A1_SILENCED			(1<<2)
#define USP_SILENCED			(1<<0)
#define fm_get_weapon_id(%1) 		get_pdata_int(%1, OFFSET_WEAPONTYPE, XTRA_OFS_WEAPON)
					
const INVALID_WEAPONS =			(1 << CSW_KNIFE)|(1 << CSW_C4)|(1 << CSW_HEGRENADE)|(1 << CSW_FLASHBANG)|(1 << CSW_SMOKEGRENADE)
const CONST_PENETRABLE =		(1 << CSW_DEAGLE)|(1 << CSW_AUG)|(1 << CSW_GALIL)|(1 << CSW_FAMAS)|
					(1 << CSW_M4A1)|(1 << CSW_SG552)|(1 << CSW_AK47)|(1 << CSW_SCOUT)|
					(1 << CSW_M249)|(1 << CSW_SG550)|(1 << CSW_G3SG1)|(1 << CSW_AWP)
					
const XTRA_OFS_WEAPON =			4
const XTRAS_OFS_PLAYER =		5

const m_pPlayer =			41
const m_fInReload = 			54
const m_fInSpecialReload = 		55
const m_flTimeWeaponIdle = 		48
const m_pHeadShot =			75
const m_pActiveItem =			373

const Float:g_fPenetrableDiv =		0.70
const Float:g_fHelmetArmorDiv =		0.75
const Float:g_fKevlarArmorDiv =		0.65

new const g_szGunsEvents[][] = 
{
        "events/awp.sc",
        "events/g3sg1.sc",
        "events/ak47.sc",
        "events/scout.sc",
        "events/m249.sc",
        "events/m4a1.sc",
        "events/sg552.sc",
        "events/aug.sc",
        "events/sg550.sc",
        "events/m3.sc",
        "events/xm1014.sc",
        "events/usp.sc",
        "events/mac10.sc",
        "events/ump45.sc",
        "events/fiveseven.sc",
        "events/p90.sc",
        "events/deagle.sc",
        "events/p228.sc",
        "events/glock18.sc",
        "events/mp5n.sc",
        "events/tmp.sc",
        "events/elite_left.sc",
        "events/elite_right.sc",
        "events/galil.sc",
        "events/famas.sc"
}

new const g_szDeploySounds[][] =
{
	"",
	"sound/weapons/p228_slidepull.wav",
	"",
	"",
	"",
	"",
	"",
	"sound/weapons/mac10_boltpull.wav",
	"sound/weapons/aug_forearm.wav",
	"",
	"sound/weapons/elite_deploy.wav",
	"sound/weapons/fiveseven_slidepull.wav",
	"",
	"",
	"sound/weapons/galil_boltpull.wav",
	"sound/weapons/famas_forearm.wav",
	"sound/weapons/usp_slideback.wav",
	"", // glock aq
	"",
	"sound/weapons/mp5_slideback.wav",
	"sound/weapons/m249_chain.wav",
	"sound/weapons/m3_pump.wav",
	"sound/weapons/m4a1_deploy.wav",
	"",
	"",
	"",
	"",
	"sound/weapons/sg552_boltpull.wav",
	"sound/weapons/ak47_boltpull.wav",
	"",
	"sound/weapons/p90_boltpull.wav"
}

new const g_szSoundReload[] = 		"weapons/generic_reload.wav"
new const g_szCameraModel[] =		"sprites/radio.spr"
new const g_szCameraClass[] =		"cam_class"

new pCvarCameraDistance, pCvarCameraRight
new pCvarCameraUp, pCvarCameraFraction
new pCvarPointerFF

new g_iGunsEventsBitsum, g_forwardPrecacheEvent
new g_mMessageDeathMsg, g_iSmokeID

new g_bBypassEntity[MAX_PLAYERS + 1], g_iUserCamera[MAX_PLAYERS + 1]
new g_iEntityEndPosition[MAX_PLAYERS + 1], g_iHitGroup[MAX_PLAYERS + 1], Float:g_fEntityEndPosition[MAX_PLAYERS + 1][3]
new g_szWeaponSoundFmt[36][64], g_szWeaponDifferent[4][64]

public plugin_init() 
{ 
	static const Version[] = "1.3"
	register_plugin("Third Person Camera", Version, "EFFEX") 

	register_cvar("thirdcam_version", Version, FCVAR_SERVER|FCVAR_SPONLY)

	pCvarCameraDistance = register_cvar("tpcamera_distance", "-110.0")
	pCvarCameraRight = register_cvar("tpcamera_right", "25.0")
	pCvarCameraUp = register_cvar("tpcamera_up", "35.0")
	pCvarCameraFraction = register_cvar("tpcamera_fraction", "-105.0")
	
	new szWeaponName[20]
	for(new i = CSW_P228;i <= CSW_P90;i++)
	{
		if((1 << i) & INVALID_WEAPONS)
			continue
        
		if(get_weaponname(i, szWeaponName, charsmax(szWeaponName)))
		{
			RegisterHam(Ham_Item_Deploy, szWeaponName, "FwdHamWeaponDeploy", 1)
			
			if((i == CSW_M3) || (i == CSW_XM1014))
				continue
				
			RegisterHam(Ham_Weapon_Reload, szWeaponName, "FwdHamWeaponReload", 1)
		}
	}
	g_mMessageDeathMsg = get_user_msgid("DeathMsg")
	
	RegisterHam(Ham_Spawn, "player", "CBasePlayer_Spawn_Post", 1) 
	RegisterHam(Ham_Weapon_Reload, "weapon_m3",     "FwdHamShotgunReload", 1)
	RegisterHam(Ham_Weapon_Reload, "weapon_xm1014", "FwdHamShotgunReload", 1)

	RegisterHam(Ham_TraceAttack, "func_breakable", "Ham_PlayerTraceAttack")
	RegisterHam(Ham_TraceAttack, "worldspawn", "Ham_PlayerTraceAttack")
	RegisterHam(Ham_TraceAttack, "player", "Ham_PlayerTraceAttack")
	RegisterHam(Ham_TakeDamage, "player", "ham_TakeDamage_Pre")
	
	register_think(g_szCameraClass, "Camera_Think")

	register_forward(FM_SetView, "fw_SetView", true)
	register_forward(FM_UpdateClientData, "fw_UpdateClientData_Post", 1)
	register_forward(FM_PlaybackEvent, "fw_PlaybackEvent")

	unregister_forward(FM_PrecacheEvent, g_forwardPrecacheEvent, 1)

	pCvarPointerFF = get_cvar_pointer("mp_friendlyfire")
}

public plugin_precache()
{
	for(new i;i < sizeof g_szDeploySounds;i++)
	{
		if(!g_szDeploySounds[i][0])
			continue
			
		precache_generic(g_szDeploySounds[i])
	}
    
	for(new iWeapon = CSW_P228;iWeapon <= CSW_P90;iWeapon++)
	{
		if(INVALID_WEAPONS & (1 << iWeapon))
			continue
        
		checkAndPrecacheWeapons(iWeapon)
	}
	
	g_iSmokeID = 			precache_model("sprites/richo2.spr")
	g_forwardPrecacheEvent = 	register_forward(FM_PrecacheEvent, "fw_PrecacheEvent", 1)

	precache_model(g_szCameraModel)
	precache_sound(g_szSoundReload)
}

public client_putinserver(id) g_iUserCamera[id] = 0

public plugin_pause()
{
	new iPlayers[MAX_PLAYERS], iNum
	get_players(iPlayers, iNum, "ach")
	for(new i, iPlayer;i < iNum;i++)
	{
		iPlayer = iPlayers[i]
		if(g_iUserCamera[iPlayer] && pev_valid(g_iUserCamera[iPlayer]))
		{
			attach_view(iPlayer, iPlayer)
		}
	}
}

public plugin_unpause()
{
	new iPlayers[MAX_PLAYERS], iNum
	get_players(iPlayers, iNum, "ach")
	for(new i, iPlayer;i < iNum;i++)
	{
		iPlayer = iPlayers[i]
		if(g_iUserCamera[iPlayer] && pev_valid(g_iUserCamera[iPlayer]))
		{
			attach_view(iPlayer, g_iUserCamera[iPlayer])
		}
	}
}

public fw_SetView(iPlayer, iEntity)
{
	if(!is_user_alive(iPlayer))
		return FMRES_IGNORED
		
	new szClass[MAX_PLAYERS]
	pev(iEntity, pev_classname, szClass, charsmax(szClass))
	if(equal(szClass, "trigger_camera"))
		return FMRES_IGNORED

	attach_view(iPlayer, g_iUserCamera[iPlayer])
	return FMRES_SUPERCEDE
}

public fw_PrecacheEvent(iType, const szName[]) 
{
	for(new i;i < sizeof g_szGunsEvents;++i) 
	{
		if(equal(g_szGunsEvents[i], szName)) 
		{
                        g_iGunsEventsBitsum |= (1 << get_orig_retval())
                        return FMRES_HANDLED
		}
        }
        return FMRES_IGNORED
}

public fw_PlaybackEvent(flags, iInvoker, iEventId) 
{
	if(!(g_iGunsEventsBitsum & (1 << iEventId)) || !is_user_connected(iInvoker))
                return FMRES_IGNORED
		
	new iWeaponID = get_user_weapon(iInvoker)
	if(!iWeaponID)
		return FMRES_HANDLED
		
	new iWeaponEnt = get_pdata_cbase(iInvoker, m_pActiveItem, XTRAS_OFS_PLAYER), szSound[64]
	if(isWeaponSilenced(iWeaponEnt))
	{
		if(iWeaponID == CSW_USP)
		{
			copy(szSound, charsmax(szSound), g_szWeaponDifferent[0])
		}
		else if(iWeaponID == CSW_M4A1)
		{
			copy(szSound, charsmax(szSound), g_szWeaponDifferent[1])
		}
	}
	else if(isWeaponOnBurstMode(iWeaponEnt))
	{
		if(iWeaponID == CSW_GLOCK18)
		{
			copy(szSound, charsmax(szSound), g_szWeaponDifferent[2])
		}
		else if(iWeaponID == CSW_FAMAS)
		{
			copy(szSound, charsmax(szSound), g_szWeaponDifferent[3])
		}
	}
	else copy(szSound, charsmax(szSound), g_szWeaponSoundFmt[iWeaponID])
	emit_sound(iInvoker, CHAN_WEAPON, szSound, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	return FMRES_IGNORED
}

public fw_UpdateClientData_Post(id, sendweapons, cd_handle)
{
	if(!is_user_alive(id))
		return FMRES_IGNORED	
		
	set_cd(cd_handle, CD_flNextAttack, get_gametime() + 0.001) 
	return FMRES_HANDLED
}

public FwdHamWeaponDeploy(const iWeapon)
{
	static id;id = get_pdata_cbase(iWeapon, m_pPlayer, XTRA_OFS_WEAPON)
	if(!is_user_connected(id))
		return HAM_IGNORED
		
	client_cmd(id, "spk ^"%s^"", g_szDeploySounds[fm_get_weapon_id(iWeapon)])
	return HAM_IGNORED
}

public FwdHamWeaponReload(const iWeapon)
{
	if(get_pdata_int(iWeapon, m_fInReload, XTRA_OFS_WEAPON))
	{
		emit_sound(get_pdata_cbase(iWeapon, m_pPlayer, XTRA_OFS_WEAPON), CHAN_ITEM, g_szSoundReload, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	}
}

public FwdHamShotgunReload(const iWeapon)
{
	if(get_pdata_int(iWeapon, m_fInSpecialReload, XTRA_OFS_WEAPON) != 1)
		return HAM_IGNORED

	new Float:flTimeWeaponIdle = get_pdata_float(iWeapon, m_flTimeWeaponIdle, XTRA_OFS_WEAPON)
	if(flTimeWeaponIdle != 0.55)
		return HAM_IGNORED
		
	emit_sound(get_pdata_cbase(iWeapon, m_pPlayer, XTRA_OFS_WEAPON), CHAN_WEAPON, g_szSoundReload, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	return HAM_IGNORED
}

// https://forums.alliedmods.net/showpost.php?p=807584&postcount=9 
public CBasePlayer_Spawn_Post(id) 
{ 
	if(!is_user_alive(id) || is_user_bot(id)) 
		return 
	
	if(pev_valid(g_iUserCamera[id]))
	{
		attach_view(id, g_iUserCamera[id])
		return
	}
	
	new iEnt = create_entity("info_target")
	if(!pev_valid(iEnt))
		return
    
	g_iUserCamera[id] = iEnt

	entity_set_string(iEnt, EV_SZ_classname, g_szCameraClass)
	entity_set_model(iEnt, g_szCameraModel)
	entity_set_byte(iEnt, EV_INT_solid, SOLID_TRIGGER)
	entity_set_int(iEnt, EV_INT_movetype, MOVETYPE_FLYMISSILE)
	entity_set_edict(iEnt, EV_ENT_owner, id)
	entity_set_int(iEnt, EV_INT_rendermode, kRenderTransTexture)
	entity_set_float(iEnt, EV_FL_renderamt, 0.0)
   
	attach_view(id, iEnt)
	entity_set_float(iEnt, EV_FL_nextthink, get_gametime())
} 

new bool:g_bDamageByPass[MAX_PLAYERS + 1]
public ham_TakeDamage_Pre(iVictim, iInflictor, iAttacker, Float:fDamage, iDamageBits)
{
	if(!is_user_connected(iAttacker) || !is_user_connected(iVictim) || is_user_bot(iAttacker))
		return HAM_IGNORED
		
	if((get_user_weapon(iAttacker) == CSW_KNIFE) || g_bDamageByPass[iAttacker])
		return HAM_IGNORED
	
	SetHamReturnInteger(0)
	return HAM_SUPERCEDE
}

public Ham_PlayerTraceAttack(iVictim, iAttacker, Float:fDamage, Float:dir[3], ptr, bits)
{
	if(!is_user_connected(iAttacker) || is_user_bot(iAttacker))
		return HAM_IGNORED
		
	if(get_user_weapon(iAttacker) == CSW_KNIFE)
		return HAM_IGNORED

	static iActualVictim;iActualVictim = g_iEntityEndPosition[iAttacker]
	if(!is_user_alive(iActualVictim) && !is_user_alive(iVictim))
	{
		static Float:fStart[3], Float:fHitPoint[3]
		pev(iAttacker, pev_origin, fStart)
		engfunc(EngFunc_TraceLine, fStart, g_fEntityEndPosition[iAttacker], 0, iAttacker, 0)

		if(is_user_alive((g_iEntityEndPosition[iAttacker] = get_tr2(0, TR_pHit))))
		{
			iActualVictim = g_iEntityEndPosition[iAttacker]
			g_iHitGroup[iAttacker] = get_tr2(0, TR_iHitgroup)
		}
		else
		{
			get_tr2(0, TR_vecEndPos, fHitPoint)
			bulletHitDecals(fHitPoint)
			
			if(pev_valid(iActualVictim) && (pev(iActualVictim, pev_takedamage) != DAMAGE_NO))
			{
				ExecuteHamB(Ham_TakeDamage, iActualVictim, iAttacker, iAttacker, fDamage, DMG_BULLET)
			}
			return HAM_IGNORED
		}
	}
	
	if(!is_user_connected(iActualVictim))
		return HAM_IGNORED
		
	new bool:bSameTeam = bool:(get_user_team(iActualVictim) == get_user_team(iAttacker)), Float:fActualDamage = fDamage
	if(bSameTeam && !get_pcvar_num(pCvarPointerFF))
		return HAM_IGNORED
		
	new bool:bHeadShot = bool:(g_iHitGroup[iAttacker] == HIT_HEAD)
	fActualDamage = multiplyDamage(iActualVictim, fDamage, g_iHitGroup[iAttacker], bSameTeam)
	if(g_bBypassEntity[iAttacker])
	{
		fActualDamage *= g_fPenetrableDiv
	}
	
	if(floatround(fActualDamage) >= get_user_health(iActualVictim))
	{
		static Float:fUserGameTime[MAX_PLAYERS + 1], Float:fGameTime;fGameTime = get_gametime()
		if((fGameTime - fUserGameTime[iAttacker]) > 0.1)
		{
			fUserGameTime[iAttacker] = fGameTime
		
			set_msg_block(g_mMessageDeathMsg, BLOCK_SET)
			set_pdata_int(iActualVictim, m_pHeadShot, bHeadShot ? HIT_HEAD : 0)
			ExecuteHamB(Ham_Killed, iActualVictim, iAttacker, 1)
			
			if(bHeadShot)
			{
				entity_set_int(iActualVictim, EV_INT_sequence, HEADSHOT_ANIM)
			}
		
			new szWeapon[MAX_PLAYERS]
			get_weaponname(get_user_weapon(iAttacker), szWeapon, charsmax(szWeapon))
			make_deathmsg(iAttacker, iActualVictim, bHeadShot, szWeapon[7])
			set_msg_block(g_mMessageDeathMsg, BLOCK_NOT)
		}
	}
	else
	{
		if(g_iHitGroup[iAttacker] == HIT_SHIELD)
		{
			createSparks(g_fEntityEndPosition[iAttacker])
		}
		else
		{
			static Float:fStart[3], Float:fEnd[3]
			pev(iAttacker, pev_origin, fStart)
			pev(iActualVictim, pev_origin, fEnd)
			engfunc(EngFunc_TraceLine, fStart, fEnd, 0, iAttacker, 0)
			if(g_bBypassEntity[iAttacker] || get_tr2(0, TR_pHit, fEnd) == iActualVictim)
			{
				if(g_bBypassEntity[iAttacker])
				{
					bulletHitDecals(g_fEntityEndPosition[iAttacker])
				}

				g_bDamageByPass[iAttacker] = true
				ExecuteHamB(Ham_TakeDamage, iActualVictim, iAttacker, iAttacker, fActualDamage, DMG_BULLET)
				g_bDamageByPass[iAttacker] = false
			}
		}
	}
	g_bBypassEntity[iAttacker] = false
	return HAM_IGNORED
}

#include <csx>
public grenade_throw(id, grenIndex, weapIndex)
{
	switch(weapIndex)
	{
		case CSW_HEGRENADE, CSW_FLASHBANG, CSW_SMOKEGRENADE:
		{
			static Float:fOrigin[3], Float:vVelocity[3]
			pev(id, pev_origin, fOrigin)
			entity_get_vector(grenIndex, EV_VEC_velocity, vVelocity)
			getSpeedVector(fOrigin, g_fEntityEndPosition[id], vector_length(vVelocity), vVelocity)
			set_pev(grenIndex, pev_velocity, vVelocity)
		}
	}
}

getSpeedVector(const Float:origin1[3],const Float:origin2[3], Float:speed, Float:new_velocity[3])
{
	xs_vec_sub(origin2, origin1, new_velocity)
	new Float:num = floatsqroot(speed * speed / (new_velocity[0] * new_velocity[0] + new_velocity[1] * new_velocity[1] + new_velocity[2] * new_velocity[2]))
	xs_vec_mul_scalar(new_velocity, num, new_velocity)
}

Float:multiplyDamage(iVictim, Float:fDamage, iHitGroup, bSameTeam) // well
{
	new iUserArmorType = get_pdata_int(iVictim, OFFSET_ARMOR_TYPE)
	if(iHitGroup == HIT_HEAD)
	{
		if(iUserArmorType == HELMET)	
		{
			fDamage *= g_fHelmetArmorDiv
		}
		else fDamage *= 3.0
	}
	else if((iHitGroup == HIT_CHEST) || (iHitGroup == HIT_STOMACH))
	{
		if(iUserArmorType == KEVLAR)
		{
			fDamage *= g_fKevlarArmorDiv
		}
		else fDamage *= 1.1
	}	

	if(bSameTeam) fDamage /= 2.0
	return fDamage
}

public Camera_Think(iEnt) 
{ 
	static iOwner;iOwner = entity_get_edict(iEnt, EV_ENT_owner)
	if(!is_user_alive(iOwner))
	{
		if(is_user_connected(iOwner))
		{
			g_iUserCamera[iOwner] = 0
			attach_view(iOwner, iOwner)
		}
		remove_entity(iEnt)
		return PLUGIN_CONTINUE
	}
	
	static Float:fPlayerOrigin[3], Float:fAngle[3], Float:fCameraOrigin[3], Float:fPlayerVel[3]
	entity_get_vector(iOwner, EV_VEC_origin, fPlayerOrigin)
	entity_get_vector(iOwner, EV_VEC_v_angle, fAngle)
	
	// https://forums.alliedmods.net/showpost.php?p=1532905&postcount=51
	static Float:fVBack[3], Float:fVecRight[3], Float:fVecUp[3]
	angle_vector(fAngle, ANGLEVECTOR_FORWARD, fVBack)
	angle_vector(fAngle, ANGLEVECTOR_RIGHT, fVecRight) 
	angle_vector(fAngle, ANGLEVECTOR_UP, fVecUp) 
	
	fCameraOrigin[0] = fPlayerOrigin[0] + fVBack[0] * get_pcvar_float(pCvarCameraDistance) + fVecRight[0] * get_pcvar_float(pCvarCameraRight) + fVecUp[0] * get_pcvar_float(pCvarCameraUp) 
	fCameraOrigin[1] = fPlayerOrigin[1] + fVBack[1] * get_pcvar_float(pCvarCameraDistance) + fVecRight[1] * get_pcvar_float(pCvarCameraRight) + fVecUp[1] * get_pcvar_float(pCvarCameraUp) 
	fCameraOrigin[2] = fPlayerOrigin[2] + fVBack[2] * get_pcvar_float(pCvarCameraDistance) + fVecRight[2] * get_pcvar_float(pCvarCameraRight) + fVecUp[2] * get_pcvar_float(pCvarCameraUp) 
	
	engfunc(EngFunc_TraceLine, fPlayerOrigin, fCameraOrigin, IGNORE_MONSTERS, iOwner, 0) 
	
	static Float:flFraction 
	get_tr2(0, TR_flFraction, flFraction) 
	if(flFraction != 1.0) // adjust camera place if close to a wall 
	{ 
		flFraction *= get_pcvar_float(pCvarCameraFraction)
		
		fCameraOrigin[0] = fPlayerOrigin[0] + (fVBack[0] * flFraction) 
		fCameraOrigin[1] = fPlayerOrigin[1] + (fVBack[1] * flFraction) 
		fCameraOrigin[2] = fPlayerOrigin[2] + (fVBack[2] * flFraction) 
	} 
	trace_line(iOwner, fPlayerOrigin, fCameraOrigin, fCameraOrigin)

	entity_set_vector(iEnt, EV_VEC_origin, fCameraOrigin)
	entity_get_vector(iOwner, EV_VEC_velocity, fPlayerVel)
	entity_set_vector(iEnt, EV_VEC_velocity, fPlayerVel)
	entity_set_vector(iEnt, EV_VEC_angles, fAngle)
	entity_set_vector(iEnt, EV_VEC_v_angle, fAngle)

	entity_set_vector(iOwner, EV_VEC_angles, fAngle)
	entity_set_vector(iOwner, EV_VEC_v_angle, fAngle)

	entity_set_float(iEnt, EV_FL_nextthink, get_gametime())
	getAimEndPosition(iEnt, iOwner, fCameraOrigin)
	return PLUGIN_CONTINUE
}  

getAimEndPosition(iEnt, iPlayer, Float:fStart[3]) 
{
	static Float:fEnd[3]
	xs_vec_copy(fStart, fEnd)
	originUnitsAhead(iEnt, fEnd, DEFAULT_DISTANCE)
	
	new trace = create_tr2()
	engfunc(EngFunc_TraceLine, fStart, fEnd, 0, iEnt, trace)
	
	g_iEntityEndPosition[iPlayer] = get_tr2(trace, TR_pHit)
	g_iHitGroup[iPlayer] = get_tr2(trace, TR_iHitgroup)
	trace_line(iEnt, fStart, fEnd, g_fEntityEndPosition[iPlayer])

	new iLastEnt = g_iEntityEndPosition[iPlayer]
	if(!is_user_alive(iLastEnt) && (1 << get_user_weapon(iPlayer) & CONST_PENETRABLE))
	{
		if(getWallThickness(iEnt) > MIN_THICKNESS)
			return

		static Float:fNewStart[3]
		xs_vec_copy(g_fEntityEndPosition[iPlayer], fNewStart)
		originUnitsAhead(iEnt, fNewStart, getWallThickness(iEnt))
		
		new trace2 = create_tr2()
		engfunc(EngFunc_TraceLine, fNewStart, fEnd, 0, iEnt, trace2)
		
		if(is_user_alive((g_iEntityEndPosition[iPlayer] = get_tr2(trace2, TR_pHit))))
		{
			g_bBypassEntity[iPlayer] = true
			g_iHitGroup[iPlayer] = get_tr2(trace2, TR_iHitgroup)
		}
	}
}

getWallThickness(const player)
{
	new Float:source[3], Float:direction[3], Float:end[3]
	new Float:fraction
	
	pev(player, pev_origin, source)
	pev(player, pev_view_ofs, direction)
	xs_vec_add(source, direction, source)
	
	pev(player, pev_v_angle, direction)
	engfunc(EngFunc_MakeVectors, direction)
	global_get(glb_v_forward, direction)
	
	xs_vec_mul_scalar(direction, 9999.0, end)
	xs_vec_add(source, end, end)
	
	engfunc(EngFunc_TraceLine, source, end, IGNORE_MONSTERS, player, 0)
	get_tr2(0, TR_flFraction, fraction)
	if(fraction == 1.0)
	{
		return 0
	}
	get_tr2(0, TR_vecEndPos, end) // gets the start point of the wall/entity point
	
	new Float:fStartOfWall[3]
	xs_vec_copy(end, fStartOfWall)
	
	xs_vec_mul_scalar(direction, 2.0, direction)
	xs_vec_add(end, direction, source)
	xs_vec_mul_scalar(direction, 9999.0, direction)
	xs_vec_add(source, direction, end)
	
	engfunc(EngFunc_TraceLine, source, end, IGNORE_MONSTERS | IGNORE_GLASS, player, 0)
	get_tr2(0, TR_flFraction, fraction)
	if((fraction == 1.0) || get_tr2(0, TR_AllSolid))
	{
		return 0
	}
	end = source
	get_tr2(0, TR_vecEndPos, source)
	
	engfunc(EngFunc_TraceLine, source, end, IGNORE_MONSTERS | IGNORE_GLASS, player, 0)
	get_tr2(0, TR_vecEndPos, end) // here we have the end of it
	return floatround(vector_distance(fStartOfWall, end)) // here, the distance between each point (thickness)
}

originUnitsAhead(id, Float:fOrigin[3], iValue = 0)
{
	new Float:fForward[3]
	pev(id, pev_v_angle, fForward)

	engfunc(EngFunc_MakeVectors, fForward)
	global_get(glb_v_forward, fForward)

	fOrigin[0] += fForward[0] * iValue
	fOrigin[1] += fForward[1] * iValue
	fOrigin[2] += fForward[2] * iValue
}

createSparks(Float:fOrigin[3])
{
	message_begin(MSG_ALL, SVC_TEMPENTITY)
	write_byte(TE_SPARKS)
	engfunc(EngFunc_WriteCoord, fOrigin[0])
	engfunc(EngFunc_WriteCoord, fOrigin[1])
	engfunc(EngFunc_WriteCoord, fOrigin[2])
	message_end()
}

bulletHitDecals(Float:fOrigin[3])
{
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, fOrigin, 0)
	write_byte(TE_WORLDDECAL)
	engfunc(EngFunc_WriteCoord, fOrigin[0])
	engfunc(EngFunc_WriteCoord, fOrigin[1])
	engfunc(EngFunc_WriteCoord, fOrigin[2])
	write_byte(random_num(41, 45))
	message_end()

	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, fOrigin, 0)
	write_byte(TE_GUNSHOTDECAL)
	engfunc(EngFunc_WriteCoord, fOrigin[0])
	engfunc(EngFunc_WriteCoord, fOrigin[1])
	engfunc(EngFunc_WriteCoord, fOrigin[2])
	write_short(0)
	write_byte(random_num(41, 45))
	message_end()
		
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(TE_EXPLOSION)
	write_coord(floatround(fOrigin[0]))
	write_coord(floatround(fOrigin[1]))
	write_coord(floatround(fOrigin[2]))
	write_short(g_iSmokeID)
	write_byte(4)
	write_byte(40)
	write_byte(14)
	message_end()
}

// I had a loop that formats all of this easier and prettier
// But then I changed to this because for some reason on my first map load
// the get_weaponname wasn't returning the names of the weapons
// I had to change the map for it to start formating the names correctly.
// So instead of letting it that way I moved to this hard-coded format.
// Ugly, but at least it works as I wanted to.
checkAndPrecacheWeapons(iWeapon)
{
	new szSound[64]
	switch(iWeapon)
	{
		case CSW_USP:		
		{
			formatex(szSound, charsmax(szSound), "weapons/usp_unsil-1.wav")
			engfunc(EngFunc_PrecacheSound, szSound)
			copy(g_szWeaponSoundFmt[iWeapon], charsmax(g_szWeaponSoundFmt[]), szSound)
			
			formatex(szSound, charsmax(szSound), "weapons/usp2.wav")
			engfunc(EngFunc_PrecacheSound, szSound)
			copy(g_szWeaponDifferent[0], charsmax(g_szWeaponDifferent[]), szSound)
			return
		}
		case CSW_M4A1:
		{
			formatex(szSound, charsmax(szSound), "weapons/m4a1_unsil-1.wav")
			engfunc(EngFunc_PrecacheSound, szSound)
			copy(g_szWeaponSoundFmt[iWeapon], charsmax(g_szWeaponSoundFmt[]), szSound)
			
			formatex(szSound, charsmax(szSound), "weapons/m4a1-1.wav")
			engfunc(EngFunc_PrecacheSound, szSound)
			copy(g_szWeaponDifferent[1], charsmax(g_szWeaponDifferent[]), szSound)
			return
		}
		case CSW_GLOCK18:
		{
			formatex(szSound, charsmax(szSound), "weapons/glock18-2.wav")
			engfunc(EngFunc_PrecacheSound, szSound)
			copy(g_szWeaponSoundFmt[iWeapon], charsmax(g_szWeaponSoundFmt[]), szSound)
			
			formatex(szSound, charsmax(szSound), "weapons/glock18-1.wav")
			engfunc(EngFunc_PrecacheSound, szSound)
			copy(g_szWeaponDifferent[2], charsmax(g_szWeaponDifferent[]), szSound)
			return
		}
		case CSW_FAMAS:
		{
			formatex(szSound, charsmax(szSound), "weapons/famas-2.wav")
			engfunc(EngFunc_PrecacheSound, szSound)
			copy(g_szWeaponSoundFmt[iWeapon], charsmax(g_szWeaponSoundFmt[]), szSound)
			
			formatex(szSound, charsmax(szSound), "weapons/famas-burst.wav")
			engfunc(EngFunc_PrecacheSound, szSound)
			copy(g_szWeaponDifferent[3], charsmax(g_szWeaponDifferent[]), szSound)
			return
		}
		case CSW_P90:		formatex(szSound, charsmax(szSound), "weapons/p90-1.wav")
		case CSW_AK47:		formatex(szSound, charsmax(szSound), "weapons/ak47-1.wav")
		case CSW_SG552:		formatex(szSound, charsmax(szSound), "weapons/sg552-1.wav")
		case CSW_DEAGLE:	formatex(szSound, charsmax(szSound), "weapons/deagle-1.wav")
		case CSW_G3SG1:		formatex(szSound, charsmax(szSound), "weapons/g3sg1-1.wav")
		case CSW_TMP:		formatex(szSound, charsmax(szSound), "weapons/tmp-1.wav")
		case CSW_M3:		formatex(szSound, charsmax(szSound), "weapons/m3-1.wav")
		case CSW_M249:		formatex(szSound, charsmax(szSound), "weapons/m249-1.wav")
		case CSW_MP5NAVY:	formatex(szSound, charsmax(szSound), "weapons/mp5-1.wav")
		case CSW_AWP:		formatex(szSound, charsmax(szSound), "weapons/awp1.wav")
		case CSW_GALIL:		formatex(szSound, charsmax(szSound), "weapons/galil-1.wav")
		case CSW_SG550:		formatex(szSound, charsmax(szSound), "weapons/sg550-1.wav")
		case CSW_UMP45:		formatex(szSound, charsmax(szSound), "weapons/ump45-1.wav")
		case CSW_FIVESEVEN:	formatex(szSound, charsmax(szSound), "weapons/fiveseven-1.wav")
		case CSW_ELITE:		formatex(szSound, charsmax(szSound), "weapons/elite_fire.wav")
		case CSW_AUG:		formatex(szSound, charsmax(szSound), "weapons/aug-1.wav")
		case CSW_MAC10:		formatex(szSound, charsmax(szSound), "weapons/mac10-1.wav")
		case CSW_XM1014:	formatex(szSound, charsmax(szSound), "weapons/xm1014-1.wav")
		case CSW_SCOUT:		formatex(szSound, charsmax(szSound), "weapons/scout_fire-1.wav")
		case CSW_P228:		formatex(szSound, charsmax(szSound), "weapons/p228-1.wav")
	}
	engfunc(EngFunc_PrecacheSound, szSound)
	copy(g_szWeaponSoundFmt[iWeapon], charsmax(g_szWeaponSoundFmt[]), szSound)
}

isWeaponOnBurstMode(iIndex)
{ 
	if(!pev_valid(iIndex))
		return 0
		
	switch(fm_get_weapon_id(iIndex)) 
	{ 
		case CSW_GLOCK18: 	return (get_pdata_int(iIndex, OFFSET_SILENCER_FIREMODE, XTRA_OFS_WEAPON) == GLOCK_BURSTMODE)
		case CSW_FAMAS: 	return (get_pdata_int(iIndex, OFFSET_SILENCER_FIREMODE, XTRA_OFS_WEAPON) == FAMAS_BURSTMODE) 
	} 
	return 0
} 

isWeaponSilenced(entity)
{
	new weapon = fm_get_weapon_id(entity)
	if((weapon != CSW_M4A1) && (weapon != CSW_USP)) 
		return 0
	
	new silencemode = get_pdata_int(entity, OFFSET_SILENCER_FIREMODE, XTRA_OFS_WEAPON)
	switch(weapon)
	{
		case CSW_M4A1:	return (silencemode & M4A1_SILENCED)
		case CSW_USP:	return (silencemode & USP_SILENCED)
	}
	return 0
}
