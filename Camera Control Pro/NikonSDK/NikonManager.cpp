//
//  NikonManager.cpp
//  Camera Control Pro
//
//  Created by Eduardo Connor on 1/6/21.
//   Adapted from main.cpp in Nikon sample app Type0029_CtrlSample_Mac
//

#include "NikonManager.h"
#include "NikonCallback.h"
#include "CtrlSample.h"

NikonManager *NikonManager::instance = 0;

NikonManager::NikonManager()
{
    char    ModulePath[PATH_MAX] = {0};
    BOOL    bRet;

    m_asyncPaused = true;
    
    // Search for a Module-file like "Type0029.md3".
    bRet = Search_Module( ModulePath );
    if ( bRet == FALSE ) {
        puts( "\"Type0029 Module\" is not found.\n" );
       
    }
    
    // Load the Module-file.
    bRet = Load_Module( ModulePath );
    if ( bRet == FALSE ) {
        puts( "Failed in loading \"Type0029 Module\".\n" );
      
    }
    
    // Allocate memory for reference to Module object.
    pRefMod = (LPRefObj)malloc(sizeof(RefObj));
    if ( pRefMod == NULL ) {
        puts( "There is not enough memory." );
        
    }
    InitRefObj( pRefMod );
    
    // Allocate memory for Module object.
    pRefMod->pObject = (LPNkMAIDObject)malloc(sizeof(NkMAIDObject));
    if ( pRefMod->pObject == NULL ) {
        puts( "There is not enough memory." );
        if ( pRefMod != NULL )
            free( pRefMod );
    }

    //    Open Module object
    pRefMod->pObject->refClient = (NKREF)pRefMod;
    bRet = Command_Open(    NULL,                    // When Module_Object will be opend, "pParentObj" is "NULL".
                                pRefMod->pObject,    // Pointer to Module_Object
                                ulModID );            // Module object ID set by Client
    if ( bRet == FALSE ) {
        puts( "Module object can't be opened.\n" );
        if ( pRefMod->pObject != NULL )    free( pRefMod->pObject );
        if ( pRefMod != NULL )
            free( pRefMod );
    }
    
    //    Enumerate Capabilities that the Module has.
    bRet = EnumCapabilities( pRefMod->pObject, &(pRefMod->ulCapCount), &(pRefMod->pCapArray), NULL, NULL );
    if ( bRet == FALSE ) {
        puts( "Failed in enumeration of capabilities." );
        if ( pRefMod->pObject != NULL )
            free( pRefMod->pObject );
        if ( pRefMod != NULL )
            free( pRefMod );
        
    }

    //    Set the callback functions(ProgressProc, EventProc and UIRequestProc).
    bRet = SetProc( pRefMod );
    if ( bRet == FALSE ) {
        puts( "Failed in setting a call back function." );
        if ( pRefMod->pObject != NULL )
            free( pRefMod->pObject );
        if ( pRefMod != NULL )
            free( pRefMod );
    }

    //    Set the kNkMAIDCapability_ModuleMode.
    if( CheckCapabilityOperation( pRefMod, kNkMAIDCapability_ModuleMode, kNkMAIDCapOperation_Set )  ){
        bRet = Command_CapSet( pRefMod->pObject, kNkMAIDCapability_ModuleMode, kNkMAIDDataType_Unsigned,
                                        (NKPARAM)kNkMAIDModuleMode_Controller, NULL, NULL);
        if ( bRet == FALSE ) {
            puts( "Failed in setting kNkMAIDCapability_ModuleMode." );
        }
    }
    
    //case 1:// Children
    // Select Device
    ulSrcID = 0;    // 0 means Device count is zero.
    bRet = SelectSource( pRefMod, &ulSrcID );
    if ( bRet == FALSE )
        puts( "Select Device failed in NikonManager" );
        
    if( ulSrcID > 0 )
    {
        bRet = sourceCommandLoop( pRefMod, ulSrcID );
        if (bRet == FALSE)
            puts( "SourceCommandLoop failed in NikonManager" );
    }
    m_asyncPaused = false;
}

NikonManager::~NikonManager()
{
    // Close Module_Object
    BOOL bRet = Close_Module( pRefMod );
    if ( bRet == FALSE )
        puts( "Module object can not be closed.\n" );

    // Unload Module
    if (gBundle != NULL)
    {
        CFBundleUnloadExecutable(gBundle);
        CFRelease(gBundle);
        gBundle = NULL;
    }
    
    // Free memory blocks allocated in this function.
    if ( pRefMod->pObject != NULL )
        free( pRefMod->pObject );
    if ( pRefMod != NULL )
        free( pRefMod );
}

void NikonManager::async()
{
    bool bRet = true;
    
    if  (m_asyncPaused == false)
        bRet = Command_Async( pRefMod->pObject );
}

void NikonManager::getCap(ULONG ulParam, ULONG ulDataType, NKPARAM pData)
{
    bool bRet = false;
    AsyncManager(this);
    
    bRet = Command_CapGet( pRefSrc->pObject, kNkMAIDCapability_FocalLength, kNkMAIDDataType_FloatPtr,(NKPARAM) pData, NULL, NULL );
}

