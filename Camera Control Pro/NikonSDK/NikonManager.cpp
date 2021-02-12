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
    m_asyncPaused = true;
    
    char    ModulePath[PATH_MAX] = {0};
    //LPRefObj    pRefMod = NULL;  // TODO ejc
    
    ULONG    ulModID = 0, ulSrcID = 0;

    BOOL    bRet;

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
    
    m_asyncPaused = true;
    bRet = Command_CapGet( pRefSrc->pObject, kNkMAIDCapability_FocalLength, kNkMAIDDataType_FloatPtr,(NKPARAM) pData, NULL, NULL );
    m_asyncPaused = false;
}

int NikonManager::getCapUnsigned(ULONG ulCapID, ULONG* ulValue)
{
    int bRet = 0;
  
    m_asyncPaused = true;
    bRet = GetUnsignedCapability((LPRefObj)pRefSrc, ulCapID, ulValue);
    m_asyncPaused = false;
    
    return bRet;
}

BYTE NikonManager::getCapBool(ULONG ulCapID)
{
    bool bRet = false;
    BYTE ulValue = 0;
    
    m_asyncPaused = true;
    bRet = GetBoolCapability(pRefSrc, ulCapID, &ulValue);
    m_asyncPaused = false;
    
    return ulValue;
}

bool NikonManager::getCapString (ULONG ulCapID,  char *psString)
{
    bool bRet = false;
    
    m_asyncPaused = true;
    bRet = GetStringCapability( pRefSrc,  ulCapID, psString);
    m_asyncPaused = false;
    
    return bRet;
}

bool  NikonManager::setCapBool (ULONG ulCapID, bool bFlag)
{
    bool bRet = false;
    
    m_asyncPaused = true;
    bRet = SetBoolCapability(pRefSrc, ulCapID, bFlag);
    m_asyncPaused = false;
    
    return bRet;
}

bool  NikonManager::setCapUnsigned  (ULONG ulCapID, ULONG ulValue)
{
    bool bRet = false;

    m_asyncPaused = true;
    bRet = SetUnsignedCapability(pRefSrc, ulCapID, ulValue);
    m_asyncPaused = false;
    
    return bRet;
}

bool  NikonManager::setCapDouble    (ULONG ulCapID, double fValue)
{
    bool bRet = false;
    
    m_asyncPaused = true;
    bRet = SetFloatCapability(pRefSrc, ulCapID, fValue);
    m_asyncPaused = false;
    
    return bRet;
}

bool  NikonManager::setCapRange    (ULONG ulCapID, double fValue)
{
    bool bRet = false;
    
    m_asyncPaused = true;
    bRet = SetRangeCapability (pRefSrc, ulCapID, fValue);
    m_asyncPaused = false;
    
    return bRet;
}

bool NikonManager::setCapEnum (ULONG ulCapID, int index)
{
    bool bRet = false;
    
    m_asyncPaused = true;
    bRet = SetEnumCapability(pRefSrc, ulCapID, index);
    m_asyncPaused = false;
    
    return bRet;
}

double NikonManager::getCapDouble(ULONG ulCapID)
{
    bool bRet = false;
    double ulValue = 0;
    
    m_asyncPaused = true;
    bRet = GetFloatCapability((LPRefObj)pRefSrc, ulCapID, (ULONG*)&ulValue);
    m_asyncPaused = false;
    
    return ulValue;
}

int NikonManager::getCapRange(ULONG ulCapID,  LPNkMAIDRange pRange)
{
    int bRet = false;
   
    m_asyncPaused = true;
    bRet = GetRangeCapability(pRefSrc, ulCapID, pRange);
    m_asyncPaused = false;
    
    return bRet;
}

int NikonManager::getCapCount()
{
    int nCount = 0;
    
    m_asyncPaused = true;
    nCount =  GetCapCount(pRefSrc->pObject);
    m_asyncPaused = false;
    
    return nCount;
}

