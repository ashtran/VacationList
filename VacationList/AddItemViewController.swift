//
//  AddItemViewController.swift
//  TodoList
//
//  Created by ASHLEY TRAN on 11/15/17.
//  Copyright © 2017 ASHLEY TRAN. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {
    
    var indexPath: NSIndexPath?
    var desc: String?
    var d: Date?
    var alpha: CGFloat?
    weak var delegate: AddItemDelegate?

    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var descArea: UITextView!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var addItemButton: UIButton!

    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.cancelButtonPressed(by:self)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let title = titleLabel.text!
        let desc = descArea.text!
        let d = date.date
            
        delegate?.itemSaved(title, desc, d, at: indexPath, sender: self)
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let title = titleLabel.text!
        let desc = descArea.text!
        let d = date.date
        
        if title != "" && desc != ""{
            delegate?.addItem(title, desc, d, sender: self)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // description styling //
        descArea.layer.borderWidth = 1
        descArea.layer.borderColor = UIColor.lightGray.cgColor
        descArea.layer.cornerRadius = 5
        date.setValue(UIColor(red:0.79, green:0.26, blue:0.45, alpha:1.0), forKey: "textColor")
        
        // fill fields with text if editing (data passed through segue) //
        titleLabel.text = title
        descArea.text = desc
        if d != nil  {
            date.date = d!
        }
        
        // if editing then hide addItem button//
        if alpha != nil{
            addItemButton.alpha = alpha!
        }
        // if not editing, hide savebutton //
        else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
