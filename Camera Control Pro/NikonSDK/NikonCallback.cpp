//
//  NikonCallback.cpp
//  Camera Control Pro
//
//  Created by Eduardo Connor on 1/6/21.
//

#include "NikonCallback.h"
#include "NikonCallbackWrapper.h"
#import <Foundation/Foundation.h>

NikonCallback *NikonCallback::instance = 0;

NikonCallback::NikonCallback() 
{
    instance = this;
    nikonCallbackWrapper = [[NikonCallbackWrapper alloc] init];
}
 
NikonCallback::NikonCallback(NikonCallbackWrapper* pNikonCallbackWrapper)
{
    instance = this;
    nikonCallbackWrapper = pNikonCallbackWrapper;
}

NikonCallback::~NikonCallback()
{
}

void NikonCallback::callbackEvent  (int capId, int objectType, int eventType)
{
    [nikonCallbackWrapper callbackEvent: capId: objectType: eventType];
}
