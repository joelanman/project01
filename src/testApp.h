#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "ofxBox2d.h"

#include "grid.h"
#include "playerInfo.h"
#include "peg.h"
#include "item.h"
#include "objectInfo.h"

class testApp : public ofxiPhoneApp{
	
    public:
    
    void setup();
    void update();
    void draw();
    void exit();

    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);

    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);
    
    
    //----------------------------------------
    // Things that will end up in a Class
    //----------------------------------------
    void deactivateBalls();
    void drawBackground();
    void drawScores();
    void initStar();
    void shuffleStar();
    void solveCollision(ofxBox2dContactArgs & contact);
    ofVec2f randomEmptySpot(float radius, ofRectangle boudaries);
    
    
    item                star;
    vector <peg*>       pegs;
    
    ofxBox2d            box2d;
    playerInfo          player_01;
    playerInfo          player_02;
    grid                mygrid;

};


