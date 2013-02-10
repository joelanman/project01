//
//  blackHole.cpp
//  emptyExample
//
//  Created by Gerard Rallo on 07/02/2013.
//
//

#include "BlackHole.h"


BlackHole::BlackHole(){
    
}

void BlackHole::draw(){
    if(!isBody()) return;
    if(picked) return;
	
	ofPushMatrix();
	ofTranslate(getPosition().x, getPosition().y, 0);
	ofRotate(getRotation(), 0, 0, 1);
    
    ofSetCircleResolution(24);
    
   
    ofSetColor(200);
    ofCircle(0, 0, getRadius() + 10);
    ofSetColor(180);
    ofCircle(0, 0, ((getRadius() + 10)/4)*2);
    ofSetColor(150);
    ofCircle(0, 0, ((getRadius() + 10)/4));
    ofSetColor(100);
    ofCircle(0, 0, ((getRadius() + 10)/8));
    
    ofNoFill();
    ofEnableSmoothing();
    ofSetLineWidth(2);
    
    ofSetColor(200);
    ofCircle(0, 0, getRadius() + 10);
    ofSetColor(180);
    ofCircle(0, 0, ((getRadius() + 10)/4)*2);
    ofSetColor(150);
    ofCircle(0, 0, ((getRadius() + 10)/4));
    ofSetColor(100);
    ofCircle(0, 0, ((getRadius() + 10)/8));
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
}