bool  NikonManager::getCapInfo(LPNkMAIDCapInfo ppCapArray,  int count)
{
    bool bRet = false;
    
    m_asyncPaused = true;
    bRet = GetCapInfoObj( pRefSrc->pObject, &ppCapArray, count, NULL, NULL );
    m_asyncPaused = false;
    
    return bRet;
}

bool NikonManager::canSet ( int capId)
{
    bool bRet = false;
    
    m_asyncPaused = true;
    bRet =  CheckCapabilityOperation(pRefSrc, capId, kNkMAIDCapOperation_Set);
    m_asyncPaused = false;
    
    return bRet;
}

// BOOL SetEnumCapabilityObj( LPRefObj pRefObj, ULONG ulCapID, LPNkMAIDEnum pStEnum );
bool NikonManager::getCapArray (LPNkMAIDEnum pStEnum, int capId)
{
    bool rc = false;
    
    m_asyncPaused = true;
    rc =  GetEnumArrayCapability(pRefSrc, capId, pStEnum);
    m_asyncPaused = false;

    return rc;
}

char * NikonManager::getEnumString(int capId, int itemId)
{
    char * str = NULL;
    
    m_asyncPaused = true;
    str = GetEnumString(  capId,  itemId, psEnumItemString );
    m_asyncPaused = false;
    
    return str;
}

int NikonManager::getCapEnumIndex (ULONG ulCapID)
{
    bool bRet = false;
    
    int ulValue = -1;
    m_asyncPaused = true;
    bRet = GetEnumCapabilityIndex (pRefSrc,ulCapID, &ulValue);
    m_asyncPaused = false;
    
    return ulValue;
}



bool NikonManager::enumCapabilities( ULONG* pulCapCount, LPNkMAIDCapInfo* ppCapArray, LPNKFUNC pfnComplete, NKREF refComplete)
{
    bool bRet = false;
    
    m_asyncPaused = true;
    bRet = EnumCapabilities( pRefMod->pObject ,  pulCapCount,  ppCapArray, NULL, NULL);
    m_asyncPaused = false;
    
    return bRet;
}

