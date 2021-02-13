//
//  WindowController.swift
//  CameraControlPro
//
//  Created by Eduardo Connor on 2/3/21.
//

import Cocoa

/// - Tag: ItemIdentifiers
private extension NSToolbarItem.Identifier {
    static let videoItem: NSToolbarItem.Identifier = NSToolbarItem.Identifier(rawValue: "Video")
    static let audioItem: NSToolbarItem.Identifier = NSToolbarItem.Identifier(rawValue: "Audio")
    static let micLevelLeftItem:  NSToolbarItem.Identifier = NSToolbarItem.Identifier(rawValue: "MicLevelLeft")
    static let micLevelRightItem: NSToolbarItem.Identifier = NSToolbarItem.Identifier(rawValue: "MicLevelRight")
    static let testButtonItem: NSToolbarItem.Identifier = NSToolbarItem.Identifier(rawValue: "TestButtonItem")
}

class WindowController: NSWindowController, NSToolbarDelegate, NSSplitViewDelegate {
    /// - Tag: ToolbarOutlet
    @IBOutlet weak var toolbar:      NSToolbar!
    @IBOutlet var videoPopup:        NSPopUpButton!
    @IBOutlet var audioPopup:        NSPopUpButton!
    @IBOutlet var micLevelLeftView:  NSView!
    @IBOutlet var micLevelRightView: NSView!
    @IBOutlet var videoView:         NSView!
    @IBOutlet var audioView:         NSView!
    @IBOutlet var testPopup:         NSPopUpButton!
   
    @objc dynamic var cameraObject: CameraObject!
    
    // MARK: - Window Controller Life Cycle
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.styleMask = [
            .titled,
            .unifiedTitleAndToolbar,
            .closable,
            .miniaturizable,
            .resizable,
            //.texturedBackground
            .fullSizeContentView
        ]
        window?.appearance = NSAppearance(named: .darkAqua)
        
        // Configure our toolbar (note: this can also be done in Interface Builder).
        
        /*  If you pass false here, you turn off the customization palette. The
            NSWindow method -runToolbarCustomizationPalette: handles the display
            of the palette, which you can see in Interface Builder is connected
            to the"Customize Toolbar" menu item.
         */
        toolbar.allowsUserCustomization = true
        
        /*  Tell the toolbar that it should save any toolbar configuration changes
            to user defaults, that is, persist any mode changes or item reordering.
            The app writes the configuration to the app domain using the toolbar
            identifier as the key.
         */
        toolbar.autosavesConfiguration = true
        
        // Tell the toolbar to show icons only by default.
        toolbar.displayMode = .iconAndLabel

        // Set this cameraObject to the one found in the content view controller (ViewController.swift).
        cameraObject = contentCameraObject();
    }
    
    // Convenience accessor to our CameraObject found in CameraObjectVariables.
    func contentCameraObject() -> CameraObject {
        return CameraObjectVariables.cameraObject
    }
   
    // MARK: - I want some action :)
    @IBAction func videoSelect (_ video: NSObject)
    {
        cameraObject.setSelectedVideoDevice(selectedVideoDevice: cameraObject.currentVideoDevice)
    }
    

    @IBAction func audioSelect (_ audio: NSObject)
    {
        cameraObject.setSelectedAudioDevice(selectedAudioDevice: cameraObject.currentAudioDevice)
            
    }
    
    // MARK: - NSToolbarDelegate
    
    /** Custom factory method to create NSToolbarItems.
     
         All NSToolbarItems have a unique identifier associated with them, used to tell your
         delegate/controller what toolbar items to initialize and return at various points.
         Typically, for a given identifier, you need to generate a copy of your toolbar item,
         and return. The function creates an NSToolbarItem with a bunch of NSToolbarItem parameters.
     
         It's easy to call this function repeatedly to generate lots of NSToolbarItems for your toolbar.
     
         The label, palettelabel, toolTip, action, and menu can all be nil, depending upon what
         you want the item to do.
     */
    /// - Tag: CustomToolbarItem
    func customToolbarItem(
        itemForItemIdentifier itemIdentifier: String,
        label: String,
        paletteLabel: String,
        toolTip: String,
        itemContent: AnyObject) -> NSToolbarItem? {
        
        let toolbarItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: itemIdentifier))
        
        toolbarItem.label = label
        toolbarItem.paletteLabel = paletteLabel
        toolbarItem.toolTip = toolTip
        toolbarItem.target = self
        
        // Set the right attribute, depending on if we were given an image or a view.
        if itemContent is NSImage {
            if let image = itemContent as? NSImage {
                toolbarItem.image = image
            }
        } else if itemContent is NSView {
            if let view = itemContent as? NSView {
                toolbarItem.view = view
            }
        } else {
            assertionFailure("Invalid itemContent: object")
        }
        
        // We actually need an NSMenuItem here, so we construct one.
        let menuItem: NSMenuItem = NSMenuItem()
        menuItem.submenu = nil
        menuItem.title = label
        toolbarItem.menuFormRepresentation = menuItem
        
        return toolbarItem
    }
    
    /// - Tag: ToolbarWillAddItem
    /** This is an optional delegate function, called when a new item is about to be added to the toolbar.
         This is a good spot to set up initial state information for toolbar items, particularly items
         that you don't directly control yourself (like with NSToolbarPrintItemIdentifier).
         The notification's object is the toolbar, and the "item" key in the userInfo is the toolbar item
         being added.
     */
    func toolbarWillAddItem(_ notification: Notification) {
        let userInfo = notification.userInfo!
        if let addedItem = userInfo["item"] as? NSToolbarItem {
            let itemIdentifier = addedItem.itemIdentifier
            if itemIdentifier == .print {
                addedItem.toolTip = NSLocalizedString("print string", comment: "")
                addedItem.target = self
            }
        }
    }
    
    
    /**    NSToolbar delegates require this function.
         It takes an identifier, and returns the matching NSToolbarItem. It also takes a parameter telling
         whether this toolbar item is going into an actual toolbar, or whether it's going to be displayed
         in a customization palette.
     */
