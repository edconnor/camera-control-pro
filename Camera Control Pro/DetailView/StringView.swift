//
//  StringView.swift
//  Camera Control Pro
//
//  Created by Eduardo Connor on 2/11/21.
//

import Cocoa

class StringViewModel : CameraUpdateProtocol {
    var capinfo:NkMAIDCapInfoObj!
    var input: String
    var nResult: Int32 = 0
    
    private(set) var state:ViewModelState = ViewModelState.idle
    
    // CameraUpdateProtocol
    func setCameraCap() {
        if capinfo.canSet()  {
            if capinfo.canSet()  {
                //nikonManager.setCapBool(Int32(capinfo.ulID.rawValue), outputText)  // TODO ejc add setter
            }
        }
    }
    
    init(capinfo: NkMAIDCapInfoObj, input: String) {
        self.capinfo = capinfo
        self.input = input
    }
    
    func load() {
        state = .loading
        
        let pointerStr: LPVOID = UnsafeMutableRawPointer.allocate(byteCount: 256, alignment: 1)
        let typedPointerStr = pointerStr.bindMemory(to: Int8.self, capacity: 256)
        defer {
            typedPointerStr.deinitialize(count: 256)
         }
       
        let rc = nikonManager.getCapString(Int32(capinfo.ulID.rawValue), typedPointerStr);
        if rc == false {
            state = .error
            return
        }
        let strInput = String(cString: typedPointerStr)
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            // Put your code which should be executed with a delay here
            self.state = .loaded
            self.input = strInput
        //}
    }
}

class StringView: NSTextField {
    var viewModel: StringViewModel!
    
    override init(frame frameRect: NSRect) {
        super.init(frame:frameRect);
    }

    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }

    // customized constructor/ init
    init(capinfo: NkMAIDCapInfoObj) {
     
        super.init(frame: NSRect())
        
        self.viewModel = StringViewModel(capinfo: capinfo, input: "")
        self.viewModel.load()
        
        self.stringValue = viewModel.input
        self.target = self
        self.action = #selector(onTextChanged)
        
        //translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            widthAnchor.constraint(equalToConstant: 200),
        ])
        
        
    }
    
    // NSView extention override
    override func updateCapCallback()
    {
        viewModel.load()
        stringValue = viewModel.input
    }
    
    @objc func onTextChanged(_ sender: NSTextField) {
        // Update the viewModel
        viewModel.input = stringValue

        // And in turn update the camera
        viewModel.setCameraCap()
    }
}


