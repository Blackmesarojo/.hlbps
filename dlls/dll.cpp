#include "extdll.h"
#include "util.h"

// Variable global para interactuar con el motor del juego
enginefuncs_t g_engfuncs;
globalvars_t  *gpGlobals; // Necesitamos acceso a las variables globales

// Función que se ejecutará cuando usemos el comando
void AddBot_Command(void)
{
    // Usamos una función del motor para crear un "cliente falso" (nuestro bot)
    g_engfuncs.pfnCreateFakeClient("CoopBot");

    // Opcional: Imprime un mensaje en la consola del servidor para confirmar.
    SERVER_PRINT("Bot anadido!\n");
}

// Esta es la función que el motor de Half-Life llama cuando carga tu DLL
extern "C" void GiveFnptrsToDll(enginefuncs_t* pengfuncsFromEngine, globalvars_t *pGlobalsFromEngine)
{
    // Copiamos las funciones del motor a nuestra variable global
    memcpy(&g_engfuncs, pengfuncsFromEngine, sizeof(enginefuncs_t));
    gpGlobals = pGlobalsFromEngine;

    // ¡Aquí registramos nuestro comando!
    // Cuando alguien escriba "rcbot addbot", se llamará a la función AddBot_Command
    g_engfuncs.pfnAddServerCommand("rcbot", AddBot_Command); // Registramos "rcbot" como el comando principal
}