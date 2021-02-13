//
//  CameraObject.swift
//  testCameraControlProApp
//
//  Created by Eduardo Connor on 1/30/21.
//

//import SwiftUI

import AVFoundation
import CoreMediaIO
import Combine

var  nikonManager = NikonManagerWrapper()

struct CameraObjectVariables {
    static var cameraObject: CameraObject!
}

class CameraObject: NSObject, AVCaptureFileOutputDelegate, AVCaptureFileOutputRecordingDelegate {
    
    @IBOutlet var previewView: LiveView!
    @IBOutlet var videoDevices: Array<AVCaptureDevice> = []
    @IBOutlet var audioDevices: Array<AVCaptureDevice> = []
    @IBOutlet var currentVideoDevice: AVCaptureDevice!
    @IBOutlet var currentAudioDevice: AVCaptureDevice!
    @IBOutlet var audioLevelLeftMeter: NSLevelIndicator!
    @IBOutlet var audioLevelRighrMeter: NSLevelIndicator!
    @IBOutlet var previewVolume: NSNumber!
    
    var detailViewController: DetailViewController!
    
    // MARK: Recording Controls
    var session = AVCaptureSession()
    //var availableSessionPresets: Array<AVCaptureSession.Preset> = []
    @IBOutlet var hasRecordingDevice:NSNumber!
    @IBOutlet var recording:NSNumber!
    
    // MARK: Transport Controls
    @IBOutlet var playing:NSNumber!
    @IBOutlet var rewinding:NSNumber!
    @IBOutlet var fastForwarding:NSNumber!
    
    var caps: Dictionary = [eNkMAIDCapability: NkMAIDCapInfoObj]()
    
    var audioLevelTimer = Timer();
    @objc dynamic var audioLevelDbLeft:  Float = 0.0
    @objc dynamic var audioLevelDbRight: Float = 0.0
   
    var movieFileOutput = AVCaptureMovieFileOutput()
    var audioPreviewOutput = AVCaptureAudioPreviewOutput()
    var videoDeviceInput: AVCaptureDeviceInput!
    var audioDeviceInput: AVCaptureDeviceInput!
    var runCount = 0  // Async timer
    
    var nikonCallbackWrapper:NikonCallbackWrapper!
    
    public var columnsSpacing: CGFloat = 100.0
    
    var timer: Timer!
    
    override init()
    {
        super.init()
        nikonManager.cameraObject = self
        CameraObjectVariables.cameraObject = self 

        nikonCallbackWrapper = NikonCallbackWrapper()
        nikonCallbackWrapper.cameraObject = self

        hasRecordingDevice = false
        recording = false

        var prop = CMIOObjectPropertyAddress(
                    mSelector: CMIOObjectPropertySelector(kCMIOHardwarePropertyAllowScreenCaptureDevices),
                    mScope: CMIOObjectPropertyScope(kCMIOObjectPropertyScopeGlobal),
                    mElement: CMIOObjectPropertyElement(kCMIOObjectPropertyElementMaster))
        
        var allow: UInt32 = 1;
        CMIOObjectSetPropertyData(CMIOObjectID(kCMIOObjectSystemObject), &prop,
                                          0, nil,
                                          UInt32(MemoryLayout.size(ofValue: allow)), &allow)
        
        movieFileOutput.delegate = self
        session.addOutput(movieFileOutput);
        
        previewVolume = 0.0
        audioPreviewOutput.volume = previewVolume.floatValue
        session.addOutput(audioPreviewOutput)
        
        // MARK:  Select devices if any exist
        let  videoDevice = AVCaptureDevice.default(for: .video)!
        setSelectedVideoDevice(selectedVideoDevice: videoDevice)

        let  audioDevice = AVCaptureDevice.default(for: .audio)!
        setSelectedAudioDevice(selectedAudioDevice:  audioDevice)
        
        // MARK: Refresh Devices
        refreshDevices()
        
        // MARK: Refresh Caps
        refreshCaps()
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()

        audioLevelTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateAudioLevels), userInfo: nil, repeats: true)
        
        // Create primary LiveView capture layer
        var previewViewLayer = previewView.layer
        
        //previewViewLayer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        
