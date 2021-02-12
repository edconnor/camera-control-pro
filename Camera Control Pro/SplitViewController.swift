//
//  SplitViewController.swift
//  Camera Control Pro
//
//  Created by Ed Connor on 2/5/21.
//


import Cocoa

class SplitViewController: NSSplitViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
//    override func splitView(_ splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
//        return proposedMinimumPosition + 1.0
//    }
   
//    override func splitView(_ splitView: NSSplitView, shouldAdjustSizeOfSubview view: NSView) -> Bool {
//        return true
//    }

}

