//
//  NikonNativeEnums.swift
//  Camera Control Pro
//
//  Created by Eduardo Connor on 1/2/21.
//

import Foundation
// The module will deliver one of these values to the nResult parameter of the clients
// completion callback function and return the same value from the entry point. Errors
// will have negative values.

// #define kNkMAIDCapability_VendorBaseDX2 kNkMAIDCapability_VendorBase + 0x100
// #define kNkMAIDResult_DX2Origin kNkMAIDResult_VendorBase + 129
// #define kNkMAIDEvent_DX2Origin  kNkMAIDEvent_CapChangeValueOnly + 0x100
// Start enum eNkMAIDCapabilityD1


enum eNkMAIDCapability: Int, CaseIterable, Decodable, Encodable {
  
    typealias IntegerLiteralType = UInt
    
    case kNkMAIDCapability_AsyncRate = 1    // milliseconds between idle async calls
    case kNkMAIDCapability_ProgressProc     // callback during lengthy operation
    case kNkMAIDCapability_EventProc        // callback when event occurs
    case kNkMAIDCapability_DataProc         // callback to deliver data
    case kNkMAIDCapability_UIRequestProc    // callback to show user interface
    
    case kNkMAIDCapability_IsAlive          // FALSE if object is removed or parent closed
    case kNkMAIDCapability_Children         // IDs of children objects
    case kNkMAIDCapability_State            // current state of the object
    case kNkMAIDCapability_Name             // a string representing the name of the object
    case kNkMAIDCapability_Description      // a string describing the object
    case kNkMAIDCapability_Interface        // a string describing the interface to a device
    case kNkMAIDCapability_DataTypes        // what data types are supported or available
    case kNkMAIDCapability_DateTime         // date associated with an object
    case kNkMAIDCapability_StoredBytes      // read only size of object as stored on device
    
    case kNkMAIDCapability_Eject            // ejects media from a device
    case kNkMAIDCapability_Feed             // feeds media into a device
    case kNkMAIDCapability_Capture          // captures new item from the source
    case kNkMAIDCapability_MediaPresent     // TRUE if item has physical media to acquire
    
    case kNkMAIDCapability_Mode             // mode of this object
    case kNkMAIDCapability_Acquire          // begins the acquisition of the object
    case kNkMAIDCapability_ForceScan        // If FALSE unneccesary scans can be eliminated
    
    case kNkMAIDCapability_Start            // start offset (in seconds) of the object
    case kNkMAIDCapability_Length           // length (in seconds) of the object
    case kNkMAIDCapability_SampleRate       // sampling rate (in samples/sec) of the object
    case kNkMAIDCapability_Stereo           // mono or stereo
    case kNkMAIDCapability_Samples          // given current state read only number of samples
    
    case kNkMAIDCapability_Filter           // selects the filter for the light source
    case kNkMAIDCapability_Prescan          // sets the focus automatically
    case kNkMAIDCapability_ForcePrescan     // If FALSE unneccesary prescans can be eliminated
    case kNkMAIDCapability_AutoFocus        // sets the focus automatically
    case kNkMAIDCapability_ForceAutoFocus   // If FALSE unneccesary autofocus can be eliminated
    case kNkMAIDCapability_AutoFocusPt      // sets the position to focus upon
    case kNkMAIDCapability_Focus            // sets the focus
    case kNkMAIDCapability_Coords           // rectangle of object in device units
    case kNkMAIDCapability_Resolution       // resolution of object (in pixels/inch)
    case kNkMAIDCapability_Preview          // preview or final acquire
    case kNkMAIDCapability_Negative         // negative or positive original
    case kNkMAIDCapability_ColorSpace       // color space
    case kNkMAIDCapability_Bits             // bits per color
    case kNkMAIDCapability_Planar           // interleaved or planar data transfer
    case kNkMAIDCapability_Lut              // LUT(s) for object
    case kNkMAIDCapability_Transparency     // light path of the original
    case kNkMAIDCapability_Threshold        // threshold level for lineart images
    case kNkMAIDCapability_Pixels           // given current state read only size of image
    case kNkMAIDCapability_NegativeDefault  // Default value for Negative capbility
    case kNkMAIDCapability_Firmware         // Firmware version
    
    case kNkMAIDCapability_CommunicationLevel1  // Device communication method (level 1)
    case kNkMAIDCapability_CommunicationLevel2  // Device communication method (level 2)
    case kNkMAIDCapability_BatteryLevel         // Device battery level
    case kNkMAIDCapability_FreeBytes            // Free bytes in device storage
    case kNkMAIDCapability_FreeItems            // Free items in device storage
    case kNkMAIDCapability_Remove               // Remove an object from device storage
    case kNkMAIDCapability_FlashMode            // Device flash (speedlight) mode
    case kNkMAIDCapability_ModuleType           // Module type
    case kNkMAIDCapability_AcquireStreamStart   // Starts a stream acquire
    case kNkMAIDCapability_AcquireStreamStop    // Stops a stream acquire
    case kNkMAIDCapability_AcceptDiskAcquisition // Sets parameters for disk acquisition
    case kNkMAIDCapability_Version              // MAID version
    case kNkMAIDCapability_FilmFormat           // File Size (35mm 6*6 etc...)
    case kNkMAIDCapability_TotalBytes           // Number of bytes in device storage
    case kNkMAIDCapability_VendorBase                            = 32768    // vendor supplied capabilities start here

