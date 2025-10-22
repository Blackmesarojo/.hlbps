// scxpm_0x0005_events.sma
// Sistema de eventos y XP

SCXPM_Events_Init() {
    // Eventos de muerte y daño
    register_event("DeathMsg", "SCXPM_PlayerKilled", "a");
    register_event("Damage", "SCXPM_PlayerDamage", "b", "2!0", "3=0", "4!0");
    
    // Eventos de ronda
    register_logevent("SCXPM_RoundStart", 2, "0=World triggered", "1=Round_Start");
    register_logevent("SCXPM_RoundEnd", 2, "0=World triggered", "1=Round_End");
    
    // Iniciar HUD task
    set_task(1.0, "SCXPM_UpdateHUD", 0, "", 0, "b");
}

public SCXPM_PlayerKilled() {
    new killer = read_data(1);
    new victim = read_data(2);
    
    if(!is_user_connected(killer) || killer == victim || !loaddata[killer]) {
        return PLUGIN_CONTINUE;
    }
    
    // Calcular XP base por muerte
    new Float:xpgain = get_cvar_float("scxpm_xpgain");
    new baseXP = 100;
    
    // Bonificación por distancia
    if(dist[killer] > 0) {
        baseXP += (dist[killer] * 10);
    }
    
    // Bonificación para VIPs
    if(is_vip[killer]) {
        baseXP = floatround(float(baseXP) * 1.5);
    }
    
    // Aplicar multiplicador global
    baseXP = floatround(float(baseXP) * xpgain);
    
    // Añadir XP
    xp[killer] += baseXP;
    
    // Mostrar ganancia de XP
    client_print(killer, print_chat, "[SCXPM] +%d XP por eliminar a %n", baseXP, victim);
    
    // Verificar subida de nivel
    if(SCXPM_CheckLevelUp(killer)) {
        SCXPM_ApplyPlayerSkills(killer);
    }
    
    return PLUGIN_CONTINUE;
}

public SCXPM_PlayerDamage(victim, inflictor, attacker, Float:damage, damagebits) {
    if(!is_user_connected(attacker) || attacker == victim || !loaddata[attacker]) {
        return PLUGIN_CONTINUE;
    }
    
    // XP por daño
    new Float:xpgain = get_cvar_float("scxpm_xpgain");
    new damageXP = floatround(damage * 0.1 * xpgain);
    
    if(damageXP > 0) {
        xp[attacker] += damageXP;
        
        // Verificar subida de nivel
        if(SCXPM_CheckLevelUp(attacker)) {
            SCXPM_ApplyPlayerSkills(attacker);
        }
    }
    
    return PLUGIN_CONTINUE;
}

public SCXPM_RoundStart() {
    for(new id = 1; id <= 32; id++) {
        if(is_user_alive(id) && loaddata[id]) {
            SCXPM_ApplyPlayerSkills(id);
        }
    }
}

public SCXPM_RoundEnd() {
    // Bonus de XP por ronda
    for(new id = 1; id <= 32; id++) {
        if(is_user_connected(id) && loaddata[id]) {
            new Float:xpgain = get_cvar_float("scxpm_xpgain");
            new roundXP = floatround(50.0 * xpgain);
            
            if(is_vip[id]) {
                roundXP = floatround(float(roundXP) * 1.5);
            }
            
            xp[id] += roundXP;
            client_print(id, print_chat, "[SCXPM] +%d XP por completar la ronda", roundXP);
            
            // Verificar subida de nivel
            if(SCXPM_CheckLevelUp(id)) {
                SCXPM_ApplyPlayerSkills(id);
            }
        }
    }
}

public SCXPM_UpdateHUD() {
    static players[32], num, id;
    get_players(players, num);
    
    for(new i = 0; i < num; i++) {
        id = players[i];
        if(!is_user_connected(id) || !loaddata[id]) continue;
        
        // Mostrar HUD
        static hudmsg[256];
        formatex(hudmsg, charsmax(hudmsg), "Nivel: %d^nXP: %d/%d^nPuntos: %d^n^nVida Extra: %d^nArmadura Extra: %d^nRegen Vida: %d^nRegen Armadura: %d^nDistancia: %d", 
            playerlevel[id],
            xp[id],
            neededxp[id],
            skillpoints[id],
            health[id],
            armor[id],
            rhealth[id],
            rarmor[id],
            dist[id]
        );
        
        set_hudmessage(0, 255, 0, 0.02, 0.15, 0, 0.0, 1.1, 0.0, 0.0, -1);
        show_hudmessage(id, hudmsg);
    }
}