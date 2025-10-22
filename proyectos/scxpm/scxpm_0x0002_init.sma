// scxpm_0x0002_init.sma

SCXPM_Init() {
    // Crear directorio si no existe
    if(!dir_exists("addons/amxmodx/data/scxpm")) {
        mkdir("addons/amxmodx/data/scxpm");
    }
    
    // Registro de forwards
    register_forward(FM_GetGameDescription, "SCXPM_GameDescription");
    register_forward(FM_PlayerPreThink, "SCXPM_PreThink");
    
    // Registro de mensajes
    register_message(get_user_msgid("Health"), "SCXPM_HealthMessage");
    register_message(get_user_msgid("StatusValue"), "SCXPM_StatusValue");
    
    // Eventos de jugador
    register_event("DeathMsg", "SCXPM_PlayerKilled", "a");
    register_event("Damage", "SCXPM_PlayerDamage", "b", "2!0", "3=0", "4!0");
    register_event("ResetHUD", "SCXPM_ResetHud", "be");
    
    // Iniciar HUD task
    set_task(1.0, "SCXPM_UpdateHUD", 0, "", 0, "b");
}

SCXPM_InitializePlayer(const id) {
    if(!is_user_connected(id)) return;
    
    // Inicializar valores por defecto
    loaddata[id] = false;
    is_vip[id] = false;
    has_godmode[id] = false;
    playerlevel[id] = 1;
    xp[id] = 0;
    skillpoints[id] = 1;
    health[id] = 0;
    armor[id] = 0;
    rhealth[id] = 0;
    rarmor[id] = 0;
    dist[id] = 0;
    
    // Cargar datos guardados
    SCXPM_LoadPlayerData(id);
    
    // Iniciar HUD para este jugador
    set_task(1.0, "SCXPM_UpdateHUD", id + 100000, "", 0, "b");
}

public SCXPM_ResetHud(const id) {
    if(!is_user_connected(id) || plugin_ended) {
        return PLUGIN_CONTINUE;
    }
    
    // Aplicar habilidades al spawn
    SCXPM_ApplyPlayerSkills(id);
    
    return PLUGIN_CONTINUE;
}