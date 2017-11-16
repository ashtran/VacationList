//
//  AddItemDelegate.swift
//  TodoList
//
//  Created by ASHLEY TRAN on 11/15/17.
//  Copyright © 2017 ASHLEY TRAN. All rights reserved.
//

import UIKit

protocol AddItemDelegate: class {
    func addItem(_ title: String, _ desc: String, _ date: Date, sender: UIViewController)
    
    func itemSaved (_ title: String,_ desc: String, _ date: Date, at indexPath: NSIndexPath?, sender: UIViewController)
    
    func cancelButtonPressed (by controller: AddItemViewController)
}
