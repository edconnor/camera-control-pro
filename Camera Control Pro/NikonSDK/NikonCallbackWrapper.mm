//
//  NikonCallbackWrapper.m
//  Camera Control Pro
//
//  Created by Eduardo Connor on 1/6/21.
//

#import <Foundation/Foundation.h>
#import "NikonCallbackWrapper.h"
#import "NikonCallback.h"


#import "Camera_Control_Pro-Swift.h"

@implementation NikonCallbackWrapper

static class NikonCallback *nikonCallback = nil;

-(id)init {
    if (self = [super init]) {
        nikonCallback = new NikonCallback(self);
    }
  
    return self;
}

- (void)callbackEvent: (NSInteger) capId :(NSInteger)objectType : (NSInteger) eventType
{
    CameraObject* cameraObject = (CameraObject*)_cameraObject;
   [cameraObject callbackEventWithCapId:capId objectType:objectType eventType:eventType];
}

- (void)dealloc
{
    delete nikonCallback;
}

@end