/// - Tag: ToolbarItemForIdentifier
    func toolbar(
        _ toolbar: NSToolbar,
        itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
        willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        var toolbarItem: NSToolbarItem?
        
        /** Create a new NSToolbarItem instance and set its attributes based on
            the provided item identifier.
         */
        
        if itemIdentifier == NSToolbarItem.Identifier.videoItem {
            // 1) Video camera toolbar item.
            toolbarItem =
                customToolbarItem(itemForItemIdentifier: NSToolbarItem.Identifier.videoItem.rawValue,
                                  label: NSLocalizedString("Video", comment: ""),
                                  paletteLabel: NSLocalizedString("Video", comment: ""),
                                  toolTip: NSLocalizedString("Select current video camera", comment: ""),
                                  itemContent: videoView)!
        } else if itemIdentifier == NSToolbarItem.Identifier.audioItem {
            // 2) Microphone toolbar item.
            toolbarItem =
                customToolbarItem(itemForItemIdentifier: NSToolbarItem.Identifier.audioItem.rawValue,
                                  label: NSLocalizedString("Audio", comment: ""),
                                  paletteLabel: NSLocalizedString("Audio", comment: ""),
                                  toolTip: NSLocalizedString("Select current microphone", comment: ""),
                                  itemContent: audioView)!
        } else if itemIdentifier == NSToolbarItem.Identifier.micLevelLeftItem {
        // 2) Microphone toolbar item.
        toolbarItem =
            customToolbarItem(itemForItemIdentifier: NSToolbarItem.Identifier.micLevelLeftItem.rawValue,
                              label: NSLocalizedString("Mic Level (L)", comment: "Mic Level (L)"),
                              paletteLabel: NSLocalizedString("Mic Level (L)", comment: ""),
                              toolTip: NSLocalizedString("DB level - left channel", comment: "DB level - left channel"),
                              itemContent: micLevelLeftView)!
        } else if itemIdentifier == NSToolbarItem.Identifier.micLevelRightItem {
            // 2) Microphone toolbar item.
            toolbarItem =
                customToolbarItem(itemForItemIdentifier: NSToolbarItem.Identifier.micLevelRightItem.rawValue,
                                  label: NSLocalizedString("Mic Level (R)", comment: ""),
                                  paletteLabel: NSLocalizedString("Mic Level (R)", comment: ""),
                                  toolTip: NSLocalizedString("DB level - right channel", comment: "Audio"),
                                  itemContent: micLevelRightView)!
        } else if itemIdentifier == NSToolbarItem.Identifier.testButtonItem {
            // 2) Test a popup button
            toolbarItem =
                customToolbarItem(itemForItemIdentifier: NSToolbarItem.Identifier.testButtonItem.rawValue,
                                  label: NSLocalizedString("TestButton", comment: ""),
                                  paletteLabel: NSLocalizedString("TestButton", comment: ""),
                                  toolTip: NSLocalizedString("TestButton tootip", comment: "TestButton"),
                                  itemContent: testPopup)!
        
        }
            
        return toolbarItem
    }

    
    /** NSToolbar delegates require this function. It returns an array holding identifiers for the default
         set of toolbar items. It can also be called by the customization palette to display the default toolbar.
     
         Note: That since our toolbar is defined from Interface Builder, an additional separator and customize
         toolbar items will be automatically added to the "default" list of items.
     */
    /// - Tag: DefaultIdentifiers
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.videoItem, .audioItem, .micLevelLeftItem,.micLevelRightItem]
      
    }
    
    /** NSToolbar delegates require this function. It returns an array holding identifiers for all allowed
         toolbar items in this toolbar. Any not listed here will not be available in the customization palette.
     */
/// - Tag: AllowedToolbarItems
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
                NSToolbarItem.Identifier.testButtonItem,
                NSToolbarItem.Identifier.micLevelLeftItem,
                NSToolbarItem.Identifier.micLevelRightItem,
                NSToolbarItem.Identifier.videoItem,
                NSToolbarItem.Identifier.audioItem,
                NSToolbarItem.Identifier.space,
                NSToolbarItem.Identifier.flexibleSpace,
                NSToolbarItem.Identifier.print ]
    }
    
    func splitView(_ splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        return proposedMinimumPosition + 1.0
    }
}
