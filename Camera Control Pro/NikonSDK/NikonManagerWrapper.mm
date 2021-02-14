//
//  NikonManagerWrapper.mm
//  Camera Control Pro
//
//  Created by Eduardo Connor on 1/6/21.
//

#import <Foundation/Foundation.h>
#import "NikonManagerWrapper.h"
#import "NikonManager.h"
#import "Maid3d1.h"

@implementation NikonManagerWrapper

static class NikonManager *nikonManager = nil;

-(id)init {
    if (self = [super init]) {
        nikonManager =  NikonManager::getInstance();
    }
   
    return self;
}

- (void) resetInstance
{
    NikonManager::resetInstance();
}

- (int) getCapUnsigned: (int) ulCapID : (ULONG*) ulValue
{
    return nikonManager->getCapUnsigned(ulCapID, ulValue);
}

- (bool)    getCapBool: (int) ulCapID
{
    return nikonManager->getCapBool(ulCapID);
}

- (bool)   setCapBool: (int) ulCapID : (bool) bFlag
{
    return nikonManager->setCapBool(ulCapID, bFlag);
}

- (bool)   setCapUnsigned: (int) ulCapID : (ULONG) ulValue
{
    return nikonManager->setCapUnsigned(ulCapID, ulValue);
}

- (bool)   setCapDouble: (int) ulCapID : (double) fValue
{
    return nikonManager->setCapDouble(ulCapID, fValue);
}


- (bool)   setCapRange: (int) ulCapID : (double) fValue
{
    return nikonManager->setCapRange(ulCapID, fValue);
}

- (bool)   setCapEnum: (int) capId : (int) index
{
    return nikonManager->setCapEnum(capId, index);
}

- (double) getCapDouble: (int) ulCapID
{
    return nikonManager->getCapDouble(ulCapID);
}

- (int)  getCapEnumIndex: (int) capId // current index (zero-based)
{
    return nikonManager->getCapEnumIndex(capId);
}



- (int)  getCapRange: (int) ulCapID : (LPNkMAIDRange) pRange
{
    return nikonManager->getCapRange(ulCapID, pRange);
}

- (bool)  getCapString: (int )capId : (char *)psString;
{
    return nikonManager->getCapString(capId, psString);
}

- (bool) getCapInfoObj: (void*) ppCapArray : (int) count
{
    return nikonManager->getCapInfo((LPNkMAIDCapInfo)ppCapArray, count);
}

- (bool) getCapArray: ( void*) pStEnum : (int) capId;
{
    return nikonManager->getCapArray((LPNkMAIDEnum) pStEnum, capId);
}

- (int) getCapCount
{
    return nikonManager->getCapCount();
}

- (int) getSrcId
{
    return nikonManager->getSrcId();
}

- (char *) getEnumString: (int) capId : (int) itemId
{
    return nikonManager->getEnumString(capId, itemId);
}

- (bool) canSet: (int) capId
{
    return nikonManager->canSet(capId);
}

- (bool) cameraConnected
{
    return nikonManager->cameraConnected();
}

- (bool) enumCapabilities: (uint32_t*) pulCapCount : (LPNkMAIDCapInfo*) ppCapArray : (LPNKFUNC) pfnComplete : (NKREF) refComplete
{
    return nikonManager->enumCapabilities(  pulCapCount,  ppCapArray,  pfnComplete,  refComplete);
}

- (void)async
{
    nikonManager->async();
}


- (double)  asyncRate
{
    return nikonManager->asyncRate();
}

- (void)dealloc
{
    delete nikonManager;
}
@end
