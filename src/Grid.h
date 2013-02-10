#pragma once

#include "ofMain.h"
#define _C 20
#define _R 16


class Grid{
	
public:
    
    Grid();
    
    int columns = _C;
    int rows = _R;
    
    char _grid[_C][_R];
    void draw();
    ofVec2f randomEmptySpot();
    
};


