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
    
    ofSetColor(55,42,50);
	ofCircle(0, 0, getRadius() + 10);
	
    ofPushStyle();
    ofEnableAlphaBlending();
    
    if(isSleeping()) {
        ofSetColor(255, 100);
        ofCircle(0, 0, getRadius());
    }
    ofPopStyle();
    
    
    ofPopMatrix();
}