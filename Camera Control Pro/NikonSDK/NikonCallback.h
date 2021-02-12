//
//  NikonCallback.hpp
//  Camera Control Pro
//
//  Created by Eduardo Connor on 1/6/21.
//

#ifndef NikonCallback_h
#define NikonCallback_h

#include <stdio.h>


@class NikonCallbackWrapper;

class NikonCallback
{
public:
    static NikonCallback *instance;
    
public:
    NikonCallback();
    NikonCallback(NikonCallbackWrapper* pNikonCallbackWrapper);
    virtual ~NikonCallback();
    
    void callbackEvent  (int capId, int objectType, int eventType);
        
public:
    NikonCallbackWrapper* nikonCallbackWrapper;
};
#endif /* NikonCallback_h */