    case kNkMAIDCapability_ModuleMode                            = 33025
    case kNkMAIDCapability_CurrentDirectory                      = 33026
    case kNkMAIDCapability_FormatStorage                         = 33027
    case kNkMAIDCapability_PreCapture                            = 33028
    case kNkMAIDCapability_LockFocus                             = 33029
    case kNkMAIDCapability_LockExposure                          = 33030
    case kNkMAIDCapability_LifeTime                              = 33031
    case kNkMAIDCapability_CFStatus                              = 33032
    case kNkMAIDCapability_ClockBatteryLevel                     = 33033
    case kNkMAIDCapability_FlashStatus                           = 33034
    case kNkMAIDCapability_ExposureStatus                        = 33035
    case kNkMAIDCapability_MediaType                             = 33036
    case kNkMAIDCapability_Ficaseype                             = 33039
    case kNkMAIDCapability_CompressionLevel                      = 33040
    case kNkMAIDCapability_ExposureMode                          = 33041
    case kNkMAIDCapability_ShutterSpeed                          = 33042
    case kNkMAIDCapability_Aperture                              = 33043
    case kNkMAIDCapability_FlexibleProgram                       = 33044
    case kNkMAIDCapability_ExposureComp                          = 33045
    case kNkMAIDCapability_MeteringMode                          = 33046
    case kNkMAIDCapability_Sensitivity                           = 33047
    case kNkMAIDCapability_WBMode                                = 33048
    case kNkMAIDCapability_WBTuneAuto                            = 33049
    case kNkMAIDCapability_WBTuneIncandescent                    = 33050
    case kNkMAIDCapability_WBTuneFluorescent                     = 33051
    case kNkMAIDCapability_WBTuneSunny                           = 33052
    case kNkMAIDCapability_WBTuneFlash                           = 33053
    case kNkMAIDCapability_WBTuneShade                           = 33054
    case kNkMAIDCapability_WBTuneCloudy                          = 33055
    case kNkMAIDCapability_FocusMode                             = 33056
    case kNkMAIDCapability_FocusAreaMode                         = 33057
    case kNkMAIDCapability_FocusPreferredArea                    = 33058
    case kNkMAIDCapability_FocalLength                           = 33059
    case kNkMAIDCapability_ClockDateTime                         = 33060
    case kNkMAIDCapability_CustomSettings                        = 33061
    case kNkMAIDCapability_BracketingOrder                       = 33062
    case kNkMAIDCapability_BracketingVary                        = 33063
    case kNkMAIDCapability_AFonRelease                           = 33064
    case kNkMAIDCapability_AFAreaSelector                        = 33065
    case kNkMAIDCapability_AFsPriority                           = 33066
    case kNkMAIDCapability_AFcPriority                           = 33067
    case kNkMAIDCapability_EVInterval                            = 33024
    case kNkMAIDCapability_CWMeteringDiameter                    = 33069
    case kNkMAIDCapability_AELockonRelease                       = 33070
    case kNkMAIDCapability_ExchangeDials                         = 33071
    case kNkMAIDCapability_EasyExposureComp                      = 33072
    case kNkMAIDCapability_Microscope                            = 33073
    case kNkMAIDCapability_AutoOffDelay                          = 33074
    case kNkMAIDCapability_SelfTimerDuration                     = 33075
    case kNkMAIDCapability_LCDBackLight                          = 33076
    case kNkMAIDCapability_PlayBackImage                         = 33077
    case kNkMAIDCapability_LimitImageDisplay                     = 33078
    case kNkMAIDCapability_BlinkTimerLED                         = 33079
    case kNkMAIDCapability_ApertureDial                          = 33080
    case kNkMAIDCapability_ZoomAperture                          = 33081
    case kNkMAIDCapability_AEAFLockButton                        = 33082
    case kNkMAIDCapability_EdgeEnhancement                       = 33083
    case kNkMAIDCapability_Curve                                 = 33084
    case kNkMAIDCapability_ShootingSpeed                         = 33085
    case kNkMAIDCapability_ShootingLimit                         = 33086
    case kNkMAIDCapability_LutHeader                             = 33087
    case kNkMAIDCapability_FileHeader                            = 33088
    case kNkMAIDCapability_LockCamera                            = 33089
    case kNkMAIDCapability_LockShutterSpeed                      = 33090
    case kNkMAIDCapability_LockAperture                          = 33091
    case kNkMAIDCapability_LensInfo                              = 33092
    case kNkMAIDCapability_MirrorUp                              = 33093
    case kNkMAIDCapability_EnableNIF                             = 33094
    case kNkMAIDCapability_PlaybackMode                          = 33095
    case kNkMAIDCapability_UserComment                           = 33096
    case kNkMAIDCapability_DecaseeDirectory                      = 33068
    case kNkMAIDCapability_NumberingMode                         = 33097
    case kNkMAIDCapability_ReadOnly                              = 33098
    case kNkMAIDCapability_Invisible                             = 33099
    case kNkMAIDCapability_DirCreatedByDx2                       = 33100
    case kNkMAIDCapability_ContinuousInPCMode                    = 33101
    case kNkMAIDCapability_CurrentDirID                          = 33102
    case kNkMAIDCapability_SensitivityIncrease                   = 33103
    case kNkMAIDCapability_WritingMedia                          = 33104
    case kNkMAIDCapability_WBPresetNumber                        = 33105
    case kNkMAIDCapability_ThumbnailSize                         = 33106
    case kNkMAIDCapability_SensitivityInterval                   = 33107
    case kNkMAIDCapability_ShootNoCard                           = 33108
    case kNkMAIDCapability_ColorReproduct                        = 33110
    case kNkMAIDCapability_ImageSize                             = 33111
    case kNkMAIDCapability_CompressRAW                           = 33112
    case kNkMAIDCapability_EnableMonitor                         = 33113
    case kNkMAIDCapability_WBGainRed                             = 33114
    case kNkMAIDCapability_WBGainBlue                            = 33115
    case kNkMAIDCapability_MakeDirectory                         = 33116
    case kNkMAIDCapability_RearPanelDisplayMode                  = 33117
    case kNkMAIDCapability_ColorAdjustment                       = 33118
    case kNkMAIDCapability_SelectFUNC                            = 33119
    case kNkMAIDCapability_TypicalFlashMode                      = 33120
    case kNkMAIDCapability_Converter                             = 33121
    case kNkMAIDCapability_ElectronicZoom                        = 33122
    case kNkMAIDCapability_DateFormat                            = 33123
    case kNkMAIDCapability_PreviewInterval                       = 33124
    case kNkMAIDCapability_MenuBank                              = 33125
    case kNkMAIDCapability_FlashComp                             = 33126
    case kNkMAIDCapability_NoAperture                            = 33127
    case kNkMAIDCapability_AntiVibration                         = 33128
    case kNkMAIDCapability_BatteryPack                           = 33129
    case kNkMAIDCapability_ResetCustomSetting                    = 33130
    case kNkMAIDCapability_ImagePreview                          = 33131
    case kNkMAIDCapability_IsoControl                            = 33132
    case kNkMAIDCapability_NoiseReduction                        = 33133
    case kNkMAIDCapability_FocusAreaLed                          = 33134
    case kNkMAIDCapability_AfSubLight                            = 33135
    case kNkMAIDCapability_AfButton                              = 33136
    case kNkMAIDCapability_SoundLevel                            = 33137
    case kNkMAIDCapability_FinderMode                            = 33138
    case kNkMAIDCapability_AeBracketNum                          = 33139
    case kNkMAIDCapability_WbBracketNum                          = 33140
    case kNkMAIDCapability_InternalSplMode                       = 33141
    case kNkMAIDCapability_EnableComment                         = 33142
    case kNkMAIDCapability_PresetExpMode                         = 33143
    case kNkMAIDCapability_PossibcaseoShoot                      = 33144
    case kNkMAIDCapability_ResetFileNumber                       = 33145
    case kNkMAIDCapability_ExpCompInterval                       = 33152
    case kNkMAIDCapability_FocusGroupPreferredArea               = 33162
    case kNkMAIDCapability_ResetMenuBank                         = 33163
    case kNkMAIDCapability_WBTuneColorTemp                       = 33164
    case kNkMAIDCapability_ShootingMode                          = 33165
    case kNkMAIDCapability_LockFV                                = 33166
    case kNkMAIDCapability_RemainContinuousShooting              = 33167
    case kNkMAIDCapability_ShootingBankName                      = 33168
    case kNkMAIDCapability_WBPresetName                          = 33169
    case kNkMAIDCapability_FmmManual                             = 33170
    case kNkMAIDCapability_F0Manual                              = 33171
    case kNkMAIDCapability_CustomBankName                        = 33172
    case kNkMAIDCapability_AfGroupAreaPattern                    = 33173
    case kNkMAIDCapability_FocusFrameInMf                        = 33174
    case kNkMAIDCapability_FocusFrameInContinuousShooting        = 33175
    case kNkMAIDCapability_FocusFrameDisplayTime                 = 33176
    case kNkMAIDCapability_ExposureDelay                         = 33177
    case kNkMAIDCapability_AddIccProfile                         = 33178
    case kNkMAIDCapability_ShootCounterInFinder                  = 33179
    case kNkMAIDCapability_CenterButtonOnShooting                = 33180
    case kNkMAIDCapability_CenterButtonOnPlayback                = 33181
    case kNkMAIDCapability_MultiSelector                         = 33182
    case kNkMAIDCapability_MultiSelectorDirection                = 33183
    case kNkMAIDCapability_CommandDialDirection                  = 33184
    case kNkMAIDCapability_EnableCommandDialOnPlayback           = 33185
    case kNkMAIDCapability_UniversalMode                         = 33186
    case kNkMAIDCapability_VerticalAfButton                      = 33188
    case kNkMAIDCapability_FlashSyncTime                         = 33189
    case kNkMAIDCapability_FlashSlowLimit                        = 33190
    case kNkMAIDCapability_ExternalFlashMode                     = 33191
    case kNkMAIDCapability_ModelingOnPreviewButton               = 33192
    case kNkMAIDCapability_BracketingFactor                      = 33193
    case kNkMAIDCapability_BracketingMethod                      = 33194
    case kNkMAIDCapability_RGBGain                               = 33195
    case kNkMAIDCapability_USBSpeed                              = 33196
    case kNkMAIDCapability_WBPresetData                          = 33197
    case kNkMAIDCapability_ContinuousShootingNum                 = 33198
    case kNkMAIDCapability_EnableBracketing                      = 33199
    case kNkMAIDCapability_BracketingType                        = 33200
    case kNkMAIDCapability_AEBracketingStep                      = 33201
    case kNkMAIDCapability_WBBracketingStep                      = 33202
    case kNkMAIDCapability_BracketingCount                       = 33203
    case kNkMAIDCapability_CameraInclination                     = 33204
    case kNkMAIDCapability_RawJpegImageStatus                    = 33205
    case kNkMAIDCapability_CaptureDustImage                      = 33206
    case kNkMAIDCapability_ZoomRateOnPlayback                    = 33207
    case kNkMAIDCapability_AfGroupAreaPatternType                = 33208
    case kNkMAIDCapability_ExternalFlashSort                     = 33209
    case kNkMAIDCapability_ExternalOldTypeFlashMode              = 33210
    case kNkMAIDCapability_ExternalNewTypeFlashMode              = 33211
    case kNkMAIDCapability_InternalFlashStatus                   = 33212
    case kNkMAIDCapability_ExternalFlashStatus                   = 33213
    case kNkMAIDCapability_InternalFlashComp                     = 33214
    case kNkMAIDCapability_ExternalFlashComp                     = 33215
    case kNkMAIDCapability_ImageSetting                          = 33216
    case kNkMAIDCapability_SaturationSetting                     = 33217
    case kNkMAIDCapability_Beep                                  = 33218
    case kNkMAIDCapability_AFMode                                = 33219
    case kNkMAIDCapability_ISOAutoShutterTime                    = 33220
    case kNkMAIDCapability_InternalSplValue                      = 33221
    case kNkMAIDCapability_InternalSplCommand                    = 33222
    case kNkMAIDCapability_RecommendFlashDisp                    = 33223
    case kNkMAIDCapability_RemoteTimer                           = 33224
    case kNkMAIDCapability_CameraInclinationMode                 = 33225
    case kNkMAIDCapability_InternalSplCommandValue               = 33227
    case kNkMAIDCapability_PreviewStatus                         = 33228
    case kNkMAIDCapability_PreviewImage                          = 33229
    case kNkMAIDCapability_CCDDataMode                           = 33232
    case kNkMAIDCapability_JpegCompressionPolicy                 = 33233
    case kNkMAIDCapability_AFLockOn                              = 33234
    case kNkMAIDCapability_FocalLengthControl                    = 33235
    case kNkMAIDCapability_ExpBaseMatrix                         = 33236
    case kNkMAIDCapability_ExpBaseCenter                         = 33237
    case kNkMAIDCapability_ExpBaseSpot                           = 33238
    case kNkMAIDCapability_CameraType                            = 33239
    case kNkMAIDCapability_NoiseReductionHighISO                 = 33240
    case kNkMAIDCapability_EasyExposureCompMode                  = 33241
    case kNkMAIDCapability_DeviceNameList                        = 33242
    case kNkMAIDCapability_ImageColorSpace                       = 33243
    case kNkMAIDCapability_ISOAutoSetting                        = 33244
    case kNkMAIDCapability_ImageMode                             = 33245
    case kNkMAIDCapability_FocusAreaFrame                        = 33265
    case kNkMAIDCapability_ISOAutoHiLimit                        = 33266
    case kNkMAIDCapability_BeepEx                                = 33267
    case kNkMAIDCapability_AFLockOnEx                            = 33268
    case kNkMAIDCapability_WarningDisp                           = 33269
    case kNkMAIDCapability_CellKind                              = 33270
    case kNkMAIDCapability_InternalSplMRPTValue                  = 33271
    case kNkMAIDCapability_InternalSplMRPTCount                  = 33272
    case kNkMAIDCapability_InternalSplMRPTInterval               = 33273
    case kNkMAIDCapability_InternalSplCommandChannel             = 33274
    case kNkMAIDCapability_InternalSplCmdSelfComp                = 33275
    case kNkMAIDCapability_InternalSplCmdGroupAMode              = 33276
    case kNkMAIDCapability_InternalSplCmdGroupAComp              = 33277
    case kNkMAIDCapability_InternalSplCmdGroupAValue             = 33278
    case kNkMAIDCapability_InternalSplCmdGroupBMode              = 33279
    case kNkMAIDCapability_InternalSplCmdGroupBComp              = 33280
    case kNkMAIDCapability_InternalSplCmdGroupBValue             = 33281
    case kNkMAIDCapability_InternalSplCmdSelfMode                = 33282
    case kNkMAIDCapability_InternalSplCmdSelfValue               = 33283
    case kNkMAIDCapability_SelectFUNC2                           = 33284
    case kNkMAIDCapability_LutIndexNumber                        = 33285
    case kNkMAIDCapability_MonochromeFilterEffect                = 33312
    case kNkMAIDCapability_MonochromeEdgeEnhancement             = 33313
    case kNkMAIDCapability_MonochromeCurve                       = 33314
    case kNkMAIDCapability_AutoFPShoot                           = 33315
    case kNkMAIDCapability_MonochromeSettingType                 = 33316
    case kNkMAIDCapability_AFCapture                             = 33317
    case kNkMAIDCapability_AutoOffTimer                          = 33318
    case kNkMAIDCapability_ImageConfirmTime                      = 33319
    case kNkMAIDCapability_InfoDisplayErrStatus                  = 33320
    case kNkMAIDCapability_ExternalSplMode                       = 33321
    case kNkMAIDCapability_ExternalSplValue                      = 33322
    case kNkMAIDCapability_Slot2ImageSaveMode                    = 33324
    case kNkMAIDCapability_CompressRAWBitMode                    = 33325
    case kNkMAIDCapability_PictureControl                        = 33326
    case kNkMAIDCapability_IntegratedLevel                       = 33327
    case kNkMAIDCapability_Brightness                            = 33328
    case kNkMAIDCapability_MonochromeTuneColors                  = 33329
    case kNkMAIDCapability_Active_D_Lighting                     = 33330
    case kNkMAIDCapability_DynamicAFArea                         = 33331
    case kNkMAIDCapability_ShootingSpeedHigh                     = 33332
    case kNkMAIDCapability_InfoDispSetting                       = 33333
    case kNkMAIDCapability_PreviewButton                         = 33335
    case kNkMAIDCapability_PreviewButton2                        = 33336
    case kNkMAIDCapability_AEAFLockButton2                       = 33338
    case kNkMAIDCapability_IndicatorDisplay                      = 33339
    case kNkMAIDCapability_LiveViewMode                          = 33340
    case kNkMAIDCapability_LiveViewDriveMode                     = 33341
    case kNkMAIDCapability_LiveViewStatus                        = 33342
    case kNkMAIDCapability_LiveViewImageZoomRate                 = 33343
    case kNkMAIDCapability_ContrastAF                            = 33344
    case kNkMAIDCapability_DecaseeDramImage                       = 33347
    case kNkMAIDCapability_CurrentPreviewID                      = 33348
    case kNkMAIDCapability_GetPreviewImageLow                    = 33349
    case kNkMAIDCapability_GetPreviewImageNormal                 = 33350
    case kNkMAIDCapability_GetLiveViewImage                      = 33351
    case kNkMAIDCapability_MFDriveStep                           = 33352
    case kNkMAIDCapability_MFDrive                               = 33353
    case kNkMAIDCapability_ContrastAFArea                        = 33354
    case kNkMAIDCapability_CompressRAWEx                         = 33355
    case kNkMAIDCapability_CellKindPriority                      = 33356
    case kNkMAIDCapability_WBFluorescentType                     = 33357
    case kNkMAIDCapability_WBTuneColorAdjust                     = 33358
    case kNkMAIDCapability_WBTunePreset1                         = 33359
    case kNkMAIDCapability_WBTunePreset2                         = 33360
    case kNkMAIDCapability_WBTunePreset3                         = 33361
    case kNkMAIDCapability_WBTunePreset4                         = 33362
    case kNkMAIDCapability_WBTunePreset5                         = 33363
    case kNkMAIDCapability_AFAreaPoint                           = 33364
    case kNkMAIDCapability_NormalAfButton                        = 33365
    case kNkMAIDCapability_ManualSetLensNo                       = 33366
    case kNkMAIDCapability_AutoDXCrop                            = 33367
    case kNkMAIDCapability_PictureControlData                    = 33368
    case kNkMAIDCapability_GetPicCtrlInfo                        = 33369
    case kNkMAIDCapability_DecaseeCustomPictureControl            = 33370
    case kNkMAIDCapability_LensType                              = 33372
    case kNkMAIDCapability_ChangedPictureControl                 = 33373
    case kNkMAIDCapability_LiveViewProhibit                      = 33374
    case kNkMAIDCapability_DateImprintSetting                    = 33375
    case kNkMAIDCapability_DateCounterSelect                     = 33376
    case kNkMAIDCapability_DateCounterData                       = 33377
    case kNkMAIDCapability_DateCounterDispSetting                = 33378
    case kNkMAIDCapability_RangeFinderSetting                    = 33379
    case kNkMAIDCapability_RangeFinderStatus                     = 33380
    case kNkMAIDCapability_AutoOffPhoto                          = 33381
    case kNkMAIDCapability_AutoOffMenu                           = 33382
    case kNkMAIDCapability_AutoOffInfo                           = 33383
    case kNkMAIDCapability_ScreenTips                            = 33384
    case kNkMAIDCapability_IlluminationSetting                   = 33385
    case kNkMAIDCapability_ShutterSpeedLockSetting               = 33386
    case kNkMAIDCapability_ApertureLockSetting                   = 33387
    case kNkMAIDCapability_VignetteControl                       = 33388
    case kNkMAIDCapability_FocusPointBrightness                  = 33389
    case kNkMAIDCapability_EnableCopyright                       = 33390
    case kNkMAIDCapability_ArtistName                            = 33391
    case kNkMAIDCapability_CopyrightInfo                         = 33392
    case kNkMAIDCapability_AngleLevel                            = 33393
    case kNkMAIDCapability_MovieScreenSize                       = 33394
    case kNkMAIDCapability_MovieVoice                            = 33395
    case kNkMAIDCapability_LiveViewAF                            = 33397
    case kNkMAIDCapability_SelfTimerShootNum                     = 33398
    case kNkMAIDCapability_FinderISODisplay                      = 33399
    case kNkMAIDCapability_EnableCommandDialOnPlaybackEx         = 33400
    case kNkMAIDCapability_ExchangeDialsEx                       = 33401
    case kNkMAIDCapability_CenterButtonOnLiveView                = 33408
    case kNkMAIDCapability_ZoomRateOnLiveView                    = 33409
    case kNkMAIDCapability_AutoDistortion                        = 33410
    case kNkMAIDCapability_SceneMode                             = 33411
    case kNkMAIDCapability_LiveViewScreenDispSetting             = 33412
    case kNkMAIDCapability_MovieRecMicrophone                    = 33413
    case kNkMAIDCapability_MovieRecDestination                   = 33414
    case kNkMAIDCapability_PrimarySlot                           = 33415
    case kNkMAIDCapability_ADLBracketingType                     = 33416
    case kNkMAIDCapability_SelectFUNC2CapAreaCrop                = 33425
    case kNkMAIDCapability_PreviewButton2CapAreaCrop             = 33426
    case kNkMAIDCapability_AEAFLockButton2CapAreaCrop            = 33427
    case kNkMAIDCapability_BracketButton                         = 33428
    case kNkMAIDCapability_RemainCountInMedia                    = 33429
    case kNkMAIDCapability_AngleLevelPitch                       = 33430
    case kNkMAIDCapability_AngleLevelYaw                         = 33431
    case kNkMAIDCapability_MovRecInCardStatus                    = 33432
    case kNkMAIDCapability_MovRecInCardProhibit                  = 33433
    case kNkMAIDCapability_ActiveSlot                            = 33540
    case kNkMAIDCapability_SaveMedia                             = 33541
    case kNkMAIDCapability_MovieRecHiISO                         = 33542
    case kNkMAIDCapability_UserMode1                             = 33543
    case kNkMAIDCapability_UserMode2                             = 33544
    case kNkMAIDCapability_MovieManualSetting                    = 33545
    case kNkMAIDCapability_AFModeAtLiveView                      = 33552
    case kNkMAIDCapability_SelfTimerShootInterval                = 33553
    case kNkMAIDCapability_AutoOffLiveView                       = 33554
    case kNkMAIDCapability_RemoteCtrlWaitTime                    = 33555
    case kNkMAIDCapability_BeepVolume                            = 33556
    case kNkMAIDCapability_VideoMode                             = 33557
    case kNkMAIDCapability_WBAutoType                            = 33558
    case kNkMAIDCapability_GetVideoImage                         = 33559
    case kNkMAIDCapability_TerminateCapture                      = 33560
    case kNkMAIDCapability_EffectMode                            = 33561
    case kNkMAIDCapability_HDRMode                               = 33568
    case kNkMAIDCapability_HDRExposure                           = 33569
    case kNkMAIDCapability_HDRSmoothing                          = 33570
    case kNkMAIDCapability_BlinkingStatus                        = 33571
    case kNkMAIDCapability_AutoSceneModeStatus                   = 33572
    case kNkMAIDCapability_WBTuneColorTempEx                     = 33573
    case kNkMAIDCapability_WBPresetProtect1                      = 33574
    case kNkMAIDCapability_WBPresetProtect2                      = 33575
    case kNkMAIDCapability_WBPresetProtect3                      = 33576
    case kNkMAIDCapability_WBPresetProtect4                      = 33577
    case kNkMAIDCapability_ISOAutoShutterTimeAutoValue           = 33584
    case kNkMAIDCapability_MovieImageQuality                     = 33585
    case kNkMAIDCapability_MovieRecMicrophoneValue               = 33586
    case kNkMAIDCapability_LiveViewExposurePreview               = 33587
    case kNkMAIDCapability_LiveViewSelector                      = 33588
    case kNkMAIDCapability_LiveViewWBMode                        = 33589
    case kNkMAIDCapability_MovieShutterSpeed                     = 33590
    case kNkMAIDCapability_MovieAperture                         = 33591
    case kNkMAIDCapability_MovieSensitivity                      = 33592
    case kNkMAIDCapability_MovieExposureComp                     = 33593
    case kNkMAIDCapability_ADLBracketingStep                     = 33603
    case kNkMAIDCapability_ResetWBMode                           = 33604
    case kNkMAIDCapability_ExpCompFlashUsed                      = 33605
    case kNkMAIDCapability_LiveViewPhotoShootingMode             = 33606
    case kNkMAIDCapability_ExposureDelayEx                       = 33607
    case kNkMAIDCapability_MovieISORange                         = 33608
    case kNkMAIDCapability_MovieReleaseButton                    = 33609
    case kNkMAIDCapability_MovieRecFrameCount                    = 33616
    case kNkMAIDCapability_CurrentItemID                         = 33617
    case kNkMAIDCapability_GetIPTCInfo                           = 33618
    case kNkMAIDCapability_LiveViewImageSize                     = 33619
    case kNkMAIDCapability_RemoteControlMode                     = 33620
    case kNkMAIDCapability_WBTunePreset6                         = 33621
    case kNkMAIDCapability_WBPresetProtect5                      = 33622
    case kNkMAIDCapability_WBPresetProtect6                      = 33623
    case kNkMAIDCapability_SpotWBMode                            = 33624
    case kNkMAIDCapability_SpotWBMeasure                         = 33625
    case kNkMAIDCapability_SpotWBChangeArea                      = 33632
    case kNkMAIDCapability_SpotWBResultDispEnd                   = 33633
    case kNkMAIDCapability_MovieWindNoiseReduction               = 33824
    case kNkMAIDCapability_RetractableLensWarningStatus          = 33825
    case kNkMAIDCapability_ISOControlSensitivity                 = 33826
    case kNkMAIDCapability_ExposureMeterLinkage                  = 33840
    case kNkMAIDCapability_MovieRecordingZone                    = 33872
    case kNkMAIDCapability_MovieISOControl                       = 33873
    case kNkMAIDCapability_MovieISOAutoHiLimit                   = 33874
    case kNkMAIDCapability_RawImageSize                          = 33875
    case kNkMAIDCapability_RawJpegTransferStatus                 = 33876
    case kNkMAIDCapability_LimitAFAreaMode                       = 33877
    case kNkMAIDCapability_AFModeRestrictions                    = 33878
    case kNkMAIDCapability_ExpBaseHighlight                      = 33879
    case kNkMAIDCapability_ElectronicFrontCurtainShutter         = 33880
    case kNkMAIDCapability_PictureControlDataEx                  = 33881
    case kNkMAIDCapability_MovieWBMode                           = 33888
    case kNkMAIDCapability_MovieWBTuneAuto                       = 33889
    case kNkMAIDCapability_MovieWBAutoType                       = 33890
    case kNkMAIDCapability_MovieWBTuneIncandescent               = 33891
    case kNkMAIDCapability_MovieWBFluorescentType                = 33892
    case kNkMAIDCapability_MovieWBTuneFluorescent                = 33893
    case kNkMAIDCapability_MovieWBTuneSunny                      = 33894
    case kNkMAIDCapability_MovieWBTuneShade                      = 33896
    case kNkMAIDCapability_MovieWBTuneCloudy                     = 33897
    case kNkMAIDCapability_MovieWBTuneColorTempEx                = 33898
    case kNkMAIDCapability_MovieWBTuneColorAdjust                = 33899
    case kNkMAIDCapability_MovieWBTunePreset1                    = 33900
    case kNkMAIDCapability_MovieWBTunePreset2                    = 33901
    case kNkMAIDCapability_MovieWBTunePreset3                    = 33902
    case kNkMAIDCapability_MovieWBTunePreset4                    = 33903
    case kNkMAIDCapability_MovieWBTunePreset5                    = 33904
    case kNkMAIDCapability_MovieWBTunePreset6                    = 33905
    case kNkMAIDCapability_MovieWBPresetProtect1                 = 33906
    case kNkMAIDCapability_MovieWBPresetProtect2                 = 33907
    case kNkMAIDCapability_MovieWBPresetProtect3                 = 33908
    case kNkMAIDCapability_MovieWBPresetProtect4                 = 33909
    case kNkMAIDCapability_MovieWBPresetProtect5                 = 33910
    case kNkMAIDCapability_MovieWBPresetProtect6                 = 33911
    case kNkMAIDCapability_MovieWBPresetNumber                   = 33912
    case kNkMAIDCapability_MovieWBPresetName                     = 33913
    case kNkMAIDCapability_MovieWBGainRed                        = 33914
    case kNkMAIDCapability_MovieWBGainBlue                       = 33915
    case kNkMAIDCapability_MoviePictureControlData               = 33916
    case kNkMAIDCapability_MoviePictureControlDataEx             = 33917
    case kNkMAIDCapability_MovieResetMenuBank                    = 33918
    case kNkMAIDCapability_MovieCCDDataMode                      = 33919
    case kNkMAIDCapability_MovieAutoDXCrop                       = 33920
    case kNkMAIDCapability_MovieNoiseReductionHighISO            = 33921
    case kNkMAIDCapability_MoviePictureControl                   = 33922
    case kNkMAIDCapability_ChangedMoviePictureControl            = 33923
    case kNkMAIDCapability_MovieResetWBMode                      = 33924
    case kNkMAIDCapability_MovieMeteringMode                     = 33925
    case kNkMAIDCapability_GetMoviePicCtrlInfo                   = 33926
    case kNkMAIDCapability_DecaseeMovieCustomPictureControl       = 33927
    case kNkMAIDCapability_MovieWBPresetData                     = 33928
    case kNkMAIDCapability_PowerZoomByFocalLength                = 33929
    case kNkMAIDCapability_MovieCaptureMode                      = 33930
    case kNkMAIDCapability_SlowMotionMovieRecordScreenSize       = 33931
    case kNkMAIDCapability_HighSpeedStillCaptureRate             = 33932
    case kNkMAIDCapability_BestMomentCaptureMode                 = 33933
    case kNkMAIDCapability_ActiveSelectionFrameSavedDefault      = 33934
    case kNkMAIDCapability_ActiveSelectionCapture40frameOver     = 33935
    case kNkMAIDCapability_ActiveSelectionOnReleaseRecord        = 33936
    case kNkMAIDCapability_ActiveSelectionControl                = 33937
    case kNkMAIDCapability_ActiveSelectionSelectedPictures       = 33938
    case kNkMAIDCapability_SaveSelectionPictures                 = 33939
    case kNkMAIDCapability_LensTypeNikon1                        = 33940
    case kNkMAIDCapability_SilentPhotography                     = 33941
    case kNkMAIDCapability_FacePriority                          = 33942
    case kNkMAIDCapability_OpticalVR                             = 33943
    case kNkMAIDCapability_ElectronicVR                          = 33944
    case kNkMAIDCapability_CaptureLV                             = 33945
    case kNkMAIDCapability_AFCaptureLV                           = 33946
    case kNkMAIDCapability_DeviceReadyLV                         = 33947
    case kNkMAIDCapability_AFLockOnAcross                        = 33980
    case kNkMAIDCapability_AFLockOnMove                          = 33981
    case kNkMAIDCapability_IPTCPresetSelect                      = 33982
    case kNkMAIDCapability_FlashISOAutoHighLimit                 = 33985
    case kNkMAIDCapability_SBWirelessMode                        = 33986
    case kNkMAIDCapability_SBWirelessMultipleFlashMode           = 33987
    case kNkMAIDCapability_SBUsableGroup                         = 33988
    case kNkMAIDCapability_WirelessCLSEntryMode                  = 33989
    case kNkMAIDCapability_SBPINCode                             = 33990
    case kNkMAIDCapability_RadioMultipleFlashChannel             = 33991
    case kNkMAIDCapability_OpticalMultipleFlashChannel           = 33992
    case kNkMAIDCapability_FlashRangeDisplay                     = 33993
    case kNkMAIDCapability_AllTestFiringDisable                  = 33994
    case kNkMAIDCapability_IPTCPresetInfo                        = 33996
    case kNkMAIDCapability_GetSBHandles                          = 33997
    case kNkMAIDCapability_GetSBAttrDesc                         = 33998
    case kNkMAIDCapability_SBAttrValue                           = 33999
    case kNkMAIDCapability_GetSBGroupAttrDesc                    = 34000
    case kNkMAIDCapability_SBGroupAttrValue                      = 34001
    case kNkMAIDCapability_TestFlash                             = 34002
    case kNkMAIDCapability_FaceDetection                         = 34003
    case kNkMAIDCapability_3DTrackingCaptuerArea                 = 34004
    case kNkMAIDCapability_SBSettingMemberLock                   = 34006
    case kNkMAIDCapability_MatrixMetering                        = 34007
    case kNkMAIDCapability_CaptureAsync                          = 34008
    case kNkMAIDCapability_AFCaptureAsync                        = 34009
    case kNkMAIDCapability_DeviceReady                           = 34010
    case kNkMAIDCapability_SBIntegrationFlashReady               = 34011
    case kNkMAIDCapability_MirrorUpCancel                        = 34031
    case kNkMAIDCapability_MirrorUpStatus                        = 34032
    case kNkMAIDCapability_MirrorUpReleaseShootingCount          = 34033
    case kNkMAIDCapability_MovieActive_D_Lighting                = 34034
    case kNkMAIDCapability_FlickerReductionSetting               = 34035
    case kNkMAIDCapability_ExposureCompFlashUsed                 = 34036
    case kNkMAIDCapability_LimitStillCaptureMode                 = 34037
    case kNkMAIDCapability_MovieFicaseype                         = 34038
    case kNkMAIDCapability_SaveCameraSetting                     = 34039
    case kNkMAIDCapability_LiveViewTFTStatus                     = 34040
    case kNkMAIDCapability_LiveViewButtonMode                    = 34041
    case kNkMAIDCapability_ExternalRecordingControl              = 34042
    case kNkMAIDCapability_DetectionPeaking                      = 34043
    case kNkMAIDCapability_WBTuneNatural                         = 34044
    case kNkMAIDCapability_HighlightBrightness                   = 34045
    case kNkMAIDCapability_MovieWBTuneNatural                    = 34046
    case kNkMAIDCapability_MovieAttenuator                       = 34047
    case kNkMAIDCapability_GetRecordingInfo                      = 34048
    case kNkMAIDCapability_PictureControlDataEx2                 = 34049
    case kNkMAIDCapability_MoviePictureControlDataEx2            = 34050
    case kNkMAIDCapability_GetVideoImageEx                       = 34051
    case kNkMAIDCapability_DiffractionCompensation               = 34052
    case kNkMAIDCapability_VibrationReduction                    = 34053
    case kNkMAIDCapability_MovieAutoDistortion                   = 34054
    case kNkMAIDCapability_MovieAfAreaMode                       = 34055
    case kNkMAIDCapability_MovieVibrationReduction               = 34056
    case kNkMAIDCapability_MovieFocusMode                        = 34057
    case kNkMAIDCapability_MovieVignetteControl                  = 34058
    case kNkMAIDCapability_MovieDiffractionCompensation          = 34059
    case kNkMAIDCapability_HDRSaveIndividualImages               = 34060
    case kNkMAIDCapability_UserMode3                             = 34061
    case kNkMAIDCapability_RecordTimeCodes                       = 34062
    case kNkMAIDCapability_CountUpMethod                         = 34063
    case kNkMAIDCapability_TimeCodeOrigin                        = 34064
    case kNkMAIDCapability_DropFrame                             = 34065
    case kNkMAIDCapability_MovieLogOutput                        = 34066
    case kNkMAIDCapability_MovieLogSetting                       = 34067
    case kNkMAIDCapability_HDMIOutputDataDepth                   = 34068
    case kNkMAIDCapability_LowLightAF                            = 34069
    case kNkMAIDCapability_ApplyLiveViewSetting                  = 34070
    case kNkMAIDCapability_LiveViewImageStatus                   = 34071
    case kNkMAIDCapability_LiveViewZoomArea                      = 34072
    case kNkMAIDCapability_TrackingAFArea                        = 34073
    case kNkMAIDCapability_MovieAfSpeed                          = 34074
    case kNkMAIDCapability_MovieAfSpeedWhenToApply               = 34075
    case kNkMAIDCapability_MovieAfTrackingSensitivity            = 34076
    case kNkMAIDCapability_GetManualSettingLensData              = 34077
    case kNkMAIDCapability_StillCaptureModeSaveFrame             = 34078
    case kNkMAIDCapability_StillFocusAreaMode                    = 34079
    case kNkMAIDCapability_ChangeMonitorOffStatus                = 34080
    case kNkMAIDCapability_RemainingExposureTime                 = 34081
    case kNkMAIDCapability_ExtendedShutterSpeedsManual           = 34082
    case kNkMAIDCapability_QuietReleaseMode                      = 34083
    case kNkMAIDCapability_AutoAreaAFFaceDetection               = 34084
    case kNkMAIDCapability_Slot2JpegImageSize                    = 34085
    case kNkMAIDCapability_GroupAreaFaceDetection                = 34086
    case kNkMAIDCapability_SinglePointAFWatchArea                = 34087
    case kNkMAIDCapability_RearControlPanel                      = 34088
    case kNkMAIDCapability_FlushBurstPrioritize                  = 34089
    case kNkMAIDCapability_BracketingBurstOptions                = 34090
    case kNkMAIDCapability_3DTrackingFaceDetection               = 34091
    case kNkMAIDCapability_AutoAreaAFStartingPoint               = 34092
    case kNkMAIDCapability_CustomGroupingsC1                     = 34093
    case kNkMAIDCapability_LiveViewWBTuneColorTemp               = 34094
    case kNkMAIDCapability_LiveViewWBTuneColorAdjust             = 34095
    case kNkMAIDCapability_LockExposureEx                        = 34096
    case kNkMAIDCapability_InitiatePixelMapping                  = 34097
    case kNkMAIDCapability_CustomGroupingsC2                     = 34098
    case kNkMAIDCapability_ElectronicFrontCurtainShutterEx       = 34099
    case kNkMAIDCapability_AutoFlashIsoSensitivityControl        = 34100
    case kNkMAIDCapability_PreCaptureAsync                       = 34101
}


