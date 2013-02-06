#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){
    
    ofRegisterTouchEvents(this);
	// initialize the accelerometer
	ofxAccelerometer.setup();
    
    ofxiPhoneAlerts.addListener(this);
	ofSetFrameRate(60);
    
    
    box2d.init();
    box2d.setGravity(0, 0);
    box2d.setFPS(60);
    
    ofRectangle bounds(0, -500, 768, 2500);
    box2d.createBounds(bounds);
    box2d.setIterations(1, 1); // minimum for IOS
    
    mygrid = grid();
    
    for(int i = 0; i < mygrid.columns; i++){
        for(int j = 0; j < mygrid.rows; j++){
            if(mygrid._grid[i][j] == 'P'){
                peg p;
                p.setPhysics(0, 0.1, 1000);
                p.enableGravity(false);
                float _x = ((ofGetWidth()+40) / (mygrid.columns)) * i + (ofGetWidth() / mygrid.columns)/2 - 13;
                float _y = (ofGetWidth() / mygrid.columns) * j;
                p.setup(box2d.getWorld(), _x, _y+230, 4);
                pegs.push_back(p);
            }
        }
    }
    
    initStar();
    
    player_01.init(&box2d, ofColor(240, 120, 120));
    player_02.init(&box2d, ofColor(120, 120, 240));
    
    player_01.setGravity(100);
    player_02.setGravity(-100);
	
	//If you want a landscape oreintation 
	//iPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
    ofAddListener(box2d.contactStartEvents, this, &testApp::solveCollision);
	
	ofBackground(220,220,220);
}





//--------------------------------------------------------------
void testApp::update(){
    
    if(star.picked){
        star.destroy();
        initStar();
    }
    
    player_01.updateBalls();
    player_02.updateBalls();
    
    deactivateBalls();
    
    
   /* ofVec2f gravity = ofxAccelerometer.getForce();
    gravity.y *= -1;
    gravity *= 30;
    box2d.setGravity(gravity);
    */
    
    box2d.update();
}

//--------------------------------------------------------------
void testApp::draw(){
    
    drawBackground();
    
    drawScores();
    
    if((player_01.b_to_go > 0)||(player_02.b_to_go > 0)){
    
        ofSetColor(240,240,120);
        star.draw();
        
        // Draw pegs
        ofSetColor(140);
        for(vector<peg>::iterator it = pegs.begin(); it != pegs.end(); ++it) {
            it->draw();
        }
        
        ofSetColor(240, 120, 120);
        player_01.drawBalls();
        ofPushMatrix();
        ofTranslate(ofGetWidth(), ofGetHeight());
        ofRotate(180);
        player_01.drawInfo();
        ofPopMatrix();
        
        ofSetColor(120, 120, 240);
        player_02.drawBalls();
        player_02.drawInfo();
    
    }
    
    
    //ofSetColor(90);
    //ofDrawBitmapString("double tap to add more", 20, 30);
    //ofDrawBitmapString(ofToString(ofGetFrameRate(), 0)+" fps", 20, 50);
}

