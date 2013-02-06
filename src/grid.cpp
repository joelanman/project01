#include "grid.h"

//--------------------------------------------------------------
grid::grid(){
    
    for(int i = 0; i < _C; i++){
        for(int j = 0; j < _R; j++){
            _grid[i][j] = 'O';
            if(ofRandom(10.0) < 5.0){
                if ((_grid[i-1][j] != 'P')&&(_grid[i][j-1] != 'P')){
                    _grid[i][j] = 'P';
                }
            }
        }
    }
    
}

//--------------------------------------------------------------
void grid::draw(){
    ofBackground(0);
    ofSetColor(0,0,255);
    ofFill();
    for (int row=0; row<10; row++) {
        for (int col=0; col<10; col++) {
            ofCircle(row*100, col*100, 30);
        }
    }
}


ofVec2f grid::randomEmptySpot(){
    int x = floor(ofRandom(_C-2) + 1);
    int y = floor(ofRandom(_R-2) + 1);
    while (_grid[x][y] != 'O') {
        x = floor(ofRandom(_C-2) + 1);
        y = floor(ofRandom(_R-2) + 1);
    }
    
    printf("x: %d, y: %d", x, y);
    
    return ofVec2f(x,y);
}