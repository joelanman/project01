//
//  objectInfo.h
//  emptyExample
//
//  Created by Gerard Rallo on 04/02/2013.
//
//

#pragma once

#include "ofMain.h"


class ObjectInfo{
    
public:
    
    ObjectInfo(int type, void* data);
    
    int objectType;
    void* objectData;
    
};