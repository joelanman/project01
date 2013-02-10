//
//  peg.h
//  emptyExample
//
//  Created by Gerard Rallo on 03/02/2013.
//
//


#pragma once

#include "ofMain.h"
#include "ofxBox2d.h"
#include "Item.h"

class Peg : public Item{
    
public:
    
    ofColor highlight_color;
    int     hl_alpha;
    
    Peg();
    Peg(ofColor hl_c);
    void draw();
    uint16  objectType() { return 0x0003; }
    
    
};