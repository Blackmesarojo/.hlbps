// scxpm_0x0006_commands.sma
// Sistema de comandos administrativos y de usuario

SCXPM_Commands_Init() {
    // Comandos de chat
    register_clcmd("say /skills", "SCXPM_SkillsMenu");
    register_clcmd("say /habilidades", "SCXPM_SkillsMenu");
    register_clcmd("say /nivel", "SCXPM_ShowLevel");
    register_clcmd("say /xp", "SCXPM_ShowLevel");
    register_clcmd("say /reset", "SCXPM_ResetSkills");
    
    // Comandos administrativos
    register_concmd("amx_setlevel", "SCXPM_AdminSetLevel", ADMIN_LEVEL_A, "<nombre> <nivel>");
    register_concmd("amx_addxp", "SCXPM_AdminAddXP", ADMIN_LEVEL_A, "<nombre> <xp>");
    register_concmd("amx_resetxp", "SCXPM_AdminResetXP", ADMIN_LEVEL_A, "<nombre>");
    register_concmd("amx_godmode", "SCXPM_AdminGodMode", ADMIN_LEVEL_A, "<nombre>");
}

public SCXPM_AdminSetLevel(const id, const level, const cid) {
    if(!cmd_access(id, ADMIN_LEVEL_A, cid, 3)) {
        return PLUGIN_HANDLED;
    }
    
    new target[32], level_str[8];
    read_argv(1, target, 31);
    read_argv(2, level_str, 7);
    
    new const player = cmd_target(id, target, CMDTARGET_ALLOW_SELF);
    if(!player) return PLUGIN_HANDLED;
    
    new const newlevel = str_to_num(level_str);
    if(newlevel < 1 || newlevel > get_cvar_num("scxpm_maxlevel")) {
        client_print(id, print_console, "[SCXPM] Nivel invalido (1-%d)", get_cvar_num("scxpm_maxlevel"));
        return PLUGIN_HANDLED;
    }
    
    playerlevel[player] = newlevel;
    skillpoints[player] = newlevel;
    xp[player] = 0;
    SCXPM_UpdateNeededXP(player);
    
    new admin_name[32], player_name[32];
    get_user_name(id, admin_name, 31);
    get_user_name(player, player_name, 31);
    
    client_print(0, print_chat, "[SCXPM] Admin %s establecio el nivel de %s a %d", admin_name, player_name, newlevel);
    SCXPM_SavePlayerData(player);
    
    return PLUGIN_HANDLED;
}

public SCXPM_AdminAddXP(const id, const level, const cid) {
    if(!cmd_access(id, ADMIN_LEVEL_A, cid, 3)) {
        return PLUGIN_HANDLED;
    }
    
    new target[32], xp_str[16];
    read_argv(1, target, 31);
    read_argv(2, xp_str, 15);
    
    new const player = cmd_target(id, target, CMDTARGET_ALLOW_SELF);
    if(!player) return PLUGIN_HANDLED;
    
    new const addxp = str_to_num(xp_str);
    if(addxp <= 0) {
        client_print(id, print_console, "[SCXPM] XP invalido (debe ser > 0)");
        return PLUGIN_HANDLED;
    }
    
    xp[player] += addxp;
    
    new admin_name[32], player_name[32];
    get_user_name(id, admin_name, 31);
    get_user_name(player, player_name, 31);
    
    client_print(0, print_chat, "[SCXPM] Admin %s anadio %d XP a %s", admin_name, addxp, player_name);
    
    if(SCXPM_CheckLevelUp(player)) {
        SCXPM_ApplyPlayerSkills(player);
    }
    
    return PLUGIN_HANDLED;
}

public SCXPM_AdminResetXP(const id, const level, const cid) {
    if(!cmd_access(id, ADMIN_LEVEL_A, cid, 2)) {
        return PLUGIN_HANDLED;
    }
    
    new target[32];
    read_argv(1, target, 31);
    
    new const player = cmd_target(id, target, CMDTARGET_ALLOW_SELF);
    if(!player) return PLUGIN_HANDLED;
    
    // Resetear stats
    playerlevel[player] = 1;
    xp[player] = 0;
    skillpoints[player] = 1;
    health[player] = 0;
    armor[player] = 0;
    rhealth[player] = 0;
    rarmor[player] = 0;
    dist[player] = 0;
    
    SCXPM_UpdateNeededXP(player);
    
    new admin_name[32], player_name[32];
    get_user_name(id, admin_name, 31);
    get_user_name(player, player_name, 31);
    
    client_print(0, print_chat, "[SCXPM] Admin %s reseteo el XP de %s", admin_name, player_name);
    SCXPM_SavePlayerData(player);
    
    return PLUGIN_HANDLED;
}

public SCXPM_AdminGodMode(const id, const level, const cid) {
    if(!cmd_access(id, ADMIN_LEVEL_A, cid, 2)) {
        return PLUGIN_HANDLED;
    }
    
    new target[32];
    read_argv(1, target, 31);
    
    new const player = cmd_target(id, target, CMDTARGET_ALLOW_SELF);
    if(!player) return PLUGIN_HANDLED;
    
    has_godmode[player] = !has_godmode[player];
    
    new admin_name[32], player_name[32];
    get_user_name(id, admin_name, 31);
    get_user_name(player, player_name, 31);
    
    client_print(0, print_chat, "[SCXPM] Admin %s %s godmode a %s", 
        admin_name, has_godmode[player] ? "activo" : "desactivo", player_name);
    
    return PLUGIN_HANDLED;
}