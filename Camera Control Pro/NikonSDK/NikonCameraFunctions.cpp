//
//  NikonCameraFunctions.cpp
//  Camera Control Pro
//
//  Created by Eduardo Connor on 1/21/21.
//

#include <mach-o/dyld.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <sys/stat.h>
#include "Maid3.h"
#include "Maid3d1.h"
#include "CtrlSample.h"

//MARK: Capability Getters
// Distribute the function according to array type.
BOOL GetEnumArrayCapability( LPRefObj pRefObj, ULONG ulCapID, LPNkMAIDEnum pStEnum )
{
    BOOL    bRet = TRUE;
    NkMAIDEnum stEnum;
    
    LPNkMAIDCapInfo pCapInfo = GetCapInfo( pRefObj, ulCapID );
    if ( pCapInfo == NULL ) return FALSE;

    // check data type of the capability
    if ( pCapInfo->ulType != kNkMAIDCapType_Enum ) return FALSE;
    // check if this capability supports CapGet operation.
    if ( !CheckCapabilityOperation( pRefObj, ulCapID, kNkMAIDCapOperation_Get ) ) return FALSE;

    bRet = Command_CapGet( pRefObj->pObject, ulCapID, kNkMAIDDataType_EnumPtr, (NKPARAM)&stEnum, NULL, NULL );
    if( bRet == FALSE ) return FALSE;

    switch ( stEnum.ulType ) {
        case kNkMAIDArrayType_Unsigned:
            bRet = SetEnumUnsignedCapability( pRefObj, ulCapID, &stEnum );
            break;
        case kNkMAIDArrayType_PackedString:
            bRet = SetEnumPackedStringCapability( pRefObj, ulCapID, &stEnum );
            break;
        case kNkMAIDArrayType_String:
            bRet =  SetEnumStringCapability( pRefObj, ulCapID, &stEnum );
            break;
        default:
            return FALSE;
    }
    
    // Copy data provided from the camera to the UnsafeMutablePointer provided by SWift
    pStEnum->ulType         = stEnum.ulType;
    pStEnum->ulElements     = stEnum.ulElements;
    pStEnum->ulDefault      = stEnum.ulDefault;
    pStEnum->ulValue        = stEnum.ulValue;
    pStEnum->wPhysicalBytes = stEnum.wPhysicalBytes;

    memcpy ( pStEnum->pData, stEnum.pData, stEnum.ulElements * stEnum.wPhysicalBytes  );
    free(stEnum.pData);
    return bRet;
}

BOOL SetEnumCapability (LPRefObj pRefObj,ULONG ulCapID, int index)
{
    BOOL bRet = FALSE;
    NkMAIDEnum    stEnum;
   
    LPNkMAIDCapInfo pCapInfo = GetCapInfo( pRefObj, ulCapID );
    if ( pCapInfo == NULL ) return FALSE;

    // check data type of the capability 
    if ( pCapInfo->ulType != kNkMAIDCapType_Enum ) return FALSE;
    // check if this capability supports CapGet operation.
    if ( !CheckCapabilityOperation( pRefObj, ulCapID, kNkMAIDCapOperation_Get ) ) return FALSE;

    bRet = Command_CapGet( pRefObj->pObject, ulCapID, kNkMAIDDataType_EnumPtr, (NKPARAM)&stEnum, NULL, NULL );
    
    stEnum.ulValue = index;
    
    // check if this capability supports CapSet operation.
    if ( CheckCapabilityOperation( pRefObj, ulCapID, kNkMAIDCapOperation_Set ) ) {
        // This capablity can be set.
        if ( index > 0 && index <= stEnum.ulElements ) {
            stEnum.ulValue = index;
            // send the selected number
            bRet = Command_CapSet( pRefObj->pObject, ulCapID, kNkMAIDDataType_EnumPtr, (NKPARAM)&stEnum, NULL, NULL );
            // This statement can be changed as follows.
            //bRet = Command_CapSet( pRefObj->pObject, ulCapID, kNkMAIDDataType_Unsigned, (NKPARAM)pstEnum->ulValue, NULL, NULL );
        }
    } else {
        // This capablity is read-only.
        printf( "This value cannot be changed. Enter '0' to exit.\n>" );
    }

    return bRet;
}