enum eNkMAIDResult: Int, CaseIterable {
    // these values are errors
    case kNkMAIDResult_NotSupported = -127
    case kNkMAIDResult_UnexpectedDataType
    case kNkMAIDResult_ValueOutOfBounds
    case kNkMAIDResult_BufferSize
    case kNkMAIDResult_Aborted
    case kNkMAIDResult_NoMedia
    case kNkMAIDResult_NoEventProc
    case kNkMAIDResult_NoDataProc
    case kNkMAIDResult_ZombieObject
    case kNkMAIDResult_OutOfMemory
    case kNkMAIDResult_UnexpectedError
    case kNkMAIDResult_HardwareError
    case kNkMAIDResult_MissingComponent

    case kNkMAIDResult_NoError = 0

    // these values are warnings
    case kNkMAIDResult_Pending
    case kNkMAIDResult_OrphanedChildren

    case kNkMAIDResult_VendorBase = 127
}

// The module will use one or more of these values to indicate what types of data a module
// or source can produce and what types of data are available for a specific item.
enum eNkMAIDDataObjType: Int, CaseIterable {
    case kNkMAIDDataObjType_Image        = 0x00000001
    case kNkMAIDDataObjType_Sound        = 0x00000002
    case kNkMAIDDataObjType_Video        = 0x00000004
    case kNkMAIDDataObjType_Thumbnail    = 0x00000008
    case kNkMAIDDataObjType_File         = 0x00000010
}

