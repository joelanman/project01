//
//  item.h
//  emptyExample
//
//  Created by Gerard Rallo on 03/02/2013.
//
//

#pragma once

#include "ofMain.h"
#include "ofxBox2d.h"
#include "ObjectInfo.h"
#include "Ball.h"

class Item : public ofxBox2dCircle{
    
public:
    
    bool    picked;     // Flag, to perform action on the object in next update ( will be deprecated soon )
    Ball*   pickedby;
    
    Item();
    void init();
    virtual void draw();
    virtual uint16  objectType();
    
};