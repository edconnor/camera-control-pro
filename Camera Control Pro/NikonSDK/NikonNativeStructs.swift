//
//  NikonNativeStructs.swift
//  Camera Control Pro
//
//  Created by Eduardo Connor on 1/2/21.
//

import Foundation

struct NkMAIDCapInfoObj
{
    var ulID: eNkMAIDCapability = eNkMAIDCapability.kNkMAIDCapability_VendorBase                // one of eNkMAIDCapability or vendor specified
    var ulType: eNkMAIDCapType = eNkMAIDCapType.kNkMAIDCapType_Generic                          // one of eNkMAIDCapabilityType
    var ulVisibility: eNkMAIDCapVisibility = eNkMAIDCapVisibility.kNkMAIDCapVisibility_Invalid  // eNkMAIDCapVisibility bits
    var ulOperations: eNkMAIDCapOperations = eNkMAIDCapOperations.kNkMAIDCapOperation_Get       // eNkMAIDCapOperations bits
    var szDescription: String = ""                                                              // text describing the capability
    
    // MARK: eNkMAIDCapOperations
    func canStart()->Bool       { return (ulOperations.rawValue  & eNkMAIDCapOperations.kNkMAIDCapOperation_Start.rawValue) != 0 }
    func canGet()->Bool         { return (ulOperations.rawValue  & eNkMAIDCapOperations.kNkMAIDCapOperation_Get.rawValue) != 0 }
    func canSet()->Bool         { return (ulOperations.rawValue  & eNkMAIDCapOperations.kNkMAIDCapOperation_Set.rawValue) != 0 }
    func canGetArray()->Bool    { return (ulOperations.rawValue  & eNkMAIDCapOperations.kNkMAIDCapOperation_GetArray.rawValue) != 0 }
    func canGetDefault()->Bool  { return (ulOperations.rawValue  & eNkMAIDCapOperations.kNkMAIDCapOperation_GetDefault.rawValue) != 0 }
    
    // MARK: eNkMAIDCapVisibility
    func isHidden()->Bool       { return (ulVisibility.rawValue  & eNkMAIDCapVisibility.kNkMAIDCapVisibility_Hidden.rawValue) != 0 }
    func isAdvanced()->Bool     { return (ulVisibility.rawValue  & eNkMAIDCapVisibility.kNkMAIDCapVisibility_Advanced.rawValue) != 0 }
    func isVendor()->Bool       { return (ulVisibility.rawValue  & eNkMAIDCapVisibility.kNkMAIDCapVisibility_Vendor.rawValue) != 0 }
    func isGroup()->Bool        { return (ulVisibility.rawValue  & eNkMAIDCapVisibility.kNkMAIDCapVisibility_Group.rawValue) != 0 }
    func isGroupMember()->Bool  { return (ulVisibility.rawValue  & eNkMAIDCapVisibility.kNkMAIDCapVisibility_GroupMember.rawValue) != 0 }
    func isInvalid()->Bool      { return (ulVisibility.rawValue  & eNkMAIDCapVisibility.kNkMAIDCapVisibility_Invalid.rawValue) != 0 }
}


// The NkMAIDEnum structure allows an enumeration to be transferred through the MAID interface. The client will always allocate the memory.
// It is the responsibility of the receiver of the data to interpret the data properly. The size of pData in bytes should always be ulElements times wPhysicalBytes.
// This structure is used to implement a capability that is a choice of options.
// The current index will be in ulValue and the default index will be in ulDefault. If ulType is kNkMAIDArrayType_String or kNkMAIDArrayType_PackedString, the strings are the text representations to be presented to the user.
// The value of a choice capability can be set in two ways. The client can send a pointer to an NkMAIDEnum
// structure with a new index in ulValue or it can send an unsigned integer which will be interpreted as the index.
struct NkMAIDEnumObj
{
    var ulType: eNkMAIDArrayType =  eNkMAIDArrayType.kNkMAIDArrayType_PackedString // one of eNkMAIDArrayType
    var ulElements: ULONG  = 0                  // total number of elements
    var ulValue: ULONG  = 0                     // current index
    var ulDefault: ULONG  = 0                   // default index
    var wPhsicalBytes: SWORD   = 0              // bytes per element
    var pData: LPVOID = UnsafeMutableRawPointer.allocate(byteCount: 2400, alignment: 1)
    
//    init() {
//      //  pData.deallocate()
//        pData = UnsafeMutableRawPointer.allocate(byteCount: Int(wPhsicalBytes) * Int(ulElements), alignment: 1) // allocated by the client
//    }
//
}



