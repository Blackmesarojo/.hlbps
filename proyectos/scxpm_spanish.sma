// scxpm_spanish.sma
#include <amxmodx>
#include <amxmisc>
#include <fun>
#include <fakemeta>

#define PLUGIN  "SCXPM Custom Final"
#define VERSION "17.31"
#define AUTHOR  "Silicer/Gemini"

// Variables globales compartidas
new bool:is_vip[33];
new bool:loaddata[33];
new bool:plugin_ended;
new xp[33];
new neededxp[33];
new playerlevel[33];
new skillpoints[33];
new health[33];
new armor[33];
new dist[33];
new rhealth[33];
new rarmor[33];
new bool:has_godmode[33];
new Trie:g_tVips;

// Forwards globales
forward SCXPM_ApplyPlayerSkills(id);

// Incluir los módulos
#include "scxpm/scxpm_0x0001_settings.sma"
#include "scxpm/scxpm_0x0002_init.sma"
#include "scxpm/scxpm_0x0003_saves.sma"
#include "scxpm/scxpm_0x0004_skills.sma"
#include "scxpm/scxpm_0x0005_events.sma"
#include "scxpm/scxpm_0x0006_commands.sma"

public plugin_init() {
    register_plugin(PLUGIN, VERSION, AUTHOR);
    SCXPM_Settings_Init();
    SCXPM_Init();
    SCXPM_Commands_Init();
    SCXPM_Events_Init();
    SCXPM_Skills_Init();
}

public plugin_end() {
    plugin_ended = true;
    SCXPM_Settings_End();
    SCXPM_SaveAllPlayers();
}