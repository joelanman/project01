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
    
    
    
    player_01.init(&box2d, ofColor(0,225,255));
    player_02.init(&box2d, ofColor(252,2,137));
    
    
    
    initGame();
    
	
    ofAddListener(box2d.contactStartEvents, this, &testApp::solveCollision);
	
	ofBackground(220,220,220);
}












//--------------------------------------------------------------
void testApp::update(){
    
    float rand = ofRandom(100);
    if(rand < 0.2){
        
        int itmClass = 5;
        
        float rad = 20;
        
        if(rand < 0.1){
            rad = ofRandom(30, 60);
            itmClass = 4;
        }
        
        ofVec2f pos = randomEmptySpot(rad + 15, ofRectangle(50, 200, ofGetWidth()-100, ofGetHeight() -400));
        
        Item* itm;
        
        if(rand < 0.1)  itm = new BlackHole();
        else            itm = new Mitosis();
        
        itm->setPhysics(0, 0.1, 1000);
        itm->setup(box2d.getWorld(), pos.x, pos.y, rad);
        itm->init();
        itm->body->GetFixtureList()->SetSensor(true);
        
        itm->setData(new ObjectInfo(itmClass,itm));
        
        if(itmClass == 4){
            list<Item*>::iterator it = items.begin();
            while (it != items.end())
            {
                if((*it)->objectType() == 0x0004){
                    (*it)->destroy();
                    it = items.erase(it);
                }else{
                    it++;
                }
            }
        }
        
        items.push_back(itm);
        
    }
    
    list<Item*>::iterator it01 = items.begin();
    while (it01 != items.end())
    {
        if((*it01)->picked){
            
            if((*it01)->objectType() == 5){
                (*it01)->pickedby->player->multiplyBalls(3, (*it01)->getPosition().x, (*it01)->getPosition().y);
            }
            
            (*it01)->destroy();
            it01 = items.erase(it01);
        }else if((*it01)->dead){
            (*it01)->destroy();
            it01 = items.erase(it01);
        }else{
            it01++;
        }
    }
    
    list<Star*>::iterator it02 = stars.begin();
    while (it02 != stars.end())
    {
        if((*it02)->picked){
            (*it02)->destroy();
            it02 = stars.erase(it02);
            initStar();
        }else{
            it02++;
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
        for(list<Peg*>::iterator it = pegs.begin(); it != pegs.end(); ++it) {
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
    if((player_02.b_to_go + player_01.b_to_go) == 0){
        destroyGame();
        initGame();
    }
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
        if((*it)->getPosition().y > ofGetHeight() - 140){
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
        if((*it)->getPosition().y < 140){
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
        
        for(list<Peg*>::iterator it = pegs.begin(); it != pegs.end(); ++it) {
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
        
        for(list<Item*>::iterator it = items.begin(); it != items.end(); it++){
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
            p->hit();
             
        }else if((oTa == 4)||(oTb == 4)){
            
            Ball* b;
            
            if(oTa == 4)    b = static_cast<Ball*>(B->objectData);
            else            b = static_cast<Ball*>(A->objectData);
            
            b->killedby = 4;
            if(b->player == &player_01){
                player_02.extraBalls(1);
            }else{
                player_01.extraBalls(1);
            }
            
        }else if((oTa == 5)||(oTb == 5)){
            
            Ball* b;
            Mitosis* m;
            
            if(oTa == 5){
                m = static_cast<Mitosis*>(A->objectData);
                b = static_cast<Ball*>(B->objectData);
            }else{
                m = static_cast<Mitosis*>(B->objectData);
                b = static_cast<Ball*>(A->objectData);
            }
            
            m->picked   = true;
            m->pickedby = b;
                
        }
        
    }
    
}



void testApp::destroyGame(){
    
    
    for(list<Peg*>::iterator it = pegs.begin(); it != pegs.end(); ++it) {
        (*it)->destroy();
    }
    
    for(list<Star*>::iterator it = stars.begin(); it != stars.end(); it++){
        (*it)->destroy();
    }
    
    for(list<Item*>::iterator it = items.begin(); it != items.end(); it++){
        (*it)->destroy();
    }
    
    pegs.clear();
    items.clear();
    stars.clear();
    
}







void testApp::initGame(){
    
    
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
            
            for(list<Peg*>::iterator it = pegs.begin(); it != pegs.end(); ++it) {
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
    
    player_01.reset();
    player_02.reset();
    
    player_01.setGravity(100);
    player_02.setGravity(-100);
    
}










