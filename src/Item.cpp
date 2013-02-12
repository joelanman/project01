//
//  item.cpp
//  emptyExample
//
//  Created by Gerard Rallo on 03/02/2013.
//
//

#include "Item.h"

Item::Item(){
    
}

void Item::init(){
    picked = false;
    dead   = false;
    created = ofGetElapsedTimeMillis();
}

void Item::draw(){
    
}

uint16 Item::objectType(){
    
}