int NikonManager::getCapUnsigned(ULONG ulCapID, ULONG* ulValue)
{
    AsyncManager amgr(this);
  
    return GetUnsignedCapability((LPRefObj)pRefSrc, ulCapID, ulValue);
}

BYTE NikonManager::getCapBool(ULONG ulCapID)
{
    bool bRet = false;
    BYTE ulValue = 0;
    
    AsyncManager amgr(this);
    bRet = GetBoolCapability(pRefSrc, ulCapID, &ulValue);
   
    return ulValue;
}

bool NikonManager::getCapString (ULONG ulCapID,  char *psString)
{
    AsyncManager amgr(this);
    
    return GetStringCapability( pRefSrc,  ulCapID, psString);
}

bool  NikonManager::setCapBool (ULONG ulCapID, bool bFlag)
{
    AsyncManager amgr(this);

    return SetBoolCapability(pRefSrc, ulCapID, bFlag);
}

bool  NikonManager::setCapUnsigned  (ULONG ulCapID, ULONG ulValue)
{
    AsyncManager amgr(this);
   
    return SetUnsignedCapability(pRefSrc, ulCapID, ulValue);
}

bool  NikonManager::setCapDouble    (ULONG ulCapID, double fValue)
{
    AsyncManager amgr(this);
   
    return SetFloatCapability(pRefSrc, ulCapID, fValue);
}

bool  NikonManager::setCapRange    (ULONG ulCapID, double fValue)
{
    AsyncManager amgr(this);

    return SetRangeCapability (pRefSrc, ulCapID, fValue);
}

bool NikonManager::setCapEnum (ULONG ulCapID, int index)
{
    AsyncManager amgr(this);

    return SetEnumCapability(pRefSrc, ulCapID, index);
}

double NikonManager::getCapDouble(ULONG ulCapID)
{
    AsyncManager amgr(this);
    bool bRet = false;
    double ulValue = 0;
    
    bRet = GetFloatCapability((LPRefObj)pRefSrc, ulCapID, (ULONG*)&ulValue);

    return ulValue;
}

int NikonManager::getCapRange(ULONG ulCapID,  LPNkMAIDRange pRange)
{
    AsyncManager amgr(this);

    return GetRangeCapability(pRefSrc, ulCapID, pRange);
}

int NikonManager::getCapCount()
{
    AsyncManager amgr(this);

    return GetCapCount(pRefSrc->pObject);
}

bool  NikonManager::getCapInfo(LPNkMAIDCapInfo ppCapArray,  int count)
{
    AsyncManager amgr(this);

    return GetCapInfoObj( pRefSrc->pObject, &ppCapArray, count, NULL, NULL );
}

bool NikonManager::canSet ( int capId)
{
    AsyncManager amgr(this);
    return CheckCapabilityOperation(pRefSrc, capId, kNkMAIDCapOperation_Set);
}

bool NikonManager::getCapArray (LPNkMAIDEnum pStEnum, int capId)
{
    AsyncManager amgr(this);
   
    return GetEnumArrayCapability(pRefSrc, capId, pStEnum);
}

char * NikonManager::getEnumString(int capId, int itemId)
{
    AsyncManager amgr(this);
   
    return GetEnumString(  capId,  itemId, psEnumItemString );
}

int NikonManager::getCapEnumIndex (ULONG ulCapID)
{
    AsyncManager amgr(this);
    bool bRet = false;
    int ulValue = -1;

    bRet = GetEnumCapabilityIndex (pRefSrc,ulCapID, &ulValue);
    
    return ulValue;
}

bool NikonManager::enumCapabilities( ULONG* pulCapCount, LPNkMAIDCapInfo* ppCapArray, LPNKFUNC pfnComplete, NKREF refComplete)
{
    AsyncManager amgr(this);
 
    return EnumCapabilities( pRefMod->pObject ,  pulCapCount,  ppCapArray, NULL, NULL);
}

bool NikonManager::resetSourceCommandLoop (int ulSrcID)
{
    AsyncManager amgr(this);
    bool bRet = false;
    
    // Close Source_Object
    bRet = RemoveChild( pRefMod, ulSrcID );
    if (bRet)
      sourceCommandLoop(  pRefMod, ulSrcID); // TODO ejc
    
    return bRet;
}

bool NikonManager::sourceCommandLoop( LPRefObj pRefMod, ULONG ulSrcID )
{
    pRefSrc = GetRefChildPtr_ID( pRefMod, ulSrcID );
    if ( pRefSrc == NULL ) {
        // Create Source object and RefSrc structure.
        if ( AddChild( pRefMod, ulSrcID ) == TRUE ) {
            printf("Source object is opened.\n");
        } else {
            printf("Source object can't be opened.\n");
            return false;
        }
        pRefSrc = GetRefChildPtr_ID( pRefMod, ulSrcID );
    }
    return true;
}


AsyncManager::AsyncManager(NikonManager *mgr)
{
    m_mgr = mgr;
    m_mgr->m_asyncPaused = true;
}

AsyncManager::~AsyncManager()
{
    m_mgr->m_asyncPaused = false;
}