bool NikonManager::resetSourceCommandLoop (int ulSrcID)
{
    bool bRet = false;
    
    m_asyncPaused = true;
    // Close Source_Object
        bRet = RemoveChild( pRefMod, ulSrcID );
    
    bRet =  sourceCommandLoop(  pRefMod, ulSrcID); // TODO ejc
    m_asyncPaused = false;
    
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
    
    
#ifdef NEEDED  // TODO ejc
    // Get CameraType
    Command_CapGet( pRefSrc->pObject, kNkMAIDCapability_CameraType, kNkMAIDDataType_UnsignedPtr, (NKPARAM)&g_ulCameraType, NULL, NULL );

    // command loop
    do {
        printf( "\nSelect (1-9, 0)\n" );
        printf( " 1. Select Item Object       2. Camera settings(1)       3. Camera settings(2)\n" );
        printf( " 4. Movie Menu               5. Shooting Menu            6. Live View\n" );
        printf( " 7. Custom Menu              8. SB Menu                  9. Async\n" );
        printf( "10. Capture                 11. TerminateCapture        12. PreCapture\n" );
        printf( "13. CaptureAsync            14. AFCaptureAsync          15. PreCaptureAsync\n" );
        printf( "16. DeviceReady             17. InitiatePixelMapping\n");
        printf( " 0. Exit\n>" );
        scanf( "%s", buf );
        wSel = atoi( buf );

        switch( wSel )
        {
            case 1:// Children
                // Select Item  Object
                ulItemID = 0;
                bRet = SelectItem( pRefSrc, &ulItemID );
                if( bRet == TRUE && ulItemID > 0 )
                    bRet = ItemCommandLoop( pRefSrc, ulItemID );
                break;
            case 2:// Camera setting 1
                bRet = SetUpCamera1( pRefSrc );
                break;
            case 3:// Camera setting 2
                bRet = SetUpCamera2( pRefSrc );
                break;
            case 4:// Movie Menu
                bRet = SetMovieMenu(pRefSrc);
                break;
            case 5:// Shooting Menu
                bRet = SetShootingMenu(pRefSrc);
                break;
            case 6:// Live View
                bRet = SetLiveView( pRefSrc );
                break;
            case 7:// Custom Menu
                bRet = SetCustomSettings( pRefSrc );
                break;
            case 8:// SB Menu
                bRet = SetSBMenu( pRefSrc );
                break;
            case 9:// Async
                bRet = Command_Async( pRefMod->pObject );
                break;
            case 10:// Capture
                bRet = IssueProcess( pRefSrc, kNkMAIDCapability_Capture );
                if( bRet == TRUE )
                {
                    // Check SaveMedia
                    ULONG ulValue;
                    BOOL bRet2 = GetUnsignedCapability( pRefSrc, kNkMAIDCapability_SaveMedia, &ulValue );
                    if( bRet2 != FALSE && ulValue == 0 ) //Card
                    {
                        printf( "SaveMedia is Card. The addition of the Item Ofbject is not notified.\n" );
                        printf( "Enter '0' to exit.\n>" );
                        scanf( "%s", buf );
                    }
                }
                Command_Async( pRefSrc->pObject );
                break;
            case 11:// TerminateCapture
                bRet = TerminateCaptureCapability( pRefSrc );
                break;
            case 12:// PreCapture
                bRet = IssueProcess( pRefSrc, kNkMAIDCapability_PreCapture );
                break;
            case 13:// CaptureAsync
                bRet = IssueProcess( pRefSrc, kNkMAIDCapability_CaptureAsync );
                if (bRet == TRUE)
                {
                    // Check SaveMedia
                    ULONG ulValue;
                    BOOL bRet2 = GetUnsignedCapability(pRefSrc, kNkMAIDCapability_SaveMedia, &ulValue);
                    if (bRet2 != FALSE && ulValue == 0) //Card
                    {
                        printf("SaveMedia is Card. The addition of the Item Ofbject is not notified.\n");
                        printf("Enter '0' to exit.\n>");
                        scanf("%s", buf);
                    }
                }
                break;
            case 14:// AFCaptureAsync
                bRet = IssueProcess( pRefSrc, kNkMAIDCapability_AFCaptureAsync );
                if( bRet == TRUE )
                {
                    // Check SaveMedia
                    ULONG ulValue;
                    BOOL bRet2 = GetUnsignedCapability( pRefSrc, kNkMAIDCapability_SaveMedia, &ulValue );
                    if( bRet2 != FALSE && ulValue == 0 ) //Card
                    {
                        printf( "SaveMedia is Card. The addition of the Item Ofbject is not notified.\n" );
                        printf( "Enter '0' to exit.\n>" );
                        scanf( "%s", buf );
                    }
                }
                break;
            case 15:// PreCaptureAsync
                bRet = IssueProcess(pRefSrc, kNkMAIDCapability_PreCaptureAsync);
                break;
            case 16:// DeviceReady
                bRet = IssueProcess( pRefSrc, kNkMAIDCapability_DeviceReady );
                break;
            case 17:// InitiatePixelMapping
                bRet = IssueProcess(pRefSrc, kNkMAIDCapability_InitiatePixelMapping);
                break;
            default:
                wSel = 0;
        }
        if ( bRet == FALSE ) {
            printf( "An Error occured. Enter '0' to exit.\n>" );
            scanf( "%s", buf );
            bRet = TRUE;
        }
        WaitEvent();
    } while( wSel > 0 );

// Close Source_Object
    bRet = RemoveChild( pRefMod, ulSrcID );

    return TRUE;
#endif
    return true;
}
