// scxpm_0x0004_skills.sma
// Sistema de habilidades y menús

#define MENU_KEYS (1<<0|1<<1|1<<2|1<<3|1<<4|1<<5|1<<6|1<<7|1<<8|1<<9)

SCXPM_Skills_Init() {
    register_clcmd("say /skills", "SCXPM_SkillsMenu");
    register_clcmd("say /habilidades", "SCXPM_SkillsMenu");
}

public SCXPM_SkillsMenu(id) {
    if(!is_user_connected(id) || !loaddata[id]) {
        return PLUGIN_HANDLED;
    }
    
    static menu[512], len;
    len = formatex(menu, 511, "\yMenu de Habilidades^n\wPuntos disponibles: %d^n^n", skillpoints[id]);
    
    len += formatex(menu[len], 511-len, "\r1. \wVida Extra \y[Nivel: %d]^n", health[id]);
    len += formatex(menu[len], 511-len, "\r2. \wArmadura Extra \y[Nivel: %d]^n", armor[id]);
    len += formatex(menu[len], 511-len, "\r3. \wRegeneracion de Vida \y[Nivel: %d]^n", rhealth[id]);
    len += formatex(menu[len], 511-len, "\r4. \wRegeneracion de Armadura \y[Nivel: %d]^n", rarmor[id]);
    len += formatex(menu[len], 511-len, "\r5. \wDistancia de Daño \y[Nivel: %d]^n^n", dist[id]);
    
    len += formatex(menu[len], 511-len, "\r0. \wSalir");
    
    show_menu(id, MENU_KEYS, menu, -1, "Skills Menu");
    return PLUGIN_HANDLED;
}

public SCXPM_SkillsMenuHandler(id, key) {
    if(!is_user_connected(id) || !loaddata[id] || !skillpoints[id]) {
        return PLUGIN_HANDLED;
    }
    
    switch(key) {
        case 0: { // Vida Extra
            health[id]++;
            skillpoints[id]--;
            client_print(id, print_chat, "[SCXPM] Aumentaste tu Vida Extra al nivel %d", health[id]);
        }
        case 1: { // Armadura Extra
            armor[id]++;
            skillpoints[id]--;
            client_print(id, print_chat, "[SCXPM] Aumentaste tu Armadura Extra al nivel %d", armor[id]);
        }
        case 2: { // Regeneración de Vida
            rhealth[id]++;
            skillpoints[id]--;
            client_print(id, print_chat, "[SCXPM] Aumentaste tu Regeneracion de Vida al nivel %d", rhealth[id]);
        }
        case 3: { // Regeneración de Armadura
            rarmor[id]++;
            skillpoints[id]--;
            client_print(id, print_chat, "[SCXPM] Aumentaste tu Regeneracion de Armadura al nivel %d", rarmor[id]);
        }
        case 4: { // Distancia de Daño
            dist[id]++;
            skillpoints[id]--;
            client_print(id, print_chat, "[SCXPM] Aumentaste tu Distancia de Daño al nivel %d", dist[id]);
        }
        case 9: { // Salir
            return PLUGIN_HANDLED;
        }
    }
    
    // Mostrar menú de nuevo si aún hay puntos
    if(skillpoints[id] > 0) {
        SCXPM_SkillsMenu(id);
    }
    
    return PLUGIN_HANDLED;
}

public SCXPM_ApplyPlayerSkills(id) {
    if(!is_user_alive(id) || !loaddata[id]) {
        return;
    }
    
    // Aplicar vida extra
    new maxhealth = 100 + (health[id] * 2);
    set_user_health(id, maxhealth);
    
    // Aplicar armadura extra
    new maxarmor = 100 + (armor[id] * 2);
    set_user_armor(id, maxarmor);
}