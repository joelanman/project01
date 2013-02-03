#pragma once

#include "ofMain.h"
#define _C 15
#define _R 12


class grid{
	
public:
    
    grid();
    
    int columns = _C;
    int rows = _R;
    
    char _grid[_C][_R];
    void draw();
    
};


