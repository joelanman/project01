//
//  Mitosis.cpp
//  emptyExample
//
//  Created by Gerard Rallo on 10/02/2013.
//
//

#include "Mitosis.h"



Mitosis::Mitosis(){
    rot = 0;
    dead = false;
    lifespan = (int)(ofRandom(5000, 12000));
}

void Mitosis::draw(){
    if(!isBody()) return;
    if(picked) return;
	
	ofPushMatrix();
	ofTranslate(getPosition().x, getPosition().y, 0);
	ofRotate(rot, 0, 0, 1);
    
    ofSetCircleResolution(10);
    
    ofSetColor(120);
    ofCircle(-10, -5, 5);
    ofCircle(10, -5, 5);
    ofCircle(0, 10, 5);
    
    
    ofNoFill();
    ofEnableSmoothing();
    ofSetLineWidth(2);
    ofCircle(-10, -5, 5);
    ofCircle(10, -5, 5);
    ofCircle(0, 10, 5);
    ofSetColor(200);
    ofSetCircleResolution(30);
    ofCircle(0, 0, getRadius());
    ofDisableSmoothing();
    ofFill();
    
    ofPushStyle();
    ofEnableAlphaBlending();
    
    if(isSleeping()) {
        ofSetColor(255, 100);
        ofCircle(0, 0, getRadius());
    }
    
    ofPopStyle();
    
    ofPopMatrix();
    rot+=0.5;
    if((ofGetElapsedTimeMillis() - created) > lifespan ) dead = true;
}



