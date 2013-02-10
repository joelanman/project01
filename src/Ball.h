//
//  ball.h
//  emptyExample
//
//  Created by Gerard Rallo on 03/02/2013.
//
//


#pragma once

#include "ofMain.h"
#include "ofxBox2d.h"
#include "ObjectInfo.h"
#include "PlayerInfo.h"

class PlayerInfo;

class Ball : public ofxBox2dCircle{
    
public:
    
    string  className;
    
    PlayerInfo* player;
    bool        has_star;
    bool        dead;
    int         killedby;
    
    Ball();
    void draw();
    void init();
    
    void setPlayer(PlayerInfo* _player);
    
    
    static uint16  ObjectType() { return 0x0001; }
    string getClassName() { return className; }
    
    
};