//--------------------------------------------------------------
void testApp::exit(){

}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){
    
    if(touch.y < ofGetHeight()/2){
        player_01.dropBall(touch.x, 50);
    }else{
        player_02.dropBall(touch.x, ofGetHeight() - 50);
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
    if((player_01.b_count == 0)&&(player_01.b_count == 0)){
        
    }
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






//--------------------------------------------------------------
//  Things that will end up in a propper Class
//--------------------------------------------------------------


void testApp::deactivateBalls(){
    for(vector<ball*>::iterator it = player_01.balls.begin(); it != player_01.balls.end(); ++it) {
        if((*it)->getPosition().y > ofGetHeight() - 180){
            if((*it)->getPosition().y > ofGetHeight() + 40){
                if((*it)->body->IsActive()){
                    (*it)->body->SetActive(false);
                    if((*it)->has_star) player_01.score++;
                    (*it)->has_star = false;
                    player_01.b_to_go--;
                }
            }else{
                b2Filter f;
                f.categoryBits = 0x0002;
                f.maskBits     = 0x0000;
                (*it)->setFilterData(f);
            }
        }
    }
    for(vector<ball*>::iterator it = player_02.balls.begin(); it != player_02.balls.end(); ++it) {
        if((*it)->getPosition().y < 180){
            if((*it)->getPosition().y < -40){
                if((*it)->body->IsActive()){
                    (*it)->body->SetActive(false);
                    if((*it)->has_star) player_02.score++;
                    (*it)->has_star = false;
                    player_02.b_to_go--;
                }
            }else{
                b2Filter f;
                f.categoryBits = 0x0002;
                f.maskBits     = 0x0000;
                (*it)->setFilterData(f);
            }
        }
    }
}


void testApp::drawBackground(){
    
    
    if(player_01.score > player_02.score){
        ofBackground(240, 200, 200);
    }else if(player_01.score < player_02.score){
        ofBackground(200, 200, 240);
    }else{
        ofBackground(240);
    }
    
    if((player_01.b_count > 0)||(player_02.b_count > 0)){
        ofSetColor(230);
        ofFill();
        ofRect(0, 0, ofGetWidth(), 200);
        ofRect(0, ofGetHeight() - 200, ofGetWidth(), 200);
        ofLine(0, ofGetHeight()/2, ofGetWidth(), ofGetHeight()/2);
    }
}


void testApp::drawScores(){
    ofSetColor(225);
    ofFill();
    for (int i = 0; i < player_01.score; i++) {
        ofCircle(i*30 + 10 + (ofGetWidth() / 2) - (player_01.score*15), (ofGetHeight() / 2) - 15, 10);
    }
    for (int i = 0; i < player_02.score; i++) {
        ofCircle(i*30 + 10 + (ofGetWidth() / 2) - player_02.score*15, (ofGetHeight() / 2) + 15, 10);
    }
}


void testApp::initStar(){
    ofVec2f pos = mygrid.randomEmptySpot();
    float _x = ((ofGetWidth()+40) / (mygrid.columns)) * pos.x + (ofGetWidth() / mygrid.columns)/2 - 13;
    float _y = (ofGetWidth() / mygrid.columns) * pos.y;
    star.setPhysics(0, 0.1, 1000);
    star.setup(box2d.getWorld(), _x, _y+230, 12);
    star.init();
    star.body->GetFixtureList()->SetSensor(true);
    star.setData(new objectInfo(2,&star));
}

void testApp::shuffleStar(){
    ofVec2f pos = mygrid.randomEmptySpot();
    
    float _x = ((ofGetWidth()+40) / (mygrid.columns)) * pos.y + (ofGetWidth() / mygrid.columns)/2 - 13;
    float _y = (ofGetWidth() / mygrid.columns) * pos.x;
    
    star.body->GetFixtureList()->SetSensor(false);
    star.setPosition(pos);
    star.body->GetFixtureList()->SetSensor(true);
    star.picked   = false;
}






void testApp::solveCollision(ofxBox2dContactArgs & contact){
    void* bodyUserData_a = contact.a->GetBody()->GetUserData();
    void* bodyUserData_b = contact.b->GetBody()->GetUserData();
    
    
    if((bodyUserData_b)&&(bodyUserData_a)){
        objectInfo* A = static_cast<objectInfo*>(bodyUserData_a);
        objectInfo* B = static_cast<objectInfo*>(bodyUserData_b);
        int oTb = B->objectType;
        int oTa = A->objectType;
        
        // (oT == 1) -> ball   // (oT == 2) -> star
        
        if((oTa == 2)||(oTb == 2)){
            
            ball* b;
            item* s;
            
            if(oTa == 2){
                s = static_cast<item*>(A->objectData);
                b = static_cast<ball*>(B->objectData);
            }else{
                s = static_cast<item*>(B->objectData);
                b = static_cast<ball*>(A->objectData);
            }
            
            if ((!b->has_star)&&(!s->picked)) {
                
                b->has_star = true;
                s->picked   = true;
                
            }
            
        }else{
            
            ball* b1 = static_cast<ball*>(A->objectData);
            ball* b2 = static_cast<ball*>(B->objectData);
            
            bool aux = b1->has_star;
            b1->has_star = b2->has_star;
            b2->has_star = aux;
            
            
        }
            
    
    }
    
}
















