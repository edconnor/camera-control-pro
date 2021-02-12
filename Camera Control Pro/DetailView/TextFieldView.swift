//
//  TextFieldView.swift
//  Camera Control Pro
//
//  Created by Eduardo Connor on 2/10/21.
//
import Cocoa

class TextFieldViewModel : CameraUpdateProtocol {
    var capinfo:NkMAIDCapInfoObj!
    var input: String
    var nResult: Int32 = 0
    
    private(set) var state:ViewModelState = ViewModelState.idle
    
    // CameraUpdateProtocol
    func setCameraCap() {
        if capinfo.canSet()  {
            if capinfo.canSet()  {
                if(capinfo.ulType == eNkMAIDCapType.kNkMAIDCapType_Unsigned) {
                    guard let strInput =  UInt32(input) else { return }
                    nikonManager.setCapUnsigned(Int32(capinfo.ulID.rawValue), strInput)
                } else {
                    guard let strInput =  Double(input) else { return }
                    nikonManager.setCapDouble(Int32(capinfo.ulID.rawValue), strInput)
                }
            }
        }
    }
    
    init(capinfo: NkMAIDCapInfoObj, input: String) {
        self.capinfo = capinfo
        self.input = input
    }
    
    func load() {
        state = .loading
      
        var nResult: Int32 = 0

        let strInput = self.getCapUnsigned(capId: capinfo.ulID, nResult: &nResult)
        
        if nResult != 0 {
            state = .error
            return
        }
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            // Put your code which should be executed with a delay here
            self.state = .loaded
            self.input = strInput
        //}
    }
    
    func getCapUnsigned(capId: eNkMAIDCapability, nResult: inout Int32 ) -> String {
        var strInput = ""
        
        if(capinfo.ulType == eNkMAIDCapType.kNkMAIDCapType_Unsigned) {
            
            let count: Int = 32
            let pointerRange = UnsafeMutablePointer  <ULONG>.allocate(capacity: count)

            pointerRange.initialize(repeating: ULONG(), count: count)
              defer {
                pointerRange.deinitialize(count: count)
                pointerRange.deallocate()
            }
            
            nResult = nikonManager.getCapUnsigned(Int32(capinfo.ulID.rawValue), pointerRange)
           
            strInput = String(pointerRange.pointee)
          
        } else if (capinfo.ulType == eNkMAIDCapType.kNkMAIDCapType_Float){
            let ulValue = nikonManager.getCapDouble(Int32(capinfo.ulID.rawValue))
            strInput = String(ulValue)
        }
        else {
            print("TestFieldViewViewModel add getter")
        }
       
        return strInput
    }
}

class TextFieldView: NSTextField {
    var viewModel: TextFieldViewModel!
    
    override init(frame frameRect: NSRect) {
        super.init(frame:frameRect);
    }

    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }

    // customized constructor/ init
    init(capinfo: NkMAIDCapInfoObj) {
     
        super.init(frame: NSRect())
        
        self.viewModel = TextFieldViewModel(capinfo: capinfo, input: "")
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

