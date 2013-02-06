//
//  objectInfo.h
//  emptyExample
//
//  Created by Gerard Rallo on 04/02/2013.
//
//

#pragma once

#include "ofMain.h"


class objectInfo{
    
public:
    
    objectInfo(int type, void* data);
    
    int objectType;
    void* objectData;
    
};