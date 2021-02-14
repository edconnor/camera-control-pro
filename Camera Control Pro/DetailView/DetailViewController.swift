//
//  DetailViewController.swift
//  Camera Control Pro
//
//  Created by Eduardo Connor on 2/4/21.
//

import Cocoa

protocol CameraUpdateProtocol {
    func setCameraCap()
}

extension NSView {
    // Override in derived class
    @objc func updateCapCallback() {
        print("no-op")
        assert(false)
    }
}

class DetailViewController: NSViewController {
    @IBOutlet weak var nameLabel: NSString!
    @IBOutlet weak var descriptionLabel: NSString!
    @IBOutlet weak var image: NSImage!
    @IBOutlet weak var gridContainerView: NSView!
    
    var modelData: ModelData!
    var capViews:  Dictionary = [Int: NSView]()
    var gridViews: Dictionary = [Int: NSGridView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nikonManager.cameraObject.detailViewController = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    public func updateCap(capId: Int)
    {
        let view = capViews[capId]
        if view != nil {
            view!.updateCapCallback()
        }
    }

    func createGridView(pageId: Int) {
        
        if gridViews[pageId] == nil {
            createControls(pageId: pageId)
        } else {
            let view = gridViews[pageId]
            gridContainerView.subviews[0].removeFromSuperview()
            gridContainerView.addSubview(view!)
            //view!.frame = NSRect(x: 0, y: 0, width: gridContainerView.frame.size.width , height: gridContainerView.frame.size.height)
            return
        }
        
        let view = gridViews[pageId]
        if gridContainerView.subviews.count != 0 {
            gridContainerView.replaceSubview(gridContainerView.subviews[0], with: view!)
        } else {
            gridContainerView.addSubview(view!)
        }
        view!.frame = NSRect(x: 0, y: 0, width: gridContainerView.frame.size.width , height: gridContainerView.frame.size.height)
    }

    func createControls(pageId: Int) {
        var views = [[NSView]]()
        
        let capInfoPage:CapInfoPage
        
        if nikonManager.cameraConnected() {
            capInfoPage = modelData.capInfoPages[pageId]
        } else {
            capInfoPage = modelData.modInfoPage
        }
        
        for capability in capInfoPage.capabilities {
            let capinfo = nikonManager.cameraObject.caps[capability]

            if (capinfo == nil) {
                print("Camera does not support: \(capability)" as String)

            } else {
                var label:NSTextField!
                var view:NSView!
                let type = capinfo!.ulType
                
                switch type {
                    case eNkMAIDCapType.kNkMAIDCapType_Enum:
                        label = NSTextField(labelWithString: capinfo!.szDescription)
                        view = PopupView(capinfo: capinfo!)
                     
                    case eNkMAIDCapType.kNkMAIDCapType_Range:
                        label = NSTextField(labelWithString: capinfo!.szDescription)
                        view = SliderStackView(frame: self.view.frame, capinfo: capinfo!)
                       
                    case eNkMAIDCapType.kNkMAIDCapType_Boolean:
                        label = NSTextField(labelWithString: capinfo!.szDescription)
                        view = ToggleView(capinfo: capinfo!)
                        
                    case eNkMAIDCapType.kNkMAIDCapType_String:
                        label = NSTextField(labelWithString: capinfo!.szDescription)
                        view = StringView(capinfo: capinfo!)
            
                    case eNkMAIDCapType.kNkMAIDCapType_Unsigned:
                        label = NSTextField(labelWithString: capinfo!.szDescription)
                        view = TextFieldView(capinfo: capinfo!)
                    
                    case eNkMAIDCapType.kNkMAIDCapType_Float:
                        label = NSTextField(labelWithString: capinfo!.szDescription)
                        view = TextFieldView(capinfo: capinfo!)
                    case eNkMAIDCapType.kNkMAIDCapType_Callback:
                        label = NSTextField(labelWithString: capinfo!.szDescription)
                        view  = NSTextField(labelWithString: "\(capability)" )
                    default:
                        label = NSTextField(labelWithString: "eNkMAIDCapType missing:" )
                        label.textColor = .red
                        view  = NSTextField(labelWithString: "\(capability)" )
                }
                
                label.alignment = .right
                views.append([label, view])
                capViews[capinfo!.ulID.rawValue] = view
                
            } // else
        } // for loop
        
        let empty = NSTextField(labelWithString: "")
        views.append([empty])
        
        let gridView = NSGridView(views: views)
        gridViews[pageId] = gridView

        // Set the hugging priority and remove spaces between rows and columns.
        //gridView.setContentHuggingPriority(NSLayoutConstraint.Priority(rawValue: 600), for: .horizontal)
        gridView.setContentHuggingPriority(NSLayoutConstraint.Priority(rawValue: 600), for: .vertical)

        // the first column needs to be right-justified:
        gridView.column(at: 0).xPlacement = .trailing
        // all cells use firstBaseline alignment
        gridView.rowAlignment = .firstBaseline

        let col = gridView.column(at: 0)
        col.trailingPadding = 10

        // Just in case we need a little extra vertical space around the views:
        //let row = gridView.cell(for: view)!.row!
        //row.topPadding = 5
        //row.bottomPadding = 5
        //gridView.cell(for:statusCellsLabel)!.row!.topPadding = 6
//                gridView.translatesAutoresizingMaskIntoConstraints = false
//                NSLayoutConstraint.activate([
//                    gridContainerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20),
//                        ])
//
    }
}