BOOL GetEnumCapabilityIndex (LPRefObj pRefObj,ULONG ulCapID, int* pIndex)
{
    BOOL bRet = FALSE;
    NkMAIDEnum    stEnum;
   
    LPNkMAIDCapInfo pCapInfo = GetCapInfo( pRefObj, ulCapID );
    if ( pCapInfo == NULL ) return FALSE;

    // check data type of the capability
    if ( pCapInfo->ulType != kNkMAIDCapType_Enum ) return FALSE;
    // check if this capability supports CapGet operation.
    if ( !CheckCapabilityOperation( pRefObj, ulCapID, kNkMAIDCapOperation_Get ) ) return FALSE;
    
    
    SLONG result;
    bRet = Command_CapGetSB( pRefObj->pObject, ulCapID, kNkMAIDDataType_EnumPtr, (NKPARAM)&stEnum, NULL, NULL, &result );
    
    
    return bRet;
}


// Get the current setting of a Unsigned Integer type capability.
BOOL GetUnsignedCapability( LPRefObj pRefObj, ULONG ulCapID, ULONG* pulValue )
{
    int    bRet;

    LPNkMAIDCapInfo pCapInfo = GetCapInfo( pRefObj, ulCapID );
    if( pCapInfo == NULL )
        return FALSE;

    // check data type of the capability
    if( pCapInfo->ulType != kNkMAIDCapType_Unsigned )
        return FALSE;
    
    
    // check if this capability supports CapGet operation.
    if( !CheckCapabilityOperation( pRefObj, ulCapID, kNkMAIDCapOperation_Get ) )
        return FALSE;
   
    
    
    
    SLONG result;

    ULONG ulvalue = 4;
    bRet = Command_CapGetSB( pRefObj->pObject, ulCapID, kNkMAIDDataType_UnsignedPtr, (NKPARAM)&ulvalue, NULL, NULL, &result);
    *pulValue = ulvalue;
    return result;
   

}


BOOL GetFloatCapability( LPRefObj pRefObj, ULONG ulCapID, ULONG* pulValue )
{
    LPNkMAIDCapInfo pCapInfo = GetCapInfo( pRefObj, ulCapID );
    if( pCapInfo == NULL ) return FALSE;

    // check data type of the capability
    if( pCapInfo->ulType != kNkMAIDCapType_Float ) return FALSE;
    // check if this capability suports CapGet operation.
    if( !CheckCapabilityOperation( pRefObj, ulCapID, kNkMAIDCapOperation_Get ) ) return FALSE;
    
    SLONG result;

    return Command_CapGetSB( pRefObj->pObject, ulCapID, kNkMAIDDataType_FloatPtr, ( NKPARAM )pulValue, NULL, NULL, &result );
}

BOOL GetBoolCapability( LPRefObj pRefObj, ULONG ulCapID,  BYTE* pbFlag )
{
    BOOL    bRet = FALSE;
  
    LPNkMAIDCapInfo pCapInfo = GetCapInfo( pRefObj, ulCapID );
    if ( pCapInfo == NULL ) return FALSE;

    // check data type of the capability
    if ( pCapInfo->ulType != kNkMAIDCapType_Boolean ) return FALSE;
    // check if this capability supports CapGet operation.
    if ( !CheckCapabilityOperation( pRefObj, ulCapID, kNkMAIDCapOperation_Get ) ) return FALSE;

    SLONG result;
    
    bRet = Command_CapGetSB( pRefObj->pObject, ulCapID, kNkMAIDDataType_BooleanPtr, (NKPARAM)pbFlag, NULL, NULL, &result );
   
    return bRet;
}


// Get the current setting of a Range type capability and set a value for it.
int GetRangeCapability( LPRefObj pRefObj, ULONG ulCapID, NkMAIDRange* stRange )
{
    int    nResult = 0;

    LPNkMAIDCapInfo pCapInfo = GetCapInfo( pRefObj, ulCapID );
    if ( pCapInfo == NULL )
        return FALSE;

    // check data type of the capability
    if ( pCapInfo->ulType != kNkMAIDCapType_Range )
        return FALSE;
    // check if this capability supports CapGet operation.
    if ( !CheckCapabilityOperation( pRefObj, ulCapID, kNkMAIDCapOperation_Get ) )
        return FALSE;
    
    
  
    nResult = Command_CapGetSB( pRefObj->pObject, ulCapID, kNkMAIDDataType_RangePtr, (NKPARAM)stRange, NULL, NULL);
    
    return nResult;
}

