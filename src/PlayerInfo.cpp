//
//  playerInfo.cpp
//  emptyExample
//
//  Created by Gerard Rallo on 03/02/2013.
//
//

#include "PlayerInfo.h"

PlayerInfo::PlayerInfo(){

}

void PlayerInfo::init(ofxBox2d *_box2d, ofColor _color){
    box2d       = _box2d;
    b_count     = 20;
    b_to_go     = 20;
    g           = 1000;
    base_color  = _color;
    score       = 0;
}

void PlayerInfo::reset(){
    b_count     = 20;
    b_to_go     = 20;
    g           = 1000;
    score       = 0;
}

void PlayerInfo::setGravity(float _g){
    g = _g;
}

void PlayerInfo::dropBall(float _x, float _y){
    if(b_count > 0){
        Ball* b; //= (ball *) malloc(sizeof(ball));
        b = new Ball();
        //b->setPhysics(4, 0.1, 0.05);
        b->setPhysics(4, 0.4, 0.05);
        b->setup(box2d->getWorld(), _x, _y, 20);
        b->addForce(ofVec2f(0, 1), g*50);
        b->init();
        b->setPlayer(this);
        b->setData(new ObjectInfo(1,b));
        balls.push_back(b);
        b_count--;
    }
}


void PlayerInfo::multiplyBalls(int _amount, float _x, float _y){
    for(int i = 0; i < _amount; i++){
        Ball* b;
        b = new Ball();
        b->setPhysics(4, 0.4, 0.05);
        b->setup(box2d->getWorld(), _x+ofRandom(5.0) - 10, _y+ofRandom(5.0) - 10, 20);
        b->addForce(ofVec2f(ofRandom(1.0), ofRandom(1.0)), g*ofRandom(50, 200));
        b->init();
        b->player = this;
        b->setData(new ObjectInfo(1,b));
        balls.push_back(b);
        b_to_go++;
    }
}


void PlayerInfo::extraBalls(int _amount){
    b_count++;
    b_to_go++;
}


void PlayerInfo::updateBalls(){
    for(list<Ball*>::iterator it = balls.begin(); it != balls.end(); ++it) {
        if((*it)->killedby == 4){
            
            b2Filter f;
            f.categoryBits = 0x0002;
            f.maskBits     = 0x0000;
            (*it)->setFilterData(f);
            (*it)->body->SetActive(false);
            (*it)->has_star = false;
            (*it)->dead = true;

            (*it)->destroy();
            it = balls.erase(it);
            
            b_to_go--;
            
        }
        (*it)->addForce(ofVec2f(0, 1), g);
    }
}

void PlayerInfo::drawInfo(){
    for (int i = 0; i < b_count; i++) {
        ofSetColor(base_color);
        ofCircle(20+10*i, ofGetHeight()-20, 4);
    }
}



void PlayerInfo::drawBalls(){
    for(list<Ball*>::iterator it = balls.begin(); it != balls.end(); ++it) {
        ofSetColor(base_color);
        if(!(*it)->dead){
            (*it)->draw();
        }
    }
}








