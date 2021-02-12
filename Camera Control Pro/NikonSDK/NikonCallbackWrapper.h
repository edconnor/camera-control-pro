//
//  NikonCallbackWrapper.h
//  Camera Control Pro
//
//  Created by Eduardo Connor on 1/6/21.
//

#ifndef NikonCallbackWrapper_h
#define NikonCallbackWrapper_h
#import <AVFoundation/AVFoundation.h>
#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@class CameraObject;

@interface NikonCallbackWrapper : NSObject
@property (nonatomic, weak) CameraObject *cameraObject;

- (void)callbackEvent: (NSInteger) capId :(NSInteger)objectType : (NSInteger) eventType;

@end

#endif /* NikonCallbackWrapper_h */
