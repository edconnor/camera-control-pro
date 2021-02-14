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
    m_pRefMod = (LPRefObj)malloc(sizeof(RefObj));
    if ( m_pRefMod == NULL ) {
        puts( "There is not enough memory." );
        
    }
    InitRefObj( m_pRefMod );
    
    // Allocate memory for Module object.
    m_pRefMod->pObject = (LPNkMAIDObject)malloc(sizeof(NkMAIDObject));
    if ( m_pRefMod->pObject == NULL ) {
        puts( "There is not enough memory." );
        if ( m_pRefMod != NULL )
            free( m_pRefMod );
    }

    //    Open Module object
    m_pRefMod->pObject->refClient = (NKREF)m_pRefMod;
    bRet = Command_Open(    NULL,                    // When Module_Object will be opend, "pParentObj" is "NULL".
                                m_pRefMod->pObject,    // Pointer to Module_Object
                        m_ulModID );            // Module object ID set by Client
    if ( bRet == FALSE ) {
        puts( "Module object can't be opened.\n" );
        if ( m_pRefMod->pObject != NULL )    free( m_pRefMod->pObject );
        if ( m_pRefMod != NULL )
            free( m_pRefMod );
    }
    
    //    Enumerate Capabilities that the Module has.
    bRet = EnumCapabilities( m_pRefMod->pObject, &(m_pRefMod->ulCapCount), &(m_pRefMod->pCapArray), NULL, NULL );
    if ( bRet == FALSE ) {
        puts( "Failed in enumeration of capabilities." );
        if ( m_pRefMod->pObject != NULL )
            free( m_pRefMod->pObject );
        if ( m_pRefMod != NULL )
            free( m_pRefMod );
        
    }

    //    Set the callback functions(ProgressProc, EventProc and UIRequestProc).
    bRet = SetProc( m_pRefMod );
    if ( bRet == FALSE ) {
        puts( "Failed in setting a call back function." );
        if ( m_pRefMod->pObject != NULL )
            free( m_pRefMod->pObject );
        if ( m_pRefMod != NULL )
            free( m_pRefMod );
    }

    //    Set the kNkMAIDCapability_ModuleMode.
    if( CheckCapabilityOperation( m_pRefMod, kNkMAIDCapability_ModuleMode, kNkMAIDCapOperation_Set )  ){
        bRet = Command_CapSet( m_pRefMod->pObject, kNkMAIDCapability_ModuleMode, kNkMAIDDataType_Unsigned,
                                        (NKPARAM)kNkMAIDModuleMode_Controller, NULL, NULL);
        if ( bRet == FALSE ) {
            puts( "Failed in setting kNkMAIDCapability_ModuleMode." );
        }
    }
    
    //case 1:// Children
    // Select Device
    m_ulSrcID = 0;    // 0 means Device count is zero.
    bRet = SelectSource( m_pRefMod, &m_ulSrcID );
    if ( bRet == FALSE ) {
        puts( "Select Device failed in NikonManager" );
        m_asyncPaused = true;
        return;
    }

        
    if( m_ulSrcID > 0 )
    {
        bRet = sourceCommandLoop( m_pRefMod );
        if (bRet == FALSE)
            puts( "SourceCommandLoop failed in NikonManager" );
    }
    
    m_asyncPaused = false;
    m_cameraConnected = true;
}

NikonManager::~NikonManager()
{
    // Close Module_Object
    BOOL bRet = Close_Module( m_pRefMod );
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
    if ( m_pRefMod->pObject != NULL )
        free( m_pRefMod->pObject );
    if ( m_pRefMod != NULL )
        free( m_pRefMod );
}

void NikonManager::async()
{
    bool bRet = true;
    
    if (!m_cameraConnected)
        return;
    
    if  (m_asyncPaused == false)
        bRet = Command_Async(refObj()->pObject );
}

void NikonManager::asyncModule()
{
    Command_Async(m_pRefMod->pObject );
}


double NikonManager::asyncRate()
{
    AsyncManager amgr(this);
    
    ULONG ulValue = 0;

    GetUnsignedCapability(m_pRefMod, kNkMAIDCapability_AsyncRate, &ulValue);
    
    return ulValue/1000.0; // convert to miiliseconds
}

void NikonManager::getCap(ULONG ulParam, ULONG ulDataType, NKPARAM pData)
{
    bool bRet = false;
    AsyncManager(this);
    
    bRet = Command_CapGet( refObj()->pObject, kNkMAIDCapability_FocalLength, kNkMAIDDataType_FloatPtr,(NKPARAM) pData, NULL, NULL );
}

