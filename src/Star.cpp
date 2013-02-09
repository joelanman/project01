//
//  star.cpp
//  emptyExample
//
//  Created by Gerard Rallo on 07/02/2013.
//
//

#include "Star.h"


Star::Star(){
    
}

void Star::draw(){
    if(!isBody()) return;
    if(picked) return;
	
	ofPushMatrix();
	ofTranslate(getPosition().x, getPosition().y, 0);
	ofRotate(getRotation(), 0, 0, 1);
    
    ofSetColor(241,241,5);
	ofCircle(0, 0, getRadius());
	
    ofPushStyle();
    ofEnableAlphaBlending();
    
    if(isSleeping()) {
        ofSetColor(255, 100);
        ofCircle(0, 0, getRadius());
    }
    ofPopStyle();
    
    
    ofPopMatrix();
}