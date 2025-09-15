#include "extdll.h"
#include "meta_api.h"
#include "bot.h"

meta_globals_t *gpMetaGlobals;
g_meta_glue_t *gpMetaGlue;
gamedll_funcs_t *gpGamedllFuncs;
mutil_funcs_t *gpMutilFuncs;

plugin_info_t Plugin_info = {
	META_INTERFACE_VERSION,
	"CoopBot",
	"1.0",
	__DATE__,
	"YourName",
	"http://yourwebsite.com",
	"COOPBOT",
	PT_STARTUP,
	PT_STARTUP,
};

void AddBot_Command(void)
{
    g_engfuncs.pfnCreateFakeClient("CoopBot");
    SERVER_PRINT("Bot anadido!\n");
}

C_DLLEXPORT int Meta_Query(char *ifvers, plugin_info_t **pPlugInfo, mutil_funcs_t *pMutilFuncs) {
	*pPlugInfo = &Plugin_info;
	gpMutilFuncs = pMutilFuncs;
	return 1;
}

C_DLLEXPORT int Meta_Attach(PLUG_LOADTIME now, META_FUNCTIONS *pFunctionTable, meta_globals_t *pMGlobals, gamedll_funcs_t *pGamedllFuncs) {
	gpMetaGlobals = pMGlobals;
	gpGamedllFuncs = pGamedllFuncs;
	g_engfuncs.pfnAddServerCommand("rcbot", AddBot_Command);
	return 1;
}

C_DLLEXPORT int Meta_Detach(PLUG_LOADTIME now, PL_UNLOAD_REASON reason) {
	return 1;
}