// The client will pass one of these values to the ulDataType parameter of the entry point
// to indicate how the data parameter will be interpreted by the module.
enum eNkMAIDDataType: Int, CaseIterable {
    case kNkMAIDDataType_Null = 0
    case kNkMAIDDataType_Boolean            // passed by value, set only
    case kNkMAIDDataType_Integer            // signed 32 bit int, passed by value, set only
    case kNkMAIDDataType_Unsigned           // unsigned 32 bit int, passed by value, set only
    case kNkMAIDDataType_BooleanPtr         // pointer to single byte boolean value(s)
    case kNkMAIDDataType_IntegerPtr         // pointer to signed 4 byte value(s)
    case kNkMAIDDataType_UnsignedPtr        // pointer to unsigned 4 byte value(s)
    case kNkMAIDDataType_FloatPtr           // pointer to DOUB_P value(s)
    case kNkMAIDDataType_PointPtr           // pointer to NkMAIDPoint structure(s)
    case kNkMAIDDataType_SizePtr            // pointer to NkMAIDSize structure(s)
    case kNkMAIDDataType_RectPtr            // pointer to NkMAIDRect structure(s)
    case kNkMAIDDataType_StringPtr          // pointer to NkMAIDString structure(s)
    case kNkMAIDDataType_DateTimePtr        // pointer to NkMAIDDateTime structure(s)
    case kNkMAIDDataType_CallbackPtr        // pointer to NkMAIDCallback structure(s)
    case kNkMAIDDataType_RangePtr           // pointer to NkMAIDRange structure(s)
    case kNkMAIDDataType_ArrayPtr           // pointer to NkMAIDArray structure(s)
    case kNkMAIDDataType_EnumPtr            // pointer to NkMAIDEnum structure(s)
    case kNkMAIDDataType_ObjectPtr          // pointer to NkMAIDObject structure(s)
    case kNkMAIDDataType_CapInfoPtr         // pointer to NkMAIDCapInfo structure(s)
    case kNkMAIDDataType_GenericPtr         // pointer to generic data
};

