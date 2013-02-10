
#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "ofxBox2d.h"

#include "Grid.h"
#include "PlayerInfo.h"
#include "Peg.h"
#include "Item.h"
#include "ObjectInfo.h"
#include "Star.h"
#include "BlackHole.h"

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
    
    Star                star;
    
    list<Star*>         stars;
    list<Item*>         items;
    
    vector <Peg*>       pegs;
    
    ofxBox2d            box2d;
    PlayerInfo          player_01;
    PlayerInfo          player_02;
    Grid                mygrid;
    
    ofSoundPlayer       xylo[10];

};