BOOL GetStringCapability(LPRefObj pRefObj, ULONG ulCapID, char *psString)
{
    BOOL    bRet;
    NkMAIDString    stString;
    
    LPNkMAIDCapInfo pCapInfo = GetCapInfo( pRefObj, ulCapID );
    if ( pCapInfo == NULL ) return FALSE;

    // check data type of the capability
    if ( pCapInfo->ulType != kNkMAIDCapType_String ) return FALSE;
    // check if this capability supports CapGet operation.
    if ( !CheckCapabilityOperation( pRefObj, ulCapID, kNkMAIDCapOperation_Get ) ) return FALSE;
    
    SLONG result;
    bRet = Command_CapGetSB( pRefObj->pObject, ulCapID, kNkMAIDDataType_StringPtr, (NKPARAM)&stString, NULL, NULL , &result );
    
    if( bRet == FALSE ) return FALSE;
   
    const char *p1 = (const char *)stString.str;
    strcpy(psString, p1);
    
    return TRUE;
}

//MARK: Capability Setters
//------------------------------------------------------------------------------------------------------------------------------------
// Show the current setting of a Unsigned Integer type capability and set a value for it.
BOOL SetUnsignedCapability( LPRefObj pRefObj, ULONG ulCapID, ULONG ulValue )
{
    BOOL    bRet;
    if ( CheckCapabilityOperation( pRefObj, ulCapID, kNkMAIDCapOperation_Set ) ) {
        // This capablity can be set.
       
        bRet = Command_CapSet( pRefObj->pObject, ulCapID, kNkMAIDDataType_Unsigned, (NKPARAM)ulValue, NULL, NULL );
        if( bRet == FALSE ) return FALSE;
    } else {
        // This capablity is read-only.
        printf( "This value cannot be changed. Enter '0' to exit.\n>" );
    }
    return TRUE;
}

//------------------------------------------------------------------------------------------------------------------------------------
// Show the current setting of a Float type capability and set a value for it.
BOOL SetFloatCapability( LPRefObj pRefObj, ULONG ulCapID, double  fValue)
{
    BOOL    bRet;

    if ( CheckCapabilityOperation( pRefObj, ulCapID, kNkMAIDCapOperation_Set ) ) {
        // This capablity can be set.

        bRet = Command_CapSet( pRefObj->pObject, ulCapID, kNkMAIDDataType_FloatPtr, (NKPARAM)&fValue, NULL, NULL );
        if( bRet == FALSE ) return FALSE;
    } else {
        // This capablity is read-only.
        printf( "This value cannot be changed. Enter '0' to exit.\n>" );
       
    }
    return TRUE;
}


// Show the current setting of a Boolean type capability and set a value for it.
BOOL SetBoolCapability( LPRefObj pRefObj, ULONG ulCapID, BYTE bFlag )
{
    BOOL    bRet;
    if ( CheckCapabilityOperation( pRefObj, ulCapID, kNkMAIDCapOperation_Set ) ) {
        // This capablity can be set.
            bRet = Command_CapSet( pRefObj->pObject, ulCapID, kNkMAIDDataType_Boolean, (NKPARAM)bFlag, NULL, NULL );
            if( bRet == FALSE )
                return FALSE;
    } else {
        // This capablity is read-only.
        printf( "This value cannot be changed. Enter '0' to exit.\n>" );
    }
    return TRUE;
}