//extension UInt8 {
//    var boolValue: Bool { return self != 0 }
//}

// The module will set one of these values in the ulType member of the NkMAIDArray structure
// to indicate how the data of the array should be interpreted.
enum eNkMAIDArrayType: Int, CaseIterable {
    case kNkMAIDArrayType_Boolean = 0       // 1 byte per element
    case kNkMAIDArrayType_Integer           // signed value that is 1, 2 or 4 bytes per element
    case kNkMAIDArrayType_Unsigned          // unsigned value that is 1, 2 or 4 bytes per element
    case kNkMAIDArrayType_Float             // DOUB_P elements
    case kNkMAIDArrayType_Point             // NkMAIDPoint structures
    case kNkMAIDArrayType_Size              // NkMAIDSize structures
    case kNkMAIDArrayType_Rect              // NkMAIDRect structures
    case kNkMAIDArrayType_PackedString      // packed array of strings
    case kNkMAIDArrayType_String            // NkMAIDString structures
    case kNkMAIDArrayType_DateTime          // NkMAIDDateTime structures
}

// Tcase he module will set one of these values in the ulType member of the NkMAIDCapInfo structure
// to indicate what type of information is represented.
enum eNkMAIDCapType: Int, CaseIterable {
    case kNkMAIDCapType_Process = 0         // a process that can be started
    case kNkMAIDCapType_Boolean             // single byte boolean value
    case kNkMAIDCapType_Integer             // signed 4 byte value
    case kNkMAIDCapType_Unsigned            // unsigned 4 byte value
    case kNkMAIDCapType_Float               // DOUB_P value
    case kNkMAIDCapType_Point               // NkMAIDPoint structure
    case kNkMAIDCapType_Size                // NkMAIDSize structure
    case kNkMAIDCapType_Rect                // NkMAIDRect structure
    case kNkMAIDCapType_String              // NkMAIDString structure
    case kNkMAIDCapType_DateTime            // NkMAIDDateTime structure
    case kNkMAIDCapType_Callback            // NkMAIDCallback structure
    case kNkMAIDCapType_Array               // NkMAIDArray structure
    case kNkMAIDCapType_Enum                // NkMAIDEnum structure
    case kNkMAIDCapType_Range               // NkMAIDRange structure
    case kNkMAIDCapType_Generic             // generic data
    case kNkMAIDCapType_BoolDefault         // Reserved
}

