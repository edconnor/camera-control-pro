//
//  ToggleView.swift
//  Camera Control Pro
//
//  Created by Eduardo Connor on 2/10/21.
//
import Cocoa

class ToggleViewModel : CameraUpdateProtocol {
    var capinfo:NkMAIDCapInfoObj!
    var nResult: Int32 = 0
    
    private(set) var state:ViewModelState = ViewModelState.idle
 
    var toggleValue: NSButton.StateValue = .off
    
    // CameraUpdateProtocol
    func setCameraCap() {
        if capinfo.canSet()  {
            if capinfo.canSet() {
                nikonManager.setCapBool(Int32(capinfo.ulID.rawValue), toggleValue == NSButton.StateValue.off ? false : true)
            }
        }
    }
    
    init(capinfo: NkMAIDCapInfoObj) {
        self.capinfo = capinfo
    }
    
    
    func load() {
        state = .loading
    
        let bResult = nikonManager.getCapBool(Int32(capinfo.ulID.rawValue))
//        if bResult == false {    // TODO ejc add proper return status on ALL getters and setters!!!
//            state = .error
//            return
//        }
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            // Put your code which should be executed with a delay here
            self.state = .loaded
        self.toggleValue = bResult ? NSButton.StateValue.on : NSButton.StateValue.off
        //}
    }
}

class ToggleView: NSButton {
    var viewModel: ToggleViewModel!
    
    override init(frame frameRect: NSRect) {
        super.init(frame:frameRect);
    }

    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }

    // customized constructor/ init
    init(capinfo: NkMAIDCapInfoObj) {
     
        super.init(frame: NSRect())
        
        self.viewModel = ToggleViewModel(capinfo: capinfo)
        self.viewModel.load()
        
        self.setButtonType(.switch)
        self.title = ""
        self.target = self
        self.action = #selector(onToggleChanged)
        self.state = viewModel.toggleValue
    }
    
    // NSView extention override
    override func updateCapCallback()
    {
        viewModel.load()
        state = viewModel.toggleValue
    }
    
    @objc func onToggleChanged(_ sender: NSButton) {
        // Update the viewModel
        viewModel.toggleValue = sender.state

        // And in turn update the camera
        viewModel.setCameraCap()
    }
}