BOOL SetRangeCapability( LPRefObj pRefObj, ULONG ulCapID, double lfValue)
{
    BOOL    bRet;
    NkMAIDRange    stRange;
    
 //   char    buf[256];
//    LPNkMAIDCapInfo pCapInfo = GetCapInfo( pRefObj, ulCapID );
//    if ( pCapInfo == NULL ) return FALSE;

    // check data type of the capability
   // if ( pCapInfo->ulType != kNkMAIDCapType_Range ) return FALSE;
    // check if this capability supports CapGet operation.
  //  if ( !CheckCapabilityOperation( pRefObj, ulCapID, kNkMAIDCapOperation_Get ) ) return FALSE;

    bRet = Command_CapGet( pRefObj->pObject, ulCapID, kNkMAIDDataType_RangePtr, (NKPARAM)&stRange, NULL, NULL );
    if( bRet == FALSE ) return FALSE;
    // show current value of this capability
    //printf( "[%s]\n", pCapInfo->szDescription );
    
    // check if this capability supports CapSet operation.
    if ( CheckCapabilityOperation( pRefObj, ulCapID, kNkMAIDCapOperation_Set ) ) {
        // This capablity can be set.
        if ( stRange.ulSteps == 0 ) {
            // the value of this capability is set to 'lfValue' directly
           // printf( "Current Value 'lfValue' directly: %f  (Max: %f  Min: %f)\n", stRange.lfValue, stRange.lfUpper, stRange.lfLower );
           // printf( "Input new value.\n>" );
            
            stRange.lfValue = lfValue;
        } else {
            // the value of this capability is calculated from 'ulValueIndex'
            //lfValue = stRange.lfLower + stRange.ulValueIndex * (stRange.lfUpper - stRange.lfLower) / (stRange.ulSteps - 1);
           // printf( "Current Value 'ulValueIndex': %f  (Max: %f  Min: %f)\n", lfValue, stRange.lfUpper, stRange.lfLower );
          //  printf( "Input new value.\n>" );
            
            stRange.ulValueIndex = (ULONG)((lfValue - stRange.lfLower) * (stRange.ulSteps - 1) / (stRange.lfUpper - stRange.lfLower));
        }
        bRet = Command_CapSet( pRefObj->pObject, ulCapID, kNkMAIDDataType_RangePtr, (NKPARAM)&stRange, NULL, NULL );
        if( bRet == FALSE ) return FALSE;
    } else {
        // This capablity is read-only.
        if ( stRange.ulSteps == 0 ) {
            // the value of this capability is set to 'lfValue' directly
            lfValue = stRange.lfValue;
        } else {
            // the value of this capability is calculated from 'ulValueIndex'
            lfValue = stRange.lfLower + stRange.ulValueIndex * (stRange.lfUpper - stRange.lfLower) / (stRange.ulSteps - 1);
        }
        printf( "Current Value (read only): %f  (Max: %f  Min: %f)\n", lfValue, stRange.lfUpper, stRange.lfLower );
        printf( "This value cannot be changed. Enter '0' to exit.\n>" );
        //scanf( "%s", buf );
    }
    return TRUE;
}



//// Show the current setting of a String type capability and set a value for it.
//BOOL SetStringCapability( LPRefObj pRefObj, ULONG ulCapID )
//{
//    BOOL    bRet;
//    NkMAIDString    stString;
//    char szBuf[256] = { 0 };
//    LPNkMAIDCapInfo pCapInfo = GetCapInfo( pRefObj, ulCapID );
//    if ( pCapInfo == NULL ) return FALSE;
//
//    // check data type of the capability
//    if ( pCapInfo->ulType != kNkMAIDCapType_String ) return FALSE;
//    // check if this capability supports CapGet operation.
//    if ( !CheckCapabilityOperation( pRefObj, ulCapID, kNkMAIDCapOperation_Get ) ) return FALSE;
//
//    bRet = Command_CapGet( pRefObj->pObject, ulCapID, kNkMAIDDataType_StringPtr, (NKPARAM)&stString, NULL, NULL );
//    if( bRet == FALSE ) return FALSE;
//    // show current value of this capability
//    printf( "[%s]\n", pCapInfo->szDescription );
//    printf( "Current String: %s\n", stString.str );
//
//    if ( CheckCapabilityOperation( pRefObj, ulCapID, kNkMAIDCapOperation_Set ) ) {
//        // This capablity can be set.
//        printf( "Input new string\n>" );
//#if defined( _WIN32 )
//        rewind(stdin);        // clear stdin
//#elif defined(__APPLE__)
//        fgets( szBuf, sizeof(szBuf), stdin );
//#endif
//        fgets( szBuf, sizeof(szBuf), stdin );
//        sscanf( szBuf, "%s", (char*)stString.str );
//        bRet = Command_CapSet( pRefObj->pObject, ulCapID, kNkMAIDDataType_StringPtr, (NKPARAM)&stString, NULL, NULL );
//        if( bRet == FALSE ) return FALSE;
//    } else {
//        // This capablity is read-only.
//        printf( "This value cannot be changed. Enter '0' to exit.\n>" );
//        scanf( "%s", stString.str );
//    }
//    return TRUE;
//}