// The module will set one of more of these values in the ulOperations member of the
// NkMAIDCapInfo structure to indicate what operations are permitted on a particular capability.
//enum eNkMAIDCapOperations: Int, CaseIterable {
//    case kNkMAIDCapOperation_Start            = 0x0001
//    case kNkMAIDCapOperation_Get                = 0x0002
//    case kNkMAIDCapOperation_Set                = 0x0004
//    case kNkMAIDCapOperation_GetArray        = 0x0008
//    case kNkMAIDCapOperation_GetDefault    = 0x0010
//}

struct eNkMAIDCapOperations: OptionSet {
    let rawValue: UInt8
    
    static let  kNkMAIDCapOperation_Start       = eNkMAIDCapOperations(rawValue: 0x0001)
    static let  kNkMAIDCapOperation_Get         = eNkMAIDCapOperations(rawValue: 0x0002)
    static let  kNkMAIDCapOperation_Set         = eNkMAIDCapOperations(rawValue: 0x0004)
    static let  kNkMAIDCapOperation_GetArray    = eNkMAIDCapOperations(rawValue: 0x0008)
    static let  kNkMAIDCapOperation_GetDefault  = eNkMAIDCapOperations(rawValue: 0x0010)
}


// The module will set one or more of these values in the ulVisibility member of the
// NkMAIDCapInfo structure to indicate what level of visibility a particular capability has.
enum eNkMAIDCapVisibility: Int, CaseIterable {
    case kNkMAIDCapVisibility_Hidden        = 0x0001
    case kNkMAIDCapVisibility_Advanced        = 0x0002
    case kNkMAIDCapVisibility_Vendor        = 0x0004
    case kNkMAIDCapVisibility_Group            = 0x0008
    case kNkMAIDCapVisibility_GroupMember    = 0x0010
    case kNkMAIDCapVisibility_Invalid            = 0x0020
}

