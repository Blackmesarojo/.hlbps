#ifndef BOT_H
#define BOT_H

#include "cbase.h"
#include "player.h"

class CCoopBot : public CBasePlayer
{
public:
    virtual void Spawn(void);
};

#endif