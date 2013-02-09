//
//  ball.cpp
//  emptyExample
//
//  Created by Gerard Rallo on 03/02/2013.
//
//

#include "Ball.h"

Ball::Ball(){
    
}

void Ball::init(){
    has_star = false;
    dead     = false;
}

void Ball::draw(){
    
    if(!isBody()) return;
	
	ofPushMatrix();
	ofTranslate(getPosition().x, getPosition().y, 0);
	ofRotate(getRotation(), 0, 0, 1);
	ofCircle(0, 0, getRadius());
    
    if(has_star){
        ofSetColor(240, 240, 120);
        ofCircle(0, 0, 12);
    }
	
    ofPushStyle();
    ofEnableAlphaBlending();
    
    if(isSleeping()) {
        ofSetColor(255, 100);
        ofCircle(0, 0, getRadius());
    }
    ofPopStyle();
    
    
    ofPopMatrix();
    
}