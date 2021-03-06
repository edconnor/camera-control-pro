//
//  MasterViewController.swift
//  Camera Control Pro
//
//  Created by Eduardo Connor on 2/4/21.
//

import Cocoa

class MasterViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    @IBOutlet weak var tableView: NSTableView!
  
    var detailViewController: DetailViewController!
    var gridView: NSGridView!
    var modelData = ModelData()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.delegate = self
        tableView.dataSource = self
        tableView.target = self
        
        guard let splitViewController = self.parent as? NSSplitViewController
        else { return }
        
        detailViewController = (splitViewController.splitViewItems[1].viewController as! DetailViewController)
        detailViewController.modelData = modelData
        
        nikonManager.cameraObject.masterViewController = self
    }
   
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        if nikonManager.cameraConnected() {
            return modelData.capInfoPages.count
        } else {
            return 1
        }
    }
  
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var image: NSImage?
        var text: String = ""
        var cellIdentifier: String = ""
        
        let capInfoPage:CapInfoPage
        
        if nikonManager.cameraConnected() {
            capInfoPage = modelData.capInfoPages[row]
        } else {
            capInfoPage = modelData.modInfoPage
        }
 
        if tableColumn == tableView.tableColumns[0] {
            image =  NSImage(systemSymbolName: capInfoPage.image, accessibilityDescription: nil)!
            text = capInfoPage.name
            cellIdentifier = "NameCellID"
        }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
          cell.imageView?.image = image ?? nil
          return cell
        }
        else {
        return nil
        }
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        let selectedRow = tableView.selectedRow
       
        if selectedRow != -1 {
            detailViewController.createGridView(pageId: selectedRow)
        }
    }
}


