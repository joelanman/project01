//
//  playerInfo.h
//  emptyExample
//
//  Created by Gerard Rallo on 03/02/2013.
//
//

#pragma once

#include "ofMain.h"
#include <list>

#include "ofxBox2d.h"
#include "Ball.h"
#include "ObjectInfo.h"


class PlayerInfo{

public:
    
    int                 b_count;
    int                 b_to_go;
    float               g;
    list<Ball*>         balls;
    ofxBox2d            *box2d;
    ofColor             base_color;
    int                 score;
    
    
    
    PlayerInfo();
    
    void init(ofxBox2d *_box2d, ofColor _color);
    void setGravity(float _g);
    
    
    void dropBall(float _x, float _y);
    void updateBalls();
    void drawBalls();
    
    void drawInfo();
    
};
