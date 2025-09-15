#include "extdll.h"
#include "util.h"
#include "cbase.h"
#include "player.h"
#include "bot.h"

LINK_ENTITY_TO_CLASS(player, CCoopBot);

void CCoopBot::Spawn(void)
{
    CBasePlayer::Spawn();
}