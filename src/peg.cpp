//
//  peg.cpp
//  emptyExample
//
//  Created by Gerard Rallo on 03/02/2013.
//
//

#include "Peg.h"

Peg::Peg(){
    
}

Peg::Peg(ofColor hl_C){
    highlight_color = hl_C;
    hl_alpha = 0;
}

void Peg::draw(){
    
    if(!isBody()) return;
	
	ofPushMatrix();
	ofTranslate(getPosition().x, getPosition().y, 0);
	ofRotate(getRotation(), 0, 0, 1);
	//ofCircle(0, 0, getRadius());
    
    ofNoFill();
    ofEnableSmoothing();
    ofSetLineWidth(2);
    ofCircle(0, 0, getRadius());
    ofDisableSmoothing();
    ofFill();
	
    ofPushStyle();
    ofEnableAlphaBlending();
    
    if(hl_alpha > 0){
        ofSetColor(highlight_color, hl_alpha);
        ofCircle(0, 0, getRadius());
        
        ofNoFill();
        ofEnableSmoothing();
        ofCircle(0, 0, getRadius()+(255-hl_alpha)/2);
        ofDisableSmoothing();
        ofFill();
        
        hl_alpha-=5;
    }

    if(isSleeping()) {
        ofSetColor(255, 100);
        ofCircle(0, 0, getRadius());
    }
    ofPopStyle();
    

    ofPopMatrix();

}