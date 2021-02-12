//
//  NikonManagerWrapper.h
//  Camera Control Pro
//
//  Created by Eduardo Connor on 1/6/21.
//

#ifndef NikonManagerWrapper_h
#define NikonManagerWrapper_h

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "Maid3d1.h"

@class NkMAIDCapInfoObj;

@class CameraObject;

@interface NikonManagerWrapper : NSObject

@property (nonatomic, weak) CameraObject *cameraObject;

@end

@interface NikonManagerWrapper()
- (int)     getCapUnsigned: (int) ulCapID : (ULONG*) ulValue;
- (bool)    getCapBool: (int) ulCapID;

- (double)  getCapDouble:   (int) ulCapID;
- (int)     getCapEnumIndex: (int) capId; // returns current index (zero-based)
- (int)     getCapRange: (int) ulCapID :(LPNkMAIDRange) pRange;
- (bool)    getCapString: (int )capId : (char *)psString;

- (bool) getCapArray:   (void*) ppCapArray : (int) capId;
- (bool) getCapInfoObj: (void*) ppCapArray : (int) count;

- (char *) getEnumString: (int) capId : (int) itemId;



- (bool)   setCapBool: (int) ulCapID : (bool) bFlag;
- (bool)   setCapUnsigned: (int) ulCapID : (ULONG) ulValue;
- (bool)   setCapDouble: (int) ulCapID : (double) fValue;
- (bool)   setCapRange: (int) ulCapID : (double) fValue;
- (bool)   setCapEnum: (int) capId : (int) index;

- (bool) canSet: (int) capId;

- (int)getCapCount;

- (bool) enumCapabilities: (uint32_t*) pulCapCount : (LPNkMAIDCapInfo*) ppCapArray : (LPNKFUNC) pfnComplete : (NKREF) refComplete;
- (void)async;

- (void) resetInstance;

- (bool) resetSourceCommandLoop : (int) ulSrcID;

@end

#endif /* NikonManagerWrapper_h */