//        previewViewLayer?.borderWidth = 2
//        previewViewLayer?.borderColor = CGColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
//        previewViewLayer?.cornerRadius = 5.0
//        previewViewLayer?.shadowOffset = CGSize(width: 3.0, height: 3.0)
            
        let newPreviewLayer = AVCaptureVideoPreviewLayer()
        newPreviewLayer.session = session
        newPreviewLayer.frame  = previewView.bounds
        newPreviewLayer.layoutManager = CAConstraintLayoutManager()
        newPreviewLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        
        previewView.layer?.addSublayer(newPreviewLayer)
        
        newPreviewLayer.addConstraint(CAConstraint(attribute: CAConstraintAttribute.midX, relativeTo: "superlayer", attribute: CAConstraintAttribute.minX))
        newPreviewLayer.addConstraint(CAConstraint(attribute: CAConstraintAttribute.midY, relativeTo: "superlayer", attribute: CAConstraintAttribute.minY))

        newPreviewLayer.addConstraint(CAConstraint(attribute: CAConstraintAttribute.width, relativeTo: "superlayer", attribute: CAConstraintAttribute.width))
        newPreviewLayer.addConstraint(CAConstraint(attribute: CAConstraintAttribute.height, relativeTo: "superlayer", attribute: CAConstraintAttribute.height))

        newPreviewLayer.setNeedsDisplay()
                //self.centerView.layer?.setNeedsDisplay()
        
        previewViewLayer = newPreviewLayer
        
        // Create LiveView graphic capture overlay layer. Used for camera heads-up display
        let lvPreviewLayer = LiveViewPreviewLayer()
        lvPreviewLayer.session = session
        lvPreviewLayer.frame  = previewView.bounds
        lvPreviewLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        previewView.layer?.addSublayer(lvPreviewLayer)
        session.startRunning()

        refreshDevices()
        
        let context = ["Nikon 6 ZII": "@Async"]
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(fireAsyncTimer), userInfo: context, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
    }

    @IBAction func setVolume (_ volume: NSObject)
    {
        audioPreviewOutput.volume = previewVolume.floatValue
    }
    
    @IBAction func stopRecording(_ record: Bool) {
        movieFileOutput.stopRecording()
    }
    
    @IBAction func startRecording(_ button: NSButton) {
        Swift.print("startRecording isEnabled = " + String(button.state.rawValue))
       
        if button.state == NSControl.StateValue.on {
            recording = true
            // Record to a temporary file, which the user will relocate when recording is finished

            // The template string:
            let template = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("file.XXXXXX") as NSURL

            // Fill buffer with a C string representing the local file system path.
            var buffer = [Int8](repeating: 0, count: Int(PATH_MAX))
            template.getFileSystemRepresentation(&buffer, maxLength: buffer.count)

            // Create unique file name (and open file):
            let fd = mkstemp(&buffer)
            if fd != -1 {
                // Create URL from file system string:
//                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//                fileURL = URL(string:"\(documentsURL.appendingPathComponent("temp"))" + ".mov")
//                movieFileOutput.startRecording(to: fileURL!, recordingDelegate: self)
//
//                Swift.print("mkstemp file name: " + fileURL!.absoluteString)
            }
        } else {
            recording = false
            Swift.print("Error: " + String(cString: strerror(errno)))
            movieFileOutput.stopRecording()
        }
    }
    
    func computeDecibels(averagePowerLevel: Float) -> Float
    {
        return pow(10.0, 0.05 * averagePowerLevel) * 20.0
    }
    
    @objc func updateAudioLevels()
    {
        // Currently only supports 1 or 2 channels.
        // TODO ejc - add support for multi-channel input
        
        var averagePowerLevels = [Float]()
    
        for connection in movieFileOutput.connections {
            for audioChannel in connection.audioChannels {
                averagePowerLevels.append(audioChannel.averagePowerLevel)
            }
        }
        
        if (averagePowerLevels.count == 1 ) {
            audioLevelDbLeft  = computeDecibels(averagePowerLevel: averagePowerLevels[0])
            audioLevelDbRight = 0.0
        }
        else if (averagePowerLevels.count == 2) {
            audioLevelDbLeft  = computeDecibels(averagePowerLevel: averagePowerLevels[0])
            audioLevelDbRight = computeDecibels(averagePowerLevel: averagePowerLevels[1])
        } else {
            audioLevelDbLeft  = 0.0
            audioLevelDbRight = 0.0
        }
    }
    
    @objc func fireAsyncTimer(timer: Timer) {
        nikonManager.async()
    }
    
    @objc func callbackEvent(capId: Int, objectType: Int, eventType: Int)
    {
        if detailViewController != nil {
            detailViewController.updateCap(capId: capId)
        }
    }
    
    func setSelectedVideoDevice(selectedVideoDevice: AVCaptureDevice )
    {
        session.beginConfiguration ()

        if (videoDeviceInput != nil) {
            // Remove the old device input from the session
            session.removeInput(videoDeviceInput);
            videoDeviceInput = nil;
        }

        do {
            try videoDeviceInput = AVCaptureDeviceInput(device: selectedVideoDevice)

            let videoDeviceFormat =  selectedVideoDevice.activeFormat
            //let desc =  videoDeviceFormat.formatDescription
            let mediaType = videoDeviceFormat.formatDescription.mediaType

            switch (mediaType)
            {
            case .video:
                currentVideoDevice = selectedVideoDevice
                break
            default:
                break;
            }
            
            session.addInput(videoDeviceInput)
        } catch  {

        }
        
        if (currentVideoDevice != nil) {
            hasRecordingDevice = true
        }
        
        if (currentAudioDevice != nil){
            hasRecordingDevice = true
        }
        
        session.commitConfiguration ()
    }

    func setSelectedAudioDevice(selectedAudioDevice: AVCaptureDevice )
    {
        session.beginConfiguration ()

        if (audioDeviceInput != nil) {
            // Remove the old device input from the session
            session.removeInput(audioDeviceInput);
            audioDeviceInput = nil;
        }

        do {
            try audioDeviceInput = AVCaptureDeviceInput(device: selectedAudioDevice)
            let audioDeviceFormat =  selectedAudioDevice.activeFormat
            let mediaType = audioDeviceFormat.formatDescription.mediaType
            
            session.addInput(audioDeviceInput)
            switch (mediaType)
            {
            case .audio:
                currentAudioDevice = selectedAudioDevice
               // let formatName = CMFormatDescriptionGetExtension(audioDeviceFormat.formatDescription, extensionKey: kCMFormatDescriptionExtension_FormatName)
                break
            default:
                break;
            }
        } catch  {
           
        }
        

        hasRecordingDevice = true
        if (currentVideoDevice != nil) {
            hasRecordingDevice = true
        }
        
        if (currentAudioDevice != nil){
            hasRecordingDevice = true
        }
        
        session.commitConfiguration ()
    }
    
    func refreshDevices ()
    {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [ .builtInWideAngleCamera, .externalUnknown ],
            mediaType: .video,
            position: .unspecified
        )
        self.videoDevices  = deviceDiscoverySession.devices

        let audioDiscoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInMicrophone, .externalUnknown],
            mediaType: .audio,
            position: .unspecified
        )
        self.audioDevices  = audioDiscoverySession.devices
    }
    
    func fileOutputShouldProvideSampleAccurateRecordingStart(_ output: AVCaptureFileOutput) -> Bool {
            Swift.print("fileOutputShouldProvideSampleAccurateRecordingStart")
            return false
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        Swift.print("captureOutput didFinishRecordingTo")
    }
    
    func refreshCaps()
    {
        let count: Int = Int(nikonManager.getCapCount())
        let pointer = UnsafeMutablePointer<NkMAIDCapInfo>.allocate(capacity: count)
        
        pointer.initialize(repeating: NkMAIDCapInfo(), count: count)
          defer {
            pointer.deinitialize(count: count)
            pointer.deallocate()
          }
        
        nikonManager.getCapInfoObj(pointer, Int32(count))
        
        let bufferPointer = UnsafeBufferPointer(start: pointer, count: count)

        for (_, value) in bufferPointer.enumerated() {
    
            let szDescription = withUnsafePointer(to: value.szDescription) {
                $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout.size(ofValue: $0)) {
                    String(cString: $0)
                }
            }
            let id  = eNkMAIDCapability(rawValue: Int(value.ulID))
            if (id != nil)
            {
                let ulOperations : eNkMAIDCapOperations = eNkMAIDCapOperations(rawValue: UInt8(value.ulOperations))
                let obj = NkMAIDCapInfoObj(ulID: id!,
                                           ulType:        eNkMAIDCapType(rawValue: Int(value.ulType))!,
                                           ulVisibility:  eNkMAIDCapVisibility(rawValue: Int(value.ulVisibility)) ?? eNkMAIDCapVisibility.kNkMAIDCapVisibility_Invalid,
                                           ulOperations:  ulOperations,
                                           szDescription: szDescription)
                caps[id!] = obj
            }
        }
    }
}

    

