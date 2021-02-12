//
//  SliderStackView.swift
//  Camera Control Pro
//
//  Custom slider control with min/max range labels and real-time value label
//
//  Created by Eduardo Connor on 2/9/21.
//

import Cocoa

class SliderViewModel : CameraUpdateProtocol {
    var capinfo: NkMAIDCapInfoObj!
    var step = 1.0
    var steps = 10
    var range: ClosedRange<Double>
    var delta: Double = 1.0
    var nResult: Int32 = 0
  
    @Published private(set) var state:ViewModelState = ViewModelState.idle
    var sliderValue: Double = 0.0
    
    // CameraUpdateProtocol
    func setCameraCap() {
        if capinfo.canSet() {
            nikonManager.setCapRange(Int32(capinfo.ulID.rawValue), sliderValue)
        }
    }

    init(capinfo: NkMAIDCapInfoObj) {
        self.capinfo = capinfo
        self.step = 1
        self.range = 0...1
    }
    
    func load() {
        state = .loading
        
        let rangeObj = self.getCapRange(capId: capinfo.ulID, nResult: &nResult)
        
        if nResult != 0 {
            state = .error
            return
        }
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            // Put your code which should be executed with a delay here
            self.range = rangeObj.min...rangeObj.max
            self.step = rangeObj.delta
            self.steps =  Int(rangeObj.range.ulSteps)
            self.state = .loaded
            self.sliderValue = rangeObj.value
       // }
    }
    
    func getCapRange(capId: eNkMAIDCapability, nResult: inout Int32 ) -> NkMAIDRangeObj {
        
        let count: Int = 1
        let pointerRange = UnsafeMutablePointer  <NkMAIDRange>.allocate(capacity: count)

        pointerRange.initialize(repeating: NkMAIDRange(), count: count)
          defer {
            pointerRange.deinitialize(count: count)
            pointerRange.deallocate()
        }
        
        nResult = nikonManager.getCapRange(Int32(capinfo.ulID.rawValue), pointerRange)
 
       
        return NkMAIDRangeObj(range: pointerRange.pointee)
    }
}

class SliderStackView: NSStackView {
    var slider: NSSlider!
    var sliderValue: NSTextField!
    var sliderMin:NSTextField!
    var sliderMax:NSTextField!
    var viewModel: SliderViewModel!
    
    var value: Double {
        get {
            slider.doubleValue
        }
        set(newValue) {
            slider.doubleValue = newValue;
            sliderValue.stringValue = slider.stringValue
        }
    }

    override init(frame frameRect: NSRect) {
        super.init(frame:frameRect);
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }

    // customized constructor/ init
    init(frame frameRect: NSRect, capinfo: NkMAIDCapInfoObj) {
        super.init(frame:frameRect);
        self.viewModel = SliderViewModel(capinfo: capinfo)
        self.viewModel.load()
 
        slider = NSSlider(value: viewModel.sliderValue, minValue: viewModel.range.lowerBound, maxValue: viewModel.range.upperBound,
                               target: self, action: #selector(onSliderChanged))
        
        slider.numberOfTickMarks = viewModel.steps
        slider.allowsTickMarkValuesOnly = true
        sliderValue = NSTextField(labelWithString: String(value))
        
        createSliderStack(value: value, range: viewModel.range)
        
        self.value = slider.doubleValue
    }
    
    // Fill the entire stack frame with a nice hightlight box with rounded corners :)
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    
        let path = NSBezierPath(roundedRect: dirtyRect, xRadius: 5.0, yRadius: 5.0)
        NSColor.tertiaryLabelColor.setFill()
        path.fill()
    }
    
    // NSView extention override
    override func updateCapCallback()
    {
        viewModel.load()
        sliderValue.doubleValue = viewModel.sliderValue
        slider.doubleValue = viewModel.sliderValue
    }

    
    @objc func onSliderChanged(_ sender: NSSlider) {
        // Update the the slider stringValue in this stack view.
        sliderValue.stringValue = slider.stringValue
        
        // Update the viewModel
        viewModel.sliderValue = slider.doubleValue
        
        // And in turn update the camera
        viewModel.setCameraCap()
    }
    
    private func createSliderStack (value: Double, range: ClosedRange<Double>)
    {
        sliderMin = NSTextField(labelWithString: String(range.lowerBound))
        sliderMax = NSTextField(labelWithString: String(range.upperBound))

        let sliderArrayH = [sliderMin!, slider!, sliderMax!]

        let stackViewH = NSStackView(views: sliderArrayH)
        stackViewH.orientation = .horizontal

        let sliderArrayV = [stackViewH, sliderValue!]
       
        self.setViews(sliderArrayV, in: NSStackView.Gravity.top)
        
        self.orientation = .vertical
        self.distribution = .fillEqually
        self.spacing = 5.0

        stackViewH.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        sliderValue.translatesAutoresizingMaskIntoConstraints = false
        sliderMin.translatesAutoresizingMaskIntoConstraints = true
        
        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: stackViewH.topAnchor, constant: 10),
            sliderMin.topAnchor.constraint(equalTo: stackViewH.topAnchor, constant: 10),
            sliderMax.topAnchor.constraint(equalTo: stackViewH.topAnchor, constant: 10),
            stackViewH.rightAnchor.constraint(equalTo: sliderMax.rightAnchor, constant: 5),
            slider.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
}
