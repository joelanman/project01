#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){
    
    ofRegisterTouchEvents(this);
	// initialize the accelerometer
	ofxAccelerometer.setup();
    
    ofxiPhoneAlerts.addListener(this);
	ofSetFrameRate(60);
	ofBackgroundHex(0xfdefc2);
    
    
    box2d.init();
    box2d.setGravity(0, 0);
    box2d.setFPS(60);
    box2d.registerGrabbing();
    
    ofRectangle bounds(-200, -500, 1168, 2500);
    box2d.createBounds(bounds);
    box2d.setIterations(1, 1); // minimum for IOS
    
    mygrid = grid();
    
    for(int i = 0; i < mygrid.rows; i++){
        for(int j = 0; j < mygrid.columns; j++){
            if(mygrid._grid[i][j] == 'P'){
                ofxBox2dCircle c;
                c.setPhysics(0, 0.1, 1000);
                c.enableGravity(false);
                float _x = (ofGetWidth() / mygrid.columns) * j + (ofGetWidth() / mygrid.columns)/2;
                float _y = (ofGetWidth() / mygrid.columns) * i;
                c.setup(box2d.getWorld(), _x, _y+250, 8);
                circles.push_back(c);
            }
        }
    }
	
	//If you want a landscape oreintation 
	//iPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
	
	ofBackground(220,220,220);
}

//--------------------------------------------------------------
void testApp::update(){
    
    for(vector<ofxBox2dCircle>::iterator it = balls_01.begin(); it != balls_01.end(); ++it) {
        it->addForce(ofVec2f(0, 1), 100);
    }
    for(vector<ofxBox2dCircle>::iterator it = balls_02.begin(); it != balls_02.end(); ++it) {
        it->addForce(ofVec2f(0, 1), -100);
    }
    
   /* ofVec2f gravity = ofxAccelerometer.getForce();
    gravity.y *= -1;
    gravity *= 30;
    box2d.setGravity(gravity);
    */
    
    box2d.update();
}

//--------------------------------------------------------------
void testApp::draw(){
   // mygrid.draw();
    ofSetHexColor(0xABDB44);
    for(vector<ofxBox2dCircle>::iterator it = circles.begin(); it != circles.end(); ++it) {
        it->draw();
    }
    ofSetColor(240, 120, 120);
    for(vector<ofxBox2dCircle>::iterator it = balls_01.begin(); it != balls_01.end(); ++it) {
        it->draw();
    }
    ofSetColor(120, 120, 240);
    for(vector<ofxBox2dCircle>::iterator it = balls_02.begin(); it != balls_02.end(); ++it) {
        it->draw();
    }
    
    ofSetColor(90);
    ofDrawBitmapString("double tap to add more", 20, 30);
    ofDrawBitmapString(ofToString(ofGetFrameRate(), 0)+" fps", 20, 50);
}

//--------------------------------------------------------------
void testApp::exit(){

}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){
    ofxBox2dCircle c;
    c.setPhysics(4, 0.5, 0.05);
    
    if(touch.y < ofGetHeight()/2){
        c.setup(box2d.getWorld(), touch.x, 50, 25);
        c.addForce(ofVec2f(0, 1), 10000);
        balls_01.push_back(c);
    }else{
        c.setup(box2d.getWorld(), touch.x, ofGetHeight() - 50, 25);
        c.addForce(ofVec2f(0, 1), -10000);
        balls_02.push_back(c);
    }
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void testApp::lostFocus(){

}

//--------------------------------------------------------------
void testApp::gotFocus(){

}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){

}