// The module will set one of these values in the ulType member of the NkMAIDObject structure
// to indicate what type of object is represented.
enum eNkMAIDObjectType: Int, CaseIterable {
    case kNkMAIDObjectType_Module = 1
    case kNkMAIDObjectType_Source
    case kNkMAIDObjectType_Item
    case kNkMAIDObjectType_DataObj
}

// The module will deliver one of these values to the ulEvent parameter of the clients event
// callback function to indicate what event has occurred.
enum eNkMAIDEvent: Int, CaseIterable {
    case kNkMAIDEvent_AddChild
    case kNkMAIDEvent_RemoveChild
    case kNkMAIDEvent_WarmingUp
    case kNkMAIDEvent_WarmedUp
    case kNkMAIDEvent_CapChange
    case kNkMAIDEvent_OrphanedChildren
    case kNkMAIDEvent_CapChangeValueOnly
}

// When the module calls the clients user interface callback function the ulType member of
// the NkMAIDUIRequestInfo structure will be set to one of these values. The user will be
// presented with the choices specified by the value.
enum eNkMAIDUIRequestType: Int, CaseIterable {
    case kNkMAIDUIRequestType_Ok
    case kNkMAIDUIRequestType_OkCancel
    case kNkMAIDUIRequestType_YesNo
    case kNkMAIDUIRequestType_YesNoCancel
}

// When the module calls the clients user interface callback function the ulDefault member
// of the NkMAIDUIRequestInfo structure will be set to one of these values.  The value will
// indicate which button should be highlighted by default.  The clients user interface callback
// function will return one of these values depending on which button the user presses.
// The case kNkMAIDEventResult_None value can only be returned if the fSync member of the
// NkMAIDUIRequestInfo structure is FALSE.
enum eNkMAIDUIRequestResult: Int, CaseIterable {
    case kNkMAIDUIRequestResult_None
    case kNkMAIDUIRequestResult_Ok
    case kNkMAIDUIRequestResult_Cancel
    case kNkMAIDUIRequestResult_Yes
    case kNkMAIDUIRequestResult_No
}

// The module will use one or more of these values in the case kNkMAIDCapability_Filter capability.
enum eNkMAIDFilter: Int, CaseIterable {
    case kNkMAIDFilter_White
    case kNkMAIDFilter_Infrared
    case kNkMAIDFilter_Red
    case kNkMAIDFilter_Green
    case kNkMAIDFilter_Blue
    case kNkMAIDFilter_Ultraviolet
}

