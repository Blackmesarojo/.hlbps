// scxpm/scxpm_globals.inc
#if defined _scxpm_globals_included
    #endinput
#endif
#define _scxpm_globals_included

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
new rhealthwait[33];
new rarmorwait[33];
new lastfrags[33];
new lastDeadflag[33];
new bool:has_godmode[33];
new Trie:g_tVips;