struct NkMAIDEnumObj2 {
    var ulType: eNkMAIDCapType? // one of eNkMAIDArrayType
    var ulElements: ULONG?                  // total number of elements
    var ulValue: ULONG?                     // current index
    var ulDefault: ULONG?                 // default index
    var wPhsicalBytes: SWORD?         // bytes per element
    var pData: LPVOID?
    
    init(ulType: eNkMAIDCapType? = nil,
         ulElements: ULONG? = nil,
         ulValue: ULONG? = nil,
         ulDefault: ULONG? = nil,                 // default index
         wPhsicalBytes: SWORD? = nil,         // bytes per element
         pData: LPVOID? = nil
    )
    {
        self.ulElements = ulElements
        self.ulValue = ulValue
        self.ulDefault = ulDefault                 // default index
        self.wPhsicalBytes =  wPhsicalBytes         // bytes per element
        self.pData =  UnsafeMutableRawPointer.allocate(byteCount: Int(wPhsicalBytes ?? 300) * Int(ulElements ?? 1), alignment: 1) // allocated by the client
    }
    
}

struct NkMAIDCapInfoTest
{
    var ulID: ULONG = 0                          // one of eNkMAIDCapability or vendor specified
    var ulType: ULONG  = 0                          // one of eNkMAIDCapabilityType
    var ulVisibility: ULONG = 0                  // eNkMAIDCapVisibility bits
    var ulOperations: ULONG   = 0                // eNkMAIDCapOperations bits
    var szDescription = Array<SCHAR>(repeating: 0, count: 256)    // text describing the capability
}


//MARK: NkMAIDRangeObj
// This structure is to implement capabilities with a numerical range of values (0-100, -5.0 to +5.0, etc.)
// The lower and upper limits will be in lfLower and lfUpper respectively.
// If any value from lfLower to lfUpper is allowed, lfValue will be the current value,
// lfDefault will be the default value and ulSteps will be zero. In this case, ulValueIndex and ulDefaultIndex are not used.
// If only discrete steps are allowed, ulValueIndex will be the index of the current step,
// ulDefaultIndex will be the index of the default step and ulSteps will be the number of
// equally spaced steps including the lower and upper limits. There must be at least two discrete steps.
// In this case, lfValue and lfDefault are not used.
// There are two ways to set the value of a range. The client can send a pointer to a
// NkMAIDRange structure with a new value in lfValue or ulValueIndex.
// For ranges with discrete steps, the client can send an unsigned integer which the
// module will accept as the index of the value. In that case, zero is the lower limit and one less than ulSteps is the upper limit.
struct NkMAIDRangeObj
{
    var range: NkMAIDRange  //  C++ struct from Maid3.h
    
    var min: Double {
        get { return range.lfLower }
    }
    
    var max: Double {
        get { return range.lfUpper }
    }
    
    var delta:Double {
        get { (max - min)/Double(range.ulSteps - 1) }
    }
    
    var defaultValue : Double {
        get {
            if (range.ulSteps == 0) {
                return range.lfDefault;
            } else {
                return valueFromIndex(index: range.ulDefaultIndex);
            }
        }
    }
    
    var value: Double {
        get {
            if (range.ulSteps == 0) {
                return range.lfValue;
           } else {
            return valueFromIndex(index: range.ulValueIndex);
           }
        }
        set(newValue) {
            if (range.ulSteps == 0) {
                range.lfValue = newValue;
            }
           else {
            range.ulValueIndex = indexFromValue(value: value);
           }
        }
    }
    
    func valueFromIndex(index: ULONG ) -> Double{
        return min + (Double(index) * delta)
    }
    
    
    private func indexFromValue(value: Double ) -> ULONG {
        return UInt32(floor((value - min)/delta))
    }
}