// The client will pass one of these values to the ulCommand parameter of the MAID entry point
// to indicate what operation the module should perform.
enum eNkMAIDCommand: Int, CaseIterable {
    case kNkMAIDCommand_Async               // process asynchronous operations
    case kNkMAIDCommand_Open                // opens a child object
    case kNkMAIDCommand_Close               // closes a previously opened object
    case kNkMAIDCommand_GetCapCount         // get number of capabilities of an object
    case kNkMAIDCommand_GetCapInfo          // get capabilities of an object
    case kNkMAIDCommand_CapStart            // starts capability
    case kNkMAIDCommand_CapSet              // set value of capability
    case kNkMAIDCommand_CapGet              // get value of capability
    case kNkMAIDCommand_CapGetDefault       // get default value of capability
    case kNkMAIDCommand_CapGetArray         // get data for array capability
    case kNkMAIDCommand_Mark                // insert mark in the command queue
    case kNkMAIDCommand_AbortToMark         // abort asynchronous commands to mark
    case kNkMAIDCommand_Abort               // abort current asynchronous command
    case kNkMAIDCommand_EnumChildren        // requests add events for all child IDs
    case kNkMAIDCommand_GetParent           // gets previously opened parent for object
    case kNkMAIDCommand_RliveesetToDefault  // resets all capabilities to their default value
}



// The module will use one or more of these values in the case kNkMAIDCapability_ColorSpace capability.
enum eNkMAIDColorSpace: Int, CaseIterable {
    case kNkMAIDColorSpace_LineArt
    case kNkMAIDColorSpace_Grey
    case kNkMAIDColorSpace_RGB
    case kNkMAIDColorSpace_sRGB
    case kNkMAIDColorSpace_CMYK
    case kNkMAIDColorSpace_Lab
    case kNkMAIDColorSpace_LCH
    case kNkMAIDColorSpace_AppleRGB
    case kNkMAIDColorSpace_ColorMatchRGB
    case kNkMAIDColorSpace_NTSCRGB
    case kNkMAIDColorSpace_BruceRGB
    case kNkMAIDColorSpace_AdobeRGB
    case kNkMAIDColorSpace_CIERGB
    case kNkMAIDColorSpace_AdobeWideRGB
    case kNkMAIDColorSpace_AppleRGB_Compensated

    case kNkMAIDColorSpace_VendorBase = 0x8000        // vendor supplied colorspaces start here
}

// The client will use these values with the case kNkMAIDCapability_NegativeDefault capability.
enum eNkMAIDBooleanDefault: Int, CaseIterable {
    case kNkMAIDBooleanDefault_None
    case kNkMAIDBooleanDefault_True
    case kNkMAIDBooleanDefault_False
}

// The module will return one of more of these values in the kNkCapability_ModuleType capability.
enum eNkMAIDModuleTypes: Int, CaseIterable {
    case kNkMAIDModuleType_Scanner        = 0x0001
    case kNkMAIDModuleType_Camera        = 0x0002
}

// The module will use these values in the NkMAIDFileInfo structure when sending file data
// to the client in response to the case kNkMAIDCapability_AcquireFile capability.
enum eNkMAIDFileDataTypes: Int, CaseIterable {
    case kNkMAIDFileDataType_NotSpecified
    case kNkMAIDFileDataType_JPEG
    case kNkMAIDFileDataType_TIFF
    case kNkMAIDFileDataType_FlashPix
    case kNkMAIDFileDataType_NIF
    case kNkMAIDFileDataType_QuickTime
    case kNkMAIDFileDataType_UserType = 0x100
}

// The module will use one or more of these values in the case kNkMAIDCapability_FlashMode capability.
enum eNkMAIDFlashMode: Int, CaseIterable {
    case kNkMAIDFlashMode_FrontCurtain
    case kNkMAIDFlashMode_RearCurtain
    case kNkMAIDFlashMode_SlowSync
    case kNkMAIDFlashMode_RedEyeReduction
    case kNkMAIDFlashMode_SlowSyncRedEyeReduction
    case kNkMAIDFlashMode_SlowSyncRearCurtain
}

enum eNkMAIDFmmManualSetting: Int, CaseIterable {
    case kNkMAIDFmmManualSetting_NoSettting = 0
    case kNkMAIDFmmManualSetting_6mm
    case kNkMAIDFmmManualSetting_8mm
    case kNkMAIDFmmManualSetting_13mm
    case kNkMAIDFmmManualSetting_15mm
    case kNkMAIDFmmManualSetting_16mm
    case kNkMAIDFmmManualSetting_18mm
    case kNkMAIDFmmManualSetting_20mm
    case kNkMAIDFmmManualSetting_24mm
    case kNkMAIDFmmManualSetting_25mm
    case kNkMAIDFmmManualSetting_28mm
    case kNkMAIDFmmManualSetting_35mm
    case kNkMAIDFmmManualSetting_43mm
    case kNkMAIDFmmManualSetting_45mm
    case kNkMAIDFmmManualSetting_50mm
    case kNkMAIDFmmManualSetting_55mm
    case kNkMAIDFmmManualSetting_58mm
    case kNkMAIDFmmManualSetting_70mm
    case kNkMAIDFmmManualSetting_80mm
    case kNkMAIDFmmManualSetting_85mm
    case kNkMAIDFmmManualSetting_86mm
    case kNkMAIDFmmManualSetting_100mm
    case kNkMAIDFmmManualSetting_105mm
    case kNkMAIDFmmManualSetting_135mm
    case kNkMAIDFmmManualSetting_180mm
    case kNkMAIDFmmManualSetting_200mm
    case kNkMAIDFmmManualSetting_300mm
    case kNkMAIDFmmManualSetting_360mm
    case kNkMAIDFmmManualSetting_400mm
    case kNkMAIDFmmManualSetting_500mm
    case kNkMAIDFmmManualSetting_600mm
    case kNkMAIDFmmManualSetting_800mm
    case kNkMAIDFmmManualSetting_1000mm
    case kNkMAIDFmmManualSetting_1200mm
    case kNkMAIDFmmManualSetting_1400mm
    case kNkMAIDFmmManualSetting_1600mm
    case kNkMAIDFmmManualSetting_2000mm
    case kNkMAIDFmmManualSetting_2400mm
    case kNkMAIDFmmManualSetting_2800mm
    case kNkMAIDFmmManualSetting_3200mm
    case kNkMAIDFmmManualSetting_4000mm
}

enum eNkMAIDF0ManualSetting: Int, CaseIterable {
    case kNkMAIDF0ManualSetting_NoSettting = 0
    case kNkMAIDF0ManualSetting_F1_2
    case kNkMAIDF0ManualSetting_F1_4
    case kNkMAIDF0ManualSetting_F1_8
    case kNkMAIDF0ManualSetting_F2_0
    case kNkMAIDF0ManualSetting_F2_5
    case kNkMAIDF0ManualSetting_F2_8
    case kNkMAIDF0ManualSetting_F3_3
    case kNkMAIDF0ManualSetting_F3_5
    case kNkMAIDF0ManualSetting_F4_0
    case kNkMAIDF0ManualSetting_F4_5
    case kNkMAIDF0ManualSetting_F5_0
    case kNkMAIDF0ManualSetting_F5_6
    case kNkMAIDF0ManualSetting_F6_3
    case kNkMAIDF0ManualSetting_F7_1
    case kNkMAIDF0ManualSetting_F8_0
    case kNkMAIDF0ManualSetting_F9_5
    case kNkMAIDF0ManualSetting_F11
    case kNkMAIDF0ManualSetting_F13
    case kNkMAIDF0ManualSetting_F15
    case kNkMAIDF0ManualSetting_F16
    case kNkMAIDF0ManualSetting_F19
    case kNkMAIDF0ManualSetting_F22
}

enum ViewModelState {
        case idle
        case loading
        case loaded
        case error
    }
