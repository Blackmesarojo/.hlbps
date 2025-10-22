// scxpm_0x0003_saves.sma
// Sistema de guardado y manejo de datos

#define SAVE_PATH "addons/amxmodx/data/scxpm"

public SCXPM_UpdateNeededXP(id) {
    if(!is_user_connected(id)) return;
    
    new level = playerlevel[id];
    new Float:required = float(level) * 500.0;
    neededxp[id] = floatround(required);
}

public SCXPM_CheckLevelUp(id) {
    if(!is_user_connected(id)) return 0;
    
    if(xp[id] >= neededxp[id]) {
        playerlevel[id]++;
        skillpoints[id]++;
        
        // Mensaje de nivel
        client_print(0, print_chat, "[SCXPM] El jugador %n alcanzo el nivel %d!", id, playerlevel[id]);
        
        // Guardar datos al subir de nivel
        SCXPM_SavePlayerData(id);
        
        // Actualizar XP necesaria para siguiente nivel
        SCXPM_UpdateNeededXP(id);
        
        // Aplicar habilidades nuevamente
        SCXPM_ApplyPlayerSkills(id);
        
        return 1;
    }
    return 0;
}

public SCXPM_LoadPlayerData(id) {
    if(!is_user_connected(id)) return;
    
    // Crear directorio si no existe
    if(!dir_exists(SAVE_PATH)) {
        mkdir(SAVE_PATH);
    }
    
    new authid[35];
    get_user_authid(id, authid, 34);
    
    // No guardar datos para jugadores sin STEAM_ID válido
    if(equal(authid, "STEAM_ID_LAN") || equal(authid, "VALVE_ID_PENDING")) {
        loaddata[id] = true;
        SCXPM_UpdateNeededXP(id);
        return;
    }
    
    new filename[128];
    formatex(filename, 127, "%s/%s.dat", SAVE_PATH, authid);
    
    if(!file_exists(filename)) {
        // Nuevo jugador
        loaddata[id] = true;
        SCXPM_UpdateNeededXP(id);
        return;
    }
    
    new file = fopen(filename, "rt");
    if(!file) {
        loaddata[id] = true;
        SCXPM_UpdateNeededXP(id);
        return;
    }
    
    new data[32];
    
    // Cargar nivel y XP
    fgets(file, data, 31);
    playerlevel[id] = str_to_num(data);
    
    fgets(file, data, 31);
    xp[id] = str_to_num(data);
    
    // Cargar puntos de habilidad
    fgets(file, data, 31);
    skillpoints[id] = str_to_num(data);
    
    // Cargar habilidades
    fgets(file, data, 31);
    health[id] = str_to_num(data);
    
    fgets(file, data, 31);
    armor[id] = str_to_num(data);
    
    fgets(file, data, 31);
    rhealth[id] = str_to_num(data);
    
    fgets(file, data, 31);
    rarmor[id] = str_to_num(data);
    
    fgets(file, data, 31);
    dist[id] = str_to_num(data);
    
    fclose(file);
    loaddata[id] = true;
    
    // Actualizar XP necesaria
    SCXPM_UpdateNeededXP(id);
    
    // Mensaje de carga exitosa
    new name[32];
    get_user_name(id, name, 31);
    client_print(id, print_chat, "[SCXPM] Bienvenido %s! Nivel: %d, XP: %d/%d", 
        name, playerlevel[id], xp[id], neededxp[id]);
}

public SCXPM_SavePlayerData(id) {
    if(!is_user_connected(id) || !loaddata[id]) return;
    
    new authid[35];
    get_user_authid(id, authid, 34);
    
    if(equal(authid, "STEAM_ID_LAN") || equal(authid, "VALVE_ID_PENDING")) {
        return;
    }
    
    // Crear directorio si no existe
    if(!dir_exists(SAVE_PATH)) {
        mkdir(SAVE_PATH);
    }
    
    new filename[128];
    formatex(filename, 127, "%s/%s.dat", SAVE_PATH, authid);
    
    new file = fopen(filename, "wt");
    if(!file) return;
    
    // Guardar nivel y XP
    fprintf(file, "%d^n", playerlevel[id]);
    fprintf(file, "%d^n", xp[id]);
    
    // Guardar puntos de habilidad
    fprintf(file, "%d^n", skillpoints[id]);
    
    // Guardar habilidades
    fprintf(file, "%d^n", health[id]);
    fprintf(file, "%d^n", armor[id]);
    fprintf(file, "%d^n", rhealth[id]);
    fprintf(file, "%d^n", rarmor[id]);
    fprintf(file, "%d^n", dist[id]);
    
    fclose(file);
}

public SCXPM_SaveAllPlayers() {
    if(plugin_ended) return;
    
    for(new id = 1; id <= 32; id++) {
        if(is_user_connected(id) && loaddata[id]) {
            SCXPM_SavePlayerData(id);
        }
    }
}