int NikonManager::getCapUnsigned(ULONG ulCapID, ULONG* ulValue)
{
    AsyncManager amgr(this);
  
    return GetUnsignedCapability(refObj(), ulCapID, ulValue);
}

BYTE NikonManager::getCapBool(ULONG ulCapID)
{
    bool bRet = false;
    BYTE ulValue = 0;
    
    AsyncManager amgr(this);
    bRet = GetBoolCapability(refObj(), ulCapID, &ulValue);
   
    return ulValue;
}

bool NikonManager::getCapString (ULONG ulCapID,  char *psString)
{
    AsyncManager amgr(this);
    
    return GetStringCapability( refObj(),  ulCapID, psString);
}

bool  NikonManager::setCapBool (ULONG ulCapID, bool bFlag)
{
    AsyncManager amgr(this);

    return SetBoolCapability(refObj(), ulCapID, bFlag);
}

bool  NikonManager::setCapUnsigned  (ULONG ulCapID, ULONG ulValue)
{
    AsyncManager amgr(this);
   
    return SetUnsignedCapability(refObj(), ulCapID, ulValue);
}

bool  NikonManager::setCapDouble    (ULONG ulCapID, double fValue)
{
    AsyncManager amgr(this);
   
    return SetFloatCapability(refObj(), ulCapID, fValue);
}

bool  NikonManager::setCapRange    (ULONG ulCapID, double fValue)
{
    AsyncManager amgr(this);

    return SetRangeCapability (refObj(), ulCapID, fValue);
}

bool NikonManager::setCapEnum (ULONG ulCapID, int index)
{
    AsyncManager amgr(this);

    return SetEnumCapability(refObj(), ulCapID, index);
}

double NikonManager::getCapDouble(ULONG ulCapID)
{
    AsyncManager amgr(this);
    bool bRet = false;
    double ulValue = 0;
    
    bRet = GetFloatCapability(refObj(), ulCapID, (ULONG*)&ulValue);

    return ulValue;
}

int NikonManager::getCapRange(ULONG ulCapID,  LPNkMAIDRange pRange)
{
    AsyncManager amgr(this);

    return GetRangeCapability(refObj(), ulCapID, pRange);
}

int NikonManager::getCapCount()
{
    AsyncManager amgr(this);

    return GetCapCount(refObj()->pObject);
}

bool  NikonManager::getCapInfo(LPNkMAIDCapInfo ppCapArray,  int count)
{
    AsyncManager amgr(this);

    return GetCapInfoObj( refObj()->pObject, &ppCapArray, count, NULL, NULL );
}

bool NikonManager::canSet ( int capId)
{
    AsyncManager amgr(this);
    return CheckCapabilityOperation(refObj(), capId, kNkMAIDCapOperation_Set);
}

bool NikonManager::getCapArray (LPNkMAIDEnum pStEnum, int capId)
{
    AsyncManager amgr(this);
   
    return GetEnumArrayCapability(refObj(), capId, pStEnum);
}

char * NikonManager::getEnumString(int capId, int itemId)
{
    AsyncManager amgr(this);
   
    return GetEnumString(  capId,  itemId, m_psEnumItemString );
}

int NikonManager::getCapEnumIndex (ULONG ulCapID)
{
    AsyncManager amgr(this);
    bool bRet = false;
    int ulValue = -1;

    bRet = GetEnumCapabilityIndex (refObj(),ulCapID, &ulValue);
    
    return ulValue;
}

bool NikonManager::enumCapabilities( ULONG* pulCapCount, LPNkMAIDCapInfo* ppCapArray, LPNKFUNC pfnComplete, NKREF refComplete)
{
    AsyncManager amgr(this);
 
    return EnumCapabilities( m_pRefMod->pObject ,  pulCapCount,  ppCapArray, NULL, NULL);
}

bool NikonManager::sourceCommandLoop( LPRefObj m_pRefMod )
{
    m_pRefSrc = GetRefChildPtr_ID( m_pRefMod, m_ulSrcID );
    if ( m_pRefSrc == NULL ) {
        // Create Source object and RefSrc structure.
        if ( AddChild( m_pRefMod, m_ulSrcID ) == TRUE ) {
            printf("Source object is opened.\n");
        } else {
            printf("Source object can't be opened.\n");
            return false;
        }
        m_pRefSrc = GetRefChildPtr_ID( m_pRefMod, m_ulSrcID );
    }
    return true;
}


LPRefObj NikonManager::refObj()
{
    return m_cameraConnected ? m_pRefSrc : m_pRefMod ;
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
