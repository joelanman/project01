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
    
    mygrid = Grid();
    
    int it = 0;
    
    for(char i = '0'; i <= '9'; i++){
        printf("this is not working....\n");
        stringstream ss;
        string s;
        ss << "xylo/00" << i << ".caf";
        ss >> s;
        xylo[it].loadSound(s);
        xylo[it].setMultiPlay(true);
        it++;
    }
    
    
    
    /*
    for(int i = 0; i < mygrid.columns; i++){
        for(int j = 0; j < mygrid.rows; j++){
            if(mygrid._grid[i][j] == 'P'){
                peg p;
                p.setPhysics(0, 0.1, 1000);
                p.enableGravity(false);
                float _x = ((ofGetWidth()+30) / (mygrid.columns)) * i + (ofGetWidth() / mygrid.columns)/2 - 8;
                float _y = (ofGetWidth() / mygrid.columns) * j;
                p.setup(box2d.getWorld(), _x, _y+230, 4);
                pegs.push_back(p);
            }
        }
    }*/
    
    ofColor palette[5];
    palette[0] = ofColor(174,255,0);
    palette[1] = ofColor(132,255,0);
    palette[2] = ofColor(38,255,0);
    palette[3] = ofColor(0,255,85);
    palette[4] = ofColor(0,255,128);
    
    
    
    for(int i = 0; i < 30; i++){
        
        int rand = (int)(floor(ofRandom(4.999)));
        
        Peg* p = new Peg(palette[rand]);
        
        bool fit = false;
        
        float r = 0;
        float x = 0;
        float y = 0;
        
        while (!fit) {
            r = ofRandom(5, 100);
            x = ofRandom(-1*r, ofGetWidth()+r);
            y = ofRandom(130+r, ofGetHeight()-130-r);
            
            if(((x > 0)&&(x < r+40)) || ((x > ofGetWidth()-r-40)&&(x < ofGetWidth()))) continue;
            
            fit = true;
            
            for(vector<Peg*>::iterator it = pegs.begin(); it != pegs.end(); ++it) {
                if ( ofDist( (*it)->getPosition().x, (*it)->getPosition().y, x, y ) < (r+(*it)->getRadius()+40) ) {
                    fit = false;
                    continue;
                }
            }
        }
        
        p->setPhysics(0, 0.1, 1000);
        p->enableGravity(false);
        p->setup(box2d.getWorld(), x, y, r);

        p->setData(new ObjectInfo(3,p));
        
        pegs.push_back(p);
        
    }
    
    
    initStar();
    initStar();
    initStar();
   
    
    player_01.init(&box2d, ofColor(0,225,255));
    player_02.init(&box2d, ofColor(252,2,137));
   
    
 //   player_01.init(&box2d, ofColor(0,169,224));
 //   player_02.init(&box2d, ofColor(152,199,61));
    
    player_01.setGravity(100);
    player_02.setGravity(-100);
	
	//If you want a landscape oreintation 
	//iPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
    ofAddListener(box2d.contactStartEvents, this, &testApp::solveCollision);
	
	ofBackground(220,220,220);
}





//--------------------------------------------------------------
void testApp::update(){
    
    float rand = ofRandom(100);
    if(rand < 0.1){
        float rad = ofRandom(30, 60);
        ofVec2f pos = randomEmptySpot(rad, ofRectangle(50, 200, ofGetWidth()-100, ofGetHeight() -400));

        BlackHole* bh = new BlackHole();
        
        bh->setPhysics(0, 0.1, 1000);
        bh->setup(box2d.getWorld(), pos.x, pos.y, rad);
        bh->init();
        bh->body->GetFixtureList()->SetSensor(true);
        
        bh->setData(new ObjectInfo(4,bh));
        
        items.clear();
        
        items.push_back(bh);
        
    }
    
    list<Star*>::iterator it = stars.begin();
    while (it != stars.end())
    {
        if((*it)->picked){
            (*it)->destroy();
            it = stars.erase(it);
            initStar();
        }else{
            it++;
        }
    }
    
    
    player_01.updateBalls();
    player_02.updateBalls();
    
    deactivateBalls();
    
    box2d.update();
}

