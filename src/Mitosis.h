//
//  Mitosis.h
//  emptyExample
//
//  Created by Gerard Rallo on 10/02/2013.
//
//


#pragma once

#include "Item.h"


class Mitosis : public Item{
    
public:
    
    float rot;
    
    
    Mitosis();
    
    void    draw();
    uint16  objectType() { return 0x0005; }
    
};
