//
//  MouseViewSwiftUi.swift
//  testmacos
//
//  Created by Eduardo Connor on 12/26/20.
//

import SwiftUI

struct LiveViewRepresentable: NSViewRepresentable {
    func updateNSView(_ nsView: LiveView, context: NSViewRepresentableContext<LiveViewRepresentable>) {
        print("Update")
    }

    func makeNSView(context: Context) -> LiveView {
        LiveView()
    }
}

class LiveView: NSView {

    
    private var currentContext : CGContext? {
        get {
            if #available(OSX 10.10, *) {
                return NSGraphicsContext.current?.cgContext
            } else if let contextPointer = NSGraphicsContext.current?.graphicsPort {
                return Unmanaged.fromOpaque(contextPointer).takeUnretainedValue()
            }

            return nil
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        let path = NSBezierPath(ovalIn: dirtyRect)
      //  NSColor.green.setFill()
       // NSColor.gray.setFill()
       // NSColor.black.setFill()
        path.fill()
    }
  
    override func mouseDown(with theEvent: NSEvent) {
        print("left mouse")
    }

    override func rightMouseDown(with theEvent: NSEvent) {
        print("right mouse")
    }
}
