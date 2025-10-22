// scxpm_0x0001_settings.sma

#define VIP_FILE "addons/amxmodx/configs/scxpm_vips.ini"

SCXPM_Settings_Init() {
    // Registro de cvars
    register_cvar("scxpm_gamename", "1");
    register_cvar("scxpm_minplaytime", "0");
    register_cvar("scxpm_hud_channel", "3");
    register_cvar("scxpm_xpgain", "1.0");
    register_cvar("scxpm_maxlevel", "1800");
    
    // Inicialización de variables
    plugin_ended = false;
    
    // Carga de VIPs
    SCXPM_LoadVips();
}

SCXPM_LoadVips() {
    if(g_tVips) {
        TrieDestroy(g_tVips);
    }
    
    g_tVips = TrieCreate();
    
    if(!file_exists(VIP_FILE)) {
        return;
    }
    
    new file = fopen(VIP_FILE, "rt");
    if(file) {
        new szLine[32];
        while(fgets(file, szLine, charsmax(szLine))) {
            trim(szLine);
            if(szLine[0] == ';' || !szLine[0]) {
                continue;
            }
            TrieSetCell(g_tVips, szLine, 1);
        }
        fclose(file);
    }
}

SCXPM_Settings_End() {
    if(g_tVips) {
        TrieDestroy(g_tVips);
    }
}