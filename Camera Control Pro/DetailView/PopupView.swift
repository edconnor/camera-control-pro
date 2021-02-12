//
//  PopupView.swift
//  Camera Control Pro
//
//  Created by Eduardo Connor on 2/10/21.
//
import Cocoa

class PopupViewModel : CameraUpdateProtocol {
    var capinfo: NkMAIDCapInfoObj!
    var nResult: Int32 = 0
    
    private(set) var state:ViewModelState = ViewModelState.idle
    var pickerItems:([String], Int) = ([],0) // as tuple
 
    var selectedOption  = 3
    
    // CameraUpdateProtocol
    func setCameraCap() {
        if capinfo.canSet()  {
            nikonManager.setCapEnum(Int32(capinfo.ulID.rawValue), Int32(selectedOption))
        }
    }
    
    init(capinfo: NkMAIDCapInfoObj) {
        self.capinfo = capinfo
    }
    
    func load() {
        state = .loading
        let enumResult = getEnumArray(cap: capinfo.ulID)  // Assign return value to the tuple
        
        if (enumResult.0.count == 0) {
            state = .error
            return
        }
        
       // DispatchQueue.main.asyncAfter(deadline: .now() +  0.05) {
            // Put your code which should be executed with a delay here
            self.state = .loaded
            self.pickerItems = enumResult
            self.selectedOption = enumResult.1 // .1 is the last item in the tuple
       // }
    }
}

class PopupView: NSPopUpButton {
    var viewModel: PopupViewModel!
    
    override init(frame frameRect: NSRect) {
        super.init(frame:frameRect);
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }

    // customized constructor/ init
    init(capinfo: NkMAIDCapInfoObj) {
        super.init(frame: NSRect(), pullsDown: false)
        self.viewModel = PopupViewModel(capinfo: capinfo)
        self.viewModel.load()
        self.target = self
        self.action = #selector(onPopupChanged)
        
        self.addItems(withTitles: viewModel.pickerItems.0) // .0 is the first item in the tuple
        self.selectItem(at: viewModel.selectedOption)
    }
    
    // NSView extention override
    override func updateCapCallback()
    {
        viewModel.load()
        selectItem(at: viewModel.selectedOption)
    }
    
    @objc func onPopupChanged(_ sender: NSPopUpButton) {
        // Update the viewModel
        viewModel.selectedOption = sender.indexOfSelectedItem
        self.selectItem(at: sender.indexOfSelectedItem)

        // And in turn update the camera
        viewModel.setCameraCap()
    }
}

func getEnumArray(cap: eNkMAIDCapability)->([String], Int) {
    var itemsw = [String]()
    var strItem = String()
    
    let count: Int = 1
    let pointerEnum = UnsafeMutablePointer  <NkMAIDEnumObj>.allocate(capacity: count)

    pointerEnum.initialize(repeating: NkMAIDEnumObj(), count: count)
      defer {
        pointerEnum.deinitialize(count: count)
        pointerEnum.deallocate()
      }
  
    let rc = nikonManager.getCapArray(pointerEnum, Int32(cap.rawValue))
    if rc == false {
        return (itemsw, 0)
    }
    
    let ulType = pointerEnum.pointee.ulType
    let nElements = Int(pointerEnum.pointee.ulElements)
    let ulValue = Int(pointerEnum.pointee.ulValue)

    let typedPointerPdata = pointerEnum.pointee.pData.bindMemory(to: UInt8.self, capacity: nElements)
    defer {
        typedPointerPdata.deinitialize(count: nElements)
     }
    
    for index in 0..<nElements {
        if ulType == eNkMAIDArrayType.kNkMAIDArrayType_PackedString {
            let element = typedPointerPdata.advanced(by: index).pointee
            if (element == 0) {
                itemsw.append(strItem)
                strItem.removeAll()
            } else {
                if let uint = UInt8(exactly: element)  {
                    let character = Character(UnicodeScalar(uint))
                    strItem.append(character)
                }
            }
        } else {
            typedPointerPdata.withMemoryRebound(to: Int32.self, capacity: nElements, {
                (typedPointerPdata32: UnsafeMutablePointer<Int32>) in
                let sItem = String(cString: nikonManager.getEnumString(Int32(cap.rawValue), Int32(typedPointerPdata32.advanced(by: index).pointee)))
                itemsw.append(sItem)
              })
        }
    }
    return (itemsw, ulValue)  // return as tuple
}