//--------------------------------------------------------------
void testApp::draw(){
    
    drawBackground();
    
    if((player_01.b_to_go > 0)||(player_02.b_to_go > 0)){
        
        // Draw Items
        for(list<Item*>::iterator it = items.begin(); it != items.end(); ++it) {
            // if((*it)->objectType() == 0x0004)
            (*it)->draw();
        }
        
    
        for(list<Star*>::iterator it = stars.begin(); it != stars.end(); ++it){
            (*it)->draw();
        }
        
        
        // Draw pegs
        ofSetColor(220);
        for(vector<Peg*>::iterator it = pegs.begin(); it != pegs.end(); ++it) {
            ofSetCircleResolution((*it)->getRadius());
            (*it)->draw();
        }
        
        
        
        ofSetCircleResolution(22);
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
    
    drawScores();
    
    
    //ofSetColor(90);
    //ofDrawBitmapString("double tap to add more", 20, 30);
    //ofDrawBitmapString(ofToString(ofGetFrameRate(), 0)+" fps", 20, 50);
}

//--------------------------------------------------------------
void testApp::exit(){

}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){
    if(touch.y < 150){
        player_01.dropBall(touch.x, 50);
    }else if(touch.y > ofGetHeight()- 150){
        player_02.dropBall(touch.x, ofGetHeight() - 50);
    }else{
        float imp = 5000;
        if(touch.x < ofGetWidth()/2) imp = -5000;
        
        for(list<Ball*>::iterator it = player_01.balls.begin(); it != player_01.balls.end(); ++it) {
            (*it)->addImpulseForce(ofVec2f(imp,0),ofVec2f((*it)->body->GetWorldCenter().x, (*it)->body->GetWorldCenter().y));
        }
        for(list<Ball*>::iterator it = player_02.balls.begin(); it != player_02.balls.end(); ++it) {
            (*it)->addImpulseForce(ofVec2f(imp,0),ofVec2f((*it)->body->GetWorldCenter().x, (*it)->body->GetWorldCenter().y));
        }
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
    for(list<Ball*>::iterator it = player_01.balls.begin(); it != player_01.balls.end(); ++it) {
        if((*it)->getPosition().y > ofGetHeight() - 180){
            if((*it)->getPosition().y > ofGetHeight() + 40){
                if((*it)->body->IsActive()){
                    (*it)->body->SetActive(false);
                    if((*it)->has_star) player_01.score++;
                    (*it)->has_star = false;
                    (*it)->dead = true;
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
    for(list<Ball*>::iterator it = player_02.balls.begin(); it != player_02.balls.end(); ++it) {
        if((*it)->getPosition().y < 180){
            if((*it)->getPosition().y < -40){
                if((*it)->body->IsActive()){
                    (*it)->body->SetActive(false);
                    if((*it)->has_star) player_02.score++;
                    (*it)->has_star = false;
                    (*it)->dead = true;
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
    
    if((player_01.b_to_go == 0)&&(player_02.b_to_go == 0)){
        if(player_01.score > player_02.score){
            ofBackground(0,225,255);
        }else if(player_01.score < player_02.score){
            ofBackground(252,2,137);
        }else{
            ofBackground(240);
        }
    }else{
        ofBackground(240);
        
        ofSetColor(235);
        ofFill();
        ofLine(0, 100, ofGetWidth(), 100);
        ofRect(0, 99, ofGetWidth(), 3);
        ofLine(0, ofGetHeight() - 100, ofGetWidth(), ofGetHeight() - 100);
        ofRect(0, ofGetHeight() - 101, ofGetWidth(), 3);
    }
    
}


void testApp::drawScores(){
    ofEnableAlphaBlending();
    ofSetColor(255, 255, 255, 150);
    ofFill();
    for (int i = 0; i < player_01.score; i++) {
        ofCircle(i*30 + 10 + (ofGetWidth() / 2) - (player_01.score*15), (ofGetHeight() / 2) - 15, 10);
    }
    for (int i = 0; i < player_02.score; i++) {
        ofCircle(i*30 + 10 + (ofGetWidth() / 2) - player_02.score*15, (ofGetHeight() / 2) + 15, 10);
    }
    ofDisableAlphaBlending();
}



ofVec2f testApp::randomEmptySpot(float radius, ofRectangle boundaries){
    
    bool fit = false;
    
    float r = radius;
    float x = 0;
    float y = 0;
    
    while (!fit) {
        
        x = ofRandom(boundaries.getMinX(), boundaries.getMaxX());
        y = ofRandom(boundaries.getMinY(), boundaries.getMaxY());
        
        fit = true;
        
        for(vector<Peg*>::iterator it = pegs.begin(); it != pegs.end(); ++it) {
            if ( ofDist( (*it)->getPosition().x, (*it)->getPosition().y, x, y ) < (r+(*it)->getRadius()) ) {
                fit = false;
                continue;
            }
        }
        
        for(list<Star*>::iterator it = stars.begin(); it != stars.end(); it++){
            if ( ofDist( (*it)->getPosition().x, (*it)->getPosition().y, x, y ) < (r+(*it)->getRadius()) ) {
                fit = false;
                continue;
            }
        }
    }

    return ofVec2f(x,y);
    
}






void testApp::initStar(){
    
    ofVec2f pos = randomEmptySpot(12, ofRectangle(0, 200, ofGetWidth(), ofGetHeight() -400) );
    Star* s = new Star();
    
    
    s->setPhysics(0, 0.1, 1000);
    s->setup(box2d.getWorld(), pos.x, pos.y, 12);
    s->init();
    s->body->GetFixtureList()->SetSensor(true);
    s->setData(new ObjectInfo(2,s));
    
    stars.push_back(s);
    
    int i;
    i++;
    
    /*
    ofVec2f pos = randomEmptySpot(12, ofRectangle(0, 200, ofGetWidth(), ofGetHeight() -400) );
    star.setPhysics(0, 0.1, 1000);
    star.setup(box2d.getWorld(), pos.x, pos.y, 12);
    star.init();
    star.body->GetFixtureList()->SetSensor(true);
    star.setData(new ObjectInfo(2,&star));
     */
    
}

void testApp::shuffleStar(){
    ofVec2f pos = mygrid.randomEmptySpot();
    
    //float _x = ((ofGetWidth()+40) / (mygrid.columns)) * pos.y + (ofGetWidth() / mygrid.columns)/2 - 13;
    //float _y = (ofGetWidth() / mygrid.columns) * pos.x;
    
    star.body->GetFixtureList()->SetSensor(false);
    star.setPosition(pos);
    star.body->GetFixtureList()->SetSensor(true);
    star.picked   = false;
}






void testApp::solveCollision(ofxBox2dContactArgs & contact){
    void* bodyUserData_a = contact.a->GetBody()->GetUserData();
    void* bodyUserData_b = contact.b->GetBody()->GetUserData();
    
    
    if((bodyUserData_b)&&(bodyUserData_a)){
        ObjectInfo* A = static_cast<ObjectInfo*>(bodyUserData_a);
        ObjectInfo* B = static_cast<ObjectInfo*>(bodyUserData_b);
        int oTb = B->objectType;
        int oTa = A->objectType;
        
        // (oT == 1) -> ball   // (oT == 2) -> star
        
        if((oTa == 2)||(oTb == 2)){
            
            Ball* b;
            Item* s;
            
            if(oTa == 2){
                s = static_cast<Item*>(A->objectData);
                b = static_cast<Ball*>(B->objectData);
            }else{
                s = static_cast<Item*>(B->objectData);
                b = static_cast<Ball*>(A->objectData);
            }
            
            if ((!b->has_star)&&(!s->picked)) {
                
                b->has_star = true;
                s->picked   = true;
                
            }
            
        }else if((oTa == 1)&&(oTb == 1)){
            
            Ball* b1 = static_cast<Ball*>(A->objectData);
            Ball* b2 = static_cast<Ball*>(B->objectData);
            
            bool aux = b1->has_star;
            b1->has_star = b2->has_star;
            b2->has_star = aux;
            
            xylo[5].play();
            
            
        }else if((oTa == 3)||(oTb == 3)){
            
            Peg* p;
            
            if(oTa == 3)    p = static_cast<Peg*>(A->objectData);
            else            p = static_cast<Peg*>(B->objectData);
            
            xylo[ 9 - (int)(floor(p->getRadius()/10)) ].play();
            p->hl_alpha = 255;
             
        }else if((oTa == 4)||(oTb == 4)){
            
            Ball* b;
            
            if(oTa == 4)    b = static_cast<Ball*>(B->objectData);
            else            b = static_cast<Ball*>(A->objectData);
            
            b->killedby = 4;
            
        }
        
    }
    
}
















