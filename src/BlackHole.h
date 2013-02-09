//
//  blackHole.h
//  emptyExample
//
//  Created by Gerard Rallo on 07/02/2013.
//
//


#pragma once

#include "Item.h"

class BlackHole : public Item{
    
public:
    
    BlackHole();
    
    void    draw();
    uint16  objectType() { return 0x0003; }
    
};
